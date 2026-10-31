import 'package:bhashini_core/bhashini_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/safety_theme.dart';
import '../../core/db/safety_database.dart';
import '../../core/services/alert_sync_service.dart';
import '../../core/widgets/freshness_badge.dart';
import '../../core/models/safety_data_point.dart';

/// Emergency Broadcasts Screen — shows live alerts from USGS, NDMA SACHET,
/// and OpenAQ, pulled and cached by [AlertSyncService].
///
/// Online: syncs fresh data on load and on pull-to-refresh.
/// Offline: shows cached alerts from the last 72 hours with a staleness banner.
class BroadcastScreen extends StatefulWidget {
  const BroadcastScreen({super.key});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  List<Broadcast> _alerts = [];
  bool _isLoading = true;
  bool _isSyncing = false;
  String? _errorMessage;
  DateTime? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    _loadAndSync();
  }

  /// Load cached alerts from DB, then sync fresh data in background.
  Future<void> _loadAndSync() async {
    setState(() => _isLoading = true);

    // 1. Show cached data immediately so the screen is never empty.
    final cached = await AlertSyncService.getAlerts();
    _lastSyncTime = await AlertSyncService.getLastSyncTime();
    if (mounted) {
      setState(() {
        _alerts = cached;
        _isLoading = false;
      });
    }

    // 2. Fetch fresh data from all live sources.
    await _doSync();
  }

  Future<void> _doSync() async {
    if (_isSyncing) return;
    if (mounted) setState(() => _isSyncing = true);

    try {
      double lat = 0, lon = 0;
      try {
        // Try to get GPS for proximity-filtered results.
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        ).timeout(const Duration(seconds: 5));
        lat = pos.latitude;
        lon = pos.longitude;
      } catch (_) {
        // Location unavailable — sync globally (NDMA + all-region USGS).
      }

      await AlertSyncService.sync(userLat: lat, userLon: lon);
      final fresh = await AlertSyncService.getAlerts();
      _lastSyncTime = await AlertSyncService.getLastSyncTime();

      if (mounted) {
        setState(() {
          _alerts = fresh;
          _isSyncing = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _errorMessage = 'Could not reach alert servers. Showing cached data.';
        });
      }
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Color _severityColor(String severity) {
    switch (severity) {
      case 'CRITICAL':
        return SafetyTheme.primaryRed;
      case 'WARNING':
        return SafetyTheme.warningOrange;
      default:
        return const Color(0xFF2563EB);
    }
  }

  IconData _severityIcon(String severity) {
    switch (severity) {
      case 'CRITICAL':
        return Icons.warning_amber_rounded;
      case 'WARNING':
        return Icons.error_outline;
      default:
        return Icons.info_outline;
    }
  }

  String _sourceLabel(String source) {
    switch (source) {
      case 'USGS':
        return '🌍 USGS Earthquake Hazards';
      case 'NDMA SACHET':
        return '🇮🇳 NDMA SACHET';
      case 'OpenAQ':
        return '💨 OpenAQ Air Quality';
      default:
        return source;
    }
  }

  UpdateFrequency _sourceFrequency(String source) {
    switch (source) {
      case 'USGS':
      case 'NDMA SACHET':
        return UpdateFrequency.realTime;
      case 'OpenAQ':
        return UpdateFrequency.hourly;
      default:
        return UpdateFrequency.unknown;
    }
  }

  bool get _isStale {
    if (_lastSyncTime == null) return false;
    return DateTime.now().difference(_lastSyncTime!) > const Duration(hours: 1);
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SafetyTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: GlobalBhashiniText(
          'Emergency Broadcasts',
          style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold, color: SafetyTheme.textDark),
        ),
        actions: [
          if (_isSyncing)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _doSync,
              child: Column(
                children: [
                  // ── Offline / stale banner ──────────────────────────────
                  if (_isStale || _errorMessage != null)
                    _buildStaleBanner(),

                  // ── Source attribution row ──────────────────────────────
                  _buildSourceRow(),

                  // ── Alert list ─────────────────────────────────────────
                  Expanded(
                    child: _alerts.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount: _alerts.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) =>
                                _buildAlertCard(_alerts[index]),
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStaleBanner() {
    final msg = _errorMessage ??
        (_lastSyncTime != null
            ? 'Cached data · Last synced ${_formatAge(_lastSyncTime!)}'
            : 'Showing offline data');
    return Container(
      color: Colors.amber.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, size: 14, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: GlobalBhashiniText(
              msg,
              style: GoogleFonts.inter(
                  fontSize: 11, color: Colors.orange.shade900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.verified, size: 14, color: Colors.green),
          const SizedBox(width: 6),
          Expanded(
            child: GlobalBhashiniText(
              'Sources: USGS · NDMA SACHET · OpenAQ',
              style: GoogleFonts.inter(
                  fontSize: 11, color: Colors.grey.shade600),
            ),
          ),
          if (_lastSyncTime != null)
            GlobalBhashiniText(
              'Checked ${_formatAge(_lastSyncTime!)}',
              style: GoogleFonts.inter(
                  fontSize: 10, color: Colors.grey.shade500),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline,
              size: 48, color: Colors.green.shade400),
          const SizedBox(height: 12),
          GlobalBhashiniText(
            'No active alerts in your region',
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: SafetyTheme.textDark),
          ),
          const SizedBox(height: 4),
          GlobalBhashiniText(
            _lastSyncTime != null
                ? 'Last checked: ${_formatAge(_lastSyncTime!)}'
                : 'Pull down to check for alerts',
            style: GoogleFonts.inter(
                fontSize: 12, color: SafetyTheme.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Broadcast alert) {
    final observedAt = alert.observedAt > 0
        ? DateTime.fromMillisecondsSinceEpoch(alert.observedAt)
        : alert.timestamp;
    final color = _severityColor(alert.severity);
    final freq = _sourceFrequency(alert.source);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: SafetyTheme.cardShadow,
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Severity icon ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_severityIcon(alert.severity), color: color, size: 24),
          ),
          const SizedBox(width: 16),
          // ── Content ───────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Severity chip + time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: GlobalBhashiniText(
                        alert.severity,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    GlobalBhashiniText(
                      _formatAge(observedAt),
                      style: GoogleFonts.inter(
                          color: SafetyTheme.textGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Title
                GlobalBhashiniText(
                  alert.title,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: SafetyTheme.textDark),
                ),
                const SizedBox(height: 4),
                // Message (truncated)
                GlobalBhashiniText(
                  alert.message.length > 120
                      ? '${alert.message.substring(0, 117)}…'
                      : alert.message,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: SafetyTheme.textGrey,
                      height: 1.4),
                ),
                const SizedBox(height: 8),
                // ── Freshness badge ───────────────────────────────────
                FreshnessBadge(
                  source: _sourceLabel(alert.source),
                  observedAt: observedAt,
                  frequency: freq,
                  isOffline: _isStale,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAge(DateTime dt) {
    final age = DateTime.now().difference(dt);
    if (age.inMinutes < 1) return 'just now';
    if (age.inMinutes < 60) return '${age.inMinutes} min ago';
    if (age.inHours < 24) return '${age.inHours}h ago';
    return '${age.inDays}d ago';
  }
}

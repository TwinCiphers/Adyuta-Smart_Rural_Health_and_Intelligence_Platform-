import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/theme/safety_theme.dart';
import '../../core/db/safety_database.dart';

class BroadcastScreen extends StatefulWidget {
  const BroadcastScreen({super.key});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  final SafetyDatabase _db = SafetyDatabase();
  List<Broadcast> _broadcasts = [];

  @override
  void initState() {
    super.initState();
    _loadBroadcasts();
  }

  Future<void> _loadBroadcasts() async {
    final broadcasts = await _db.getAllBroadcasts();
    setState(() {
      _broadcasts = broadcasts;
    });
  }

  Future<void> _addAdminBroadcast() async {
    await _db.insertBroadcast(BroadcastsCompanion(
      title: drift.Value('Admin: Flash Flood Alert'),
      message: drift.Value('Real-time alert generated from Admin UI. Avoid coastal roads immediately.'),
      severity: drift.Value('CRITICAL'),
      timestamp: drift.Value(DateTime.now()),
    ));
    _loadBroadcasts();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Real broadcast injected into local database!'), backgroundColor: Colors.green));
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'CRITICAL':
        return SafetyTheme.primaryRed;
      case 'WARNING':
        return SafetyTheme.warningOrange;
      default:
        return const Color(0xFF2563EB); // Blue for INFO
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity) {
      case 'CRITICAL':
        return Icons.warning_amber_rounded;
      case 'WARNING':
        return Icons.error_outline;
      default:
        return Icons.info_outline;
    }
  }

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
        title: Text(
          'Emergency Broadcasts',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: SafetyTheme.textDark),
        ),
      ),
      body: _broadcasts.isEmpty
          ? Center(
              child: Text(
                'No active broadcasts in your area.',
                style: GoogleFonts.inter(color: SafetyTheme.textGrey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _broadcasts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                // Reverse list to show newest first
                final alert = _broadcasts[_broadcasts.length - 1 - index];
                final severityStr = alert.severity;
                final color = _getSeverityColor(severityStr);

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
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_getSeverityIcon(severityStr), color: color, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    severityStr,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\${alert.timestamp.hour}:\${alert.timestamp.minute.toString().padLeft(2, "0")}',
                                  style: GoogleFonts.inter(color: SafetyTheme.textGrey, fontSize: 11, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              alert.title,
                              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15, color: SafetyTheme.textDark),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alert.message,
                              style: GoogleFonts.inter(fontSize: 13, color: SafetyTheme.textGrey, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAdminBroadcast,
        backgroundColor: SafetyTheme.primaryRed,
        icon: const Icon(Icons.add_alert, color: Colors.white),
        label: Text('Admin Broadcast', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

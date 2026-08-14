import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_module/core/theme/app_theme.dart';
import 'package:health_module/core/widgets/soft_background_layout.dart';
import '../providers/directory_provider.dart';
import 'facility_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:geolocator/geolocator.dart';

class DirectoryScreen extends ConsumerStatefulWidget {
  const DirectoryScreen({super.key});

  @override
  ConsumerState<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends ConsumerState<DirectoryScreen> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(mounted) {
      setState(() {
        _currentPosition = position;
      });
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(directorySearchQueryProvider);

    return SoftBackgroundLayout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Local Health Directory',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                'Find PHCs, CHCs, and hospitals near you.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.softShadow,
                ),
                child: TextField(
                  onChanged: (val) {
                    ref.read(directorySearchQueryProvider.notifier).state = val;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search by village, taluk, or facility...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              if (searchQuery.isNotEmpty) ...[
                ref.watch(searchFacilitiesProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error: $err'),
                  data: (results) {
                    if (results.isEmpty) return const Text('No facilities found.');
                    return Column(
                      children: results.map((fac) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FacilityDetailScreen(facility: fac))),
                          child: _buildFacilityCard(
                            context, 
                            fac.name, 
                            '${fac.type} • ${fac.address}', 
                            Icons.local_hospital,
                            fac.phone ?? ''
                          ),
                        ),
                      )).toList(),
                    );
                  }
                ),
              ],
              
              if (searchQuery.isEmpty) ...[
                Text('Nearby Facilities', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 12),
                ref.watch(facilitiesProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error loading directory: $err'),
                  data: (facilities) {
                    if (facilities.isEmpty) return const Text('No facilities found.');
                    return Column(
                      children: facilities.map((fac) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FacilityDetailScreen(facility: fac))),
                          child: _buildFacilityCard(
                            context, 
                            fac.name, 
                            '${fac.type} • ${fac.address}', 
                            Icons.local_hospital,
                            fac.phone ?? ''
                          ),
                        ),
                      )).toList(),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                Text('Local Helpers (ASHA/Anganwadi)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                const SizedBox(height: 12),
                ref.watch(localHelpersProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error loading helpers: $err'),
                  data: (helpers) {
                    if (helpers.isEmpty) return const Text('No helpers found.');
                    return Column(
                      children: helpers.map((h) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildHelperCard(context, h.name, '${h.helperType} • ${h.village}', h.phone),
                      )).toList(),
                    );
                  },
                ),
              ],
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFacilityCard(BuildContext context, String name, String details, IconData icon, String phone) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.blue[700], size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(details, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.directions, color: AppTheme.primaryColor, size: 18),
                label: const Text('Directions', style: TextStyle(color: AppTheme.primaryColor)),
              ),
              if (phone.isNotEmpty)
                TextButton.icon(
                  onPressed: () => _makePhoneCall(phone),
                  icon: const Icon(Icons.call, color: AppTheme.primaryColor, size: 18),
                  label: const Text('Call', style: TextStyle(color: AppTheme.primaryColor)),
                )
            ],
          )
        ],
      ),
    );
  }
  
  Widget _buildHelperCard(BuildContext context, String name, String details, String phone) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: Colors.green[700], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(details, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _makePhoneCall(phone),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.call, color: Colors.green[800], size: 20),
            )
          ),
        ],
      ),
    );
  }
}

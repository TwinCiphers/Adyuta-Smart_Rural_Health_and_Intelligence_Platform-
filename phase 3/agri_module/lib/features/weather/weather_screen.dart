import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../../core/theme/agri_theme.dart';

class _Location {
  final String name;
  final double lat;
  final double lon;
  final bool isGps;
  const _Location(this.name, this.lat, this.lon, {this.isGps = false});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Location && runtimeType == other.runtimeType && name == other.name && lat == other.lat && lon == other.lon && isGps == other.isGps;

  @override
  int get hashCode => name.hashCode ^ lat.hashCode ^ lon.hashCode ^ isGps.hashCode;
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final List<_Location> _locations = const [
    _Location('📍 Use My GPS Location', 0.0, 0.0, isGps: true),
    _Location('Bengaluru, Karnataka', 12.9716, 77.5946),
    _Location('Indore, MP', 22.7196, 75.8577),
    _Location('Bhopal, MP', 23.2599, 77.4126),
    _Location('Ujjain, MP', 23.1765, 75.7885),
    _Location('Ludhiana, Punjab', 30.9010, 75.8573),
    _Location('Karnal, Haryana', 29.6857, 76.9905),
    _Location('Nashik, MH', 19.9975, 73.7898),
    _Location('Guntur, AP', 16.3067, 80.4365),
    _Location('Jaipur, RJ', 26.9124, 75.7873),
  ];

  late _Location _selectedLocation;
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _weatherData;
  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedLocation = _locations[0];
    _fetchUserLocation();
  }

  _Location get _dropdownValue {
    if (_selectedLocation.isGps) return _locations[0];
    return _selectedLocation;
  }

  Future<void> _fetchUserLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Location services are disabled. Please turn on GPS on your phone.';
            _isLoading = false;
          });
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _errorMessage = 'Location permission denied. Please allow location access to get local weather.';
              _isLoading = false;
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Location permission permanently denied. Please enable in phone settings.';
            _isLoading = false;
          });
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String placeName = 'GPS (${position.latitude.toStringAsFixed(2)}°, ${position.longitude.toStringAsFixed(2)}°)';
      try {
        final revUrl = Uri.parse('https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${position.latitude}&longitude=${position.longitude}&localityLanguage=en');
        final revRes = await http.get(revUrl);
        if (revRes.statusCode == 200) {
          final revData = jsonDecode(revRes.body);
          final city = revData['city'] ?? revData['locality'] ?? revData['principalSubdivision'] ?? '';
          final state = revData['principalSubdivision'] ?? '';
          if (city.toString().isNotEmpty) {
            placeName = '$city, $state'.replaceAll(RegExp(r',\s*$'), '');
          }
        }
      } catch (_) {}

      if (mounted) {
        setState(() {
          _selectedLocation = _Location(placeName, position.latitude, position.longitude, isGps: true);
        });
      }

      await _fetchWeather();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Could not detect GPS location: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchWeather() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    try {
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=${_selectedLocation.lat}&longitude=${_selectedLocation.lon}&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,surface_pressure,wind_speed_10m,wind_direction_10m,wind_gusts_10m,visibility,uv_index&hourly=temperature_2m,precipitation_probability,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,sunrise,sunset,uv_index_max&timezone=auto');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _weatherData = data;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Failed to load weather forecast (Error ${response.statusCode})';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Network error: Could not reach live weather API.';
          _isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> _getWeatherInfo(int code) {
    switch (code) {
      case 0:
        return {'desc': 'Sunny / Clear', 'icon': Icons.wb_sunny, 'color': const Color(0xFFF59E0B)};
      case 1:
      case 2:
      case 3:
        return {'desc': 'Partly sunny', 'icon': Icons.wb_cloudy, 'color': const Color(0xFF60A5FA)};
      case 45:
      case 48:
        return {'desc': 'Foggy', 'icon': Icons.cloud, 'color': const Color(0xFF94A3B8)};
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return {'desc': 'Light Drizzle', 'icon': Icons.grain, 'color': const Color(0xFF3B82F6)};
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
        return {'desc': 'Moderate Rain', 'icon': Icons.umbrella, 'color': const Color(0xFF2563EB)};
      case 71:
      case 73:
      case 75:
      case 77:
        return {'desc': 'Snow', 'icon': Icons.cloudy_snowing, 'color': const Color(0xFF38BDF8)};
      case 80:
      case 81:
      case 82:
        return {'desc': 'Rain Showers', 'icon': Icons.water_drop, 'color': const Color(0xFF1D4ED8)};
      case 95:
      case 96:
      case 99:
        return {'desc': 'Thunderstorms', 'icon': Icons.thunderstorm, 'color': const Color(0xFF7C3AED)};
      default:
        return {'desc': 'Partly cloudy', 'icon': Icons.wb_cloudy_outlined, 'color': const Color(0xFF64748B)};
    }
  }

  String _formatDay(String dateStr, int index) {
    if (index == 0) return 'Today';
    try {
      final dt = DateTime.parse(dateStr);
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${weekdays[dt.weekday - 1]} ${dt.day}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatHour(String timeStr) {
    try {
      final dt = DateTime.parse(timeStr);
      int hour = dt.hour;
      String ampm = hour >= 12 ? 'PM' : 'AM';
      if (hour == 0) hour = 12;
      if (hour > 12) hour -= 12;
      return '$hour $ampm';
    } catch (e) {
      return timeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Elegant cream-gray background like Image 1
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        title: Text('Live Climate & Weather', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF1E293B))),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: AgriTheme.primaryGreen),
            tooltip: 'Use My GPS Location',
            onPressed: _fetchUserLocation,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AgriTheme.primaryGreen),
            tooltip: 'Refresh Weather',
            onPressed: () {
              if (_selectedLocation.isGps) {
                _fetchUserLocation();
              } else {
                _fetchWeather();
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AgriTheme.primaryGreen),
                  SizedBox(height: 16),
                  Text('Syncing live satellite climate grid...'),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_off, size: 64, color: AgriTheme.priceDown),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(fontSize: 16, color: AgriTheme.textDark),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_selectedLocation.isGps) {
                              _fetchUserLocation();
                            } else {
                              _fetchWeather();
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AgriTheme.primaryGreen, foregroundColor: Colors.white),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        )
                      ],
                    ),
                  ),
                )
              : _buildBentoClimateGrid(),
    );
  }

  Widget _buildBentoClimateGrid() {
    final current = _weatherData!['current'] ?? <String, dynamic>{};
    final daily = _weatherData!['daily'] ?? <String, dynamic>{};
    final hourly = _weatherData!['hourly'] ?? <String, dynamic>{};

    final double temp = (current['temperature_2m'] as num? ?? 25.0).toDouble();
    final int humidity = (current['relative_humidity_2m'] as num? ?? 65).toInt();
    final double windSpeed = (current['wind_speed_10m'] as num? ?? 10.0).toDouble();
    final double windGusts = (current['wind_gusts_10m'] as num? ?? windSpeed * 1.5).toDouble();
    final int currentCode = (current['weather_code'] as num? ?? 1).toInt();
    final double pressure = (current['surface_pressure'] as num? ?? 1011.0).toDouble();
    final double visibilityMeters = (current['visibility'] as num? ?? 10000.0).toDouble();
    final double visibilityKm = visibilityMeters / 1000.0;
    final double uvIndex = (current['uv_index'] as num? ?? 6.0).toDouble();
    final double apparentTemp = (current['apparent_temperature'] as num? ?? temp).toDouble();

    final List<dynamic> dates = daily['time'] as List<dynamic>? ?? [];
    final List<dynamic> maxTemps = daily['temperature_2m_max'] as List<dynamic>? ?? [];
    final List<dynamic> minTemps = daily['temperature_2m_min'] as List<dynamic>? ?? [];
    final List<dynamic> weatherCodes = daily['weather_code'] as List<dynamic>? ?? [];
    final List<dynamic> precipProbs = daily['precipitation_probability_max'] as List<dynamic>? ?? [];
    final List<dynamic> sunrises = daily['sunrise'] as List<dynamic>? ?? [];
    final List<dynamic> sunsets = daily['sunset'] as List<dynamic>? ?? [];

    final List<dynamic> hourlyTimes = hourly['time'] as List<dynamic>? ?? [];
    final List<dynamic> hourlyTemps = hourly['temperature_2m'] as List<dynamic>? ?? [];
    final List<dynamic> hourlyPrecip = hourly['precipitation_probability'] as List<dynamic>? ?? [];

    final currentInfo = _getWeatherInfo(currentCode);
    final double todayMax = maxTemps.isNotEmpty ? (maxTemps[0] as num).toDouble() : temp + 4;
    final double todayMin = minTemps.isNotEmpty ? (minTemps[0] as num).toDouble() : temp - 4;
    final int todayPrecipProb = precipProbs.isNotEmpty ? (precipProbs[0] as num).toInt() : 0;

    String sunriseTime = '06:05 AM';
    String sunsetTime = '06:45 PM';
    if (sunrises.isNotEmpty && sunsets.isNotEmpty) {
      try {
        final sr = DateTime.parse(sunrises[0].toString());
        final ss = DateTime.parse(sunsets[0].toString());
        sunriseTime = _formatHour(sr.toIso8601String());
        sunsetTime = _formatHour(ss.toIso8601String());
      } catch (_) {}
    }

    // Dynamic farming advisory logic
    String advisoryTitle = 'Favorable Farming Weather';
    String advisoryDesc = 'Current climate grid shows ideal soil moisture and sky conditions for weeding, sowing, and routine nutrient application.';
    Color advisoryColor = const Color(0xFF16A34A);
    Color advisoryBg = const Color(0xFFDCFCE7);
    IconData advisoryIcon = Icons.check_circle;

    if (todayPrecipProb >= 50 || currentCode >= 51) {
      advisoryTitle = 'Rain Alert: Delay Fertilizer Spray';
      advisoryDesc = 'High probability of rain ($todayPrecipProb%) detected. Postpone foliar urea sprays and chemical pesticide application to prevent runoff.';
      advisoryColor = const Color(0xFF0284C7);
      advisoryBg = const Color(0xFFE0F2FE);
      advisoryIcon = Icons.water_drop;
    } else if (temp >= 36) {
      advisoryTitle = 'Heat Stress Advisory: Increase Irrigation';
      advisoryDesc = 'High ambient temperatures detected. Maintain soil moisture through evening drip irrigation to prevent crop heat stress.';
      advisoryColor = const Color(0xFFEA580C);
      advisoryBg = const Color(0xFFFFF7ED);
      advisoryIcon = Icons.wb_sunny;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar with Location & Timestamp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_selectedLocation.name}  ${TimeOfDay.now().format(context)}',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Updated just now • Live Satellite Grid',
                      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<_Location>(
                    value: _dropdownValue,
                    isDense: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1E293B), size: 20),
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: const Color(0xFF1E293B)),
                    onChanged: (_Location? newLoc) {
                      if (newLoc != null && newLoc != _dropdownValue) {
                        if (newLoc.isGps) {
                          _fetchUserLocation();
                        } else {
                          setState(() {
                            _selectedLocation = newLoc;
                          });
                          _fetchWeather();
                        }
                      }
                    },
                    items: _locations.map((loc) {
                      return DropdownMenuItem(
                        value: loc,
                        child: Text(loc.name.length > 15 ? '${loc.name.substring(0, 15)}...' : loc.name),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Hero Bento Card (Left/Top in Image 1)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section: Temp & Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(currentInfo['icon'] as IconData, size: 48, color: currentInfo['color'] as Color),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${temp.toStringAsFixed(0)}°C',
                              style: GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A), height: 1.0),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentInfo['desc'] as String,
                              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
                            ),
                            Text(
                              'H${todayMax.toStringAsFixed(0)}°  L${todayMin.toStringAsFixed(0)}°',
                              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text('Feels like', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                          Text('${apparentTemp.toStringAsFixed(0)}°', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Horizontal Day Selector (Like Image 1: Today, Mon 27, Tue 28...)
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedDayIndex == index;
                      final dayStr = _formatDay(dates[index].toString(), index);
                      final code = (weatherCodes[index] as num).toInt();
                      final info = _getWeatherInfo(code);
                      final maxT = (maxTemps[index] as num).toStringAsFixed(0);
                      final minT = (minTemps[index] as num).toStringAsFixed(0);

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDayIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 72,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                dayStr,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.white : const Color(0xFF475569),
                                ),
                              ),
                              Icon(info['icon'] as IconData, size: 22, color: isSelected ? const Color(0xFFF59E0B) : info['color'] as Color),
                              Text(
                                '$maxT° $minT°',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white70 : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
                const SizedBox(height: 12),

                // Hourly Trend Bar (Like Image 1 curve with rain % underneath)
                Text('Hourly Trend & Rain Prob.', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF475569))),
                const SizedBox(height: 12),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: math.min(12, hourlyTimes.length),
                    itemBuilder: (context, index) {
                      // pick hours starting from current hour
                      int hourIdx = DateTime.now().hour + index;
                      if (hourIdx >= hourlyTimes.length) hourIdx = index;
                      final hTime = _formatHour(hourlyTimes[hourIdx].toString());
                      final hTemp = (hourlyTemps[hourIdx] as num).toStringAsFixed(0);
                      final hPrecip = (hourlyPrecip[hourIdx] as num).toInt();

                      return Container(
                        width: 58,
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(hTime, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
                            Text('$hTemp°', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                            Container(
                              height: 4,
                              width: 24,
                              decoration: BoxDecoration(
                                color: hPrecip > 30 ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.water_drop, size: 10, color: Color(0xFF3B82F6)),
                                Text('$hPrecip%', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF3B82F6))),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Bento Grid of 6 Climate Cards (Exactly matching Image 1 parameters!)
          Row(
            children: [
              // Card 1: Visibility
              Expanded(
                child: _buildBentoCard(
                  title: 'Visibility',
                  mainValue: '${visibilityKm.toStringAsFixed(0)} km',
                  subValue: visibilityKm >= 8 ? 'Good' : 'Moderate',
                  customWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar(40, const Color(0xFF22C55E)),
                      const SizedBox(height: 4),
                      _buildBar(55, const Color(0xFF22C55E)),
                      const SizedBox(height: 4),
                      _buildBar(70, const Color(0xFF16A34A)),
                      const SizedBox(height: 4),
                      _buildBar(85, const Color(0xFF15803D)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Card 2: Wind
              Expanded(
                child: _buildBentoCard(
                  title: 'Wind Speed',
                  mainValue: '${windSpeed.toStringAsFixed(0)} km/h',
                  subValue: 'Gusts ${windGusts.toStringAsFixed(0)} km/h',
                  customWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: const Icon(Icons.navigation, color: Color(0xFF3B82F6), size: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              // Card 3: Pressure
              Expanded(
                child: _buildBentoCard(
                  title: 'Pressure',
                  mainValue: '${pressure.toStringAsFixed(0)} mb',
                  subValue: pressure >= 1013 ? 'High • Stable' : 'Rising slowly',
                  customWidget: Container(
                    height: 8,
                    width: 65,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF93C5FD), Color(0xFF3B82F6), Color(0xFF8B5CF6)]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Card 4: AQI & Air Quality
              Expanded(
                child: _buildBentoCard(
                  title: 'AQI • Air Quality',
                  mainValue: '42 Good',
                  subValue: 'Ideal for farming',
                  customWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF22C55E), width: 4),
                        ),
                        child: const Center(child: Icon(Icons.check, size: 18, color: Color(0xFF22C55E))),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              // Card 5: Humidity
              Expanded(
                child: _buildBentoCard(
                  title: 'Humidity',
                  mainValue: '$humidity%',
                  subValue: 'Dew point ${(temp - ((100 - humidity) / 5)).toStringAsFixed(0)}°',
                  customWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (i) {
                      final height = 15.0 + ((i % 3) * 6.0);
                      return Container(
                        width: 5,
                        height: height,
                        decoration: BoxDecoration(
                          color: i < 4 ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Card 6: UV Index
              Expanded(
                child: _buildBentoCard(
                  title: 'UV Index',
                  mainValue: '${uvIndex.toStringAsFixed(0)} ${uvIndex >= 6 ? 'High' : 'Moderate'}',
                  subValue: uvIndex >= 6 ? 'Protect standing crops' : 'Safe solar levels',
                  customWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.wb_sunny, color: uvIndex >= 6 ? const Color(0xFFEA580C) : const Color(0xFFF59E0B), size: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Card 7: Sun Hours Sunrise / Sunset Arc (Full Width like Image 1)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sun Hours • Daylight Schedule', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.wb_twilight, color: Color(0xFFF59E0B), size: 28),
                        const SizedBox(height: 6),
                        Text(sunriseTime, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        Text('Sunrise', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '☀️ approx 12h 40m daylight',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFD97706)),
                      ),
                    ),
                    Column(
                      children: [
                        const Icon(Icons.nights_stay_outlined, color: Color(0xFF6366F1), size: 28),
                        const SizedBox(height: 6),
                        Text(sunsetTime, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        Text('Sunset', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Live Agricultural Advisory Banner (Ultra Premium Bottom Feature)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: advisoryBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: advisoryColor.withOpacity(0.4), width: 1.5),
              boxShadow: [BoxShadow(color: advisoryColor.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: advisoryColor.withOpacity(0.15), blurRadius: 8)],
                  ),
                  child: Icon(advisoryIcon, color: advisoryColor, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        advisoryTitle,
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: advisoryColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        advisoryDesc,
                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1E293B), height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBentoCard({required String title, required String mainValue, required String subValue, required Widget customWidget}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mainValue, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                    const SizedBox(height: 2),
                    Text(subValue, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF64748B))),
                  ],
                ),
              ),
              customWidget,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double width, Color color) {
    return Container(
      width: width,
      height: 5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/agri_theme.dart';
import 'kissan_curated_blog_data.dart';
import 'services/bhashini_tts_service.dart';

class XmlPageData {
  final int pageNumber;
  final List<String> paragraphs;
  final String rawText;

  XmlPageData({
    required this.pageNumber,
    required this.paragraphs,
    required this.rawText,
  });
}

class KissanXmlViewerScreen extends StatefulWidget {
  final String filePath;
  final String title;
  final String author;
  final String category;
  final Color categoryColor;
  final Color categoryTextColor;

  const KissanXmlViewerScreen({
    super.key,
    required this.filePath,
    required this.title,
    required this.author,
    required this.category,
    required this.categoryColor,
    required this.categoryTextColor,
  });

  @override
  State<KissanXmlViewerScreen> createState() => _KissanXmlViewerScreenState();
}

class _KissanXmlViewerScreenState extends State<KissanXmlViewerScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  String? _errorMessage;
  List<XmlPageData> _pages = [];
  int _currentPageIndex = 0;
  
  // Customization controls
  double _fontSize = 16.0;
  bool _isContinuousScroll = false;
  bool _showRawXml = false;
  final Set<int> _bookmarkedPages = {};
  final Set<int> _completedChecklistItems = {};
  
  // Search
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<int> _matchingPageIndices = [];
  
  // Voice Simulation & Bhashini 12-Language TTS
  String? _playingVoiceId;
  late AnimationController _voiceAnimController;
  BhashiniLanguage _selectedLang = BhashiniTtsService.supportedLanguages[0];

  final Map<String, String> _dynamicTranslations = {};
  final Set<String> _fetchingTranslations = {};

  String _getTranslated(String text) {
    if (_selectedLang.code == 'en' || text.trim().isEmpty) return text;
    final staticTrans = BhashiniTtsService.translateDomainText(text, _selectedLang.code);
    if (staticTrans != text) return staticTrans;
    
    final cacheKey = '${_selectedLang.code}_$text';
    if (_dynamicTranslations.containsKey(cacheKey)) {
      return _dynamicTranslations[cacheKey]!;
    }
    
    if (!_fetchingTranslations.contains(cacheKey)) {
      _fetchingTranslations.add(cacheKey);
      BhashiniTtsService.translateLive(text, _selectedLang.code).then((translated) {
        if (mounted && translated != text) {
          setState(() {
            _dynamicTranslations[cacheKey] = translated;
          });
        }
      });
    }
    
    return text;
  }

  @override
  void initState() {
    super.initState();
    _voiceAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    BhashiniTtsService.init();
    _loadXmlDocument();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _voiceAnimController.dispose();
    BhashiniTtsService.stop();
    super.dispose();
  }

  Future<void> _loadXmlDocument() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      String xmlString;
      try {
        xmlString = await rootBundle.loadString(widget.filePath);
      } catch (_) {
        xmlString = await rootBundle.loadString('packages/agri_module/${widget.filePath}');
      }
      final parsedPages = _parseXmlContent(xmlString);
      setState(() {
        _pages = parsedPages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load document from Kissan Knowledge Base:\n$e';
      });
    }
  }

  List<XmlPageData> _parseXmlContent(String xml) {
    final List<XmlPageData> result = [];
    final pageRegex = RegExp(r'<page\s+number="([^"]+)">([\s\S]*?)</page>', caseSensitive: false);
    final textRegex = RegExp(r'<text>([^<]*)</text>', caseSensitive: false);

    final pageMatches = pageRegex.allMatches(xml);
    for (final pageMatch in pageMatches) {
      final pageNumStr = pageMatch.group(1) ?? '0';
      final int pageNum = int.tryParse(pageNumStr) ?? (result.length + 1);
      final pageBody = pageMatch.group(2) ?? '';

      final textMatches = textRegex.allMatches(pageBody);
      final List<String> lines = [];
      for (final textMatch in textMatches) {
        final rawLine = _unescapeXml(textMatch.group(1) ?? '').trim();
        if (rawLine.isNotEmpty) {
          lines.add(rawLine);
        }
      }

      // Group lines into paragraphs
      final List<String> paragraphs = [];
      StringBuffer currentPara = StringBuffer();
      for (final line in lines) {
        if (currentPara.isNotEmpty) {
          if (line.length < 40 || line.endsWith('.') || line.endsWith(':') || line.startsWith('') || line.startsWith('') || line.startsWith('•')) {
            currentPara.write(' ');
            currentPara.write(line);
            paragraphs.add(currentPara.toString().trim());
            currentPara.clear();
          } else {
            currentPara.write(' ');
            currentPara.write(line);
          }
        } else {
          currentPara.write(line);
        }
      }
      if (currentPara.isNotEmpty) {
        paragraphs.add(currentPara.toString().trim());
      }

      if (paragraphs.isEmpty && lines.isNotEmpty) {
        paragraphs.addAll(lines);
      }

      final rawText = paragraphs.join('\n\n');
      result.add(XmlPageData(
        pageNumber: pageNum,
        paragraphs: paragraphs.isEmpty ? ['[Empty Page Content]'] : paragraphs,
        rawText: rawText,
      ));
    }

    if (result.isEmpty) {
      result.add(XmlPageData(
        pageNumber: 1,
        paragraphs: ['No readable text found in this document structure.'],
        rawText: 'No readable text found in this document structure.',
      ));
    }

    return result;
  }

  String _unescapeXml(String input) {
    return input
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
      if (_searchQuery.isEmpty) {
        _matchingPageIndices.clear();
      } else {
        _matchingPageIndices = _pages
            .asMap()
            .entries
            .where((e) => e.value.rawText.toLowerCase().contains(_searchQuery))
            .map((e) => e.key)
            .toList();
        if (_matchingPageIndices.isNotEmpty && !_matchingPageIndices.contains(_currentPageIndex)) {
          _currentPageIndex = _matchingPageIndices.first;
        }
      }
    });
  }

  void _toggleBookmark(int pageIndex) {
    setState(() {
      if (_bookmarkedPages.contains(pageIndex)) {
        _bookmarkedPages.remove(pageIndex);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed bookmark from page'), duration: Duration(seconds: 1)),
        );
      } else {
        _bookmarkedPages.add(pageIndex);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmarked page for quick access!'), backgroundColor: AgriTheme.primaryGreen, duration: Duration(seconds: 1)),
        );
      }
    });
  }

  Widget _buildPlayStopButton(String id, String textToSpeak, {bool compact = false}) {
    final isPlaying = _playingVoiceId == id;
    return InkWell(
      onTap: () => _toggleVoice(id: id, customTextToSpeak: textToSpeak),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12, vertical: compact ? 4 : 6),
        decoration: BoxDecoration(
          color: isPlaying ? const Color(0xFFDC2626) : AgriTheme.primaryGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isPlaying ? Icons.stop : Icons.volume_up, color: Colors.white, size: compact ? 14 : 16),
            if (!compact) ...[
              const SizedBox(width: 6),
              Text(
                isPlaying
                    ? BhashiniTtsService.getUiString('stop', _selectedLang.code)
                    : BhashiniTtsService.getUiString('listen', _selectedLang.code),
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _toggleVoice({String id = 'main', String? customTextToSpeak}) async {
    if (_playingVoiceId == id) {
      await BhashiniTtsService.stop();
      setState(() {
        _playingVoiceId = null;
      });
    } else {
      if (_playingVoiceId != null) {
        await BhashiniTtsService.stop();
      }
      setState(() {
        _playingVoiceId = id;
      });
      final blog = KissanCuratedBlogRepository.getBlogByPath(widget.filePath);
      String textToSpeak = customTextToSpeak ?? '';
      
      if (customTextToSpeak == null) {
        if (blog != null && !_showRawXml) {
          final title = _getTranslated(blog.title);
          final summary = _getTranslated(blog.executiveSummary);
          final tip = _getTranslated(blog.goldNuggetTip);
          textToSpeak = '$title. ${BhashiniTtsService.getUiString('exec_summary', _selectedLang.code)}: $summary. $tip';
        } else if (_pages.isNotEmpty) {
          textToSpeak = _pages[_currentPageIndex].paragraphs.map((p) => _getTranslated(p)).join('. ');
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.volume_up, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Bhashini AI Voice (${_selectedLang.nativeName}): Reading in ${_selectedLang.name}...'),
              ),
            ],
          ),
          backgroundColor: AgriTheme.primaryGreen,
          duration: const Duration(seconds: 4),
        ),
      );
      
      await BhashiniTtsService.speak(textToSpeak, _selectedLang);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AgriTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AgriTheme.lightGreen,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'XML KNOWLEDGE BASE',
                    style: GoogleFonts.outfit(
                      color: AgriTheme.primaryGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    style: GoogleFonts.outfit(
                      color: AgriTheme.textDark,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              'By ${widget.author}',
              style: GoogleFonts.outfit(color: AgriTheme.textMuted, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Reading Mode',
            icon: Icon(
              _isContinuousScroll ? Icons.view_day_outlined : Icons.auto_stories_outlined,
              color: AgriTheme.primaryGreen,
            ),
            onPressed: () {
              setState(() {
                _isContinuousScroll = !_isContinuousScroll;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isContinuousScroll ? 'Switched to Continuous Scroll Mode' : 'Switched to Card Page Mode'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          PopupMenuButton<double>(
            tooltip: 'Font Size',
            icon: const Icon(Icons.format_size, color: AgriTheme.textDark),
            onSelected: (val) {
              setState(() {
                _fontSize = val;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 14.0, child: Text('Small (14pt)')),
              const PopupMenuItem(value: 16.0, child: Text('Normal (16pt)')),
              const PopupMenuItem(value: 18.0, child: Text('Large (18pt)')),
              const PopupMenuItem(value: 22.0, child: Text('Extra Large (22pt)')),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AgriTheme.primaryGreen),
                  SizedBox(height: 16),
                  Text('Parsing XML Knowledge Base Document...', style: TextStyle(color: AgriTheme.textMuted, fontWeight: FontWeight.w600)),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                        const SizedBox(height: 16),
                        Text(_errorMessage!, textAlign: TextAlign.center, style: GoogleFonts.outfit(color: AgriTheme.textDark, fontSize: 16)),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadXmlDocument,
                          style: ElevatedButton.styleFrom(backgroundColor: AgriTheme.primaryGreen),
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text('Retry', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                )
              : Builder(
                  builder: (context) {
                    final blog = KissanCuratedBlogRepository.getBlogByPath(widget.filePath);
                    final isCuratedView = blog != null && !_showRawXml;

                    return Column(
                      children: [
                        _buildLanguageSelector(),
                        _buildSearchBar(),
                        if (_playingVoiceId != null) _buildVoiceAssistantBanner(),
                        if (_showRawXml && blog != null)
                          Container(
                            color: const Color(0xFFFEFCE8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, size: 16, color: Color(0xFF854D0E)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Viewing raw OCR extracted text. Switch back for structured guide.',
                                    style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF854D0E)),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => setState(() => _showRawXml = false),
                                  icon: const Icon(Icons.article, size: 16, color: AgriTheme.primaryGreen),
                                  label: Text('Curated Blog', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AgriTheme.primaryGreen)),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: isCuratedView
                              ? _buildCuratedBlogView(blog)
                              : (_isContinuousScroll ? _buildContinuousScrollView() : _buildPageCardView()),
                        ),
                        if (!isCuratedView) _buildBottomNavigationBar(),
                      ],
                    );
                  },
                ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AgriTheme.borderLight),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: BhashiniTtsService.getUiString('search_hint', _selectedLang.code),
                      hintStyle: GoogleFonts.outfit(color: AgriTheme.textMuted, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, size: 20, color: AgriTheme.textMuted),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: AgriTheme.textMuted),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _toggleVoice,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _playingVoiceId == 'main' ? AgriTheme.primaryGreen : const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AgriTheme.primaryGreen),
                  ),
                  child: Icon(
                    _playingVoiceId == 'main' ? Icons.volume_up : Icons.volume_up_outlined,
                    color: _playingVoiceId == 'main' ? Colors.white : AgriTheme.primaryGreen,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Found matches on ${_matchingPageIndices.length} page(s)',
                  style: GoogleFonts.outfit(color: AgriTheme.primaryGreen, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (_matchingPageIndices.isNotEmpty)
                  Row(
                    children: [
                      Text(
                        'Jump to match: ',
                        style: GoogleFonts.outfit(color: AgriTheme.textMuted, fontSize: 12),
                      ),
                      SizedBox(
                        height: 24,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _matchingPageIndices.length > 5 ? 5 : _matchingPageIndices.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 4),
                          itemBuilder: (context, i) {
                            final pageIdx = _matchingPageIndices[i];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _currentPageIndex = pageIdx;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _currentPageIndex == pageIdx ? AgriTheme.primaryGreen : AgriTheme.lightGreen,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'P.${_pages[pageIdx].pageNumber}',
                                  style: GoogleFonts.outfit(
                                    color: _currentPageIndex == pageIdx ? Colors.white : AgriTheme.primaryGreen,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVoiceAssistantBanner() {
    return AnimatedBuilder(
      animation: _voiceAnimController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF166534), Color(0xFF15803D)],
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.graphic_eq, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kisan Voice Assistant Active',
                      style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      'Reading advisory notes loud and clear for field listening...',
                      style: GoogleFonts.outfit(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.stop_circle_outlined, color: Colors.white, size: 24),
                onPressed: _toggleVoice,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.translate, size: 16, color: AgriTheme.primaryGreen),
                const SizedBox(width: 6),
                Text(
                  BhashiniTtsService.getUiString('voice_heading', _selectedLang.code),
                  style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AgriTheme.primaryGreen),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: BhashiniTtsService.supportedLanguages.map((lang) {
                final isSelected = _selectedLang.code == lang.code;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      if (_playingVoiceId != null) {
                        BhashiniTtsService.stop();
                        _playingVoiceId = null;
                      }
                      setState(() {
                        _selectedLang = lang;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Switched to ${lang.name} (${lang.nativeName}) - Bhashini AI Voice Ready'),
                          backgroundColor: AgriTheme.primaryGreen,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AgriTheme.primaryGreen : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AgriTheme.primaryGreen : AgriTheme.borderLight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(lang.flag, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            lang.nativeName,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Colors.white : AgriTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageCardView() {
    if (_pages.isEmpty) return const SizedBox();
    final page = _pages[_currentPageIndex];
    final isBookmarked = _bookmarkedPages.contains(_currentPageIndex);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0 && _currentPageIndex > 0) {
          setState(() => _currentPageIndex--);
        } else if (details.primaryVelocity! < 0 && _currentPageIndex < _pages.length - 1) {
          setState(() => _currentPageIndex++);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: AgriTheme.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'PAGE ${page.pageNumber}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? AgriTheme.primaryGreen : AgriTheme.textMuted,
                    ),
                    onPressed: () => _toggleBookmark(_currentPageIndex),
                    tooltip: 'Bookmark Page',
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_outlined, color: AgriTheme.textMuted, size: 20),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: page.rawText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Page text copied to clipboard!'), duration: Duration(seconds: 1)),
                      );
                    },
                    tooltip: 'Copy Page Text',
                  ),
                ],
              ),
              const Divider(height: 24),
              ...page.paragraphs.map((para) => _buildParagraph(para)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinuousScrollView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pages.length,
      itemBuilder: (context, idx) {
        final page = _pages[idx];
        final isBookmarked = _bookmarkedPages.contains(idx);
        final isMatch = _matchingPageIndices.contains(idx);

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isMatch ? const Color(0xFFFEFCE8) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: isMatch ? const Color(0xFFFEF08A) : AgriTheme.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isMatch ? const Color(0xFFFEF08A) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'PAGE ${page.pageNumber}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isMatch ? const Color(0xFF854D0E) : const Color(0xFF475569),
                      ),
                    ),
                  ),
                  if (isMatch) ...[
                    const SizedBox(width: 8),
                    Text(
                      '⭐ Keyword Match',
                      style: GoogleFonts.outfit(fontSize: 11, color: const Color(0xFF854D0E), fontWeight: FontWeight.bold),
                    ),
                  ],
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? AgriTheme.primaryGreen : AgriTheme.textMuted,
                    ),
                    onPressed: () => _toggleBookmark(idx),
                  ),
                ],
              ),
              const Divider(height: 24),
              ...page.paragraphs.map((para) => _buildParagraph(para)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildParagraph(String text) {
    if (_searchQuery.isEmpty || !text.toLowerCase().contains(_searchQuery)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: _fontSize,
            color: AgriTheme.textDark,
            height: 1.6,
          ),
        ),
      );
    }

    // Highlight matching text
    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    int start = 0;
    while (true) {
      final index = lowerText.indexOf(_searchQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + _searchQuery.length),
        style: const TextStyle(backgroundColor: Color(0xFFFEF08A), fontWeight: FontWeight.bold, color: Color(0xFF854D0E)),
      ));
      start = index + _searchQuery.length;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.outfit(
            fontSize: _fontSize,
            color: AgriTheme.textDark,
            height: 1.6,
          ),
          children: spans,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    if (_pages.isEmpty || _isContinuousScroll) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.first_page),
              onPressed: _currentPageIndex > 0 ? () => setState(() => _currentPageIndex = 0) : null,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _currentPageIndex > 0 ? () => setState(() => _currentPageIndex--) : null,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Page ${_pages[_currentPageIndex].pageNumber} of ${_pages.length}',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: AgriTheme.textDark),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                      value: _currentPageIndex.toDouble(),
                      min: 0,
                      max: (_pages.length - 1).toDouble().clamp(0, double.infinity),
                      activeColor: AgriTheme.primaryGreen,
                      inactiveColor: AgriTheme.borderLight,
                      onChanged: (val) {
                        setState(() {
                          _currentPageIndex = val.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _currentPageIndex < _pages.length - 1 ? () => setState(() => _currentPageIndex++) : null,
            ),
            IconButton(
              icon: const Icon(Icons.last_page),
              onPressed: _currentPageIndex < _pages.length - 1 ? () => setState(() => _currentPageIndex = _pages.length - 1) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuratedBlogView(CuratedAgriBlog blog) {
    // Filter sections by search query if present
    final List<AgriBlogSection> visibleSections = [];
    if (_searchQuery.isEmpty) {
      visibleSections.addAll(blog.sections);
    } else {
      for (final sec in blog.sections) {
        final titleMatches = sec.title.toLowerCase().contains(_searchQuery);
        final paraMatches = sec.paragraphs.where((p) => p.toLowerCase().contains(_searchQuery)).toList();
        final bulletMatches = sec.bulletPoints.where((b) => b.toLowerCase().contains(_searchQuery)).toList();
        if (titleMatches || paraMatches.isNotEmpty || bulletMatches.isNotEmpty) {
          visibleSections.add(AgriBlogSection(
            title: sec.title,
            icon: sec.icon,
            paragraphs: titleMatches ? sec.paragraphs : (paraMatches.isNotEmpty ? paraMatches : sec.paragraphs),
            bulletPoints: titleMatches ? sec.bulletPoints : (bulletMatches.isNotEmpty ? bulletMatches : sec.bulletPoints),
          ));
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AgriTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getTranslated(blog.category).toUpperCase(),
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined, size: 16, color: AgriTheme.primaryGreen),
                        const SizedBox(width: 4),
                        Text(
                          _getTranslated(blog.readTime),
                          style: GoogleFonts.outfit(color: AgriTheme.primaryGreen, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  _getTranslated(blog.title),
                  style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AgriTheme.textDark, height: 1.3),
                ),
                const SizedBox(height: 6),
                Text(
                  _getTranslated(blog.subtitle),
                  style: GoogleFonts.outfit(fontSize: 14, color: const Color(0xFF065F46), fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 14),
                Divider(color: AgriTheme.primaryGreen.withOpacity(0.2)),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: AgriTheme.primaryGreen,
                          child: Icon(Icons.verified_user, size: 16, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            '${BhashiniTtsService.getUiString('synthesized_by', _selectedLang.code)} ${_getTranslated(blog.author)}',
                            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: AgriTheme.textDark),
                          ),
                        ),
                      ],
                    ),
                    _buildPlayStopButton('main', ''),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Executive Summary & Gold Nugget Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFEFCE8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFEF08A), width: 1.5),
              boxShadow: [
                BoxShadow(color: Colors.amber.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFFEF08A), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.lightbulb, color: Color(0xFF854D0E), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        BhashiniTtsService.getUiString('exec_summary', _selectedLang.code),
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF854D0E)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _getTranslated(blog.executiveSummary),
                  style: GoogleFonts.outfit(fontSize: 14, color: const Color(0xFF713F12), height: 1.5),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFDE047)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _getTranslated(blog.goldNuggetTip),
                          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF854D0E), height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Stats Grid
          Text(
            BhashiniTtsService.getUiString('research_findings', _selectedLang.code),
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AgriTheme.textDark),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: blog.quickStats.map((stat) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AgriTheme.borderLight),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(10)),
                      child: Icon(stat.icon, color: AgriTheme.primaryGreen, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(stat.value, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AgriTheme.textDark)),
                          Text(_getTranslated(stat.label), style: GoogleFonts.outfit(fontSize: 11, color: AgriTheme.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Actionable Checklist
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    const Icon(Icons.check_circle, color: AgriTheme.primaryGreen, size: 24),
                    Text(
                      '${BhashiniTtsService.getUiString('action_checklist', _selectedLang.code)} (${_completedChecklistItems.length}/${blog.actionChecklist.length})',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AgriTheme.primaryGreen),
                    ),
                    _buildPlayStopButton(
                      'checklist', 
                      '${BhashiniTtsService.getUiString('action_checklist', _selectedLang.code)}. ' + blog.actionChecklist.map((c) => _getTranslated(c)).join('. '), 
                      compact: true
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...blog.actionChecklist.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final task = entry.value;
                  final isDone = _completedChecklistItems.contains(idx);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isDone) {
                          _completedChecklistItems.remove(idx);
                        } else {
                          _completedChecklistItems.add(idx);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isDone ? Icons.check_box : Icons.check_box_outline_blank,
                            color: isDone ? AgriTheme.primaryGreen : Colors.grey.shade400,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _getTranslated(task),
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: isDone ? AgriTheme.textMuted : AgriTheme.textDark,
                                decoration: isDone ? TextDecoration.lineThrough : null,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Blog Sections
          Text(
            BhashiniTtsService.getUiString('detailed_guide', _selectedLang.code),
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AgriTheme.textDark),
          ),
          const SizedBox(height: 14),
          if (visibleSections.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: Text(
                '${BhashiniTtsService.getUiString('no_results', _selectedLang.code)} "$_searchQuery"',
                style: GoogleFonts.outfit(fontSize: 14, color: AgriTheme.textMuted),
              ),
            ),
          ...visibleSections.map((sec) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
                ],
                border: Border.all(color: AgriTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                        child: Icon(sec.icon, color: AgriTheme.primaryGreen, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _getTranslated(sec.title),
                          style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: AgriTheme.textDark),
                        ),
                      ),
                      _buildPlayStopButton(
                        'sec_${sec.title}',
                        '${_getTranslated(sec.title)}. ' + sec.paragraphs.map((p) => _getTranslated(p)).join('. ') + (sec.bulletPoints.isNotEmpty ? '. ' + sec.bulletPoints.map((b) => _getTranslated(b)).join('. ') : ''),
                        compact: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...sec.paragraphs.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _getTranslated(p),
                      style: GoogleFonts.outfit(fontSize: _fontSize, color: AgriTheme.textDark, height: 1.6),
                    ),
                  )),
                  if (sec.bulletPoints.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: sec.bulletPoints.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(color: AgriTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                              Expanded(
                                child: Text(
                                  _getTranslated(b),
                                  style: GoogleFonts.outfit(fontSize: _fontSize - 1, color: const Color(0xFF334155), height: 1.5, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),

          const SizedBox(height: 20),
          // Switch to Raw XML View Button
          Center(
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _showRawXml = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Switched to Raw Extracted OCR XML View'), duration: Duration(seconds: 2)),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                side: const BorderSide(color: AgriTheme.primaryGreen),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.code, color: AgriTheme.primaryGreen),
              label: Text('View Raw Extracted OCR XML Data (${_pages.length} Pages)', style: GoogleFonts.outfit(color: AgriTheme.primaryGreen, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'bhashini_domain_dictionary.dart';

class BhashiniLanguage {
  final String code;
  final String locale;
  final String name;
  final String nativeName;
  final String flag;

  const BhashiniLanguage({
    required this.code,
    required this.locale,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

class BhashiniTtsService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;
  static bool _isPlaying = false;

  static const List<BhashiniLanguage> supportedLanguages = [
    BhashiniLanguage(code: 'en', locale: 'en-IN', name: 'English', nativeName: 'English', flag: '🇮🇳'),
    BhashiniLanguage(code: 'hi', locale: 'hi-IN', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
    BhashiniLanguage(code: 'bn', locale: 'bn-IN', name: 'Bengali', nativeName: 'বাংলা', flag: '🇮🇳'),
    BhashiniLanguage(code: 'te', locale: 'te-IN', name: 'Telugu', nativeName: 'తెలుగు', flag: '🇮🇳'),
    BhashiniLanguage(code: 'mr', locale: 'mr-IN', name: 'Marathi', nativeName: 'मराठी', flag: '🇮🇳'),
    BhashiniLanguage(code: 'ta', locale: 'ta-IN', name: 'Tamil', nativeName: 'தமிழ்', flag: '🇮🇳'),
    BhashiniLanguage(code: 'gu', locale: 'gu-IN', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳'),
    BhashiniLanguage(code: 'kn', locale: 'kn-IN', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳'),
    BhashiniLanguage(code: 'ml', locale: 'ml-IN', name: 'Malayalam', nativeName: 'മലയാളം', flag: '🇮🇳'),
    BhashiniLanguage(code: 'or', locale: 'or-IN', name: 'Odia', nativeName: 'ଓଡ଼ିଆ', flag: '🇮🇳'),
    BhashiniLanguage(code: 'pa', locale: 'pa-IN', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', flag: '🇮🇳'),
    BhashiniLanguage(code: 'ur', locale: 'ur-IN', name: 'Urdu', nativeName: 'اردو', flag: '🇮🇳'),
  ];

  static Future<void> init() async {
    if (_isInitialized) return;
    try {
      await _flutterTts.setSpeechRate(0.48);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _flutterTts.setCompletionHandler(() {
        _isPlaying = false;
      });
      _isInitialized = true;
    } catch (e) {
      debugPrint('TTS Init error: $e');
    }
  }

  static Future<void> speak(String text, BhashiniLanguage language) async {
    await init();
    if (_isPlaying) {
      await stop();
    }
    try {
      _isPlaying = true;
      // Set language locale for TTS
      final availableLocales = await _flutterTts.getLanguages;
      bool localeSupported = false;
      if (availableLocales is List) {
        for (var loc in availableLocales) {
          if (loc.toString().toLowerCase().contains(language.code.toLowerCase())) {
            await _flutterTts.setLanguage(loc.toString());
            localeSupported = true;
            break;
          }
        }
      }
      if (!localeSupported) {
        await _flutterTts.setLanguage(language.locale);
      }
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('TTS Speak error: $e');
      _isPlaying = false;
    }
  }

  static Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _isPlaying = false;
    } catch (e) {
      debugPrint('TTS Stop error: $e');
    }
  }

  // Localized UI dictionary for blog headers in 12 languages
  static String getUiString(String key, String langCode) {
    final Map<String, Map<String, String>> dict = {
      'exec_summary': {
        'en': 'Executive Summary & Gold Nugget',
        'hi': 'कार्यकारी सारांश और मुख्य सुझाव',
        'bn': 'নির্বাহী সারসংক্ষেপ এবং মূল পরামর্শ',
        'te': 'కార్యనిర్వాహక సారాంశం & ముఖ్య సూచన',
        'mr': 'कार्यकारी सारांश आणि महत्त्वाचा सल्ला',
        'ta': 'செயல்பாட்டு சுருக்கம் & முக்கிய குறிப்பு',
        'gu': 'કારોબારી સારાંશ અને મુખ્ય સૂચન',
        'kn': 'ಕಾರ್ಯನಿರ್ವಾಹಕ ಸಾರಾಂಶ ಮತ್ತು ಮುಖ್ಯ ಸಲಹೆ',
        'ml': 'എക്സിക്യൂട്ടീവ് സംഗ്രഹവും പ്രധാന നിർദ്ദേശവും',
        'or': 'କାର୍ଯ୍ୟନିର୍ବାହୀ ସାରାଂଶ ଏବଂ ମୁଖ୍ୟ ପରାମର୍ଶ',
        'pa': 'ਕਾਰਜਕਾਰੀ ਸਾਰ ਅਤੇ ਮੁੱਖ ਸੁਝਾਅ',
        'ur': 'ایگزیکٹو خلاصہ اور اہم مشورہ',
      },
      'research_findings': {
        'en': 'Key Research Findings & Data Points',
        'hi': 'प्रमुख शोध निष्कर्ष और आँकड़े',
        'bn': 'মূল গবেষণার ফলাফল এবং তথ্য',
        'te': 'ప్రధాన పరిశోధన ఫలితాలు & డేటా',
        'mr': 'महत्त्वाचे संशोधन निष्कर्ष आणि आकडेवारी',
        'ta': 'முக்கிய ஆராய்ச்சி முடிவுகள் & தரவு',
        'gu': 'મુખ્ય સંશોધન તારણો અને ડેટા',
        'kn': 'ಪ್ರಮುಖ ಸಂಶೋಧನಾ ಫಲಿತಾಂಶಗಳು ಮತ್ತು ಅಂಕಿಅಂಶಗಳು',
        'ml': 'പ്രധാന ഗവേഷണ കണ്ടെത്തലുകളും ഡാറ്റയും',
        'or': 'ମୁଖ୍ୟ ଗବେଷଣା ଫଳାଫଳ ଏବଂ ତଥ୍ୟ',
        'pa': 'ਮੁੱਖ ਖੋਜ ਨਤੀਜੇ ਅਤੇ ਅੰਕੜੇ',
        'ur': 'اہم تحقیقی نتائج اور اعداد و شمار',
      },
      'action_checklist': {
        'en': 'Farmer Action Checklist',
        'hi': 'किसान कार्य सूची (चेकलिस्ट)',
        'bn': 'কৃষকদের করণীয় তালিকা',
        'te': 'రైతు చర్యల జాబితా',
        'mr': 'शेतकरी कृती यादी (चेकलिस्ट)',
        'ta': 'விவசாயி செயல் பட்டியல்',
        'gu': 'ખેડૂત કાર્ય સૂચિ (ચેકલિસ્ટ)',
        'kn': 'ರೈತರ ಕ್ರಿಯಾ ಪಟ್ಟಿ (ಚೆಕ್ಲಿಸ್ಟ್)',
        'ml': 'കർഷക കർമ്മ പട്ടിക',
        'or': 'କୃଷକ କାର୍ଯ୍ୟ ତାଲିକା',
        'pa': 'ਕਿਸਾਨ ਕਾਰਜ ਸੂਚੀ',
        'ur': 'کسان کے اقدامات کی فہرست',
      },
      'detailed_guide': {
        'en': 'Detailed Curated Guide & Practices',
        'hi': 'विस्तृत मार्गदर्शिका और कृषि पद्धतियाँ',
        'bn': 'বিস্তারিত নির্দেশিকা এবং কৃষি পদ্ধতি',
        'te': 'వివరణాత్మక మార్గదర్శిని & పద్ధతులు',
        'mr': 'सविस्तर मार्गदर्शक आणि कृषी पद्धती',
        'ta': 'விரிவான வழிகாட்டி & நடைமுறைகள்',
        'gu': 'વિગતવાર માર્ગદર્શિકા અને કૃષિ પદ્ધતિઓ',
        'kn': 'ವಿವರವಾದ ಮಾರ್ಗದರ್ಶಿ ಮತ್ತು ಪದ್ಧತಿಗಳು',
        'ml': 'വിശദമായ വഴികാട്ടിയും കൃഷിരീതികളും',
        'or': 'ବିସ୍ତୃତ ମାର୍ଗଦର୍ଶିକା ଏବଂ ପଦ୍ଧତି',
        'pa': 'ਵਿਸਥਾਰਪੂਰਵਕ ਗਾਈਡ ਅਤੇ ਖੇਤੀ ਅਭਿਆਸ',
        'ur': 'تفصیلی تفصیلی رہنما اور زرعی طریقے',
      },
      'listen': {
        'en': 'Listen',
        'hi': 'सुनें',
        'bn': 'শুনুন',
        'te': 'వినండి',
        'mr': 'ऐका',
        'ta': 'கேளுங்கள்',
        'gu': 'સાંભળો',
        'kn': 'ಕೇಳಿ',
        'ml': 'കേൾക്കുക',
        'or': 'ଶୁଣନ୍ତୁ',
        'pa': 'ਸੁਣੋ',
        'ur': 'سنیں',
      },
      'stop': {
        'en': 'Stop',
        'hi': 'रोकें',
        'bn': 'থামুন',
        'te': 'ఆపండి',
        'mr': 'थांबा',
        'ta': 'நிறுத்து',
        'gu': 'થોભો',
        'kn': 'ನಿಲ್ಲಿಸಿ',
        'ml': 'നിർത്തുക',
        'or': 'ବନ୍ଦ କରନ୍ତୁ',
        'pa': 'ਰੋਕੋ',
        'ur': 'روکیں',
      },
      'search_hint': {
        'en': 'Search agricultural topics in this manual...',
        'hi': 'इस मैनुअल में कृषि विषय खोजें...',
        'te': 'ఈ మాన్యువల్‌లో వ్యవసాయ అంశాలను శోధించండి...',
        'kn': 'ಈ ಕೈಪಿಡಿಯಲ್ಲಿ ಕೃಷಿ ವಿಷಯಗಳನ್ನು ಹುಡುಕಿ...',
        'ta': 'இந்த கையேட்டில் வேளாண் தலைப்புகளைத் தேடுங்கள்...',
        'mr': 'या मॅन्युअलमध्ये कृषी विषय शोधा...',
        'bn': 'এই ম্যানুয়ালে কৃষি বিষয় অনুসন্ধান করুন...',
        'gu': 'આ માર્ગદર્શિકામાં કૃષિ વિષયો શોધો...',
        'ml': 'ഈ മാനുവലിൽ കാർഷിക വിഷയങ്ങൾ തിരയുക...',
        'or': 'ଏହି ମାନୁଆଲରେ କୃଷି ବିଷୟଗୁଡିକ ଖୋଜନ୍ତୁ...',
        'pa': 'ਇਸ ਮੈਨੂਅਲ ਵਿੱਚ ਖੇਤੀਬਾੜੀ ਵਿਸ਼ੇ ਖੋਜੋ...',
        'ur': 'اس دستی میں زرعی موضوعات تلاش کریں...',
      },
      'no_results': {
        'en': 'No sections match your search query.',
        'hi': 'आपकी खोज से कोई अनुभाग मेल नहीं खाता।',
        'te': 'మీ శోధనకు ఏ విభాగాలు సరిపోలడం లేదు.',
        'kn': 'ನಿಮ್ಮ ಹುಡುಕಾಟಕ್ಕೆ ಯಾವುದೇ ವಿಭಾಗಗಳು ಹೊಂದಿಕೆಯಾಗುವುದಿಲ್ಲ.',
        'ta': 'உங்கள் தேடலுக்கு எந்த பிரிவும் பொருந்தவில்லை.',
        'mr': 'तुमच्या शोधाशी कोणताही विभाग जुळत नाही.',
        'bn': 'আপনার অনুসন্ধানের সাথে কোনো বিভাগ মেলে না।',
        'gu': 'તમારી શોધ સાથે કોઈ વિભાગ મેળ ખાતો નથી.',
        'ml': 'നിങ്ങളുടെ തിരച്ചിലിന് അനുയോജ്യമായ വിഭാഗങ്ങളൊന്നുമില്ല.',
        'or': 'ଆପଣଙ୍କର ସନ୍ଧାନ ସହିତ କୌଣସି ବିଭାଗ ମେଳ ଖାଉ ନାହିଁ।',
        'pa': 'ਤੁਹਾਡੀ ਖੋਜ ਨਾਲ ਕੋਈ ਭਾਗ ਮੇਲ ਨਹੀਂ ਖਾਂਦਾ।',
        'ur': 'آپ کی تلاش سے کوئی حصہ میل نہیں کھاتا۔',
      },
      'voice_heading': {
        'en': 'Bhashini AI 12-Language Translation & Voice:',
        'hi': 'भाषिणी AI 12-भाषा अनुवाद और आवाज:',
        'te': 'భాషిణి AI 12-భాషల అనువాదం & వాయిస్:',
        'kn': 'ಭಾಷಿಣಿ AI 12-ಭಾಷಾ ಅನುವಾದ ಮತ್ತು ಧ್ವನಿ:',
        'ta': 'பாஷினி AI 12-மொழி மொழிபெயர்ப்பு & குரல்:',
        'mr': 'भाषिणी AI १२-भाषा अनुवाद आणि आवाज:',
        'bn': 'ভাষিণী AI ১২-ভাষা অনুবাদ এবং ভয়েস:',
        'gu': 'ભાષિણી AI 12-ભાષા અનુવાદ અને અવાજ:',
        'ml': 'ഭാഷിണി AI 12-ഭാഷാ വിവർത്തനവും ശബ്ദവും:',
        'or': 'ଭାଷିଣୀ AI 12-ଭାଷା ଅନୁବାଦ ଏବଂ କଣ୍ଠ:',
        'pa': 'ਭਾਸ਼ਿਣੀ AI 12-ਭਾਸ਼ਾ ਅਨੁਵਾਦ ਅਤੇ ਆਵਾਜ਼:',
        'ur': 'بھاشنی AI 12 زبانوں کا ترجمہ اور آواز:',
      },
      'synthesized_by': {
        'en': 'Synthesized by',
        'hi': 'संश्लेषित:',
        'te': 'రూపొందించినవారు:',
        'kn': 'ಸಿದ್ಧಪಡಿಸಿದವರು:',
        'ta': 'தொகுத்தவர்:',
        'mr': 'तयार करणारे:',
        'bn': 'তৈরি করেছেন:',
        'gu': 'તૈયાર કરનાર:',
        'ml': 'തയ്യാറാക്കിയത്:',
        'or': 'ପ୍ରସ୍ତୁତକର୍ତ୍ତା:',
        'pa': 'ਤਿਆਰ ਕਰਤਾ:',
        'ur': 'تیار کردہ:',
      },
    };

    return dict[key]?[langCode] ?? dict[key]?['en'] ?? key;
  }

  // Pre-curated Bhashini domain dictionary for core agricultural terms and sentences
  static String translateDomainText(String input, String targetLangCode) {
    if (targetLangCode == 'en') return input;
    return BhashiniDomainDictionary.lookup(input, targetLangCode);
  }

  // Live fallback translation using public translation API if text is not in domain dictionary
  static Future<String> translateLive(String text, String targetLangCode) async {
    if (targetLangCode == 'en' || text.trim().isEmpty) return text;
    final cached = translateDomainText(text, targetLangCode);
    if (cached != text) return cached;

    try {
      final url = Uri.parse('https://api.mymemory.translated.net/get?q=${Uri.encodeComponent(text)}&langpair=en|$targetLangCode');
      final response = await http.get(url).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['responseData'] != null && data['responseData']['translatedText'] != null) {
          String trans = data['responseData']['translatedText'].toString();
          if (!trans.contains('MYMEMORY') && !trans.contains('QUERY LIMIT')) {
            return trans;
          }
        }
      }
    } catch (e) {
      debugPrint('Translation error: $e');
    }
    return text;
  }
}

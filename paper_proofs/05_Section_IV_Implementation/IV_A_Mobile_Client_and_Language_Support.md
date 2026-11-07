# Proof-of-Work: Section IV-A — Mobile Client and Language Support

**Paper Section:** IV. IMPLEMENTATION — A. Mobile client and language support (Page 3, Column 2)  
**Paper Excerpt:**
> *"Client uses Flutter (Material 3), Riverpod for state and GoRouter for navigation. There's a host app (adyuta_main) which owns the routing, the theme, the global state and the auth. The five domain packages (health, agriculture, governance, education, safety) are all linked via local path dependencies and each compiles independently. There's a shared core package which takes care of the translations. Offline data is in Hive and in SQLite via Drift (six bundled databases in total: hospital directory, first aid, maternal and child health, medicines, nutrition, personal health records). The layouts are all based on a 360 x 800 base design with flutter_screenutil.*
> 
> *The interface is available in 12 languages via offline dictionaries (Bhashini API and dictionary cache for the rest). A refactoring script has moved over 220 hard-coded Text widgets to GlobalBhashiniText and any call that takes longer than 5 seconds falls back to cached or English text. Advisory content and voice support is complete for English, Kannada, Hindi and Tamil. Telugu, Bengali, Gujarati, Punjabi and Malayalam are all detected and answered in English. The safety module runs a foreground service (flutter_background_service) which keeps the tracking and SOS active even when the app is closed. SOS will capture GPS, send an SMS and open the dialer to 112, 108 or 1091."*

---

## 🔬 Claims & Verification Cross-Walk

| Implementation Claim | Repository Code / Proof Artifact | Verified Location |
| :--- | :--- | :--- |
| **1. Flutter Material 3, Riverpod, GoRouter shell** | Central host app managing theme, auth, and routing | [`phase 3/adyuta_main/lib/main.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/adyuta_main/lib/main.dart) |
| **2. Independent package compilation & path linking** | Each module builds independently and links via local path | [`phase 3/adyuta_main/pubspec.yaml`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/adyuta_main/pubspec.yaml) lines 35–45 |
| **3. Six bundled SQLite Drift databases** | Pre-packaged clinical databases embedded in APK assets | [`assets/offline/health/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/assets/offline/health/) (All 6 health databases checked) |
| **4. 360 x 800 ScreenUtil base layout design** | Responsive scaling preventing layout breaks on rural low-cost Android screens | Configured in `adyuta_main` presentation layer using `flutter_screenutil` |
| **5. 12 languages support via Bhashini & dictionaries** | Shared translation package + fallback cache | [`phase 3/bhashini_core/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/bhashini_core) |
| **6. Refactoring of 220+ Text widgets to GlobalBhashiniText** | Automated Python migration script replacing hardcoded text | Root script: [`apply_translation.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/apply_translation.py) and [`add_all_langs.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/add_all_langs.py) |
| **7. 5-second network timeout fallback to cache/English** | Graceful degradation preventing freeze on bad 2G connectivity | Tested in [`tests.md` Table 7.8](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) |
| **8. Background tracking & SOS emergency dispatch** | `flutter_background_service` keeping tracking and SOS active when app is terminated | [`phase 3/safety_module/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/safety_module) and [`safety_database_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/safety_module/test/safety_database_test.dart) |

---

## 💻 Codebase Artifact Links
- **Host App Configuration:** [`phase 3/adyuta_main/pubspec.yaml`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/adyuta_main/pubspec.yaml)
- **Bhashini Localization Package:** [`phase 3/bhashini_core/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/bhashini_core)
- **Translation Automation Scripts:** [`apply_translation.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/apply_translation.py), [`add_all_langs.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/add_all_langs.py)
- **Safety Database Tests:** [`phase 3/safety_module/test/safety_database_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/safety_module/test/safety_database_test.dart)

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 3, Column 2, Section IV-A, following the language support and background service description.  
**LaTeX Footnote Suggestion:**
```latex
\footnote{The Flutter host configuration, Bhashini translation scripts, and Drift database SQLite test suites are documented in \texttt{paper\_proofs/05\_Section\_IV\_Implementation/IV\_A\_Mobile\_Client\_and\_Language\_Support.md}.}
```

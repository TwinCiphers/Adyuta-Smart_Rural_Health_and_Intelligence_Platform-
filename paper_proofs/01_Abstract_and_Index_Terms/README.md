# Proof-of-Work: Abstract & Index Terms

**Paper Section:** Abstract & Index Terms (Page 1, Column 1)  
**Paper Excerpt:**
> *"The work here built ADYUTA as a single-voice, first-offline Android app using Flutter that pulls healthcare, agriculture, safety and a couple other areas together. Learned models stay limited to just the advisory part with retrieval and the on-device leaf classifier while the rest stays deterministic and gets checked by a static audit... Tests on a windows machine and a moto phone all passed except one skip. The classifier hit high accuracy on held out images and search memory dropped sharply from over 170 MB down to under 6..."*
> 
> **Index Terms:** *rural computing, offline-first systems, edge AI, retrieval-augmented generation, voice interfaces, mobile health, Indic languages, ICT for development.*

---

## 🔬 Claims & Verification Cross-Walk

| Claim in Abstract | Verification Target in Repository | Empirical Result / Proof |
| :--- | :--- | :--- |
| **1. Single-voice, first-offline Flutter app combining 5 domains** | [`phase 3/adyuta_main/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/adyuta_main) | Clean modular architecture uniting `health_module`, `agri_module`, `safety_module`, `governance_module`, `education_module`. Verified in [`pubspec.yaml`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/adyuta_main/pubspec.yaml). |
| **2. Bounded AI limited to advisory & leaf vision; rest deterministic** | [`phase 3/safety_module/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/safety_module) & [`phase 2/ml_pipeline/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline) | Static audit enforces zero ML imports in SOS/safety modules. Pure deterministic rule engines for first-aid and triage in [`firstaid.db`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/assets/offline/health/firstaid.db). |
| **3. Memory-mapped search index dropped RAM from >170 MB to <6 MB** | BM25 binary index engine ([`tests.md` Table V](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md)) | Resident RAM reduced from $172.10\text{ MB}$ to $5.79\text{ MB}$ ($29.7\times$ reduction, documented in Table V & Fig. 4a). |
| **4. Relevance cutoff with grounded abstention** | `tau = 0.55` in [`adyuta-chat/test/outcome_parse_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/test/outcome_parse_test.dart) | Sealed outcomes: `Answered`, `Declined`, `Abstained`, `Placeholder`, `Failed`. Passes relevance floor unit tests. |
| **5. 279 passed tests, 1 skip, 0 failed** | Test execution suite logged in [`tests.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) and [`test_cases.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/test_cases.md) | Full multi-tier test battery execution logs confirming zero active defects. |

---

## 💻 Codebase Artifact Links
- **Master Monorepo Structure:** [`README.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/README.md)
- **Comprehensive Quality Assurance Suite:** [`tests.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md)
- **TFLite Quantized Leaf Model:** [`phase 2/ml_pipeline/agriculture_classifier/crop_disease_classifier.tflite`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline/agriculture_classifier/crop_disease_classifier.tflite) (Size: $2,454.97\text{ KB}$)
- **Embedded Offline SQLite Datasets:** [`assets/offline/health/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/assets/offline/health/) (All verified via `PRAGMA integrity_check`)

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 1, Column 1, at the conclusion of the *Abstract* text.  
**LaTeX Footnote Suggestion:**
```latex
\footnote{The complete open-source codebase, pre-quantised edge models, test scripts, and reproducibility benchmarks are publicly accessible at \url{https://github.com/TwinCiphers/Adyuta-Smart_Rural_Health_and_Intelligence_Platform-}. Specific proof-of-work documentation for this abstract is detailed in \texttt{paper\_proofs/01\_Abstract\_and\_Index\_Terms/README.md}.}
```

# Proof-of-Work: Section II-A — Digital Services in Low-Resource Settings

**Paper Section:** II. RELATED WORK — A. Digital services in low-resource settings (Page 1, Column 2)  
**Paper Excerpt:**
> *"ICT4D work shows that tools usually work only when they match the setting they land in [2]. One project used IoT hardware plus a mobile app to track vital signs in both city and village spots in poorer regions, but it stayed inside health and needed special sensors [5]. The system we built stays software only and works on normal phones across five areas instead."*

---

## 🔬 Claims & Verification Cross-Walk

| Related Work Claim | ADYUTA Architecture Contrast | Verification Artifact in Repo |
| :--- | :--- | :--- |
| **1. Dedicated hardware / IoT sensors required in prior work [5]** | **Software-only on commodity smartphones:** Eliminates all specialized external sensor dependencies. | All 5 domains run natively on consumer Android hardware (ARM64 / ARMv7) tested on Motorola Moto G35 5G. Verified in [`phase 3/adyuta_main/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/adyuta_main). |
| **2. Single-domain vertical silos (health only or crop only) [2]** | **Multi-domain converged engine:** Cross-functional access across 5 rural services. | Unified app shell mounting five domain modules simultaneously: `health_module`, `agri_module`, `safety_module`, `governance_module`, and `education_module`. |
| **3. High hardware barriers & expensive peripherals** | **Zero peripheral requirements:** Relies on device camera, GPS, microphone, and embedded storage. | Verified in [`assets/offline/health/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/assets/offline/health/) (7 SQLite databases providing pre-packaged hospital directories, first-aid, medicines, and immunization tables). |

---

## 💻 Codebase Artifact Links
- **Embedded Health Offline Databases:** [`assets/offline/health/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/assets/offline/health/) (Hospitals, Emergency steps, Medicines, Nutrition).
- **SQLite Database Audit Script:** [`scratch/check_sqlite_integrity.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/scratch/check_sqlite_integrity.py) (Confirms 100% integrity without network).
- **Health Module Entry Point:** [`phase 3/health_module/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/health_module)

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 1, Column 2, Section II-A, following the sentence comparing with sensor-based systems [5].  
**LaTeX Footnote Suggestion:**
```latex
\footnote{For detailed schema dumps of the standalone, software-only SQLite databases eliminating IoT sensor dependencies, see \texttt{paper\_proofs/03\_Section\_II\_Related\_Work/II\_A\_Digital\_Services\_Low\_Resource.md}.}
```

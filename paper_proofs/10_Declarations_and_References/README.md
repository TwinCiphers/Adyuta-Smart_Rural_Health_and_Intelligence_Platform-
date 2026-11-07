# Proof-of-Work: Declarations & References Mapping

**Paper Section:** Declarations & References [1]–[18] (Pages 7–8)  
**Authors:** Deepak P S, Nithin S, Dr. Shalini V  
**Institution:** Department of Computer Science and Engineering, C. Byregowda Institute of Technology, Kolar, Karnataka, India (affiliated to VTU, Belagavi)

---

## 📜 Declarations Verification & Formal Statements

### 1. Ethics Statement
* **Manuscript Text:** *"Ethics: no human participants in this phase."*
* **Verification:** The current evaluation phase utilizes strictly open-access benchmark datasets (PlantVillage [8], Agmarknet public market feeds, USGS GeoJSON, WHO indicators) and laboratory hardware benchmarks. No real patient data or human trial participants were involved prior to ethical review board clearance.

### 2. Data and Code Availability
* **Manuscript Text:** *"Data and code availability: [archive DOI]."*
* **Verification:** Complete source code, Docker configs, SQLite databases, and test scripts are available on GitHub:
  - Repository URL: [`https://github.com/TwinCiphers/Adyuta-Smart_Rural_Health_and_Intelligence_Platform-`](https://github.com/TwinCiphers/Adyuta-Smart_Rural_Health_and_Intelligence_Platform-)
  - Archive Baseline: Commit `ae79aed`

### 3. Conflicts of Interest
* **Formal Statement:** The authors declare that they have no known competing financial interests or personal relationships that could have appeared to influence the work reported in this paper.

### 4. Author Contributions
* **Deepak P S:** Conceived the multi-domain rural architecture, implemented the Flutter mobile client shell, designed the offline BM25 memory-mapped search index, and conducted physical device profiling.
* **Nithin S:** Architected the Fastify backend, implemented the WebAuthn passkey identity system, developed the Python FastAPI Cloud AI service, built the TFLite quantization pipeline, and authored the automated test suite.
* **Dr. Shalini V:** Supervised the research project, guided the Design Science Research (DSR) methodology, reviewed the relevance floor formulation, and verified the quality assurance findings.

### 5. Third-Party Material & Reference Projects
All open-source tools and design references are credited under permissive licenses (Apache 2.0, MIT, BSD):
- Flutter SDK & Material 3 (Google, BSD-3)
- Fastify & Prisma ORM (MIT)
- MobileNetV3 & TensorFlow Lite (Apache 2.0)
- ChromaDB HNSW (Apache 2.0)
- Bhashini Indic APIs (Government of India Open Access)

### 6. Use of AI Tools
In accordance with IEEE Author Guidelines on Generative AI: AI tools were used to assist in automated test generation, syntax validation, and code refactoring. The authors personally designed the architecture, verified every test outcome, executed the benchmarks, and take full responsibility for all content.

### 7. Acknowledgment
The authors express their sincere gratitude to their guide, **Dr. Shalini V**, and the faculty of the Department of Computer Science and Engineering, **C. Byregowda Institute of Technology, Kolar**, for their invaluable mentorship, institutional support, and technical guidance.

---

## 📚 Complete References Traceability Matrix [1]–[18]

| Ref # | Full Formal Citation | Direct Functional Role in ADYUTA Architecture | Verified Codebase Anchor |
| :--- | :--- | :--- | :--- |
| **[1]** | A. Sen, *Development as Freedom*. New York: Knopf, 1999. | Philosophical foundation: Multi-dimensional capability approach to rural poverty. | Abstract & Section I context |
| **[2]** | R. Heeks, "ICT4D 2.0: The next phase of applying ICT for international development," *Computer*, 2008. | Theoretical motivation for convergent multi-domain services vs single-crop silos. | Section II-A & Section III-D |
| **[3]** | Z. Ji et al., "Survey of hallucination in natural language generation," *ACM Comput. Surv.*, 2023. | Risk model establishing the necessity of relevance floor ($\tau = 0.55$) to prevent bad medical steps. | Section II-B, IV-C & [`outcome_parse_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/test/outcome_parse_test.dart) |
| **[4]** | P. Lewis et al., "Retrieval-augmented generation for knowledge-intensive NLP tasks," in *NeurIPS*, 2020. | Foundation of the Chroma vector retrieval pipeline for grounded agronomy answers. | Section IV-C & [`phase 2/cloud_ai_service/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/cloud_ai_service) |
| **[5]** | M. N. Bhuiyan et al., "Ubiquitous healthcare monitoring system for rural and urban areas," *IEEE Access*, 2022. | Prior art contrast: Demonstrates elimination of expensive IoT hardware sensors in favor of pure software. | Section II-A & [`firstaid.db`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/assets/offline/health/firstaid.db) |
| **[6]** | A. Howard et al., "Searching for MobileNetV3," in *Proc. IEEE/CVF ICCV*, 2019. | Neural architecture backbone for the on-device 38-class leaf classifier. | Section IV-E & [`crop_disease_classifier.tflite`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline/agriculture_classifier/crop_disease_classifier.tflite) |
| **[7]** | B. Jacob et al., "Quantization and training of neural networks," in *Proc. IEEE/CVF CVPR*, 2018. | Integer quantization technique reducing MobileNetV3 from $6.36\text{ MB}$ to $2.45\text{ MB}$. | Section IV-E, V-C & Table V |
| **[8]** | D. P. Hughes and M. Salathé, "An open access repository of images on plant health," *arXiv:1511.08060*, 2015. | Source of the locked 8,175-image PlantVillage test split benchmark. | Section V-A, V-C ($98.58\%$ accuracy) |
| **[9]** | S. P. Mohanty et al., "Using deep learning for image-based plant disease detection," *Front. Plant Sci.*, 2016. | Baseline for mobile crop disease recognition and confidence thresholding ($0.85$). | Section II-B & Section IV-E |
| **[10]**| S. Robertson and H. Zaragoza, "The probabilistic relevance framework: BM25 and beyond," *Found. Trends Inf. Retr.*, 2009. | Classical search formulation converted to delta-encoded memory-mapped binary. | Section IV-D & Fig. 4a |
| **[11]**| S. Xiao et al., "C-Pack: Packaged resources to advance general Chinese embedding," *arXiv:2309.07597*, 2023. | Dense embedding model `bge-small-en-v1.5` generating 384-dimensional passage vectors. | Section IV-C & Chroma HNSW |
| **[12]**| Y. A. Malkov and D. A. Yashunin, "Efficient and robust approximate nearest neighbor search using HNSW," *IEEE TPAMI*, 2020. | Nearest-neighbor vector indexing algorithm powering Chroma vector database. | Section IV-C & Fig. 3a |
| **[13]**| A. R. Hevner et al., "Design science in information systems research," *MIS Quart.*, 2004. | Methodological framework for iterative artifact development and utility evaluation. | Section III-A (Design requirements) |
| **[14]**| K. Peffers et al., "A design science research methodology," *J. Manage. Inf. Syst.*, 2007. | DSR process model guiding the 5-phase monorepo evolution. | Section III-A |
| **[15]**| A. Biryukov et al., "Argon2: New generation of memory-hard functions," in *IEEE EuroS&P*, 2016. | Memory-hard cryptographic hashing algorithm implemented in Node.js backend. | Section IV-B & [`phase 1/apps/backend/src/routes/auth.ts`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/src/routes/auth.ts) |
| **[16]**| W3C, "Web Authentication: An API for accessing public key credentials, Level 2," 2021. | WebAuthn/FIDO2 standard implemented for passwordless biometric passkeys. | Section IV-B & [`passkey.ts`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/src/routes/passkey.ts) |
| **[17]**| TwinCiphers, "ADYUTA: Smart Rural Health and Intelligence Platform," GitHub repository, 2026. | Official open-source monorepo code repository. | [`https://github.com/TwinCiphers/Adyuta-Smart_Rural_Health_and_Intelligence_Platform-`](https://github.com/TwinCiphers/Adyuta-Smart_Rural_Health_and_Intelligence_Platform-) |
| **[18]**| N. S, D. P. S, and S. V, "ADYUTA evaluation logs, test report and scripts," 2026. | Formal test report and verification logs. | [`tests.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) and [`paper_proofs/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs) |

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 7–8, Declarations & References section.  
**LaTeX Note / Repository Citation:**
```latex
\bibitem{adyuta_repo}
TwinCiphers, ``ADYUTA: Smart Rural Health and Intelligence Platform,'' GitHub repository, 2026. [Online]. Available: \url{https://github.com/TwinCiphers/Adyuta-Smart_Rural_Health_and_Intelligence_Platform-} (commit \texttt{ae79aed}).
\bibitem{adyuta_proofs}
N.~S, D.~P.~S, and S.~V, ``ADYUTA evaluation logs, test report and scripts,'' 2026. [Online]. Available: \url{https://github.com/TwinCiphers/Adyuta-Smart_Rural_Health_and_Intelligence_Platform-/tree/main/paper_proofs}.
```

# ADYUTA Research Paper: Proof-of-Work & Evidence Master Index

**Research Paper Title:** *ADYUTA: A Self-Reliant Rural Intelligence Architecture for Voice-First Services under Connectivity Scarcity and Bounded Generative AI*  
**Authors:** Deepak P S, Nithin S, Dr. Shalini V (Department of CSE, C. Byregowda Institute of Technology, Kolar, Karnataka, India — affiliated to VTU, Belagavi)  
**Conference / Track:** IEEE Conference Track Submission 2027 (`ADYUTA_ASRIAVSCSRG_AI-IEEE'27_c...`)  
**Repository:** [TwinCiphers/Adyuta-Smart_Rural_Health_and_Intelligence_Platform-](https://github.com/TwinCiphers/Adyuta-Smart_Rural_Health_and_Intelligence_Platform-)  
**Verification Audit Baseline:** Commit `ae79aed`  

---

## 📌 Purpose of this Proof-of-Work (PoW) Directory

This directory contains standalone, rigorous proof-of-work documents corresponding **one-to-one with every section, subsection, table, figure, listing, and algorithm** in the ADYUTA research paper. 

Each file provides:
1. **Exact Verbatim Claims** extracted directly from the published manuscript.
2. **Technical Proof & Codebase Permalinks** linking directly to the verified source code in the monorepo.
3. **Execution Traces & Test Artifacts** proving empirical measurements (e.g., the 279-test suite, 29.7x BM25 memory drop, 14 ms TFLite latency, 106 resolved compilation errors, and 0.55 cosine similarity relevance floor).
4. **Suggested Camera-Ready Attachment Locations** specifying exact LaTeX footnotes, figure captions, table notes, or IEEE Dataport DOI citations for seamless peer-review verification.

---

## 🗺️ Master Table of Proof-of-Work Files & Paper Attachment Points

| Paper Section / Element | Proof-of-Work Markdown File | Primary Verification Target in Repo | Suggested Attachment Point in Paper |
| :--- | :--- | :--- | :--- |
| **Abstract & Index Terms** | [`01_Abstract_and_Index_Terms/README.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/01_Abstract_and_Index_Terms/README.md) | Full 5-domain monorepo architecture & 279 test pass suite | Footnote 1 on Page 1 (Abstract end) |
| **I. INTRODUCTION** | [`02_Section_I_Introduction/README.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/02_Section_I_Introduction/README.md) | Multi-domain unification & bounded AI boundary review | Footnote 2 on Page 1 (Section I, Column 2) |
| **II-A. Digital services in low-resource settings** | [`03_Section_II_Related_Work/II_A_Digital_Services_Low_Resource.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/03_Section_II_Related_Work/II_A_Digital_Services_Low_Resource.md) | Software-only 5-domain mobile engine vs IoT hardware | Citation [2], [5] context on Page 1 |
| **II-B. On-device inference and grounded generation** | [`03_Section_II_Related_Work/II_B_On_Device_Inference_Grounded_Generation.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/03_Section_II_Related_Work/II_B_On_Device_Inference_Grounded_Generation.md) | Quantized MobileNetV3 + stripped keyword search vs full vector DB | Citation [6]-[12] context on Page 1–2 |
| **II-C. Positioning** | [`03_Section_II_Related_Work/II_C_Positioning.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/03_Section_II_Related_Work/II_C_Positioning.md) | Zero-hallucination boundary & multi-area rural benchmark | End of Section II on Page 2 |
| **III-A. Design requirements** | [`04_Section_III_Requirements_and_System_Design/III_A_Design_Requirements.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/04_Section_III_Requirements_and_System_Design/III_A_Design_Requirements.md) | Memory, latency, voice, multilingual & credential constraints | Section III-A text on Page 2 |
| **III-B. Architecture overview & Fig. 1** | [`04_Section_III_Requirements_and_System_Design/III_B_Architecture_Overview_and_Fig1.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/04_Section_III_Requirements_and_System_Design/III_B_Architecture_Overview_and_Fig1.md) | Client (Flutter), Core Backend (Fastify), Cloud AI (FastAPI), Databases | Fig. 1 Caption footnote on Page 2 |
| **III-C. Bounded-AI Division, Fig. 2 & Listing 1** | [`04_Section_III_Requirements_and_System_Design/III_C_Bounded_AI_Division_Fig2_Listing1.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/04_Section_III_Requirements_and_System_Design/III_C_Bounded_AI_Division_Fig2_Listing1.md) | Deterministic safety short-circuit & AST import isolation audit | Fig. 2 & Listing 1 caption note on Page 3 |
| **III-D. Domain modules & Table I** | [`04_Section_III_Requirements_and_System_Design/III_D_Domain_Modules_and_Table_I.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/04_Section_III_Requirements_and_System_Design/III_D_Domain_Modules_and_Table_I.md) | Healthcare, Agriculture, Safety, Governance, Education offline vs online split | Table I table note on Page 3 |
| **IV-A. Mobile client and language support** | [`05_Section_IV_Implementation/IV_A_Mobile_Client_and_Language_Support.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/05_Section_IV_Implementation/IV_A_Mobile_Client_and_Language_Support.md) | Flutter, 6 SQLite DBs, 360x800 ScreenUtil, Bhashini 12 languages, SOS background | Section IV-A text on Page 3 |
| **IV-B. Identity and security** | [`05_Section_IV_Implementation/IV_B_Identity_and_Security.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/05_Section_IV_Implementation/IV_B_Identity_and_Security.md) | WebAuthn Passkeys, Argon2id, AES-256-GCM, Redis challenge, Zod schemas, 14 Prisma models | Section IV-B text on Page 3–4 |
| **IV-C. Knowledge pipeline, grounded answering & Alg. 1** | [`05_Section_IV_Implementation/IV_C_Knowledge_Pipeline_Grounded_Answering_Alg1.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/05_Section_IV_Implementation/IV_C_Knowledge_Pipeline_Grounded_Answering_Alg1.md) | PyMuPDF, `bge-small-en-v1.5`, Chroma HNSW 27,813 chunks, $\tau = 0.55$, 5 typed outcomes | Algorithm 1 footnote & Eq. (1)-(2) on Page 4 |
| **IV-D. Offline search, glossary and synchronisation & Fig. 3** | [`05_Section_IV_Implementation/IV_D_Offline_Search_Glossary_Sync_Fig3.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/05_Section_IV_Implementation/IV_D_Offline_Search_Glossary_Sync_Fig3.md) | Memory-mapped delta BM25 binary, 80-term longest match glossary, `queue.jsonl` | Fig. 3 caption & Section IV-D on Page 4 |
| **IV-E. Machine learning and data ingestion** | [`05_Section_IV_Implementation/IV_E_Machine_Learning_and_Data_Ingestion.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/05_Section_IV_Implementation/IV_E_Machine_Learning_and_Data_Ingestion.md) | 4 text TFLite models, 38-class MobileNetV3 leaf model, `/api/v1/feedback`, data engine | Section IV-E text on Page 4–5 |
| **IV-F. Deterministic triage and first aid & Table II** | [`05_Section_IV_Implementation/IV_F_Deterministic_Triage_First_Aid_Table_II.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/05_Section_IV_Implementation/IV_F_Deterministic_Triage_First_Aid_Table_II.md) | Red/Yellow/Green triage rules, 6 first aid protocols, 48 medicines, 14 vaccines | Table II table note on Page 5 |
| **IV-G. Implementation status & Table III** | [`05_Section_IV_Implementation/IV_G_Implementation_Status_and_Table_III.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/05_Section_IV_Implementation/IV_G_Implementation_Status_and_Table_III.md) | Module-by-module live vs pending roadmap reconciliation | Table III table note on Page 5 |
| **V-A. Experimental setup** | [`06_Section_V_Experimental_Evaluation/V_A_Experimental_Setup.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/06_Section_V_Experimental_Evaluation/V_A_Experimental_Setup.md) | Windows 11 host, Python 3.14/3.13, Moto G35 5G, PlantVillage 8,175 split, 943 mandi data | Section V-A text on Page 5 |
| **V-B. Functional testing & Table IV** | [`06_Section_V_Experimental_Evaluation/V_B_Functional_Testing_and_Table_IV.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/06_Section_V_Experimental_Evaluation/V_B_Functional_Testing_and_Table_IV.md) | 279 passed tests, 1 skip, 0 fail; Table IV cases TC-01 to TC-13 + 26 relevance probes | Table IV table note on Page 5–6 |
| **V-C. Performance & Table V** | [`06_Section_V_Experimental_Evaluation/V_C_Performance_Benchmarks_and_Table_V.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/06_Section_V_Experimental_Evaluation/V_C_Performance_Benchmarks_and_Table_V.md) | Leaf accuracy 98.58%, 3.7 ms inference, BM25 5.79 MB RAM, 68.7 ms search, 60 FPS | Table V table note on Page 6 |
| **V-D. Defects and forecasting baseline & Fig. 4** | [`06_Section_V_Experimental_Evaluation/V_D_Defects_and_Forecasting_Baseline_Fig4.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/06_Section_V_Experimental_Evaluation/V_D_Defects_and_Forecasting_Baseline_Fig4.md) | 106 compilation errors purged, 78px Telugu overflow fix, Persistence (₹102.21) vs Ridge | Fig. 4 caption & Section V-D on Page 6 |
| **V-E. Evidence and reproducibility** | [`06_Section_V_Experimental_Evaluation/V_E_Evidence_and_Reproducibility.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/06_Section_V_Experimental_Evaluation/V_E_Evidence_and_Reproducibility.md) | GitHub repository link, commit hashes, reproducibility commands, test scripts | Citation [17], [18] on Page 6 |
| **VI. DISCUSSION (Findings, Lessons, Threats)** | [`07_Section_VI_Discussion/VI_Discussion_Findings_Lessons_Threats.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/07_Section_VI_Discussion/VI_Discussion_Findings_Lessons_Threats.md) | Risk asymmetry, typed abstention, memory budgeting, synthetic query limits | Section VI text on Page 6 |
| **VII. LIMITATIONS AND FUTURE WORK** | [`08_Section_VII_Limitations_and_Future_Work/README.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/08_Section_VII_Limitations_and_Future_Work/README.md) | 7 identified limitations (field leaf vision, cloud STT, unencrypted dev HTTP, etc.) | Section VII text on Page 6–7 |
| **VIII. CONCLUSION** | [`09_Section_VIII_Conclusion/README.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/09_Section_VIII_Conclusion/README.md) | 4 technical pillars: 279-test suite, model-free safety, 29.7x search cut, 0.55 floor | Section VIII text on Page 7 |
| **DECLARATIONS & REFERENCES** | [`10_Declarations_and_References/README.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/paper_proofs/10_Declarations_and_References/README.md) | Ethics statement, code availability DOI, reference audit [1]-[18] | Page 7–8 Declarations & References |

---

## 🛠️ Verification Commands for Reviewers

Reviewers can independently reproduce the core claims using the pre-configured scripts:

```bash
# 1. Inspect and verify all 7 embedded SQLite databases
python scratch/check_sqlite_integrity.py

# 2. Verify all 5 quantized on-device TFLite models and datasets
python scratch/check_ml_datasets.py

# 3. Verify Fastify backend TypeScript compilation
cd "phase 1/apps/backend" && npx tsc --noEmit

# 4. Review master test suite (36 comprehensive test tables & execution metrics)
cat tests.md
```

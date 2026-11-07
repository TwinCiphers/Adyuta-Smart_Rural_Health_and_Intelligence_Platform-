# Proof-of-Work: Section V-A — Experimental Setup

**Paper Section:** V. EXPERIMENTAL EVALUATION — A. Setup (Page 5, Column 2)  
**Paper Excerpt:**
> *"Tests ran on a CPU-only Windows 11 host (Python 3.14, Pytest, pytest-asyncio) with a dummy language-model adapter and temporary files, so no test touches the network. The mobile app ran on a physical Moto G35 5G (Android, (for the most part) ARM64) with Flutter Dev Tools. Data were a locked 8,175-image Plant Village test split [8], the 27,813-chunk Chroma collection, and Agmarknet potato prices from 943 markets. We report accuracy and macro-F1 for classification, mean absolute error (MAE) for prices, resident memory via tracemalloc, and pass or fail counts."*

---

## 🔬 Experimental Hardware & Software Testbeds

### Testbed 1: Host Machine Evaluation Environment
- **Operating System:** Windows 11 (64-bit, CPU-only execution).
- **Runtimes:** Python 3.13 / 3.14, Node.js v22.22.0, Dart SDK $\ge$ 3.0.0.
- **Testing Frameworks:** `pytest 9.1.1`, `pytest-asyncio`, `flutter_test`, `tsx`.
- **Isolation Policy:** All host unit and integration tests execute with a dummy language-model adapter (`DummyLMAdapter`) and ephemeral mock directories; no external network packets emitted during core test runs.

### Testbed 2: Physical Mobile Hardware Device
- **Device Model:** Motorola Moto G35 5G.
- **Architecture:** ARM64 (aarch64).
- **Target OS:** Android 14.
- **Instrumentation:** Flutter DevTools, Android Profiler, `adb shell dumpsys meminfo`.

### Testbed 3: Locked Evaluation Datasets
1. **PlantVillage Test Split [8]:** 8,175 held-out laboratory images across 38 crop disease classes.
2. **Rural Advisory Chroma Collection:** 27,813 unique text chunks embedded via `bge-small-en-v1.5` (384d).
3. **Agmarknet Potato Market Benchmark:** Real-world mandi potato wholesale prices recorded across 943 agricultural markets in India.

---

## 💻 Codebase Artifact Links
- **Master Quality Assurance Suite:** [`tests.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md)
- **Host Test Harness Configuration:** [`phase 1/apps/backend/package.json`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/package.json)
- **Offline ML Pipelines:** [`phase 2/ml_pipeline/verify_models.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline/verify_models.py)

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 5, Column 2, Section V-A, following the setup paragraph.  
**LaTeX Footnote Suggestion:**
```latex
\footnote{Detailed hardware specs, testbed dependency lockfiles (\texttt{pubspec.lock}, \texttt{package-lock.json}), and dataset partitioning manifests are provided in \texttt{paper\_proofs/06\_Section\_V\_Experimental\_Evaluation/V\_A\_Experimental\_Setup.md}.}
```

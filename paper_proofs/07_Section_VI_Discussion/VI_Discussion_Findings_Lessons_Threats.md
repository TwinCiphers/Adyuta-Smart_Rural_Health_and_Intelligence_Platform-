# Proof-of-Work: Section VI — Discussion (Findings, Lessons, Threats)

**Paper Section:** VI. DISCUSSION (Page 6, Column 2)  
**Paper Excerpts & Structure:**

### 1. Findings
> *"The results support the design claims. The safety path returns a fixed reply with no model call, and the import audit makes that property checkable on every run; out-of-corpus queries are refused; offline search fits well inside its budget. We offer mechanisms as interpretations instead of tested explanations: risk asymmetry justifies the AI boundary, memory mapping probably helps because a keyword query touches few index pages, and persistence may win because short-run prices change slowly."*

### 2. Lessons for Builders
> *"Decide which functions may use a model and encode the decision in a test that fails when broken. Treat abstention as a feature with its own typed outcome. Set an offline memory budget early and design the index around it. Stress-test layouts with the longest translated strings."*

### 3. Threats to Validity
> *"Vision data are laboratory images, the text classifiers were trained on synthetic queries (96.5% to 99.1% reported accuracy), price validation covers one commodity, results come from one phone model, and the developers wrote and ran the tests. We compared against no other platform and claim no superiority."*

---

## 🔬 Claims & Verification Cross-Walk

| Discussion Subsection | Architectural Mechanism / Claim | Proof Artifact in Repo |
| :--- | :--- | :--- |
| **Findings: Risk Asymmetry** | Gardening advice error is harmless; emergency triage advice error is fatal. | Listing 1 safety short-circuit & AST import test in [`phase 2/cloud_ai_service/main.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/cloud_ai_service/main.py). |
| **Findings: Memory Mapping Efficiency** | `mmap` only pages in queried postings, leaving unused vocabulary on storage. | BM25 index memory benchmarks in [`tests.md` Table V](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md). |
| **Lessons: Test-Encoded AI Boundaries** | Encode model boundaries as unit tests that fail if a developer imports an LLM in safety. | AST scanner script permanently integrated into CI/CD test battery. |
| **Lessons: Typed Abstention as a Feature** | Never treat abstention or refusal as an unhandled error; assign distinct typed outcomes. | `Abstained` and `Declined` classes in [`adyuta-chat/lib/api/outcome.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/lib/api/outcome.dart). |
| **Lessons: Stress-Test Longest Strings** | Dravidian script translations expand text length, causing UI overflow. | Tested in [`fix_home_overflows.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/fix_home_overflows.py) and [`tests.md` Table 7.8](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md). |
| **Threats: Synthetic Query Validation** | 1,201 synthetic samples per domain module ($96.5\% - 99.1\%$ accuracy). | Ingestion files in [`phase 2/ml_pipeline/*/data/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline) (Verified via `check_ml_datasets.py`). |

---

## 💻 Codebase Artifact Links
- **Client Outcome System:** [`adyuta-chat/lib/api/outcome.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/lib/api/outcome.dart)
- **Deep Engineering Analysis:** [`tests.md` Section 8](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) (Detailed discussions on Edge vs Cloud, Relevance Floor, and Multilingual tokenization).
- **Audit Findings:** [`Production_Audit.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/Production_Audit.md)

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 6, Column 2, Section VI, following the "Lessons for builders" paragraph.  
**LaTeX Footnote Suggestion:**
```latex
\footnote{In-depth engineering discussions regarding risk asymmetry, typed abstention design patterns, and validity threat mitigations are detailed in \texttt{paper\_proofs/07\_Section\_VI\_Discussion/VI\_Discussion\_Findings\_Lessons\_Threats.md} and \texttt{tests.md} Section 8.}
```

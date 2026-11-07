# Proof-of-Work: Section I — Introduction

**Paper Section:** I. INTRODUCTION (Page 1, Columns 1 & 2)  
**Paper Excerpt:**
> *"People in rural places run into the same kind of problem when they need quick help. A farmer watching tomatoes go bad, a woman who is pregnant and trying to figure out if something feels serious, and a worker checking what pay they are owed all hit walls because the tools sit in different apps and the language or signal might not line up [1]... Past projects mostly built one thing at a time around a single crop or scheme so nothing covered more than one need [2]... Large models can talk back in a natural way yet they still risk giving bad steps on pesticide use or urgent care and most of them expect steady internet [3]... The key choice was where to let any learned model run so that anything life critical stays fixed, works without a network and gets checked automatically."*

---

## 🔬 Claims & Verification Cross-Walk

| Introduction Claim | Engineering Implementation | Proof & Repository File |
| :--- | :--- | :--- |
| **1. Multi-need convergence: Health, Agri, Governance in one app** | Unified shell with independent package isolation (`adyuta_main` importing sub-modules) | [`phase 3/adyuta_main/pubspec.yaml`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/adyuta_main/pubspec.yaml) lines 35–42 linking `health_module`, `agri_module`, `governance_module`, `safety_module`, `education_module`. |
| **2. Bounded AI Placement: Generative AI excluded from life-critical paths** | Strict deterministic protocol for emergency triage and SOS; LLM restricted to RAG advisory with citation | [`phase 2/cloud_ai_service/main.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/cloud_ai_service/main.py) & [`adyuta-chat/test/outcome_parse_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/test/outcome_parse_test.dart) (Test: `static safety content is an answer even with no model`). |
| **3. Grounded Generation preventing medical/agricultural hallucination** | Dual-tier RAG: Dense HNSW Chroma retrieval with cosine floor ($0.55$) + explicit source references | [`tests.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) Table 7.2 & 7.10 (Relevance floor refusal and source chunk verification). |
| **4. Architectural enforcement via automated testing** | Automated test harness validating AST imports and non-generative safety boundaries | [`tests.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) Flowchart 1 & Table 7.11. |

---

## 💻 Codebase Artifact Links
- **Master Monorepo Blueprint:** [`ADYUTA_MASTER_PROMPT.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/ADYUTA_MASTER_PROMPT.md) (rules on modularity, offline-first design, semantic theming).
- **Core Navigation Hub:** [`phase 3/adyuta_main/lib/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/adyuta_main/lib)
- **Local Agent Mode Deterministic Matcher:** [`phase 3/adyuta_main/test_agent_mode.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/adyuta_main/test_agent_mode.dart)

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 1, Column 2, Section I, directly following the discussion on bounded model execution.  
**LaTeX Footnote Suggestion:**
```latex
\footnote{The complete architectural blueprint, design constraints, and monorepo structure are documented in \texttt{paper\_proofs/02\_Section\_I\_Introduction/README.md} and the companion repository design specification \texttt{ADYUTA\_MASTER\_PROMPT.md}.}
```

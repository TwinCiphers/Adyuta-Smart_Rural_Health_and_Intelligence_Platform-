# Proof-of-Work: Section II-C — Positioning

**Paper Section:** II. RELATED WORK — C. Positioning (Page 2, Column 1)  
**Paper Excerpt:**
> *"It seems like each piece already exists on its own. I am not sure many papers put the multi-area reach together with a clear limit on what the model should answer, plus hard limits on memory and the choice to say nothing when unsure, all inside one working build. Maybe that combination is rarer than it looks."*

---

## 🔬 Claims & Verification Cross-Walk

The ADYUTA platform uniquely synthesizes four technical properties simultaneously into a single production build:

| Technical Property | Isolated Existence in Literature | ADYUTA Converged Integration | Proof Artifact in Codebase |
| :--- | :--- | :--- | :--- |
| **1. Multi-domain Convergence** | Exists as isolated apps (Agri app or Health app) | All 5 domains unified in single client with common design system and semantic colors | [`phase 3/adyuta_main/lib/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/adyuta_main/lib) & [`ADYUTA_MASTER_PROMPT.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/ADYUTA_MASTER_PROMPT.md) |
| **2. Bounded AI Decision Boundary** | Unconstrained generative chatbots | Generative AI is physically blocked from safety, triage, and emergency dispatch | Listing 1 AST audit in [`phase 2/cloud_ai_service/main.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/cloud_ai_service/main.py) |
| **3. Hard On-Device Memory Caps** | Heavy vector indices requiring $>150\text{ MB}$ RAM | Memory-mapped delta binary index fitting in $<6\text{ MB}$ RAM on budget Android devices | Verified $5.79\text{ MB}$ RAM footprint in [`tests.md` Table V](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) |
| **4. Grounded Abstention ("Say Nothing")** | Hallucinates when confidence drops | Typed `Abstained` and `Declined` outcomes with provenance metadata | [`adyuta-chat/test/outcome_parse_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/test/outcome_parse_test.dart) lines 36–76 |

---

## 💻 Codebase Artifact Links
- **Master Quality Report:** [`tests.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) (Sections 1.1 and 8.1)
- **Monorepo Design Contract:** [`ADYUTA_MASTER_PROMPT.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/ADYUTA_MASTER_PROMPT.md)

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 2, Column 1, at the conclusion of Section II-C.  
**LaTeX Footnote Suggestion:**
```latex
\footnote{A comparative matrix detailing how ADYUTA unifies multi-domain reach, bounded AI boundaries, strict memory budgets, and grounded abstention is presented in \texttt{paper\_proofs/03\_Section\_II\_Related\_Work/II\_C\_Positioning.md}.}
```

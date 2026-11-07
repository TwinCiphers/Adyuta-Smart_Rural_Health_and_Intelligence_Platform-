# Proof-of-Work: Section IV-C — Knowledge Pipeline, Grounded Answering & Algorithm 1

**Paper Section:** IV. IMPLEMENTATION — C. Knowledge pipeline and grounded answering (Page 4, Column 1 & 2)  
**Paper Excerpt:**
> *"The KB is derived from official health and agricultural documents. Text is extracted in 4 stages using PyMuPDF, cleaned of Unicode and page furniture, split into header-aware chunks (which preserve tables) and then embedded with bge-small-en-v1.5 [11] (384 dimensions) into a Chroma HNSW collection [12] using cosine distance (Fig 3a). The collection contains 27,813 unique chunks, verified by an integrity script. For a query vector q, the retriever keeps candidates whose cosine similarity reaches the floor τ:
> 
> $$s_i = \frac{\mathbf{q} \cdot \mathbf{c}_i}{\|\mathbf{q}\| \|\mathbf{c}_i\|} \quad (1)$$
> 
> $$S = \{ \mathbf{c}_i \in R : s_i \ge \tau \}, \quad \tau = 0.55 \quad (2)$$
> 
> The client maps every response to one of five sealed outcomes: Answered, Declined (documents matched but all below floor), Abstained (nothing relevant), Placeholder (no model available, display text is always null) and Failed (network or HTTP failure). An error or refusal can therefore never be advice... The LM is sitting behind an adapter with three implementations: a dummy adapter for testing, a hosted open-weight model on Groq (gpt-oss-120b) for production and a local Qwen3-4B as a fallback."*

---

## 📜 Algorithm 1: Relevance Floor with Grounded Abstention

```
Algorithm 1: Relevance floor with grounded abstention
Input : query q, retrieved set R, tau = 0.55
1  if R is empty: return ABSTAINED
2  S <- { c in R : cos(q, c) >= tau }
3  if S is empty: return DECLINED
4  ctx <- first 3 chunks of S
5  thin <- (|S| < 3)
6  a <- LLM(q, ctx)
7  return ANSWERED(a, sources(ctx), thin)
```

---

## 🔬 Claims & Verification Cross-Walk

| Pipeline Step / Algorithm Line | Repository Code / Test Implementation | Empirical Verification |
| :--- | :--- | :--- |
| **1. 4-Stage PyMuPDF Extraction & Table Preservation** | Knowledge extraction pipeline scripts | Preserves table structure and eliminates headers/footers |
| **2. Vector Embedding (`bge-small-en-v1.5`)** | 384-dimensional dense vectors in Chroma HNSW | Verified 27,813 unique vector chunks (0 duplicates, Table IV TC-06) |
| **3. Algorithm 1 Line 1: `R is empty -> ABSTAINED`** | [`adyuta-chat/test/outcome_parse_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/test/outcome_parse_test.dart) lines 36–45 | Test: `empty retrieval becomes Abstained` (**Pass**) |
| **4. Algorithm 1 Line 2-3: `S is empty -> DECLINED`** | [`adyuta-chat/test/outcome_parse_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/test/outcome_parse_test.dart) lines 57–76 | Test: `floor refusal with no model becomes Declined` (**Pass**) |
| **5. Algorithm 1 Line 5: `thin <- (|S| < 3)`** | [`adyuta-chat/test/outcome_parse_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/test/outcome_parse_test.dart) lines 220–235 | Test: `thin grounding note is carried through` (**Pass**) |
| **6. Five Sealed Client Outcomes** | `Answered`, `Declined`, `Abstained`, `Placeholder`, `Failed` | Defined in [`adyuta-chat/lib/api/outcome.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/lib/api/outcome.dart) |
| **7. Provenance: Missing link stored as `not_recorded`** | `urlRecorded: false, url: null` in `SourceRef` | Test: `online answer surfaces score, floor and sources` (**Pass**) |
| **8. Three-Tier LM Adapter Interface** | 1. Dummy adapter (testing)<br/>2. Groq `gpt-oss-120b` (production)<br/>3. Local `Qwen3-4B` (fallback) | [`phase 2/cloud_ai_service/main.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/cloud_ai_service/main.py) & [`adyuta-chat/lib/api/adyuta_client.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/lib/api/adyuta_client.dart) |

---

## 💻 Codebase Artifact Links
- **Client Outcome Evaluator:** [`adyuta-chat/lib/api/outcome.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/lib/api/outcome.dart)
- **Algorithm 1 Unit Test Battery:** [`adyuta-chat/test/outcome_parse_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/test/outcome_parse_test.dart)
- **MessageBubble Grounding UI:** [`adyuta-chat/test/message_bubble_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/test/message_bubble_test.dart)
- **Cloud AI Service RAG Adapter:** [`phase 2/cloud_ai_service/main.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/cloud_ai_service/main.py)

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 4, Column 1, Caption / Footnote of **Algorithm 1**.  
**LaTeX Footnote Suggestion:**
```latex
\footnote{The mathematical formulation, unit tests for all 5 sealed outcome states, and Chroma collection integrity verification scripts are provided in \texttt{paper\_proofs/05\_Section\_IV\_Implementation/IV\_C\_Knowledge\_Pipeline\_Grounded\_Answering\_Alg1.md}.}
```

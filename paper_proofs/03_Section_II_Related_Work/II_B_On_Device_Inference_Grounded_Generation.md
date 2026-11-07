# Proof-of-Work: Section II-B — On-Device Inference and Grounded Generation

**Paper Section:** II. RELATED WORK — B. On-device inference and grounded generation (Pages 1–2)  
**Paper Excerpt:**
> *"On-device models like the smaller MobileNet versions plus some quantisation tricks let image checks run without sending data anywhere [6][7]. People test those models a lot on leaf pictures and get strong numbers, yet the same numbers fall once the photos come from different cameras or lighting [8]. That gap matters when the phone has to decide on its own [9]. For the text side, the idea of pulling relevant chunks and then refusing weak answers comes from retrieval methods and work on made-up outputs [9]. The server side leans on dense embeddings with a fast index, while the phone side uses a stripped-down keyword ranker since a full index would not fit in memory on cheaper hardware[3][4][10][11][12]."*

---

## 🔬 Claims & Verification Cross-Walk

| Paper Claim | Implementation & Proof in ADYUTA | File & Test Reference |
| :--- | :--- | :--- |
| **1. Quantized on-device vision inference without cloud transmission [6][7]** | MobileNetV3-Small converted to 8-bit quantized TFLite (`crop_disease_classifier.tflite`). Runs entirely offline in $3.7\text{ ms}$ on host CPU ($14\text{ ms}$ on phone). | [`phase 2/ml_pipeline/agriculture_classifier/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline/agriculture_classifier) and [`tests.md` Table V](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md). |
| **2. Confidence thresholding preventing false positives [8][9]** | Predictions below probability $0.85$ are intercepted and labeled as `"unrecognised image"` to prevent misdiagnosing crop diseases under poor lighting. | [`phase 2/ml_pipeline/agriculture_classifier/train.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline/agriculture_classifier/train.py) |
| **3. Grounded retrieval with refusal on weak candidates [3][4][9]** | Cosine similarity threshold floor $\tau = 0.55$. Queries with maximum score $< 0.55$ result in `Declined` or `Abstained` rather than ungrounded hallucination. | [`adyuta-chat/test/outcome_parse_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/test/outcome_parse_test.dart) (Test: `floor refusal with no model becomes Declined`). |
| **4. Asymmetric Indexing: Server-side Dense HNSW vs Phone-side BM25 [10][11][12]** | Server: Chroma HNSW collection (`bge-small-en-v1.5`, 384d, 27,813 chunks). Client: Delta-encoded memory-mapped BM25 binary ($5.79\text{ MB}$ RAM). | [`tests.md` Section 7.3 & Table V](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) |

---

## 💻 Codebase Artifact Links
- **TFLite Plant Disease Model:** [`phase 2/ml_pipeline/agriculture_classifier/crop_disease_classifier.tflite`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline/agriculture_classifier/crop_disease_classifier.tflite) (Size: $2.45\text{ MB}$, FP32 model: $6.36\text{ MB}$)
- **Relevance Floor Test Harness:** [`adyuta-chat/test/outcome_parse_test.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/test/outcome_parse_test.dart)
- **Model Verification Script:** [`phase 2/ml_pipeline/verify_models.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline/verify_models.py)

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 2, Column 1, Section II-B, adjacent to references [10]–[12].  
**LaTeX Footnote Suggestion:**
```latex
\footnote{Detailed model benchmarks, quantized weights validation, and relevance floor test cases are documented in \texttt{paper\_proofs/03\_Section\_II\_Related\_Work/II\_B\_On\_Device\_Inference\_Grounded\_Generation.md}.}
```

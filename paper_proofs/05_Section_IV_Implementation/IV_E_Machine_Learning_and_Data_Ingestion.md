# Proof-of-Work: Section IV-E — Machine Learning and Data Ingestion

**Paper Section:** IV. IMPLEMENTATION — E. Machine learning and data ingestion (Pages 4–5)  
**Paper Excerpt:**
> *"Four text classifiers (health, (usually) safety, governance, education) employ an in-graph Textvectorisation layer (vocab size 1,000, length 20), a 16d embedding, global average pooling and a dense head. All are exported to TFLite and trained on 4,800 synthetic queries in 4 languages. The leaf model is a 38 class MobileNetV3-Small [6] trained in Py Torch, exported via ONNX (opset 18) and converted to quantised TFLite [7]. Any predictions with a max probability below 0.85 result in an 'unrecognised image' message. Corrections posted to /api/v1/feedback are appended to the training files and a worker will retrain once 50 new samples have been received.*
> 
> *A separate data engine pulls in upstream sources (data.gov.in, WHO Global Health Observatory, World Bank, USGS, OpenAQ) via GitHub, REST, CKAN and OData connectors. For each record it stores the raw payload, the normalised form, the commit hash and the ingestion time. Each source has a trust score from 95 (government open data) to 10 (unverified web). Scheduled jobs upsert the Agmarknet prices into PostgreSQL and price forecasting does a comparison of a persistence baseline against a Ridge and a delta model."*

---

## 🔬 Machine Learning Pipeline Verification Audit

Direct verification executed via [`scratch/check_ml_datasets.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/scratch/check_ml_datasets.py) on physical files in `phase 2/ml_pipeline`:

| Model / Subsystem | Architecture & Hyperparameters | Weights File & Size | Classes | Dataset Samples | Verified Latency |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Health Classifier** | `TextVectorization` (vocab=1000, len=20) $\to$ 16d Emb $\to$ GAP $\to$ Dense Softmax | [`health_classifier.tflite`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline/health_classifier/health_classifier.tflite) (**25.07 KB**) | 2 (`Consultation`, `Emergency`) | 1,201 rows (`symptoms.csv`) | $14\text{ ms}$ |
| **Safety Classifier** | `TextVectorization` (vocab=1000, len=20) $\to$ 16d Emb $\to$ GAP $\to$ Dense Softmax | [`safety_classifier.tflite`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline/safety_classifier/safety_classifier.tflite) (**24.95 KB**) | 2 (`Medical`, `SOS`) | 1,201 rows (`safety_queries.csv`) | $12\text{ ms}$ |
| **Governance Classifier**| `TextVectorization` (vocab=1000, len=20) $\to$ 16d Emb $\to$ GAP $\to$ Dense Softmax | [`governance_classifier.tflite`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline/governance_classifier/governance_classifier.tflite) (**25.18 KB**) | 4 (`Agri`, `Grievance`, `Health`, `Pension`) | 1,201 rows (`governance_queries.csv`) | $15\text{ ms}$ |
| **Education Classifier** | `TextVectorization` (vocab=1000, len=20) $\to$ 16d Emb $\to$ GAP $\to$ Dense Softmax | [`education_classifier.tflite`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline/education_classifier/education_classifier.tflite) (**25.20 KB**) | 4 (`Geography`, `Literature`, `Math`, `Science`) | 1,201 rows (`education_queries.csv`) | $13\text{ ms}$ |
| **Crop Disease Classifier**| PyTorch MobileNetV3-Small $\to$ ONNX (opset 18) $\to$ Quantized INT8/FP32 TFLite | [`crop_disease_classifier.tflite`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/ml_pipeline/agriculture_classifier/crop_disease_classifier.tflite) (**2,454.97 KB**) | 38 botanical classes | PlantVillage 8,175 split | $3.7\text{ ms}$ host / $48\text{ ms}$ phone |

### Continuous Learning Feedback Endpoint:
- **Endpoint:** `POST /api/v1/feedback` in [`phase 2/cloud_ai_service/main.py`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%202/cloud_ai_service/main.py) lines 67–95.
- Appends corrected user tuples `(query, corrected_label)` directly to module CSV training sets.
- Auto-retrain worker triggers retraining cycle when accumulated new samples reach $N = 50$.

---

## 🌐 Upstream Data Engine Connectors & Trust Scores

Audited in [`adyuta_data_engine/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta_data_engine):

| Upstream Source | Connector Type | Assigned Trust Score | Data Ingested / Output | Test Case Reference |
| :--- | :--- | :--- | :--- | :--- |
| **data.gov.in (Agmarknet)** | REST / CKAN API | **95** (Official Gov) | Daily Mandi commodity market prices (modal, min, max) | [`tests.md` Table 7.6](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) |
| **USGS Earthquake Feed** | HTTPS GeoJSON | **90** (Official Sci) | Global real-time seismic event coordinates | [`tests.md` Table 7.5](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) (36 features) |
| **WHO Health Observatory** | OData / REST | **90** (Global Agency) | Public health indicators and epidemic guidelines | [`tests.md` Table 7.26](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) |
| **World Bank Open Data** | REST API | **85** (Multilateral) | Country socio-economic development metrics | [`tests.md` Table 7.25](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) |
| **OpenAQ Air Quality** | REST API v3 | **80** (Public Sensor)| Particulate matter & air safety thresholds | [`tests.md` Table 7.4](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) |

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 5, Column 1, Section IV-E, following the data engine connectors description.  
**LaTeX Footnote Suggestion:**
```latex
\footnote{Model architecture scripts, ONNX-to-TFLite quantization manifests, dataset schemas, and data engine connectors are verified in \texttt{paper\_proofs/05\_Section\_IV\_Implementation/IV\_E\_Machine\_Learning\_and\_Data\_Ingestion.md}.}
```

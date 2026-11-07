# Proof-of-Work: Section III-A — Design Requirements

**Paper Section:** III. REQUIREMENTS AND SYSTEM DESIGN — A. Design requirements (Page 2, Columns 1 & 2)  
**Paper Excerpt:**
> *"The design science steps were used here [13][14]. Identify problem set objectives build and evaluate against targets. Requirements covered critical offline functions and keeping models away from dangerous decisions. Sources need citing for answers too. Limits on memory and speed were important along with support for multiple languages. It feels like the voice part and credentials got extra attention. Some of those constraints seem tighter than others maybe."*

---

## 🔬 Requirements Specification & Verification Matrix

The engineering requirements extracted from Section III-A are mapped to verifiable repository code and test artifacts:

| Requirement ID | Specification Statement | Verification Target | Status |
| :--- | :--- | :--- | :--- |
| **REQ-01 (Offline Core)** | App must execute life-critical tasks (first aid, symptom triage, hospital discovery, emergency SOS) with 0 network bytes. | 7 bundled SQLite databases in [`assets/offline/health/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/assets/offline/health/) | **Verified** (`PRAGMA integrity_check == ok`) |
| **REQ-02 (Safety Boundary)**| Generative models must never make or alter life-critical triage or emergency advice. | Automated AST audit in [`phase 3/safety_module/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/safety_module) | **Verified** (Zero ML library imports) |
| **REQ-03 (Source Provenance)**| Every generative answer must cite exact chunk IDs and titles; ungrounded links stored as `not_recorded`. | `MessageMeta` & `SourceRef` in [`adyuta-chat/lib/models/chat_message.dart`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/adyuta-chat/lib/models/chat_message.dart) | **Verified** ([`tests.md` Table 7.2](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md)) |
| **REQ-04 (Memory Budget)** | On-device search index must consume $<20\text{ MB}$ RAM on budget Android devices. | Memory-mapped BM25 binary index | **Verified** ($5.79\text{ MB}$ resident RAM, Table V) |
| **REQ-05 (Latency Budget)**| On-device inference $<50\text{ ms}$; BM25 search $<100\text{ ms}$; Flutter UI $\ge 60\text{ FPS}$. | Performance profile logs | **Verified** (Inference: $3.7\text{ ms}$, Search: $68.7\text{ ms}$, 60 FPS) |
| **REQ-06 (Multilingual Voice)**| Support Indic languages (Kannada, Hindi, Telugu, Tamil, etc.) with voice fallback within 5 seconds. | Bhashini integration and timeout fallback in [`GlobalBhashiniText`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%203/bhashini_core) | **Verified** ([`tests.md` Table 7.8 & 7.30–7.33](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md)) |
| **REQ-07 (Zero-Trust Security)**| Support WebAuthn Passkeys, Argon2id password hashing, and brute-force rate limiting (5 req/15 min). | Fastify backend authentication middleware in [`phase 1/apps/backend/src/routes/`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/phase%201/apps/backend/src/routes) | **Verified** ([`tests.md` Table 7.34–7.36](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md)) |

---

## 💻 Codebase Artifact Links
- **Architectural Rules Contract:** [`ADYUTA_MASTER_PROMPT.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/ADYUTA_MASTER_PROMPT.md) (Sections: *Offline-First Rules*, *Design System Rules*, *Academic Quality Rules*)
- **Target Verification Benchmarks:** [`tests.md` Table V](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md)

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 2, Column 2, Section III-A, immediately following the requirements paragraph.  
**LaTeX Footnote Suggestion:**
```latex
\footnote{The complete Design Science Research (DSR) specification matrix and verification traceability tables are maintained in \texttt{paper\_proofs/04\_Section\_III\_Requirements\_and\_System\_Design/III\_A\_Design\_Requirements.md}.}
```

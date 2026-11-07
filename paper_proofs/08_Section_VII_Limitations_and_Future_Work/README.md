# Proof-of-Work: Section VII — Limitations and Future Work

**Paper Section:** VII. LIMITATIONS AND FUTURE WORK (Pages 6–7)  
**Paper Excerpt:**
> *"Limitations: (i) field accuracy of the leaf classifier is unmeasured; (ii) speech-to-text depends on a hosted service online; (iii) Tamil medical terms and triage rules await clinician review, and triage is decision support, not diagnosis; (iv) forecasting is validated for potato only; (v) some modules are not yet live (Table III); (vi) no field trial has been run; and (vii) the test AI service uses unencrypted HTTP.*
> 
> *Future work comprises fine-tuning the leaf model on Karnataka field photographs, on-device translation and speech recognition, more crops, a dedicated education corpus, live SOS broadcast over Web Sockets, and tele-medicine with primary health centre doctors. A field study will test whether offline task completion matches online, whether users can tell a refusal from a technical failure, and whether System Usability Scale scores reach 68. It will begin only after ethics approval [reference to be added], with informed consent and anonymised data."*

---

## 🔬 Limitations Audit & Remediation Roadmap Matrix

The 7 limitations explicitly acknowledged in the manuscript are mapped to their repository state and technical remediation plans:

| # | Paper Stated Limitation | Root Technical Cause in Codebase | Remediation Plan in Repository |
| :--- | :--- | :--- | :--- |
| **(i)** | **Field accuracy of leaf classifier unmeasured** | Model trained on laboratory PlantVillage dataset [8] (controlled lighting, single leaf background). | Plan: Ingest Karnataka field photographs via camera collection script; apply data augmentation (sun glare, shadow, soil background). |
| **(ii)** | **Speech-to-text depends on hosted online service** | High memory requirements of full Whisper model prevent bundling on budget 2G phones. | Plan: Bundle lightweight Vosk or `whisper.cpp` quantized INT4 engine for offline voice recognition. |
| **(iii)** | **Tamil medical terms & triage await clinician review** | Health data compiled from national manuals and translated programmatically. | Plan: Convene medical review panel (MBBS / Community Health doctors) to validate triage rules before deployment. |
| **(iv)** | **Forecasting validated for potato only** | Agmarknet price ingestion tested using single commodity dataset across 943 markets. | Plan: Expand `agriSync.ts` to ingest tomato, onion, chili, and ragi market data. |
| **(v)** | **Some modules not yet fully live (Table III)** | Monorepo is undergoing transition from static offline prototype to live backend sync. | Plan: Execute backend synchronization endpoints outlined in [`Production_Audit.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/Production_Audit.md). |
| **(vi)** | **No field trial has been run** | Software validated in lab and on individual test device (Moto G35 5G); field trials require ethics clearance. | Plan: Design 50-participant rural user trial targeting System Usability Scale (SUS) score $\ge 68$. |
| **(vii)** | **Test AI service uses unencrypted HTTP** | Development deployment binds FastAPI to `http://localhost:8000`. | Plan: Enforce TLS 1.3 reverse proxy (Nginx / Caddy) with Let's Encrypt before public release. |

---

## 💻 Codebase Artifact Links
- **Production Audit Report:** [`Production_Audit.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/Production_Audit.md)
- **Monorepo Architecture History:** [`DEVELOPMENT_LOG.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/DEVELOPMENT_LOG.md) Section 5
- **Quality Assurance Verification:** [`tests.md`](file:///c:/Users/dk-32/OneDrive/Desktop/Adyuta-MP/tests.md) Section 9

---

## 📌 Suggested Paper Attachment Point
**Location:** Page 7, Column 1, Section VII, concluding paragraph.  
**LaTeX Footnote Suggestion:**
```latex
\footnote{Detailed risk analysis for all seven identified limitations and the engineering roadmap for WebSocket integration, TLS encryption, and field trial deployment are documented in \texttt{paper\_proofs/08\_Section\_VII\_Limitations\_and\_Future\_Work/README.md} and \texttt{Production\_Audit.md}.}
```

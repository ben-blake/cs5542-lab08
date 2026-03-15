# Individual Contribution Report — Tina Nguyen

**Course:** CS 5542 — Big Data Analytics
**Lab:** Lab 8 — Fine-Tuning and Domain Adaptation for GenAI Systems
**Date:** March 14, 2026

## Contributions

### Streamlit UI Integration
- Implemented the model selection sidebar in `src/app.py` with four modes: Cortex (Production), Baseline (Untrained Llama), Fine-Tuned (LoRA), and Compare Baseline vs Fine-Tuned
- Built the side-by-side comparison view that displays both baseline and fine-tuned SQL outputs simultaneously with execution results
- Added API status indicators in the sidebar showing connection state to the model server

### Data Preparation
- Prepared and validated the Olist dataset for instruction tuning
- Reviewed and verified the 82 instruction examples for correctness, ensuring SQL queries match the Olist schema and use proper Snowflake syntax
- Validated the golden query benchmark used as the source for training examples

### Testing and Quality Assurance
- Ran end-to-end testing of the Streamlit app with all four model modes
- Tested the fine-tuning pipeline on Google Colab, verifying training completion and adapter download
- Validated evaluation results and confirmed metrics accuracy
- Ran smoke tests to ensure Lab 8 additions did not break existing functionality

### Group Report and Documentation
- Co-authored the group report (LaTeX)
- Reviewed and edited the README and RUN.md for Lab 8
- Documented the step-by-step guide for running the project

## Percentage Contribution

**50%**

## GitHub Commits

| File | Description | Commit |
|------|-------------|--------|
| `src/app.py` | Added model selection sidebar and comparison mode | [`3a72f1d`](https://github.com/ben-blake/cs5542-lab08/commit/3a72f1d) |
| `data/instruction_dataset.json` | Reviewed and validated instruction examples | [`3a1d043`](https://github.com/ben-blake/cs5542-lab08/commit/3a1d043) |
| `data/instruction_train.json` | Training split validation | [`c26339f`](https://github.com/ben-blake/cs5542-lab08/commit/c26339f) |
| `data/instruction_val.json` | Validation split validation | [`f53ae8f`](https://github.com/ben-blake/cs5542-lab08/commit/f53ae8f) |
| `README.md` | Updated documentation for Lab 8 | [`bb92e06`](https://github.com/ben-blake/cs5542-lab08/commit/bb92e06) |
| `lab08_report.pdf` | PDF group report | [`29258bb`](https://github.com/ben-blake/cs5542-lab08/commit/29258bb) |

## AI Tools Used

**Anthropic Claude Code (claude-opus-4-6)** was used to assist with development:

- **Streamlit integration**: Claude Code helped scaffold the model selection UI and side-by-side comparison layout in the Streamlit app. The generated code was reviewed and customized to match the existing app design.
- **Testing support**: Claude Code assisted with identifying test scenarios and debugging issues encountered during end-to-end testing.
- **Documentation**: Claude Code helped draft sections of the README, RUN.md, and group report, which were then reviewed and edited for accuracy.

All AI-generated code was reviewed, tested, and validated before integration. The team is fully responsible for the final implementation.

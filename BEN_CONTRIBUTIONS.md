# Individual Contribution Report — Ben Blake

**Course:** CS 5542 — Big Data Analytics
**Lab:** Lab 8 — Fine-Tuning and Domain Adaptation for GenAI Systems
**Date:** March 14, 2026

## Contributions

### Instruction Dataset Creation
- Designed and implemented `scripts/create_instruction_dataset.py` to generate 82 Alpaca-format training examples
- Created 50 augmented SQL examples covering JOINs, aggregations, window functions, CTEs, date functions, HAVING clauses, and CASE expressions
- Processed 32 deduplicated examples from the golden query benchmark with fully qualified table names

### LoRA Fine-Tuning Implementation
- Built `scripts/fine_tune.py` for local LoRA/QLoRA training with HuggingFace Trainer and PEFT
- Created `notebooks/fine_tune_colab.ipynb` for QLoRA 4-bit fine-tuning on Google Colab T4 GPU
- Configured LoRA hyperparameters (r=16, alpha=32, target modules) and training arguments
- Trained and validated the adapter on Colab, achieving 100% SQL generation and qualified name usage

### FastAPI Model Server
- Built `scripts/api_server.py` serving both the untrained baseline and LoRA-adapted models simultaneously
- Implemented `/generate`, `/generate-baseline`, and `/health` endpoints
- Handled dual-model loading, prompt formatting, and SQL extraction from model outputs
- Resolved torch/numpy/PEFT version compatibility issues for local CPU inference

### Evaluation Pipeline
- Created `scripts/evaluate_adaptation.py` with 15 evaluation queries (5 easy, 5 medium, 5 hard)
- Added evaluation cells to the Colab notebook for GPU-accelerated baseline vs fine-tuned comparison
- Measured SQL validity, qualified table name usage, and latency metrics

### Colab Notebook
- Built end-to-end fine-tuning notebook with dataset upload, QLoRA training, evaluation, and adapter download
- Added 15-query evaluation section comparing baseline vs fine-tuned outputs directly in the notebook

## Percentage Contribution

**50%**

## GitHub Commits

| File | Description | Commit |
|------|-------------|--------|
| `scripts/create_instruction_dataset.py` | Instruction dataset generation (82 Alpaca-format examples) | [`54af82c`](https://github.com/ben-blake/cs5542-lab08/commit/54af82c) |
| `scripts/fine_tune.py` | Local LoRA/QLoRA fine-tuning script | [`e0d561a`](https://github.com/ben-blake/cs5542-lab08/commit/e0d561a) |
| `scripts/api_server.py` | FastAPI server serving baseline + fine-tuned models | [`7c17533`](https://github.com/ben-blake/cs5542-lab08/commit/7c17533) |
| `scripts/evaluate_adaptation.py` | Baseline vs fine-tuned evaluation pipeline (15 queries) | [`26e2217`](https://github.com/ben-blake/cs5542-lab08/commit/26e2217) |
| `src/utils/finetuned_client.py` | HTTP client for model API endpoints | [`eb74ce4`](https://github.com/ben-blake/cs5542-lab08/commit/eb74ce4) |
| `notebooks/fine_tune_colab.ipynb` | Colab notebook for QLoRA training + evaluation on T4 GPU | [`31165a1`](https://github.com/ben-blake/cs5542-lab08/commit/31165a1) |
| `config.yaml` | Added finetuned configuration section | [`a5e7d6c`](https://github.com/ben-blake/cs5542-lab08/commit/a5e7d6c) |

## AI Tools Used

**Anthropic Claude Code (claude-opus-4-6)** was the primary AI-assisted development tool used throughout this lab:

- **Code generation**: Claude Code assisted with scaffolding the fine-tuning script, FastAPI server, evaluation pipeline, and Colab notebook. Each generated file was reviewed for correctness and adapted to fit the existing project architecture.
- **Debugging**: Claude Code helped diagnose and resolve dependency conflicts (torch 2.2.2 / numpy / PEFT version mismatches, adapter config compatibility between PEFT 0.18.1 on Colab and 0.12.0 locally, torch._dynamo import errors).
- **Documentation**: Claude Code assisted with writing the README, RUN.md, CLAUDE.md updates, and the LaTeX group report.

All AI-generated code was reviewed, tested, and validated before integration. The team is fully responsible for the final implementation.

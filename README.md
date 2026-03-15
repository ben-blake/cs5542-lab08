# Lab 8: Fine-Tuning and Domain Adaptation for GenAI Systems

Analytics Copilot — a Text-to-SQL system that converts natural language questions into SQL queries against the Olist Brazilian E-Commerce dataset. Built with a three-agent pipeline on Snowflake Cortex LLM and extended with LoRA fine-tuning of CodeLlama-7B for domain adaptation.

**Demo**: [https://vimeo.com/1173679060](https://vimeo.com/1173679060)

## Team Members

- **Ben Blake** (GenAI & Backend Lead) - [@ben-blake](https://github.com/ben-blake)
- **Tina Nguyen** (Data & Frontend Lead) - [@tinana2k](https://github.com/tinana2k)

## Problem Statement

Non-technical users often depend on data analysts to write SQL queries or build dashboards, creating bottlenecks and slowing down decision-making. This system allows business users to ask questions in plain English and receive accurate SQL queries, result tables, and visualizations.

In Lab 8, we apply **domain adaptation** to improve SQL generation quality by fine-tuning a language model (CodeLlama-7B) on Olist-specific instruction data using **LoRA (Low-Rank Adaptation)**, and compare it against the untrained baseline.

## System Architecture

### Three-Agent Pipeline

1. **Schema Linker** — RAG-based retrieval over metadata to find relevant tables (Cortex Search)
2. **SQL Generator** — LLM-powered SQL generation with few-shot examples (Cortex Complete, llama3.1-70b)
3. **Validator** — EXPLAIN-based validation with self-correction retry loop (up to 3 attempts)

### Domain Adaptation Pipeline (Lab 8)

4. **Instruction Dataset** — 82 Alpaca-format examples (32 golden queries + 50 augmented SQL patterns)
5. **LoRA Fine-Tuning** — QLoRA 4-bit training of CodeLlama-7B-Instruct on the instruction dataset
6. **Model Server** — FastAPI serving both untrained baseline and LoRA-adapted models
7. **Evaluation** — 15-query benchmark comparing baseline vs fine-tuned on SQL quality metrics

```
┌──────────────────────────────────────────────────────────────────┐
│                        Streamlit UI                              │
│  Model selector: Cortex | Baseline | Fine-Tuned | Compare Mode   │
└────────────┬─────────────────────────────────┬───────────────────┘
             │                                 │
   ┌─────────▼──────────┐          ┌───────────▼────────────┐
   │  Cortex Pipeline    │          │  FastAPI Model Server   │
   │  (Schema Linker →   │          │  /generate (LoRA)       │
   │   SQL Generator →   │          │  /generate-baseline     │
   │   Validator)        │          │  (CodeLlama-7B)         │
   └─────────┬──────────┘          └───────────┬────────────┘
             │                                 │
             └──────────┬──────────────────────┘
                        │
               ┌────────▼────────┐
               │   Snowflake     │
               │   (Olist Data)  │
               └─────────────────┘
```

## Quick Start

### Smoke Tests (No Snowflake Needed)

```bash
git clone https://github.com/ben-blake/cs5542-lab08.git
cd cs5542-lab08
chmod +x reproduce.sh
./reproduce.sh --smoke
```

### Full Pipeline (Requires Snowflake)

```bash
cp .env.example .env   # Fill in Snowflake credentials
./reproduce.sh
```

## Step-by-Step Guide

### 1. Environment Setup

```bash
git clone https://github.com/ben-blake/cs5542-lab08.git
cd cs5542-lab08
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 2. Run Smoke Tests

```bash
source venv/bin/activate
python -m pytest tests/test_smoke.py -v --tb=short
```

### 3. Generate Instruction Dataset

```bash
source venv/bin/activate
python scripts/create_instruction_dataset.py
```

This creates:
- `data/instruction_dataset.json` — 82 Alpaca-format examples
- `data/instruction_train.json` — 90% training split
- `data/instruction_val.json` — 10% validation split

### 4. Fine-Tune the Model

**Option A: Google Colab (Recommended — Free T4 GPU)**

1. Upload `notebooks/fine_tune_colab.ipynb` to [Google Colab](https://colab.research.google.com)
2. Set runtime to **T4 GPU** (Runtime → Change runtime type → T4 GPU)
3. Upload `data/instruction_dataset.json` when prompted
4. Run all cells — training takes ~10-15 minutes on T4
5. The evaluation cells (Section 9) run 15 queries through both baseline and fine-tuned models
6. Download `fine_tuned_model.zip` and `adaptation_evaluation.json`
7. Unzip the adapter into `artifacts/fine_tuned_model/`

**Option B: Local (CPU — very slow, for testing only)**

```bash
source venv/bin/activate
python scripts/fine_tune.py --cpu --epochs 1
```

### 5. Start the Model API Server

```bash
source venv/bin/activate
python scripts/api_server.py --model-path artifacts/fine_tuned_model
```

This loads both models (~13GB RAM) and exposes:
- `POST /generate` — Fine-tuned (LoRA) inference
- `POST /generate-baseline` — Untrained base CodeLlama inference
- `GET /health` — Health check

### 6. Run Evaluation

In a **separate terminal** (with the API server running):

```bash
source venv/bin/activate
python scripts/evaluate_adaptation.py
```

This runs 15 queries (5 easy, 5 medium, 5 hard) through both models and outputs:
- Side-by-side PASS/FAIL comparison
- Execution accuracy, qualified table name usage, latency
- Results saved to `artifacts/adaptation_evaluation.json`

**Note:** On CPU, each query takes ~3-5 minutes. Use Colab (Step 4A) for faster evaluation.

### 7. Launch the Streamlit App

```bash
source venv/bin/activate
streamlit run src/app.py
```

Open `http://localhost:8501`. The sidebar offers 4 model options:
- **Cortex (Production)** — Snowflake Cortex llama3.1-70b
- **Baseline (Untrained Llama)** — Raw CodeLlama-7B without fine-tuning
- **Fine-Tuned (LoRA)** — CodeLlama-7B with LoRA adapter
- **Compare Baseline vs Fine-Tuned** — Side-by-side comparison view

## Repository Structure

```
cs5542-lab08/
├── src/
│   ├── agents/
│   │   ├── schema_linker.py       # RAG-based table retrieval
│   │   ├── sql_generator.py       # Cortex LLM SQL generation
│   │   └── validator.py           # EXPLAIN validation + self-correction
│   ├── utils/
│   │   ├── snowflake_conn.py      # Snowflake session management
│   │   ├── finetuned_client.py    # HTTP client for FastAPI model server
│   │   ├── viz.py                 # Auto-chart generation
│   │   ├── config.py              # Config loader with seed control
│   │   └── logger.py              # File + console logging
│   └── app.py                     # Streamlit chat interface (4 model modes)
├── scripts/
│   ├── create_instruction_dataset.py  # Generate 82 Alpaca-format examples
│   ├── fine_tune.py                   # LoRA fine-tuning (local)
│   ├── api_server.py                  # FastAPI: baseline + fine-tuned serving
│   ├── evaluate_adaptation.py         # Baseline vs fine-tuned evaluation
│   ├── ingest_data.py                 # CSV -> Snowflake ingestion
│   ├── build_metadata.py             # Cortex metadata generation
│   └── evaluate.py                    # Cortex pipeline evaluation
├── notebooks/
│   └── fine_tune_colab.ipynb          # Colab notebook (QLoRA on T4 GPU)
├── snowflake/                         # DDL scripts (01-05)
├── tests/
│   └── test_smoke.py                  # 18 offline smoke tests
├── data/
│   ├── olist/                         # 9 Olist CSVs (from Kaggle)
│   ├── instruction_dataset.json       # 82 fine-tuning examples
│   ├── instruction_train.json         # Training split (90%)
│   ├── instruction_val.json           # Validation split (10%)
│   └── golden_queries.json            # 50 benchmark question-SQL pairs
├── artifacts/
│   ├── fine_tuned_model/              # LoRA adapter weights
│   ├── adaptation_evaluation.json     # Baseline vs fine-tuned results
│   └── evaluation_report.json         # Cortex pipeline results
├── config.yaml                        # Runtime configuration
├── requirements.txt                   # Pinned dependencies
├── reproduce.sh                       # Single-command reproduction
└── .env.example                       # Credential template
```

## Instruction Dataset

82 Alpaca-format examples covering the Olist schema:

| Source | Count | Description |
|---|---|---|
| Golden queries | 32 | Deduplicated from 50 benchmark queries |
| Augmented | 50 | Hand-crafted covering JOINs, aggregations, window functions, CTEs, date functions, HAVING |

Format:
```json
{
  "instruction": "You are a Snowflake SQL expert...",
  "input": "How many orders are there?",
  "output": "SELECT COUNT(*) AS total_orders FROM ANALYTICS_COPILOT.RAW.ORDERS"
}
```

## Adaptation Method

- **Base model**: CodeLlama-7B-Instruct (`codellama/CodeLlama-7b-Instruct-hf`)
- **Method**: LoRA (Low-Rank Adaptation) with QLoRA 4-bit quantization
- **LoRA config**: r=16, alpha=32, dropout=0.05, target modules: q_proj, k_proj, v_proj, o_proj
- **Training**: 3 epochs, batch size 4, gradient accumulation 4, learning rate 2e-4
- **Hardware**: Google Colab T4 GPU (free tier)

## Evaluation

15 queries (5 easy, 5 medium, 5 hard) comparing:

| Metric | Baseline (Untrained) | Fine-Tuned (LoRA) |
|---|---|---|
| Generates valid SQL | Measured | Measured |
| Uses qualified table names | Measured | Measured |
| Average latency | Measured | Measured |

Results saved in `artifacts/adaptation_evaluation.json`.

## Datasets

1. **Olist Brazilian E-Commerce** (primary) — [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce): 100k orders across 9 relational tables
2. **Superstore Sales** (optional) — [Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

## Agentic AI Tool Usage

**Tool used:** Anthropic Claude Code (claude-opus-4-6)

| Task | Verified By |
|---|---|
| Instruction dataset generation script | Manual review + output validation |
| LoRA fine-tuning script | Colab training execution |
| FastAPI model server | API endpoint testing |
| Streamlit integration (4 model modes) | Manual UI testing |
| Evaluation pipeline | Execution on 15 queries |
| Colab notebook | End-to-end training + evaluation |

All generated code was reviewed, validated, and tested by the team.

## Configuration

All runtime parameters in `config.yaml`:

```yaml
finetuned:
  api_url: "http://localhost:8000"
  base_model: "codellama/CodeLlama-7b-Instruct-hf"
  lora_r: 16
  lora_alpha: 32
  training_epochs: 3
  model_path: "artifacts/fine_tuned_model"
  instruction_dataset: "data/instruction_dataset.json"
```

## Team Contributions

See [`BEN_CONTRIBUTIONS.md`](BEN_CONTRIBUTIONS.md) and [`TINA_CONTRIBUTIONS.md`](TINA_CONTRIBUTIONS.md) for detailed individual contributions.

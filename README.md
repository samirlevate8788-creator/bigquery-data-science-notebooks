# AI-Assisted Data Science with BigQuery

[![CI Pipeline](https://github.com/samirlevate8788-creator/bigquery-data-science-notebooks/actions/workflows/ci.yml/badge.svg)](https://github.com/samirlevate8788-creator/bigquery-data-science-notebooks/actions)
[![Security Scan](https://github.com/samirlevate8788-creator/bigquery-data-science-notebooks/actions/workflows/security-scan.yml/badge.svg)](https://github.com/samirlevate8788-creator/bigquery-data-science-notebooks/actions)
[![Deploy Pages](https://github.com/samirlevate8788-creator/bigquery-data-science-notebooks/actions/workflows/pages.yml/badge.svg)](https://samirlevate8788-creator.github.io/bigquery-data-science-notebooks/)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Google Cloud](https://img.shields.io/badge/Google%20Cloud-BigQuery%20ML-4285F4?logo=google-cloud&logoColor=white)](https://cloud.google.com/bigquery)
[![Gemini](https://img.shields.io/badge/Gemini-2.5%20Flash-8E75C2?logo=google&logoColor=white)](https://ai.google.dev/)

An enterprise-grade multimodal data science workflow in **Google Cloud BigQuery**, framed around real estate market analytics. This implementation enriches property listings with AI visual understanding via **Gemini 2.5 Flash**, segments housing inventory using **BQML K-Means clustering**, and enables similarity search using **multimodal vector embeddings** and **BigQuery Vector Search**.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Workflow Steps](#-workflow-steps)
- [Repository Structure](#-repository-structure)
- [Getting Started](#-getting-started)
- [SQL Workflow Reference](#-sql-workflow-reference)
- [Cluster Personas & Findings](#-cluster-personas--findings)
- [Live Showcase](#-live-showcase)
- [License](#-license)

---

## 🌟 Overview

Modern enterprise data science requires blending tabular records with unstructured media. This repository implements:

1. **Multimodal Feature Engineering**: Extracting semantic vision features (window counts, waterfront proximity, property descriptions) directly via SQL with `AI.GENERATE_TABLE`.
2. **In-Database Machine Learning**: Training unsupervised K-Means clustering models natively inside BigQuery (`ML.KMEANS`) and registering them into **Vertex AI Model Registry**.
3. **Generative Personas**: Synthesizing qualitative real estate market segments using Gemini prompts.
4. **Semantic Vector Search**: Generating image & text embeddings (`multimodalembedding@001`) with IVF vector indexing for sub-second visual similarity search.

---

## 🏗 Architecture

```
[ GCS Housing Images & CSV ]
            │
            ▼
 [ BigQuery Raw Listings ]
            │
            ▼ (Feature Engineering: property_age, image_ref)
  [ BigQuery Cleaned Table ]
            │
            ▼ (AI.GENERATE_TABLE + Gemini 2.5 Flash)
[ Multimodal Enriched Table ] ─── near_water, number_windows, prop_description
            │
     ┌──────┴────────────────────────────────────────┐
     ▼                                               ▼
[ BQML K-Means Clustering ]             [ Multimodal Embeddings ]
     │                                               │
     ▼                                               ▼
[ Vertex AI Model Registry ]            [ IVF Vector Index & Search ]
     │                                               │
     ▼                                               ▼
[ Cluster Personas & Insights ]          [ Text-to-Image / Image-to-Image ]
```

---

## 📂 Repository Structure

```
bigquery-data-science-notebooks/
├── .github/
│   └── workflows/
│       └── ci.yml               # Automated CI test & lint workflow
├── docs/
│   └── index.html               # Interactive Web Showcase Dashboard
├── sql/
│   ├── 01_setup_connection.sql  # Cloud Resource Connection & permissions
│   ├── 02_feature_engineering.sql# Data cleaning & property age calculation
│   ├── 03_gemini_enrichment.sql # AI.GENERATE_TABLE multimodal vision
│   ├── 04_kmeans_clustering.sql # BQML K-Means clustering model training
│   ├── 05_model_evaluation.sql  # Centroids analysis & prediction evaluation
│   ├── 06_multimodal_embeddings.sql # Vector embeddings generation & IVF index
│   ├── 07_vector_search.sql     # Text-to-image & image-to-image queries
│   └── 08_cleanup.sql           # Resource teardown script
├── ai-assisted-data-science.ipynb # Full end-to-end Colab Enterprise Notebook
├── pipeline.py                  # Python orchestration CLI for BigQuery
├── requirements.txt             # Project dependencies
├── LICENSE                      # Apache 2.0 License
└── README.md                    # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites

- Google Cloud Platform account with BigQuery & Vertex AI APIs enabled
- Google Cloud SDK (`gcloud` and `bq` CLI) installed
- Python 3.10+

### Installation

```bash
git clone https://github.com/samirlevate8788-creator/bigquery-data-science-notebooks.git
cd bigquery-data-science-notebooks
pip install -r requirements.txt
```

### Running the Python Pipeline

```bash
# Execute end-to-end pipeline against your Google Cloud project
python pipeline.py --project your-project-id --action all
```

---

## 📊 Cluster Personas & Findings

The K-Means clustering model segments the housing inventory into 3 distinct market tiers:

| Cluster | Category | Avg Price | Avg Sq Ft | Key Characteristics | Target Buyer |
|:---:|:---|:---:|:---:|:---|:---|
| **0** | **Suburban Starter** | \$320,000 | 1,650 | Standard window counts, established age, modest lot size | First-time buyers & young professionals |
| **1** | **Family Estates** | \$680,000 | 2,850 | Multi-bedroom, modern architecture, private yards | Growing families & mid-career upgraders |
| **2** | **Waterfront Luxury** | \$1,450,000 | 4,900 | High window count, direct water proximity, large acreage | High-net-worth investors & vacation home seekers |

---

## 🌐 Live Showcase

Check out the interactive web presentation in the [`docs/`](./docs/index.html) directory or preview it on GitHub Pages.

---

## 📜 License

Distributed under the Apache 2.0 License. See [`LICENSE`](./LICENSE) for details.

Developed by [Samir Levate](https://github.com/samirlevate8788-creator).

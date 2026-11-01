#!/usr/bin/env python3
"""
AI-Assisted Data Science with BigQuery Workflow Pipeline
Automates data extraction, feature engineering, clustering, and vector search.
"""

import argparse
import os
import sys
import time
from google.cloud import bigquery


def run_query(client: bigquery.Client, query: str, description: str) -> None:
    print(f"\n[+] Executing: {description}...")
    start_time = time.time()
    try:
        job = client.query(query)
        job.result()  # Wait for completion
        duration = time.time() - start_time
        print(f"[✓] {description} completed in {duration:.2f}s")
    except Exception as e:
        print(f"[✗] Error during {description}: {e}", file=sys.stderr)
        raise


def setup_dataset_and_tables(client: bigquery.Client, project_id: str) -> None:
    # Feature Engineering
    query_fe = f"""
    CREATE OR REPLACE TABLE `{project_id}.housing_dataset.listings` AS
    SELECT
      *,
      EXTRACT(YEAR FROM CURRENT_DATE()) - year_built AS property_age,
      OBJ.FETCH_METADATA(OBJ.MAKE_REF(house_uri, 'us.ai_connection')) AS image_ref
    FROM
      `{project_id}.housing_dataset.listings`
    WHERE sale_status = 'For Sale';
    """
    run_query(client, query_fe, "Feature Engineering (property_age & image_ref)")


def train_kmeans(client: bigquery.Client, project_id: str) -> None:
    query_kmeans = f"""
    CREATE OR REPLACE MODEL `{project_id}.housing_dataset.kmeans_clustering_model`
    OPTIONS(
      model_type='KMEANS',
      num_clusters=3,
      model_registry='VERTEX_AI',
      VERTEX_AI_MODEL_ID='housing_clustering'
    ) AS
    SELECT
      price, sq_ft, year_built, number_of_rooms, number_of_baths,
      acre_lot, property_age, near_water, number_windows
    FROM
      `{project_id}.housing_dataset.listings_multimodal`;
    """
    run_query(client, query_kmeans, "K-Means Clustering Model Training (k=3)")


def evaluate_clusters(client: bigquery.Client, project_id: str) -> None:
    query_eval = f"""
    SELECT
      centroid_id AS cluster,
      ROUND(AVG(price), 2) AS avg_price,
      ROUND(AVG(sq_ft), 2) AS avg_sq_ft,
      ROUND(AVG(property_age), 1) AS avg_age,
      COUNT(*) AS count
    FROM
      ML.PREDICT(MODEL `{project_id}.housing_dataset.kmeans_clustering_model`,
        TABLE `{project_id}.housing_dataset.listings_multimodal`)
    GROUP BY cluster
    ORDER BY cluster;
    """
    print("\n[+] Cluster Summary Profiles:")
    df = client.query(query_eval).to_dataframe()
    print(df.to_string(index=False))


def main():
    parser = argparse.ArgumentParser(description="BigQuery AI-Assisted Data Science Pipeline")
    parser.add_argument("--project", default=os.environ.get("PROJECT_ID", "bq-ds-lab-8051"), help="GCP Project ID")
    parser.add_argument("--action", choices=["all", "feature_engineering", "train", "eval"], default="all")
    args = parser.parse_args()

    client = bigquery.Client(project=args.project)

    if args.action in ["all", "feature_engineering"]:
        setup_dataset_and_tables(client, args.project)
    if args.action in ["all", "train"]:
        train_kmeans(client, args.project)
    if args.action in ["all", "eval"]:
        evaluate_clusters(client, args.project)

    print("\n[✓] Pipeline execution finished successfully!")


if __name__ == "__main__":
    main()

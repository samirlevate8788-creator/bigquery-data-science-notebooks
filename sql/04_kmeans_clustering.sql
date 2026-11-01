-- Step 4: Model Training with K-Means Clustering (BQML)
-- Registers the trained model into Vertex AI Model Registry as 'housing_clustering'

CREATE OR REPLACE MODEL `housing_dataset.kmeans_clustering_model`
OPTIONS(
  model_type = 'KMEANS',
  num_clusters = 3,
  model_registry = 'VERTEX_AI',
  VERTEX_AI_MODEL_ID = 'housing_clustering'
) AS
SELECT
  price,
  sq_ft,
  year_built,
  number_of_rooms,
  number_of_baths,
  acre_lot,
  property_age,
  near_water,
  number_windows
FROM
  `housing_dataset.listings_multimodal`;

-- Step 5: Model Evaluation and Cluster Summaries

-- 1. Evaluate clustering metrics (Davies-Bouldin index, Mean squared distance)
SELECT * FROM ML.EVALUATE(MODEL `housing_dataset.kmeans_clustering_model`);

-- 2. Inspect Centroids for key numeric features
SELECT * FROM ML.CENTROIDS(MODEL `housing_dataset.kmeans_clustering_model`)
WHERE feature IN ('price', 'property_age')
ORDER BY feature, centroid_id;

-- 3. Assign each listing to a cluster
CREATE OR REPLACE TABLE `housing_dataset.clustered_listings` AS
SELECT
  CENTROID_ID AS cluster,
  * EXCEPT(CENTROID_ID)
FROM
  ML.PREDICT(
    MODEL `housing_dataset.kmeans_clustering_model`,
    TABLE `housing_dataset.listings_multimodal`
);

-- 4. Aggregate cluster statistics for persona generation
SELECT
  centroid_id AS cluster,
  AVG(price) AS avg_price,
  AVG(sq_ft) AS avg_sq_ft,
  AVG(year_built) AS avg_year_built,
  AVG(number_of_rooms) AS avg_number_of_rooms,
  AVG(number_of_baths) AS avg_number_of_baths,
  AVG(acre_lot) AS avg_acre_lot,
  AVG(property_age) AS avg_property_age,
  AVG(number_windows) AS avg_number_windows,
  COUNT(*) AS cluster_size
FROM
  ML.PREDICT(MODEL `housing_dataset.kmeans_clustering_model`,
    TABLE `housing_dataset.listings_multimodal`)
GROUP BY
  cluster
ORDER BY
  cluster;

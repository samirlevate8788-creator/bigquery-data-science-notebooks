-- Step 8: Clean Up All Created Resources

-- Delete tables
DROP TABLE IF EXISTS `housing_dataset.listings`;
DROP TABLE IF EXISTS `housing_dataset.listings_multimodal`;
DROP TABLE IF EXISTS `housing_dataset.home_embeddings`;
DROP TABLE IF EXISTS `housing_dataset.clustered_listings`;

-- Delete models
DROP MODEL IF EXISTS `housing_dataset.gemini`;
DROP MODEL IF EXISTS `housing_dataset.kmeans_clustering_model`;
DROP MODEL IF EXISTS `housing_dataset.multimodal_embedding_model`;

-- Delete dataset
DROP SCHEMA IF EXISTS `housing_dataset` CASCADE;

-- Step 6: Multimodal Embeddings & Vector Index

-- 1. Create remote multimodal embedding model
CREATE OR REPLACE MODEL `housing_dataset.multimodal_embedding_model`
REMOTE WITH CONNECTION DEFAULT
OPTIONS (ENDPOINT = 'multimodalembedding@001');

-- 2. Generate multimodal embeddings for all house images
CREATE OR REPLACE TABLE `housing_dataset.home_embeddings` AS
SELECT
  id,
  price,
  sq_ft,
  prop_description,
  image_ref,
  ml_generate_embedding_result AS mm_embedding
FROM ML.GENERATE_EMBEDDING(
  MODEL `housing_dataset.multimodal_embedding_model`,
  (SELECT *, image_ref AS content FROM `housing_dataset.listings_multimodal`),
  STRUCT(TRUE AS flatten_json_output)
);

-- 3. Create Vector Index for accelerated similarity lookups
CREATE OR REPLACE VECTOR INDEX `house_images_index`
ON `housing_dataset.home_embeddings`(mm_embedding)
OPTIONS (
  index_type = 'IVF',
  distance_type = 'COSINE'
);

-- Step 7: Vector Search (Text-to-Image & Image-to-Image)

-- Query A: Text-to-Image Search (e.g. "house near the ocean")
SELECT
  base.id,
  base.price,
  base.sq_ft,
  base.prop_description,
  base.image_ref.uri AS image_uri,
  distance
FROM
  VECTOR_SEARCH(
    TABLE `housing_dataset.home_embeddings`,
    'mm_embedding',
    (
      SELECT
        ml_generate_embedding_result,
        content AS query
      FROM
        ML.GENERATE_EMBEDDING(
          MODEL `housing_dataset.multimodal_embedding_model`,
          (SELECT "house near the ocean" AS content)
        )
    ),
    top_k => 5
  )
ORDER BY distance ASC;

-- Query B: Image-to-Image Search (Find houses visually similar to a sample picture)
SELECT
  base.id,
  base.price,
  base.sq_ft,
  base.prop_description,
  base.image_ref.uri AS image_uri,
  distance
FROM
  VECTOR_SEARCH(
    TABLE `housing_dataset.home_embeddings`,
    'mm_embedding',
    (
      SELECT
        ml_generate_embedding_result,
        content AS query
      FROM
        ML.GENERATE_EMBEDDING(
          MODEL `housing_dataset.multimodal_embedding_model`,
          (
            SELECT OBJ.FETCH_METADATA(
              OBJ.MAKE_REF('gs://drw001-data-science-with-notebooks/images/test_image/house_test_image.jpg', 'us.ai_connection')
            ) AS content
          )
        )
    ),
    top_k => 5
  )
ORDER BY distance ASC;

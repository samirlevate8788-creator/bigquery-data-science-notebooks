-- Step 3: Multimodal Enrichment with Gemini Remote Model
-- Create remote model connecting BigQuery to Vertex AI Gemini
CREATE OR REPLACE MODEL `housing_dataset.gemini`
REMOTE WITH CONNECTION `us.ai_connection`
  OPTIONS(ENDPOINT = 'gemini-2.5-flash');

-- Enrich listings image metadata using AI.GENERATE_TABLE
CREATE OR REPLACE TABLE `housing_dataset.listings_multimodal` AS (
SELECT
  id,
  price,
  sq_ft,
  year_built,
  city,
  zipcode,
  number_of_rooms,
  number_of_baths,
  acre_lot,
  property_age,
  near_water,
  number_windows,
  prop_description,
  image_ref
FROM AI.GENERATE_TABLE(
  MODEL `housing_dataset.gemini`,
  (
    SELECT (
      'Analyze the following image to find whether it is near a body of water,'
      'the number of windows, and give a brief description of the property.',
      image_ref
    ) AS prompt,
    *
    FROM `housing_dataset.listings`
  ),
  STRUCT(
     "near_water BOOL, number_windows INT64, prop_description STRING" AS output_schema
  )
));

-- Step 2: Feature Engineering and Object References
-- Filter listings to 'For Sale', compute property_age, and extract image_ref metadata

CREATE OR REPLACE TABLE `housing_dataset.listings` AS
SELECT
  *,
  EXTRACT(YEAR FROM CURRENT_DATE()) - year_built AS property_age,
  OBJ.FETCH_METADATA(OBJ.MAKE_REF(house_uri, 'us.ai_connection')) AS image_ref
FROM
  `housing_dataset.listings`
WHERE sale_status = 'For Sale';

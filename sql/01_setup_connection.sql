-- Step 1: Create Cloud Resource Connection and Configure Permissions
-- Run via bq CLI:
-- bq mk --connection --location=us --connection_type=CLOUD_RESOURCE ai_connection

-- Show connection service account:
-- bq show --format=prettyjson --connection us.ai_connection

-- Grant IAM roles to connection service account:
-- gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:$SERVICE_ACCT_EMAIL --role='roles/storage.objectViewer'
-- gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:$SERVICE_ACCT_EMAIL --role='roles/aiplatform.user'

-- Create BigQuery dataset:
-- bq mk --dataset housing_dataset

-- Load raw data from GCS:
-- bq load --autodetect --source_format=CSV --skip_leading_rows=1 housing_dataset.listings gs://drw001-data-science-with-notebooks/tabular/housing-data.csv

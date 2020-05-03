region                          = "us-east-1"
environment_tag                 = "development"
project_tag                     = "lambda-arch"

# API Gataway
api_gtw_stage_name              = "api"
api_gtw_throttling_rate_limit   = 5
api_gtw_throttling_burst_limit  = 10
api_gtw_metrics_enabled         = true
api_gtw_logging_level           = "ERROR"
api_gtw_data_trace_enabled      = true

# Dynamo DB
dynamo_db_read_capacity         = 5
dynamo_db_write_capacity        = 5

# Lambda
lambda_api_key                  = "bf129c5257c9b850e2f442b5841b852042169a1c8efe82ecc749a08c58c5c9971816486849f098c6f307a06129cafc10ade7cfefd509dde22e83bfd93df5ce48d56a8a2f214cff337a660c092c3b48fd05d48c9c411ad7d25440a781f81af0a4d04fc9dab5b8f18bf89693d2533482bafd0bf3109135eb913014d2339eeca80019266ba1218c54257917feb2e9a6f828a9d6dd63383ae3d3aa2c18c56f38dc7e"
lambda_memory_size              = 256
lambda_timeout                  = 4

# Github
#github_token                    = "<Place your personal access token>"
#github_owner                    = "<Place your repository owner>"
#github_repo                     = "<Place your code repository>"
poll_source_changes             = "true"
github_branch                   = "develop"

# Code Pipeline
lambda_deploy_bucket            = "lambda-arch-app-bucket"
lambda_devops_bucket            = "lambda-arch-devops-bucket"
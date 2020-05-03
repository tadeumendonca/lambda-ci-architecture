
# -----------------------------------------------------------------------------
# Variables: General
# -----------------------------------------------------------------------------
variable "environment_tag" {
  type        = string
  description = "AWS Environment Tag for cost tracking"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "project_tag" {
  type        = string
  description = "AWS Project Tag for cost tracking"
}

# -----------------------------------------------------------------------------
# Variables: Dynamo DB
# -----------------------------------------------------------------------------
variable "dynamo_db_read_capacity" {
  type        = number
  description = "Dynamo DB Read Capacity"
}

variable "dynamo_db_write_capacity" {
  type        = number
  description = "Dynamo DB Read Capacity"
}

# -----------------------------------------------------------------------------
# Variables: API Gateway
# -----------------------------------------------------------------------------
variable "api_gtw_stage_name" {
  type        = string
  description = "API Gateway Service Stage Name"
}

variable "api_gtw_throttling_rate_limit" {
  type        = number
  description = "API Gateway Throttling Rate Limit"
}

variable "api_gtw_throttling_burst_limit" {
  type        = number
  description = "API Gateway Throttling Burst Limit"
}

variable "api_gtw_metrics_enabled" {
  type        = bool
  description = "API Gateway Metrics Enabled"
}

variable "api_gtw_logging_level" {
  type        = string
  description = "API Gateway Logging Level"
}

variable "api_gtw_data_trace_enabled" {
  type        = bool
  description = "API Gateway Data Tracing Enabled"
}

# -----------------------------------------------------------------------------
# Variables: CodePipeline
# -----------------------------------------------------------------------------
variable "github_token" {
  type        = string
  description = "Github OAuth token"
}

variable "github_owner" {
  type        = string
  description = "Github username"
}

variable "github_repo" {
  type        = string
  description = "Github repository name"
}

variable "github_branch" {
  type        = string
  description = "Github branch name"
  default     = "master"
}

variable "poll_source_changes" {
  type        = string
  default     = "false"
  description = "Periodically check the location of your source content and run the pipeline if changes are detected"
}

# -----------------------------------------------------------------------------
# Variables: CodeBuild
# -----------------------------------------------------------------------------
variable "build_image" {
  type        = string
  default     = "aws/codebuild/standard:2.0"
  description = "Docker image for build environment, e.g. 'aws/codebuild/standard:2.0' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html"
}

variable "build_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "Instance type of the build instance"
}

variable "build_timeout" {
  default     = 5
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed"
}

variable "badge_enabled" {
  type        = bool
  default     = false
  description = "Generates a publicly-accessible URL for the projects build badge. Available as badge_url attribute when enabled"
}

variable "privileged_mode" {
  type        = bool
  default     = false
  description = "(Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images"
}

variable "lambda_deploy_bucket" {
  type        = string
  description = "Lambda Deploy Bucket Name"
}

variable "lambda_devops_bucket" {
  type        = string
  description = "Lambda DevOps Bucket Name"
}

variable "lambda_api_key" {
  type        = string
  description = "Lambda API Key value"
}

variable "lambda_memory_size" {
  type        = number
  description = "Lambda Memory Size value"
}

variable "lambda_timeout" {
  type        = number
  description = "Lambda Timeout value"
}
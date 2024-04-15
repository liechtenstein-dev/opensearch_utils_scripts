variable "s3_bucket_destination" {
  description = "The S3 bucket to store the opensearch snapshots|logs|backups"
  type        = string
}

variable "domain_name" {
  description = "The domain name of the OpenSearch cluster"
  type        = string
}
data "aws_caller_identity" "current" {}

data "aws_elasticsearch_domain" "logs" {
  domain_name = "${var.domain_name}"
}

data "aws_s3_bucket" "tfstate_bucket" {
  bucket = "${var.s3_bucket_destination}"
}

resource "aws_iam_policy" "opensearch_s3_access_policy" {
  name        = "OpenSearchS3AccessPolicy"
  description = "Allows OpenSearch to bucket S3"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "${data.aws_s3_bucket.tfstate_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "${data.aws_s3_bucket.tfstate_bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "opensearch_s3_access_policy" {
  name               = "OpenSearch-S3-Access-Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

resource "aws_iam_role_policy_attachment" "attach_opensearch_s3_policy" {
  depends_on = [ aws_iam_role.opensearch_s3_access_policy ]
  policy_arn = aws_iam_policy.opensearch_s3_access_policy.arn
  role       = "OpenSearch-S3-Access-Role"
}
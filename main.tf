/**
 * # Terraform AWS Logging buckets module
 *
 * 以下リソースのアクセスログを保存するS3バケットを作成します。
 * バケットのアクセス権限が異なるため、それぞれバケットを分けています。
 * * ELB
 * * Cloudfront
 * * S3バケット
 * * SessionManager
 */

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  bucket_name_elb = "${var.tf.fullname}-elb-logs"
  bucket_name_cloudfront = "${var.tf.fullname}-cloudfront-logs"
  bucket_name_s3 = "${var.tf.fullname}-s3-logs"
  bucket_name_session_manager = "${var.tf.fullname}-session-manager-logs"
}

resource "aws_s3_bucket" "elb" {
  bucket = local.bucket_name_elb

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "elb" {
  bucket                  = aws_s3_bucket.elb.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
  depends_on = [
    aws_s3_bucket.elb
  ]
}

resource "aws_s3_bucket_policy" "elb" {
  bucket = aws_s3_bucket.elb.id

  # ELBアクセスログのS3出力権限は以下ドキュメントを参照 
  # [参照] https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::582318560864:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.elb.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.elb.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.elb.id}"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "cloudfront" {
  bucket = local.bucket_name_cloudfront

  # CloudfrontのログをS3に出力するためには、以下アカウントからのFULL_CONTROL付与が必要
  # [参照] https://docs.aws.amazon.com/ja_jp/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
  grant {
    id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudfront" {
  bucket                  = aws_s3_bucket.cloudfront.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
  depends_on = [
    aws_s3_bucket.cloudfront
  ]
}

resource "aws_s3_bucket" "s3" {
  bucket = local.bucket_name_s3
  # S3アクセスログの出力には規定ACLが用意されている
  # https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/acl-overview.html#canned-acl
  acl    = "log-delivery-write"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3" {
  bucket                  = aws_s3_bucket.s3.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
  depends_on = [
    aws_s3_bucket.s3
  ]
}

resource "aws_s3_bucket" "session_manager" {
  bucket = local.bucket_name_session_manager

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "session_manager" {
  bucket                  = aws_s3_bucket.session_manager.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
  depends_on = [
    aws_s3_bucket.session_manager
  ]
}

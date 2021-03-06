<!-- BEGIN_TF_DOCS -->
# Terraform AWS Logging buckets module

以下リソースのアクセスログを保存するS3バケットを作成します。
バケットのアクセス権限が異なるため、それぞれバケットを分けています。
* ELB
* Cloudfront
* S3バケット

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=3.74.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_in_development"></a> [in\_development](#input\_in\_development) | S3バケットにオブジェクトが残っていてもバケットごと強制削除されます | `bool` | `false` | no |
| <a name="input_tf"></a> [tf](#input\_tf) | Terraformアプリケーション情報 | <pre>object({<br>    name          = string<br>    shortname     = string<br>    env           = string<br>    fullname      = string<br>    fullshortname = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_cloudfront"></a> [bucket\_cloudfront](#output\_bucket\_cloudfront) | Cloudfront access log bucket |
| <a name="output_bucket_elb"></a> [bucket\_elb](#output\_bucket\_elb) | ALB/NLB access log bucket |
| <a name="output_bucket_s3"></a> [bucket\_s3](#output\_bucket\_s3) | S3 bucket access log bucket |
<!-- END_TF_DOCS -->    
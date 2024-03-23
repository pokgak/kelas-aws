data "aws_iam_policy_document" "list-s3-buckets" {
    statement {
        actions = [
        "s3:ListAllMyBuckets",
        ]
    
        resources = ["*"]
    }
}

resource "aws_iam_policy" "list-s3-buckets" {
    name        = "list-s3-buckets"
    description = "List S3 buckets"
    policy      = data.aws_iam_policy_document.list-s3-buckets.json
}
resource "aws_iam_role" "test_service" {
    name = "test-service"
    assume_role_policy = data.aws_iam_policy_document.test_service_assume_role_policy.json
}

data "aws_iam_policy_document" "test_service_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::058264261389:user/pokgak",
        "arn:aws:iam::058264261389:user/nazhan",
      ]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "test_service" {
    role       = aws_iam_role.test_service.name
    policy_arn = aws_iam_policy.list-s3-buckets.arn
}

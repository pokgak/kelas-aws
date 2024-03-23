resource "aws_iam_user" "pokgak" {
  name = "pokgak"
}

resource "aws_iam_user" "nazhan" {
  name = "nazhan"
}

resource "aws_iam_user_policy_attachment" "pokgak-list-s3-buckets" {
    user       = aws_iam_user.pokgak.name
    policy_arn = aws_iam_policy.list-s3-buckets.arn
}

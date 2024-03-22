resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group_membership" "developers" {
  name = "developers-group-membership"

  users = [
    aws_iam_user.pokgak.name,
    aws_iam_user.nazhan.name,
  ]

  group = aws_iam_group.developers.name
}

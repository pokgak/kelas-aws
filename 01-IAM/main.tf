provider "aws" {
  profile = "pokgak-prod"
}

resource "aws_iam_user" "pokgak" {
  name = "pokgak"
}

resource "aws_iam_user" "nazhan" {
  name = "nazhan"
}

resource "aws_iam_group" "developers" {
  name = "tester"
}

resource "aws_iam_group_membership" "developers" {
  name = "developers-group-membership"

  users = [
    aws_iam_user.pokgak.name,
    aws_iam_user.nazhan.name,
  ]

  group = aws_iam_group.developers.name
}


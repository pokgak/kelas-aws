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

data "aws_iam_policy_document" "assume_role" {
    statement {
      actions = ["sts:AssumeRole"]
      resources = [
        "arn:aws:iam::058264261389:role/test-service" 
      ]
    }
}

resource "aws_iam_policy" "assume_role" {
    name        = "test-service-assume-role"
    policy      = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_group_policy_attachment" "assume_role" {
    group       = aws_iam_group.developers.name
    policy_arn = aws_iam_policy.assume_role.arn
}

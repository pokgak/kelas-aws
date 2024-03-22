resource "aws_iam_user" "pokgak" {
  name = "pokgak"
}

resource "aws_iam_user" "nazhan" {
  name = "nazhan"
}

# grant permission to the pokgak user to list EKS clusters
data "aws_iam_policy_document" "list-eks" {
    statement {
        actions = [
        "eks:ListClusters",
        ]
    
        resources = ["*"]
    }
}

resource "aws_iam_policy" "list-eks" {
    name        = "list-eks"
    description = "List EKS clusters"
    policy      = data.aws_iam_policy_document.list-eks.json
}

resource "aws_iam_user_policy_attachment" "pokgak-list-eks" {
    user       = aws_iam_user.pokgak.name
    policy_arn = aws_iam_policy.list-eks.arn
}

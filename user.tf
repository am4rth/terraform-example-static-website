
resource "aws_iam_user" "my_user" {
  name = "my-bucket-user"
  path = "/"
}

resource "aws_iam_access_key" "my_user" {
  user = aws_iam_user.my_user.name
}

output "user_name" {
  value = aws_iam_user.my_user.name
}

output "user_access_key" {
  value = aws_iam_access_key.my_user.id
}

output "user_secret_key" {
  value = aws_iam_access_key.my_user.secret
  sensitive = true
}

data "aws_iam_policy_document" "allow_s3_upload" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.www_bucket.arn}",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:*Object",
    ]

    resources = [
      "${aws_s3_bucket.www_bucket.arn}/*",
    ]
  }
}

resource "aws_iam_user_policy" "s3_policy" {
  user = aws_iam_user.my_user.name
  policy = data.aws_iam_policy_document.allow_s3_upload.json
}

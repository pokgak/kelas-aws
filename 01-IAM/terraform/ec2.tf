resource "aws_iam_instance_profile" "test_service" {
  name = "test-service"
  role = aws_iam_role.test_service.name
}

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "test" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = "t2.micro"

  key_name = "pokgak-playground"
  iam_instance_profile = aws_iam_instance_profile.test_service.name

  tags = {
    Name = "test"
  }
}


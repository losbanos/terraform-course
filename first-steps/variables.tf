variable "instance_type" {
  type    = map
  default = {
    example = "t3.micro"
    example1 = "t4.micro"
  }
}

variable "aws_region" {
  default = "ap-northeast-2"
}
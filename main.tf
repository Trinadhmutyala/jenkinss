provider "aws" {
    region = "us-east-1"  
}

resource "aws_instance" "foo" {
  ami           = "ami-0453ec754f44f9a4a" # us-west-2
  instance_type = "t2.micro"
  tags = {
      Name = "TFtri-Instance"
  }
}

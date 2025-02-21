provider "aws" {
    region = "ap-southeast-1"  
}

resource "aws_instance" "terraform_jenkins_lab" {
  ami           = "ami-039454f12c36e7620"
  instance_type = "t2.micro"
  tags = {
      Name = "TF-Instance"
  }
}

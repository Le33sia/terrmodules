packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}
variable "region" {
  type    = string
  default = "us-west-2"
}


source "amazon-ebs" "test" {
  ami_name = "test" 
  source_ami = "ami-07bff6261f14c3a45" 
  instance_type = "t2.micro"
  region = "us-west-2"
  ssh_username = "ec2-user"
}

build {
  sources = [
    "source.amazon-ebs.test"
  ]
 
  provisioner "file" {
    source = "./info.php"
    destination = "/tmp/info.php" 

  }
  provisioner "shell" {
    script = "./app.sh"
  }
} 



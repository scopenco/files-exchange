# Variables, should be changed

variable "public_key_path" {
  description = "Path to the SSH public key to be used for authentication. Should be generated localy."
  default     = "~/Downloads/keys/us-west-2-test.pub"
}

variable "key_name" {
  description = "Desired name of AWS key pair to be created"
  default     = "us-west-2-test"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}

# RHEL 7.3
variable "aws_amis" {
  default = {
    us-west-1 = "ami-2cade64c"
    us-west-2 = "ami-6f68cf0f"
  }
}

variable "chef_env" {
  description = "Chef Server environment"
  default     = "myenv"
}

variable "chef_node_name" {
  description = "Node name that will be registered on Chef Server"
  default     = "fe.domain.com"
}

variable "chef_data_bag_secret" {
  description = "Path to data bag secret file for encripted data bags"
  default     = "~/.chef/data_bag_secret"
}

variable "chef_url" {
  description = "Chef Server URL"
  default     = "https://chefserver.mydomain.com/organizations/org1"
}

variable "chef_user_id" {
  description = "User in Chef Server"
  default     = "chefserver_user"
}

variable "chef_user_key" {
  description = "Path to user key in Chef Server"
  default     = "~/Downloads/keys/chefserver_user.key"
}


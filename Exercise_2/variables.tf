# Define the variable for aws_region
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "archive_path" {
  type    = string
  default = "greet_lambda.zip"
}

variable "runtime" {
  type    = string
  default = "python3.8"
}

variable "greeting_msg" {
  type    = string
  default = "Hello Europe!"
}

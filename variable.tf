variable "ami" {
  default = "ami-0e5f882be1900e43b"
  type = string
}

variable "type" {
  default = "t2.micro"
  type = string
}
 
 variable "key_pair" {
  default = "root-server2-london"
   
 }
variable "availability_zone" {
    type ="map"
    default = {
        "a" = "eu-west-2a"
        "b" = "eu-west-2b"

    }
  
}
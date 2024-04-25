variable "mykey" {
  default = "son"
}
variable "myami" {
  # default = "ami-0022f774911c1d690"
  default = "ami-0a3c3a20c09d6f377"
 
}
variable "instancetype" {
  default = "t3a.medium"
}
variable "tag" {
  default = "Jenkins_Server"
}
variable "jenkins-sg" {
  default = "jenkins2-server-security-group"
}
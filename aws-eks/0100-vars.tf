variable "AwsRegion" {
  type = "string"
}
variable "K8sClusterName" {
  type    = "string"
}
variable "VpcId" {
  type = "string"
}

variable "MinNumberOfWokerNodes" {
  type = "string"
}

variable "MaxNumberOfWokerNodes" {
  type = "string"
}

variable "InstanceType" {
  type = "string"
}

variable "DependsOn" {
  type = "list"
  default=[]
}
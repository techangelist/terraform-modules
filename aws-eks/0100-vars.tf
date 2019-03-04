variable "AwsRegion" {
  type = "string"
}
variable "K8sClusterName" {
  type    = "string"
}
variable "VpcStatePath" {
  type    = "string"
}
variable "VpcStateRegion" {
  type    = "string"
}

variable "VpcStateBucket" {
  type    = "string"
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
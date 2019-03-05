variable "AwsRegion" {
  type = "string"
}

variable "K8sClusterName" {
  type    = "string"
}

variable "VpcName" {
  type    = "string"
}

variable "VpcCidr" {
  type = "string"
}

variable "PrivateSubnets" {
  type = "list"
}

variable "PublicSubnets" {
  type = "list"
}

variable "AvailabilityZones" {
  type = "list"
}

variable "Tags" {
  type = "map"
  description = "A map of tags to add to all resources"
}

variable "DependsOn" {
  type = "list"
  default=[]
}

variable "EnableDnsHostNames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = false
}

variable "inst_type" {
  type        = string
  description = "AWS instance type for the worker(s)"
}

variable "key_name" {
  type        = string
  description = "Name of public ssh key used for AWS EC2 instances"
}

variable "sg_groups" {
  type        = list(any)
  description = "List of EC2 service groups to assign to worker nodes"
}

variable "worker_count" {
  type        = number
  description = "Number of workers"
}

variable "stream_workergroup" {
  type        = string
  default     = "default"
  description = "Name of the Cribl worker group to add the workers to.  Defaults to \"default\" or whatever the mapping applies"
}

variable "stream_token" {
  type        = string
  default     = "logstream_leader"
  description = "Cribl leader auth token.  Defaults to \"logstream_leader\""
}

variable "stream_install" {
  type        = string
  default     = "/opt/cribl"
  description = "Install location for Cribl.  Defaults to \"/opt/cribl\""
}

variable "stream_leader" {
  type        = string
  default     = ""
  description = "DNS Name or IP of the Leader that worker(s) should join"
}

variable "ssh_private_key" {
  type        = string
  default     = "~/.ssh/id_rsa"
  description = "Location of private ssh key.  Defaults to use id_rsa in the users home directory"

}

variable "worker_vpc_id" {
  type        = string
  description = "VPC to use for Cribl worker nodes"
}

variable "worker_ami" {
  type        = string
  description = "AMI to use instead of the default Amazon Linux AMI"
  default     = null
}
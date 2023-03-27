variable "inst_type" {
  type        = string
  description = "AWS instance type for the worker(s)"
}

variable "key_name" {
  type        = string
  description = "Name of public ssh key used for AWS EC2 instances"
}

variable "existing_sg_groups" {
  type        = list(any)
  default     = []
  description = "List of existing EC2 security groups to assign to worker nodes (Takes priority over cribl_service_ports)"
}

variable "worker_count" {
  type        = number
  description = "Number of workers to deploy"
}

variable "cribl_workergroup" {
  type        = string
  default     = "default"
  description = "Name of the Cribl worker group to add the workers to.  Defaults to \"default\" or whatever the mapping applies"
}

variable "cribl_token" {
  type        = string
  default     = "logstream_leader"
  description = "Cribl leader auth token.  Defaults to \"logstream_leader\""
}

variable "cribl_install" {
  type        = string
  default     = "/opt/cribl"
  description = "Install location for Cribl.  Defaults to \"/opt/cribl\""
}

variable "cribl_leader" {
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

variable "worker_service_ports" {
  type        = list(any)
  description = "TCP ports to include the new security group"
}

variable "cribl_cloud_instance" {
  type        = string
  default     = ""
  description = "Name of Cribl Cloud Instance, if adding worker nodes to cloud instance"
}

variable "cribl_tls" {
  type        = string
  default     = "yes"
  description = "Should the on-prem worker to leader communication be over TLS"
}

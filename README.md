# criblworker
Terraform module for creating Cribl workers and adding them to an existing leader and worker group

**This is a WIP in progress!**

## To Test This Module
This module is still under development and has not been published anywhere besides my personal github account.  

Example Code to use this module:
```
provider "aws" {
  profile = "default"
  region  = "us-east-2"
} 

module "myworkers" {
  source              = "github.com/ryhennessy/criblworker"
  inst_type           = "t3.micro"
  key_name            = "my_ssh_key"
  worker_count        = 1
  stream_leader       = "34.221.82.180"
  worker_vpc_id       = "vpc-0fbd644aa081265e4"
  cribl_service_ports = ["22", "9000", "9997", "9514"]
}
```

All the values of in the example above will need to be changed/validated.   Confirm that you have the correct profile and region in the aws standza.   The variables for the module will need to be changed/validated as well.  For a full list of all the options that can be supplied to this module check out the "Module Variables" section below.


## Module Variables
Below is the full list of variables/descriptions that can be used for this module. 

| Variable | Type | Default Value | Description |
|--------- | ---- | ------------- | ------------|
| inst_type | String |  *None* | AWS instance type for the worker(s) |
| existing_sg_groups | List |  *None* | List of existing EC2 security groups to assign to worker nodes (Takes priority over cribl_service_ports) |
| worker_count | number | *None* | Number of workers to deploy |
| stream_workergroup | string | default | Name of the Cribl worker group to add the workers to.  Defaults to "default" or whatever the mapping applies |
| stream_token | string | logstream_leader | Cribl leader auth token.  Defaults to "logstream_leader" |
| stream_install | string | /opt/cribl | Install location for Cribl.  Defaults to "/opt/cribl" |
| stream_leader | string | *None* | DNS Name or IP of the Leader that worker(s) should join |
| ssh_private_key | string | ~/.ssh/id_rsa | Location of private ssh key.  Defaults to use id_rsa in the users home directory |
| worker_vpc_id | string | *None* |  VPC to use for Cribl worker nodes |
| worker_ami | string | null | Custom AMI to use for the worker nodes. If not supplied the module will use the latest Amazon Linux AMI |
| cribl_service_ports | list | *None* | Creates a **new** security group and assigns the ports listed to it |



## Items still be investigated or worked on 
There are still a few items that are being investigated as additional functionalites for this module.  If you would like to add something to this list please open an issue or contact me.
 * add tags to the install worker template
 * add worker nodes to a new/existing LB config
 * add submoduules for creating the same worker groups in GCP and Azure
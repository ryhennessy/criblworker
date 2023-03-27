# criblworker
Terraform module for creating Cribl workers and adding them to an existing leader and worker group

**This is an active project and will be updated as enhancements, fixes, etc, are developed.**

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
  cribl_leader       = "1.1.1.1"
  worker_vpc_id       = "vpc-0fbaasdfsdf2dfd"
  worker_service_ports = ["22", "4200", "9000", "9997", "9514"]
}
```

Copy and paste the above example into a file named 'main.tf' in an empty folder/directory.  All the values in the example above will need to be changed/validated.   Confirm that you have the correct profile and region in the aws section.   The variables for the module will need to be changed/validated as well.  For a full list of all the options that can be supplied to this module, check out the "Module Variables" section below.

Once you have all the correct settings applied in the module.   You can run the following two commands.

This will pull down all the required information to run this Terraform code.
```
terraform init
```

This will apply the module.  The output will list all the changes that will be made.  At the end you are prompted to approve those changes (ie. Create the workers).  
```
terraform apply
```


## Module Variables
Below is the full list of variables and descriptions that can be used for this module. 

| Variable | Type | Default Value | Description |
|--------- | ---- | ------------- | ------------|
| inst_type | String |  *None* | AWS instance type for the worker(s) |
| existing_sg_groups | List |  *None* | List of existing EC2 security groups to assign to worker nodes (Takes priority over cribl_service_ports) |
| worker_count | number | *None* | Number of workers to deploy |
| cribl_workergroup | string | default | Name of the Cribl worker group to add the workers to.  Defaults to "default" or whatever the mapping applies |
| cribl_token | string | logstream_leader | Cribl leader auth token.  Defaults to "logstream_leader" |
| cribl_install | string | /opt/cribl | Install location for Cribl.  Defaults to "/opt/cribl" |
| cribl_leader | string | *None* | DNS Name or IP of the Leader that worker(s) should join |
| cribl_tls | string | yes | Use TLS when registering to a non-cloud Leader. Any value besides the default will turn off TLS |
| ssh_private_key | string | ~/.ssh/id_rsa | Location of private ssh key.  Defaults to use id_rsa in the users home directory. Used for loging into machines to do post install tasks |
| worker_vpc_id | string | *None* |  VPC to use for Cribl worker nodes.  The module will loop and add workers to subnets in supplied VPC |
| worker_ami | string | null | Custom AMI to use for the worker nodes. If not supplied the module will use the latest Amazon Linux AMI |
| worker_service_ports | list | *None* | Creates a **new** security group and assigns the ports listed to it |
| cribl_cloud_instance | string | *None* | Register created Cribl Worker Nodes to Cribl Cloud Instance. (Takes priority over cribl_leader. example value: "main-asdf-asdf-asdf") |



## Items still be investigated or worked on 
There are still a few items that are being investigated as additional functionalites for this module.  If you would like to add something to this list please open an issue or contact me.
 * add tags to the install worker template
 * add worker nodes to a new/existing LB config
 * add submoduules for creating the same worker groups in GCP and Azure
 * Test default image/type for graviton use cases
 * option to add workers to an auto scaling group.
 * add option to pull the content from local repo vs CDN.
 * add option to deploy the worker in a specific AZ/Subnet.
 * add flag to deploy with a leader not using TLS.

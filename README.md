# criblworker
Terraform module for creating Cribl workers and adding them to an existing leader and worker group

**This is a WIP in progress!**

## To Test This Module
This module is still under development and has not been published anywhere.  In order to use the module you will need to pull the module locally and reference it that way.

To pull the module locally run the following command.
```
git clone https://github.com/ryhennessy/criblworker.git
```

Once you have the module locally you will need to create a terraform file similar to the one below. The example assumes that you will be running the terraform code in the parent directory where the module was downloaded.


Example Code:
```
provider "aws" {
  profile = "default"
  region  = "us-east-2"
} 

module "myworkers" {
  source        = "../criblworker"
  inst_type     = "t3.micro"
  key_name      = "<name of the Security Group Key""
  sg_groups     = ["sg-234jadl32dsdf"]
  worker_count  = 3  // Number of Cribl Workers you would like
  stream_leader = "<Existing Leader IP or DNS name>""
  worker_vpc_id = "vpc-0fasdf334sadfdsf""
}

```

You will need to validate the profile and region in the AWS stanza.   All the values of the module will need to be changed/validated as well.  These are not all the variables that you can use for the module.  For now, you can see all the variables you can use 
for the module by viewing the variables.tf file in the modules directory.

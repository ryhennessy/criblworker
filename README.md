# criblworker
Terraform module for creating Cribl workers and adding them to an existing leader and worker group

**This is a WIP in progress!**

## To Test This Module
This module is still under devlopment and has not been published anywhere.  In order to use the module you will need to pull the module locally and reference it that way.

To pull the module locally run the following command.
```
git clone https://github.com/ryhennessy/criblworker.git
```

Once you have the module locally you will need to create a create a terraform file simlar to the one below.  The example assumes that you will be running the terraform code in the parent directory where the module was downloaded.

Example Code:
```
provider "aws" {
  profile = "default"
  region  = "us-east-2"
} 

module "myworkers" {
  source        = "../criblworker"
  inst_type     = "t3.micro"
  key_name      = "hennessy"
  sg_groups     = ["sg-0700f7f57dc2a2bb3"]
  worker_count  = 3
  stream_leader = "34.221.82.180"
  worker_vpc_id = "vpc-0fbd644aa081265e4"
}

```




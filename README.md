****HEST JOB ASSESSMENT****

This Repo Contains the terraform scripts to provision Resources in AWS Cloud.

The ****main.tf**** contains the main scripts to provision,

1.VPC

2.Public and Private Subnet (In different availability Zones)

3.Elastic Ip for NAT Gateway

4.NAT and Internet Gateway 

5.Route Tables And Route Tables Association

6.Frontend(Public) and Backend(Private) Security Groups 

7.TWO VMs (Webserver in Public Subnet and Database Server in Private Subnet)

The ****output.tf**** is used to output out the public ip addresses of the instances in  **main.tf** 

The ****provider.tf**** contains AWS Cloud Provider 

The ****variable.tf**** contains the environment variables I used it in **main.tf** 

**
**PREREQUISITES****

AWS ACCOUNT

AWSCLI

IAM USER WITH ADMIN ACCESS

TERRAFORM

**TO PROVISION THE RESOURCES**

terraform init 

terraform apply -auto-approve

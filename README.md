# Architecture

![image architecture](cloud_hw_1_architecture.jpg)

- client can create compute and network resources using Terraform service account
- terraform needs S3 Bucket and YDB to synchronize current configuration state 
- client can connect to VM via ssh using public IP address

# Run
- create terraform.tfvars with specifying variables: 
    - folder_id
    - image_id (with crawler set up as in https://github.com/leapsky/bookspider)
    - zone (optional) 

- terraform init

- terraform plan

- terraform apply

- terraform destroy

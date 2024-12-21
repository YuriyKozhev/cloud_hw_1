# Architecture

![image architecture](cloud_architecture.jpg)

- client can create compute and network resources using Terraform service account
- terraform needs S3 Bucket and YDB to synchronize current configuration state 
- client can connect to VM via ssh using public IP address
- client can create MySQL cluster, Redis cluster and start concurrently parse and save website data to the database using Terraform service account

# Run
- create terraform.tfvars with specifying variables: 
    - folder_id
    - image_id
    - zone (optional) 
    - ssh_key
    - user_name (optional)
    - db_user_name (optional)
    - db_user_pass
    - db_name (optional)
    - db_table_name (optional)
    - workers_count (optional)

- terraform init

- terraform plan

- terraform apply
    - the Urls2queueSpider starts saving page numbers to the Redis queue
    - the BookspiderSpider workers start reading pages from the Redis queue and parse items from the pages which are later saved to the MySql database

- terraform destroy

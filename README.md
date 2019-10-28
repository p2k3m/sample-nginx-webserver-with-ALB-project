sample-nginx-webserver-with-ALB-project
Above Creates
● An EC2 instance of type t2.micro based on any linux distro. 
● A Load Balancer forwarding incoming requests to the EC2 instance. 
 
The EC2 instance needs to run an Nginx web server serving one HTML file (just make one                 up and make the file part of your Github repo). Please create a README.md file inside your                 repository documenting your project. 

command to run terraform - 
terraform import aws_default_vpc.default vpc-aae1fecc

terraform init -backend-config="infrastructure-prod.config"
terraform plan -var-file="production.tfvars"
terraform apply -var-file="production.tfvars"
terraform destroy -var-file="production.tfvars"


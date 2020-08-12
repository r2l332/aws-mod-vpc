name              = "eks"
region            = "eu-west-1"
create_network    = true
vpc_cidr          = "10.0.0.0/16"
pub_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
priv_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
bucket_name       = ""
ddb_name          = ""
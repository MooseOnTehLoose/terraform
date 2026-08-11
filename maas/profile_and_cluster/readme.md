## Creating a Basic Profile and Cluster in MaaS using Terraform

Create a .env file in the directory with your Spectro API Key:

\# .env file  
export TF_VAR_spectro_api_key="API_KEY"

Run a Terraform Init, load the .env file and deploy the example:

```bash
terraform init
source .env
terraform plan -out
terraform apply
```

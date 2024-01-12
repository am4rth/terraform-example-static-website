# Terraform example for static websites

## Getting started

Clone repo and init terraform

```bash
git clone https://github.com/am4rth/terraform-example-static-website.git
cd terraform-example-static-website

terraform init
```

Copy the config example and set your values

```bash
cp example_vars myvars.tfvars
```

Plan the changes and apply them

```bash
terraform plan -var-file myvars.tfvars -out myplan
terrafrom apply myplan
```

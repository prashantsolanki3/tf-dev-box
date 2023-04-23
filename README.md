<!--ts-->
- [Bootstrap VM Terraform](#bootstrap-vm-terraform)
  - [Preparation](#preparation)
  - [Running the Module](#running-the-module)
<!--te-->

# Bootstrap VM Terraform

Deploy a Bootstrap VM in Proxmox to run basic services like github runner for the Host infrastructure.

## Preparation

Note: This method requires an ubuntu vm template. To create a compatible vm programtically refer to [proxmox-ubuntu-vm-template](https://github.com/prashantsolanki3/proxmox-ubuntu-vm-template)
- Create terraform.tfvars (in the same directory as main.tf)

```
nano terraform.tfvars
```

- Check variables.tf, read the descriptions and add the required variables to env.tfvars. The env.tfvars file should look something like this:

```
PROXMOX_IP                     = "PROXMOX_IP"
PM_API_TOKEN_ID                = "proxmox-token-id"
PM_API_TOKEN_SECRET            = "proxmox-token-secret"
.
.
.
# Other Variables
```

## Running the Module

- (First Run) Initialise the Project: Installs the required dependencies.

```
terraform init
```

- Plan the deployment

```
terraform plan
```

- Apply the changes

WARNING: This would actually update the resources on Proxmox.

```
terraform apply
```
- Destroy the VMs

```
terraform destroy
```


<!-- ### Generate Ansible Inventory

Ansible inventory is created in `ansible/inventory` upon completion of the terraform deployment is complete.

You can manually configure and run any Ansible playbooks.

#### Ansible

Run Playboon on the specified inventory

Note: The comma (,) at the end is required.
```
ansible all -i <ip>,
``` -->
# Infrastructure Bicep Files

The Bicep files in this directory are provided as **samples** for reference purposes only.

- `prep-az-resource-gpt5.bicep` — Provisions Azure AI Search, Storage Account, and Azure OpenAI (GPT-5 + text-embedding-3-large)
- `prep-az-resource-gpt41.bicep` — Same resources with GPT-4.1 instead of GPT-5

These templates are **not required** to run the sample. You are free to provision the Azure resources in any way you prefer (e.g., Azure Portal, Azure CLI, Terraform, etc.).

## Deployment

To deploy a template, run:

```bash
az deployment group create --resource-group <resource group name> --template-file prep-az-resource-gpt<xx>.bicep
```

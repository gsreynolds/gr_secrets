SUBSCRIPTION=""
VAULTNAME=""
LOCATION=""
RGNAME=""

az account set --subscription $SUBSCRIPTION
az group create -n $RGNAME -l $LOCATION
az provider register -n Microsoft.KeyVault
az keyvault create --name $VAULTNAME --resource-group $RGNAME --location $LOCATION
az keyvault secret set --vault-name $VAULTNAME --name "test-secret" --value "test1234"
az keyvault set-policy --name $VAULTNAME --resource-group $RGNAME --secret-permissions get list --object-id $(az vm identity show -g $RGNAME -n xenial-vm | jq -r '.principalId')

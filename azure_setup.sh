REGION="eu-west-1"
VAULTNAME="$USER-vault"
LOCATION="northeurope"
RGNAME="kitchen-$USER-secrets"

echo $RGNAME
echo $LOCATION
echo $VAULTNAME

az group create -n $RGNAME -l $LOCATION
az identity create -g $RGNAME -n $VAULTNAME-identity
az identity show --name $VAULTNAME-identity --resource-group $RGNAME | jq -r '.id'

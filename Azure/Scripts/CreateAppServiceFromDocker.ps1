# Name for our resource group
$rgName= "RGdockerMySQL"

# Name for our app
$appName="AppServiceDocker_$random"

# if you want see all available location and his available products
#Get-AzureRmLocation |Format-Table in Azure PowerShell
$location="westeurope"

# Docker image what we want (https://hub.docker.com/_/mysql)
dockerHubContainerPath="mysql:latest"

# Create a Resource Group
az group create --name $rgName --location $location

# Create an App Service Plan based on Basic 1 (Aprox 12€/month)
az appservice plan create --name AppServiceLinuxDockerPlan --resource-group $rgName --location $location --is-linux --sku B1

# Create a Web App
az webapp create --name $appName --plan AppServiceLinuxDockerPlan --resource-group $rgName

# Configure Web App with a Custom Docker Container from Docker Hub
az webapp config container set --docker-custom-image-name $dockerHubContainerPath --name $appName --resource-group $rgName

# Your webApp can be see here
echo "Deployed:" http://$appName.azurewebsites.net

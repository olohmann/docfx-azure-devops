param 
(
    [Parameter(Mandatory = $true)]
    [ValidateLength(1,255)]
    [ValidateNotNull()]
    [string]
    $RegistryName,

    [Parameter(Mandatory = $true)]
    [ValidateLength(1,255)]
    [ValidateNotNull()]
    [string]
    $ImageName,

    [Parameter(Mandatory = $false)]
    [ValidateLength(1,255)]
    [ValidateNotNull()]
    [string]
    $Tag = "latest",

    [Parameter(Mandatory = $true)]
    [ValidateLength(1,255)]
    [ValidateNotNull()]
    [string]
    $AppServiceName,

    [Parameter(Mandatory = $true)]
    [ValidateLength(1,255)]
    [ValidateNotNull()]
    [string]
    $AppServiceResourceGroupName
)

Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

Write-Host "Deploying image $($RegistryName).azurecr.io/$($ImageName):$($Tag) to App Service $($AppServiceResourceGroupName)/$($AppServiceName)..."

# Make sure the admin mode is enabled, as the BETTER option with RBAC-based assignment is not allowed in all environments.
az acr update -n $RegistryName --admin-enabled true --output none

# In case the image needs another port when configured non-root.
az webapp config appsettings set -g $AppServiceResourceGroupName -n $AppServiceName --settings WEBSITES_PORT="80" --output none

$RegistryPassword = (az acr credential show --name oliverlo --output json | ConvertFrom-Json).passwords[0].value

Write-Host "Applying..."
az webapp config container set --name $AppServiceName --resource-group $AppServiceResourceGroupName --docker-custom-image-name "$($ImageName):$($Tag)" --docker-registry-server-url "https://$($RegistryName).azurecr.io" --docker-registry-server-user "$($RegistryName)" --docker-registry-server-password "$($RegistryPassword)" --output none

Write-Host "Deployment finished successfully."
param 
(
    [Parameter(Mandatory = $true)]
    [ValidateLength(1,255)]
    [ValidateNotNull()]
    [string]
    $DocFXJson,

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

    [switch]
    $LocalBuildOnly
)

Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

function RunAcrBuild {
    az acr build -r $RegistryName -f ./Dockerfile -t "$($RegistryName).azurecr.io/$($ImageName):$($Tag)" ./_out/_site
    if ($LastExitCode -gt 0) { throw "acr docker build error" }
}

function RunLocalDockerBuild {
    docker build -f ./Dockerfile -t "$($RegistryName).azurecr.io/$($ImageName):$($Tag)" ./_out/_site
    if ($LastExitCode -gt 0) { throw "docker build error" }
}

# Install docfx latest version
nuget install docfx.console
mv docfx.console.* docfx.console

.\docfx.console\tools\docfx.exe build $DocFXJson --output _out

if ($LocalBuildOnly) 
{
    RunLocalDockerBuild
}
else
{
    RunAcrBuild
}

# Load the scripts
. "$PSScriptRoot\.\Common\Common\EnterprisePolicyOperations.ps1"
. "$PSScriptRoot\.\Common\SetupSubscriptionForPowerPlatform.ps1"
. "$PSScriptRoot\.\Common\Identity\NewIdentity.ps1"
. "$PSScriptRoot\.\Common\Identity\CreateIdentityEnterprisePolicy.ps1"

function CreateManagedIdentityForDatalakeStorage
{
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$environmentId,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$policyArmId,

        [Parameter(Mandatory=$false)]
        [ValidateSet("tip1", "tip2", "prod")]
        [String]$endpoint,

        [Parameter(
            Mandatory=$true,
            HelpMessage="The Policy subscription"
        )]
        [string]$subscriptionId,

        [Parameter(
            Mandatory=$true,
            HelpMessage="The Policy resource group"
        )]
        [string]$resourceGroup,

        [Parameter(
            Mandatory=$true,
            HelpMessage="The Policy name"
        )]
        [string]$enterprisePolicyName,

        [Parameter(
            Mandatory=$true,
            HelpMessage="The Policy location"
        )]
        [string]$enterprisePolicylocation
    )

    Write-Host "Logging In..." -ForegroundColor Green
    $connect = AzureLogin $tenantId
    if ($false -eq $connect)
    {
        Write-Host "Error Logging In..." -ForegroundColor Red
        return
    }
    Write-Host "Logged In..." -ForegroundColor Green

    Set-AzContext -Subscription $subscriptionId
    
    # Logged in user needs owner role on subscription
    Write-Host "Setting up subscription for Power Platform..." -ForegroundColor Green
    SetupSubscriptionForPowerPlatform
    Write-Host "Subscription Setup for Power Platform Completed." -ForegroundColor Green
    
    # Logged in user needs owner role on resource group
    Write-Host "Creating Identity Enterprise Policy..." -ForegroundColor Green
    CreateIdentityEnterprisePolicy -subscriptionId $subscriptionId -resourceGroup $resourceGroup -enterprisePolicyName $enterprisePolicyName -enterprisePolicylocation $enterprisePolicylocation
    Write-Host "Identity Enterprise Policy Created." -ForegroundColor Green

    # Logged in user needs admin role on Power Platform
    Write-Host "Creating New Identity..." -ForegroundColor Green
    NewIdentity -environmentId $environmentId -policyArmId $policyArmId -endpoint $endpoint
    Write-Host "New Identity Created." -ForegroundColor Green
}
CreateManagedIdentityForDatalakeStorage
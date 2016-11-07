<#
    Prerequisite: https://www.microsoft.com/en-us/download/details.aspx?id=35588
    Gives administrative access to one specific ODB site.
#>

param (
    [string]
    [ValidateNotNullOrEmpty()]$office365TenantName = $(throw "Office365TenantName param is required."),
    [string]
    [ValidateNotNullOrEmpty()]$ODBUrl = $(throw "OneDriveForBusinessUrl param is required.")
)

$cred = Get-Credential

Connect-SPOService -Url "https://$($office365TenantName)-admin.sharepoint.com" -Credential $cred

$site = Get-SPOSite -Identity "https://$($office365TenantName)/personal/$($(ODBUrl))"
$user = Set-SPOUser -Site $site.Url -LoginName $cred.UserName -IsSiteCollectionAdmin $true

Write-Host "Got administrative access: $($ODBUrl)"
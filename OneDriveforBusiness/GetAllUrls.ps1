<#
    Prerequisite: https://www.microsoft.com/en-us/download/details.aspx?id=35588
    Gets all OneDrive for Business urls. 
#>

param (
    [string]
    [ValidateNotNullOrEmpty()]$office365TenantName = $(throw "Office365TenantName param is required.")
)

$cred = Get-Credential

Connect-SPOService -Url "https://$($office365TenantName)-admin.sharepoint.com" -Credential $cred

Connect-MsolService -Credential $cred

$users = $(Get-MsolUser -All)

foreach($usr in $users)
{
    if ($usr.IsLicensed -eq $true)
    {
        Write-Host "https://$($office365TenantName)-my.sharepoint.com/personal/$($usr.UserPrincipalName.Replace(".","_").Replace("@","_"))"
    }
}
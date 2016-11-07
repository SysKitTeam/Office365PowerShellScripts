<#
    Prerequisite: https://www.microsoft.com/en-us/download/details.aspx?id=35588
    Gives administrative access to your user to all OneDrive for Business urls. 
#>

param (
    [string]
    [ValidateNotNullOrEmpty()]$office365TenantName = $(throw "Office365TenantName param is required.")
)

$cred = Get-Credential

Connect-SPOService -Url "https://$($office365TenantName)-admin.sharepoint.com" -Credential $cred

$onedriveURL = @()

Connect-MsolService -Credential $cred

Write-Host "Connected to SharePoint Online!"
$users = $(Get-MsolUser -All )
$i=0;
foreach($usr in $users)
{
    $i++;
    Write-Host "Geting user $($i)/$($users.length)"
    if ($usr.IsLicensed -eq $true)
    {
        $od4bSC = "https://$($office365TenantName)-my.sharepoint.com/personal/$($usr.UserPrincipalName.Replace(".","_").Replace("@","_"))"
        $onedriveURL += $od4bSC
    }
}

foreach($url in $onedriveURL)
{
    $site = Get-SPOSite -Identity $url
    $user = Set-SPOUser -Site $site.Url -LoginName $cred.UserName -IsSiteCollectionAdmin $true
    Write-Host "Got administrative access: $($site.Url)"
}
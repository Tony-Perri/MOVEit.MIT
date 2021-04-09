# MOVEit.MIT
MOVEit.MIT is a PowerShell module for using the [MOVEit Transfer REST API](https://docs.ipswitch.com/MOVEit/Transfer2020_1/Api/rest/).  *Please note - This is currently a work-in-progress and not all endpoints have been implemented.*  
## Features
- PowerShell commands map, as much as possible, directly to REST API endpoints.
- Commands set the type on output objects for formatting using .format.ps1xml file
- Automatically refreshes the auth token when it is over half-way to expiring (ie. every 10 mins)
- Supports the REST API's paging parameters

## Installation
MOVEit.MIT can be installed from the PowerShell Gallery using the command:
```powershell
Install-Module -Name 'MOVEit.MIT'
```

## Getting Started
Once installed, you should be able to access the MOVEit Transfer REST API using the module commands either from a command-prompt or a script.

First, you'll need to connect to a MOVEit Transfer server and authenticate.
```powershell
# Connect to a MOVEit Transfer server
Connect-MITServer -Hostname '<your-transfer-server>' -Credential (Get-Credential)
```
Once connected, you can use any of the commands to invoke the cooresponding REST API endpoint.
```powershell
# Get a list of MOVEit Transfer users
Get-MITUser
```
```powershell
# Get a list of users by username
Get-MITUser -Username 'partner'
```
```powershell
# Get a specific user by userid
Get-MITUser -UserId 'mi3y430ss81kvzld'
```
## Paging
The MOVEit Transfer REST API returns paged results.  By default, `PerPage = 25`.  Use the `-Page` and `-PerPage` parameters to return more results.  Use the `-IncludePaging` parameter to include paging information in the output.
```powershell
# Get the 100 most recent log entries and include paging information in the output
Get-MITLog -SortDirection desc -PerPage 100 -IncludePaging
```
```powershell
# Get all logs
$page = 1
do {
    $paging, $logs = Get-MITLog -SortDirection desc -Page $page -PerPage 50 -IncludePaging
    $logs
} while ($page++ -lt $paging.TotalPages)
```
## Pipeline
Many commands accept parameters from the pipeline
```powershell
# Create a new folder under root
Get-MITFolder -Path '/' | New-MITFolder -Name 'Test'
```
```powershell
# Remove a user
Get-MITUser -Username 'user1' -IsExactMatch | Remove-MITUser
```
## Packages
Example for sending an Ad Hoc package with attachment(s)
```powershell
# Send a package
$sendPackageParams = @{
    DeliveryReceipts = $true    
    Recipients = @(
        (New-MITPackageRecipient -Role To -Type Unreg -Identifier 'guest1@moveitdemo.com'),
        (New-MITPackageRecipient -Role CC -Type User -Identifier 'User 2')
    )
    Subject = 'The files'
    Body = 'Here are your files.'
    Attachments = @(
        (Write-MITPackageAttachment -Path '~/Documents/File1.pdf'),
        (Write-MITPackageAttachment -Path '~/Documents/File2.pdf')
    )
    ExpirationHours = 7*24
}

Send-MITPackage @sendPackageParams
```
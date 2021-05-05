## 0.4.0 - 
* Add support for mfa using code from authenticator app
* Updates for MOVEit Transfer 2021
    * Set-MITFolder support -InheritAccess parameter
    * Set-MITFolder support -Description parameter
    * Set-MITFolderAcl support for -OverrideBehaviourType
    * Set-MITFolderAcl support for -EntryId
    * Implement Set-MITFolderMaintenance function
    * Implement Set-MITFolderNotification function
* Update comment-based help with links to REST API endpoint doc
## 0.3.0 - April 2021
* Add warning if more items exist and -IncludePaging was not specified.
* Add Invoke-MITWebRequest for raw request/response
## 0.2.1-preview - March 2021
#### Packages
* Get-MITPackage
* New-MITPackageRecipient
* Send-MITPackage
* Set-MITPackage
* Write-MITPackageAttachment
#### Mailboxes
* Get-MITMailbox
#### Files
* Read-MITFile
* Write-MITFile
* Write-MITPackageAttachment (see packages)
## 0.2.0 - March 2021
#### General
* Initial release
#### Session/Token
* Connect-MITServer
* Disconnect-MITServer
#### Users
* Get-MITUser
* New-MITUser
* Remove-MITUser
* Set-MITUser
#### Groups
* Get-MITGroup
* New-MITGroup
* Add-MITGroupMember
* Get-MITGroupMember
* Remove-MITGroupMemeber
#### Folders
* Get-MITFolder
* New-MITFolder
* Remove-MITFolder
* Set-MITFolder
* Get-MITFolderAcl
* New-MITFolderAcl
* Remove-MITFolderAcl
* Set-MITFolderAcl
#### Folder Content
* Get-MITFolderContent
#### Files
* Get-MITFile
#### Logs
* Get-MITLog
#### Orgs
* Get-MITOrg
* New-MITOrg
* Switch-MITOrg
#### Other
* Get-MITInfo
* Get-MITTransferStatus
* Invoke-MITRestMethod
* New-MITRemoteAccessRule

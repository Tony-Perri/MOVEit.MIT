## 0.4.8 - 
* 
## 0.4.7 - Apr 2024
* Small update to FormatRestApi error
* Add 'System.Net.Http' assembly to manifest for better 5.1 compatibility.
* `Set-MITPackageAttachment`: Use chunked for files -ge 20MB (previously -ge 2GB)
## 0.4.6 - Oct 2023
* Add support for -SkipCertificateCheck
* Format RestApi error details rather than the raw json
* `Set-MITFolderAcl`: Add `-FolderPermissions` string[] parameter
* `New-MITFolderAcl`: Add `-FolderPermissions` string[] parameter
## 0.4.5 - Sep 2023
* `Set-MITFileContent`: Make HashType a parameter
* `Set-MITFileContent`: Use chunked for files -ge 20MB (previously -ge 2GB)
* `Get-MIT*` cmdlets: Add `-All` parameter to  to automatically return all results
* Updated help links to Transfer2023 API documentation
## 0.4.4 - Jun 2022
* Refactor calls to Invoke-RestMethod to call Invoke-MITRequest instead.
* Add `Set-MITOrg`.
* Add -IncludePaging switch to Add-MITGroupMember, even though the REST endpoint doesn't
  support the Page or PerPage parameters, in order to suppress warnings if a group has more than
  25 members
## 0.4.3 - Mar 2022
* Add `Copy-MITFile`.
* Add `Move-MITFile`.
* Add `Remove-MITFile`.
* Add support for SendPasswordChangeNotification to Set-MITUser.  Requires Transfer v2021.1.
* Fix an issue in Connect-MITServer where the BaseUri is set even if the connection is not successful
* Rename `Read-MITFile` to `Get-MITFileContent`.  Added alias for `Read-MITFile`.
* Rename `Write-MITFile` to `Set-MITFileContent`.  Added alias for `Write-MITFile`.
* Rename `Write-MITPackageAttachment` to `Set-MITPackageAttachment`.  Added alias.
## 0.4.2 - Aug 2021
* Changed some [switch] parameters to [bool], such as the -ForceChangePassword
  parameter.  This was because of how switch parameters were converted to JSON, but
  also some parameters can be set to $true or $false.
## 0.4.1 - June 2021
* Add support for Get-MITReport
* Add support for Invoke-MITReport
## 0.4.0 - May 2021
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

function Set-MITUser {
    <#
    .SYNOPSIS
        Change a MOVEit Transfer User
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]                    
        [Alias('Id')]
        [string]$UserId,

        [Parameter()]
        [ValidateSet('Active','Suspended','Template')]
        [string]$Status,

        [Parameter()]
        [switch]$ForceChangePassword,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Password,
        
        [Parameter()]
        [string]$StatusNote,

        [Parameter()]
        [string]$Email,

        [Parameter()]
        [ValidateSet('ReceivesNoNotifications', 'ReceivesNotifications','AdminReceivesNotifications')]
        [string]$ReceivesNotification,

        [Parameter()]
        [string]$Language,

        [Parameter()]
        [ValidateSet('TemporaryUser', 'User', 'FileAdmin', 'Admin', 'SysAdmin')]
        [string]$Permission,

        [Parameter()]
        [string]$Notes,

        [Parameter()]
        [string]$FullName,

        [Parameter()]
        [int64]$FolderQuota,

        [Parameter()]
        [ValidateSet('MOVEitOnly', 'ExternalOnly', 'Both')]
        [string]$AuthMethod,

        [Parameter()]
        [ValidateSet('HTML','Text')]
        [string]$EmailFormat,

        [Parameter()]
        [int64]$DefaultFolderId
    )

    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/users/$UserId"
                
    # Set the request headers
    $headers = @{
        Accept          = "application/json"
        Authorization   = "Bearer $($script:Token.AccessToken)"        
    }

     # Build the request body.
     $body = @{}
     switch ($PSBoundParameters.Keys) {
        Status { $body['status'] = $Status }
        ForceChangePassword { $body['forceChangePassword'] = $ForceChangePassword }
        Password { $body['password'] = $Password }
        StatusNote { $body['statusNote'] = $StatusNote }
        Email { $body['email'] = $Email }
        ReceivesNotification { $body['receivesNotification'] = $ReceivesNotification }
        Language { $body['language'] = $Language }
        Permission { $body['permission'] = $Permission }
        Notes { $body['notes'] = $Notes }
        FullName { $body['fullName'] = $FullName }
        FolderQuota { $body['folderQuota'] = $FolderQuota }
        AuthMethod { $body['authMethod'] = $AuthMethod }
        EmailFormat { $body['emailFormat'] = $EmailFormat }
        DefaultFolderId { $body['defaultFolderId'] = $DefaultFolderId }
    }
    
    # Setup the params to splat to IRM
    $irmParams = @{
        Uri = $uri
        Method = 'Patch'
        Headers = $headers
        ContentType = 'application/json'
        Body = ($body | ConvertTo-Json)
    }

    # Send the request and output the response
    try {
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse -TypeName 'MITUserSimple'
    }
    catch {
        $_
    }
}
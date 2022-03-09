function Set-MITUser {
    <#
    .SYNOPSIS
        Change a MOVEit Transfer User
    .LINK
        Partial user update
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/PATCHapi/v1/users/{Id}-1.0        
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', 'Password')]
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
        [bool]$ForceChangePassword,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Password,

        [Parameter()]
        [bool]$SendPasswordChangeNotification,
        
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

    try {
        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            Status { $body['status'] = $Status }
            ForceChangePassword { $body['forceChangePassword'] = $ForceChangePassword }
            Password { $body['password'] = $Password }
            SendPasswordChangeNotification { $body['sendPasswordChangeNotification'] = $SendPasswordChangeNotification }
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
            Resource    = "users/$UserId"
            Method      = 'Patch'
            ContentType = 'application/json'
            Body        = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse -TypeName 'MITUserSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
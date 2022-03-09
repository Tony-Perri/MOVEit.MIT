function New-MITUser {
    <#
    .SYNOPSIS
        Create a MOVEit Transfer User
    .LINK
        Create new user
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/POSTapi/v1/users-1.0        
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', 'Password')]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Username,    
    
        [Parameter()]
        [string]$FullName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Password,

        [Parameter()]
        [string]$Email,

        [Parameter()]
        [string]$SourceUserId,

        [Parameter()]
        [ValidateSet('TemporaryUser', 'User', 'FileAdmin', 'Admin', 'SysAdmin')]
        [string]$Permission,

        [Parameter()]
        [bool]$ForceChangePassword,

        [Parameter()]
        [int32]$OrgID,

        [Parameter()]
        [string]$Notes,

        [Parameter()]
        [string]$HomeFolderPath,

        [Parameter()]
        [ValidateSet('AllowIfExists', 'DenyIfExists')]
        [string]$HomeFolderInUseOption
    )
    
    try {
        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            Username { $body['username'] = $Username }    
            FullName { $body['fullName'] = $FullName }
            Password { $body['password'] = $Password }
            Email { $body['email'] = $Email }
            SourceUserId { $body['sourceUserId'] = $SourceUserId }
            Permission { $body['permission'] = $Permission }
            ForceChangePassword { $body['forceChangePassword'] = $ForceChangePassword }
            OrgID { $body['orgID'] = $OrgID }
            Notes { $body['notes'] = $Notes }
            HomeFolderPath { $body['homeFolderPath'] = $HomeFolderPath }
            HomeFolderInUseOption { $body['HomeFolderInUseOption'] = $HomeFolderInUseOption }
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "users"
            Method = 'Post'
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse -TypeName 'MITUserSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
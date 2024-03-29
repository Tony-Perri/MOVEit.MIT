function Connect-MITServer {
    <#
    .SYNOPSIS
        Connectot a MOVEit Transfer server and create an auth token.
    .DESCRIPTION
        Create an auth token using the /api/v1/token endpoint.
        Call before calling any other Get-MIT* commands.            
    .EXAMPLE
        Connect-MITServer
        User is prompted for parameters.
    .EXAMPLE
        Connect-MITServer -Hostname 'moveit.server.com' -Credential (Get-Credential -Username 'admin')
        Supply parameters on command line except for password.
    .INPUTS
        None.
    .OUTPUTS
        String message if connected.
    .LINK
        Retrieve API token
        https://docs.ipswitch.com/MOVEit/Transfer2023/API/rest/#operation/Auth_GetToken
    #>
    [CmdletBinding()]
    param (      
        # Hostname for the endpoint                 
        [Parameter(Mandatory=$true)]
        [string]$Hostname,

        # Credentials
        [Parameter(Mandatory=$true)]
        [pscredential]$Credential,

        # OTP for MFA
        [Parameter()]
        [ValidatePattern('^\d{3}\s?\d{3}$')]
        [string]$Otp,

        # SkipCertificateCheck
        [Parameter()]
        [switch]$SkipCertificateCheck
    )     

    try {                    
        # Clear any existing Token or Base Uri settings.  These will be set if the connection is
        # successful.
        $script:Token = @()
        $script:BaseUri = ''

        # Determine if SkipCertificateCheck parameter is specified
        $script:SkipCertificateCheck = $false
        
        if ($SkipCertificateCheck) {
            if ($PSVersionTable.PSVersion.Major -ge 6) {
                Write-Warning "SkipCertificateCheck is not secure and is not recommended. "
                Write-Warning ("This switch is only intended to be used against known hosts " +
                              "using a self-signed certificate for testing purposes.") 
                Write-Warning "Use at your own risk."
                $script:SkipCertificateCheck = $true                              
            }
            else {
                Write-Error "SkipCertificateCheck requires PowerShell 6 or later" -ErrorAction Stop
            }
        }
        
        # Set the Base Uri locally for now.  Will update the script-level variable if
        # the connection is successfu.
        $baseUri = "https://$Hostname/api/v1"
        
        # Build the request
        $uri = "$baseUri/token"
        $params = @{ 
            Method = 'POST'
            ContentType = 'application/x-www-form-urlencoded'        
            Headers = @{Accept = "application/json"}            
        }
        
        # Add SkipCertificateCheck parameter if set
        if ($script:SkipCertificateCheck) {
            $params['SkipCertificateCheck'] = $true
        }
        
        # This try/catch block will be to catch and handle the exception that is thrown
        # if MFA is required.
        try {
            $response = @{
                grant_type = 'password'
                username = $Credential.UserName
                password= $Credential.GetNetworkCredential().Password
                } | Invoke-RestMethod -Uri $uri @params -UserAgent $script:UserAgent
        }
        catch [System.Net.Http.HttpRequestException], [System.Net.WebException] {
            if ($_.Exception.Response.StatusCode -eq 401) {
                $response = ($_.ErrorDetails.Message | ConvertFrom-Json)
                $isMfaRequired = ($response.error -eq 'mfa_required')
            }

            if (-not $isMfaRequired) {
                # Must have been some other error so let's re-throw it.
                throw $_
            }            
        }
        
        if ($isMfaRequired) {
            Write-Verbose "MFA Authentication is required"
            # Resubmit to the same endpoint, using otp as the granttype, 
            # the mfa_access_token given in the error in the mfa_access_token field,
            # and the 6 digit code from your authenticator in the otp field.
            if (-not $Otp) {                
                $Otp = Read-Host -Prompt "Enter 6-digit verification code"
            }
            $response = @{
                grant_type = 'otp'
                mfa_access_token = $response.mfa_access_token
                otp = $otp                
                } | Invoke-RestMethod -Uri $uri @params -UserAgent $script:UserAgent
        }

        if ($response.access_token) {
            $script:BaseUri = $baseUri
            $script:Token = @{                    
                AccessToken = $Response.access_token
                CreatedAt = $(Get-Date)
                ExpiresIn = $Response.expires_in
                RefreshToken = $Response.refresh_token
            }
            Write-Output "Connected to MOVEit Transfer server $Hostname"
        }
    }
    catch [System.Net.Http.HttpRequestException], [System.Net.WebException] {
        # Format ErrorDetails which contains the JSON response from the REST API
        $PSCmdlet.ThrowTerminatingError((Format-RestErrorDetails $PSItem))
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }   
}
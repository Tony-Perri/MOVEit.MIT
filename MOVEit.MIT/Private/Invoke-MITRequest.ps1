using namespace Microsoft.PowerShell.Commands
function Invoke-MITRequest {
    <#
    .SYNOPSIS
        Function all cmdlets call to send a request to MIT.
    .DESCRIPTION
        First confirms that the auth token hasn't expired.  Then sends the request
        and writes the response to the pipeline.
    #>    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                    Position=0)]
        [string]$Resource,
        
        [Parameter()]
        [WebRequestMethod]$Method = [WebRequestMethod]::Get,

        [Parameter()]
        [string]$Accept = 'application/json',

        [Parameter()]
        [string]$ContentType,

        [Parameter()]
        [System.Object]$Body,

        [Parameter()]
        [string]$Outfile,

        [Parameter()]
        [System.Collections.IDictionary]$Form,

        [Parameter()]
        [string]$TransferEncoding
    )

    try {
        # Confirm the Token
        Confirm-MITToken

        # We'll use a splat so we can include just the parameters specified to call IRM.
        # We'll start with the defaults, then add anything that is passed in.
        $irmParams = @{
            Uri     = "$script:BaseUri/$Resource"
            Method  = $Method
            Headers = @{
                Accept        = "$Accept"
                Authorization = "Bearer $($script:Token.AccessToken)"        
            }
            UserAgent = $script:UserAgent
        }

        # if ($Method -in ([WebRequestMethod]::Post, [WebRequestMethod]::Put, [WebRequestMethod]::Patch)) {
        #     if ($PSBoundParameters.ContainsKey('Body')) {
        #         # ToDo: Set the ContentType based on the Request Method and maybe do the
        #         # body | ConvertTo-Json here too?
        #     }
        # }

        # Add any add'l params that were passed in
        switch ($PSBoundParameters.Keys) {
            ContentType      { $irmParams['ContentType']      = $ContentType }
            Body             { $irmParams['Body']             = $Body }
            Outfile          { $irmParams['Outfile']          = $Outfile }
            Form             { $irmParams['Form']             = $Form }
            TransferEncoding { $irmParams['TransferEncoding'] = $TransferEncoding }
        }

        Write-Verbose "Uri: $($irmParams.Uri)"
        Write-Verbose "Method: $($irmParams.Method)"
        Write-Verbose "Accept: $($irmParams.Headers.Accept)"
        Write-Verbose "ContentType: $($irmParams.ContentType)"        

        # Add SkipCertificateCheck parameter if set
        if ($script:SkipCertificateCheck) {
            $irmParams['SkipCertificateCheck'] = $true
            Write-Verbose "SkipCertificateCheck: $true"
        }

        # Send the request and write out the response
        Invoke-RestMethod @irmParams
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
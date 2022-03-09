function Switch-MITOrg {
    <#
    .SYNOPSIS
        Switch (ie. ActAsAdmin) to a different Org.
    .LINK
        Become administrator in specific organization
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/POSTapi/v1/auth/actasadmin-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]                    
        [int32]$OrgId
    )

    try {
        # Build the request body.
        $body = @{
            orgId = $OrgId
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "auth/actasadmin"
            Method = 'Post'
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse -TypeName 'MITSwitchOrg'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
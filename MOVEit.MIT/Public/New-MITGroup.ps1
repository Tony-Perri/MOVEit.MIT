function New-MITGroup{
    <#
    .SYNOPSIS
        Create a MOVEit Transfer Group
    .LINK
        Create new group
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/POSTapi/v1/groups-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [string]$Description
    )

    try {
        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            Name { $body['name'] = $Name }
            Description { $body['description'] = $Description }
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "groups"
            Method = 'Post'
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse -TypeName 'MITGroupSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
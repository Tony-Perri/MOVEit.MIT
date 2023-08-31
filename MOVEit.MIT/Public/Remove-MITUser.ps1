function Remove-MITUser {
    <#
    .SYNOPSIS
        Remove a MOVEit Transfer User
    .LINK
        Delete user
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/DELETEapi/v1/users/{Id}-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]                    
        [Alias('Id')]
        [string]$UserId
    )

    try {
        # Set the resource for this request
        $resource = "users/$UserId"
                    
        # Send the request and output the response
        Invoke-MITRequest -Resource $resource -Method 'Delete'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
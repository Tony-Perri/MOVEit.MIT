function Remove-MITGroupMember {
    <#
    .SYNOPSIS
        Remove MOVEit Transfer Group Member
    .LINK
        Remove member from group
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/DELETEapi/v1/groups/{Id}/members/{UserId}-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]                    
        [string]$GroupId,

        [Parameter(Mandatory)]
        [string]$UserId
    )

    try {
        # Set the resource for this request
        $resource = "groups/$GroupId/members/$UserId"

        # Send the request and output the response
        Invoke-MITRequest -Resource $resource -Method 'Delete' |
            Write-MITResponse -TypeName 'MITUserSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
    
}
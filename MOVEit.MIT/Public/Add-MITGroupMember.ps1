function Add-MITGroupMember{
    <#
    .SYNOPSIS
        Add MOVEit Transfer Group Member(s)
    .LINK
        Add members(s) to group
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/POSTapi/v1/groups/{Id}/members-1.0    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]                    
        [string]$GroupId,

        [Parameter(Mandatory)]
        [string[]]$UserIds,        

        [Parameter()]
        [switch]$IncludePaging
    )
    
    try {
        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            GroupId { $body['id'] = $GroupId }
            UserIds { $body['userIds'] = $UserIds }            
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "groups/$GroupId/members"
            Method = 'Post'
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse -TypeName 'MITUserSimple' -IncludePaging:$IncludePaging
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
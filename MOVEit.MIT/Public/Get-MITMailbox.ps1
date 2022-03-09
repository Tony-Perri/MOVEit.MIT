function Get-MITMailbox {
    <#
    .SYNOPSIS
        Get MOVEit Transfer mailbox(es)
    .LINK
        Retrieve mailboxes list
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/mailboxes-1.0
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true,
                    ParameterSetName='Detail')]
        [Alias('Id')]                    
        [string]$MailboxId
    )
    try { 
        # Set the resource for this request
        $resource = "mailboxes"
        
        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                Invoke-MITRequest -Resource "$resource/$MailboxId" |
                    Write-MITResponse -Typename 'MITMailboxDetail'
            }
            'List' {
                # This is the first endpoint that doesn't use items[] to
                # return an array, so we'll force it for compatibility.
               [PSCustomObject]@{
                    items = Invoke-MITRequest -Resource $resource
                } | Write-MITResponse -Typename 'MITMailboxSimple'
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
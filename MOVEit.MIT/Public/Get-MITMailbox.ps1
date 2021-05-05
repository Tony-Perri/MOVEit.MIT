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
        # Confirm the token, refreshing if necessary
        Confirm-MITToken
    
        # Set the Uri for this request
        $uri = "$script:BaseUri/mailboxes"
                
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        }
        
        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                $response = Invoke-RestMethod -Uri "$uri/$MailboxId" -Headers $headers
                $response | Write-MITResponse -Typename 'MITMailboxDetail'
            }
            'List' {
                # This is the first endpoint that doesn't use items[] to
                # return an array, so we'll force it for compatibility.
                $response = [PSCustomObject]@{
                    items = @()
                }
                $response.items = Invoke-RestMethod -Uri $uri -Headers $headers
                $response | Write-MITResponse -Typename 'MITMailboxSimple'
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
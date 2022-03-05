function Remove-MITFile {
    <#
    .SYNOPSIS
        Remove a MOVEit Transfer File
    .LINK
        Delete folder
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/DELETEapi/v1/files/{Id}-1.0        
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$FileId
    )

    Process {
        try {
            # Confirm the token, refreshing if necessary
            Confirm-MITToken

            # Set the Uri for this request
            $uri = "$script:BaseUri/files/$FileId"
                    
            # Set the request headers
            $headers = @{
                Accept        = "application/json"
                Authorization = "Bearer $($script:Token.AccessToken)"        
            }

            # Setup the params to splat to IRM
            $irmParams = @{
                Uri     = $uri
                Method  = 'Delete'
                Headers = $headers
            }

            if ($PSCmdlet.ShouldProcess("File: $FileId", "Deleting file")) {
                # Send the request and output the response
                $response = Invoke-RestMethod @irmParams
                $response 
            }            
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
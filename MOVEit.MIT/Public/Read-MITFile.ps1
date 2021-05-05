function Read-MITFile {
    <#
    .SYNOPSIS
        Read (download) a MOVEit Transfer file/attachment
    .LINK
        Download file
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/files/{Id}/download-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('Id')]
        [string]$FileId,
        
        [Parameter(Mandatory=$false)]
        [string]$Path,

        # Overwrite existing file
        [Parameter(Mandatory=$false)]
        [switch]$Force
    )

    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/files/$FileId/download"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/octet-stream"
            Authorization = "Bearer $($script:Token.AccessToken)"        
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Uri = $uri
            Headers = $headers
        }

        # Add the -OutFile param if specified, otherwise the content
        # is output to the pipeline
        if ($PSBoundParameters.ContainsKey('Path')) {
            $newPath = $Path

            # If not -Force, check to see if the file exists and, if
            # so, add an increment to it.
            if (-not $Force) {
                $i = 0
                while (Test-Path $newpath) {
                    $newFilename = "{0} ({1}){2}" -f [System.IO.Path]::GetFileNameWithoutExtension($path),
                                                        ++$i, [System.IO.Path]::GetExtension($path)
                    $newpath = Join-Path -Path ([System.IO.Path]::GetDirectoryName($path)) -ChildPath $newFilename    
                }
            }
            
            # Send the request
            Invoke-RestMethod @irmParams -OutFile $newPath
            
            # Output the path as an object
            Write-Output ([PSCustomObject]@{
                FileId = $FileId
                Path = $newPath
            })
        }
        else {
            # Send the request and output the response
            Invoke-RestMethod @irmParams
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
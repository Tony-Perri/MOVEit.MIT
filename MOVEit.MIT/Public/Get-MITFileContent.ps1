function Get-MITFileContent {
    <#
    .SYNOPSIS
        Get (download) a MOVEit Transfer file/attachment
    .LINK
        Download file
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/GETapi/v1/files/{Id}/download-1.0        
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
        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "files/$FileId/download"
            Accept = "application/octet-stream"
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
            Invoke-MITRequest @irmParams -OutFile $newPath
            
            # Output the path as an object
            Write-Output ([PSCustomObject]@{
                FileId = $FileId
                Path = $newPath
            })
        }
        else {
            # Send the request and output the response
            Invoke-MITRequest @irmParams
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
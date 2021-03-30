function Write-MITFile {
    <#
        .SYNOPSIS
        Write (upload) a file to a MOVEit Transfer folder
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$FolderId,

        [Parameter(Mandatory)]
        [ValidateScript({
            if(-Not ($_ | Test-Path) ){
                throw "File or folder does not exist"
            }
            if(-Not ($_ | Test-Path -PathType Leaf) ){
                throw "The Path argument must be a file. Folder paths are not allowed."
            }
            return $true 
        })]
        [string]$Path,

        [Parameter(Mandatory=$false)]
        [string]$Comments
    )

    try {
        # This function will only work on version 6 or later.
        if ($PSVersionTable.PSVersion.Major -lt 6) {
            Write-Error "Write-MITPackageAttachment requires PowerShell 6 or later" -ErrorAction Stop
        }

        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/folders/$FolderId/files"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"        
        }

        # Get the fileinfo
        $fileinfo = Get-Item -Path $Path
        Write-Verbose "File to upload: $($fileinfo.FullName)"
        $filehash = Get-FileHash -Algorithm SHA256 -Path $fileinfo.FullName
        Write-Verbose "File hash: $($filehash.Algorithm) $($filehash.Hash)"
              
        # Build the request form
        $form = @{
            comments = $Comments
            hashtype = $filehash.Algorithm -replace 'SHA', 'SHA-' #Add the dash
            hash = $filehash.Hash
            file = $fileinfo
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Uri = $uri
            Method = 'Post'
            Headers = $headers
            Form = $form            
        }

        # If the file is over 2GB switch to chunked
        if ($fileinfo.Length -gt [int32]::MaxValue) {
            Write-Verbose 'Using Transfer-Encoding: chunked'
            $irmParams['TransferEncoding'] = 'chunked'
        }

        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse -Typename 'MITFileSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
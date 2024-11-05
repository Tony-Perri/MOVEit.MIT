function Write-MITResponse {    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true)]
        [PSObject]$Response,
        
        [Parameter(Mandatory=$false)]
        [string]$TypeName,

        [Parameter(Mandatory=$false)]
        [switch]$IncludePaging
    )

    # Handle paging info in the response, if present
    if ($Response.psobject.properties['paging']) {
        # Write out paging info to console if in verbose mode
        Write-Verbose ("totalItems: {0} perPage: {1}  page: {2} totalPages: {3}" -f
                $response.paging.totalItems, $response.paging.perPage, 
                $response.paging.page, $response.paging.totalPages)

        if ($IncludePaging) {
            # Add type and write the paging info.  Want to send this down the pipeline first
            # so the caller can check the first item for this information if they want
            # to loop through multiple pages, etc.
            $Response.paging.PSObject.TypeNames.Insert(0,'MITPaging')
            $Response.paging 
        }
        else {
            # No paging info is being output, so write a warning if the total
            # items exceeds the number displayed per page
            if ($response.paging.totalItems -gt $response.paging.perPage) {
                Write-Warning "Results are paged.  Use -IncludePaging, -Page and -PerPage parameters, or use the -All parameter."
            }
        }
    }

    # Determine if the results are in the items property or the response itself
    $result = if ($Response.psobject.properties['items']) { $Response.items } else { $Response }

    # Add type to the results for better display from .format.ps1xml file and write
    # to the pipeline
    if ($TypeName) {
        foreach ($item in $result) {
            $item.PSOBject.TypeNames.Insert(0,$TypeName)
        }
    }

    # Write the results to the pipeline
    $result
}
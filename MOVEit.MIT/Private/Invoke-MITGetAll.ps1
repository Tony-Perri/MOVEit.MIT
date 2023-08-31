function Invoke-MITGetAll {
    <#
    .SYNOPSIS
        Function cmdlets call when the -All parameter is used
        so the logic to loop through all items is only implemented
        once
    .EXAMPLE
        Invoke-MITGetAll -Scriptblock ${function:Get-MITUser} -BoundParameters $PSBoundParameters
    #>  
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.ScriptBlock]
        $ScriptBlock,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, object]]
        $BoundParameters,

        [Parameter()]
        [int]
        $WarningNumItems = 5000
    )

   
    # These are the original bound parameters the function (ie. Get-MITUser)
    # was called with.  Need to remove the -All parameter and then pass the rest
    # to the $ScriptBlock
    $BoundParameters.Remove('All') | Out-Null
    
    # We'll use the paging to iterate through all of the items, 200
    # at a time.
    $pagingParams = @{
        Page = 1
        PerPage = 200
        IncludePaging = $true
    }

    do {
        # Call the ScriptBlock and splat the original boundparameters and the paging parameters
        $paging, $items = & $ScriptBlock @BoundParameters @pagingParams
        
        # Write a warning if there are a lot of items
        if ($pagingParams.Page -eq 1 -and $paging.totalItems -gt $WarningNumItems) {
            Write-Warning "-All specified and total items of $($paging.totalItems) exceeds warning level of $WarningNumItems"
        }

        # Write the items to the pipeline
        $items                                        
    } while ($pagingParams.Page++ -lt $paging.totalPages)
}
$PublicFunctions = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$PrivateFunctions = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

#Dot source the files
Foreach($file in @($PublicFunctions + $PrivateFunctions)) {
    Try {
        . $file.FullName
    }
    Catch {
        Write-Error -Message "Failed to import $($file.FullName): $_"
    }
}

Export-ModuleMember -Function $PublicFunctions.Basename

# Update the format data to display the Log output and paging info   
Update-FormatData -AppendPath "$PSScriptRoot\Format\MIT.Format.ps1xml" 
Update-FormatData -AppendPath "$PSScriptRoot\Format\MITLog.Format.ps1xml" 
Update-FormatData -AppendPath "$PSScriptRoot\Format\MITOrg.Format.ps1xml" 
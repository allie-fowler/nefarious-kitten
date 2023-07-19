# Get the first CSV file in the input directory

param (
    [string]$inputFile = ""
)

# Check if the input file parameter is empty
if ([string]::IsNullOrEmpty($InputFile)) {
    $inputFile = Get-ChildItem -Path . -Filter "input/*AlertBook.csv" | Select-Object -First 1
}

# Check if a matching file was found
if ($inputFile) {
    # Use the file as your input
    # $inputFile.FullName contains the full path to the file
    Write-Host "Using file: $($inputFile)"

    Write-Host "File Modify Date: $fileCreationDate"
    Write-Host "Current Date: $currentDate"

    # Rest of your script using $inputFile.FullName
    # Number of days back to collect symbols
    $lookBack = -7

    $datenow = Get-Date -Format "MMddyyyy-HHmmss"
    $DaysAgo = (Get-Date).AddDays($lookBack)
    $regex = "\b[A-Z]{1,4}\b"

    # Find dates in the specified range, grab stock symbols and recipe type
    $symbolsList = Get-Content -Path $inputFile | ForEach-Object {
        $fields = $_ -split ','
        if ($fields[0] -as [datetime]) {
            $date = [datetime]::ParseExact($fields[0], "M/d/yy H:mm:ss", $null)
            if ($date -ge $DaysAgo) {
                if ($fields[2] -match $regex) {
                    $stockSymbol = $matches[0]
                    if ($fields[2] -match "\(3 Days\)") {
                        Write-Output "$fields[0]	$stockSymbol		Moses"
                    }
                    elseif ($fields[2] -match "\(Day\)") {
                        Write-Output "$fields[0]	$stockSymbol		Recipe"
                    }
                }
            }
        }
    } | Sort-Object -Unique | Out-String

    # Output the list to a window"
    #$wshell = New-Object -ComObject Wscript.Shell
    #$Output = $wshell.Popup($symbolsList,0,"header",0+64)
    Write-Host "$symbolsList"

}
else {
    # Throw an error if no CSV file is found
    throw "No CSV file found in the current directory."
}

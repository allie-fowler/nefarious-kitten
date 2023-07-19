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

    $datenow = Get-Date -Format "MMddyyyy"
    $DaysAgo = (Get-Date).AddDays($lookBack).Date

    # Find dates in the specified range, grab stock symbols and recipe type
    $symbolsList = Get-Content -Path $inputFile | Select-Object -Skip 4 | ForEach-Object {
        $fields = $_ -split ','
        if ($fields.Count -ge 7) {
            try {
                $date = [datetime]::ParseExact($fields[0], "M/d/yy H:mm:ss", $null).Date
                if ($date -ge $DaysAgo) {
                    if ($fields[2] -match $regex) {
                        $stockSymbol = $matches[0]
                        if ($fields[2] -match "\(3 Days\)") {
                            "{0,-6} {1,-8} {2}" -f $stockSymbol, "Moses", $date.ToString("MM/dd/yyyy")
                        }
                        elseif ($fields[2] -match "\(Day\)") {
                            "{0,-6} {1,-8} {2}" -f $stockSymbol, "Recipe", $date.ToString("MM/dd/yyyy")
                        }
                    }
                }
            }
            catch {
                # Ignore the line if the date cannot be parsed
                continue
            }
        }
    } | Sort-Object -Unique

    # Output the list to a window"
    $symbolsList | Out-String | Write-Host

}
else {
    # Throw an error if no CSV file is found
    throw "No CSV file found in the current directory."
}

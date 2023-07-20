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

    $dateRangeStart = (Get-Date).AddDays($lookBack).Date
    $symbolsHashtable = @{}
    $stockSymbols = [System.Collections.Generic.HashSet[string]]::new()
    $csvDelimiter = ','

    Get-Content -Path $inputFile | Select-Object -Skip 4 | ForEach-Object {
        $fields = $_ -split $csvDelimiter
        $date = $fields[0].Trim()
        $stockSymbol = $fields[1].Trim()

        if ($date -match '^\d{1,2}/\d{1,2}/\d{2}') {
            $dateParsed = [DateTime]::ParseExact($date, "M/d/yy H:mm:ss", $null)
            if ($dateParsed.Date -ge $dateRangeStart) {
                $recipeType = $fields[2].Trim()

                if ($recipeType -eq "(3 Days)") {
                    $stockSymbols.Add("$stockSymbol Moses")
                } elseif ($recipeType -eq "(Day)") {
                    $stockSymbols.Add("$stockSymbol Recipe")
                }
            }
        }
    }

    # Output the list to a window
    $sortedSymbolsList = $stockSymbols | Sort-Object | ForEach-Object {
        "{0,-6} {1,-8} {2}" -f $_.Split(' ')[0], $_.Split(' ')[1], $dateRangeStart.ToString("MM/dd/yyyy")
    }

    $sortedSymbolsList | Out-String | Write-Host

}
else {
    # Throw an error if no CSV file is found
    throw "No CSV file found in the current directory."
}

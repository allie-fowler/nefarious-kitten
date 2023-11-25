# Get the first CSV file in the input directory
param (
    [string]$inputFile = ""
)

# Check if the input file parameter is empty
if ([string]::IsNullOrEmpty($InputFile)) {
    $inputFile = Get-ChildItem -Path . -Filter "input/*AlertBook.csv" | Select-Object -Last 1
}

# Check if a matching file was found
if ($inputFile) {
    # Use the file as your input
    # $inputFile.FullName contains the full path to the file
    Write-Host "Using input file: $($inputFile)"
    Write-Host "Current Date: $currentDate"

    # Rest of your script using $inputFile.FullName
    # Number of days back to collect symbols
    $lookBack = -7

    $datenow = Get-Date -Format "MMddyyyy"
    $DaysAgo = (Get-Date).AddDays($lookBack).Date

    # Find dates in the specified range, grab stock symbols and recipe type
    $symbolsHashtable = @{}
    $regex = "\b[A-Z]{1,4}\b"

    Get-Content -Path $inputFile | ForEach-Object {
        if ($_ -match "^\d{1,2}/\d{1,2}/\d{2} \d{1,2}:\d{1,2}:\d{1,2}") {
            $fields = $_ -split ','
            if ($fields.Count -ge 7) {
                try {
                    $date = [datetime]::ParseExact($fields[0], "M/d/yy H:mm:ss", $null).Date
                    if ($date -ge $DaysAgo) {
                        if ($fields[2] -match $regex) {
                            $stockSymbol = $matches[0]
                            if ($fields[2] -match "\(3 Days\)") {
                                $type = "Moses"
                                #$symbolsHashtable["$stockSymbol Moses"] = $date
                            }
                            elseif ($fields[2] -match "\(Day\)") {
                                $type = "Recipe"
                                #$symbolsHashtable["$stockSymbol Recipe"] = $date
                            }
                            if ($fields[3] -like "*low*") {
                                $direction = "Up"
                                #$symbolsHashtable["$stockSymbol Up"] = $date
                            }
                            elseif ($fields[3] -like "*high*") {
                                $direction = "Down"
                                #$symbolsHashtable["$stockSymbol Down"] = $date
                            }
                            else  {
                                $direction = "Undetermined"
                                #$symbolsHashtable["$stockSymbol Undetermined"] = $date
                            }
                            $symbolsHashtable["$stockSymbol $type $direction"] = $date
                        }
                    }
                }
                catch {
                    # Ignore the line if the date cannot be parsed
                    continue
                }
            }
        }
    }

    Set-PSDebug -Trace 2

    Write-Host ("Before chunk 1")
    foreach ($key in $symbolsHashtable.Keys) {
    Write-Host ("Key: " + $key + ", Value: " + $symbolsHashtable[$key])
    }
    
    # Output the list to a window
    #$sortedSymbolsList = $symbolsHashtable.GetEnumerator() | Sort-Object Name | ForEach-Object {
    #    $stockRecipe = $_.Name -split ' '
    #    if ($_ -like "*low*") {
    #        "{0,-6} {1,-8} {2} Up" -f $stockRecipe[0], $stockRecipe[1], $_.Value.ToString("MM/dd/yyyy")
    #    } elseif ($_ -like "*high*") {
    #        "{0,-6} {1,-8} {2} Down" -f $stockRecipe[0], $stockRecipe[1], $_.Value.ToString("MM/dd/yyyy")
    #    }  
    #    else {
    #        "{0,-6} {1,-8} {2} Undetermined" -f $stockRecipe[0], $stockRecipe[1], $stockRecipe[2], $_.Value.ToString("MM/dd/yyyy")
    #    }
    #}

    Write-Host ("After chunk 1, the list is " + $sortedSymbolsList)
    
    $sortedSymbolsList = $symbolsHashtable.GetEnumerator() | Sort-Object Name | ForEach-Object {
        $stockRecipe = $_.Name -split ' '
        "{0,-6} {1,-8} {2}" -f $stockRecipe[0], $stockRecipe[1], $stockRecipe[2], $_.Value.ToString("MM/dd/yyyy")
    }

    $sortedSymbolsList | Out-String | Write-Host

}
else {
    # Throw an error if no CSV file is found
    throw "No CSV file found in the current directory."
}

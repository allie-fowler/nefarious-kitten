# Get the first CSV file in the current directory

param (
    [string]$inputFile = ""
)

# Check if the input file parameter is empty
if ([string]::IsNullOrEmpty($InputFile)) {
    $inputFile = Get-ChildItem -Path . -Filter "*AlertBook.csv" | Select-Object -First 1
}

$PSVersionTable.PSVersion


# Check if a matching file was found
if ($inputFile) {
    # Use the file as your input
    # $inputFile.FullName contains the full path to the file
    Write-Host "Using file: $($inputFile)"
    
    # Check if the file was not modified today
    $fileModifyDate = (Get-ItemProperty -Path $inputFile -Name LastWriteTime).LastWriteTime.Date.ToString('yyyy-MM-dd').Trim()
    $currentDate = (Get-Date -Format 'yyyy-MM-dd').Trim()

    if ($fileModifyDate -ne $currentDate) {
        Write-Host "::warning::The input file was not modified today."
    }

    # Rest of your script using $inputFile.FullName
    # Number of days back to collect symbols
    $lookBack = -7

    $datenow = Get-Date -Format "MMddyyyy-HHmmss"
    $DaysAgo = (Get-Date).AddDays($lookBack)
    $regex = "\b[A-Z]{1,4}\b"

    # Find dates in the specified range, grab stock symbols and recipe type
    $symbolsList = Get-Content -Path $inputFile | ForEach-Object {
    if ($_ -match "\b(\d{1,2}/\d{1,2}/\d{2})\b") {
        $date = [datetime]::ParseExact($matches[1], "M/d/yy", $null)
        if ($date -ge $DaysAgo) {
            if ($_ -match $regex) {
                $stockSymbol = $matches[0]
                if ($_ -match "\(3 Days\)") {
                    Write-Output "$stockSymbol		 Moses"
                }
                elseif ($_ -match "\(Day\)") {
                    Write-Output "$stockSymbol		 Recipe"
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


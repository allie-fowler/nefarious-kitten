param (
# Should be a tos alert export file
    [Parameter(Mandatory=$true)]
    [string]$InputFile
)

# Number of days back to collect symbols
$lookBack = -7

$datenow = Get-Date -Format "MMddyyyy-HHmmss"
$DaysAgo = (Get-Date).AddDays($lookBack)
$regex = "\b[A-Z]{1,4}\b"

# Find dates in the specified range, grab stock symbols and recipe type
$symbolsList = Get-Content -Path $InputFile | ForEach-Object {
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
$wshell = New-Object -ComObject Wscript.Shell
$Output = $wshell.Popup($symbolsList,0,"header",0+64)

# Get the recipesUP SYM file in the input directory

param (
    [string]$inputFile = ""
)

# Check if the input file parameter is empty
if ([string]::IsNullOrEmpty($InputFile)) {
    $inputFile = Get-ChildItem -Path . -Filter "input/recipe*UP.sym" | Select-Object -First 1
}

# Check if a matching file was found
if ($inputFile) {
    # Use the file as  input
    # $inputFile.FullName contains the full path to the file
    Write-Host "Using file: $($inputFile)"    
    
    # Retrieve the file's modify date
    $fileCreationDate = (Get-Item $inputFile.FullName).LastWriteTime.ToString()
    Write-Host "File Modify Date: $fileCreationDate"

    # Find dates in the specified range, grab stock symbols and recipe type
    $symbols = Get-Content -Path $inputFile.FullName | ForEach-Object { $_.Trim() } | Sort-Object -Unique -Join ", "
} 

$watchlist = @{
    name = "mywatchlist"
    watchlistItems = @(
        @{
            symbol = $symbols
        }
    )
}

Write-Host "UP recipes: $($watchlist.watchlistItems[0].symbol)"

#$json = $watchlist | ConvertTo-Json
#$headers = @{
#    Authorization = "Bearer <access_token>"
#    ContentType = "application/json"
#}

# Later we might add directly to ToS with the following technique
#Invoke-RestMethod -Uri "https://api.tdameritrade.com/v1/accounts/<account_id>/watchlists/<watchlist_id>" -Method Put -Headers $headers -Body $json

# Get the recipeUP or recipesUP SYM file in the input directory

# Check if a matching file exists
$inputFile = Get-ChildItem -Path "./input" -Filter "recipe*UP.sym" | Select-Object -First 1

# If a file was found, use it as input
if ($inputFile) {
    # Use the file as input
    Write-Host "Using file: $($inputFile.FullName)"
    
    # Retrieve the file's modify date
    $fileCreationDate = (Get-Item $inputFile.FullName).LastWriteTime.ToString()
    Write-Host "File Modify Date: $fileCreationDate"

    # Find dates in the specified range, grab stock symbols and recipe type
    $symbols = Get-Content -Path $inputFile.FullName | ForEach-Object { $_.TrimStart('=') } | Where-Object { $_ -ne "" } | Sort-Object -Unique
    $symbolString = $symbols -join ", "
} 

$watchlist = @{
    name = "mywatchlist"
    watchlistItems = @(
        @{
            symbol = $symbolString
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

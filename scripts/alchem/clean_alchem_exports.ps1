# Define the file patterns to search for
$filePatterns = @("recipe*UP.sym", "recipe*DOWN.sym")

# Initialize an empty hashtable to store the symbols
$watchlist = @{
    name = "mywatchlist"
    watchlistItems = @()
}

# Iterate over the file patterns
foreach ($filePattern in $filePatterns) {
    # Check if a matching file exists
    $inputFile = Get-ChildItem -Path "./input" -Filter $filePattern | Select-Object -First 1

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

        # Determine the recipe label based on the filename
        $recipeLabel = if ($filePattern -like "*UP*") { "UP" } else { "DOWN" }

        # Add the symbol string with the corresponding recipe label to the watchlist hashtable
        $watchlistItem = @{
            symbol = $symbolString
            recipeType = $recipeLabel
        }
        $watchlist.watchlistItems += $watchlistItem
    }
}

# Output the results
foreach ($item in $watchlist.watchlistItems) {
    Write-Host "Recipes $($item.recipeType): $($item.symbol)"
}

#$json = $watchlist | ConvertTo-Json
#$headers = @{
#    Authorization = "Bearer <access_token>"
#    ContentType = "application/json"
#}

# Later we might add directly to ToS with the following technique
#Invoke-RestMethod -Uri "https://api.tdameritrade.com/v1/accounts/<account_id>/watchlists/<watchlist_id>" -Method Put -Headers $headers -Body $json

# Get the recipesUP SYM file in the input directory

param (
    [string]$inputFile = ""
)

# Check if the input file parameter is empty
if ([string]::IsNullOrEmpty($InputFile)) {
    $inputFile = Get-ChildItem -Path . -Filter "input/*recipe*UP.sym" | Select-Object -First 1
}

$symbols = Get-Content $inputFile

$watchlist = @{
    name = "mywatchlist"
    watchlistItems = @(
        @{
            symbol = "$symbols"
        }
    )
}
$json = $watchlist | ConvertTo-Json
$headers = @{
    Authorization = "Bearer <access_token>"
    ContentType = "application/json"
}

# Later we might add directly to ToS with the following technique
#Invoke-RestMethod -Uri "https://api.tdameritrade.com/v1/accounts/<account_id>/watchlists/<watchlist_id>" -Method Put -Headers $headers -Body $json

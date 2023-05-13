param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile
)

$symbols = Get-Content $InputFile

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

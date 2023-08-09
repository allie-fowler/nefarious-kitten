# nefarious-kitten

Before beginning with either option, create a branch for yourself
In this Github repo:
* Click on "Main" branch
* In the "Find or create a branch" text box, create any descriptive name for your new branch
* Click "Create branch:<my-branch>" from main

Proceed with either or both of the following choices
  
## Clean and sort alerts exported from ToS.
In ToS:
* Alerts
* Actions Menu
* Export To File
* Accept the default file name in format YYYY-MM-DD-AlertBook.csv and save
* In your GitHub branch created above, Click on the "input" subdirectory
* Upload your exported Alerts file by clicking "Add File" and then dragging or choosing your previously downloaded Alerts file.
* Click "Commit changes"

See the output:
* Click "Actions"
* Click "Get Recent Tos recipe hits" on the left
* In the list of "green checkmark" runs, the top item should be VERY recent like "now" or "1 minute ago".  Click the item.
* Click the green checkmark labelled "Recipe / Moses hits"
* Click the drop-down arrow labelled "Run the recent_recipes_from_ToS.ps1" script

Behold the cleaned and sorted output to add to your quote sheet!

## Reformat exported quote sheets from Alchem to input into ToS.

In Alchem:
* Export your Alchem quote sheets to files named both RecipesUP.sym and RecipesDOWN.sym
* In your GitHub branch created above, Click on the "input" subdirectory
* Upload your exported Alerts file by clicking "Add File" and then choosing your two previously exported recipes<UP|DOWN>.sym files.
* Click "Commit changes"

See the output:
* Click "Actions"
* Click "Scrub Alchem exports" on the left
* In the list of "green checkmark" runs, the top item should be VERY recent like "now" or "1 minute ago".  Click the item.
* Click the green checkmark labelled "Scrub Alchem exports"
* Click the drop-down arrow labelled "Clean Up and Down recipe exports from Alchem"
* Using your mouse, copy the items in the "Recipes Up" line
* In the ToS watchlist dropdown, select "edit" and then choose your RecipesUp watchlist.
* Click import.
* Select "Paste from Clipboard" and "Replace current symbols"

Your watchlist is now synced with your Alchem quote sheet

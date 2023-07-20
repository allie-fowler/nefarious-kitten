# nefarious-kitten
## Clean and sort alerts exported from ToS.

In ToS:
* Alerts
* Actions Menu
* Export To File
* Accept the default file name in format YYYY-MM-DD-AlertBook.csv and save

In this Github repo:
* Click on "Main" branch
* In the "Find or create a branch" text box, create any descriptive name for your new branch
* Click "Create branch:<my-branch>" from main
* Click on the "input" subdirectory
* Delete any previously existing files of format YYYY-MM-DD-AlertBook.csv by clicking on it, selecting the three dots, and selecting "Delete file", then "Commit changes"
* Upload your exported Alerts file by clicking "Add File" and then dragging or choosing your previously downloaded Alerts file.
* Click "Commit changes"

Process the input file:
* Click "Actions"
* Click "Get Recent Tos recipe hits" on the left
* Click "Run Workflow" on the right
* Under "Use workflow from" select the name of the branch you created above
* It may take 15 seconds or so before you see evidence of it running
* AFter it runs for another 15-30 seconds, there should be a new green checkmark in the list with a timestamp of "now"
* Click the name, "Get Recent ToS recipe hits"
* Click the green checkmark labelled "Recipe / Moses hits"
* Click the drop-down arrow labelled "Run the recent_recipes_from_ToS.ps1" script

See your cleaned and sorted output!

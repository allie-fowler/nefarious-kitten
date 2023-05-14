Describe "Testing scripts/tos/recent_recipes_from_tos.ps1" {
    Context "When executing recent_recipes_from_tos.ps1" {
        It "Should complete without any errors" {
            # Run your script and capture the output
            $output = & "scripts/tos/recent_recipes_from_tos.ps1"

            # Check if the script completed without errors
            $success = $LASTEXITCODE -eq 0
            
            # Assert the test
            $success | Should Be $true
        }

        It "Should produce the expected output" {
            # Run your script and capture the output
            $output = & "scripts/tos/recent_recipes_from_tos.ps1"

            # Define the expected output
            $expectedOutput = "AAPL		 Recipe
ACN		 Recipe
CF		 Recipe
EXAS		 Recipe
FDX		 Recipe
SNOW		 Recipe
SPWR		 Moses
SPWR		 Recipe
TDOC		 Recipe
TEAM		 Recipe
URI		 Recipe"
            
            # Assert the test
            $output | Should Be $expectedOutput
        }
    }
}


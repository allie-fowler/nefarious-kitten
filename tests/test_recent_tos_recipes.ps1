Describe "Testing MyScript.ps1" {
    Context "When executing MyScript.ps1" {
        It "Should complete without any errors" {
            # Run your script and capture the output
            $output = & "MyScript.ps1"

            # Check if the script completed without errors
            $success = $LASTEXITCODE -eq 0
            
            # Assert the test
            $success | Should Be $true
        }

        It "Should produce the expected output" {
            # Run your script and capture the output
            $output = & "MyScript.ps1"

            # Define the expected output
            $expectedOutput = "Hello, World!"
            
            # Assert the test
            $output | Should Be $expectedOutput
        }
    }
}


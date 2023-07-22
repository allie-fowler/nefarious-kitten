name: Scrub Alchem exports
on: 
  pull_request: 
  workflow_dispatch:
  push:
    paths:
      - 'input/*.sym'
      - 'scripts/alchem/clean_alchem_exports.ps1'
jobs:
  get-hits:
    name: Scrub Alchem exports
    runs-on: ubuntu-latest
    steps:
    - name: Check out repository code
      uses: actions/checkout@v3
      with:
        fetch-depth: 0
    - name: Clean Up and Down recipe exports from Alchem
      shell: pwsh
      run: |
        scripts/alchem/clean_alchem_exports.ps1   

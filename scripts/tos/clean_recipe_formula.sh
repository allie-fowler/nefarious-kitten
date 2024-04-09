#!/bin/bash
#Expect only one parameter containing a ToS alert script
s=$1

declare -A replacements=(
    # Operators
    ['is greater than']='>'
    [' or equal to']='='
    ['is less than']='<'
    [' and ']=', '
    ['reference ']=''

    # CC area
    ['BollingerBands(length = 21).UpperBand']='tbb'
    ['BollingerBands(length = 21).LowerBand']='bbb'

    # SRSI area
    ['shared_rp_wsb_StochRSI().D']='%D'
    ['shared_rp_wsb_StochRSI().K']='%K'
    
    # MACD area
    ['shared_rp_wsb_MACD().Value']='MACD fast'
    ['shared_rp_wsb_MACD().Avg']='MACD slow'
    ['shared_rp_wsb_MACD().Diff']='Hist'
    ['MACDaf(select = THREE_DAYS).Value']='3D: MACD fast'
    ['MACDaf(select = THREE_DAYS).Signal']='3D: MACD slow'
    ['MACDaf(select = THREE_DAYS).Diff']='3D: MACD Hist'
    ['MACDaf(select = WEEK).Value']='W: MACD fast'
    ['MACDaf(select = WEEK).Signal']='W: MACD slow'
    ['MACDaf(select = WEEK).Diff']='W: MACD Hist'
    ['MACDaf(select = MONTH).Value']='M: MACD fast'
    ['MACDaf(select = MONTH).Signal']='M: MACD slow'
    ['MACDaf(select = MONTH).Diff']='M: MACD Hist'

    # DM area
    ['DIMinus(length = 5)']=-'DI'
    ['DIPlus(length = 5)']='+DI'
    ['DIaf(select = THREE_DAYS).DIg']='3D: -DI'
    ['DIMinusAF(select = THREE_DAYS)']='3D: -DI'
    ['DIaf(select = THREE_DAYS).DIr']='3D: +DI'
    ['DIaf(select = WEEK).DIg']='W: -DI'
    ['DIMinusAF(select = WEEK)']='W: -DI'
    ['DIaf(select = WEEK).DIr']='W: +DI'
    ['DIaf(select = MONTH).DIg']='M: -DI'
    ['DIaf(select = MONTH).DIr']='M: +DI'
    
)

# Make the replacements
for i in "${!replacements[@]}"
do
    s=${s//$i/${replacements[$i]}}
done

# Massage the string for pretty output
# Split the input string by comma and space
IFS=", " read -ra items <<< "$s"

# Initialize empty arrays for each group
declare -a group_3D
declare -a group_W
declare -a group_M
declare -a group_other

# Iterate through the items and categorize them
for item in "${items[@]}"; do
    if [[ $item == "3D:"* ]]; then
        group_3D+=("$item")
    elif [[ $item == "W:"* ]]; then
        group_W+=("$item")
    elif [[ $item == "M:"* ]]; then
        group_M+=("$item")
    else
        group_other+=("$item")
    fi
done

# Print the grouped items
echo "Default Timeframe:"
for item in "${group_other[@]}"; do
    echo "$item"
done

echo "3D:"
for item in "${group_3D[@]}"; do
    echo "$item"
done

echo "W:"
for item in "${group_W[@]}"; do
    echo "$item"
done

echo "M:"
for item in "${group_M[@]}"; do
    echo "$item"
done

echo "Copy and paste to Alchem:"
echo "$s"

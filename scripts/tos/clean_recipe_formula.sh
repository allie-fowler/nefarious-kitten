#!/bin/bash
set +x

declare -A replacements=(
    # Operators
    ['is greater than']='>'
    [' or equal to']='='
    ['is less than']='<'
    [' and ']=', '

    # CC area
    ['reference BollingerBands(length = 21).UpperBand']='tbb'
    ['reference BollingerBands(length = 21).LowerBand']='bbb'

    # SRSI area
    ['shared_rp_wsb_StochRSI().D']='%D'
    ['shared_rp_wsb_StochRSI().K']='%K'
    
    # MACD area
    ['shared_rp_wsb_MACD().Value']='MACD fast'
    ['shared_rp_wsb_MACD().Average']='MACD slow'
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
    ['DIaf(select = THREE_DAYS).DIr']='3D: +DI'
    ['DIaf(select = WEEK).DIg']='W: -DI'
    ['DIaf(select = WEEK).DIr']='W: +DI'
    ['DIaf(select = MONTH).DIg']='M: -DI'
    ['DIaf(select = MONTH).DIr']='M: +DI'
    
)

s=$1

# Make the replacements
for i in "${!replacements[@]}"
do
    s=${s//$i/${replacements[$i]}}
done

echo "$s"

IFS=',' read -r -a array <<< "$s"

main_items=()
threeD_items=()
W_items=()

current_section=main_items

for element in "${array[@]}"; do
    trimmed_element=$(echo "$element" | xargs)  # Trim leading and trailing whitespaces

    if [[ $trimmed_element == "3D:"* ]]; then
        current_section=threeD_items
        trimmed_element=${trimmed_element#"3D: "}  # Remove prefix
    elif [[ $trimmed_element == "W:"* ]]; then
        current_section=W_items
        trimmed_element=${trimmed_element#"W: "}  # Remove prefix
    fi

    if [[ $current_section == main_items ]]; then
        main_items+=("$trimmed_element")
    elif [[ $current_section == threeD_items ]]; then
        threeD_items+=("$trimmed_element")
    elif [[ $current_section == W_items ]]; then
        W_items+=("$trimmed_element")
    fi
done

echo "${main_items[*]},"
echo -e "\n3D:"
echo "* ${threeD_items[*]},"
echo -e "\nW:"
echo "* ${W_items[*]},"

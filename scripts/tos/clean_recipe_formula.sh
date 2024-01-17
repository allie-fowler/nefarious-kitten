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

declare -a main_array
declare -a threeD_array
declare -a W_array

prefix=""
for element in "${array[@]}"
do
    trimmed_element="$(echo -e "${element}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    if [[ $trimmed_element == "3D:"* ]]
    then
        prefix="3D"
        threeD_array+=("${trimmed_element:4}")
    elif [[ $trimmed_element == "W:"* ]]
    then
        prefix="W"
        W_array+=("${trimmed_element:3}")
    else
        if [[ $prefix == "3D" && $trimmed_element != "3D:"* && $trimmed_element != "W:"* ]]
        then
            threeD_array+=("$trimmed_element")
        elif [[ $prefix == "W" && $trimmed_element != "3D:"* && $trimmed_element != "W:"* ]]
        then
            W_array+=("$trimmed_element")
        else
            main_array+=("$trimmed_element")
            prefix=""
        fi
    fi
done

echo "${main_array[*]},"
echo -e "\n3D:"
printf "* %s,\n" "${threeD_array[*]}"
echo -e "\nW:"
printf "* %s,\n" "${W_array[*]}"

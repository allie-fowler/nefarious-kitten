#!/bin/bash

declare -A replacements=(
    ["is greater than"]=">"
    [" or equal to"]="="
    ["is less than"]="<"
    ["reference BollingerBands(\"length\" = 21).\"UpperBand\""]="tbb"
    ["reference BollingerBands(\"length\" = 21).\"LowerBand\""]="bbb"
    ["DIMinus("length" = 5)"]="-DI"
    ["DIPlus("length" = 5)"]="+DI" 
)

s=$1

for i in "${!replacements[@]}"
do
    s=${s//$i/${replacements[$i]}}
done

echo "$s"

#!/bin/bash

declare -A replacements=(
    # Operators
    ['is greater than']=">"
    [' or equal to']="="
    ['is less than']="<"
    [' and ']=", "

    # CC area
    ['reference BollingerBands("length" = 21)."UpperBand"']='tbb'
    ['reference BollingerBands("length" = 21)."LowerBand"']='bbb'

    # SRSI area
    ['shared_rp_wsb_StochRSI()."D"']='%D'
    ['shared_rp_wsb_StochRSI()."D"']='%K'
    
    # MACD area
    ['shared_rp_wsb_MACD()."Value"']='MACD fast'
    ['shared_rp_wsb_MACD()."Average"']='MACD slow'
    ['shared_rp_wsb_MACD()."Diff"']='Hist'
    ['MACDaf("select" = "THREE_DAYS")."Value"']='3D: MACD fast'
    ['MACDaf("select" = "THREE_DAYS")."Signal"']='3D: MACD slow'
    ['MACDaf("select" = "THREE_DAYS")."Diff"']='3D: MACD Hist'
    ['MACDaf("select" = "WEEK")."Value"']='W: MACD fast'
    ['MACDaf("select" = "WEEK")."Signal"']='W: MACD slow'
    ['MACDaf("select" = "WEEK")."Diff"']='W: MACD Hist'
    ['MACDaf("select" = "MONTH")."Value"']='M: MACD fast'
    ['MACDaf("select" = "MONTH")."Signal"']='M: MACD slow'
    ['MACDaf("select" = "MONTH")."Diff"']='M: MACD Hist'

    # DM area
    ['DIMinus("length" = 5)']="-DI"
    ['DIPlus("length" = 5)']="+DI"
    ['DIaf("select" = "THREE_DAYS")."DIg"']="3D: -DI"
    ['DIaf("select" = "THREE_DAYS")."DIr"']="3D: +DI"
    ['DIaf("select" = "WEEK")."DIg"']="W: -DI"
    ['DIaf("select" = "WEEK")."DIr"']="W: +DI"
    ['DIaf("select" = "MONTH")."DIg"']="M: -DI"
    ['DIaf("select" = "MONTH")."DIr"']="M: +DI"
    
)

s=$1

for i in "${!replacements[@]}"
do
    s=${s//$i/${replacements[$i]}}
done

echo "$s"

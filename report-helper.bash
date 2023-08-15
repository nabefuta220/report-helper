#!/bin/bash

KINDS="図 表 リスト"
INPUT="report_test.md"
OUTPUT="report_base.md"

# more report1.md | grep "[図表][0-9]+(-[0-9]+)+" -E -o | sort | uniq -c | awk  '$1==1 {print $2 }' # missing cheaker

# url check : more report2.md | grep "\[(http.+)\]" -E -o
# base reflerencesr : 数字の後ろに' '
# shoud next : 次の図表番号
#replaceer : 

# graphe num : more $INPUT | grep "$KIND[0-9]+(-[0-9]+)+" -E -o  | uniq

cp $INPUT $OUTPUT 
for KIND in $KINDS;do
    TAREGTS=`more $INPUT | grep "$KIND[0-9]+(-[0-9]+)+" -E -o  |sort|uniq` # filter

    COUNT=1;
    for TARGET in $TAREGTS
    do
        echo "$TARGET $COUNT"
        sed "s/$TARGET/$KIND$COUNT/g" $OUTPUT -i
        COUNT=`expr $COUNT + 1`
    done

done
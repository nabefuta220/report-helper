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



replace_label(){

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
}
## 追加の引数を受け取る、引数はoutputに入る
get_addional_argument(){
     if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]] ; then
        echo "$1 requires an argument." 1>&2
        exit 1
    else
        output="$2"
    fi
}
## main
    echo "test"
    input="$1"
    shift
    while (( $# > 0 )) 
do
    case $1 in
    
    -r | --replace )
    echo "replace at:$2"
    get_addional_argument $1 $2
    shift
    ;;
    -l | --link )
    echo "replace link"
    get_addional_argument $1 $2
    shift
    ;;
    -c | --check)
    echo "check label"
    ;;
    -n | --next)
    echo "find next"
    get_addional_argument $1 $2
    shift
    ;;
    -h | --help)
    echo "help"
    ;;

    -* | --*)
        echo "invalid option."
        echo "at: $1"
        exit 1
    
    
    esac
    shift
    done
    echo "input file :$input"
    echo "output file : $output"
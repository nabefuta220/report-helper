#!/bin/bash

KINDS="図 表 リスト"
#INPUT="report_test.md"
#OUTPUT="report_base.md"

# more report1.md | grep "[図表][0-9]+(-[0-9]+)+" -E -o | sort | uniq -c | awk  '$1==1 {print $2 }' # missing cheaker

# url check : more report2.md | grep "\[(http.+)\]" -E -o
# base reflerencesr : 数字の後ろに' '
# shoud next : 次の図表番号
#replaceer : 

# graphe num : more $INPUT | grep "$KIND[0-9]+(-[0-9]+)+" -E -o  | uniq
#ラベルの整合性をチェックする
check_label(){
    for KIND in $KINDS;do
    ##重複したラベルがあるか調べる
        DUPLICATED_LAEBELS=`more $1 | grep "$KIND[0-9]+(-[0-9]+)+ " -E -o  | awk 'a[$0]++{print}'`
        if [[ ! -z $DUPLICATED_LAEBELS  ]] ; then
            for  DUPLICATED_LAEBEL in $DUPLICATED_LAEBELS ; do
                LINES=`sed -n "/$DUPLICATED_LAEBEL /=" $1| tr '\n' ','`
                LINES=${LINES/%?/}
                echo -e "error: chapture of $DUPLICATED_LAEBEL appers multiple place (line: ${LINES})" 1>&2
                exit 1
            done
        else
        ##参照しているところが1つ以上あるか調べる
            UNIQUE_LABELS=`more $1 | grep "$KIND[0-9]+(-[0-9]+)+ " -E -o  | awk '!a[$0]++{print}'`
            REFERED_LABELS=`more $1 | grep "$KIND[0-9]+(-[0-9]+)+" -E -o  | awk '!a[$0]++{print}'`
            
            for UNIQUE_LABEL in $UNIQUE_LABELS; do
                CHAPTURE_LINE=`sed -n "/$UNIQUE_LABEL /=" $1`
                LINES=`sed -n -e "/$UNIQUE_LABEL[^ ]/=" $1`
                REFERED_LABELS=${REFERED_LABELS/$UNIQUE_LABEL/''}
                if [[ -z $LINES ]] ;then 
                    echo -e "warning : label $UNIQUE_LABEL dosen't appeare (first chapture : line $CHAPTURE_LINE)" 1>&2
                fi
            done
            REFERED_LABELS=`echo $REFERED_LABELS | grep "$KIND[0-9]+(-[0-9]+)+" -E -o`
            if [[ ! -z $REFERED_LABELS ]] ;then 
                for REFERED_LABEL in $REFERED_LABELS ; do
                    LINES=`sed -n "/$REFERED_LABEL/=" $1 | tr '\n' ','`
                    LINES=${LINES/%?/}
                    echo -e "warning: label $REFERED_LABEL dosen't have chapture (first appered : line $LINES)" 1>&2
                done;
            fi
        fi

        
    done
    echo "check passed!"
    exit 0
}
#ラベルを張り替える
replace_label(){

cp $1 $2 
for KIND in $KINDS;do
    TAREGTS=`more $1 | grep "$KIND[0-9]+(-[0-9]+)+" -E -o  |sort|uniq` # filter
    COUNT=1;
    for TARGET in $TAREGTS
    do
        echo "$TARGET $COUNT"
        sed "s/$TARGET/$KIND$COUNT/g" $2 -i
        COUNT=`expr $COUNT + 1`
    done

done
echo "replaced!"
exit 0
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
##helpを表示
usage(){
    cat usage.txt
    exit 0
}
## main
    echo "test"
    input="$1"
    shift
    if [[ $input = '-h' ]] ; then
    usage
    fi
    while (( $# > 0 )) 
do
    case $1 in
    
    -r | --replace )
    echo "replace at:$2"
    get_addional_argument $1 $2
    shift
    replace_label $input $output
    ;;
    -l | --link )
    echo "replace link"
    get_addional_argument $1 $2
    shift
    ;;
    -c | --check)
    echo "check label"
    check_label $input $output
    ;;
    -n | --next)
    echo "find next"
    get_addional_argument $1 $2
    shift
    ;;
    -h | --help)
    echo "help"
    usage
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
log_file=check_${MODULE}.log

echo "" > $log_file

for sf in `find default -name '*.template'`
do
    f=${sf/default/${MODULE}}
    f=${f//module/${MODULE}}
    f=${f/.template/}
    echo "
==========================================================================================
${f}
" >> $log_file
    diff -y --suppress-common-lines $sf $f >> $log_file
done

grep module ${MODULE} ${MODULE}/{inc,src,test}

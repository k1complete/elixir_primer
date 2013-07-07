OUT=`basename $1 sh`tmp
OUT2=`basename $1 sh`lst
echo $OUT
echo $OUT2
export IN=$1
export PS1='$ '
cat > $OUT <<EOF
spawn bash -i
log_file $OUT2
expect "\\\$ "
EOF
cat $IN | awk '{ printf "send \"%s\\n\"\n", $0; print "expect \"\\\$ \"\n"}' >> $OUT
cat >> $OUT <<EOF2
close
#interact
EOF2
touch $OUT2
rm -f $OUT2
expect -f $OUT


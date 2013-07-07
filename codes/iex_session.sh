OUT=`basename -s exs $1`cmd
OUT2=`basename -s exs $1`tmp
OUT3=`basename -s exs $1`lst
PS1='$ '
touch $OUT
rm $OUT
cat > $OUT <<EOF
spawn bash -i 
expect "\\\$ "
send "iex \\n"
log_file $OUT2
expect  "iex*\> "
EOF
sed 's/[][\"]/\\&/g' $1 | awk '{printf " send \"%s\\n\"\n", $0; print " expect {\n*(*)> }\n" }' >> $OUT
cat >> $OUT2 <<EOF2
interact
close
EOF2
touch $OUT2
rm -f $OUT2
expect  -f $OUT
sed -e '1,3d' -e 's/\[[0-9][0-9]*m//g' -e 's///'  $OUT2 |fold -w 80  > $OUT3

#!/usr/bin/env zsh

T=".drive-test"; R="drive-test"
RNDID=$(openssl rand -base64 10 | tr -d /+= | head -c 5)
D="$T-$RNDID.data"

rm .drive-test*.data
rm .drive-test*

B=512k; N=512;

TESTPATH=${1:-"/please/supply/path"}

# Get the drive identifier for the current directory
echo -e "\nTesting $TESTPATH\n"

cd $TESTPATH
df -P $TESTPATH

ID=$(df -P $TESTPATH | tail -1 | sed -E -e 's~ *(/[^ ]*) .*~\1~' -e 's~/dev/~~' -e 's~/~~g')
MACHINE=$(hostname -s)


function dinfo() {
    local D=$1
    local T=$2
    diskutil info "$1" | grep "$T" | sed "s~.*: *~~" | cut -w -f1
}

dloc=$(dinfo $ID "Location")
dname=$(dinfo $ID "Volume Name")
duuid=$(dinfo $ID "Volume UUID" | tail -c 4)

R=$(echo "$R-$MACHINE-$dloc-$dname-$duuid-$ID" | tr "/?:. '\"" "-")
R="$TESTPATH/$R.md"
echo -e "\nReport File: $R\n"

printf "# Drive Test: %s on " $ID | tee $R;
uname -mnp | tee -a $R
printf "\n\n" tee -a $R

diskutil info $ID | grep -Ei "(Volume UUID:)|(Name:)|(Disk Size:)|(State:)|(Point:)|(Location:)" | sed -E "s~(: [^\(-]*)[\(-].*~\1…~" | tee -a $R
printf "\n" tee -a $R


printf "Continue with write/read test? (y/n)?  "
read -k1 -s REPLY
echo "  $REPLY"

echo
if ! [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\nCancelled\n"
    exit 1
fi    

function B2Mb() {
    local B="$1"
    echo "${B}*8/(1024*1024)" | bc
}

function readresult() {
    RN=$1;
    echo "  Reading $RN" >&2;
    grep bytes $RN >&2;
    local BPS=$(cat $RN | grep bytes | sed -e 's~.*(~_~g' -e 's~[^0-9]~~g');
    echo "  Bytes/sec: $BPS" >&2; \
    local Mbps=$(B2Mb $BPS)
    echo $Mbps
}

DD_OPTS=(bs=$B count=$N iflag=direct oflag=direct)

DIR="Write"; R2="$T.w"; echo "## $DIR"
echo -e "\nWriting to $TESTPATH/$D …\n"
dd if=/dev/zero of=$TESTPATH/$D $DD_OPTS  2>&1 | tee $R2
echo ""

DIR="Read"; R2="$T.r"; echo "## $DIR"
echo -e "\Reading from $TESTPATH/$D …\n"
dd if=$TESTPATH/$D of=/dev/null $DD_OPTS  2>&1 | tee $R2
echo ""

#ls -la $TESTPATH/$D

# write random bytes to make sure data is accessed by read
#echo -e "\nWriting random bytes …\n"
#for ((i = 0 ; i < $((N/8)); i+=4 )); do
#    dd if=/dev/random bs=4 of=$TESTPATH/$D oseek=$i count=3 conv=notrunc >/dev/null 2</dev/null
#done
#ls -la $TESTPATH/$D
# 
#echo -e "\n--- $TESTPATH/$D Random Header---\n"
#hexdump -n 512 $TESTPATH/$D
#shasum $TESTPATH/$D
#echo ""

#cp $TESTPATH/$D $HOME/
#rm $TESTPATH/$D
#dd if=/dev/random bs=$B of=$TESTPATH/$D count=2 2>&1
#shasum $TESTPATH/$D
##cp $HOME/$D $TESTPATH/
#rm $HOME/$D
#shasum $TESTPATH/$D


#DIR="Read"; R2="$T.r"; echo "## $DIR"
#echo -e "\nWriting random bytes …\n"
#for ((i = 0 ; i < $((N/4)); i+=4 )); do
#    dd if=/dev/random bs=$B of=$TESTPATH/$D oseek=$i count=1 conv=notrunc >/dev/null 2</dev/null
#done
#ls -la $TESTPATH/$D
#echo -e "\nReading from $TESTPATH/$D …\n"
##dd if="$D" bs=$B of=/dev/null count=$N 2>&1 | tee $R2
#echo ""

echo "" | tee -a $R
DIR="Write"; R2="$T.w";
Mbps=$(readresult $R2); printf -- "- %-14s %'9d Mb/s\n" "$DIR Speed:" $Mbps | tee -a $R
DIR="Read"; R2="$T.r";
Mbps=$(readresult $R2); printf -- "- %-14s %'9d Mb/s\n" "$DIR Speed:" $Mbps | tee -a $R
echo "" | tee -a $R

rm $TESTPATH/$D


printf -- "\n --- $R ---\n\n"
cat $R
echo ""


#!/usr/bin/env zsh

T=".drive-test"; R="drive-test"
RNDID=$(openssl rand -base64 10 | tr -d /+= | head -c 5)
D="$T-$RNDID.data"

setopt nullglob
rm .drive-test*.data 2>/dev/null
rm .drive-test* 2>/dev/null

B=512k; N=512;

TESTPATH=${1:-"/please/supply/path"}

function dinfo() {
    local D=$1
    local T=$2
    diskutil info "$1" | grep "$T" | sed "s~.*: *~~" | cut -d' ' -f1
}

# Get the drive identifier for the current directory
echo -e "\nTesting drive for path: $TESTPATH\n"

cd $TESTPATH
df -P $TESTPATH

ID=$(df -P $TESTPATH | tail -1 | sed -E -e 's~ *(/[^ ]*) .*~\1~')
ID=$(echo $ID | sed -E -e 's~/dev/~~' -e 's~/~~g')
# diskutil info "$ID"


echo "Device ID: $ID"
PHYSICAL=$(dinfo $ID "Physical Store"); PHYSICAL=${PHYSICAL:-$ID}
echo "Physical Device ID: $PHYSICAL"
DISK=$(echo "$PHYSICAL" | sed -E -e 's~([^0-9]+[0-9]+)([^0-9]+[0-9]+)~\1~' )
echo ""
iostat -c1 $DISK
echo ""

MACHINE=$(hostname -s)


dloc=$(dinfo $ID "Location"  | tr -d "\n\""); printf "loc: [%s]\n" $dloc
dname=$(dinfo $ID "Volume Name"  | tr -d "\n\""); printf "name: [%s]\n" $dname
duuid=$(dinfo $ID "Volume UUID" | tr -d "\n\"" | tail -c 4); printf "uuid: [%s]\n" $duuid
dproto=$(dinfo $ID "Protocol" | tr -d "\n\""); printf "proto: [%s]\n" $dproto

ID=$(echo $ID | sed -E -e 's~/dev/~~' -e 's~/~~g')

R = "$TESTPATH/$R"
if [[ "$dloc" =~ "^External" ]]; then
    R="$R-$dname-$dloc-$dproto-$duuid-$ID"
else
    R="$R-$MACHINE-$dloc-$dname-$dproto-$duuid-$ID"
fi
R=$(echo "$R" |  tr "/?:. '\"" "-")
R="$R.md"
echo -e "\nReport File: $R\n"

printf "# Drive Test: %s (%s on %s)\n\n" "$dname" "$dloc" "$MACHINE" | tee $R;

diskutil info $ID | grep -Ei "(Volume UUID:)|(Name:)|(Protocol:)|(Disk Size:)|(State:)|(Point:)|(Location:)" | sed -E "s~(: [^\(-]*)[\(-].*~\1…~" | tee -a $R
printf "\n" tee -a $R

iostat $PHYSICAL

function ask_to_continue() {

    local REPLY=""
    printf "    --> Continue with write/read test? (y/n)?  "
    read -k1 -s REPLY 
    echo "  $REPLY"

    if ! [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "\nCancelled\n"
        exit 1
    fi
}

ask_to_continue    

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

DD_OPTS=(bs=$B iflag=direct oflag=direct)
echo -e "\ndd test\n" | tee -a $R
DDTEST=(dd if=/dev/zero of=/dev/null count=1)
DDTEST+=( $DD_OPTS )
printf "  |  %s\n" $DDTEST | tee -a $R

DDOUT=$( $DDTEST 2>&1 )
DDRV=$?

if ! (( DDRV == 0 )); then
    echo -e "\nTest returned with error code $DDRV: $DDOUT" | tee -a $R
    echo -e "\n ***  WARNING: dd test failed ***\n" | tee -a $R
    ask_to_continue
    DD_OPTS=(bs=$B)
else
    echo -e "dd test passed"
fi
 
DD_OPTS+=( "count=$N" )

DIR="Write"; R2="$T.w"; echo "## $DIR"
echo -e "\nWriting to $TESTPATH/$D …\n"
dd if=/dev/zero of=$TESTPATH/$D $DD_OPTS  2>&1 | tee $R2
echo ""

DIR="Read"; R2="$T.r"; echo "## $DIR"
echo -e "\Reading from $TESTPATH/$D …\n"
dd if=$TESTPATH/$D of=/dev/null $DD_OPTS  2>&1 | tee $R2
echo ""


printf "\ndd options used:\n" | tee -a $R
printf "    %s\n" $DD_OPTS | tee -a $R

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


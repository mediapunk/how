#!/usr/bin/env zsh

T=".drive-test"; R="drive-test"
RNDID=$(openssl rand -base64 10 | tr -d /+= | head -c 5)
D="$T-$RNDID.data"

setopt nullglob
rm .drive-test*.data 2>/dev/null
rm .drive-test* 2>/dev/null

B=1024k; N=1024;

TESTPATH=${1:-"/please/supply/path"}

function hr() { local N=20; local LINE=$(printf "%${N}s" " " | tr " " "${1}"); printf -- "\n %s \n\n" "${LINE}"; }

function dinfo() {
    local D=$1
    local T=$2
    diskutil info "$1" | grep "$T" | sed "s~.*: *~~" | cut -d' ' -f1
}

# Get the drive identifier for the current directory
echo -e "\nTesting drive for path: $TESTPATH\n"

cd $TESTPATH
df -P $TESTPATH


hr "-"
VID=$(df -P $TESTPATH | tail -1 | sed -E -e 's~ *(/[^ ]*) .*~\1~')
VID=$(echo $VID | sed -E -e 's~/dev/~~' -e 's~/~~g')
echo "  Virtual ID: $VID"
VDISK=$(echo "$VID" | sed -E 's~([^0-9]+[0-9]+)([^0-9]+[0-9]+)~\1~')
echo "  Virtual Disk: $VDISK"

PHYSID=$(dinfo $VID "Physical Store"); PHYSID=${PHYSID:-$VID}
echo "  Physical ID: $PHYSID"
PHYSDISK=$(echo "$PHYSID" | sed -E -e 's~([^0-9]+[0-9]+)([^0-9]+[0-9]+)~\1~' )
echo "  Physical Disk: $PHYSDISK"
hr "^"

# Only Physical Disks for iostat
#iostat -c1 $VID
#iostat -c1 $VDISK
#iostat -c1 $PHYSID
iostat -c1 $PHYSDISK


hr "~"

MACHINE=$(hostname -s)

#hr "="
#diskutil info "$VID" | grep -Ei "(num)|(id)|(device)|(name)"
#hr " "
#diskutil info "$VDISK" | grep -Ei "(num)|(id)|(device)|(name)"
#hr "-"
#diskutil info "$PHYSID" | grep -Ei "(num)|(id)|(device)|(name)"
#hr " "
#diskutil info "$PHYSDISK" | grep -Ei "(num)|(id)|(device)|(name)"
#hr "="

function diskprop() { local PROP="${2}"; diskutil info "${1}" | grep -Ei "[^ ] ${PROP}:" | grep -vi "no[t ] .*(no[t ]" | sed -E 's~[^:]*: *~~'; };
#export -f diskprop

#VOLNAME="$(diskprop "$VID" "name")"
#DEVICENAME="$(diskprop "$VDISK" "name")"

#echo "DEVICE/VOLUME: --> $DEVICENAME / $VOLNAME"
#hr "^"

#NAMES=($(diskprop $VID "name"; diskprop $VDISK "name"; diskprop $PHYSID "name"; diskprop $PHYSDISK "name"))
#printf -- "%s\n" $NAMES | uniq

UUIDS="$(diskprop $VID "uuid"; diskprop $VDISK "uuid"; diskprop $PHYSID "uuid"; diskprop $PHYSDISK "uuid")"
#echo "$UUIDS"
UUIDS=($(echo "$UUIDS" | uniq))
#echo "$UUIDS"
UUID_STR=$(printf -- "%.5s-" $UUIDS | sed -E 's~\-$~~')
echo "UUIDS: $UUID_STR"

hr "="
 

#SP_STORAGE_ID=$(system_profiler -detailLevel full -json SPStorageDataType | yq -P ".[][] | select(.bsd_name==\"$VID\")")
#echo "$SP_STORAGE_ID" | yq -P

#hr "v"
#PROTOCOL=$(echo "$SP_STORAGE_ID" | yq -P ".[].protocol")
#echo "Protocol: $PROTOCOL"
#hr "^"

#DATATYPE="SPNVMeDataType"
#if [[ "$PROTOCOL" == "USB" ]]; then DATATYPE="SPUSBDataType"; fi
#if [[ "$PROTOCOL" == "PCI-Express" ]]; then DATATYPE="SPNVMeDataType" ; fi


#hr "#"
#TYPE_ITEMS=$(system_profiler -json "$DATATYPE" 2>/dev/null | yq -P ".[][] | select((._items))")
#echo "$TYPE_ITEMS" | yq -P; hr "^"
#DISK_ITEMS=$(echo "$TYPE_ITEMS" | yq -P ".[] | select(.[].bsd_name==\"${PHYSDISK}\")")
#DISK_ITEMS=$(echo "$TYPE_ITEMS" | yq -P "._items[] | select(.[].bsd_name==\"${PHYSDISK}\")")
#echo "$DISK_ITEMS" | yq -P; hr "@"
#CONNECTION=$(echo "$DISK_ITEMS" | yq -P ".[]._name")
#echo "Connected to: $CONNECTION"
#hr ":"


dloc=$(dinfo $VID "Location"  | tr -d "\n\""); printf "loc: [%s]\n" $dloc
dname=$(dinfo $VID "Volume Name"  | tr -d "\n\""); printf "name: [%s]\n" $dname
duuid="$UUID_STR"
#(dinfo $VID "Volume UUID" | tr -d "\n\"" | tail -c 4); printf "uuid: [%s]\n" $duuid
dproto=$(dinfo $VID "Protocol" | tr -d "\n\""); printf "proto: [%s]\n" $dproto


if [[ "$dloc" =~ "^External" ]]; then
    R="$R-$dname-$dloc-$dproto-$duuid"
else
    R="$R-$MACHINE-$dloc-$dname-$dproto-$duuid"
fi
R=$(echo "$R" |  tr "/?:. '\"" "-")
R="$TESTPATH/$R.md"

hr "_"
echo -e "\nReport File: $R\n"

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


printf "# Drive Test: %s (%s on %s)\n\n" "$dname" "$dloc" "$MACHINE" | tee $R;

diskutil info $VID | grep -Ei "(Volume UUID:)|(Name:)|(Protocol:)|(Disk Size:)|(State:)|(Point:)|(Location:)" | sed -E "s~(: [^\(-]*)[\(-].*~\1…~" | tee -a "$R"
printf "\n" tee -a "$R"



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


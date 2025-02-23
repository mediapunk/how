

# Get a summary of Drive capacity

    VOLS=(/Volumes/*(N))
    DISKS=($(for V in $VOLS; do df -P $V | tail -1 | cut -d' ' -f1; done))
    USERDISKS=( $(for D in $DISKS; do printf "\n$D "; diskutil info $D | grep -E "OS Can Be Installed.*: *Yes"; done | grep Yes | cut -d' ' -f1))
    function disksummary() { echo "$1:"; diskutil info $1 | grep -E "(Name:)|(Mount Point:)|(Space:)|(Status:)|(Location:)" | sed -E 's~\(.*\)$~~'; }
    for D in $USERDISKS; do disksummary $D; done

    function diskinfo() { echo "$1:"; diskutil info $1 | grep -E "$2" | sed -E 's~\(.*\)$~~'; } 
    DISKS=($(df -l -P | cut -d' ' -f1)); printf "[%s]\n" $DISKS 
    YQFILTER='to_entries[] | select(.["value"]["Media OS Use Only"]=="No") | select(.["value"]["Media Read-Only"]=="No") | .key'
    DISKS2=( $(for D in $DISKS; do diskinfo $D "Only" 2>/dev/null; done | yq -r $YQFILTER) )


### Find drives using at least 10GB and over 10% capacity" 
    df -P -l -H | awk '{print $1, $3, $5, $6}' | grep "[0-9][0-9]G" | grep "[0-9][0-9]%"     

### Find drives using at least 10GB and over 30% capacity"
    df -P -l -H | awk '{print $6 ":  Using " $5 " with " $3}' | grep "[0-9][0-9]G" | grep "[0-9][0-9]%"


    #!/usr/bin/env zsh
    VOLS=(/Volumes/*(N))
    for V in $VOLS; do
        USAGE=( $(df -Plg $V | tail -1 | awk '{print $2, $3, $5}' ) );
        printf " • %-25s (using %3s of %4s GiB)\n" ${V} ${USAGE[3]} ${USAGE[1]};
    done

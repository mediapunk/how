

# Get a summary of Drive capacity

    VOLS=(/Volumes/*(N))
    DISKS=($(for V in $VOLS; do df -P $V | tail -1 | cut -d' ' -f1; done))
    USERDISKS=( $(for D in $DISKS; do printf "\n$D "; diskutil info $D | grep -E "OS Can Be Installed.*: *Yes"; done | grep Yes | cut -d' ' -f1))
    function disksummary() { echo "$1:"; diskutil info $1 | grep -E "(Name:)|(Mount Point:)|(Space:)|(Status:)|(Location:)" | sed -E 's~\(.*\)$~~'; }
    for D in $USERDISKS; do disksummary $D; done

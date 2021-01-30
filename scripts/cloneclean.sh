#!/bin/bash
#
# Title:      remove the old garbage files
# MOD from MrDoobPG
# fuck of all haters
# GNU:        General Public License v3.0
################################################################################
if pidof -o %PPID -x "$0"; then
    exit 1
fi

startscript() {
    while true; do

	rsync "$(cat /var/plexguide/server.hd.path)/downloads/" "$(cat /var/plexguide/server.hd.path)/move/" \
	  -aqp --remove-source-files --link-dest="$(cat /var/plexguide/server.hd.path)/downloads/" \
	  --exclude-from="/opt/pgclone/excluded/transport.exclude" \
	  --exclude="**_HIDDEN~" --exclude=".unionfs/**" \
	  --exclude="**partial~" --exclude=".unionfs-fuse/**" \
	  --exclude=".fuse_hidden**" --exclude="**.grab/**" \
	  --exclude="**torrent**" --exclude="**nzb**" \
      --exclude="**mwall**"  --exclude="**filezilla**"

          sleep 5

	if [[ $(find "$(cat /var/plexguide/server.hd.path)/move" -type f | wc -l) -gt 0 ]]; then
            echo "running"
	else
            find "$(cat /var/plexguide/server.hd.path)/downloads/nzb" -mindepth 1 -type f -cmin +"$(cat /var/plexguide/cloneclean.nzb)"  2>/dev/null -exec rm -rf {} \;
            find "$(cat /var/plexguide/server.hd.path)/downloads/torrent" -mindepth 2 -type f -cmin +"$(cat /var/plexguide/cloneclean.torrent)"  2>/dev/null -exec rm -rf {} \;
            find "$(cat /var/plexguide/server.hd.path)/downloads" -mindepth 3 -type d \( ! -name syncthings ! -name .stfolder \) -empty -delete
            find "$(cat /var/plexguide/server.hd.path)/downloads" -mindepth 2 -type d \( ! -name .stfolder ! -name **games** ! -name ebooks ! -name abooks ! -name sonarr** ! -name radarr** ! -name lidarr** ! -name **kids** ! -name **tv** ! -name **movies** ! -name music** ! -name audio** ! -name anime** ! -name software ! -name xxx \) -empty -delete
	fi
          sleep 30
    done
}

# keeps the function in a loop
cheeseballs=0
while [[ "$cheeseballs" == "0" ]]; do startscript; done



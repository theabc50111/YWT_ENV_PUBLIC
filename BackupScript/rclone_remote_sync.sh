#!/usr/bin/env bash

set -u # make sure all varaible is set

ARGUMENT_LIST=(
  "remote_name"
  "rclone_config"
  "dst"
  "src"
)

# read arguments
opts=$(getopt \
  --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
  --name "$(basename "$0")" \
  --options "h" \
  -- "$@"
)

eval set -- "$opts" # Note: In order to handle the argument containing space, the quotes around '$opts': they are essential!
execution=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dst)
      dst="$2" # Note: In order to handle the argument containing space, the quotes around '$2': they are essential!
      shift 2 # The 'shift' eats a commandline argument, i.e. converts $1=a, $2=b, $3=c, $4=d into $1=b, $2=c, $3=d. shift 2 moves it all the way to $1=c, $2=d. It's done since that particular branch uses an argument, so it has to remove two things from the list (the -r and the argument following it) not just one.
      ;;

    --src)
      src="$2"
      shift 2
      ;;

    --remote_name)
      remote_name="$2"
      shift 2
      ;;

    --rclone_config)
      rclone_config="$2"
      shift 2
      ;;

    -h)
      echo "===============execution example:===============
rclone_remote_sync.sh --remote_name <remote_name settle in rclonenccu_gsuite> --dst <folder_name>  

===============options explanation:===============
--remote_name : remote name, you can find [remote_name] in rclone.conf, rclone.conf format example:
    #   [remote_name]
    #   client_id = 
    #   client_secret = 
    #   scope = drive
    #   root_folder_id = 
    #   service_account_file =
    #   token = {\"access_token\":\"XXX\",\"token_type\":\"Bearer\",\"refresh_token\":\"XXX\",\"expiry\":\"2014-03-16T13:57:58.955387075Z\"}

--dst : destination directory
--src : soruce dircectory
--rclone_config : location of rclone.conf
"
      execution=false
      shift 2
      ;;

    *)
      if [ "$1" != "--" ]; then
           echo "don't has $1 option"
      fi
      break
      ;;
  esac
done


if $execution ; then
/usr/bin/rclone sync "$src" "$remote_name":"$dst" --skip-links --config="$rclone_config" -P
fi

#! /bin/bash

set -u # make sure all varaible is set

ARGUMENT_LIST=(
  "dst"
  "src"
  "diff"
  "md"
  "ms"
  "err"
  "comb"
  "diff_f"
  "md_f"
  "ms_f"
  "fw"
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

    --diff)
      diff_file="$2"
      shift 2
      ;;

    --md)
      miss_dst_file="$2"
      shift 2
      ;;

    --ms)
      miss_src_file="$2"
      shift 2
      ;;

    --err)
      err_file="$2"
      shift 2
      ;;

    --comb)
      combined_file="$2"
      shift 2
      ;;

    --diff_f)
      filtered_diff_file="$2"
      shift 2
      ;;

    --ms_f)
      filtered_miss_src_file="$2"
      shift 2
      ;;

    --md_f)
      filtered_miss_dst_file="$2"
      shift 2
      ;;

    --fw)
      filtered_word="$2"
      shift 2
      ;;

    -h)
      echo "===============execution example:===============
./rclone_check.sh --src /media/ywt01/Transcend/ --dst /media/ywt01/Seagate Backup Plus Drive/ --diff ~/Documents/diff.txt --ms ~/Documents/ms.txt  --md ~/Documents/md.txt --err ~/Documents/err.txt --comb ~/Documents/comb.txt --ms_f ms_f.txt --md_f md_f.txt --diff_f diff_f.txt --fw RECYCLE\|Trash

===============options explanation:===============
--dst : destination directory
--src : soruce dircectory
--diff : records of modified files
--ms  : records of missing files in sorce directory
--md  : records of missing files in destination directory
--err : records of errors while check
--comb: records of check results of all files
--diff_f : filtered records of modified files
--ms_f  : filtered records of missing files in sorce directory
--md_f  : filtered records of missing files in destination directory
--fw : filtered_word, if you want to filter multiple words, all of them should be contained in \"\" and use 『|』 to seperate them 
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
	rclone check "$src" "$dst" --differ "$diff_file" --missing-on-dst "$miss_dst_file" --missing-on-src "$miss_src_file" --error "$err_file" --combined "$combined_file"
	if [ "$filtered_miss_src_file" != "" ] || [ "$filtered_miss_dst_file" != "" ] || [ "$filtered_diff_file" != "" ]; then
		grep -vE \($filtered_word\) "$miss_src_file" > "$filtered_miss_src_file" # check those file only exist in src and ignore RECYCLE&Trash folder
		grep -vE \($filtered_word\) "$miss_dst_file" > "$filtered_miss_dst_file" # check those file only exist in dst and ignore RECYCLE&Trash folder
		grep -vE \($filtered_word\) "$diff_file" | > "$filtered_diff_file" # check those file exist both in src and dst but different
	fi
fi

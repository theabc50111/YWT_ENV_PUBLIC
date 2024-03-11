
<details markdown="1">
<summary  style="font-size:22px;" ><b><code>rclone_check.sh</code></b> : used for check difference between sorce and destination
</summary>
    
- example of how to check : 
    ```
    ./rclone_check.sh --src /media/ywt01/Transcend/ --dst /media/ywt01/Seagate Backup Plus Drive/ --diff ~/Documents/diff.txt --ms ~/Documents/ms.txt  --md ~/Documents/md.txt --err ~/Documents/err.txt --comb ~/Documents/comb.txt --ms_f ms_f.txt --md_f md_f.txt --diff_f diff_f.txt --fw RECYCLE\|Trash
    ```
- check all opts : ```./rclone_check.sh -h```

</details>

<hr>

<details markdown="1">
<summary  style="font-size:22px;" ><b><code>rclone_remote_sync.sh</code></b> : used to sync local data to specific remote drive
</summary>
    
- example of how to sync local data to cloud : 
    ```
    ./rclone_remote_sync.sh --remote_name nccu_gsuite --dst LG_15Z90N-backup --src ~/Documents/tmp/ --rclone_config ~/:w.config/rclone/rclone.conf
    ```
- check all opts : ```./rclone_remote_sync.sh -h```

</details>

<details>
<summary style="font-size:14px; font-weight: bold;"><i>note of using <code>rclone_remote_sync.sh</code></i></summary>

- ### *before using `rclone_remote_sync.sh`,*
  - ***setting rclone.conf by executing `rclone config`***<br>
    - `rclone config` will open an interactive setup process, **just follow the *default* setting**.
      - During the interactive setup, it will ask :`Use auto config?`, answer `n`, it will automatically open browser, and ask your permission
- ### If you want to **increase the speed of upload/download from google drive**, you need to **Making your own client_id**
  - [Making your own client_id](https://rclone.org/drive/#making-your-own-client-id)
- ### ref
  - [rclone for google drive](https://rclone.org/drive/)
  - [rclone config](https://rclone.org/commands/rclone_config/)
  - [default location of rclone.conf](https://rclone.org/docs/#config-config-file)
</details>


<details>
<summary style="font-size:14px; font-weight: bold;"><i>example of using <code>rclone_remote_sync.sh</code></i> by <code>crontab</code> </summary>

1. executing: `crontab -e`
2. Input:
   ```
   MAILTO="theabc50111@gmail.com"

   # m h  dom moon dow  command
   15 18 * * Thu /home/ywt01/.local/bin/rclone_remote_sync.sh --remote_name nccu_gsuite --dst LG_15Z90N-backup --src /home/ --rclone_config /home/ywt01/.config/rclone/rclone.conf 2>> /var/tmp/sync_log.txt
   ```

</details>

<hr>

# Note
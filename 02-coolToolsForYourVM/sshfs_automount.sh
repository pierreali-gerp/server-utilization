#!/bin/bash

# This script allows you to mount a network folder with SFTP using "sshfs".
# You can simply run it from the terminal with (provided you are in the script folder, and the REQUIREMENTS below are satisfied):
#   ./sshfs_automount.sh
#
# ...or you can use it to automate mounting of a network folder every time the VM starts, which is its main intended purpose. To do so:
#   1. Edit the crontab of your user (DO NOT USE sudo!):
#       crontab -e
#      The "nano" editor will open.
#   2. Add the following line to the file:
#       @reboot <path_to_the_sshfs_automount_script.sh>
#      Example:
#       @reboot /home/username/autoScripts/sshfs_mount.sh
#   3. Save the file with CTRL+O, confirm by pressing ENTER, then press CTRL+X to exit.
#   4. Check that the instruction has been actually added to the crontab by running:
#       crontab -l
#   5. Bonus: Before trying to reboot the OS and see whether the scheduled task works, check from the terminal that you can run it once from
#      the path you inserted into the crontab:
#       <path_to_the_sshfs_automount_script.sh>
#      Example:
#       /home/username/autoScripts/sshfs_mount.sh
#
# REQUIREMENTS. Before running this script, you need to:
#   - install sshfs on your VM from the official repositories of your distro (on Ubuntu: sudo apt install sshfs; on Fedora: sudo dnf install sshfs)
#   - replace <uid>, <gid> (see next bullet), <username_on_server>, <server_IP>, <server_path>, <mount_path>, <user_password_on_server>
#   - find the uid and gid numbers associated with your Linux user on the VM by running:
#       id -u  -> this is the <uid>
#       id -g  -> this is the <gid>
#   - create the empty mount path (i.e., /home/user/nasmount in the following example must already exist BEFORE running the sshfs command)
#   - make this script executable: chmod +x sshfs_automount.sh
#
# Example:
# sshfs -o password_stdin,allow_other,uid=1000,gid=1000 "username@192.168.1.1:/InfoMedNAS_test" "/home/user/nasmount" <<< 'xxxxxxxx'

sshfs -o password_stdin,allow_other,uid=<uid>,gid=<gid> "<username_on_server>@<server_IP>:<server_path>" "<mount_path>" <<< '<user_password_on_server>'
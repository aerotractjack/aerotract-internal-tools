# PROCEDURE
Connecting a computer running a linux OS to a network shared folder so that it will reconnect automatically.
Created March 22, 2023 by Jack Wolf

# USAGE
`$ sudo ./nas2fstab.sh $USER`

## Script notes
- Must be ran with sudo privileges so it can write to /etc/fstab, with the following command
`$ sudo -u ./nas2fstab.sh $USER`
- Script only needs to be ran once
- Must reboot machine after script runs
- Can be used to mount multiple NAS instances
- Will not add duplicate entry to /etc/fstab
- This has been tested on Ubuntu and POP! OS.  You will find multiple ways if you web search but this worked for Jack.
- This was an SMB file share running on a Synology NAS

## What the script automates
Create a username/password for you or your team on the host sharing the folder if you don’t have one or an existing shared username/password.  An example is using the HTML interface on a Synology NAS to create a user and grand rights.
On the Linux computer, create a directory file `/home/USER/.smbcredentials/CREDENTIAL_FILENAME`, replacing USER with your username and CREDENTIAL_FILENAME with whatever filename you would like. My username is `example-user` and my SMB group is `example-group`, so my file is at `/home/aerotract/.smbcredentials/example-group`
In the file created in the previous step, on two separate lines, write your username and password like:
```
username=example-user
password=p@ssw0rd
```
Determine the IP and shared directory of the storage. For example, the eight-bay Synology NAS has the IP address 192.168.1.50 and the shared directory is `main`
Open the file `/etc/fstab` (you will need to use `sudo` to edit with root privileges) and add the following line to the very end (make sure to replace IP, SHARE, USER, and CREDENTIAL_FILENAME) with your own. This should be exact and in one long line:

```
//IP/SHARE /media/share cifs vers=3.0,credentials=/home/USER/.smb/CREDENTIAL_FILENAME,uid=1000,gid=1000,forceuid,forcegid
```
Save and close the file
In your terminal, enter the command `sudo apt install cifs-utils` and press `Enter` or hit `Y` when prompted.
Restart your computer. If the data is not accessible from your `/media/share` directory, try entering the terminal command `sudo mount -a` and restarting your computer



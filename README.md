# :desktop_computer: Winstart 
This is a simple bash file to automatically connect to an OpenVPN server and mount shared drives. This little script could be used in company or private environment to simplify the startup.

## :sparkles: How it works
You can define as many mount points as you like by using the array provided under NAS Drives. The script will check in several ping routines if the internal host is available and if yes, it will mount the drives or if not, connect to VPN first. In this way you can use the script at home / office AND remote. Have fun!


## :wrench: Configuration

You need to configure the following things to make the script work

[x] Install OpenVPN GUI (Community Edition) and install profile
[x] Setup SMB / share user with access to requested drives/folders (password without special characters)
[x] Set Variables in the script to match your confirguration


## :gem: Credits
The script uses the ANSI snippet from @mlocati to make the terminal more colorful :rainbow:. Thanks for that.
# klipper-backup 💾 
Klipper backup script for manual or automated GitHub backups 

This backup is provided by [klipper-backup](https://github.com/Staubgeborener/klipper-backup).

# Manually backup the SD Card from Linux

## Find the SD Card
```bash
sudo fdisk -l
```
Get the name of the SD Card in the Disk field (example /dev/sdb)

## Use `dd` utility to write the image on the wanted directory
```bash
sudo dd if=/dev/sdb of=~/mainsail_backup_14012024.img

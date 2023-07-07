#!/bin/bash
 
shopt -s extglob  # enable extglob
 
LatestVersion=$(curl -Lsk 'https://github.com/Staubgeborener/klipper-backup/raw/main/version')
if [[ ! -e "version" ]]; then
    version="New version released: v"${LatestVersion}
else
    LocalVersion=$(sed -n 1p version)
    version="v"${LocalVersion}
fi
 
color=$'\e[1;36m'
end=$'\e[0m'
 
Klipper-Backup-Logo() {
    echo -e "${color}
 _    _  _                           _              _                  ________
| |_ | ||_| ___  ___  ___  ___  ___ | |_  ___  ___ | |_  _ _  ___     | |____| |
| '_|| || || . || . || -_||  _||___|| . || .'||  _|| '_|| | || . |    |  (__)  |
|_,_||_||_||  _||  _||___||_|       |___||__,||___||_,_||___||  _|    |        |
           |_|  |_|                                          |_|      |________|
    ${version}${end}"
}
 
get_userbackupdir() {
    local userbackupdir=$(grep 'userbackupdir=' ~/klipper-backup/.env | sed 's/^.*=//')
 
    if [ ! -n "$userbackupdir" ]; then
        while true; do
            read -p "You have to define the path of your backup directory, if it does not exist it will be created for you: " path
 
            mkdir -p "$path"
 
            if [ $? -eq 0 ] && [ -n "$path" ]; then
            if [[ ${path: -1} != '/' ]]; then
                path="${path}/"
            fi
                userbackupdir="$path"
                echo -e "userbackupdir=$userbackupdir" > ~/klipper-backup/.env
                break
            fi
        done
    fi
 
    echo "$userbackupdir"
}
 
installation() {
    cd ~
    wget https://github.com/Staubgeborener/klipper-backup/releases/download/$LatestVersion/klipper-backup-main.zip
    unzip -o klipper-backup-main.zip
    userbackupdir=$(get_userbackupdir)
    if [ -d ~/klipper-backup ] && [ -d "$userbackupdir" ]; then
        cp ~/klipper-backup-main/!(.env) $userbackupdir
        cp ~/klipper-backup-main/!(.env) ~/klipper-backup/
    else
        mv klipper-backup-main klipper-backup
        cp ~/klipper-backup/.env.example ~/klipper-backup/.env
        cp -r ~/klipper-backup $userbackupdir
    fi
 
    chmod +x ~/klipper-backup/*.sh
    chmod +x ${userbackupdir}*.sh
    rm -r ~/klipper-backup-main ~/klipper-backup-main.zip
    echo -e "# klipper-backup 💾 \nKlipper backup script for manual or automated GitHub backups \n\nThis backup is provided by [klipper-backup](https://github.com/Staubgeborener/klipper-backup)." > ${userbackupdir}README.md
}
 
updates() {
    if [[ $LatestVersion > $LocalVersion ]] ; then
        echo -e "${color}New version $LatestVersion released! Start update:${end}\n"
        installation
    else
        echo "You are up-to-date"
    fi
}
 
Klipper-Backup-Logo
 
if [[ ! -e "version" ]]; then
    echo -e "\n${color}Start installation...${end}\n"
    installation
    echo -e "\n${color}Finished! Now set up the repository and edit the .env file. You can find more details in the wiki on Github: https://github.com/Staubgeborener/klipper-backup/wiki/Installation%3A-Initialize-GitHub-repository"
else
    echo "Check for updates..."
    updates
fi
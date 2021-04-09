#!/bin/bash

ARGS="$@"
ARGC="$#"
BACKUP_DIR="$(pwd)/backup"
BACKUP_PATH="$BACKUP_DIR/laba_backup.sh"

if [[ $UID == 0 ]]; then
    echo "Please DONT run this script with sudo."
    exit 1
fi

if [[ "$#" == 0 ]]; then
  echo "Wrong usage."
  exit 1
fi

EMAIL=""
for ARG in $ARGS
do
  if [[ "$ARG" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]
  then 
    EMAIL=$ARG
    break
  fi
done

if [[ -z EMAIL ]]; then
echo "Email not found or is not valid."
exit 1
fi 

FILES=""
mkdir -p $BACKUP_DIR

echo "Copying backup files to $BACKUP_DIR"
for ARG in ${@:2}
do
  if [[ -f $ARG ]]; then
    FILES="$FILES $(readlink -e $ARG)"
    # заодно бэкап сделаем
    cp $ARG $BACKUP_DIR/$ARG.backup
  fi
done

if touch $BACKUP_PATH; then
  rm $BACKUP_PATH
  echo "#!/bin/bash" >> $BACKUP_PATH
  echo "export PATH=\"$(printenv PATH)\"" >> $BACKUP_PATH
  echo "echo \"Backup from \$(date)\" | /usr/bin/mutt $EMAIL -a $FILES" >> $BACKUP_PATH
  chmod a+x $BACKUP_PATH
  
  echo "Created backup script at $BACKUP_PATH"
else
  echo "Unable to create backup script at $BACKUP_PATH. Check your rights."
  exit 1
fi

echo "Configuring crontab..."
(crontab -l ; echo "* * * * * $BACKUP_PATH")| crontab -
echo "Cron result: $?"
echo "Done!"

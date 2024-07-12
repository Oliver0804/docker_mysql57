#!/bin/bash

# 設置環境變量
MYSQL_USER="root"
MYSQL_PASSWORD="mypassword"
MYSQL_DATABASE="WiringSystemRecordsDB"
BACKUP_DIR="/backup"

# 創建備份文件名
BACKUP_FILE="$BACKUP_DIR/$MYSQL_DATABASE-$(date +%F_%T).sql"

# 執行 mysqldump 並備份數據庫
mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > $BACKUP_FILE

# 打印備份結果
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE"
else
    echo "Backup failed"
fi


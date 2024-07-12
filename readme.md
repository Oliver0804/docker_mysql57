# 使用 Docker Compose 設置 MySQL 5.7 並應用更新的初始化腳本

## 步驟 1：創建 `docker-compose.yml` 文件

在你的項目目錄中創建一個 `docker-compose.yml` 文件，並添加以下內容：

```yaml
version: '3.9'

services:
  db:
    image: mysql:5.7
    container_name: mysql57-container
    environment:
      MYSQL_ROOT_PASSWORD: mypassword # Root 賬號的密碼
      MYSQL_DATABASE: WiringSystemRecordsDB # 預設創建的資料庫
      MYSQL_USER: user # 自定義的用戶名
      MYSQL_PASSWORD: password # 自定義用戶的密碼
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
      - ./backup.sh:/backup.sh # 備份腳本
      - ./backup:/backup  # 持久化備份的數據
    platform: linux/amd64

volumes:
  db_data:

```




## 步驟 2：啟動 Docker Compose
在終端或命令提示符中，導航到包含 docker-compose.yml 文件的目錄，然後運行以下命令來啟動 Docker Compose：
```bash
docker-compose up -d
```


## 步驟 3：連線到 MySQL
打開終端並運行以下命令：
```bash
docker exec -it mysql57-container mysql -uroot -pmypassword
```


## 資料庫更新：更新 init.sql 文件
如果你更新了 init.sql 文件並希望將更改應用到你的 MySQL 容器中，請按照以下步驟操作：

1.停止並移除現有的容器：
```bash
docker-compose down
```

2.刪除舊的數據卷：
```bash
docker volume rm <your_project_name>_db_data
```
<your_project_name> 應替換為你的 Docker Compose 項目的名稱，可以在 docker volume ls 列表中找到。

3.更新 init.sql 文件，確保包含你想要的新 SQL 命令：

```sql
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- 新增或修改的 SQL 命令
ALTER TABLE users ADD COLUMN age INT;
```

4.重新啟動 Docker Compose：
```bash
docker-compose up -d
```


## 步驟 6：在 Docker 中備份和還原 MySQL 數據庫，可以使用以下步驟。這些步驟適用於在 Docker 容器內部或外部進行操作。

### 備份 MySQL 數據庫
#### 方法一：使用 docker exec 命令
1. 創建備份目錄（可選）

創建一個目錄來存儲備份文件：
```bash
mkdir -p ~/mysql_backups
```

2.運行備份命令
使用 docker exec 命令進入容器並執行 mysqldump 來備份數據庫。例如，要備份名為 testdb 的數據庫：

```bash
docker exec mysql57-container sh -c 'exec mysqldump -uroot -pmypassword testdb' > ~/mysql_backups/testdb_backup.sql
```

在這裡：
- mysql57-container 是你的容器名稱
- root 和 mypassword 是你的 MySQL 用戶名和密碼
- testdb 是要備份的數據庫名稱
- ~/mysql_backups/testdb_backup.sql 是備份文件的存儲路徑

#### 方法二：使用 docker run 命令
這種方法適合將備份文件直接導出到主機系統中：

```bash
docker run --rm --network container:mysql57-container -v ~/mysql_backups:/backups mysql:5.7 sh -c 'exec mysqldump -uroot -pmypassword testdb > /backups/testdb_backup.sql'
```


### 還原 MySQL 數據庫
#### 方法一：使用 docker exec 命令
1. 運行還原命令

使用 docker exec 命令進入容器並執行 mysql 來還原數據庫。例如，要還原備份文件 testdb_backup.sql 到 testdb 數據庫：
```bash
docker exec -i mysql57-container sh -c 'exec mysql -uroot -pmypassword testdb' < ~/mysql_backups/testdb_backup.sql
```
#### 方法二：使用 docker run 命令
這種方法適合將備份文件從主機系統中導入到容器內的 MySQL：
```bash
docker run --rm --network container:mysql57-container -v ~/mysql_backups:/backups mysql:5.7 sh -c 'exec mysql -uroot -pmypassword testdb < /backups/testdb_backup.sql'
```

### 完整的備份和還原示例
```bash
# 創建備份目錄
mkdir -p ~/mysql_backups

# 備份數據庫
docker exec mysql57-container sh -c 'exec mysqldump -uroot -pmypassword testdb' > ~/mysql_backups/testdb_backup.sql

# 還原數據庫
docker exec -i mysql57-container sh -c 'exec mysql -uroot -pmypassword testdb' < ~/mysql_backups/testdb_backup.sql
```


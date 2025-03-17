# WiringSystemRecordsDB 範例資料

本文件包含 WiringSystemRecordsDB 資料庫的示範資料，可用於測試和開發環境。

## 目錄
1. [異常類型參考表](#異常類型參考表)
2. [工單表單](#工單表單)
3. [打線記錄表單](#打線記錄表單)
4. [配方表](#配方表)
5. [沖壓異常記錄表](#沖壓異常記錄表)
6. [使用說明](#使用說明)
7. [常見問題處理](#常見問題處理)

## 異常類型參考表

```sql
-- 插入異常類型參考表數據
INSERT IGNORE INTO AbnormalityType (TypeName, Description) VALUES
('端子變形', '沖壓過程中端子出現彎曲或變形'),
('端子損壞', '端子出現破裂或斷裂'),
('線材不良', '線材品質問題導致無法正常沖壓'),
('模具磨損', '模具使用過久出現磨損影響成品'),
('機械故障', '沖壓機械設備故障'),
('參數設置錯誤', '沖壓參數設置不正確');
```

## 工單表單

```sql
-- 插入工單表單數據
INSERT INTO WorkOrder (WorkOrderID, Date, ID, Mold, Terminal, WireDiameter, TotalQuantity, WorkTimeSeconds, Tension) VALUES
('WO-20250301-001', '2025-03-01', 'OP001', 'M-A101', 'T-X505', '0.75mm²', 1000, 3600, 15.75),
('WO-20250301-002', '2025-03-01', 'OP002', 'M-B202', 'T-Y606', '1.0mm²', 800, 2880, 18.20),
('WO-20250302-001', '2025-03-02', 'OP001', 'M-C303', 'T-Z707', '1.5mm²', 1200, 4320, 22.50),
('WO-20250302-002', '2025-03-02', 'OP003', 'M-A101', 'T-X505', '0.75mm²', 750, 2700, 15.80),
('WO-20250303-001', '2025-03-03', 'OP002', 'M-D404', 'T-W808', '2.0mm²', 500, 2500, 26.75);
```

## 打線記錄表單

```sql
-- 插入打線表單數據
INSERT INTO WiringRecord (WorkOrderID, Date, SampleTestSerialNumber, FrontLength, BackLength, Tension) VALUES
('WO-20250301-001', '2025-03-01', 'S0001-001', 125.5, 85.2, 15.8),
('WO-20250301-001', '2025-03-01', 'S0001-002', 125.7, 85.0, 15.7),
('WO-20250301-001', '2025-03-01', 'S0001-003', 125.4, 85.3, 15.9),
('WO-20250301-002', '2025-03-01', 'S0002-001', 150.2, 95.5, 18.1),
('WO-20250301-002', '2025-03-01', 'S0002-002', 150.0, 95.6, 18.3),
('WO-20250302-001', '2025-03-02', 'S0003-001', 180.5, 110.0, 22.6),
('WO-20250302-001', '2025-03-02', 'S0003-002', 180.3, 110.2, 22.4),
('WO-20250302-002', '2025-03-02', 'S0004-001', 125.6, 85.1, 15.7),
('WO-20250303-001', '2025-03-03', 'S0005-001', 200.0, 120.5, 26.8);
```

## 配方表

```sql
-- 插入配方表數據
INSERT INTO Recipe (MoldID, TerminalID, WireDiameter, MotorHeight) VALUES
('M-A101', 'T-X505', '0.75mm²', 45.5),
('M-B202', 'T-Y606', '1.0mm²', 48.2),
('M-C303', 'T-Z707', '1.5mm²', 52.7),
('M-D404', 'T-W808', '2.0mm²', 56.8),
('M-A101', 'T-X505', '1.0mm²', 46.5),
('M-B202', 'T-Y606', '1.5mm²', 49.2),
('M-C303', 'T-Z707', '2.0mm²', 53.5);
```

## 沖壓異常記錄表

```sql
-- 插入沖壓異常記錄表數據
INSERT INTO StampingAbnormality (WorkOrderID, AbnormalityTime, AbnormalityType, Description, HandlingMeasures, HandledBy, Status) VALUES
('WO-20250301-001', '2025-03-01 10:15:22', '端子變形', '發現5%的端子有輕微變形', '調整沖壓壓力，更換受損端子', '張工', 'resolved'),
('WO-20250301-002', '2025-03-01 14:30:45', '模具磨損', '模具邊緣出現磨損痕跡', '標記磨損位置，安排下班後更換模具', '李工', 'resolved'),
('WO-20250302-001', '2025-03-02 09:05:18', '機械故障', '沖壓機出現異常噪音', '暫停生產，檢查機械部件', '王工', 'handling'),
('WO-20250302-002', '2025-03-02 16:22:37', '線材不良', '批次線材直徑不一致', '退回不合格線材，向供應商反饋', '趙工', 'pending'),
('WO-20250303-001', '2025-03-03 11:45:10', '參數設置錯誤', '壓力設置過高導致端子變形', '重新調整參數，記錄正確參數值', '張工', 'resolved');
```

## 使用說明

### 執行順序

請按照以下順序執行 SQL 語句：

1. 首先執行 `init.sql` 創建資料庫和表結構
2. 然後執行範例數據插入語句

### 完整執行腳本

如果您希望一次性執行所有範例數據插入，可以使用以下命令：

```bash
# 登入 MySQL
mysql -u username -p

# 或者使用 docker 環境
docker exec -it mysql_container mysql -u username -p
```

然後執行以下腳本：

```sql
USE WiringSystemRecordsDB;

-- 插入所有範例數據
-- 異常類型參考表
INSERT IGNORE INTO AbnormalityType (TypeName, Description) VALUES
('端子變形', '沖壓過程中端子出現彎曲或變形'),
('端子損壞', '端子出現破裂或斷裂'),
('線材不良', '線材品質問題導致無法正常沖壓'),
('模具磨損', '模具使用過久出現磨損影響成品'),
('機械故障', '沖壓機械設備故障'),
('參數設置錯誤', '沖壓參數設置不正確');

-- 工單表單
INSERT INTO WorkOrder (WorkOrderID, Date, ID, Mold, Terminal, WireDiameter, TotalQuantity, WorkTimeSeconds, Tension) VALUES
('WO-20250301-001', '2025-03-01', 'OP001', 'M-A101', 'T-X505', '0.75mm²', 1000, 3600, 15.75),
('WO-20250301-002', '2025-03-01', 'OP002', 'M-B202', 'T-Y606', '1.0mm²', 800, 2880, 18.20),
('WO-20250302-001', '2025-03-02', 'OP001', 'M-C303', 'T-Z707', '1.5mm²', 1200, 4320, 22.50),
('WO-20250302-002', '2025-03-02', 'OP003', 'M-A101', 'T-X505', '0.75mm²', 750, 2700, 15.80),
('WO-20250303-001', '2025-03-03', 'OP002', 'M-D404', 'T-W808', '2.0mm²', 500, 2500, 26.75);

-- 打線表單
INSERT INTO WiringRecord (WorkOrderID, Date, SampleTestSerialNumber, FrontLength, BackLength, Tension) VALUES
('WO-20250301-001', '2025-03-01', 'S0001-001', 125.5, 85.2, 15.8),
('WO-20250301-001', '2025-03-01', 'S0001-002', 125.7, 85.0, 15.7),
('WO-20250301-001', '2025-03-01', 'S0001-003', 125.4, 85.3, 15.9),
('WO-20250301-002', '2025-03-01', 'S0002-001', 150.2, 95.5, 18.1),
('WO-20250301-002', '2025-03-01', 'S0002-002', 150.0, 95.6, 18.3),
('WO-20250302-001', '2025-03-02', 'S0003-001', 180.5, 110.0, 22.6),
('WO-20250302-001', '2025-03-02', 'S0003-002', 180.3, 110.2, 22.4),
('WO-20250302-002', '2025-03-02', 'S0004-001', 125.6, 85.1, 15.7),
('WO-20250303-001', '2025-03-03', 'S0005-001', 200.0, 120.5, 26.8);

-- 配方表
INSERT INTO Recipe (MoldID, TerminalID, WireDiameter, MotorHeight) VALUES
('M-A101', 'T-X505', '0.75mm²', 45.5),
('M-B202', 'T-Y606', '1.0mm²', 48.2),
('M-C303', 'T-Z707', '1.5mm²', 52.7),
('M-D404', 'T-W808', '2.0mm²', 56.8),
('M-A101', 'T-X505', '1.0mm²', 46.5),
('M-B202', 'T-Y606', '1.5mm²', 49.2),
('M-C303', 'T-Z707', '2.0mm²', 53.5);

-- 沖壓異常記錄表
INSERT INTO StampingAbnormality (WorkOrderID, AbnormalityTime, AbnormalityType, Description, HandlingMeasures, HandledBy, Status) VALUES
('WO-20250301-001', '2025-03-01 10:15:22', '端子變形', '發現5%的端子有輕微變形', '調整沖壓壓力，更換受損端子', '張工', 'resolved'),
('WO-20250301-002', '2025-03-01 14:30:45', '模具磨損', '模具邊緣出現磨損痕跡', '標記磨損位置，安排下班後更換模具', '李工', 'resolved'),
('WO-20250302-001', '2025-03-02 09:05:18', '機械故障', '沖壓機出現異常噪音', '暫停生產，檢查機械部件', '王工', 'handling'),
('WO-20250302-002', '2025-03-02 16:22:37', '線材不良', '批次線材直徑不一致', '退回不合格線材，向供應商反饋', '趙工', 'pending'),
('WO-20250303-001', '2025-03-03 11:45:10', '參數設置錯誤', '壓力設置過高導致端子變形', '重新調整參數，記錄正確參數值', '張工', 'resolved');
```

## 常見問題處理

### 重複鍵錯誤 (Duplicate entry for key)

如果遇到重複鍵錯誤，可以使用以下方法解決：

1. 使用 `INSERT IGNORE` 語法忽略重複項
2. 使用 `REPLACE INTO` 替換重複項
3. 使用 `ON DUPLICATE KEY UPDATE` 更新重複項
4. 執行前先清空表格 (僅測試環境使用)：`TRUNCATE TABLE 表名;`

### 外鍵約束錯誤

如果遇到外鍵約束錯誤，請確保按照正確的順序插入數據：

1. 首先插入 `AbnormalityType` 數據
2. 然後插入 `WorkOrder` 數據
3. 接著插入依賴於 `WorkOrder` 的其他表格數據

### 數據範例說明

本範例數據模擬了一個線束沖壓生產系統的記錄，包含：

- 5筆工單數據，時間跨越3天
- 9筆打線記錄，對應不同的工單
- 7筆配方數據，包含不同的模具、端子和線徑組合
- 5筆異常記錄，分佈在不同工單和處理狀態
- 6種異常類型定義

這些數據可用於開發和測試系統功能，包括報表生成、數據分析和介面展示等。

## 範例資料特點

1. **多樣性**：提供了多種不同情境下的生產數據
2. **關聯性**：所有表格之間的外鍵關係都正確設置
3. **實用性**：數據內容貼近實際生產情境，便於業務理解
4. **完整性**：包含日期、數量、測量值等各類數據類型

## 中文亂碼問題處理

若插入中文數據時出現問號或亂碼，請遵循以下步驟解決：

### 方法一：設置資料庫和表的字符集

在創建資料庫時指定 UTF-8 字符集：

```sql
CREATE DATABASE WiringSystemRecordsDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

對現有資料庫修改字符集：

```sql
ALTER DATABASE WiringSystemRecordsDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

修改表的字符集：

```sql
ALTER TABLE 表名 CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 方法二：設置連接字符集

在連接 MySQL 時設置字符集：

```sql
SET NAMES utf8mb4;
```

或在連接字符串中指定：

```bash
mysql -u username -p --default-character-set=utf8mb4
```

### 方法三：修改 Docker 環境配置

如果使用 Docker，在 docker-compose.yml 中添加環境變數：

```yaml
services:
  mysql:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=yourpassword
      - MYSQL_DATABASE=WiringSystemRecordsDB
      - MYSQL_USER=username
      - MYSQL_PASSWORD=password
      - MYSQL_INITDB_ARGS=--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    volumes:
      - ./mysql-data:/var/lib/mysql
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "3306:3306"
```

或創建 my.cnf 配置文件，並掛載到容器中：

```ini
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci

[client]
default-character-set=utf8mb4
```

### 檢查字符集設置

執行以下命令檢查當前字符集設置：

```sql
SHOW VARIABLES LIKE 'character_set%';
SHOW VARIABLES LIKE 'collation%';
```

完成上述設置後，重新插入中文數據應該可以正常顯示，不再出現問號或亂碼問題。

## 使用 Docker logs 檢查容器運行狀態

要確認 MySQL 容器是否成功運行且字符集設置正確，可以使用 Docker 日誌命令：

### 查看容器啟動日誌

```bash
# 查看容器日誌
docker logs mysql57-container

# 持續追蹤容器日誌
docker logs -f mysql57-container

# 查看最近 100 行日誌
docker logs --tail 100 mysql57-container
```

### 檢查 MySQL 容器是否成功啟動

成功啟動的跡象：
- 日誌中出現 `[Note] mysqld: ready for connections.`
- 日誌中包含 `port: 3306  MySQL Community Server`
- 無嚴重錯誤訊息

### 檢查字符集設置是否成功

在日誌中查找字符集相關信息：

```bash
# 搜索字符集相關日誌
docker logs mysql57-container 2>&1 | grep -i "character\|collation"
```

如果設置成功，應該能看到類似以下信息：
```
[Note] Server hostname (bind-address): '*'; port: 3306
[Note] - '0.0.0.0' resolves to '0.0.0.0';
[Note] Server socket created on IP: '0.0.0.0'.
[Note] InnoDB: Buffer pool(s) load completed at 230428 12:34:56
[Note] /usr/sbin/mysqld: ready for connections.
```

### 使用腳本自動檢查容器狀態

您可以使用 `check_mysql_status.sh` 腳本快速檢查 MySQL 容器的運行狀態和字符集設置。
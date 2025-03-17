#!/bin/bash

# MySQL Docker 容器狀態檢查腳本
# 此腳本用於檢查 MySQL 容器運行狀態並提供運行信息

# 設定容器名稱
CONTAINER_NAME="mysql57-container"

# 顏色設置
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

echo -e "${YELLOW}===== MySQL 容器狀態檢查 =====${NC}"

# 1. 檢查容器是否存在並運行
echo -e "${YELLOW}檢查容器運行狀態...${NC}"
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo -e "${GREEN}✓ 容器 $CONTAINER_NAME 正在運行${NC}"
    
    # 獲取容器基本資訊
    CONTAINER_ID=$(docker ps -q -f name=$CONTAINER_NAME)
    CREATED=$(docker inspect -f '{{.Created}}' $CONTAINER_ID)
    UPTIME=$(docker inspect -f '{{.State.StartedAt}}' $CONTAINER_ID)
    
    echo -e "${YELLOW}容器 ID:${NC} $CONTAINER_ID"
    echo -e "${YELLOW}創建時間:${NC} $CREATED"
    echo -e "${YELLOW}啟動時間:${NC} $UPTIME"
else
    echo -e "${RED}✗ 容器 $CONTAINER_NAME 未運行!${NC}"
    
    if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
        echo -e "${YELLOW}容器存在但未運行。嘗試啟動容器:${NC}"
        docker start $CONTAINER_NAME
    else
        echo -e "${RED}容器不存在，請先創建容器:${NC}"
        echo "docker-compose up -d"
        exit 1
    fi
fi

echo ""
echo -e "${YELLOW}===== 檢查 MySQL 服務狀態 =====${NC}"

# 2. 檢查 MySQL 服務是否響應
echo -e "${YELLOW}檢查 MySQL 服務響應...${NC}"
if docker exec $CONTAINER_NAME mysqladmin ping -uroot -pmypassword --silent; then
    echo -e "${GREEN}✓ MySQL 服務正常響應${NC}"
    
    # 獲取 MySQL 版本信息
    VERSION=$(docker exec $CONTAINER_NAME mysql -uroot -pmypassword -e "SELECT VERSION();" -s)
    echo -e "${YELLOW}MySQL 版本:${NC} $VERSION"
else
    echo -e "${RED}✗ MySQL 服務未響應!${NC}"
fi

echo ""
echo -e "${YELLOW}===== 檢查字符集設置 =====${NC}"

# 3. 檢查字符集設置
echo -e "${YELLOW}檢查數據庫字符集設置:${NC}"
docker exec $CONTAINER_NAME mysql -uroot -pmypassword -e "SHOW VARIABLES WHERE Variable_name LIKE 'character\_set\_%' OR Variable_name LIKE 'collation%';" 2>/dev/null

echo ""
echo -e "${YELLOW}===== 最近日誌 =====${NC}"

# 4. 顯示最近的容器日誌
echo -e "${YELLOW}最近 20 行容器日誌:${NC}"
docker logs --tail 20 $CONTAINER_NAME

echo ""
echo -e "${YELLOW}===== 檢查中文支持 =====${NC}"

# 5. 測試中文支持
echo -e "${YELLOW}測試中文數據支持:${NC}"
docker exec $CONTAINER_NAME mysql -uroot -pmypassword -e "CREATE DATABASE IF NOT EXISTS test_charset; USE test_charset; CREATE TABLE IF NOT EXISTS chinese_test (id INT AUTO_INCREMENT PRIMARY KEY, text VARCHAR(100)); INSERT INTO chinese_test (text) VALUES ('測試中文顯示'), ('MySQL字符集測試'), ('正確顯示中文'); SELECT * FROM chinese_test;" 2>/dev/null

echo ""
echo -e "${GREEN}檢查完成。如果看到正確顯示的中文，表示 MySQL 容器配置成功。${NC}"
echo -e "${YELLOW}如果需要更詳細的日誌，請運行:${NC}"
echo "docker logs $CONTAINER_NAME"

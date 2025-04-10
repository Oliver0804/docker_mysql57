-- 創建數據庫
CREATE DATABASE IF NOT EXISTS WiringSystemRecordsDB;

-- 使用數據庫
USE WiringSystemRecordsDB;

-- 創建工單表單，添加拉力值 Tension 並將 WireDiameter 改為 VARCHAR(50)
CREATE TABLE WorkOrder (
    WorkOrderID VARCHAR(50) PRIMARY KEY,  -- 工單編號
    Date DATE NOT NULL,                   -- 日期
    ID VARCHAR(50) NOT NULL,              -- ID
    Mold VARCHAR(100) NOT NULL,           -- 模具
    Terminal VARCHAR(100) NOT NULL,       -- 端子
    WireDiameter VARCHAR(50) NOT NULL,    -- 線徑文字
    TotalQuantity INT NOT NULL,           -- 總數量
    WorkTimeSeconds INT NOT NULL,         -- 工作時間(秒)
    Tension DECIMAL(10, 2)                -- 添加拉力值
);

-- 創建打線表單
CREATE TABLE WiringRecord (
    ID INT AUTO_INCREMENT PRIMARY KEY,        -- 自動增量ID
    WorkOrderID VARCHAR(50) NOT NULL,         -- 工單編號 (外鍵)
    Date DATE NOT NULL,                       -- 日期
    SampleTestSerialNumber VARCHAR(100) NOT NULL, -- 抽樣測試序號
    FrontLength DECIMAL(10, 2) NOT NULL,      -- 前段長度，支援小數點
    BackLength DECIMAL(10, 2) NOT NULL,       -- 後段長度，支援小數點
    Tension DECIMAL(10, 2),                   -- 拉力值，支援小數點
    KEY (WorkOrderID),                        -- 工單編號索引
    FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

-- 創建配方表，將 WireDiameter 改為 VARCHAR(50)
CREATE TABLE Recipe (
    RecipeID INT AUTO_INCREMENT PRIMARY KEY,  -- 自增主鍵
    MoldID VARCHAR(50) NOT NULL,              -- 模具編號
    TerminalID VARCHAR(50) NOT NULL,          -- 端子編號
    WireDiameter VARCHAR(50) NOT NULL,        -- 線徑文字
    MotorHeight DECIMAL(10, 2) NOT NULL,      -- 馬達高度
    UpperLimit DECIMAL(10, 2) NOT NULL,       -- 上限值
    Average DECIMAL(10, 2) NOT NULL,          -- 平均值
    LowerLimit DECIMAL(10, 2) NOT NULL,       -- 下限值
    UNIQUE KEY unique_recipe (MoldID, TerminalID, WireDiameter)  -- 唯一鍵
);

-- 創建沖壓異常記錄表
CREATE TABLE StampingAbnormality (
    AbnormalityID INT AUTO_INCREMENT PRIMARY KEY,  -- 異常記錄ID
    WorkOrderID VARCHAR(50) NOT NULL,              -- 工單編號 (外鍵)
    AbnormalityTime DATETIME NOT NULL,             -- 異常發生時間點
    AbnormalityType VARCHAR(100) NOT NULL,         -- 異常類型
    Description TEXT,                              -- 異常描述
    HandlingMeasures TEXT,                         -- 處理措施
    HandledBy VARCHAR(50),                         -- 處理人員
    Status ENUM('pending', 'handling', 'resolved') DEFAULT 'pending', -- 處理狀態
    FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

-- 創建異常類型參考表（可選）
CREATE TABLE AbnormalityType (
    TypeID INT AUTO_INCREMENT PRIMARY KEY,
    TypeName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT
);
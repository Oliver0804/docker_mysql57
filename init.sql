-- 創建數據庫
CREATE DATABASE IF NOT EXISTS WiringSystemRecordsDB;

-- 使用數據庫
USE WiringSystemRecordsDB;

-- 創建工單表單
CREATE TABLE WorkOrder (
    WorkOrderID VARCHAR(50) PRIMARY KEY,  -- 工單編號
    Date DATE NOT NULL,                   -- 日期
    ID VARCHAR(50) NOT NULL,              -- ID
    Mold VARCHAR(100) NOT NULL,           -- 模具
    Terminal VARCHAR(100) NOT NULL,       -- 端子
    WireDiameter DECIMAL(10, 2) NOT NULL,    -- 線徑，支援小數點
    TotalQuantity INT NOT NULL,           -- 總數量
    WorkTimeSeconds INT NOT NULL          -- 工作時間(秒)
);

-- 創建打線表單
CREATE TABLE WiringRecord (
    ID INT AUTO_INCREMENT PRIMARY KEY,        -- 自動增量ID
    WorkOrderID VARCHAR(50) NOT NULL,         -- 工單編號 (外鍵)
    Date DATE NOT NULL,                       -- 日期
    SampleTestSerialNumber VARCHAR(100) NOT NULL, -- 抽樣測試序號
    FrontLength DECIMAL(10, 2) NOT NULL,      -- 前段長度，支援小數點
    BackLength DECIMAL(10, 2) NOT NULL,       -- 後段長度，支援小數點
    Tension DECIMAL(10, 2) NOT NULL,          -- 拉力值，支援小數點
    FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

-- 創建配方表
CREATE TABLE Recipe (
    MoldID VARCHAR(50) PRIMARY KEY,       -- 模具編號
    TerminalID VARCHAR(50) NOT NULL,      -- 端子編號
    WireDiameter DECIMAL(10, 2) NOT NULL,    -- 線徑，支援小數點
    MotorHeight INT NOT NULL              -- 馬達高度
);

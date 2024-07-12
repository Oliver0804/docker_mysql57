-- Create the database
CREATE DATABASE WiringSystemRecordsDB;

-- Use the database
USE WiringSystemRecordsDB;

-- Create the WorkOrder table
CREATE TABLE WorkOrder (
    WorkOrderID VARCHAR(50) PRIMARY KEY,
    Date DATE NOT NULL,
    ID VARCHAR(50) NOT NULL,
    Mold VARCHAR(100) NOT NULL,
    Terminal VARCHAR(100) NOT NULL,
    WireDiameter VARCHAR(50) NOT NULL,
    TotalQuantity INT NOT NULL
);

-- Create the WiringRecord table
CREATE TABLE WiringRecord (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE NOT NULL,
    ProductionLineNumber VARCHAR(50) NOT NULL,
    SideLineMeasurement VARCHAR(100) NOT NULL,
    FrontLength INT NOT NULL,
    BackLength INT NOT NULL,
    WorkOrderID VARCHAR(50) NOT NULL,
    TimeSeconds INT NOT NULL,
    FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

-- Create the Recipe table
CREATE TABLE Recipe (
    MoldID VARCHAR(50) PRIMARY KEY,
    TerminalID VARCHAR(50) NOT NULL,
    WireDiameter VARCHAR(50) NOT NULL,
    MotorHeight INT NOT NULL
);


-- Create a new database called 'GadgetsDB'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'GadgetsDB'
)
CREATE DATABASE GadgetsDB
GO
 
-- Switch to the GadgetsDB database
USE GadgetsDB
 
-- Creating a FlashDrive table
CREATE TABLE [FlashDrive]
(
    [FlashDrvId] [int] IDENTITY(1,1) NOT NULL,
    [Color] [varchar](20) NULL,
    [CaseWidth] INT NULL,
    [CaseDepth] INT NULL,
    [Price] [decimal](10, 2) NULL,
	[PurchaseDate] Date NULL,
    CONSTRAINT [PK_FlashDrvType] PRIMARY KEY CLUSTERED 
(
   [FlashDrvId] ASC
)
)
 
-- Insert rows into table 'FlashDrive' 
INSERT INTO [dbo].[FlashDrive]
( -- Columns to insert data into
 Color,[CaseWidth],[CaseDepth], Price, PurchaseDate
)
VALUES
(
    'Black',49,20,200.00,'2021-01-11'
),
(
    'White',45,18,150.00,'2022-02-14'
),
(
    'Purple',50,15,NULL,'2022-05-10'
),
(
    NULL,55,15,170.50,'2022-04-15'
),
(
    '-1',NULL,NULL,NULL,NULL
),
(
    '-2',NULL,20,300,'2022-03-29'
)


--TRUNCATE TABLE FLASHDRIVE
--Drop Table FLASHDRIVE

-- Get both numeric and negative Color column values from Watch table
SELECT *, ISNUMERIC(Color)
FROM  FLASHDRIVE
WHERE ISNUMERIC (Color)=1 
AND CAST(Color AS INT)<1

-- Data wrangling by grouping data into Null and Non-Nulls by initializing all numeric negative color values with NULLS
UPDATE FLASHDRIVE
SET Color=NULL
WHERE ISNUMERIC
(Color)=1 AND CAST
(Color AS INT)<1

--ALTERNATIVE QUERY
SELECT CASE WHEN ISNUMERIC (Color)=1 THEN NULL ELSE Color END AS Color,
CaseWidth,CaseDepth, Price, PurchaseDate FROM FLASHDRIVE


-- look for all the rows where Color is Null 
SELECT * FROM FLASHDRIVE
where COLOR IS NULL
 
-- look for all the rows where CaseWidth is Null 
SELECT * FROM FLASHDRIVE
where CaseWidth IS NULL
 
-- look for all the rows where CaseDepth is Null 
SELECT * FROM FLASHDRIVE
where CaseDepth IS NULL


--Eliminate problematic nulls (excessive nulls) from the FlashDrive table 
DELETE FROM FLASHDRIVE
where Color is NULL 
AND CaseDepth IS NULL
AND CaseWidth IS NULL
AND Price IS NULL

--ALTERNATIVE WAY QUERY
SELECT * FROM FLASHDRIVE WHERE FlashDrvId <> 5


--UNPIVOTING

--Create Electronic Table
CREATE TABLE [Electronic_Revenue]
(
    Item [nvarchar](50) NULL,
    [2018] [decimal](10, 2) NULL,
    [2019] [decimal](10, 2) NULL,
    [2020] [decimal](10, 2) NULL,
	[2021] [decimal](10, 2) NULL,
	[2022] [decimal](10, 2) NULL,
)

-- Insert rows into table Electronic_Revenue1
INSERT INTO [Electronic_Revenue]
( -- Columns to insert data into
 Item,[2018],[2019],[2020],[2021],[2022]
)
VALUES
(
    'Flash Drive',2742.2,2892.9,3177.8,3279.3,3037.7
),
(
    'Ear Phone',1273.8,1264.1,1283.3,1199.9,1198.5
),
(
    'Mobile Phone',591,1158,2048,2982,3175
),
(
    'Mouse',1372.2,1361.2,1254.5,1233.5,1501.8
),
(
    'Printer',	620.2,692.7,818,834.4,724.3
)


-- Unpivot the table.  
SELECT Item, Year, Revenue 
FROM   
   (SELECT Item, [2018],[2019],[2020],[2021],[2022] 
   FROM Electronic_Revenue1) p  
UNPIVOT  
   (Revenue FOR Year IN   
      ([2018],[2019],[2020],[2021],[2022])  
)AS unpvt;  
GO


-- pivot the table.  
--Insert the unpivoted data into a new table Electronic_Rev_Pivot
SELECT Item, Year, Revenue into  Electronic_Rev_Pivot
FROM   
   (SELECT Item, [2018],[2019],[2020],[2021],[2022] 
   FROM Electronic_Revenue1) p  
UNPIVOT  
   (Revenue FOR Year IN   
      ([2018],[2019],[2020],[2021],[2022])  
)AS unpvt;  
GO


SELECT * FROM  Electronic_Rev_Pivot

---pivot the table to your desired format

SELECT Year,   
  [Flash Drive], [Ear Phone], [Mobile Phone], [Mouse], [Printer]  
FROM  
(
  SELECT Item,Year,Revenue    
  FROM Electronic_Rev_Pivot
) AS SourceTable  
PIVOT  
(  
  AVG(Revenue)  
  FOR Item IN ([Flash Drive], [Ear Phone], [Mobile Phone], [Mouse], [Printer])  
) AS PivotTable;  
--a. Create above table (Actions) and insert values

CREATE TABLE Actions
(
Visitor_ID INT PRIMARY KEY IDENTITY (1,1),
Adv_Type VARCHAR(10) NOT NULL,
[Action] VARCHAR(10) NOT NULL
);

INSERT Actions
(Adv_Type,[Action])
VALUES
('A','Left'),
('A','Order'),
('B','Left'),
('A','Order'),
('A','Review'),
('A','Left'),
('B','Left'),
('B','Order'),
('B','Review'),
('A','Review')

SELECT * FROM Actions

-- b. Retrieve count of total Actions and Orders for each Advertisement Type

CREATE VIEW T_A
AS
SELECT Adv_Type, COUNT(Adv_Type) Total_Actions
FROM Actions
GROUP BY Adv_Type

CREATE VIEW T_O
AS
SELECT Adv_Type, COUNT([Action]) Total_Order
FROM Actions
WHERE [Action] = 'Order'
GROUP BY Adv_Type

SELECT * FROM T_A
SELECT * FROM T_O

SELECT T_A.Adv_Type, Total_Order, Total_Actions
FROM T_A,T_O
WHERE T_A.Adv_Type = T_O.Adv_Type

-- c. Calculate Orders (Conversion) rates for each Advertisement Type by dividing by 
-- total count of actions casting as float by multiplying by 1.0.

WITH RATE AS
(
SELECT T_A.Adv_Type, Total_Order, Total_Actions
FROM T_A,T_O
WHERE T_A.Adv_Type = T_O.Adv_Type
)
SELECT Adv_Type,ROUND((CAST(Total_Order AS float)/CAST(Total_Actions AS float))*1.0,2) AS Conversion_Rate
FROM RATE
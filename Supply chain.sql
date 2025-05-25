SELECT TOP (1000) [Product_type]
      ,[SKU]
      ,[Price]
      ,[Availability]
      ,[Number_of_products_sold]
      ,[Revenue_generated]
      ,[Customer_demographics]
      ,[Stock_levels]
      ,[Lead_times]
      ,[Order_quantities]
      ,[Shipping_times]
      ,[Shipping_carriers]
      ,[Shipping_costs]
      ,[Supplier_name]
      ,[Location]
      ,[Lead_time]
      ,[Production_volumes]
      ,[Manufacturing_lead_time]
      ,[Manufacturing_costs]
      ,[Inspection_results]
      ,[Defect_rates]
      ,[Transportation_modes]
      ,[Routes]
      ,[Costs]
  FROM [Supply_Chain].[dbo].[supply_chain_data]
  
  SELECT * FROM supply_chain_data



 --0
 SELECT COUNT(*) FROM supply_chain_data

 --1
 SELECT distinct Product_type
 FROM supply_chain_data

 --2
 SELECT distinct SKU
 FROM supply_chain_data
 
 --3
 SELECT COUNT(distinct SKU) 
 FROM supply_chain_data
 
 --4
 SELECT distinct Shipping_carriers
 FROM supply_chain_data
 
 --5
 SELECT distinct Supplier_name
 FROM supply_chain_data
 
 --6
 SELECT distinct Transportation_modes
 FROM supply_chain_data
 
 --7
 SELECT distinct Routes
 FROM supply_chain_data
 --8
 SELECT distinct Customer_demographics
 FROM supply_chain_data
 --9
 SELECT distinct Location
 FROM supply_chain_data
 --10
 SELECT SUM(Revenue_generated) as Total_Revenue
 FROM supply_chain_data
 --11
 SELECT SUM(Costs) as Total_Cost
 FROM supply_chain_data
 --12
 SELECT Distinct Inspection_results
 FROM supply_chain_data
 --13
 SELECT Product_type, SUM(Revenue_generated) as Total_Revenue
 FROM supply_chain_data
 GROUP BY Product_type
 --14
 SELECT Product_type, SUM(Revenue_generated) as Total_Revenue
 FROM supply_chain_data
 GROUP BY Product_type

 --15
 SELECT Customer_demographics, SUM(Revenue_generated) as Total_Revenue
 FROM supply_chain_data
 GROUP BY Customer_demographics


  --16
 SELECT Routes, SUM(Revenue_generated) as Total_Revenue
 FROM supply_chain_data
 GROUP BY Routes

   --17
 SELECT Location, SUM(Revenue_generated) as Total_Revenue
 FROM supply_chain_data
 GROUP BY Location
 
   --18
 SELECT Inspection_results, SUM(Revenue_generated) as Total_Revenue
 FROM supply_chain_data
 GROUP BY Inspection_results

 --19
 SELECT Product_type, SUM(Costs) as Total_Cost
 FROM supply_chain_data
 GROUP BY Product_type

  --20
 SELECT Shipping_carriers, SUM(Shipping_costs) as Total_Cost
 FROM supply_chain_data
 GROUP BY Shipping_carriers

 --21
 WITH CTE AS (
  SELECT *, ROW_NUMBER() OVER( PARTITION BY SKU ORDER BY SKU) AS rn
  FROM supply_chain_data
  )
  DELETE FROM CTE WHERE rn>1;

   --22
EXEC sp_rename 'dbo.supply_chain_data.procurement_time', 'lead_time', 'COLUMN';
  
  SELECT * FROM supply_chain_data

   --23
  EXEC sp_rename 'dbo.supply_chain_data.lead_times', 'procurement_time', 'COLUMN';

   --24
  UPDATE supply_chain_data
  SET Price= ROUND(Price,2);

   --25
  UPDATE supply_chain_data
  SET Revenue_generated=ROUND(Revenue_generated,2)
   
   --26
  UPDATE supply_chain_data
  SET Shipping_costs=ROUND(Shipping_costs,2)
   
   --27
  UPDATE supply_chain_data
  SET Manufacturing_costs=ROUND(Manufacturing_costs,2)

   --28
  UPDATE supply_chain_data
  SET Costs=ROUND(Costs,2)

   --29
  UPDATE supply_chain_data
  SET Defect_rates=ROUND(Defect_rates,2)

   SELECT * FROM supply_chain_data

   --30
   EXEC sp_rename 'dbo.supply_chain_data.Number_of_products_sold','Products_sold','COLUMN';

   --31
   SELECT SKU, COUNT(*) AS DuplicateCount
  FROM supply_chain_data
  GROUP BY SKU
  HAVING COUNT(*) > 1;

  --32 Checking for Duplicity
  SELECT *
FROM supply_chain_data
WHERE SKU IN (
    SELECT SKU
    FROM supply_chain_data
    GROUP BY SKU
    HAVING COUNT(*) > 1
)
ORDER BY SKU;

--33 Checking for Duplicity
  SELECT *
FROM supply_chain_data
WHERE Product_type IN (
    SELECT Product_type
    FROM supply_chain_data
    GROUP BY Product_type
    HAVING COUNT(*) > 1
)
ORDER BY Product_type;

--34 Checing for Null
  SELECT *
  FROM supply_chain_data
  WHERE Price is NULL;



 SELECT COUNT(*) AS NullCount
  FROM supply_chain_data
  WHERE Product_type is NULL;

  SELECT COUNT(*) AS NullCount
  FROM supply_chain_data
  WHERE Products_sold is NULL;

  SELECT COUNT(*) AS NullCount
  FROM supply_chain_data
  WHERE Costs is NULL;

  SELECT * FROM supply_chain_data

  --35 Creating table: Dim_Product
 CREATE TABLE Dim_Product (
 Product_Ind INT IDENTITY PRIMARY KEY,
 SKU VARCHAR(50) UNIQUE,
 Price FLOAT,
 Availability INT,
 Stock_levels INT,
 Costs FLOAT
 );


 --Test
 SELECT count(*) FROM Dim_Product 
 


  --35 Adding Values: Dim_Product
 ALTER TABLE dim_product
 ADD Product_type VARCHAR(50)

 INSERT INTO dim_product (SKU, Product_type, Price, Availability, Stock_levels, Costs)
SELECT DISTINCT
    SKU, Product_type, Price, Availability,Stock_levels, Costs
FROM supply_chain_data;

--36 Dim_Customer
CREATE TABLE Dim_Customer (
 Demography_Id INT IDENTITY PRIMARY KEY,
Customer_demographics VARCHAR(50) UNIQUE
 );

 INSERT INTO Dim_Customer (Customer_demographics)
SELECT DISTINCT
    Customer_demographics
FROM supply_chain_data;

--Test
SELECT * FROM Dim_Customer

--Tables created up until now-Dim_Product and Dim_customer other than the main table

--Dim_Supplier

CREATE TABLE Dim_Supplier (
Supplier_Id INT IDENTITY PRIMARY KEY,
Supplier_name VARCHAR(50) UNIQUE
)

INSERT INTO Dim_Supplier (Supplier_name)
SELECT DISTINCT
Supplier_name
FROM supply_chain_data

SELECT * FROM Dim_Supplier

--Dim_Location
CREATE TABLE Dim_Location (
Location_Id INT IDENTITY PRIMARY KEY,
Location VARCHAR(50) UNIQUE
)

INSERT INTO Dim_Location (Location)
SELECT DISTINCT
Location
FROM supply_chain_data


--Dim_Shipping
CREATE TABLE Dim_Shipping (
Shipping_Id INT IDENTITY PRIMARY KEY,
Shipping_carriers VARCHAR(50) UNIQUE
)

INSERT INTO Dim_Shipping (Shipping_carriers)
SELECT DISTINCT
Shipping_carriers
FROM supply_chain_data

--Dim_Transportation
CREATE TABLE Dim_Transportation (
Transportation_Id INT IDENTITY PRIMARY KEY,
Transportation VARCHAR(50) UNIQUE
)

INSERT INTO Dim_Transportation (Transportation)
SELECT DISTINCT
Transportation_modes
FROM supply_chain_data

--Dim_Inspection
CREATE TABLE Dim_Inspection (
Inspection_Id INT IDENTITY PRIMARY KEY,
Inspection VARCHAR(50) UNIQUE
)

INSERT INTO Dim_Inspection (Inspection)
SELECT DISTINCT
Inspection_results
FROM supply_chain_data


--Dim_Route
CREATE TABLE Dim_Route (
Route_Id INT IDENTITY PRIMARY KEY,
Routes VARCHAR(50) UNIQUE
)

INSERT INTO Dim_Route (Routes)
SELECT DISTINCT
Routes
FROM supply_chain_data

--Wrong Query to change column name
UPDATE Dim_Inspection
SET Demography_Id = 'customer_id'
--Right Query to change column name
EXEC sp_rename 'Dim_Customer.customer_id', 'Customer_id', 'COLUMN';

EXEC sp_rename 'Dim_Product.Product_ind', 'Product_id', 'COLUMN';

--Test
SELECT * FROM Dim_Route

SELECT * FROM fact_supply_chain

SELECT * FROM Dim_Product
--FACT TABLE
--DROPPING TABLE
DROP TABLE fact_supply_chain

--CREATING FRESH TABLE
CREATE TABLE fact_supply_chain (
    Product_id INT,
   Customer_id INT,
 Supplier_Id INT,
    Location_id INT,
    Shipping_id INT,
   Inspection_id INT,
    Transportation_id INT,
 Route_id INT,
    Products_sold INT,
    Revenue_generated FLOAT,
    procurement_time INT,
    Order_quantities INT,
    Shipping_times INT,
    Shipping_costs FLOAT,
    lead_time INT,
    Production_volumes INT,
    Manufacturing_lead_time INT,
    Manufacturing_costs FLOAT,
    Defect_rates FLOAT,
    -- Add more measures as needed
    FOREIGN KEY (Product_id) REFERENCES dim_Product(Product_id),
    FOREIGN KEY (Customer_id) REFERENCES dim_Customer(Customer_id),
    FOREIGN KEY (Supplier_id) REFERENCES dim_Supplier(Supplier_id),
    FOREIGN KEY (Location_id) REFERENCES dim_Location(Location_id),
    FOREIGN KEY (Shipping_id) REFERENCES dim_Shipping(Shipping_id),
    FOREIGN KEY (Inspection_id) REFERENCES dim_Inspection(Inspection_id),
    FOREIGN KEY (Transportation_id) REFERENCES dim_Transportation(Transportation_id),
    FOREIGN KEY (Route_id) REFERENCES dim_Route(Route_id)
);

--Checking Fact table supply chain
SELECT * FROM fact_supply_chain


INSERT INTO fact_supply_chain (
    Product_id, Customer_id, Supplier_id, Location_id, Shipping_id, Inspection_id,
    Transportation_id, Route_id,
    Products_sold, Revenue_generated,procurement_time, Order_quantities,
	Shipping_times, Shipping_costs, 
	lead_time, Production_volumes, Manufacturing_lead_time, Manufacturing_costs, Defect_rates
)
SELECT
    p.Product_id,
    c.Customer_id,
    s.Supplier_Id,
    l.Location_Id,
    sh.Shipping_Id,
    i.Inspection_Id,
    t.Transportation_Id,
    r.Route_Id,
    M.Products_sold,
    M.Revenue_generated,
    M.procurement_time,
    M.Order_quantities,
    M.Shipping_times,
    M.Shipping_costs,
    M.lead_time,
    M.Production_volumes,
    M.Manufacturing_lead_time,
    M.Manufacturing_costs,
    M.Defect_rates
FROM supply_chain_data M
JOIN dim_product p ON M.SKU = p.SKU
JOIN Dim_Customer c ON M.Customer_demographics = c.Customer_demographics
JOIN Dim_Supplier s ON M.Supplier_name= s.Supplier_name
JOIN Dim_Location l ON M.Location = l.Location
JOIN Dim_Shipping sh ON M.Shipping_carriers = sh.Shipping_carriers
JOIN Dim_Inspection i ON M.Inspection_results = i.Inspection
JOIN Dim_Transportation t ON M.Transportation_modes= t.Transportation
JOIN Dim_Route r ON M.Routes = r.Routes;

SELECT COUNT(*) FROM fact_supply_chain

--Printing P.Product_id, P.Product_type, P.Price, F.Revenue_generated joining Dim_Product and Fact Table

SELECT P.Product_id, P.Product_type, P.Price, F.Revenue_generated  
FROM fact_supply_chain F
LEFT JOIN Dim_Product P ON F.Product_id=P.Product_id
ORDER BY P.Product_id ASC;

--Testing the Fact-Product tables numerically

SELECT P.Product_type, SUM(P.Price) AS Product_Revenue
FROM fact_supply_chain F
LEFT JOIN Dim_Product P ON F.Product_id=P.Product_id
GROUP BY P.Product_type;

--Creating Indexes for Product, Supplier, Location and Customer tables based on their importance 

CREATE INDEX idx_fact_product ON fact_supply_chain (Product_id);
CREATE INDEX idx_fact_customer ON fact_supply_chain (Customer_id);
CREATE INDEX idx_fact_supplier ON fact_supply_chain (Supplier_id);
CREATE INDEX idx_fact_location ON fact_supply_chain (Location_id);

CREATE VIEW vw_supply_chain AS
SELECT
    F.Product_id,
	p.SKU,
	p.Product_type,
	p.Price,
	p.Availability,
	p.Costs,
	p.Stock_levels,
	c.Customer_demographics,
	s.Supplier_name,
	l.Location,
	sh.Shipping_carriers,
    i.Inspection,
    t.Transportation,
    r.Routes,
    F.Products_sold,
    F.Revenue_generated,
    F.procurement_time,
    F.Order_quantities,
    F.Shipping_times,
    F.Shipping_costs,
    F.lead_time,
    F.Production_volumes,
    F.Manufacturing_lead_time,
    F.Manufacturing_costs,
    F.Defect_rates
FROM fact_supply_chain F
JOIN dim_product p ON F.Product_id = p.Product_id
JOIN Dim_Customer c ON F.Customer_id = c.Customer_id
JOIN Dim_Supplier s ON F.Supplier_id= s.Supplier_Id
JOIN Dim_Location l ON F.Location_id = l.Location_Id
JOIN Dim_Shipping sh ON F.Shipping_id = sh.Shipping_Id
JOIN Dim_Inspection i ON F.Inspection_id = i.Inspection_Id
JOIN Dim_Transportation t ON F.Transportation_id = t.Transportation_Id
JOIN Dim_Route r ON F.Route_id = r.Route_Id;


--Altering view 
ALTER VIEW vw_supply_chain AS
SELECT
    fact.Product_id,
    product.Product_type,
    product.SKU,
    customer.Customer_demographics,
    supplier.Supplier_name,
    location.Location,
    shipping.Shipping_carriers,
    inspection.Inspection,
    transportation.Transportation,
    route.Routes,
    fact.Products_sold,
    fact.Revenue_generated,
    fact.procurement_time,
    fact.Order_quantities,
    fact.Shipping_times,
    fact.Shipping_costs,
    fact.lead_time,
    fact.Production_volumes,
    fact.Manufacturing_lead_time,
    fact.Manufacturing_costs,
    fact.Defect_rates
FROM fact_supply_chain AS fact
JOIN dim_product AS product ON fact.Product_id = product.Product_id
JOIN Dim_Customer AS customer ON fact.Customer_id = customer.Customer_id
JOIN Dim_Supplier AS supplier ON fact.Supplier_id = supplier.Supplier_Id
JOIN Dim_Location AS location ON fact.Location_id = location.Location_Id
JOIN Dim_Shipping AS shipping ON fact.Shipping_id = shipping.Shipping_Id
JOIN Dim_Inspection AS inspection ON fact.Inspection_id = inspection.Inspection_Id
JOIN Dim_Transportation AS transportation ON fact.Transportation_id = transportation.Transportation_Id
JOIN Dim_Route AS route ON fact.Route_id = route.Route_Id;


SELECT * FROM Dim_Product
SELECT * FROM fact_supply_chain

--Left Join
SELECT F.Product_id, P.Price * F.Order_quantities AS Total_Sales, F.Revenue_generated
FROM fact_supply_chain AS F
LEFT JOIN Dim_Product AS P ON F.Product_id=P.Product_id
ORDER BY F.Product_id;

--Join
SELECT F.Product_id, P.Price * F.Order_quantities AS Total_Sales, F.Revenue_generated
FROM fact_supply_chain AS F
JOIN Dim_Product AS P ON F.Product_id=P.Product_id
ORDER BY F.Product_id;

--TESTING Analysing......[Supply chain master table]
SELECT P.Product_type, SUM(P.Price * F.Order_quantities) AS Total_Sales, SUM(F.Revenue_generated) AS Revenue_generated
FROM fact_supply_chain AS F
JOIN Dim_Product AS P ON F.Product_id=P.Product_id
Group BY P.Product_type;


SELECT P.Product_type, P.Price * F.Order_quantities AS Total_Sales, F.Revenue_generated
FROM fact_supply_chain AS F
JOIN Dim_Product AS P ON F.Product_id=P.Product_id
GROUP BY P.Product_type;

SELECT * FROM Dim_Customer
SELECT * FROM Dim_Product
SELECT * FROM Dim_Transportation
SELECT * FROM Dim_Inspection
SELECT * FROM Dim_Location
SELECT * FROM Dim_Route
SELECT * FROM Dim_Shipping
SELECT * FROM Dim_Supplier
SELECT * FROM fact_supply_chain

--Extracting from Fact, Customer and Product
SELECT Ch.Customer_demographics, SUM(P.Price * F.Order_quantities) AS Total_Sales, SUM(F.Revenue_generated) AS Total_revenue
FROM fact_supply_chain AS F
JOIN Dim_Product AS P ON F.Product_id=P.Product_id
JOIN Dim_Customer AS Ch ON F.Customer_id=Ch.Customer_id
GROUP BY Ch.Customer_demographics;

--Extracting from Fact, Inspection and Product
SELECT I.Inspection, SUM(P.Price * F.Order_quantities) AS Total_Sales, SUM(F.Revenue_generated) AS Total_revenue
FROM fact_supply_chain AS F
JOIN Dim_Product AS P ON F.Product_id=P.Product_id
JOIN Dim_Inspection AS I ON F.Inspection_id=I.Inspection_Id
GROUP BY I.Inspection;

--Extracting from Fact, Shipping and Product
SELECT Sh.Shipping_carriers, SUM(P.Price * F.Order_quantities) AS Total_Sales, SUM(F.Revenue_generated) AS Total_revenue
FROM fact_supply_chain AS F
JOIN Dim_Product AS P ON F.Product_id=P.Product_id
JOIN Dim_Shipping AS Sh ON F.Shipping_id=Sh.Shipping_Id
GROUP BY Sh.Shipping_carriers;

--Extracting from Fact, Location and Product
SELECT L.Location, SUM(P.Price * F.Order_quantities) AS Total_Sales, SUM(F.Revenue_generated) AS Total_revenue
FROM fact_supply_chain AS F
JOIN Dim_Product AS P ON F.Product_id=P.Product_id
JOIN Dim_Location AS L ON F.Location_id=L.Location_Id
GROUP BY L.Location;














 --22
 SELECT SKU,Defect_rates
 FROM supply_chain_data
WHERE Defect_rates= MIN(Defect_rates)

 --23
 WITH CTE AS(
 SELECT SUM(Revenue_generated) 
 FROM supply_chain_data
 )

 SELECT customer_demographics,SUM(Revenue_generated)/CTE as Revenue share
 FROM supply_chain_data
 GROUP BY customer demographics

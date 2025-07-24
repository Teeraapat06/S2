SELECT 
  OrderID, 
  ProductID, 
  UnitPrice, 
  Quantity, 
  Discount,
  (UnitPrice * Quantity) AS TotalPrice,
  (UnitPrice * Quantity) - (UnitPrice * Quantity * Discount) AS NetPrice
FROM [Order Details];
SELECT (42.40 * 35) - (42.40 * 35 * 0.15) AS NetPrice;

SELECT 
  EmployeeID, 
  FirstName, 
  BirthDate, 
  DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age,
  HireDate, 
  DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsWorked
FROM Employees;

SELECT
  COUNT(*) AS จำนวนสินค้า, 
   count(ProductName),count(UnitPrice)
FROM
  Products
WHERE
  UnitsInStock < 15

-- จำนวนลูกค้าที่อยู่ประเทศ USA
SELECT COUNT(*) AS TotalCustomersInUSA
FROM Customers
WHERE Country = 'USA';

-- จำนวนพนักงานที่อยู่ใน london
SELECT count(*)
FROM Employees
WHERE city = 'London'

-- จำนวนใบสั่งที่ออกในปี 1997
Select count(*)
from Orders
where year(orderdate) = 1997

-- จำนวนครั้งที่ขายสินค้ารหัส 1
select count(*)
from [Order Details]
where productID = 1

-- จำนวนสินค้าที่ขายได้ทั้งหมด เฉพาะสินค้ารหัส 1
select sum(quantity)
from [Order Details]
where ProductID = 1

-- มูลค่าสินค้าในคลังทั้งหมด
select sum(UnitPrice * UnitsInStock)
from Products

-- จำนวนสินค้ารหัสประเภท 8 ที่สั่งซื้อแล้ว
select sum(UnitsOnOrder)
from Products
where CategoryID = 8

-- ราคาสินค้ารหัส 1 ที่ขายได้ราคาสูงสุดและต่ำสุด
select max(UnitPrice), min(UnitPrice) 
from [Order Details]
where ProductID = 1

--function AVG
--ราคาสินค้าเฉลี่ยทั้งหมดที่เคยขายได้ เฉพาะสินค้ารหัส 5
select avg(unitprice), min(unitprice), max(unitprice)
from [Order Details]
where ProductID = 5

SELECT Country, COUNT(*) AS TotalCustomers
FROM Customers
GROUP BY Country;

--ประเทศ และจำนวนลูกค้า
select country, count(*)
from Customers
group by country;

--รหัสประเภทสินค้า ราคาเฉลี่ยของสินค้าประเภทเดียวกัน
select 
    categoryID, avg(unitprice), min(unitprice), max(unitprice)
from Products
group by categoryID

--รายการสินค้าในการสั่งซื้อ [order deteils]
select orderID, count(*)
from [Order Details]
group by OrderID
having count(*)>3

--ประเทศ และจำนวนในการสั่งสินค้าไปถึงปลายทาง
select shipcountry, count(*) numOfoders
from Orders
group by ShipCountry
having count(*)>=100

select orderID, sum(unitprice*quantity*(1-discount))
from [Order Details]
group by OrderID
having sum(UnitPrice*Quantity*(discount))< 100

-- ประเทศใดที่มีจำนวนใบสั่งซื้อที่ส่งสินค้าไปปลายทางต่ำกว่า 20 รายการ ในปี 1997
SELECT ShipCountry, COUNT(*)
FROM Orders
WHERE YEAR(OrderDate) = 1997
GROUP BY ShipCountry
HAVING COUNT(*) < 20
ORDER BY count(*) DESC

-- ใบสั่งซื้อใดมียอดขายสูงที่สุด แสดงรหัสใบสั่งและยอดขาย
select 
 top 1 orderID, sum(UnitPrice*Quantity*(1-Discount)) as total
 from [Order Details]
 group by OrderID
 ORDER by total desc

-- ใบสั่งซื้อใดมียอดขายต่ำที่สุด 5 อันดับ แสดงรหัสใบสั่งซื้อและยอดขาย
select 
 top 5 orderID, sum(UnitPrice*Quantity*(1-Discount)) as total
 from [Order Details]
 group by OrderID
 ORDER by total asc

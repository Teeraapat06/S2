-- แสดงชื่อประเภทสินค้า ชื่อสินค้า และ ราคาสินค้า
Select c.CategoryName, p.ProductName, p.UnitPrice
From Products as p, Categories as c
Where p.CategoryID = c.CategoryID

-- แสดงชื่อประเภทสินค้า ชื่อสินค้า และ ราคาสินค้า
Select c.CategoryName, p.ProductName, p.UnitPrice
From Products as p, Categories as c
Where p.CategoryID = c.CategoryID
And CategoryName = 'seafood'

Select c.CategoryName, p.ProductName, p.UnitPrice
From Products as p join Categories as c
Where p.CategoryID = c.CategoryID
And CategoryName = 'seafood'

-- จงแสดงข้อมูลหมายเลขใบสั่งซื้อและชื่อบริษัทขนส่งสินค้า
SELECT CompanyName, OrderID
FROM Orders, Shippers
WHERE Shippers.ShipperID = Orders.Shipvia

SELECT CompanyName, OrderID
FROM Orders JOIN Shippers
ON Shippers.ShipperID = Orders.Shipvia

-- จงแสดงข้อมูลหมายเลขใบสั่งซื้อและชื่อบริษัทขนส่งสินค้าของใบสั่งซื้อหมายเลข 10275
SELECT CompanyName, OrderID
FROM Orders, Shippers
WHERE Shippers.ShipperID = Orders.Shipvia
AND OrderID = 10275

SELECT CompanyName, OrderID
FROM Orders JOIN Shippers
ON Shippers.ShipperID=Orders.Shipvia
WHERE OrderID=10275

Select * from Orders    where OrderID = 10250
Select * from [Order Details] where OrderID = 10250

-- ต้องการรหัสสินค้า ซื้อสินค้า บริษัทผู้จำหน่าย ประเทศ
SELECT p.ProductID, p.ProductName, s.CompanyName, s.Country
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID

-- ต้องการรหัสพนักงาน ชื่อพนักงาน รหัสใบสั่งซื้อที่เกี่ยวข้อง เรียงตามลำดับรหัสพนักงาน
SELECT e.EmployeeID, e.FirstName, o.OrderID
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
ORDER BY e.EmployeeID;

-- ต้องการรหัสสินค้า ชื่อสินค้า เมือง และประเทศของบริษัทผู้จำหน่าย
SELECT p.ProductID, p.ProductName, s.City, s.Country
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID;

-- จงแสดงหมายเลขใบสั่งซื้อ, ชื่อบริษัทลูกค้า,สถานที่ส่งของ, และพนักงานผู้ดูแล
SELECT O.OrderID เลขใบสั่งซื้อ, C.CompanyName ลูกค้า, E.FirstName พนักงาน, O.ShipAddress ส่งไปที่
FROM Orders O
join Customers C on O.CustomerID=C.CustomerID
join Employees E on O.EmployeeID=E.EmployeeID

-- ต้องการ รหัสพนักงาน ชื่อพนักงาน จำนวนใบสั่งซื้อที่เกี่ยวข้อง ผลรวมของค่าขนส่ง ในปี 1998
SELECT e.EmployeeID, e.FirstName AS EmployeeName, COUNT(o.OrderID) AS OrderCount, SUM(o.Freight) AS TotalFreight
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
WHERE YEAR(o.OrderDate) = 1998
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY e.EmployeeID

-- ต้องการชื่อบริษัทขนส่ง และจำนวนใบสั่งซื้อที่เกี่ยวข้อง
Select s.CompanyName, count(*) จำนวนorders
from Shippers s
join orders o on s .ShipperID = o.ShipVia
group by s.CompanyName
ORDER BY 2 DESC

-- ต้องการรหัสสินค้า ชื่อสินค้า และจำนวนทั้งหมดที่ขายได้
select p.ProductID, p.ProductName, sum(Quantity) จำนวนที่ขายได้
from Products p 
join [Order Details] od on p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName

-- ต้องการรหัสสินค้า ชื่อสินค้า ที่ nancy ขายได้ ทั้งหมด เรียงตามลำดับสินค้า
SELECT p.ProductID, p.ProductName
FROM Employees e Join Orders o on e.EmployeeID = o.EmployeeID
                 Join [Order Details] od on o.OrderID = od.OrderID
                 Join Products p on p.ProductID = od.ProductID
Where e.FirstName = 'Nancy'
ORDER BY ProductID

SELECT DISTINCT p.ProductID, p.ProductName
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
                 JOIN [Order Details] od ON o.OrderID = od.OrderID
                 JOIN Products p ON p.ProductID = od.ProductID
WHERE e.FirstName = 'Nancy'
ORDER BY p.ProductID

-- ต้องการชื่อบริษัทลูกค้าชื่อ Around the horn ซื้อสินค้าที่มาจากประเทศอะไรบ้าง
select distinct s.Country
from Customers c join orders o on c.CustomerID = o.CustomerID
                 join [Order Details] od on o.OrderID = od.OrderID
                 join products p on p.ProductID = od.ProductID
                 join Suppliers s on s.SupplierID = p.SupplierID
where c.CompanyName = 'Around the horn'

-- บริษัทลูกค้าชื่อ Around the horn ซื้อสินค้าอะไรบ้าง จำนวนเท่าใด
SELECT p.ProductID, p.ProductName, SUM(Quantity) จำนวนที่ซื้อ
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
                 JOIN [Order Details] od ON o.OrderID = od.OrderID
                 JOIN Products p ON p.ProductID = od.ProductID
WHERE c.CompanyName = 'Around the Horn'
GROUP BY p.ProductName, p.ProductName

-- ต้องการหมายเลขใบสั่งซื้อ ชื่อพนักงาน และยอดขายในใบสั่งซื้อนั้น
select o.OrderID, FirstName, sum(od.Quantity* od.UnitPrice * (1-Discount)) TotalCash
from Orders o join Employees e on o.EmployeeID = e.EmployeeID
              join [Order Details] od on o.OrderID = od.OrderID
Group by o.OrderID, FirstName

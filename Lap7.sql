-- 1.   จงแสดงให้เห็นว่าพนักงานแต่ละคนขายสินค้าประเภท Beverage ได้เป็นจำนวนเท่าใด และเป็นจำนวนกี่ชิ้น เฉพาะครึ่งปีแรกของ 2540(ทศนิยม 4 ตำแหน่ง)
SELECT
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS BeverageSalesAmount,
    SUM(od.Quantity) AS BeverageUnits
FROM Employees e
JOIN Orders o           ON o.EmployeeID = e.EmployeeID
JOIN [Order Details] od ON od.OrderID = o.OrderID
JOIN Products p         ON p.ProductID = od.ProductID
JOIN Categories c       ON c.CategoryID = p.CategoryID
WHERE c.CategoryName = 'Beverages'
  AND o.OrderDate >= '1997-01-01'
  AND o.OrderDate <  '1997-07-01'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY BeverageSalesAmount DESC;

-- 2.   จงแสดงชื่อบริษัทตัวแทนจำหน่าย  เบอร์โทร เบอร์แฟกซ์ ชื่อผู้ติดต่อ จำนวนชนิดสินค้าประเภท Beverage ที่จำหน่าย โดยแสดงจำนวนสินค้า จากมากไปน้อย 3 อันดับแรก
SELECT TOP 3
    s.SupplierID,
    s.CompanyName,
    s.ContactName,
    s.Phone,
    s.Fax,
    COUNT(*) AS BeverageProductCount
FROM Suppliers s
JOIN Products p   ON p.SupplierID = s.SupplierID
JOIN Categories c ON c.CategoryID = p.CategoryID
WHERE c.CategoryName = 'Beverages'
GROUP BY s.SupplierID, s.CompanyName, s.ContactName, s.Phone, s.Fax
ORDER BY BeverageProductCount DESC, s.CompanyName;

-- 3.   จงแสดงข้อมูลชื่อลูกค้า ชื่อผู้ติดต่อ เบอร์โทรศัพท์ ของลูกค้าที่ซื้อของในเดือน สิงหาคม 2539 ยอดรวมของการซื้อโดยแสดงเฉพาะ ลูกค้าที่ไม่มีเบอร์แฟกซ์
SELECT
    cu.CustomerID,
    cu.CompanyName,
    cu.ContactName,
    cu.Phone,
    CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS TotalAmountAug1996
FROM Customers cu
JOIN Orders o           ON o.CustomerID = cu.CustomerID
JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE cu.Fax IS NULL
  AND o.OrderDate >= '1996-08-01'
  AND o.OrderDate <  '1996-09-01'
GROUP BY cu.CustomerID, cu.CompanyName, cu.ContactName, cu.Phone
ORDER BY TotalAmountAug1996 DESC;

-- 4.   แสดงรหัสสินค้า ชื่อสินค้า จำนวนที่ขายได้ทั้งหมดในปี 2541 ยอดเงินรวมที่ขายได้ทั้งหมดโดยเรียงลำดับตาม จำนวนที่ขายได้เรียงจากน้อยไปมาก พรอ้มทั้งใส่ลำดับที่ ให้กับรายการแต่ละรายการด้วย
WITH S AS (
  SELECT
      p.ProductID, p.ProductName,
      SUM(od.Quantity) AS TotalQty,
      SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
  FROM Products p
  JOIN [Order Details] od ON od.ProductID = p.ProductID
  JOIN Orders o            ON o.OrderID = od.OrderID
  WHERE o.OrderDate >= '1998-01-01' AND o.OrderDate < '1999-01-01'
  GROUP BY p.ProductID, p.ProductName
)
SELECT
    ROW_NUMBER() OVER (ORDER BY TotalQty ASC, ProductName) AS ลำดับ,
    ProductID,
    ProductName,
    TotalQty,
    CAST(TotalSales AS DECIMAL(18,4)) AS TotalSales
FROM S
ORDER BY TotalQty ASC, ProductName;

-- 5.   จงแสดงข้อมูลของสินค้าที่ขายในเดือนมกราคม 2540 เรียงตามลำดับจากมากไปน้อย 5 อันดับใส่ลำดับด้วย รวมถึงราคาเฉลี่ยที่ขายให้ลูกค้าทั้งหมดด้วย
WITH S AS (
  SELECT
      p.ProductID, p.ProductName,
      SUM(od.Quantity) AS TotalQty,
      SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales,
      AVG(od.UnitPrice * (1 - od.Discount)) AS AvgNetUnitPrice
  FROM Products p
  JOIN [Order Details] od ON od.ProductID = p.ProductID
  JOIN Orders o            ON o.OrderID = od.OrderID
  WHERE o.OrderDate >= '1997-01-01' AND o.OrderDate < '1997-02-01'
  GROUP BY p.ProductID, p.ProductName
)
SELECT TOP 5
    ROW_NUMBER() OVER (ORDER BY TotalSales DESC, ProductName) AS ลำดับ,
    ProductID,
    ProductName,
    TotalQty,
    CAST(TotalSales AS DECIMAL(18,4)) AS TotalSales,
    CAST(AvgNetUnitPrice AS DECIMAL(18,4)) AS AvgNetUnitPrice
FROM S
ORDER BY TotalSales DESC, ProductName;

-- 6.   จงแสดงชื่อพนักงาน จำนวนใบสั่งซื้อ ยอดเงินรวมทั้งหมด ที่พนักงานแต่ละคนขายได้ ในเดือน ธันวาคม 2539 โดยแสดงเพียง 5 อันดับที่มากที่สุด
WITH S AS (
  SELECT
      e.EmployeeID,
      e.FirstName + ' ' + e.LastName AS EmployeeName,
      COUNT(DISTINCT o.OrderID) AS OrderCount,
      SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
  FROM Employees e
  JOIN Orders o            ON o.EmployeeID = e.EmployeeID
  JOIN [Order Details] od  ON od.OrderID = o.OrderID
  WHERE o.OrderDate >= '1996-12-01' AND o.OrderDate < '1997-01-01'
  GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT TOP 5
    EmployeeID,
    EmployeeName,
    OrderCount,
    CAST(TotalSales AS DECIMAL(18,4)) AS TotalSales
FROM S
ORDER BY TotalSales DESC, EmployeeName;

-- 7.   จงแสดงรหัสสินค้า ชื่อสินค้า ชื่อประเภทสินค้า ที่มียอดขาย สูงสุด 10 อันดับแรก ในเดือน ธันวาคม 2539 โดยแสดงยอดขาย และจำนวนที่ขายด้วย
WITH S AS (
  SELECT
      p.ProductID, p.ProductName, c.CategoryName,
      SUM(od.Quantity) AS TotalQty,
      SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
  FROM Products p
  JOIN Categories c       ON c.CategoryID = p.CategoryID
  JOIN [Order Details] od ON od.ProductID = p.ProductID
  JOIN Orders o           ON o.OrderID = od.OrderID
  WHERE o.OrderDate >= '1996-12-01' AND o.OrderDate < '1997-01-01'
  GROUP BY p.ProductID, p.ProductName, c.CategoryName
)
SELECT TOP 10
    ProductID, ProductName, CategoryName,
    TotalQty,
    CAST(TotalSales AS DECIMAL(18,4)) AS TotalSales
FROM S
ORDER BY TotalSales DESC, ProductName;

-- 8.   จงแสดงหมายเลขใบสั่งซื้อ ชื่อบริษัทลูกค้า ที่อยู่ เมืองประเทศของลูกค้า ชื่อเต็มพนักงานผู้รับผิดชอบ ยอดรวมในแต่ละใบสั่งซื้อ จำนวนรายการสินค้าในใบสั่งซื้อ และเลือกแสดงเฉพาะที่จำนวนรายการในใบสั่งซื้อมากกว่า 2 รายการ
WITH per_order AS (
  SELECT
      o.OrderID,
      SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS OrderTotal,
      COUNT(*) AS ItemLines
  FROM Orders o
  JOIN [Order Details] od ON od.OrderID = o.OrderID
  GROUP BY o.OrderID
)
SELECT
    o.OrderID,
    cu.CompanyName AS CustomerCompany,
    cu.Address AS CustomerAddress,
    cu.City    AS CustomerCity,
    cu.Country AS CustomerCountry,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    CAST(p.OrderTotal AS DECIMAL(18,4)) AS OrderTotal,
    p.ItemLines
FROM Orders o
JOIN Customers cu ON cu.CustomerID = o.CustomerID
JOIN Employees e  ON e.EmployeeID = o.EmployeeID
JOIN per_order p  ON p.OrderID = o.OrderID
WHERE p.ItemLines > 2
ORDER BY p.OrderTotal DESC;

-- 9.   จงแสดง ชื่อบริษัทลูกค้า ชื่อผู้ติดต่อ เบอร์โทร เบอร์แฟกซ์ ยอดที่สั่งซื้อทั้งหมดในเดือน ธันวาคม 2539 แสดงผลเฉพาะลูกค้าที่มีเบอร์แฟกซ์
SELECT
    cu.CustomerID,
    cu.CompanyName,
    cu.ContactName,
    cu.Phone,
    cu.Fax,
    CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS TotalDec1996
FROM Customers cu
JOIN Orders o           ON o.CustomerID = cu.CustomerID
JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE cu.Fax IS NOT NULL
  AND o.OrderDate >= '1996-12-01'
  AND o.OrderDate <  '1997-01-01'
GROUP BY cu.CustomerID, cu.CompanyName, cu.ContactName, cu.Phone, cu.Fax
ORDER BY TotalDec1996 DESC;

-- 10.  จงแสดงชื่อเต็มพนักงาน จำนวนใบสั่งซื้อที่รับผิดชอบ ยอดขายรวมทั้งหมด เฉพาะในไตรมาสสุดท้ายของปี 2539 เรียงตามลำดับ มากไปน้อยและแสดงผลตัวเลขเป็นทศนิยม 4 ตำแหน่ง
WITH S AS (
  SELECT
      e.EmployeeID,
      e.FirstName + ' ' + e.LastName AS EmployeeName,
      COUNT(DISTINCT o.OrderID) AS OrderCount,
      SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
  FROM Employees e
  JOIN Orders o           ON o.EmployeeID = e.EmployeeID
  JOIN [Order Details] od ON od.OrderID = o.OrderID
  WHERE o.OrderDate >= '1996-10-01' AND o.OrderDate < '1997-01-01'
  GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT
    EmployeeID,
    EmployeeName,
    OrderCount,
    CAST(TotalSales AS DECIMAL(18,4)) AS TotalSales
FROM S
ORDER BY TotalSales DESC, EmployeeName;

-- 11.  จงแสดงชื่อพนักงาน และแสดงยอดขายรวมทั้งหมด ของสินค้าที่เป็นประเภท Beverage ที่ส่งไปยังประเทศ ญี่ปุ่น
SELECT
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS BeverageToJapanSales
FROM Employees e
JOIN Orders o            ON o.EmployeeID = e.EmployeeID
JOIN [Order Details] od  ON od.OrderID = o.OrderID
JOIN Products p          ON p.ProductID = od.ProductID
JOIN Categories c        ON c.CategoryID = p.CategoryID
WHERE c.CategoryName = 'Beverages'
  AND o.ShipCountry = 'Japan'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY BeverageToJapanSales DESC;

-- 12.  แสดงรหัสบริษัทตัวแทนจำหน่าย ชื่อบริษัทตัวแทนจำหน่าย ชื่อผู้ติดต่อ เบอร์โทร ชื่อสินค้าที่ขาย เฉพาะประเภท Seafood ยอดรวมที่ขายได้แต่ละชนิด แสดงผลเป็นทศนิยม 4 ตำแหน่ง เรียงจาก มากไปน้อย 10 อันดับแรก
WITH S AS (
  SELECT
      s.SupplierID, s.CompanyName, s.ContactName, s.Phone,
      p.ProductID, p.ProductName,
      SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
  FROM Suppliers s
  JOIN Products p         ON p.SupplierID = s.SupplierID
  JOIN Categories c       ON c.CategoryID = p.CategoryID
  JOIN [Order Details] od ON od.ProductID = p.ProductID
  JOIN Orders o           ON o.OrderID = od.OrderID
  WHERE c.CategoryName = 'Seafood'
  GROUP BY s.SupplierID, s.CompanyName, s.ContactName, s.Phone, p.ProductID, p.ProductName
)
SELECT TOP 10
    SupplierID, CompanyName, ContactName, Phone,
    ProductID, ProductName,
    CAST(TotalSales AS DECIMAL(18,4)) AS TotalSales
FROM S
ORDER BY TotalSales DESC, CompanyName, ProductName;

-- 13.  จงแสดงชื่อเต็มพนักงานทุกคน วันเกิด อายุเป็นปีและเดือน พร้อมด้วยชื่อหัวหน้า
WITH A AS (
  SELECT
      e.EmployeeID,
      e.FirstName + ' ' + e.LastName AS EmployeeName,
      e.BirthDate,
      DATEDIFF(MONTH, e.BirthDate, GETDATE()) AS AgeMonths,
      e.ReportsTo
  FROM Employees e
)
SELECT
    a.EmployeeID,
    a.EmployeeName,
    CONVERT(varchar(10), a.BirthDate, 120) AS BirthDate,
    (a.AgeMonths / 12) AS AgeYears,
    (a.AgeMonths - (a.AgeMonths / 12)*12) AS AgeRemainMonths,
    (mgr.FirstName + ' ' + mgr.LastName) AS ManagerName
FROM A a
LEFT JOIN Employees mgr ON mgr.EmployeeID = a.ReportsTo
ORDER BY a.EmployeeName;

-- 14.  จงแสดงชื่อบริษัทลูกค้าที่อยู่ในประเทศ USA และแสดงยอดเงินการซื้อสินค้าแต่ละประเภทสินค้า
SELECT
    cu.CustomerID,
    cu.CompanyName,
    c.CategoryName,
    CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS TotalByCategory
FROM Customers cu
JOIN Orders o           ON o.CustomerID = cu.CustomerID
JOIN [Order Details] od ON od.OrderID = o.OrderID
JOIN Products p         ON p.ProductID = od.ProductID
JOIN Categories c       ON c.CategoryID = p.CategoryID
WHERE cu.Country = 'USA'
GROUP BY cu.CustomerID, cu.CompanyName, c.CategoryName
ORDER BY cu.CompanyName, c.CategoryName;

-- 15.  แสดงข้อมูลบริษัทผู้จำหน่าย ชื่อบริษัท ชื่อสินค้าที่บริษัทนั้นจำหน่าย จำนวนสินค้าทั้งหมดที่ขายได้และราคาเฉลี่ยของสินค้าที่ขายไปแต่ละรายการ แสดงผลตัวเลขเป็นทศนิยม 4 ตำแหน่ง
SELECT
    s.SupplierID,
    s.CompanyName,
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalUnitsSold,
    CAST(AVG(od.UnitPrice * (1 - od.Discount)) AS DECIMAL(18,4)) AS AvgNetUnitPrice
FROM Suppliers s
JOIN Products p         ON p.SupplierID = s.SupplierID
JOIN [Order Details] od ON od.ProductID = p.ProductID
JOIN Orders o           ON o.OrderID = od.OrderID
GROUP BY s.SupplierID, s.CompanyName, p.ProductID, p.ProductName
ORDER BY s.CompanyName, p.ProductName;

-- 16.  ต้องการชื่อบริษัทผู้ผลิต ชื่อผู้ต่อต่อ เบอร์โทร เบอร์แฟกซ์ เฉพาะผู้ผลิตที่อยู่ประเทศ ญี่ปุ่น พร้อมทั้งชื่อสินค้า และจำนวนที่ขายได้ทั้งหมด หลังจาก 1 มกราคม 2541
SELECT
    s.SupplierID,
    s.CompanyName,
    s.ContactName,
    s.Phone,
    s.Fax,
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalQtyAfter19980101
FROM Suppliers s
JOIN Products p         ON p.SupplierID = s.SupplierID
JOIN [Order Details] od ON od.ProductID = p.ProductID
JOIN Orders o           ON o.OrderID = od.OrderID
WHERE s.Country = 'Japan'
  AND o.OrderDate > '1998-01-01'
GROUP BY s.SupplierID, s.CompanyName, s.ContactName, s.Phone, s.Fax, p.ProductID, p.ProductName
ORDER BY CompanyName, ProductName;

-- 17.  แสดงชื่อบริษัทขนส่งสินค้า เบอร์โทรศัพท์ จำนวนรายการสั่งซื้อที่ส่งของไปเฉพาะรายการที่ส่งไปให้ลูกค้า ประเทศ USA และ Canada แสดงค่าขนส่งโดยรวมด้วย
SELECT
    sh.ShipperID,
    sh.CompanyName AS ShipperCompany,
    sh.Phone,
    COUNT(o.OrderID) AS OrdersToUS_CA,
    CAST(SUM(o.Freight) AS DECIMAL(18,4)) AS TotalFreight
FROM Shippers sh
JOIN Orders o ON o.ShipVia = sh.ShipperID
WHERE o.ShipCountry IN ('USA', 'Canada')
GROUP BY sh.ShipperID, sh.CompanyName, sh.Phone
ORDER BY OrdersToUS_CA DESC, ShipperCompany;

-- 18.  ต้องการข้อมูลรายชื่อบริษัทลูกค้า ชื่อผู้ติดต่อ เบอร์โทรศัพท์ เบอร์แฟกซ์ ของลูกค้าที่ซื้อสินค้าประเภท Seafood แสดงเฉพาะลูกค้าที่มีเบอร์แฟกซ์เท่านั้น
SELECT DISTINCT
    cu.CustomerID,
    cu.CompanyName,
    cu.ContactName,
    cu.Phone,
    cu.Fax
FROM Customers cu
JOIN Orders o           ON o.CustomerID = cu.CustomerID
JOIN [Order Details] od ON od.OrderID = o.OrderID
JOIN Products p         ON p.ProductID = od.ProductID
JOIN Categories c       ON c.CategoryID = p.CategoryID
WHERE c.CategoryName = 'Seafood'
  AND cu.Fax IS NOT NULL
ORDER BY cu.CompanyName;

-- 19.  จงแสดงชื่อเต็มของพนักงาน  วันเริ่มงาน (รูปแบบ 105) อายุงานเป็นปี เป็นเดือน ยอดขายรวม เฉพาะสินค้าประเภท Condiment ในปี 2540
WITH tenure AS (
  SELECT
      e.EmployeeID,
      e.FirstName + ' ' + e.LastName AS EmployeeName,
      e.HireDate,
      DATEDIFF(MONTH, e.HireDate, GETDATE()) AS TenureMonths
  FROM Employees e
),
sales97 AS (
  SELECT
      o.EmployeeID,
      SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS CondimentsSales97
  FROM Orders o
  JOIN [Order Details] od ON od.OrderID = o.OrderID
  JOIN Products p         ON p.ProductID = od.ProductID
  JOIN Categories c       ON c.CategoryID = p.CategoryID
  WHERE c.CategoryName = 'Condiments'
    AND o.OrderDate >= '1997-01-01' AND o.OrderDate < '1998-01-01'
  GROUP BY o.EmployeeID
)
SELECT
    t.EmployeeID,
    t.EmployeeName,
    CONVERT(varchar(10), t.HireDate, 105) AS HireDate_105,
    (t.TenureMonths / 12) AS TenureYears,
    (t.TenureMonths - (t.TenureMonths / 12)*12) AS TenureRemainMonths,
    CAST(ISNULL(s.CondimentsSales97, 0) AS DECIMAL(18,4)) AS CondimentsSales_1997
FROM tenure t
LEFT JOIN sales97 s ON s.EmployeeID = t.EmployeeID
ORDER BY CondimentsSales_1997 DESC, t.EmployeeName;

-- 20.  จงแสดงหมายเลขใบสั่งซื้อ  วันที่สั่งซื้อ(รูปแบบ 105) ยอดขายรวมทั้งหมด ในแต่ละใบสั่งซื้อ โดยแสดงเฉพาะ ใบสั่งซื้อที่มียอดจำหน่ายสูงสุด 10 อันดับแรก
WITH per_order AS (
  SELECT
      o.OrderID,
      o.OrderDate,
      SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS OrderTotal
  FROM Orders o
  JOIN [Order Details] od ON od.OrderID = o.OrderID
  GROUP BY o.OrderID, o.OrderDate
)
SELECT TOP 10
    OrderID,
    CONVERT(varchar(10), OrderDate, 105) AS OrderDate_105,
    CAST(OrderTotal AS DECIMAL(18,4)) AS OrderTotal
FROM per_order
ORDER BY OrderTotal DESC, OrderID;

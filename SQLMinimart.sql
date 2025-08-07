1. สินค้าที่มีราคา 15 บาท
SELECT * FROM Products
WHERE UnitPrice = 15;

2. สินค้าที่มีจำนวนคงเหลือในสต๊อกต่ำกว่า 250
SELECT * FROM Products
WHERE UnitsInStock < 250;

3. รหัสสินค้า ชื่อสินค้าที่เลิกจำหน่ายแล้ว
SELECT ProductID, ProductName
FROM Products
WHERE Discontinued = 1;

4. รหัสสินค้า ชื่อสินค้า ราคา ของสินค้าที่มีราคามากกว่า 100
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice > 100;

5. รหัสสินค้า และราคาของยางลบ
SELECT ProductID, UnitPrice
FROM Products
WHERE ProductName LIKE '%ยางลบ%';

6. หมายเลขใบเสร็จ วันที่ และราคารวม ของใบเสร็จที่ออกก่อนวันที่ 15 ก.พ.
SELECT OrderID, OrderDate, TotalAmount
FROM Orders
WHERE OrderDate < '2025-02-15';

7. รหัสสินค้า ชื่อสินค้า ที่มีจำนวนคงเหลือตั้งแต่ 400 ขึ้นไป
SELECT ProductID, ProductName
FROM Products
WHERE UnitsInStock >= 400;

8. รหัสสินค้า ชื่อสินค้า ราคา และ จำนวนคงเหลือ ของแชมพู, แป้งเด็ก, ดินสอ, ยางลบ
SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE ProductName LIKE '%แชมพู%' 
   OR ProductName LIKE '%แป้งเด็ก%' 
   OR ProductName LIKE '%ดินสอ%' 
   OR ProductName LIKE '%ยางลบ%';

9. รายละเอียดของสินค้าประเภทเครื่องเขียน
SELECT *
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'เครื่องเขียน';

10. รหัสประเภทสินค้า ชื่อประเภท และรายละเอียดของ สินค้าประเภทเครื่องสำอาง
SELECT c.CategoryID, c.CategoryName, c.Description
FROM Categories c
WHERE c.CategoryName = 'เครื่องสำอาง';

11. คำนำหน้า ชื่อ นามสกุล ของพนักงานที่เป็น Sale Representative
SELECT TitleOfCourtesy, FirstName, LastName
FROM Employees
WHERE Title = 'Sales Representative';

12. รหัสพนักงาน ชื่อพนักงาน ชื่อผู้ใช้ รหัสผ่าน ของพนักงานทุกคน
SELECT EmployeeID, FirstName, LastName, Username, Password
FROM Employees;

13. ชื่อผู้ใช้ และรหัสผ่านของพนักงานที่ชื่อก้องนิรันดร์
SELECT Username, Password
FROM Employees
WHERE FirstName = 'ก้องนิรันดร์';

14. รหัสพนักงานที่ออกใบเสร็จหมายเลข 3
SELECT EmployeeID
FROM Orders
WHERE OrderID = 3;

15. รหัสสินค้า ชื่อสินค้า ราคา ของสินค้าที่มีรหัสประเภท 2, 4
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE CategoryID IN (2, 4);

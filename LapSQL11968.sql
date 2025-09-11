select = from Employees
where Title = (Select title
from Employees
where FirstName = 'nancy');

--ต้องการซื้อนามสกุลพนักงานที่มีอายุมากที่สุด
select Firstname, Lastname FROM Employees
where BirthDate = (select min(BirthDate)from Employees);

--ต้องการซื้อสินค้าที่มีราคามากกว่าสินค้าซื้อ Ikura
select Productname from Products
where UnitPrice > (select unitprice from Products
                  where ProductName = 'Ikura')

--ต้องการชื่อบริษัทลูกค้าที่อยู่เมืองเดียวกับบริษัทชื่อ Around the Horn
SELECT Companyname from Customers
where city = (select city from customers
              where companyname = 'Around the horn')

--ต้องการชื่อนามสกุลพนักงานทราเข้างานคนล่าสุด
select Firstname, lastname from Employees
where HireDate = (select max(HireDate) from Employees)  

--ข้อมูลใบสั่งซื้อที่ถูกส่งไปประเทษที่ไม่มีผู้ผลิตสินค้าตั้งอยู่
SELECT * from Orders
where ShipCountry not in (select distinct country from suppliers)

--การใส่ตัวเลขลําดับ
--ต้องการข้อมูลสินค้าที่ราคาน้อยกว่า 50$
SELECT ROW_NUMBER() over (order by unitprice desc) AS RowNum,
Productname , unitprice
from Products
where unitprice < 50

--คําสั่ง DRL
SELECT * from Shippers

--ตาราง มี pk เป็น autoincrement
Insert into Shippers
VALUES ('บริษัทขนเยอะจํากัด','081-123456789')

insert into shippers(CompanyName)
values('บริษัทขนมหาศาลจํากัด')

select * from Employees
--ต้องการข้อมูล รหัสและชื่อพนักงาน และรหัสและชื่อหัวหน้าพนักงาน
SELECT
    emp.EmployeeID,
    emp.FirstName AS [ชื่อพนักงาน],
    boss.EmployeeID,
    boss.FirstName AS [ชื่อหัวหน้า]
FROM Employees AS emp
JOIN Employees AS boss
    ON emp.ReportsTo = boss.EmployeeID;

SELECT * from Customers
--ตารางที่มี px เป็น char

insert into Customers(CustomerID,CompanyName)
VALUES ('A0001','บริษัทซื้อเยอะจํากัด')

--จงเพิ่มข้อมูลพนักงาน 1 คน (ใส่ข้อมูลเท่าที่มี)
insert into Employees(FirstName,LastName)
VALUES ('วุ้นเส้น','เขมรสกุล')

SELECT * from Employees

--จงเพิ่มสินค้า ปลาแดกบอง ราคา 1.5$ จํานวน 12
INSERT into Products(ProductName,UnitPrice,UnitsInStock);
VALUES('ปลาแดกบอง',1.5,12)

SELECT * from Products

--ปรับปรุงเบอร์โทรศัพท์ ของบริษทขนส่ง รหัส 6
UPDATE Shippers
set Phone = '085-99998989'
where ShipperID = 6

--ปรับปรุงจํานวนสินค้าคงเหลือสินค้ารหัส 1 เพิ่มจํานวนเข้าไป 100 ชิ้น
UPDATE Products
set UnitsInStock = UnitsInStock+100
where ProductID = 1

SELECT * from Products

--ปรับปรุง เมือง และประเทศลูกค้า รหัส A0001 ให้เป็น อุดรธานี, thialand
UPDATE Customers
set City = 'อุดรธานี',Country = 'Thailand'
where CustomerID = 'A0001'

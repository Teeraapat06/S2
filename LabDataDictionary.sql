-- Create database zoo
-- DROP database zoo

-- SELECT * from sysdatabases

-- CREATE TABLE type (
--     TypeID CHAR(3) NOT NULL,
--     Tname Varchar(50) NOT NULL,
--     PRIMARY KEY(TypeID)
-- );

-- SELECT name, collation_name
-- FROM sys.databases
-- WHERE name = 'zoo';

-- alter Database zoo Collate Thai_CI_AS

-- INSERT INTO "Type" VALUES ('A01', 'สัตว์บก');
-- INSERT INTO "Type" VALUES ('A02', 'สัตว์มีปีก');

-- select * from "Type"

-- CREATE TABLE Animal (
--     AID CHAR(4) NOT NULL,
--     AName Varchar(50) NOT NULL,
--     Descriptions Varchar(255) NOT NULL,
--     QTY INTEGER IDENTITY(1,1),
--     TypeID Char(3),
--     PRIMARY KEY(AID),
--     FOREIGN KEY(TypeID) REFERENCES Type(TypeID)
-- );

-- //-----------------------------------------------------------------------------------

Create database ZooDB

CREATE TABLE AnimalType (
    animal_type_id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    type_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(max) NULL,
);

CREATE TABLE SpeciesInfo (
    species_info_id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    common_name NVARCHAR(100) NOT NULL,
    scientific_name NVARCHAR(100) NULL,
    habitat NVARCHAR(max) NULL,
    diet NVARCHAR(max) NULL,
    conservation_status NVARCHAR(max) NULL,
    description NVARCHAR(max) NULL,
);

CREATE TABLE Enclosure (
    enclosure_id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    location NVARCHAR(200) NULL,
);

CREATE TABLE Keeper (
    keeper_id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(50) NULL,
    email NVARCHAR(100) NULL,
);

CREATE TABLE EnclosureKeeper (
    enclosure_id INT NOT NULL,
    keeper_id INT NOT NULL,
    PRIMARY KEY (enclosure_id, keeper_id),
    FOREIGN KEY (enclosure_id) REFERENCES Enclosure(enclosure_id),
    FOREIGN KEY (keeper_id) REFERENCES Keeper(keeper_id)
);

CREATE TABLE Food (
    food_id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    type NVARCHAR(100) NULL,
    unit NVARCHAR(50) NULL,
);

CREATE TABLE Animal (
    animal_id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    gender NVARCHAR(10) NULL,
    birth_date DATE NULL,
    enclosure_id INT NULL,
    animal_type_id INT NULL,
    species_info_id INT NULL,
    FOREIGN KEY (enclosure_id) REFERENCES Enclosure(enclosure_id),
    FOREIGN KEY (animal_type_id) REFERENCES AnimalType(animal_type_id),
    FOREIGN KEY (species_info_id) REFERENCES SpeciesInfo(species_info_id)
);

CREATE TABLE FeedingSchedule (
    feeding_id INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    animal_id INT NOT NULL,
    food_id INT NOT NULL,
    amount DECIMAL(10,2) NULL,
    feeding_date DATE NULL,
    feeding_time TIME NULL,
    keeper_id INT NULL,
    FOREIGN KEY (animal_id) REFERENCES Animal(animal_id),
    FOREIGN KEY (food_id) REFERENCES Food(food_id),
    FOREIGN KEY (keeper_id) REFERENCES Keeper(keeper_id)
);

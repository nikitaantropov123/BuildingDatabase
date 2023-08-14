                                     
                                            /* Light and Sound Company (LSC) Database */

CREATE DATABASE LSC

GO

USE LSC

GO
            
CREATE TABLE Categories
(
    CategoryID INT IDENTITY (1,1) NOT NUll,
    CategoryName VARCHAR(20) NOT NULL,
    CategotyDescription VARCHAR(100),
    CONSTRAINT cat_ID_PK PRIMARY KEY(CategoryID),
    CONSTRAINT cat_name_UK UNIQUE(CategoryName)
)

GO

CREATE TABLE SalesManagers
(
    ManagerID INT IDENTITY (1,1),
    DepID INT,
    FirstName VARCHAR(15),
    LastName VARCHAR(20) NOT NULL,
    BirthDate DATE,
    HireDate DATE,
    Email VARCHAR(20)
    CONSTRAINT sm_id_PK PRIMARY KEY(ManagerID),
    CONSTRAINT sm_email_UK UNIQUE(Email),
)

GO 

CREATE TABLE Departments
(
    DepID INT IDENTITY (1,1),
    DepName VARCHAR(20) NOT NULL,
    DepDesc VARCHAR(100)
    CONSTRAINT deps_id_PK PRIMARY KEY(DepID),
)

GO

CREATE TABLE Suppliers
(
    SupplierID INT IDENTITY (1,1),
    SupplierName VARCHAR(20) NOT NULL,
    SupplierDesc VARCHAR(100)
    CONSTRAINT sup_id_PK PRIMARY KEY(SupplierID),
)

GO

CREATE TABLE Customers
(
    CustomerID INT IDENTITY (10323,1),
    CustomerName VARCHAR(30),
    WorkEmail VARCHAR(30) NOT NULL,
    Address VARCHAR(50) NOT NULL,
    Company VARCHAR(20),
    CONSTRAINT cus_id_PK PRIMARY KEY(CustomerID),
    CONSTRAINT cus_email_UK UNIQUE(WorkEmail)
)

GO

CREATE TABLE Products
(
    ProductID INT IDENTITY (1,1) NOT NUll,
    ProductName VARCHAR(20) NOT NULL,
    Description VARCHAR(100),
    CategoryID INT,
    ProductPrice MONEY NOT NULL,
    SupplierID INT,
    CONSTRAINT pro_ID_PK PRIMARY KEY(ProductID),
    CONSTRAINT pro_sup_FK FOREIGN KEY(SupplierID) REFERENCES Suppliers(SupplierID),
    CONSTRAINT pro_catid_FK FOREIGN KEY(CategoryID) REFERENCES Categories(CategoryID)
)

GO 

CREATE TABLE Orders
(
    OrderID INT IDENTITY (23444,1),
    CustomerID INT NOT NULL, 
    ManagerID INT NOT NULL,
    ProductID INT,
    ProductQnty INT,
    TotalDue INT NOT NULL,
    ShipAddress VARCHAR(50)
    CONSTRAINT ord_ID_PK PRIMARY KEY(OrderID),
    CONSTRAINT ord_cusID_FK FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT ord_manID_FK FOREIGN KEY(ManagerID) REFERENCES SalesManagers(ManagerID),
    CONSTRAINT ord_proID_FK FOREIGN KEY(ProductID) REFERENCES Products(ProductID)
)

GO 

INSERT INTO Categories
    VALUES ('Speakers', 'Best speakers for big shows'),
            ('Headphones', 'High quality monitor headphones'),
            ('Mixers', 'All kinds of the best mixers ever sold'), 
            ('Midi Controllers', 'Midi controllers of all kind'),
            ('Cabels', 'Professional touring cables'),
            ('Studio Monitors', 'Best refenrence monitors'),
            ('Audio Interfaces', 'Audiophile Interfaces')

GO

INSERT INTO SalesManagers 
    VALUES (1,'Walter','White', '1967-02-17', GETDATE(),('whitew@gmail.com')),
            (3,'Skyler','White', '1970-04-10', GETDATE(),('whites@gmail.com')),
            (2,'Saul', 'Goodman', '1966-01-12', GETDATE(),('goodmans@gmail.com')),
            (4, 'Michael', 'Ermentraut', '1955-01-03', GETDATE(),('erment@gmail.com')),
            (4, 'Gustavo', 'Fring', '1970-05-15', GETDATE(),'fring@gmail.com'),
            (1, 'Hank', 'Shrader', '1966-11-30', GETDATE(), 'shrader@gmail.com')

GO

INSERT INTO Departments
    VALUES  ('Stage Sound', 'Professional stage sound'),
            ('Home Studio', 'Home studio solutions'),
            ('Instalations', 'Solutions for instalations'),
            ('Festivals', 'Solutions for festivals')

GO

INSERT INTO Suppliers (SupplierName)
    VALUES ('Behringer'),
           ('Cabletech'),
           ('AKAI'),
           ('M-Audio'),
           ('Midas'),
           ('Ultrasone'),
           ('Tannoy'),
           ('Martin Audio'),
           ('BeerDynamics'),
           ('KRK Systems')

GO 

INSERT INTO Customers
    VALUES ('James Hatfield', 'voc.inc@gmail.com','Exit Light St, 80', 'Metallica LTD'),
           ('Lars Ulrich', 'drum.inc@gmail.com','Exit Light St, 80', 'Metallica LTD'),
           ('Kirk Hammet', 'guit.inc@gmail.com','Exit Light St, 80', 'Metallica LTD'),
           ('Robert Trujillo', 'bass.inc@gmail.com','Exit Light St, 80', 'Metallica LTD'),
           ('Zion Malka', 'bahoortov@gmail.com','Tzomet Kiryat Ata, 4', 'Morgan LTD'),
           ('Itzik Zino', 'bahoor.lo.tov@gmail.com','Tzomet Kiryat Ata, 4', 'Morgan LTD'),
           ('Egor Varyanik', 'e.varyanik@gmail.com', 'Monteefiore, 20', 'Monkey INC'),
           ('Vlad Busel', 'ngc606@gmail.com','HaGalil, 2', 'Dobryachok LTD'),
           ('Dmitriy Cherniak','kusokpiroga228@gmail.com','HaGalil, 2','MicroChell INC'),
           ('Volodimyr Zelenskiyy', 'zelya@ukr.net', 'Verhovna Rada', 'Hto Ya 228 LTD'),
           ('Carlos Pisuhin', 'redmix@gmail.com', 'Levi Eshkol 196', 'KingCarlos INC')

GO

INSERT INTO Products 
    VALUES  ('K10',     'Active Subwoofer',  1, '2000', 1),
            ('S18a',    'Passsive Subwoofer',1, '5000', 1),
            ('2.8',     'Active Subwoofer',  1, '2500', 8), 
            ('B2031a',  'Monitors',          6, '600', 1), 
            ('KRK5',    'Monitors',          6, '700', 10),
            ('i900',    'Monitor Headphones',2, '1950', 7),
            ('dt 900',  'Monitor Headphones',2, '1700', 10),
            ('M12',     'Top Speakers',      1, '2200', 6),
            ('X15',     'Top Speakers',      1, '2500', 9),
            ('DR112',   'Top Speakers',      1, '2000', 1),
            ('XX10',    'XLR-XLR Cable',     5, '10', 2),
            ('XFP10',   'XLR-PL Cable',      5, '10', 2),
            ('SPK10',   'Speakon Cable',     5, '10', 2),
            ('UMC1820', 'Pro Audio Interface',7, '1000', 1),
            ('UMC204',  'Pro Audio Interface',7, '300', 1),
            ('MPK2',    'Mini Midi Controller',4, '450', 3),
            ('AXIOM25', 'Midi Controller',     4, '350', 4),
            ('X32',      'Digital Mixer',      3, '15000', 1),
            ('QX1204USB','Analog Mixer',       3, '700', 1),
            ('Heritage', 'Digital Mixer',      3, '23000', 5) 

GO

INSERT INTO Orders
    VALUES (10323,2,2,2,10000,'Histadrut 2, Petah Tikva'),
           (10329,1,18,1,15000,'Kaplan 44, Tel Aviv'),
           (10333,5,10,10,20000,'KFC, Jenin'),
           (10323,3,3,1,2500,'Burger King, Jenin'),
           (10333,5,10,10,20000,'Exit Light 22, LA'),
           (10330,6,16,2,900,'Rav Kuk 23, Zfat'),
           (10332,3,5,2,1400,'Verhovna Rada 1, Kyiv'),
           (10327,2,8,2,4400,'Beni Berman 112, Arad'),
           (10325,1,3,1,2500,'Montefiore 21, Bnei Brak'),
           (10331,4,20,2,46000,'Rozenshtrasse 87, Kenigsberg'),
           (10324,5,17,1,350,'Kfar HaYarok 1, Tel Aviv'),
           (10329,2,11,100,1000,'Sheikh Abdulla 666, Teheran'),
           (10333,2,14,1,1000,'Al Nasser 4, Kabul'),
           (10327,6,6,15,29250,'Bing Chiling, Bejiing'),
           (10332,2,11,100,1000,'Putin Loh 228, Rostov')

/* Made by Nikita Antropov */
create database TaxiStationFinalProject;
use TaxiStationFinalProject;

create table Address(
address_ID int NOT NULL,
street_name char(25),
street_num int,
city_name char(25),
phone_num int,
zip_code int,
primary key (address_ID)
)engine=InnoDB;

create table TaxiOwner(
owner_ID int NOT NULL,
owner_name char(25) NOT NULL,
primary key (owner_ID)
)engine = InnoDB;

create table TaxiStation(
station_ID int NOT NULL,
address_ID int NOT NULL,
primary key (station_ID),
foreign key (address_ID) references Address(address_ID),
foreign key (station_ID) references TaxiOwner(owner_ID)
)engine = innoDB;

create table Driver(
driver_ID int NOT NULL,
lisence_num int NOT NULL,
driver_name char(25),
DoB date,
primary key (driver_ID, lisence_num)
)engine = InnoDB;

create table RentCompany(
company_ID int NOT NULL,
company_name char(25),
rent_customer_ID int,
address_ID int,
numOfRentCars int,
costOfAllRents int,
rent_date date,
primary key (Company_ID),
foreign key (rent_customer_ID) references TaxiStation(station_ID),
foreign key (company_ID) references TaxiOwner(owner_ID),
foreign key (address_ID) references Address(Address_ID)
)engine = InnoDB;

create table Taxi(
taxi_ID int NOT NULL,
owner_ID int NOT NULL,
model char(25),
company char(25),
primary key (taxi_ID, owner_ID),
CONSTRAINT fk_Update_cascade
foreign key (owner_ID) references TaxiOwner(owner_ID)
ON update CASCADE
)engine = InnoDB;

create table Driver_Taxi(
pair_ID int NOT NULL,
driver_ID int NOT NULL,
taxi_ID int NOT NULL,
primary key (pair_ID),
foreign key (driver_ID) references driver(driver_ID),
foreign key (taxi_ID) references taxi(taxi_ID)
)engine = InnoDB;

create table Customer(
customer_ID int NOT NULL,
customer_name char(25) NOT NULL,
DoB date,
primary key (customer_ID)
)engine = innoDB;

create table TripOrder(
station_ID int NOT NULL,
order_ID int NOT NULL auto_increment,
address_Source_ID int,
address_Destination_ID int,
timeOfTravel int,
numOfKM int,
driver_taxi_ID int NOT NULL,
cost int,
primary key (order_ID),
foreign key (station_ID) references taxiStation(station_ID),
foreign key (address_Source_ID) references address(address_ID),
foreign key (address_Destination_ID) references address(address_ID),
foreign key (driver_taxi_ID) references Driver_Taxi(pair_ID)
)engine = InnoDB;

create table Payment(
order_ID int NOT NULL,
costByDay int,
costByNight int,
paymentMethod char(15),
primary key (order_ID),
constraint fk_tripOrder
foreign key (order_ID) references tripOrder(order_ID)
ON delete CASCADE
)engine = InnoDB;

create table Customer_Order(
customer_ID int NOT NULL,
order_ID int NOT NULL,
foreign key (customer_ID) references customer(customer_ID),
CONSTRAINT fk_UpdateOrder_cascade
foreign key (order_ID) references tripOrder(order_ID)
ON update CASCADE
)engine = InnoDB;

INSERT INTO Address VALUES
(300,'Ben Gurion',27,'Tel Aviv',0527342149,123000),
(301,'Herzel',1,'Rishon Lezion',0547766801,556700),
(302,'Haim Weizman',77,'Yehud',0587941212,303001),
(303,'Zeev Jabotinsky',56,'Petah Tikva',036352417,477000),
(304,'Hagfanim',30,'Kiryat Ono',0,476000),
(305,'Igal Alon',14,'Tel Aviv', 0,321400),
(306,'Menahem Begin',132,'Kiryat Ono',0,545010),
(307,'Hacarmel',56,'Petah Tikva',0,143360),
(308,'Hacalanit',56,'Kiryat Ono',0,555700),
(309,'Sokolov',56,'Herzelia',0,239070),
(310,'Levi Eshkol',115,'Kiryat Ono',035356871,669000);

INSERT INTO TaxiOwner VALUES
(1000,'taxi station'),
(700,'exclusive cars'),
(701,'champions'),
(702,'fast and furious'),
(703,'cabs to rent');

INSERT INTO TaxiStation VALUES
(1000, 310);

INSERT INTO Driver VALUES
(100,200,'Eyal Cohen', '1978-02-01'),
(101,201,'Doron Kavalio', '1980-04-13'),
(102,202,'Israel Katorza', '1960-07-08'),
(103,203,'Menahem Levi', '1967-07-12');

INSERT INTO RentCompany VALUES
(700,'exclusive cars',1000,300,4,20000, '2005-01-01'),
(701,'champions',1000,301,2,25000, '2007-5-12'),
(702,'fast and furious',1000,302,1,5700, '2008-10-14'),
(703,'cabs to rent',1000,303,3,35000, '2002-12-02');

INSERT INTO Taxi VALUES
(500, 1000, 'corolla','Toyota'), 
(501, 1000, 'corolla','Toyota'), 
(502, 700, 'B-class','Mercedes'), 
(503, 700, 'C-class','Mercedes'), 
(504, 700, 'C-class','Mercedes'), 
(505, 700, 'A-class','Mercedes'), 
(506, 701, 'Rio','Kaia'), 
(507, 701, 'Forte','Kaia'), 
(508, 702, 'Octavia','Skoda'), 
(509, 703, 'Rapid','Skoda'), 
(510, 703, 'GT-350','Lamborgini'), 
(511, 703, 'S-8','Audi');

INSERT INTO Customer VALUES
(80, 'Ronen Badash', '1990-01-07'),
(81, 'Itay Bell', '1989-07-06'),
(82, 'Lior Shir', '1985-03-01'),
(83, 'Nir Shemesh', '1992-12-22'),
(84, 'Liad Nahum', '1996-06-13');

INSERT INTO TripOrder VALUES
(1000, 1, 304, 305, 30, 20, 100,70), #day
(1000, 2, 304, 306, 7, 5, 101, 25), #night
(1000, 3, 306, 309, 30, 25, 101,65), #day
(1000, 4, 304, 307, 25, 22, 102, 100),#night
(1000, 5, 306, 307, 15, 10, 103, 50),#day
(1000, 6, 308, 309, 30, 20, 103,70);#day

INSERT INTO Payment VALUES
(1, 70, 0, 'Credit Card'),
(2, 0, 25, 'Cash'),
(3, 65, 0, 'cash'),
(4, 0, 100, 'Credit Card'),
(5, 50, 0, 'Cash'),
(6, 70, 0, 'Cash');

INSERT INTO Customer_Order VALUES
(80, 1),
(81, 2),
(82, 3), 
(80, 4),
(84, 5),
(83, 6);

INSERT INTO Driver_Taxi VALUES
(100, 500),
(100, 511),
(101, 504),
(102, 505),
(102, 510),
(103, 506),
(103, 510),
(103, 501);


use TaxiStationFinalProject;

#Queries for user - manager:
#1 retrive total information on trip-bookings.
select count(TripOrder.order_ID) as sumOfBookings, sum(TripOrder.cost) as sumOfErnings, sum(TripOrder.numOfKM) as totalKM
from TripOrder;


#2 retrive driver information who ride on specific vehicle.
SELECT d.*
from Driver as d join Driver_Taxi as tx
on(d.driver_ID = tx.driver_ID)
where tx.taxi_ID Like '510';

#3 retrieve the maximum  and minimum pay for the rent company.
select max(costOfAllRents), min(costOfAllRents)
from RentCompany
where (rent_date > '2003-01-01');

#4 retrive all drivers that were late at least once.
SELECT d.*, o.*
from TripOrder as o join driver as d join Driver_Taxi as dt
on(o.driver_ID = d.driver_ID) and (d.driver_ID = dt.driver_ID)
group by o.driver_ID 
having (o.timeOfTravel >= 15)
order by (o.order_ID);

#5
select  order_ID, costByDay
from payment
where (costByDay > 0) and costByDay < all
(select costByNight
 from payment
 where costByNight in (50,100))
 order by costByDay;

#6 retrive all viechls and their driver that been used more then twice.
SELECT tx.taxi_ID, d.*
from Driver as d join Driver_Taxi as tx
on(d.driver_ID = tx.driver_ID)
group by tx.taxi_ID
having tx.taxi_ID > 2
order by tx.taxi_ID;


#Queries for user - customer:
#1 retrive order information by customer id.
select c.customer_name, o.*
from customer as c join customer_order as co join triporder as o 
on (c.customer_ID = co.customer_ID) and (co.order_ID = o.order_ID)
where c.customer_name like ('Nir Shemesh');


#2 retrive driver information to complaint about the long drive , via order-ID.
select c.customer_name, a.city_name, o.cost, d.driver_name, d.driver_ID
from customer as c join customer_order as co join triporder as o join driver as d join address as a
on (c.customer_ID = co.customer_ID) and (co.order_ID = o.order_ID) and (o.driver_ID = d.driver_ID) and (o.address_Source_ID = a.address_ID)
where o.order_ID like 6;

#3 retrive the avarge time for a drive and and avrage cost for specific destination.
select a.city_name, avg(o.timeOfTravel), avg(o.cost)
from customer as c join customer_order as co join triporder as o join Address as a
on (c.customer_ID = co.customer_ID) and (co.order_ID = o.order_ID) and (o.address_Destination_ID = a.address_ID)
group by a.city_name
having a.city_name like 'Kiryat Ono';

#4 retrive total payment for the taxi station.
select c.customer_name, sum(o.cost)
from customer as c join customer_order as co join triporder as o 
on (c.customer_ID = co.customer_ID) and (co.order_ID = o.order_ID)
group by c.customer_ID having c.customer_name = 'Ronen Badash';

#5 retrive customer name who paid by credit card
select distinct c.customer_name
from customer as c join customer_order as co join triporder as o join Payment as p
on (c.customer_ID = co.customer_ID) and (co.order_ID = o.order_ID) and (o.order_ID = p.order_ID)
where p.paymentMethod like 'Credit Card';

#6 retrive cost per KM for trip taken place at day time, with minimum fee.
select (cost / numOfKM) as costPerKM
from triporder as o  join payment as p  
on (o.order_ID = p.order_ID)
where (costByDay > 0) and costByDay > any
(select costByDay
 from payment
 where costByDay in (50,65))
 order by costByDay; 

#Triggers
delimiter $
CREATE TRIGGER deleteTaxi
after delete
    on Taxi
    FOR each row 
    begin 
    insert into taxi_log values(old.taxi_ID, old.owner_ID, old.model, old.company, now(), 'delete');
    end $

delimiter $
CREATE TRIGGER updateNumOfCars
after insert
on RentCompany 
for each row
begin
insert into company_log values(new.company_ID,new.company_name,new.rent_customer_ID, new.address_ID, new.numOfRentCars, new.costOfAllRents, new.rent_date, now(), 'insert');
end $

-- Ćwiczenie 1
-- 1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz
-- nazwę klienta.

select sum(Quantity),CompanyName
from orders o
    join [Order Details] od
        on o.OrderID=od.OrderID
    join Customers c 
        on o.CustomerID=c.CustomerID
group by CompanyName, od.OrderID

select *
from [Order Details]


-- 2. Dla każdego zamówienia podaj łączną wartość zamówionych produktów (wartość
-- zamówienia bez opłaty za przesyłkę) oraz nazwę klienta.

select od.Orderid, sum(Quantity*UnitPrice*(1-Discount)) koszt,CompanyName
from orders o
    join [Order Details] od
        on o.OrderID=od.OrderID
    join Customers c 
        on o.CustomerID=c.CustomerID
group by od.OrderID,CompanyName

-- 3. Dla każdego zamówienia podaj łączną wartość tego zamówienia (wartość
-- zamówienia wraz z opłatą za przesyłkę) oraz nazwę klienta.

select od.Orderid, sum(Quantity*UnitPrice*(1-Discount))+o.Freight koszt,CompanyName
from orders o
    join [Order Details] od
        on o.OrderID=od.OrderID
    join Customers c 
        on o.CustomerID=c.CustomerID
group by od.OrderID,o.Freight,CompanyName
order by 2

-- WAZNE FREIGHT JEST POZA SUMA !

-- 4. Zmodyfikuj poprzednie przykłady tak żeby dodać jeszcze imię i nazwisko pracownika
-- obsługującego zamówień

select sum(Quantity),CompanyName, e.FirstName +' '+e.LastName pracownik
from orders o
    join [Order Details] od
        on o.OrderID=od.OrderID
    join Customers c 
        on o.CustomerID=c.CustomerID
    join Employees e 
        on o.EmployeeID=e.EmployeeID
group by CompanyName, od.OrderID,e.EmployeeID,e.FirstName +' '+e.LastName


select od.Orderid, sum(Quantity*UnitPrice*(1-Discount)) koszt,CompanyName,e.FirstName +' '+e.LastName pracownik
from orders o
    join [Order Details] od
        on o.OrderID=od.OrderID
    join Customers c 
        on o.CustomerID=c.CustomerID
    join Employees e 
        on o.EmployeeID=e.EmployeeID
group by od.OrderID,CompanyName, e.EmployeeID,e.FirstName +' '+e.LastName


select od.Orderid, sum(Quantity*UnitPrice*(1-Discount))+o.Freight koszt,CompanyName, e.FirstName +' '+e.LastName pracownik
from orders o
    join [Order Details] od
        on o.OrderID=od.OrderID
    join Customers c 
        on o.CustomerID=c.CustomerID
    join Employees e 
        on o.EmployeeID=e.EmployeeID
group by od.OrderID,o.Freight,CompanyName,e.EmployeeID,e.FirstName +' '+e.LastName
order by 2

-- Ćwiczenie 2
-- 1. Podaj nazwy przewoźników, którzy w marcu 1998 przewozili produkty z kategorii
-- 'Meat/Poultry'

select distinct s.CompanyName
from [Order Details] od 
    join Products p 
        on od.ProductID=p.ProductID
            join Categories c 
                on p.CategoryID=c.CategoryID
    join orders o 
        on od.OrderID=o.OrderID
            join Shippers s 
                on o.ShipVia=s.ShipperID
where YEAR(o.ShippedDate)=1998 and MONTH(o.ShippedDate)=3 and CategoryName='Meat/Poultry'

-- 2. Podaj nazwy przewoźników, którzy w marcu 1997r nie przewozili produktów z
-- kategorii 'Meat/Poultry'

select CompanyName
from Shippers
EXCEPT
select distinct s.CompanyName
from [Order Details] od 
    join Products p 
        on od.ProductID=p.ProductID
            join Categories c 
                on p.CategoryID=c.CategoryID
    join orders o 
        on od.OrderID=o.OrderID
            join Shippers s 
                on o.ShipVia=s.ShipperID and YEAR(o.ShippedDate)=1997 and MONTH(o.ShippedDate)=3 and CategoryName='Meat/Poultry'


-- 3. Dla każdego przewoźnika podaj wartość produktów z kategorii 'Meat/Poultry' które
-- ten przewoźnik przewiózł w marcu 1997

select s.CompanyName, sum(od.Quantity*od.UnitPrice*(1-Discount))
from [Order Details] od 
    join Products p 
        on od.ProductID=p.ProductID
            join Categories c 
                on p.CategoryID=c.CategoryID
    join orders o 
        on od.OrderID=o.OrderID
            join Shippers s 
                on o.ShipVia=s.ShipperID
where YEAR(o.ShippedDate)=1997 and MONTH(o.ShippedDate)=3 and CategoryName='Meat/Poultry'
group by s.ShipperID, s.CompanyName

/*

Powyzsza opcja lepsza, bo moga byc firmy o tej samej nazwie, lepiej najpierw grupowac po ID.

select s.CompanyName, sum(od.Quantity*od.UnitPrice*(1-Discount))
from [Order Details] od 
    join Products p 
        on od.ProductID=p.ProductID
            join Categories c 
                on p.CategoryID=c.CategoryID
    join orders o 
        on od.OrderID=o.OrderID
            join Shippers s 
                on o.ShipVia=s.ShipperID
where YEAR(o.ShippedDate)=1997 and MONTH(o.ShippedDate)=3 and CategoryName='Meat/Poultry'
group by s.CompanyName
*/


-- Ćwiczenie 3
-- 1. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez
-- klientów jednostek towarów z tej kategorii.

select c.CategoryName, sum(Quantity) 'total products'
from [Order Details] od 
    join Products p 
        on od.ProductID=p.ProductID
            join Categories c 
                on p.CategoryID=c.CategoryID
group by c.CategoryID,c.CategoryName

-- 2. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych w 1997r
-- jednostek towarów z tej kategorii.

select c.CategoryName, sum(Quantity) 'total products'
from [Order Details] od
    join Orders o 
        on od.OrderID=o.OrderID and year(OrderDate)=1997    -- laczymy tylko te ktore sa z 1997
    join Products p 
        on od.ProductID=p.ProductID
            join Categories c 
                on p.CategoryID=c.CategoryID
group by c.CategoryID,c.CategoryName

-- 3. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych przez
-- klientów jednostek towarów z tek kategorii.

select c.CategoryName, round(sum(od.Quantity*od.UnitPrice),2) 
from [Order Details] od
    join Orders o 
        on od.OrderID=o.OrderID
    join Products p 
        on od.ProductID=p.ProductID
            join Categories c 
                on p.CategoryID=c.CategoryID
group by c.CategoryID,c.CategoryName

-- 4. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych towarów z
-- tek kategorii.

select c.CategoryName, round(sum(od.Quantity*od.UnitPrice*(1-od.Discount)),2) 'total price'
from [Order Details] od
    join Orders o 
        on od.OrderID=o.OrderID
    join Products p 
        on od.ProductID=p.ProductID
            join Categories c 
                on p.CategoryID=c.CategoryID
group by c.CategoryID,c.CategoryName

-- Ćwiczenie 4
-- 1. Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r

select s.CompanyName,count(*)
from Orders o 
    join Shippers s 
        on o.ShipVia=s.ShipperID
where year(o.ShippedDate)=1997
group by s.ShipperID,s.CompanyName

-- 2. Który z przewoźników był najaktywniejszy (przewiózł największą liczbę zamówień) w
-- 1997r, podaj nazwę tego przewoźnika

select top 1 s.CompanyName,count(*)
from Orders o 
    join Shippers s 
        on o.ShipVia=s.ShipperID
where year(o.ShippedDate)=1997
group by s.ShipperID,s.CompanyName
order by 2 desc

-- 3. Dla każdego przewoźnika podaj łączną wartość "opłat za przesyłkę" przewożonych
-- przez niego zamówień od '1998-05-03' do '1998-05-29'

select s.CompanyName,sum(Freight)
from Orders o 
    join Shippers s 
        on o.ShipVia=s.ShipperID
where ShippedDate>'1998-05-03'and ShippedDate<'1998-05-29'
group by s.ShipperID,s.CompanyName

-- 4. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika w maju 1996

select e.FirstName,e.LastName, round(sum(od.Quantity*od.UnitPrice*(1-od.Discount)),2)
from Employees e
    left join orders o on o.EmployeeID=e.EmployeeID
        join [Order Details] od on o.OrderID=od.OrderID
where YEAR(o.OrderDate)=1996 and MONTH(o.OrderDate)=5
group by o.EmployeeID, e.FirstName,e.LastName

-- akurat w 1996 nic nie ma

-- 5. Który z pracowników obsłużył największą liczbę zamówień w 1996r, podaj imię i
-- nazwisko takiego pracownika

select top 1 e.FirstName,e.LastName, count(o.OrderID)
from Employees e
    left join orders o on o.EmployeeID=e.EmployeeID
        join [Order Details] od on o.OrderID=od.OrderID
where YEAR(o.OrderDate)=1996
group by o.EmployeeID, e.FirstName,e.LastName
order by 3 desc

-- 6. Który z pracowników był najaktywniejszy (obsłużył zamówienia o największej
-- wartości) w 1996r, podaj imię i nazwisko takiego pracownika

select top 1 e.FirstName,e.LastName, round(sum(od.Quantity*od.UnitPrice*(1-od.Discount)),2)
from Employees e
    left join orders o on o.EmployeeID=e.EmployeeID
        join [Order Details] od on o.OrderID=od.OrderID
where YEAR(o.OrderDate)=1996
group by o.EmployeeID, e.FirstName,e.LastName
order by 3 desc

-- Ćwiczenie 5
-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika

select e.FirstName+' '+e.LastName,sum(od.Quantity*od.UnitPrice*(1-od.Discount))
from [Order Details] od  
    join Orders o 
        on od.OrderID=o.OrderID
            join Employees e 
                on o.EmployeeID=e.EmployeeID
group by e.EmployeeID, e.FirstName+' '+e.LastName

-- Ogranicz wynik tylko do pracowników
-- a) którzy mają podwładnych

select distinct chf.FirstName+' '+chf.LastName, sum(od.Quantity*od.UnitPrice*(1-od.Discount))
from Employees as chf
    join Employees as e on e.ReportsTo=chf.EmployeeID
    join Orders o on chf.EmployeeID=o.EmployeeID
        join [Order Details] od on od.OrderID=o.OrderID
group by e.EmployeeID, chf.FirstName,chf.LastName

-- o wiele przyjemniej podzapytaniem!

select e.FirstName+' '+e.LastName, sum(od.Quantity*od.UnitPrice*(1-od.Discount))
from Employees e
    join Orders o on e.EmployeeID=o.EmployeeID
        join [Order Details] od on od.OrderID=o.OrderID
where e.EmployeeID in (
    select distinct ReportsTo
    from Employees
)
group by e.EmployeeID, e.FirstName,e.LastName


-- kluczowe bylo grupowanie

-- b) którzy nie mają podwładnych, trzeba uzyc excepta.

select e.FirstName+' '+e.LastName,sum(od.Quantity*od.UnitPrice*(1-od.Discount))
from [Order Details] od  
    join Orders o on od.OrderID=o.OrderID
            join Employees e on o.EmployeeID=e.EmployeeID
group by e.EmployeeID, e.FirstName+' '+e.LastName

except

select e.FirstName+' '+e.LastName, sum(od.Quantity*od.UnitPrice*(1-od.Discount))
from Employees e
    join Orders o on e.EmployeeID=o.EmployeeID
        join [Order Details] od on od.OrderID=o.OrderID
where e.EmployeeID in (
    select distinct ReportsTo
    from Employees
)
group by e.EmployeeID, e.FirstName,e.LastName

-- albo 

select distinct chf.FirstName+' '+chf.LastName, sum(od.Quantity*od.UnitPrice*(1-od.Discount))
from Employees as chf
    join Employees as e on e.ReportsTo=chf.EmployeeID
    join Orders o on chf.EmployeeID=o.EmployeeID
        join [Order Details] od on od.OrderID=o.OrderID
group by e.EmployeeID, chf.FirstName,chf.LastName

-- 2. Napisz polecenie, które wyświetla klientów z Francji którzy w 1998r złożyli więcej niż
-- dwa zamówienia oraz klientów z Niemiec którzy w 1997r złożyli więcej niż trzy zamówienia.

select c.CompanyName, c.Country,count(o.OrderID)
from customers c 
    join orders o on o.CustomerID=c.CustomerID
where c.Country='France' and YEAR(o.OrderDate)=1998
group by c.CustomerID,c.CompanyName,c.Country
having count(o.OrderID)>2

union 

select c.CompanyName, c.Country, count(o.OrderID)
from customers c 
    join orders o on o.CustomerID=c.CustomerID
where c.Country='Germany' and YEAR(o.OrderDate)=1997
group by c.CustomerID,c.CompanyName, c.Country
having count(o.OrderID)>3
order by 2
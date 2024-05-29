-- Ćwiczenia 1
-- 1. Dla każdego zamówienia podaj jego wartość. Posortuj wynik wg wartości zamówień
-- (w malejęcej kolejności)

select OrderID, UnitPrice*Quantity*(1-Discount) cost
from [Order Details]
order by cost desc

select *
from [Order Details]

-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało tylko pierwszych 10
-- wierszy

select top 10 OrderID, UnitPrice*Quantity*(1-Discount) cost
from [Order Details]
order by cost desc

-- 3. Podaj nr zamówienia oraz wartość zamówienia, dla zamówień, dla których łączna
-- liczba zamawianych jednostek produktów jest większa niż 250

select OrderID, SUM(UnitPrice*Quantity*(1-Discount)) cost
from [Order Details]
group by OrderID
having sum(Quantity)>250

-- 4. Podaj liczbę zamówionych jednostek produktów dla produktów, dla których
-- productid jest mniejszy niż 3

select SUM(Quantity) 
from [Order Details]
where ProductID<3

-- Ćwiczenie 2
-- 1. Ilu jest dorosłych czytekników

select count(*)
from adult

-- 2. Ile jest dzieci zapisanych do biblioteki

select count(*)
from juvenile

-- 3. Ilu z dorosłych czytelników mieszka w Kaliforni (CA)

select COUNT(*)
from adult
where state='CA'

-- 4. Dla każdego dorosłego czytelnika podaj liczbę jego dzieci.

/*
select a.member_no as 'dorosly czytelnik', count(j.member_no) as 'liczba dzieci'
from adult a left join juvenile j 
on a.member_no=j.adult_member_no
group by a.member_no
order by [liczba dzieci] desc
*/

select adult_member_no, count(member_no)
from juvenile
group by adult_member_no

-- 5. Dla każdego dorosłego czytelnika podaj liczbę jego dzieci urodzonych przed 1998r

/*
select a.member_no as 'dorosly czytelnik', count(j.member_no) as 'liczba dzieci przed 1998'
from adult a left join juvenile j 
on a.member_no=j.adult_member_no and YEAR(j.birth_date)<1998
group by a.member_no
order by [liczba dzieci przed 1998] desc
*/

select adult_member_no, count(member_no)
from juvenile
where YEAR(birth_date)<1998
group by adult_member_no

-- Ćwiczenie 3
-- 1. Dla każdego czytelnika podaj liczbę zarezerwowanych przez niego książek

select member_no, count(*) as 'liczba zarezerwowanych ksiazek'
from reservation
group by member_no
order by 2 desc

select member_no, count(isbn) as 'liczba zarezerwowanych ksiazek'
from reservation
group by member_no
order by 2 desc

-- 2. Dla każdego czytelnika podaj liczbę wypożyczonych przez niego książek

select member_no, count(isbn)
from loan
group by member_no  
order by 2 desc

-- 3. Dla każdego czytelnika podaj liczbę książek zwróconych przez niego w 2001r.

select member_no, COUNT(isbn) as 'liczba ksiazek zwroconych w 2001r.'
from loanhist
where YEAR(in_date)=2001
group by member_no
order by 2 desc

-- 4. Dla każdego czytelnika podaj sumę kar jakie zapłacił w 2001r

select member_no, ISNULL(fine_paid,0)
from loanhist
where YEAR(in_date)=2001
group by member_no,ISNULL(fine_paid,0)
order by member_no

select member_no, sum(ISNULL(fine_paid,0)) 
from loanhist
where YEAR(in_date)=2001
group by member_no
order by member_no

-- 5. Ile książek wypożyczono w maju/listopadzie 2001

select count(*)
from loanhist
where YEAR(out_date)=2001 and MONTH(out_date)=5

-- 6. Na jak długo średnio były wypożyczane książki w maju/listopadzie 2001

select AVG(DATEDIFF(d,out_date,in_date)) 
from loanhist
where YEAR(out_date)=2001 and MONTH(out_date)=11


-- Ćwiczenie 4
-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień w 1997r

select EmployeeID, Count(OrderID)
from Orders
where YEAR(OrderDate)=1997
group by EmployeeID

select EmployeeID, Count(*)
from Orders
where YEAR(OrderDate)=1997
group by EmployeeID

-- 2. Dla każdego pracownika podaj ilu klientów (różnych klientów) obsługiwał ten
-- pracownik w 1997r

select EmployeeID, COUNT(distinct(CustomerID))
from Orders
where YEAR(OrderDate)=1997
group by EmployeeID

-- pomoc ponizej
select distinct EmployeeID, CustomerID
from Orders
where YEAR(OrderDate)=1997 and EmployeeID=2
order by CustomerID

-- 3. Dla każdego spedytora/przewoźnika podaj łączną wartość "opłat za przesyłkę" dla
-- przewożonych przez niego zamówień

select ShipVia, SUM(Freight)
from Orders
group by ShipVia

-- 4. Dla każdego spedytora/przewoźnika podaj łączną wartość "opłat za przesyłkę"
-- przewożonych przez niego zamówień w latach od 1996 do 1997   

select *
from Orders

select ShipVia, SUM(Freight)
from Orders
where YEAR(ShippedDate) BETWEEN 1996 and 1997
group by ShipVia

-- Ćwiczenie 5
-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z
-- podziałem na lata

select EmployeeID, DATEPART(yy,OrderDate), count(OrderID)
from Orders
group by rollup (EmployeeID,DATEPART(yy,OrderDate))
order by EmployeeID

select EmployeeID, DATEPART(yy,OrderDate), count(OrderID) as 'num of orders'
from Orders
group by EmployeeID,DATEPART(yy,OrderDate)
order by 1,2

--pomoc
select count(*)
from Orders
where EmployeeID=1 and year(OrderDate)=1997

-- 2. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z
-- podziałem na lata i miesiące.

select EmployeeID, DATEPART(yy,OrderDate) as year, DATEPART(mm,OrderDate) as month, count(OrderID) as 'num of orders'
from Orders
group by EmployeeID,DATEPART(yy,OrderDate),DATEPART(mm,OrderDate)
order by EmployeeID

-- mozna bez datepart samymi YEAR(), MONTH()

-- pomoc
select count(*)
from Orders
where EmployeeID=1 and year(OrderDate)=1996 and MONTH(OrderDate)=8


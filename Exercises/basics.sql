

-- Ćwiczenie 1
-- 1. Napisz polecenie select za pomocą którego uzyskasz identyfikator/numer tytułu oraz
-- tytuł książki

select title_no, title
from title

-- 2. Napisz polecenie, które wybiera tytuł o numerze/identyfikatorze 10


select title
from title
where title_no=10

-- 3. Napisz polecenie select, za pomocą którego uzyskasz numer książki (nr tyułu) i
-- autora dla wszystkich książek, których autorem jest Charles Dickens lub Jane Austen

select title_no,author
from title
where author in ('Jane Austen','Charles Dickens')


-- Ćwiczenie 2
-- 1. Napisz polecenie, które wybiera numer tytułu i tytuł dla wszystkich książek, których
-- tytuły zawierających słowo 'adventure'

select title_no,title
from title
where title LIKE '%adventure%'

-- 2. Napisz polecenie, które wybiera numer czytelnika, oraz zapłaconą karę dla wszystkich
-- książek, tore zostały zwrócone w listopadzie 2001

select member_no, ISNULL(fine_paid,0)
from loanhist
where YEAR(in_date)=2001 and MONTH(in_date)=11 

-- 3. Napisz polecenie, które wybiera wszystkie unikalne pary miast i stanów z tablicy adult.

select state,city
from adult
group by state,city

-- 4. Napisz polecenie, które wybiera wszystkie tytuły z tablicy title i wyświetla je w
-- porządku alfabetycznym.

select title
from title
order by title 


-- Ćwiczenie 3

select member_no,isbn,fine_assessed, fine_assessed*2 as double_fine, fine_assessed*2-fine_assessed as diff
from loanhist
where fine_assessed IS NOT NULL AND fine_assessed*2-fine_assessed>3


-- Ćwiczenie 4

select firstname +' '+ middleinitial +' '+ lastname as email_name
from member
where lastname='Anderson'

select LOWER(CONCAT(firstname, middleinitial, LEFT(lastname,2))) as email_name
from member
where lastname='Anderson'

-- FINAL ANSWER
select LOWER(firstname+middleinitial+SUBSTRING(lastname,0,3)) as email_name
from member
where lastname='Anderson'


-- Ćwiczenie 5

select 'The title is:'+' '+title+', title number'+' '+STR(title_no,1) as title_desc
from title



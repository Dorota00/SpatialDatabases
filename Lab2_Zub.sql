--2 
create database lab2

--3
create extension postgis

--4
create table buildings (id int, geometry geometry, name varchar)
create table roads (id int, geometry geometry, name varchar)
create table poi (id int, geometry geometry, name varchar)

--5
insert into buildings values (1, 'POLYGON((8 1.5, 10.5 1.5, 10.5 4, 8 4, 8 1.5))', 'BuildingA')
							,(2, 'POLYGON((4 5, 6 5, 6 7, 4 7, 4 5))', 'BuildingB')
							,(3, 'POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))', 'BuildingC')
							,(4, 'POLYGON((9 8, 10 8, 10 9, 9 9, 9 8))', 'BuildingD')
							,(5, 'POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))', 'BuildingF')


insert into roads values (1, 'LINESTRING(0 4.5, 12 4.5)','RoadX')
						,(2, 'LINESTRING(7.5 10.5, 7.5 0)','RoadY')
						
insert into poi values 	(1, 'POINT(1 3.5)', 'G')
						,(2, 'POINT(5.5 1.5)', 'H')
						,(3, 'POINT(9.5 6)', 'I')
						,(4, 'POINT(6.5 6)', 'J')
						,(5, 'POINT(6 9.5)', 'K')
--6
--a					
select sum(st_length(geometry))
from roads

--b
select st_astext(geometry), st_area(geometry), st_perimeter(geometry)
from buildings 
where name = 'BuildingA'

--c
select name, st_area(geometry)
from buildings
order by name

--d
select name, st_perimeter(geometry)
from buildings
order by st_area(geometry) desc
limit 2

--e
with C as(
select geometry
from buildings 
where name = 'BuildingC'
), 
K as(
select geometry
from poi 
where name = 'K'
)

select st_distance(c.geometry, k.geometry) 
from C c 
cross join K k

--f
with B as(
select geometry
from buildings 
where name = 'BuildingB'
), 
 C as(
select geometry
from buildings 
where name = 'BuildingC'
)
select st_area(st_difference(c.geometry, st_buffer(b.geometry, 0.5)))
from B b
cross join C c

--g
with X as(
select geometry
from roads
where name = 'RoadX'
)
select name
from buildings b
cross join X x
where st_y(st_centroid(b.geometry)) > st_ymax(x.geometry)

--h
select st_area(st_symdifference(geometry, st_geomfromtext('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')))
from buildings 
where name = 'BuildingC'



						
-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
select f.title 
from film f 
where rating='R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
select a.first_name as Nombre, a.last_name as Apellido
from actor a 
where a.actor_id between 30 and 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
select *
from film f 
where f.language_id =f.original_language_id ;
-- No da ninguno, lo cual tiene sentido puesto que original_language_id esta vacío.

-- 5. Ordena las películas por duración de forma ascendente.
select f.title , f.length 
from film f 
order by f.length asc;

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
select a.first_name as Nombre, a.last_name as Apellido
from actor a 
where a.last_name ='ALLEN';

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento
select rating, count(*) as total_peliculas
from film
group by rating;

-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
select title as titulo, rating, length as duracion
from film
where rating = 'PG-13' or length >180;

-- 9.  Encuentra la variabilidad de lo que costaría reemplazar las películas.
select variance("replacement_cost") as "Varianza"
from film;

-- 10.  Encuentra la mayor y menor duración de una película de nuestra BBDD
select
max(length) as Duracion_maxima,
min(length) as Duracion_minima
from film;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select p.amount as coste
from rental r
join payment p
  on r.rental_id = p.rental_id
order by r.rental_date desc
offset 3
limit 1;

-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación
select title as "titulo", rating
from film f 
where f.rating not in ('NC-17', 'G')
order by f.rating desc;

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración
select f.rating, 
avg(f.length ) as promedio_duracion
from film f 
group by f.rating ;

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
select f.title  as titulo, f.length  as duracion
from film f 
where f.length >180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
select sum(p.amount) as Total_ingresos
from payment p ;

-- 16. Muestra los 10 clientes con mayor valor de id.
select *
from customer c 
order by c.customer_id desc
limit 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
select a.first_name as Nombre , a.last_name as Apellido
from actor a 
join film_actor fa 
	on a.actor_id =fa.actor_id 
join film f 
	on fa.film_id =f.film_id 
where f.title ='EGG IGBY';

-- 18. Selecciona todos los nombres de las películas únicos.
select distinct f.title 
from film f; 

-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
select f.title , c.category_id 
from film f 
join film_category fc 
	on f.film_id = fc.film_id 
join category c 
	on fc.category_id =c.category_id 
where c.category_id = 5;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
select  c.name AS categoria,
       round(avg(f.length)) AS promedio_duracion
from category c
join film_category fc
  on c.category_id = fc.category_id
join film f
  on fc.film_id = f.film_id
group by c.name
having avg(f.length) > 110
order by promedio_duracion DESC;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
select avg(f.rental_duration) as media_duracion
from film f ;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
select concat(a.first_name , ' ' , a.last_name ) as Nombre
from actor a ;

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
select date(r.rental_date) as dia,
	count(*) as total_alquileres
from rental r 
group by date(r.rental_date)
order by count(*) desc;

-- 24. Encuentra las películas con una duración superior al promedio.
select f.title as titulo, f.length as duracion
from film f 
where f.length > (
	select avg(length)
	from film)
order by f.length desc;

-- 25. Averigua el número de alquileres registrados por mes.
select to_char(r.rental_date, 'MM') as mes,
	count(*) as total_alquileres_mes
from rental r 
group by to_char(rental_date,'MM') 
order by mes;

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado
select 
	avg(amount) as promedio,
	stddev(amount) as desviacion_estandar,
	variance(amount) as varianza
from payment;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
select title , rental_rate  
from film
where rental_rate > (
	select avg(rental_rate)
	from film)
order by film.rental_rate; 

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
select actor_id,
	count(film_id) as total_peliculas
from film_actor fa
group by actor_id 
having count(film_id) > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
select  f.title,
       coalesce(count(i.inventory_id), 0) AS cantidad_disponible
from film f
left join inventory i
  on f.film_id = i.film_id
group by f.title
order by cantidad_disponible DESC;

-- 30. Obtener los actores y el número de películas en las que ha actuado
select a.first_name as Nombre,
       a.last_name as Apellido,
       count(fa.film_id) AS total_peliculas
from actor a
join film_actor fa
  on a.actor_id = fa.actor_id
group by a.first_name, a.last_name
order by total_peliculas DESC;

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
select 
  f.title,
  a.first_name,
  a.last_name
from film f
left join film_actor fa 
	on fa.film_id = f.film_id
left join actor a       
	on a.actor_id = fa.actor_id
order by f.title, a.last_name, a.first_name;

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
select 
	a.first_name as Nombre,
	a.last_name as Apellido,
	f.title  as Pelicula
from actor a 
left join film_actor fa 
	on a.actor_id = fa.actor_id 
left join film f 
	on fa.film_id=f.film_id 
order by a.first_name , a.last_name , f.title ;

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
select 
    f.title,
    r.rental_date,
    r.return_date
from film f
left join inventory i 
	on i.film_id = f.film_id
left join rental r    
	on r.inventory_id = i.inventory_id
order by f.title, r.rental_date;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select
    c.first_name as nombre,
    c.last_name as apellido,
    SUM(p.amount) AS total_gastado
from customer c
join payment p 
	on p.customer_id = c.customer_id
group by c.first_name, c.last_name
order by total_gastado desc
limit 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select 
	a.first_name as Nombre,
	a.last_name as Apellido
from actor a 
where a.first_name ='JOHNNY';

-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
select 
	a.first_name as Nombre,
	a.last_name as Apellido
from actor a;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
select 
max(a.actor_id),
min(a.actor_id)
from actor a; 

-- 38. Cuenta cuántos actores hay en la tabla “actor”.
select 
count(*)
from actor a; 

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select 
	a.first_name,
	a.last_name 
from actor a 
order by a.last_name desc;

-- 40. Selecciona las primeras 5 películas de la tabla “film”.
select 
	f.title 
from film f 
limit 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
select first_name,
	COUNT(*) AS cantidad
from actor
group by first_name
order by cantidad desc
limit 1;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select 
	r.rental_date ,
	c.first_name ,
	c.last_name 
from rental r 
join customer c 
	on c.customer_id =r.customer_id 
order by r.rental_date ;

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres
select 
	c.first_name ,
	c.last_name,
	r.rental_date 
from customer c 
left join rental r 
	on c.customer_id =r.customer_id 
order by c.first_name  ;

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
select 
	f.title,
	c.category_id,
	c.name AS categoria
from film f
cross join category c;
/* El cross join no aporta valor, puesto que mostrara todas las peliculas con todas las categorias, incluso si no estan relacionadas */

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
select distinct  
	a.first_name,
	a.last_name
from actor a
join film_actor fa       
	on a.actor_id = fa.actor_id
join film f              
	on fa.film_id = f.film_id
join film_category fc    
	on f.film_id = fc.film_id
join category c          
	on fc.category_id = c.category_id
where c.name = 'Action'
order by a.first_name ;

-- 46. Encuentra todos los actores que no han participado en películas.
select 
	a.first_name, 
	a.last_name
from actor a
left join film_actor fa
  on fa.actor_id = a.actor_id
where fa.actor_id is null
order by a.last_name, a.first_name;

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
select
	a.first_name as Nombre,
	a.last_name as Apellido,
	count(fa.film_id) as total_peliculas
from actor a 
join film_actor fa 
	on a.actor_id =fa.actor_id 
group by a.first_name , a.last_name 
order by total_peliculas desc; 

-- 48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.
create view actor_num_peliculas as
select
	a.first_name as Nombre,
	a.last_name as Apellido,
	count(fa.film_id) as total_peliculas
from actor a 
join film_actor fa 
	on a.actor_id =fa.actor_id 
group by a.first_name , a.last_name; 


select *
from actor_num_peliculas;

-- 49. Calcula el número total de alquileres realizados por cada cliente.
select 
	c.first_name, 
	c.last_name, 
	count(r.rental_id) as total_alquileres
from customer c 
left join rental r 
	on c.customer_id =r.customer_id 
group by c.first_name , c.last_name 
order by total_alquileres desc;

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
select 
	c.name as categoria, 
	sum(f.length) as duracion 
from category c 
join film_category fc 
	on c.category_id =fc.category_id 
join film f 
	on f.film_id =fc.film_id 
where c.name ='Action';

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.
create temporary table  cliente_rentas_temporal as
select 
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) as total_alquileres
from customer c
left join rental r 
  on c.customer_id = r.customer_id
group by c.first_name, c.last_name;

select *
from cliente_rentas_temporal;

-- 52. Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.
create temporary table peliculas_alquiladas as
select 
    f.title,
    COUNT(r.rental_id) AS total_alquileres
from film f
join inventory i 
	on i.film_id = f.film_id
join rental r   
	on r.inventory_id = i.inventory_id
group by f.film_id, f.title
having COUNT(r.rental_id) >= 10;

select *
from peliculas_alquiladas;

-- 53.  Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película
select f.title
from customer c
join rental r 
	on c.customer_id = r.customer_id
join inventory i 
	on r.inventory_id = i.inventory_id
join film f 
	on i.film_id = f.film_id
where c.first_name = 'TAMMY'
  and c.last_name = 'SANDERS'
  and r.return_date is null
order by f.title;

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados alfabéticamente por apellido.
select distinct a.first_name, a.last_name
from actor a
join film_actor fa 
	on a.actor_id = fa.actor_id
join film f 
	on fa.film_id = f.film_id
join film_category fc 
	on f.film_id = fc.film_id
join category c 
	on fc.category_id = c.category_id
where c.name = 'Sci-Fi'
order by a.last_name, a.first_name;

-- 55.  Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaperʼ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
select distinct a.first_name, a.last_name
from actor a
join film_actor fa 
	on a.actor_id = fa.actor_id
join film f 
	on fa.film_id = f.film_id
join inventory i 
	on f.film_id = i.film_id
join rental r 
	on i.inventory_id = r.inventory_id
where r.rental_date > (
    select MIN(r2.rental_date)
    from rental r2
    join inventory i2 
    	on r2.inventory_id = i2.inventory_id
    join film f2 
    	on i2.film_id = f2.film_id
    where f2.title = 'SPARTACUS CHEAPER'
)
order by a.last_name, a.first_name;

-- 56.  Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ.
select a.first_name, a.last_name
from actor a
where a.actor_id not in (
    select fa.actor_id
    from film_actor fa
    join film f 
    	on fa.film_id = f.film_id
    join film_category fc 
    	on f.film_id = fc.film_id
    join category c 
    	on fc.category_id = c.category_id
    where c.name = 'Music'
)
order by a.first_name;

-- 57.  Encuentra el título de todas las películas que fueron alquiladas por más de 8 días. 
select distinct f.title
from rental r
join inventory i 
	on r.inventory_id = i.inventory_id
join film f 
	on i.film_id = f.film_id
where extract(day from(r.return_date - r.rental_date)) > 8
ORDER BY f.title;

-- 58.  Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ.
select f.title
from film f
join film_category fc 
	on f.film_id = fc.film_id
join category c 
	on fc.category_id = c.category_id
where c.name = 'Animation'
order by f.title;

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. Ordena los resultados alfabéticamente por título de película.
select f.title, f.length 
from film f
where f.length = (
    select length
    from film
    where title = 'DANCING FEVER'
)
order by f.title;


-- 60.  Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
select c.first_name, c.last_name
from customer c
join rental r 
	on c.customer_id = r.customer_id
join inventory i 
	on r.inventory_id = i.inventory_id
join film f 
	on i.film_id = f.film_id
group by c.customer_id, c.first_name, c.last_name
having COUNT(distinct f.film_id) >= 7
order by c.last_name;

-- 61.  Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
select c.name AS categoria, COUNT(r.rental_id) as total_alquileres
from rental r
join inventory i 
	on r.inventory_id = i.inventory_id
join film f 
	on i.film_id = f.film_id
join film_category fc 
	on f.film_id = fc.film_id
join category c 
	on fc.category_id = c.category_id
group by c.name
order by total_alquileres desc;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
select c.name as categoria, COUNT(f.film_id) as total_peliculas
from film f
join film_category fc 
	on f.film_id = fc.film_id
join category c 
	on fc.category_id = c.category_id
where f.release_year = 2006
group by c.name
order by total_peliculas desc;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select s.first_name, s.last_name, st.store_id
from staff s
cross join store st
order by s.first_name;

-- 64.  Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
select c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) as total_alquileres
from customer c
left join rental r 
	on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name
order by c.customer_id;

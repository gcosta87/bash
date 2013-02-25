IMDB
====
Son 2 pequeños scripts que sirven para obtener algo de información del sitio IMDB.com


## Descripción de los scripts
### extraerTituloHispano.sh
Este script permite obtener el título en español para Argentina (o sino en su defecto España) en base a una URL o ID de una película en IMDB. 

Si la película no fue lanzada en Argentina, no devuelve nada. Esto se puede "desactivar", modificando el código :D. Mas adelante se le agregará esta opción como parámetro.

Ejemplo:

```
./extraerTituloHispano http://www.imdb.com/title/tt0120737/
```

o bien usando su ID.

```
./extraerTituloHispano tt0120737
```

Lo cual imprime: **El señor de los anillos: La comunidad del anillo [Argentina]**


### extraerIDsDelListado.sh
Se encarga de guardar en un archivo prefijado ( *IDsPeliculas.txt* ) todas las IDs de las películas que forman parte de un resultado de una búsqueda avanzada ([Advanse Title Search](http://www.imdb.com/search/title)).

Ejemplo de uso, tras haber utilizado el buscador de IMDB y obtenido la URL de los resultados:

```
./extraerIDsDelListado "http://www.imdb.com/search/title?release_date=2001,2013&title_type=tv_movie"
```

Es aconsejable el uso de comillas dobles para la URL


## Ejemplo de uso
Es posible sacar "mayor provecho" a ambos scripts para obtener un listado de títulos de películas en base a una búsqueda. Por ejemplo una vez obtenido las IDs (extraerIDsDelListado.sh) se puede generar un archivo de títulos ( llamado *titulos.txt* ) de la siguiente forma:

```
cat IDsPeliculas.txt | while read peliculaID; do ./extraerTituloHispano.sh "$peliculaID" >> titulos.txt ;done;
```

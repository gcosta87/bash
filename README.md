bash
====

En este repo dejo algunos bashscripts que utilizo a menudo: algunos pueden llegar a serte útil ;).

Todos son publicados bajo la **GPLv3**

## chequearSaldoDePersonal

Con este script es posible averiguar el saldo (solo credito,no los bonus) de una o varias cuentas de *Personal Argentina* (Cuenta de Autogestion).

### USO:
Para utilizarlo primero hay que crear un Perfil de cuenta ( *crearPerfil.sh* ), que no es mas que indicar: Numero de celular y contraseña. Esto genera un archivo oculto (.NUMERODECELULAR.perfil) el cual es utilzado por el script principal (chequearSaldo.sh).

Una vez creado los perfiles, es posible consultar el saldo. Se ejecuta el script *chequearSaldo.sh* , y este realiza las siguientes acciones:
* Informa al usuario (via notify-send) el saldo del celular/es consultado/s
* Guarda en un archivo (reporte.csv) el resultado obtenido, acompañado con la fecha, hora y la diferencia con el saldo anterior. 

Adicionalmente se adjunta un pequeño script,*servicio.sh*, para definirlo en el arranque del sistema/sesion (p.e *.config/autorun*) y asi automatizar el chequeo.Este lanza la aplizacion cada 4 HS. Es util para monitorear cambios en el saldo (usando el archivo CSV).

### Motivacion:
Algunos usos pueden ser:
* Llevar un Historial/Registro de Saldo.
* Utilizar bajo otro script para generar una pequeña "alarma" ante cambios del saldo
* Para informar al usuario en otros contextos: via mail, usando Conky (widget para desktop) ;)

### Estado:
Actualmente (3/3/2013) el script funciona. Días a tras dejo de funcionar debido a cambios en el servidor de Personal que afectaban la autentificación (login). Esto se ve en el script comentado como método "nuevo" o "viejo", donde están comentadas lineas que si llegara el caso de que volviera a cambiar el servidor están disponibles.

## IMDB
Son dos pequeños scripts para:
* Obtener el titulo en español de una pelicula segun su URl o  su "ID" ( *ttxxxxxxx* ) dentro de la web de IMDB.com, que haya sido lanzada (released) en Argentina.
* Extraer todos los IDs de un resultado de una Búsqueda Avanzada ([Advanced Title Search](http://www.imdb.com/search/title)), generando un archivo *.txt con todas las IDs.
 
Gracias a ellos es posible, usando en su conjunto, obtener un listado de titulos en base a una busqueda de IMDB.

Puede llegar a ser útil para armar listados temáticos: Peliculas de los 80, protagonizadas por determinado actor,etc.

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
* Guarda en un archivo (reporte.csv) el resultado obtenido, acompañado con la fecha, hora y la diferencia con el saldo anterior. Actualmente esta diferencia sirve para cuando se consulta 1 solo perfil, sera modificado para soportar correctamente varios.

Adicionalmente se adjunta un pequeño script,*servicio.sh*, para definirlo en el arranque del sistema/sesion (p.e *.config/autorun*) y asi automatizar el chequeo.Este lanza la aplizacion cada 4 HS. Es util para monitorear cambios en el saldo (usando el archivo CSV).

### Motivacion:
Algunos usos pueden ser:
* Llevar un Historial/Registro de Saldo.
* Utilizar bajo otro script para generar una pequeña "alarma" ante cambios del saldo
* Para informar al usuario en otros contextos: via mail, usando Conky (widget para desktop) ;)

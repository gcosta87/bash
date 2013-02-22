#!/bin/bash
#Bashscript que sirve para dejar como servicio (demonio) el chequeo de saldo
#Ejecuta la consulta con una freq de 4 HS de iniciada la maquina/sesion...

#Inicialmente se detiene 25 segundos... para que cargue el resto del "Sistema"
sleep 25 

while [ true ]
do
	cd /home/gonzalo/Espacio\ de\ Trabajo/bashScripts/chequearSaldoDePersonal/
	./chequearSaldo.sh
	sleep 4h
done

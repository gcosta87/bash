#!/bin/bash

#  chequearSaldo.sh
#   
#  Copyright 2013 Gonzalo G. Costa <gonzalogcostaARROBAyahooPUNTOcomPUNTOar>
#   
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
   
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#   
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.

##	CONSTANTES
##

readonly URL_PERSONAL_LOGIN="https://autogestion.personal.com.ar/individuos/"
#URL para la version anterior a la actualizacion de 02/13
#~ readonly URL_PERSONAL_LOGIN_VALIDACION="https://autogestion.personal.com.ar/individuos/"
readonly URL_PERSONAL_LOGIN_VALIDACION="https://sso.personal.com.ar/openam/UI/Login"
readonly URL_PERSONAL_SALDO="https://autogestion.personal.com.ar/individuos/inicio_tarjeta.aspx"

readonly ARCHIVO_DE_COOKIE=".cookie.txt"
readonly URL_REFERENCIA="https://autogestion.personal.com.ar/individuos/Index.aspx"

readonly ARCHIVO_CSV="reporte.csv"
readonly ARCHIVO_TEMP=".temp"
#Frecuencia en segundos que se usa para indicar el minimo de tiempo que debe pasar para actualizar el archivo CSV.
# 3600 = 1HS
readonly FREQUENCIA_MINIMA_DE_ACTUALIZACION=3600


##	FUNCIONES
#

#Inicializa las Cookies, permite obtener la Id de Sesion y otro paramentro requerido
#Retorna la cadena con los parametros (listos para hacer enviar por post) EVENTVALIDATION y VIEWSTATE. o nada si sirgio algun errror
inicializar(){		
	 wget -qO- --keep-session-cookies --save-cookies "$ARCHIVO_DE_COOKIE" --user-agent="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0" "$URL_PERSONAL_LOGIN" | grep -Eo '(__VIEWSTATE|__EVENTVALIDATION)"\s+value="[^"]+' | sed -e 's/" *value=\"/=/g' | sed -e 's/^/\&/g' | tr -d '\n' | sed 's/\//%2F/g'| sed 's/=/%3D/g' | sed 's/+/%2B/g' | sed 's/__VIEWSTATE%3D/__VIEWSTATE=/g' | sed 's/__EVENTVALIDATION%3D/__EVENTVALIDATION=/g' 
}

#Requiere haber hecho al menos un inicializar()
#Llevaria a cabo el login..
#Recibe como parametros: $1=COD de Area, $2=Celular, $3=Contraseña y $4 recibe los parametros requeridos EVENTVALIDATION y VIEWSTATE
completarLogin(){	 
	#Metodo para la version anterior a la actualizacion de 02/13:
	#~ wget -qO - --keep-session-cookies --load-cookies "$ARCHIVO_DE_COOKIE" --save-cookies "$ARCHIVO_DE_COOKIE" --referer="$URL_REFERENCIA" --user-agent="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0" --post-data "__LASTFOCUS=&__EVENTTARGET=ctl00%24BannerLogueo%24LogueoPropio%24BtnAceptar&__EVENTARGUMENT=$4&ctl00%24BannerLogueo%24LogueoPropio%24TxtArea=$1&ctl00%24BannerLogueo%24LogueoPropio%24TxtLinea=$2&ctl00%24BannerLogueo%24LogueoPropio%24TxtPin=$3&IDToken3=" "$URL_PERSONAL_LOGIN";	
	wget -qO "$ARCHIVO_TEMP" --keep-session-cookies --load-cookies "$ARCHIVO_DE_COOKIE" --save-cookies "$ARCHIVO_DE_COOKIE" --referer="$URL_REFERENCIA" --user-agent="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0" --post-data "__LASTFOCUS=&__EVENTTARGET=&__EVENTARGUMENT=$4&TxtArea=$1&TxtLinea=$2&IDToken2=$3&IDToken1=$1$2&IDToken3=&goto=https%3A%2F%2Fautogestion.personal.com.ar%2FIndividuos%2Fdefault.aspx&gotoOnFail=https%3A%2F%2Fautogestion.personal.com.ar%2FIndividuos%2FRespuesta.aspx&realm=%2Fservicios" "$URL_PERSONAL_LOGIN_VALIDACION";	
}

#Realiza la consula correspondiente, en $1 se le debe pasar la ID de SESION
consultarSaldo(){	
	#Metodo para la version anterior a la actualizacion de 02/13:
	#~ resultado=`wget -qO-  --keep-session-cookies --load-cookies "$ARCHIVO_DE_COOKIE" --save-cookies "$ARCHIVO_DE_COOKIE" --referer="$URL_REFERENCIA" --user-agent="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0" "$URL_PERSONAL_SALDO" | grep "lblSaldo" | grep -Eo "[0-9]+.[0-9]+\s*<" | sed 's/<//g'`
	resultado=`cat "$ARCHIVO_TEMP" | grep "lblSaldo" | grep -Eo "[0-9]+.[0-9]+\s*<" | sed 's/<//g'`
	rm "$ARCHIVO_TEMP"
	echo $resultado
}


#En base al ult registro almacenado, calculo la diferencia del valor del saldo.
#En $1=recibe cod de area+celular, $2=recibe el saldo actual
calcularDiferenciaConAnterior(){
	ultimoSaldo=`cat $ARCHIVO_CSV | grep $1 | tail -n1 | cut -f7 -d";" | grep -Eo "[0-9]+(.[0-9]*)?"`
	#Si no tiene saldo anterior lo seteo en 0
	if [ -n "$ultimoSaldo" ]
	then
		echo "$2 - $ultimoSaldo" | bc
	else
		echo "0"
	fi
}
#Persiste en un archivo CSV, como maximo se puede actualizar cada 1 HS
#Recibe en $1=codigo de area + celular, $2=saldo
registrarEnArchivoCSV(){
	#almaceno dia de la semana, dia del mes, nombre del mes,año, hora
	camposDeTiempo=`date '+"%A", "%d", "%B", "%Y", "%H:%M",'`
	
	#Si no existe lo creo e inicializo...
	if [ ! -e "$ARCHIVO_CSV" ]
	then
		echo '"Dia de Semana", "Dia", "Mes", "Año",  "Hora",  "Celular", "Saldo", "Diferencia", ' > "$ARCHIVO_CSV"
		echo "$camposDeTiempo \"$1\", \"$2\"," >> "$ARCHIVO_CSV"
	else
		#Consulto si trascrurrio el minimo tiempo para actualizar
		tiempoActual=`date +%s`
		tiempoDeModificacion=`stat -c %Y "$ARCHIVO_CSV"`

		diferencia=$(($tiempoActual - $tiempoDeModificacion))

		if [ $diferencia -gt $FREQUENCIA_MINIMA_DE_ACTUALIZACION ]
		then
			#Si existe, agrego el registro con el calculo de la dif. del saldo
			diferenciaDeSaldo=$(calcularDiferenciaConAnterior "$1" "$2")
			echo "$camposDeTiempo \"$1\", \"$2\", \"$diferenciaDeSaldo\"" >> "$ARCHIVO_CSV"
		fi
	fi
}
     
##	MAIN
#

#Recorre cada perfil de USR y chequea su saldo
for perfil in .*.perfil
do
	#formato de los datos "cod:cel:passwd"
	datosDelPerfil=`cat $perfil`
	
	codDeArea=`echo $datosDelPerfil | cut -f1 -d":"`
	celular=`echo $datosDelPerfil | cut -f2 -d":"`
	passwd=`echo $datosDelPerfil | cut -f3 -d":"`	
	
	
	EV=$(inicializar)
	completarLogin "$codDeArea" "$celular" "$passwd" "$EV"
	saldo=$(consultarSaldo)
	
	if [ -n "$saldo" ] && [ "$saldo" != " " ]
	then
		notify-send "Saldo de $celular: $saldo."	
		registrarEnArchivoCSV "$codDeArea$celular" "$saldo"
	else
		notify-send "No se ha podido obtener el saldo del celular $celular."	
	fi
	#Demora para que se visuale la Notificacion
	sleep 4
done

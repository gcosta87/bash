#!/bin/bash

#  extraerIDsDelListado.sh
#   
#  Copyright 2013 Gonzalo G. Costa <gonzalogcostaARROBAyahooPUNTOcomPUNTOar>
#   
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
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
#
readonly URL_BASE="http://www.imdb.com"

#parametro pàra ver el listado en modo simple/compacto
readonly MODO_SIMPLE="&view=simple"

readonly PAGINA_TEMP=".listado-temp"
readonly ARCHIVO_RESULTADO="IDsPeliculas.txt"

##	MAIN
#

#$1= URL de busqueda: ejemplo http://www.imdb.com/search/title?role=nm0000115&title_type=feature,tv_movie&view=simple
#url de busqueda, "limpia"
urlInicial=`echo "$1" | sed -e 's/http:\/\///' -e 's/www.//' -e 's/imdb.com//'`
esUnaURLDeBusqueda=`echo "$urlInicial" | grep -E "^/search/title"`

if [ -n "$esUnaURLDeBusqueda" ]
then
	#chequeo que este en modo simple, sino se lo agrego
	poseeModoSimple=`echo "$urlInicial" | grep "$MODO_SIMPLE"`
	
	if [ -z "$poseeModoSimple" ]
	then
		#le agrego el parametro modo simple
		urlInicial="$urlInicial$MODO_SIMPLE"
	fi

	paginaSiguiente="$urlInicial"
	
	#Si hay resultados los procesos
	while [ -n "$paginaSiguiente"  ]
	do
		echo "$paginaSiguiente"
	
		#Descargo la pagina
		wget -qO "$PAGINA_TEMP" -t 100 "$URL_BASE$paginaSiguiente"
		
		#Extre las IDs publicadas del listado
		cat "$PAGINA_TEMP" | grep -i 'class="title"' | grep -Eo '/title/tt[0-9]+' | sed -e 's/\/title\///' >> "$ARCHIVO_RESULTADO"
	
		#obtengo el link a la siguiente pagina
		paginaSiguiente=`cat "$PAGINA_TEMP"  | grep -i -m 1 '>Next&nbsp;&raquo;' | grep -Eo 'href="[^"]+' | sed 's/href="//'`
	
		sleep 1
		#elimino el archivo tmp
		rm "$PAGINA_TEMP"
		
	done
else
	echo "No es una URL de busqueda :("
fi

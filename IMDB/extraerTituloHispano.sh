#!/bin/bash

#  extraerTituloHispano.sh
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

#Recibe una URL y devuelve el 1er titulo que encuentre en orden: Argentina,España.
#Las peliculas fueron lanzadas en argentina

##	CONSTANTES
#
#Al final va la ID
readonly URL_PELICULA_ID="http://www.imdb.com/title/"

readonly URL_RELATIVA_LANZAMIENTOS="/releaseinfo?ref_=tt_dt_dt#akas"

readonly PAGINA_TEMP=".pelicula-temp"
#Archivo donde se guardan las IDs de las pelis de las cuales no se obtuvieron titulos...
readonly ARCHIVO_LOG_DE_ERROR="extraerTituloHispano.err"

##	FUNCION
#

# Extrea el titulo para el pais dado del archivo temporal (pagina descargada)
#En $1 recibe el string del pais: argentina,spain,etc...
extraerTituloParaPais(){
	#~ cat "$PAGINA_TEMP" | grep -iE -B2 "<td>\s*([a-zA-Z]+\s*/)*$1" | head -n1 | sed -e 's/<td>//' -e 's/<\/td>//' | sed -f caracteresEspeciales.sed
	cat "$PAGINA_TEMP" | grep -iE -B2 "<td>\s*([ a-z()]+/)*\s*$1" | head -n1 | sed -e 's/<td>//' -e 's/<\/td>//' | sed -f caracteresEspeciales.sed
}


##	MAIN
#

#$1= URL o ID de pelicula...
#Limpio lo que recibo en $1 para quedarme con la ID
peliculaID=`echo "$1"  | grep -Eo "/?tt[0-9]+/?" | sed 's/\///g'`

if [ -n "$peliculaID" ]
then
	#Descargo la pagina al archivo temporal
	wget  -q -O "$PAGINA_TEMP" "$URL_PELICULA_ID$peliculaID$URL_RELATIVA_LANZAMIENTOS"
	lanzadaEnArgentina=`cat "$PAGINA_TEMP" | grep -i "/calendar/?region=AR"`
	if [ -n "$lanzadaEnArgentina" ]
	then
		#Extraigo el nombre para Argentina
		nombreEnArgentina=$(extraerTituloParaPais "argentina")
				
		if [ -n "$nombreEnArgentina" ]
		then
			echo "$nombreEnArgentina [Argentina]"
		else
			nombreEnEspa=$(extraerTituloParaPais "spain")
			if [ -n "$nombreEnEspa" ]
			then
				echo "'$nombreEnEspa' [España]"				
			else
				#Sino se puedo obtener guarda el ID en el archivo
				echo "$peliculaID" >> "$ARCHIVO_LOG_DE_ERROR"
			fi
		fi
		
	#else
		#echo "No fue lanzada en Argentina! :("
	fi
	#Elimino el Arch temporal
	rm "$PAGINA_TEMP"
else	
	echo "No se pudo obtener la ID de la Pelicula"
	
fi

#!/bin/bash
#	documentador.sh
#
#	Copyrigth 2013 Gonzalo Gabriel Costa <gonzalogcostaARROBAyahooPUNTOcomPUNTOar>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.

#Genera un archivo HTML en base a un archivo que posee el siguiente formato (ver demo):
#// @nombre:			NOMBRE_DE_FUNCION
#// @descripción:	COMENTARIO
#// @estado:			[Experimental|Inestable|Borrador|Estable]
#// @parámetro	PARAMETRO: [string|number|object|array|Array|Object|String|Number|..], COMENTARIO	(opcional)
#// @retorno	[cadena|numero|objeto|arreglo|Array|Object|String|Number|..], COMENTARIO		(opcional)


##	CONSTANTES
#
readonly ARCHIVO_PREPROCESADO=".temporal"

readonly DOCUMENTADORJS_VERSION="0.1"
#Se excluyen las primeras N lineas q contien la Licencia (GPL=19)
readonly EXCLUIR_PRIMERAS_N_LINEAS=19

##	FUNCIONES
#

# retorna el rengo de lineas de codigo que representan la descripcion del modulo. el formato devuelto es: n,M
#Recibe en $1, el nombre del archivo
rangoDeLineasDeComentario(){
	inicio=`cat "$1" | tail -n+"$EXCLUIR_PRIMERAS_N_LINEAS" | grep -m1 -n -E "\s*/[*]" | grep -Eo "^[0-9]+"`
	fin=`cat "$1" | tail -n+"$EXCLUIR_PRIMERAS_N_LINEAS" | grep -m1 -n -E "\s*[*]/" | grep -Eo "^[0-9]+"`
	echo "$(($EXCLUIR_PRIMERAS_N_LINEAS + $inicio - 1)),$(($EXCLUIR_PRIMERAS_N_LINEAS + $fin - 1))";
}

##	MAIN
##

# $1= Archivo a documentar...
if [ -e "$1" ]
then
	nombreDelArchivo=`basename "$1" .js`	
	cat "$1" | grep -Ei "^// @(nombre:|descripción|estado:|parámetro|retorno)" | sed -e 's/\/\/ //' -e 's/@//'  | tr '\t' ' ' | sed -r -e 's/^nombre/{{{FIN_FUNCION}}}\n{{{INICIO_FUNCION}}}\nnombre/' | sed -e '$a {{{FIN_FUNCION}}}' | sed  -r -e '/^estado/{n;s:^parámetro:{{{INICIO_PARAMETROS}}}\nparámetro:}'  | sed  -r -e '/^parámetro/{n;s:^retorno:{{{FIN_PARAMETROS}}}\nretorno:}' | sed  -r -e '/^parámetro/{n;s:^\{\{\{FIN_FUNCION\}\}\}:{{{FIN_PARAMETROS}}}\n{{{FIN_FUNCION}}}:}' | sed '1d' > "$ARCHIVO_PREPROCESADO"
	#~ cat "$1" | grep -E "^//\s*(@nombre:|@descripción|@estado:|@parámetro|@retorno|FUNCIONES PRIVADAS|FUNCIONES P[ÚU]BLICAS)" | sed -e 's/\/\/ //' -e 's/@//'  | tr '\t' ' ' | sed -r -e 's/^nombre/{{{FIN_FUNCION}}}\n{{{INICIO_FUNCION}}}\nnombre/' | sed -e '$a {{{FIN_FUNCION}}}' | sed  -r -e '/^estado/{n;s:^parámetro:{{{INICIO_PARAMETROS}}}\nparámetro:}'  | sed  -r -e '/^parámetro/{n;s:^retorno:{{{FIN_PARAMETROS}}}\nretorno:}' | sed  -r -e '/^parámetro/{n;s:^\{\{\{FIN_FUNCION\}\}\}:{{{FIN_PARAMETROS}}}\n{{{FIN_FUNCION}}}:}'  | sed -e  '1,3 s/{{{FIN_FUNCION}}}//' > "$ARCHIVO_PREPROCESADO"
		
	echo "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='es' lang='es'><head><title>$nombreDelArchivo</title><meta http-equiv='content-type' content='text/html;charset=utf-8' /><meta name='generator' content='DocumentadorJS' /><link rel='stylesheet' type='text/css' href='documentadorJS.default.css'></head><body><a name='inicio'></a><div class='nombreArchivo'>$nombreDelArchivo</div><br/><br/>"
	
	#Obtengo la descripcion del Archivo
	echo '<h2>Descripción:</h2>'
	cat "$1" | sed "$(rangoDeLineasDeComentario "$1")!d" | sed -r -e 's: */\*::' -e 's: *\*/::' -e 's: *\*::' | sed -e '1i <p>' -e '$a </p>' | sed -r -e 's:[.]$:.</p><p>:' | tr -d '\n' | sed -e 's:<p></p>::g'
	echo "<br/><br/>"

	#Armo la lista de funciones
	echo "<h2>Funciones:</h2><div class='listaDeFunciones'><ul>"
	cat "$ARCHIVO_PREPROCESADO" | grep -E "^nombre:" | sed -r -e 's/nombre: *//' -e 's:.*:<li><a href="#&">&</a></li>:'; echo "</ul><br/></div>"
	
	#Se arma el cuerpo del HTML: las funciones	
	cat "$ARCHIVO_PREPROCESADO" | sed -r -e  '/^nombre/{s:^nombre[:] *::;s:.*:<h2><a name="&"></a>&</h2>:}' -e '/^descripción:/ {s:^descripción[:] *::;s:.*:<p class="descripcion">&</p>:}' -e '/^estado/ {s:^estado[:] *::;s:.*:<p class="estado">Estado\: <span>&</span></p><br/>:}'   -e '/^parámetro/ {s:^parámetro *::;s:.*:<li class="parametro">&</li>:;s:[:]\s*([a-zA-Z]+):\: <span class="\1">\1<\/span>:}'   -e '/^retorno/ {s:^retorno *::;s:([a-zA-Z]+)[:,] *(.*):<h3>Retorno\: <span class="\1">\1</span></h3><p class="retorno">\2</p>:}' | sed -e 's/{{{INICIO_PARAMETROS}}}/<h3>Lista de parámetros<\/h3><ul>/' -e 's/{{{FIN_PARAMETROS}}}/<\/ul>/' -e 's/{{{FIN_FUNCION}}}/<\/div>/'  -e 's/{{{INICIO_FUNCION}}}/\n<div class="funcion"><small class="linkInicio"><a href="#inicio">[inicio]<\/a><\/small>/' | sed -r -n '1h;1!H;${g;s:</li>\n<(/div|h3)>:</ul><\1>:g;p;}'
	
	#Se agrega un pequeño pie de pagina 
	echo "<br/><br/><p style='text-align:center;padding:5px'><small>Este documento fue realizado usando <a href='http://github.com/gcosta87/bash/' target='_blank'>DocumentadorJS</a> v$DOCUMENTADORJS_VERSION</small></p></body></html>"
	
	rm "$ARCHIVO_PREPROCESADO"

else
	echo "No existe el archivo $1"
fi

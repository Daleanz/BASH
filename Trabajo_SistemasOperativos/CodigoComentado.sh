#!/bin/bash

# Colores --> Se declararon color en ASCII para poder hacer uso de ellos, y mostrar algunos echo importante en consola de manera mas clara.
rojo="\e[31m"
amarillo="\e[33m"
verde="\e[32m"
azul="\e[34m"
reset="\e[0m"

# Tipo de letra --> Se declara el formato en negrita, y se hara el mismo uso que los colores, van a estar combinados estos 2 para el mismo
# proposito.
negrita="\e[1m"

# Declaracion de las funciones.

Presentacion(){
  echo "*************************************** Datos del Grupo *************************************************************************"
  echo "Integrante 1: Jeison Salas Coloma --> Rut: 15.306.099-1"
  echo "Integrante 2: Roberto Barros Gutiérrez --> Rut: 20.759.294-3"
  echo "Integrante 3: David Moya Aravena --> Rut: 21.017.382-k"

  echo " "
  echo "Trabajo de BASH - Sistemas Operativos"
  echo "Profesor: Felipe Tirado"
  echo "---------------------------------------------------------------------------------------------------------------------------------"
}

# Primera Funcion: Esta se encarga de verificar si el archivo del cual se quiere hacer uso existe.
VerificarSiExisteArchivo(){
  archivo=$1 # Archivo que recibe por parametro la funcion.
  # Linea 29: se hace uso del operador (-f) para saber si nuestro archivo existe, y ademas para saber si es un archivo regular, osea que
  # no sea un directorio u otro tipo de archivos.
  if [ -f "$archivo" ]; then 
    # Mensaje correspondiente a mostrar cuando se verifique que SI existe el archivo.
    echo -e  "${verde} ${negrita} $archivo ---- SI existe. ${reset}"
    echo " "

    booleano=1 
    return $booleano
  else
    # Mensaje correspondiente a mostrar cuando se verifique que NO existe el archivo.
    echo -e "${rojo} ${negrita} $archivo ---- NO existe. ${reset}"
    echo " "

    booleano=0
    return $booleano
  fi # Cierre de la estructura condicional IF

  # Esta funcion retorna un valor (1 , 0), dependiendo del caso, esto solo se hara uso en la linea 138 para comprobar si el archivo existe
  # y mostrar un mensaje en la terminal para que el usuario sepa mas sobre lo que pasa con el archivo. 
} 

# Segunda Funcion: Se encarga de mostrar por la terminal el contenido del archivo que reciba por parametro.
MostrarContenidoArchivo(){
  echo "-------------------------------------------------------------------------------------------------------------------------------"
  archivo=$1 # Archivo que recibe por parametro la funcion.
  
  # Hacemos uso de un bucle while para poder mostrar el contenido del archivo.
  # Se hace uso de la instruccion (IFS=) para evitar que se recorten los espacios en blancos al leer las lineas del archivo.
  # read -r linea: (read) lee una linea del archivo y la almacena en la variable (linea), el (-r), ayuda a evitar que se modifiquen
  # los saltos de linea, tabulacion u otro caracter de "escape"
  # (-r) ayuda en este while a que se lea la linea tal cual viene escrita en el documento.
  # echo "$linea" mostrara la linea por consola.
  # done: da a conocer el final del while.
  # < "$archivo": (<) indica la reedireccion de entrada para el ciclo while, que aqui vendrian siendo las lineas contenidas en el archivo
  # especificado con ("$archivo"), las (" ") se hacen uso de ellas para asegurar que el contenido de la variable se interprete correctamente
  # en otras palabras evitar posibles errores en la compilacion.
  while IFS= read -r linea
  do
    echo "$linea"
  done < "$archivo"

  echo "-------------------------------------------------------------------------------------------------------------------------------"
  echo " "
}

# Tercera Funcion: se encarga de generar copias de transicion, para poder llegar al archivo final el cual se denomino como (TextoFinal.txt),
# el que constara con los siguientes cambios:
#   1 - Todas las letras pasadas a minusculas.
#   2 - Reemplazo de las vocales acentuadas por sus pares sin acentos.
#   3 - Eliminacion de los signos de puntuacion.
# Todas las copias y el archivo final se generaran en el Directorio: /home/usuario/Escritorio
# Tambien esta funcion genera las copias, pero cuando ya no sea necesario su uso las eliminara y solo mantendra el archivo original y el final.
GenerarCopiaDelArchivo(){
  # archivo: archivo recibido por parametro en la funcion.
  # archivoCopia: primer archivo de transicion.
  # archivoCopia1: segundo archivo de transicion.
  # archivoFinal: archivo ya con todas las modificaciones.
  archivo=$1
  archivoCopia="CopiaArchivo.txt"
  archivoCopia1="CopiaArchivo1.txt"
  archivoFinal="TextoFinal.txt"

  # Linea 96, se hace uso de la funcion (basename) para poder obtener el nombre del archivo pasado por parametro en la funcion, y almacenarlo
  # en la variable (nombreArchivo)
  nombreArchivo=$(basename "$archivo")
  echo "Nombre del archivo es $nombreArchivo"

  # Linea 100: se procede a crear una copia del archivo original (primer archivo de transicion).
  cp "$archivo" "$archivoCopia"
  # Llamamos a la funcion VerificarSiExisteArchivo para combrobar que se haya creado correctamente el primer archivo de transicion.
  VerificarSiExisteArchivo "$archivoCopia"
  
  # Linea 107: hacemos uso de la funcion (cat) se usa en conjunto con la funcion (sed), para poder generar la primera modificacion, que es 
  # el reemplazo de las vocasles acentuadas por sus pares sin acentos (se tienen en cuenta las MAYUS y la MINUS), y finalmente se copiara
  # (guardar) el archivo modificado en el primer archivo de transicion (CopiaArchivo.txt).
  cat $nombreArchivo | sed 's/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g;
                         s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g;' > CopiaArchivo.txt

  # Linea 111: se genera el segundo archivo de transicion.
  cp "$archivoCopia" "$archivoCopia1" 

  # Linea 118: se hace uso del comando (awk), la cual sirve para procesar y manipular datos en archivos de textos, en esta caso
  # usamos el script (´{print tolower($0)}) de (awk), el cual se encarga de leer cada linea y convertirla en minusculas haciendo
  # uso de la funcion (toloweri()).
  # como argumentos se pasan los archivos: "$archivoCopia"(primer archivo de transicion) que es del que se scaran y procesaran las lineas,
  # para finalmente almacenar los cambios que hara el script en el archivo "$archivoCopia1" (segundo archivo de transicion). 
  awk '{print tolower($0)}' "$archivoCopia" > "$archivoCopia1"

  # Se vuelve a llamar a la funion VerificarSiExisteArchivo para ver si es que se creo el segundo archivo de transicion correctamente.
  VerificarSiExisteArchivo "$archivoCopia1"

  # Linea 127 : hacemos uso de la funcion (cat) en conjunto de la funcion (tr -d) haciendo uso del operador de tuberia (|), esto lo que hace
  # es pasar por (" "), los simbolos, en este caso son los de puntuacion los cuales seran eliminados, (>) redirige la salida del comando
  # aplicadio anteriormente hacia el archivo final "TextoFinal.txt", el que contendra ya la ultima modificacion, para solo tener las palabras
  # en el archivo.
  cat CopiaArchivo1.txt | tr -d '.,:;¿?¡!+-_*"(){}[]=#$%&/' > TextoFinal.txt

  # Se eliminan los dos archivos de transicion creados anteriormente, ya que no se seguiran utilizando.
  rm "$archivoCopia"
  rm "$archivoCopia1"

  # Verificamos si se eliminaron los archivos de transicion, y si se copio correctamente el archivo final "TextoFinal.txt".
  VerificarSiExisteArchivo "$archivoCopia"
  VerificarSiExisteArchivo "$archivoCopia1"
  VerificarSiExisteArchivo "$archivoFinal"
 
  echo " "
  echo -e "${azul} ${negrita} Contenido a Minusculas, sin Acentos y sin signos de Puntuacion ${reset}"
  #MostrarContenidoArchivo $archivoFinal

}

# Cuarta Funcion: se encarga de obtener y mostrar las palabras que mas se repiten en el archivo de texto, se hace uso de un vector para 
# almacenar las palabras con mas frecuencia, luego se hace uso de otro vector el que almacena la frecuencia de estas palabras, para
# finalmente ser mostrada la informacion en consola para el usuario.
ObtenerFrecuenciasPalabras(){
  archivo=$1 # archivo recibido por parametro.
  MostrarContenidoArchivo $archivo

  # Linea 172: hacemos uso de la funcion (cat) en conjunto con las siguientes funciones (tr -s)(grep -oE '\w{2,}')(sort)(uniq -c)(sort -nr)
  # (head -n 10)(awk '{printn $2}') tambien junto con el operador de tuberia (|).
  # Explicacion de las funciones:
  #   1 - (tr -s): reemplazara toda secuencia de espacios en blancos por saltos de linea.
  #   2 - (grep -oE): grep es un comando de bash, el cual se usa para buscar y filtrar lineas de textos que coinciden con un patro que se
  #                   le especifique, (-o) es una opcion de (grep) que indicara que se muestren solo las palabras que coincidan con el patron
  #                   en lugar de mostrar la linea completa, (E), esta es una opcion la cual habilita el uso de expresiones regulares extendidas
  #                   la cual sirve para poder definir patrones especiales de busquedas, (\w{2,}) es el patron de busqueda del cual hacemos uso
  #                   (w) representa un caracter de palabra, (2,) hace referencia a que la palabra debe contener al menos dos caracteres
  #                   concecutivos, ( es decir las letras unitarias no se tomaran como palabra ), el largo de la cadena debe ser mayor que 0.
  #   3 - sort: funcion que se encarga de ordenar las palabras en orden alfabetico.
  #   4 - uniq -c: cuenta el numero de veces que aparece la palabra en el archivo, y tambien muestra la cantidad que aparece junto a la palabra
  #                en nuestro caso no lo hicimos asi, porque lo decimos almacenar en un vector, para luego al mostrar en consola, sea de manera
  #                mas clara y ordenada para el usuario.
  #   5 - sort -nr: hacemos uso de (sort), el cual ordena las palabras, pero aqui en conjunto con (-nr), el cual permitira ordenar
  #                 las palabras que mas veces aparacen en orden descendente.
  #   6 - head -n 10: mostrara las 10 primeras lineas, que en este caso seran las 10 primeras palabras mas frecuentes, que decimos almacenar
  #                   en un vector para despues mostrar en consola.
  #   7 - awk '{print $2}': hacemos uso del script ('{print $2}') de (awk), para solo poder almacenar las palabras en el vector.
  # Linea 173: hacemos uso de todo lo anterior pero a diferencia del punto (7), ahora hacemos uso del script ('{print $1}') de (awk), la cual
  # nos permite capturar la cantidad de veces que aparecen las palabras en el archivo, y asi almacenarlas en otro vector.
  PalabrasFrecuentes=($(cat "$archivo" | tr -s '[:space:]' '\n' | grep -oE '\w{2,}' | sort | uniq -c | sort -nr | head -n 10 | awk '{print $2}'))
  Frecuencia=($(cat "$archivo" | tr -s '[:space:]' '\n' | grep -oE '\w{2,}' | sort | uniq -c | sort -nr | head -n 10 | awk '{print $1}'))
 
  echo -e "${amarillo} ${negrita} Las palabras con mas frecuencia del archivo $archivo son: ${reset}"
  echo " "

  # Se hace uso del ciclo for para poder recorrer 2 vectores al mismo tiempo, el vector de las palabras mas repetidas y el vector que almaceno
  # la cantidad de veces que aparecen las palabras en el archivo.
  # En el argumento del for, solo ponemos que recorra un vector ya que los 2 vectores creados antes tienen la misma cantidad de elementos.
  # Iniciamos la variable iteradora (i = 0), y se ejecutara mientras (i) sea menor al len del vector pasado en el argumento, si se cumple
  # (i) se incrementara en (1) unidad.
  #[@]: indica que queremos acceder a todos los elementos del vector pasado en argumento.
  # #: lo usamos en el argumento del for, en este caso no hace alusion a un comentario, sino que es parte de la sintaxis para poder
  #   obtener el largo (rango), del vector pasado en el argumento, para que (i) se pueda ir iterando.
  # Vector[i]: basicamente (i) esta tomando el valor que se encuentra en ese indice, para asi poder mostrarlo en consola con un "echo".
  # done: con esto finalizamos el ciclo for.
  # Tambiens hace uso de (echo -e), donde (-e) se hace uso para representar y aplicar acciones de formato de texto para mostrar en consola, 
  # donde usamos los colores y el formato en "negrita"
  for ((i=0; i<${#PalabrasFrecuentes[@]}; i++))
  do
    echo -e "La $((i + 1)) palabra ${verde}${negrita}[${PalabrasFrecuentes[i]}]${reset} se repite: ${azul}${negrita}${Frecuencia[i]}${reset} veces."
  done

  echo " "
}

# Quinta Funcion: se encarga de obtener las las letras que se repiten con mas frecuencia en el archivo, ademas tambien obtener la frecuencia
# de cada una de ellas, crea dos vectores donde el primer vector almacena las letras mas repetidas y el segundo vector almacena la
# frecuencia de estas letras en el archivo de texto, para finalmente hacer uso de un ciclo for con el que se mostrara la informacion por
# consola al usuario.
ObtenerFrecuenciasLetras(){
  archivo=$1 # archivo recibido por parametro. # archivo recibido por parametro. # archivo recibido por parametro. 

  # Para el primer vector, como tiene muchas funciones ya descritas en la funcion anterior, se explicaran las nuevas que son: 
  #   1 - (tr -s): en este caso esta eliminar los espacios en blancos adicionales y las reemplazara por un solo espacio.
  #   2 - (grep -o .): hacemos uso de la funcion (grep) en conjunto (-o) y tambien seguido de (.), que ordenara cada caracter en una linea 
  #                   separada.
  #   3 - awk: para el primer vector usaremos el script ('{print $2}'), para almacenar los caracteres mas repetidos en el, en el segundo
  #           vector usaremos el script ('{print $1}'), para almacenar la cantidad de veces que se repiten los caracteres mas repetidos del
  #           archivo de texto.
  LetrasFrecuentes=($(cat "$archivo" | tr -s '[:space:]' | grep -o . | sort | uniq -c | sort -nr | head -n 6 | awk '{print $2}'))
  Frecuencia=($(cat "$archivo" | tr -s '[:space:]' | grep -o . | sort | uniq -c | sort -nr | head -n 5 | awk '{print $1}'))

  echo -e "${amarillo} ${negrita} Las letras con mas frecuencia del archivo $archivo son: ${reset}"
  echo " "

  # Hacemos uso de un ciclo for, posee la misma estructura que el for de la funcion anterior, asique funciona de la misma manera, solo que
  # este mostrara los caracteres mas frecuentes junto a la cantidad que aparece dicho caracter en el archivo de texto.
  # done: con esto finalizamos la estructura del ciclo for.
  for ((i=0; i<${#LetrasFrecuentes[@]}; i++))
  do
    echo -e "La $((i + 1)) letra ${verde}${negrita}[${LetrasFrecuentes[i]}]${reset} se repite: ${azul}${negrita}${Frecuencia[i]}${reset} veces."
  done
}

# Llamada de las funciones.
Presentacion
#--------------------------------------------
# Esteblecemos una variable la cual almacenara el nombre del archivo que queramos modificar, este sera ingresado por consola, se hizo esto para evitar estar cambiando el nombre
# en cada linea donde se necesite el archivo.
echo -e "${amarillo}${negrita}Ingresa el nombre del archivo: ${reset}"
read nombreArchivo

nombreDelArchivo=$nombreArchivo
# Se llama a la funcion VerificarSiExisteArchivo para ver si existe el archivo.
VerificarSiExisteArchivo "$nombreDelArchivo"
contador=$?

# Se hace uso de una estructura condicional, que dependera del valor que obtenga el contador, el cual sera el valor que retorne la funcion
# VerificarSiExisteArchivo y contador haciendo uso de ($?) almacenara el dato retornado por la funcion, que se definio al principio como
# booleano = 1, o booleano = 0, dependiendo del caso.
if [ "$contador" -eq 1 ]; then
  # Si se cumple la condicion se ejecutaran las funciones necesarias ya programadas y se mostrara el contenido final modificado.
  echo -e "${azul} ${negrita} Contenido del archivo original: $nombreDelArchivo ${reset}"
  MostrarContenidoArchivo "$nombreDelArchivo"
  GenerarCopiaDelArchivo "$nombreDelArchivo"
  ObtenerFrecuenciasPalabras TextoFinal.txt
  ObtenerFrecuenciasLetras TextoFinal.txt
else
  echo -e "${rojo} ${negrita} El archivo no se encontro. ${reset}"
fi

echo " "
echo -e "${rojo} ${negrita} Cerrando programa... ${reset}"

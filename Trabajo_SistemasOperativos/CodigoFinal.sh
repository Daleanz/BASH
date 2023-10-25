#!/bin/bash

Presentacion(){
  echo "*************************************** Datos del Grupo *************************************************************************"
  echo "Integrante 1: Jeison Salas Colma --> Rut: 15.306.099-1"
  echo "Integrante 2: Roberto Barros Gutiérrez --> Rut: 20.759.294-3"
  echo "Integrante 3: David Moya Aravena --> Rut: 21.017.382-k"

  echo " "
  echo "Trabajo de BASH - Sistemas Operativos"
  echo "Profesor: Felipe Tirado"
  echo "---------------------------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------- DECLARACION DE FUNCIONES --------------------------------------------------------
# Primera Funcion: Verifica si el archivo del cual queremos hacer uso existe (Archivo ingresado por parametro), mostrara mensajes correspondientes a si existe o no existe.
#                  Tambien retorna un (1) o (0), donde se le hara uso en la linea 193.
VerificarSiExisteArchivo(){
  archivo=$1 
  # Linea 29: se hace uso del operador (-f) para saber si nuestro archivo existe, y ademas para saber si es un archivo regular.
  if [ -f "$archivo" ]; then 
    echo "$archivo ---- SI existe."
    echo " "
    booleano=1 
    return $booleano

  else
    echo "$archivo ---- NO existe."
    echo " "
    booleano=0
    return $booleano
  fi
} 

# Segunda Funcion: Esta mostrara el contenido en la terminal, el archivo sera recibido por parametro, utilizando un ciclo while y la funcion (read) para leer cada linea del documento.
#                  Hace uso de la instruccion (IFS=), que es para evitar que se recorten los espacios en blancos.
#                  Hace uso de de la opcion (-r), ayuda a que se lea la linea tal cual viene en el documento.
#                  Hace uso del operador(<) para redireccional la entrada para el ciclo while, en este caso son las lineas del documento.
#                  Hace uso de (" ") para poder evitar posibles errores de compilacion.
#
MostrarContenidoArchivo(){
  echo "-------------------------------------------------------------------------------------------------------------------------------"
  archivo=$1  
  while IFS= read -r linea
  do
    echo "$linea"
  done < "$archivo"

  echo "-------------------------------------------------------------------------------------------------------------------------------"
  echo " "
}

# Tecera Funcion: Generara copias de transicion, para poder llegar al archivo final denominado (TextoFinal.txt), el cual tendra las sigueintes modificaciones:
#                             1 - Todas las letras pasadas a minusculas.
#                             2 - Reemplazo de las vocales acentuadas pro sus pares sin acentos.
#                             3 - Eliminacion de los signos de puntuacion.
#                 Tambien cuando no sea necesario el uso de las copias de transicion, estas seran eliminadas.
GenerarCopiaDelArchivo(){
  archivo=$1
  archivoCopia="CopiaArchivo.txt"
  archivoCopia1="CopiaArchivo1.txt"
  archivoFinal="TextoFinal.txt"

  # Linea 96, se hace uso de la funcion (basename) para poder obtener el nombre del archivo pasado por parametro en la funcion, y almacenarlo
  # en la variable (nombreArchivo)
  nombreArchivo=$(basename "$archivo")
  echo "Nombre del archivo es $nombreArchivo"

  # Se usa el comando (cp) para generar el primer archivo de transicion.
  cp "$archivo" "$archivoCopia"
  VerificarSiExisteArchivo "$archivoCopia"
  
  # Se hace uso del comando (cat) en conjunto con el comando (sed), para poder realizar el reemplazo de las vocales acentuadas por sus pares sin acentos, la modificacion quedara guardada
  # en el primer archivo de transicion.
  cat $nombreArchivo | sed 's/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g;
                            s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g;
                            s/ä/a/g; s/ë/e/g; s/ï/i/g; s/ö/o/g; s/ü/u/g;
                            s/Ä/A/g; s/Ë/E/g; s/Ï/I/g; s/Ö/O/g; s/Ü/U/g/U/gm;   ' > CopiaArchivo.txt

  # Se usa el comando (cp) para generar el segundo archivo de transicion.
  cp "$archivoCopia" "$archivoCopia1" 

  # Se hace uso del script(print tolower($0)) de la herramienta (awk), para poder convertir cada linea del documento en minusculas,
  # se pasa el archivo a modificar y el archivo donde se guardara el cambio.
  awk '{print tolower($0)}' "$archivoCopia" > "$archivoCopia1"

  VerificarSiExisteArchivo "$archivoCopia1"

  # Linea 127 : hacemos uso de la funcion (cat) en conjunto de la funcion (tr -d) haciendo uso del operador de tuberia (|), esto lo que hace
  # es pasar por (" "), los simbolos, en este caso son los de puntuacion los cuales seran eliminados, (>) redirige la salida del comando
  # aplicadio anteriormente hacia el archivo final "TextoFinal.txt", el que contendra ya la ultima modificacion, para solo tener las palabras
  # en el archivo.
  #
  # Se hace uso de los comandos en conjunto (cat y tr), donde se pasa el archivo a modificar y donde (tr) hara uso de la opcion (-d) para poder eliminar los "signos de puntuacion" en este caso, 
  # para finalmente almacanear la modificacion en el archivo final.
  cat CopiaArchivo1.txt | tr -d '.,:;¿?¡!+-_*"(){}[]=#$%&/' > TextoFinal.txt

  # Se hace uso del comando (rm) para poder eliminar los archivos de transicion anteriormente creados.
  rm "$archivoCopia"
  rm "$archivoCopia1"

  # Verificamos si se eliminaron los archivos de transicion, y si se copio correctamente el archivo final "TextoFinal.txt".
  VerificarSiExisteArchivo "$archivoCopia"
  VerificarSiExisteArchivo "$archivoCopia1"
  VerificarSiExisteArchivo "$archivoFinal"
 
  echo " "
  echo "Contenido a Minusculas, sin Acentos y sin signos de Puntuacion"
}

# Cuarta Funcion: Obtendra y mostrara por la terminal las palabras que mas se repiten en el documento junto a su frecuencia correspondiente,
#                 Hara uso de un vector para almacenar las palabras mas repetidas.
#                 Hara uso de otro vector para almacenar la frecuencia de las palabras.
ObtenerFrecuenciasPalabras(){
  archivo=$1
  MostrarContenidoArchivo $archivo

  # Se crea el vector "PalabrasFrecuentes", donde se igualara al comando (cat) donde este comando trabajara en conjunto con varios comandos:
  #     - Uso del comando (grep), que utilizara las opciones (-o) y (E), donde (E) habilita el uso de expresiones regulares y se hara uso del 
  #       patron de busqueda (\w{2,}), mientras (-o) solo mostrara la parte de la linea que coincide con el patron de busqueda.
  #     - Uso del comando (sort) para poder ordenar las lineas de texto.
  #     - Uso del comando (uniq) junto a la opcion (-c), que contara la frecuencia de las palabras en el documento.
  #     - Uso del comando (head) junto a la opcion (-n), donde mostrara en este caso las 10 palabras mas frecuentes.
  #     - Uso de l script (print $2) de la herramienta (awk), para poder obtener en este caso la segunda columna, la cual seran las palabras frecuentes,
  #       para que se almacenen en el vector "PalabrasFrecuentes"
  # Se crea el vector "Frecuencia", la unica diferencia al uso de los comandos y opciones del vector "PalabrasFrecuentes" es:
  #     - Uso del script (print $1) de la herramienta (awk), que es pa obtener los elementos de la primera columna en este caso, que viene siendo
  #       la cantidad de veces que se repiten la palabras y almacenarlas en el vecto "Frecuencia".
  PalabrasFrecuentes=($(cat "$archivo" | tr -s '[:space:]' '\n' | grep -oE '\w{2,}' | sort | uniq -c | sort -nr | head -n 10 | awk '{print $2}'))
  Frecuencia=($(cat "$archivo" | tr -s '[:space:]' '\n' | grep -oE '\w{2,}' | sort | uniq -c | sort -nr | head -n 10 | awk '{print $1}'))
 
  echo "Las palabras con mas frecuencia del archivo $archivo son:"
  echo " "

  # Se hace uso de un bucle (for), para poder ir recorriendo el vector "Palabras Frecuentes" y "Frecuencia" ya que tienen el mismo rango,
  #     - Uso del (#) para poder obtener la cantidad de elementos del vector.
  #     - Uso del (@) para poder acceder a todos los elementos del vector.
  # Finalmente se mostrara por la terminal la informacion.
  for ((i=0; i<${#PalabrasFrecuentes[@]}; i++))
  do
    echo "La $((i + 1)) palabra [${PalabrasFrecuentes[i]}] se repite: ${Frecuencia[i]} veces."
  done

  echo " "
}

# Quinta Funcion: se encarga de obtener las las letras que se repiten con mas frecuencia en el archivo, ademas tambien obtener la frecuencia
# de cada una de ellas, crea dos vectores donde el primer vector almacena las letras mas repetidas y el segundo vector almacena la
# frecuencia de estas letras en el archivo de texto, para finalmente hacer uso de un ciclo for con el que se mostrara la informacion por
# consola al usuario.
#
# Quinta Funcion: Obtendra y mostrara las letras que mas se repiten del documento junto a su frecuencia correspondiente.
#                 Hara uso de un primer vector el cual almacenara las palabras mas repetidas del documento.
#                 Hara uso de un segundo vector el cual almacenara la frecuencias de las palabras mas repetidas del documento.
ObtenerFrecuenciasLetras(){
  archivo=$1 

  # Para el primer vector, como tiene muchas funciones ya descritas en la funcion anterior, se explicaran las nuevas que son: 
  #   1 - (tr -s): en este caso esta eliminar los espacios en blancos adicionales y las reemplazara por un solo espacio.
  #   2 - (grep -o .): hacemos uso de la funcion (grep) en conjunto (-o) y tambien seguido de (.), que ordenara cada caracter en una linea 
  #                   separada.
  #   3 - awk: para el primer vector usaremos el script ('{print $2}'), para almacenar los caracteres mas repetidos en el, en el segundo
  #           vector usaremos el script ('{print $1}'), para almacenar la cantidad de veces que se repiten los caracteres mas repetidos del
  #           archivo de texto.
  #
  # La unica diferencia con respecto a la funcion "ObtenerFrecuanciaPalabras", es que esta funcion solo obtendra y mostrara las primeras 5 letras.
  # Tambien hara uso de los mismos comandos y opciones, a diferencia del comando:
  #     - (grep) el que hara uso de la opcion (-o) y (.) donde el punto es una expresion regular y en este caso separa cada caracter linea a linea, para
  #       luego contar la frecuencia de cada caracter en el documento.
  # Funcionamiento para los vectores igual al de la funcion "ObtenerFrecuenciasPalabras"
  LetrasFrecuentes=($(cat "$archivo" | tr -s '[:space:]' | grep -o . | sort | uniq -c | sort -nr | head -n 6 | awk '{print $2}'))
  Frecuencia=($(cat "$archivo" | tr -s '[:space:]' | grep -o . | sort | uniq -c | sort -nr | head -n 5 | awk '{print $1}'))

  echo "Las letras con mas frecuencia del archivo $archivo son:"
  echo " "

  for ((i=0; i<${#LetrasFrecuentes[@]}; i++))
  do
    echo -e "La $((i + 1)) letra [${LetrasFrecuentes[i]}] se repite: ${Frecuencia[i]} veces."
  done
}

# Llamada de las funciones.
Presentacion
#--------------------------------------------
# Se crea la variable (nombreArchivo) la cual almacenara el nombre del archivo ingresado por el usuario.
echo  "Ingresa el nombre del archivo:"
read nombreArchivo

nombreDelArchivo=$nombreArchivo

VerificarSiExisteArchivo "$nombreDelArchivo"
contador=$?

# Se hace uso de una estructura condicional, que dependera del valor que obtenga el contador, el cual sera el valor que retorne la funcion
# VerificarSiExisteArchivo y contador haciendo uso de ($?) almacenara el dato retornado por la funcion, que se definio al principio como
# booleano = 1, o booleano = 0, dependiendo del caso.
#
# Se crea una variable (contador) la cual hace uso de la variable espcial ($?) la cual almacenara el valor de retorno de la funcion "VerificarSiExisteArchivo",
# para luego ser usado en la estructura condicional (If, else), para poder mostrar de manera mas clara la informacion al usuario.
if [ "$contador" -eq 1 ]; then
  # Si se cumple la condicion se ejecutaran las funciones necesarias ya programadas y se mostrara el contenido final modificado.
  echo "Contenido del archivo original: $nombreDelArchivo"
  MostrarContenidoArchivo "$nombreDelArchivo"
  GenerarCopiaDelArchivo "$nombreDelArchivo"
  ObtenerFrecuenciasPalabras TextoFinal.txt
  ObtenerFrecuenciasLetras TextoFinal.txt
else
  echo  "El archivo no se encontro."
fi

echo " "
echo  "Cerrando programa..."

#Este script de Bash realiza una tarea muy simple:

Recibe dos argumentos en la línea de comandos: el nombre de un archivo de entrada ($1) y el nombre de un archivo de salida ($2).
Lee línea por línea el archivo especificado como argumento de entrada ($1) utilizando el comando cat.
Para cada línea leída del archivo de entrada, el script toma esa línea y la convierte en su equivalente en Base64 utilizando el comando base64.
El resultado de cada conversión se agrega al archivo especificado como argumento de salida ($2) utilizando el operador de redirección >>, que agrega contenido al final del archivo sin borrar el contenido existente. Cada línea convertida se agrega como una nueva línea en el archivo de salida.


#!/bin/bash

for i in $(cat $1); do
        echo $i | base64 >> $2
done



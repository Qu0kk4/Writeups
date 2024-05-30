Es un script echo en bash, este se utiliza en el reporte de nmap para poder extraer los puertos cuando son bastante.

El formato tiene que ser un archivo.txt.

````bash
#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Uso: $0 archivo.txt"
  exit 1
fi

# Verificar si el archivo existe
if [ ! -f "$1" ]; then
  echo "El archivo $1 no existe."
  exit 1
fi

# Procesar el archivo, extraer solo los números al principio de cada línea y eliminar letras
result=$(grep -oE '^[0-9]+' "$1" | tr '\n' ',')

# Eliminar la última coma
result=${result%,}

# Mostrar el resultado
echo "$result"
````

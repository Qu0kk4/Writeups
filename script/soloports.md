Es un script echo en bash, este se utiliza en el reporte de nmap para poder extraer los puertos cuando son bastante.

El formato tiene que ser un archivo.txt.

````bash
#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Uso: $0 archivo.txt"
  exit 1
fi

# Verifica si el archivo existe
if [ ! -f "$1" ]; then
  echo "El archivo $1 no existe."
  exit 1
fi

# Procesa el archivo.txt, extrae solo los números al principio de cada línea y elimina las letras
result=$(grep -oE '^[0-9]+' "$1" | tr '\n' ',')

# Elimina la última coma
result=${result%,}

# Imprima el resultado
echo "$result"
````

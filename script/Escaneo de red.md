## Script basico de redes internas para CTF u otros casos.

## Para su uso, en caso de que tenga otro rango de IP modifiquen el script antes de lanzarlo.

````bash
#!/bin/bash

# Función para imprimir el banner
imprimir_banner() {
    echo -e "\e[1;34m"  # Cambiar el texto a color azul brillante
    echo "a/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\a"
    echo "        QuokkaScanred       "
    echo "a/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\a"
    echo -e "\e[0m"  # Restablecer los colores a los valores predeterminados
}

# Función para manejar la señal SIGINT (Ctrl+C)
function control_c() {
    echo -e "\n¡Tool detenida!"
    exit 1
}

# Asociar la función control_c() al manejo de la señal SIGINT
trap control_c SIGINT

# Llamar a la función para imprimir el banner
imprimir_banner

# Bucle para hacer ping a las IPs del rango 192.168.0.1 a 192.168.0.255
for i in {1..255}; do
    timeout 1 bash -c "ping -c 1 192.168.0.$i" >/dev/null
    if [ $? -eq 0 ]; then
        echo "El host 192.168.0.$i encontrado"
    fi
done

````

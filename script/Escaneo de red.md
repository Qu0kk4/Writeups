````bash
#!/bin/bash

# Función que se ejecuta al recibir SIGINT (Ctrl+C), La función finish imprime un mensaje y sale del script si el estado 0.
finish() {
    echo -e "\n[*] Cerrando el script..."
    exit 0
}

# Configura la trampa para SIGINT.
trap finish SIGINT

# Solicita la dirección IP de la victima.
read -p "Introduce la IP: " ip_address

# Verifica que se haya ingresado una IP victima.
if [ -n "$ip_address" ]; then
    # Escanea todos los puertos del 1 al 65535.
    for port in $(seq 1 65535); do
        # Intenta conectarse al puerto; si tiene éxito, muestra que está abierto.
        (echo > /dev/tcp/$ip_address/$port) 2>/dev/null && echo "[*] Puerto $port - Abierto" &
    done
    # Espera a que todos los procesos en segundo plano terminen.
    wait
fi
````

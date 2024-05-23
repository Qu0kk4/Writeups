## Maquina Flower

Hacemos un escaneo de red para ver que ip estan conectadas a nuestra maquina, para ello vamos a utilizar lo siguientes comandos:

````bash
netdiscover -i eth0 y -r ip

**netdiscover:**

- `netdiscover -i eth0`: Este comando ejecuta el escaneo de red en la interfaz de red especificada (`eth0` en este caso). Utiliza ARP (Protocolo de Resolución de Direcciones) para descubrir y mostrar hosts activos en la red local.
- `netdiscover -r IP`: Este comando escanea una red específica especificada por la dirección IP y su máscara de subred (ejemplo: `192.168.1.0/24`). Descubre y muestra los hosts activos en esa red.

arp-scan -I eth0 --localnet

**arp-scan:**

- `arp-scan -I eth0 --localnet`: Este comando ejecuta un escaneo ARP en la interfaz de red especificada (`eth0`) para descubrir hosts en la red local. La opción `--localnet` indica que se escaneará la red local donde está conectada la interfaz especificada.
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20175014.png)


![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20175040.png)

# Maquina Friendly B)
![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-02%20212326.png)

Realizamos un escaneo de red con arp-scan para ver las maquinas conectadas, luego le lanzamos un ping a la maquina que vamos a comprometer, segun el ttl nos damos cuenta si estamos ante una maquina linux si es ttl 64 o si es un ttl 128 es windows.

>arp-scan -i eth0 --localnet


Con nmap utilizamos el siguiente el comando:
>nmap -sC -sV ip -oN target.txt` 


## Imagen Inspiradora
Aquí tienes una imagen que resume la esencia de mi proyecto:

![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/Captura%20de%20pantalla%202024-03-11%20153825.png)

¡Espero que disfrutes explorando mi proyecto tanto como yo disfruté creándolo!



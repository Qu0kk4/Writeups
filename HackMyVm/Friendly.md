# Maquina Friendly B)
![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-02%20212326.png)

Realizamos un escaneo de red con arp-scan para ver las maquinas conectadas, luego le lanzamos un ping a la maquina que vamos a comprometer, segun el ttl nos damos cuenta si estamos ante una maquina linux si es ttl 64 o si es un ttl 128 es windows.
>arp-scan -i eth0 --localnet

![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/1.png)

Con nmap utilizamos el siguiente el comando:
>nmap -p --open -A -T5 -O "IP" -oN nombre.txt

![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-02%20203501.png)

Vemos que tenemos los puertos 21 "ftp y el 80 "http", lo siguiente es ingresar al servicio ftp ya que podemos loguearnos como anonimo.
Dentro del FTP encontramos un archivo llamado index.html, lo descargamos a nuestra maquina atacante.
>ftp "IP"

![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-02%20203448.png)



## Imagen Inspiradora
Aquí tienes una imagen que resume la esencia de mi proyecto:

![Imagen]()

¡Espero que disfrutes explorando mi proyecto tanto como yo disfruté creándolo!



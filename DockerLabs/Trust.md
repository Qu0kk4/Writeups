## MAQUINA TRUST DOCKERLABS

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20133430.png)

Comenzamos haciendo un escaneo de puertos y servicios utilizando nmap, en nuestro caso vamos a usar los siguiente comandos:

````console
nmap -p- -sS --open --min-rate 5000 -vvv -n -Pn 172.17.0.3 -oN escaneo.txt 
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20133023.png)

Este resultado es sencillo no nos da mucha info, asi que vamos hacer un escaneo mas detallado

````console
nmap -p22,80 -sC -sV -O 172.17.0.3 -oN fullscan.txt
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20133035.png)

Este escaneo nos da un poquito mas de info, vemos que en el servicio web que corre por el puerto 80, hay un apache y que contiene una pagina por default.

¿Que podemos hacer ahora?, Vamos a buscar rutas ocultas dentro del servidor web, para ello usamos la herramienta gobuster.

````console
gobuster dir -u http://172.17.0.3 -w /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-1.0.txt -x php,html,txt
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20133522.png)

La herramienta encontro una ruta llamada /secret.php, asi que ingresamos a ella.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20133247.png)

Como dice el contenido de la web, "esta web no se puede hackear" por lo que me huele a raro.. si nos ponemos a pensar tenemos el puerto 22 el servicio ssh abierto.

Usamos hydra para hacer fuerza bruta ssh utilizando el usuario mario.

````console
hydra -l mario -P /usr/share/wordlists/rockyou.txt ssh://172.17.0.3 -t 10
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20134512.png)

Hydra encontro una contraseña, asi que nos logeamos atravez del ssh con estas credenciales.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20134600.png)

Una vez adentro somos el usuario mario, ahora vamos a buscar la manera de tener los privilegios maximos de esta maquina
Para ello probamos con sudo -l y obtuvimos lo siguiente.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20134643.png)

Vim, puede ser ejecutado por cualquier usuario osea que por root tambien.. asi que buscamos la forma de poder usar vim para escalar privilegios y tener control total de la maquina.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20134905.png)

Usamos la opcion "a" y la enviamos, acuerdense de ir a la ruta /usr/bin/vim

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20134924.png)

SOMOS ROOT! 




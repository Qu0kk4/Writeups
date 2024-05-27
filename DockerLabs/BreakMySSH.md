## MAQUINA DE DOCKERLABS

Con nmap hacemos un escaneo de puertos para ver cuales se encuentran abiertos

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20165445.png)

Solo tenemos el puerto 22 abierto, si buscamos un poco de info en google, vemos que es vulnerable a una enumeracion de usuarios.

Podemos comprobarlos con searchsploit y utilizar tanto esto como metasploit, pero en nuestro caso no.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20165454.png)

Lo que vamos a hacer es utilizar hydra para hacer fuerza bruta

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20173814.png)

Hydra nos encontro una contraseña, asi que mediante el ssh entramos sin proporcionar usuario y listo, somos root.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20173727.png)

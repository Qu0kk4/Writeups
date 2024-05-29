## Writeup Crossroads HMV

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20214353.png)

Realizamos un escaneo de red para ver las maquinas conectadas a nuestra red.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20185917.png)

Luego lanzamos un ping  a la maquina que vamos a atacar para ver si tenemos conectividad.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20185943.png)


Una vez obtenida la ip y verificar que tenemos conexion con ella vamos a lanzar con nmap un escaneo para ver los puertos abiertos y que corren en ellos:

```console
nmap -p- --open -sS --min-rate 4000 -vvv -n -Pn ip -oN target.txt
```
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20190059.png)

Luego lanzamos un escaneo para ver mas detalladamente las versiones que corren en cada uno de los servicios.

```console
nmap -sC -sV IP 
```
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20190337.png)

Tenemos el puerto 80, 139 y 445 corriedo por la maquina.

Entramos a la pagina web para ver el contenido

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-28%20224634.png)

Buscamos un poco de informacion sobre la pagina usando el wappalyzer.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20191615.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20191542.png)

Ahora usamos whatweb.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20192332.png)

Con gobuster vamos a buscar directorios ocultos en la web.

```console
gobuster --url ip -w wordlists -t 100
```
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20193209.png)

Como resultado tenemos un note.txt y un robots.txt

Ahora como tenemos el puerto 445 smb abierto. vamos a usar smbmap y smbclient para ver los archivos que contienen dentro.

```console
smbclient -L ip
smbmap -H ip
````
SMBCLIENT

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20191019.png)

SMBMAP

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20191211.png)

Con smbmap vemos que no podemos acceder a los archivos compartidos, lo siguiente es usar otra herramienta de enumeracion llamada enum4linux .

```console
enum4linux -a ip
```
Esta herramienta nos proporciona mucha info, detro de esa info nos muestra que hay un usuarios llamado albert.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20195726.png)

Ahora que tenemos un usuario, usamos metasploit para hacer fuerza bruta al protoclo smb para sacar alguna pass valida.

Completamos las opciones de metasploit y en este caso usamos el diccionario rockyou.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20203046.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20203025.png)

Listo ya tenemos la contraseña del usuario albert:bradley1

Volvemos a smbmap para entrar con la credencial al servicio smb y podemos ver que tenemos 
acceso a la carpeta smbshares.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20203552.png)

Tambien podemos ver lo mismo con smbclient que es un poca mas util con el tema de subir y descargar archivos. En ese caso usamos el siguiente comando:

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20204414.png)

Nos descargamos el archivo smb.conf y lo leemos para ver como esta configurado el SMB.
El archivo contiene algo interesante.

```console
1. `magic script = smbscript.sh`: Esta línea especifica un script que se ejecutará cada vez que un usuario acceda al recurso compartido. El script se llama `smbscript.sh` en este caso.
```
Esto quiere decir que podemos colocar una revershell que nos envie una conexion a nuestra pc.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20205647.png)

Para ello creamos un script con una revershell con el mismo nombre (smbscript.sh)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20210050.png)

Ahora nos ponemos en escucha con netcat y subimos el archivo al smb con el comando "put".

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20210313.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20180648.png)

Hacemos el tratamiento de la tty para tener una shell estable.

Luego de ello  vamos a escalar privilegios para ser el usuario root.

Buscamos permisos suid y tenemos como resultado "home/albert/root"

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20210500.png)

Dentro de esa ruta tenemos un archivo llamado ./beroot.

Esto lo transferimos a nuestra maquina atacante mediante un servidor python para poder leerlo

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20210718.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20210723.png)

Este archivo nos pide una contraseña, la cual no sabemos cual es.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20211019.png)

Si vemos la carpeta albert tenemos una imagen llamada croosroads.png, la descargamos en nuestra maquina atacante y con la herramienta "stegoveritas" leemos su contenido.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20213507.png)

Terminado de realizar su trabajo la herramienta nos crea un carpeta con todo lo obtenido.

En la carpeta: crossroeads/keepers/ obtenemos unos numeros raros que si cambiamos el nombre del contenido a password.txt y le damos un cat, vemos que son una seria de nombres que podrian ser la contraseña del archivo beroot.

Nos enviamso esa wordlists a la maquina victima y con el siguiente script vamos a realizar fuerza  bruta para sacar la contraseña.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20181145.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20181448.png)

Una vez que nos encontra una contraseña, hacemos un ls al directorio y tenemos una carpeta llamada rootcreds.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20214123.png)

Hacemos un cat y vemos que tenemos la siguiente pass:

____drifting____

Hacemos un su root y colocamos la pass.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-04%20214241.png)










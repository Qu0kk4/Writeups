## MAQUINA LAMES

Comenzamos haciendo un escaneo de puertos para ver que servicios estan corriendo.

````console
nmap -p- --open -sS -T4 -vvv -n -Pn "IP" -oN escaneo.txt
````

````console
La ejecucion de comando con nmap es gusto de cada uno
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-07%20214501.png)

Una vez realizado el escaneo hacemos un escaneo mas detallado para ver las versiones que estan corriendo en cada servicio.

````console
nmap -p PUERTO1,PUERTO2,PUERTO3,PUERTO4,PUERTO5 -sCV "IP" -oN fullscan.txt
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-07%20214715.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-07%20214729.png)

Tenemos el puerto 21 que los script basicos de nmap nos reportan que podemos acceder  siendo anonymous.

Una vez adentro del ftp vemos que no hay nada y buscando alguna vulnerabilidad vemos que es vulnerable a ejecucionde comandos. (pero la via no viene por aca).

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-07%20214908.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-07%20214942.png)

Tambien tenemos el puerto 22 el ssh, que al tener una version antigua es vulnerable a enumearcion de usuarios y demas.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-07%20215050.png)

Luego tenemos el puerto 139/445 smb, el cual nmap nos reporto que la version es 3.0.20. 

Con smbclient listamos el contenido.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-07%20215357.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-07%20220357.png)

Con crackmapexce

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-07%20220220.png)

La via no es por aca ya que dentro de los archivos no contienen nada.

Como tenemos la version de samba, vamos a buscar por metasploit si tiene alguna vulnerabilidad.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-07%20223740.png)

Metasploit nos muestra un exploit en el cual realiza una ejecucion de comandos.

Completamos las opciones requeridas.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-07%20223839.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-07%20223930.png)

Ejecutamos y somos ROOT!


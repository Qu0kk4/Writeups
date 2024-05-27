## MAQUINA WALKINGCMS WRITEUP 

Con nmap hacemos un escaneo de puertos para ver los puertos que se encuentras abiertos, para ello usamos el siguiente comando.

````console
nmap -p80 -sC -sV "IP" -oN fullscan.txt
````
(Dense el gusto de utilizar otros comando je!)

En este caso nmap nos reporto que el puerto 80 donde corre un servicio http se encuentra abierto.





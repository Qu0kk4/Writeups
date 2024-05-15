Iniciamos la maquina de dockerlabs.es

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20152445.png)

Hacemos un escaneo de nmap

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20153419.png)

Tenemos el puerto 21 y el 80 abiertos, en este caso ingresamos al servicio http.

La web nos muestra lo siguiente.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20153521.png)

Con wappalyzer vemos un poco mas de informacion sobre la web.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20153804.png)

Ahora nos dirijimos al servicio ftp que corre por el puerto 21.

En este caso vemos que podemos logearnos de forma anonima.

Lo interesante de aca es que hay un directorio llamado /upload.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20153831.png)

Si no dirigimos a este directorio pero en la web, vemos que esta nos redirige al directorio pero esta vacio.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20153923.png)

Luego con gobuster buscamos mas directorios ocultos.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20154126.png)

Si prestamos atencion vemos que el directorio /upload si esta disponible.

Aca vamos a subir un archivo php, dentro del directorio /upload en el FTP.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20154619.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20154646.png)

Luego vamos al sitio web y entramos dentro de la url y nos dirijimos otra vez al directorio /upload.

Con el archivo php se utiliza para injectar comando, vamos a probar con whoami si nos devuelve que usuario es.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20154657.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20154713.png)

Bien como fue exitosa la injeccion de comando, vamos a enviarnos un revershell a nuestra maquina atacante.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20161913.png)

Lo encodeamos :D y luego nos ponemos en escucha con netcat.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20161939.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20161939.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20161805.png)

Una vez dentro hacemos el tratamiento de la tty para tener una shell estable.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20162058.png)

Dentro de la maquina tenemos 3 usuarios: gladys, pingu y ubuntu.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20162127.png)

Nos queda buscar alguna forma de escalar privilegios buscando algun binario, en este caso usamos sudo -l.

Vemos que el usuario pingu tiene un binario llamado "man", en este caso no nos pide password

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20162440.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20163433.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20163442.png)

Somos usuario pingu, seguimos buscando la escalada de privilegios para ser root, volvemos a utilzar el comando sudo -l y nos encontramos con lo siguiente.

El usuario gladys tiene permiso para ingresar a nmap y dpkg sin contraseña. Ahora con esto buscamos si es posible loguearnos con estos binarios.

En este caso nos centramos en dpkg. Mas info en https://es.wikipedia.org/wiki/Dpkg

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20163503.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20163719.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20163816.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20163935.png)

Como pudimos loguaernos como gladys, otra vez hacemos sudo -l y vemos lo siguiente.

Root esta utilizando un binario llamado chown, accediendo a el sin contraseñas

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20164004.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20164028.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20170755.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-08%20171335.png)


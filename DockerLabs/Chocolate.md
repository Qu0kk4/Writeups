## Maquina Chocolate "Dockerlabs"

Iniciamos la maquina y esta nos brinda la ip victima.

Ahora lanzamos un ping para ver si tenemos conectividad pero para tambien ver el ttl: si el ttl es 64 o aprox es una maquina linux y si es 128 aprox es windows.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20153330.png)

Luego hacemos un escaneo con nmap para ver los puertos y servicios abiertos.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20152823.png)


Solo tenemos el puerto 80 http abierto.

Ingresamos al sitio web y nos muestra la pagina de apache por default.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20153352.png)

Lanzamos un whatweb para ver mas informacion sobre la pagina.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20153012.png)

Leemos el codigo fuente de la pagina por default y vemos algo interesante. Al paracer tenemos un directorio.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20153254.png)

Agregamos a la url el directorio /nibbleblog y nos muestra lo siguiente.
Parece ser un CMS.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20153545.png)

Buscamos un poco sobre este CMS con nuestro amigo google.

https://wwwhatsnew.com/2012/08/22/nibbleblog-un-nuevo-cms-para-crear-blogs-sin-usar-base-de-datos-opensource/

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20153735.png)

Tambien aparece una ruta llamada admin.php, donde se pueden hacer publicaciones.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20153551.png)

Con gobuster vamos a buscar directorios ocultos.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20161228.png)

Ingresamos a la ruta de /update.php y esta nos muestra que version de nibbleblog esta corriendo

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20161151.png)

Ingresamos a la ruta de admin.php donde se encuentra el panel de login y buscando por google si posee alguna contraseña por default encontre que se puede acceder a ella colocando USER: admin y PASSWORD: admin.

Una vez adentro nos muestra los siguiente:

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20161510.png)

En google vamos a buscar la manera de hacer esto de forma manual.
Aca tenemos una guia explicada de como podemos subir una revershell para ganar acceso al sistema.

https://packetstormsecurity.com/files/133425/NibbleBlog-4.0.3-Shell-Upload.html

Vamos a plugins y instalamos "My image".

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20162344.png)

Ahora usamos la revershell de pentest mokey pero la guardamos con el nombre "image.php", si no se guarda asi no funciona la revershell.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20162352.png)

Vamos a browser y la subimos omitiendo los errores

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20163558.png)

Luego en otra terminal nos vamos a poner en escucha con netcat.

Seguido de eso volvemos a la pagina web y vamos  a la ruta que esta de color naranja y la enviamos.

Nuestro nc ya obtuvo la revershell.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20163635.png)

Somos www-data, ahora buscamos mas usuarios dentro de la maquina.

Tnemos otro usuario llamado chocolate.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20163757.png)

Buscamos de loguearnos como el usuario chocolate, en este caso usamos sudo -l.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20163834.png)

Hay un binario /usr/bin/php que esta usando el usuario chocolate y que no nos pide contraseña.
De la siguiente forma nos logueamos como chocolate.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20164531.png)

Ahora que somos chocolate, buscamos la forma de escalar privilegios maximos.
Nos dirijimos a la ruta /opt y tenemos un script.php que esta siendo ejecutado por root.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20171054.png)

Cambiamos el contenido del script por lo siguiente.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20171445.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20171457.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-13%20171513.png)

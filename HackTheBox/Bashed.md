## MAQUINA BASHED

Lo primero que hacemos es realizar un escaneo de puertos con NMAP en este caso nos interesa los que estan abiertos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-12%20224728.png)

Con unos scripts basicos que vienen en nmap para ver la version de este puerto encontrado.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-12%20224733.png)

El resultado de nmap solo nos muestra que esta el puerto 80 en el cual corre un servicio http, asi que abrimos el navegador web.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-12%20224809.png)

Una vez adentro luego de hacer un poco de OSINT  a la pantalla principal, vamos a buscar directorios que se encuentran ocultos en la web.

En este caso vamos a utilizar un script de nmap.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-12%20225258.png)

Hay 6 directorios ocultos, en nuestro caso vamos a lo importante, ingresamos al directorio /dev y nos muestra lo siguiente.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-12%20230716.png)

En estos apartados una vez ingresado a cada uno nos muestra una interfaz de comando que al parecer es del usuario www-data.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-12%20230731.png)

Listamos el contenido para ver lo que hay y indefectiblemente podemos ver algunos directorios.

Es interesante que tenemos una carpeta llamada /uploads.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-12%20231856.png)

Si subimos un archivo .php a la carpeta y esta se muestra en la web, podemos aprovechar esto y  subir una RV para conectarnos a nuestra maquina.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-12%20232123.png)

Como dijimos antes, subimos el archivo llamado "hola" y nos muestra un estado de error 304 ya que no posee ningun contenido dentro del archivo. 

Para subir la RV vamos a inicar un servidor con pyhton para luego descargarlo con wget a la maquina victima.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20194750.png)

Bien ahora usamos un RV de pentestmonkey para conectarnos a nuestra maquina, una vez configurado la RV  colocamos netcat en escucha.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20195231.png)

Una vez dentro de la maquina somos el usuario www-data como en la interfaz de comandos, ahora que da buscar la manera de conseguir los privielegios maximos de la maquina.

Pero primero vemos que hay 2 usuarios en la  maquina.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20195425.png)

Ahora buscamos permisos sudoers con sudo -l y muestra lo siguiente.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20195655.png)

Ahora volvemos a la raiz y listamos, aca hay una carpeta muy interesante llamada scripts que esta siendo ejecutado por el usuario scriptmanager.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20200240.png)

Como somos usuario www-data no poseemos los permisos necesarios para acceder a ella solo podemos listarla, en este caso listamos el contenido.

En la primera opcion no muestra nada ya que como dije antes no tenemos permisos y no podemos ver que permisos tiene los archivos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20200505.png)

Utilizando este comando podemos listar los permisos que tienen estos archivos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20200536.png)

Hacemos lo mismo para poder leer lo que contienen cada archivo.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20200938.png)

Bien aca se esta ejecutando un archivo.py en el usuario scritpmanager, lo que vamos a hacer es enviarnos revershell en pyhton hacia nuestra maquina nuevamente pero por diferentes puertos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20202605.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20202610.png)

Una vez adentro volvemos atener conexion con la maquina victima y ahora el siguiente comando vamos a logearnos como el usuario scriptmanager.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20202836.png)

Una vez logeado vamos a la carpeta scripts en la raiz y modificamos el contenido del archivo test.py

Borramos el contenido y colocamos el siguiente.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20203634.png)

Una vez hecho esto esperamos un poco, y hacemos un bash -p

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20203652.png)

Y listo somos root

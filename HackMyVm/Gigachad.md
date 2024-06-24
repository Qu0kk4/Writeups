![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20210519.png)

Comenzamos haciendo un escaneo de red con arp-scan.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20192305.png)

Ya obtenida la ip utilizamos la herramienta NMAP para hacer un escaneo de puertos el cual nos vamos a solamente los puertos abiertos.

````bash
nmap -p- --open -sS -T4 -vvv -n -Pn -sCV "ip" 
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20193725.png)

Al escaneo anterior le colocamos los parametro -sCV. 

¿Que es lo que hace? el comando -sC activa los scripts basicos que vienen por default en NMAP y el parametro -sV indica a Nmap que realice un escaneo de versiones de los servicios que están corriendo en los puertos abiertos de la máquina objetivo.

Lo que nos muestra NMAP es que tenemos el puerto 21 en el que corre un FTP tambien nos muestra la version.

El puerto 22 corre el servicio ssh y el puerto 80 corre un servicio http.

En el resultado de NMAP vemos que podemos acceder al servicio FTP siendo anonimos, asi que vamos a ingresar.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20193934.png)

Una vez accedidos tenemos un archivo llamado chadinfo a esto los nos traemos a nuestra maquina atacante.

Le pasamos el comando strings y vemos que tiene un usuario y una contraseña pero esta no se pueden ver claramente. Lo que si hay lo que parece un directorio en el cual aloja una imagen.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20194026.png)

Como tenemos el servicio web corriendo vamos a abrir nuestro navegador para ingresar.

La web nos muestra los siguiente.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20194118.png)

En el archivo que descargamos del ftp nos mostraba un ruta donde hay una imagen, vamos a ver el contenido.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20200840.png)

En la pagina principal si vemos su codigo fuente muestra otra ruta.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20194220.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20194214.png)

Buscamos info de que quiere decir mi5 y mi6.

````bash
MI5 y MI6 son agencias de inteligencia del Reino Unido:

1. **MI5 (Military Intelligence, Section 5)**: Es la agencia de seguridad nacional del Reino Unido, responsable de la seguridad interna y la contrainteligencia. Se enfoca en la protección contra amenazas internas, como el terrorismo, el espionaje y otras actividades que puedan representar una amenaza para la seguridad nacional.
    
2. **MI6 (Secret Intelligence Service, SIS)**: Es la agencia de inteligencia exterior del Reino Unido, encargada de recolectar inteligencia en el extranjero. MI6 opera en secreto y su principal función es obtener información de interés para la seguridad nacional británica y para apoyar las políticas exteriores del gobierno del Reino Unido.
````

En la siguiente imagen vemos que hay unas palabras donde si usamos un poco la mente "nos esta diciendo que ese lugar es su lugar favorito" asi que vamos a buscar en google que lugar es el que aparece en la imagen.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20200757.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20201041.png)

Ese lugar se llamada "torre de la doncella", volvemos al archivo ftp que nos mostraba un usuario llamado chad, entonces porque no probar esto para ver si es la contraseña.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20202029.png)

Bien accedimos como usuario chad. Ahora buscamos informacion en la maquina.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20202144.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20202159.png)

¿Que hacemos ahora dentro de la maquina? buscar la manera de escalar privilegios para ser usuario root.

Con este comando podemos ver que archivos estan corriendo como usuario root, y hay uno interesante llamado "s-nail-privsep".

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20202801.png)

En searchsploit tenemos una vulnerabilidad que al parecer podemos hacer una escalada de privilegios.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20203329.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20203338.png)

A este script lo vamos a enviar a la maquina victima para ejecutarlo para ello le damos permisos de ejecucion.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20203816.png)

Una vez ejecutado el script esperamos y nos muestra que el script funciono ahora somos el usuario root.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20210356.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-05%20210410.png)


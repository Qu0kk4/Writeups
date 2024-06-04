# MAQUINA BROKER

Hacemos un escaneo utilizando nmap para ver los puertos que se encuentran abiertos.

````console
nmap -p- --open -sS --min-rate 5000 -n -Pn -vvv 10.10.11.243 -oN escaneo.txt 
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20194336.png)

El resultado de nmpa nos reporto varios puertos abiertos, ahora con un script creado (en mi github esta) vamos a tomar todos los puertos abiertos para hacer un escaneo mas detallado para ver las versiones de cada servicio.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20195319.png)

````console
nmap -p puertos -sC -sV 10.10.11.243 -oN fullscan.txt
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20195335.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20195347.png)

Nos centramos en el puerto 8161 que corre un servicio http.

Si vemos el reporte de nmap vemos que corre un servidor http Jetty de version 9.4.39.

Si ingresamos nos aparece un inicio de session en el cual vamos a colocar las credenciales admin:admin.

Una vez adentro nos dirige a este sitio.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20195623.png)

En "MANAGE activeMQ broker" nos muestra la version del sitio se trata de 5.15.15.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20195634.png)

Si prestamos atencion en el reporte de nmap tambien tenemos la version de este servicio http.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20195657.png)

Buscamos en google algun exploit o vulnerabilidad para aprovechar y encontramos lo siguientes resultados.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20195816.png)

Link de exploit: https://github.com/evkl1d/CVE-2023-46604/tree/main

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20195855.png)

Este exploit es sencillo de utilizar, nos traemos el repositorio a nuestra maquina atacante.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20200201.png)

Dentro de este repositorio vamos a modificar el contenido de poc.xml

Tenemos colocar nuestra RV indicando el puerto (modificamos lo que esta resaltado)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20200251.png)

Seguido de eso abrimos 3 terminales.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20200422.png)

1) En la primera vamos a ejecutar el exploit
2) En la segunda vamos a abrir un servidor http con python para enviar el archivo con nuestra RV
3) Y la tercera vamos a ponernos en escucha con netcat atravez del puerto que colocamos en la RV

Una vez hecho esto vamos a enviar el exploit y quedaria de la siguiente manera.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20200936.png)

Listo, una vez dentro hacemos el tratamiento de la tty para tener una shell estable.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20201035.png)

Leemos el archi /etc/passwd y tenemos 2 usuarios

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20201300.png)

Actualmente somos el usuario activemq.

Hacemos un sudo -l para ver los permisos y encontramos la siguiente ruta.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20201544.png)

Buscamos la carpeta nginx y lo que vamos a  hacer es lo siguiente

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20205157.png)

Copiamos y enviamos  el archivo nginx.conf a la carpeta /tmp.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20205208.png)

Ahora modificamos el archivo borrando todo lo que contiene dentro de  nginx.conf con lo siguiente.

````console
user root;
events {
    worker_connections 1024;
}
http {
    server {
        listen 1337;
        root /;
        autoindex on;
    }
}
````

Lo guardamos con el nombre pwned.conf y levantamos el servicio nginx .

````console
sudo /usr/sbin/nginx -c /tmp/pwned.conf
````

Vemos que la maquina tiene instalado curl.
Y ahora desde curl y especificando el puerto 1337, que fue el que indicamos antes, ya podremos acceder a cualquier directorio o archivo del sistema ya que estaríamos moviéndonos como root:

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-03%20205825.png)





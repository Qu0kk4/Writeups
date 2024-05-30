## Writeup Fooding Dockerlabs

Con nmap vamos a realizar un escaneo de puertos abiertos dentro de la maquina.

````console
nmap -p- -sS --open --min-rate 5000 -vvv -n -Pn 172.17.0.2 -oN escaneo.txt
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-29%20220608.png)

Tenemos varios puertos corriendo dentro de la maquina, por ende vamos a extraer los puertos y seguido con nmap usamos unos scripts basicos para ver con un poco mas detallados que servicios y versiones estan corriendo.

Para la extraccion de puertos utilize un script creado por mi en bash XD.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-29%20221151.png)

````console
nmap -sC -sV IP -oN fullscan.txt
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-29%20221226.png)
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-29%20221248.png)
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-29%20221307.png)

Comenzamos ingresando por la pagina web que corre por el puerto 80, esta no nos muestra nada ya que nos envia una pagina por default de apache.

Como vimos en el reporte de nmap tenemos un protocolo "ssl", esto quiere decir que corre un https, por lo que vamos a agregar al http: la "s".

Listo estamos dentro de la web, esta al ser protegido por el ssl no vamos a poder fuzzear.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-29%20221512.png)

Hay un protocolo http que corre por el puerto 8161 "un servidor web llamado jetty 9.4.39"

https://en.wikipedia.org/wiki/Jetty

Una vez que ingresemos nos pide usuarios y contraseña que buscando por google son que vienen por defecto "admin:admin".

Dentro corre el servicio apache activeMQ.

Si vamos al apartado marcado en naranja vamos a ver detallado algunas cosas entre ellas la version.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-29%20202754.png)

Esta version tambien aparece en el reporte de nmap pero esta corre en el puerto 61616, para tener encuenta.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-29%20202824.png)

Continuamos, ahora buscamos algun exploit de esta version.

https://github.com/evkl1d/CVE-2023-46604/tree/main

````bash
Encontramos la siguiente vuln: "CVE-2023.46604" es una vulnerabilidad de deserialización que existe en el protocolo OpenWire de Apache ActiveMQ. Un atacante puede aprovechar esta falla para ejecutar código arbitrario en el servidor donde se ejecuta ActiveMQ. El script de explotación en este repositorio automatiza el proceso de envío de una solicitud diseñada al servidor para activar la vulnerabilidad.
````

Tenemos una PoC asi que es facil de explotarla para ello hacemos lo siguiente.

1) Descargamos el repositorio a nuestra carpeta de trabajo.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-29%20224222.png)

2) Dentro de la carpeta hay un archivo xml en el cual hay que modificar la IP con nuestra IP para poder obtener una RV.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-29%20224609.png)

3) Ahora abrimos 3 terminales, 1= para enviar realizar la explotacion, 2= para abrir un servidor python para enviar el archivo y 3= una para tener la conexion con NC.

En el exploit se desglosa asi: 

-i = ip del servicio web 
-u =  nuestra ip + el puerto donde corre el servidor python.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-29%20225339.png)

Le damos enter al exploit y listo somos root! en la maquina victima

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-29%20225447.png)


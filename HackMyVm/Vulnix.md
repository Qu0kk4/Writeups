## MAQUINA VULNYX HMV

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20174048.png)

Hacemos un escaneo de red para saber que ip vamos a atacar.

```console
netdiscover -i eth0 -r "ip"
```
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20110643.png)

Ya que tenemos la ip, le lanzamos un ping para ver si hay conectividad con la maquina.. segun el ttl estamos ante una maquina linux

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20110730.png)

Luego hacemos un escaneo de puertos para saber que servicios estan abiertos en la maquina:

```console
nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn "ip" -oN escaneo.txt
```
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20120419.png)

Entramos al puerto 80 que es un servicio web para ver que contiene.

Como no hay ningun contenido que podes hacer algo vamos fuzzear directorios para ver si hay.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20124626.png)

Para fuzzear vamos a utilizar dirb.

Hay directorios ocultos que no hace falta decir que estamos ante un wordpress..

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20112110.png)

Bien aca tenemos un archivo importante llamado "secret".

Este brinda info sobre que el contenido de la pass y user estan dentro de unos esos 2 archivos

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20111739.png)

Mirando mas el contenido de los directorios encontrados con dirb hay uno interesante.
"wp-file-manager-6.zip"

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20125029.png)

Como veo que esta en el directorio "upload", se me dio por buscar que seguramente un archivo se puede subir de alguna forma, asi que en searchsploit encontre una vulnerabilidad

```console
CVE-2020-25213":
Este script parece ser un exploit para una vulnerabilidad en el plugin de WordPress llamado "WP File Manager". Aquí está la función general del script:

1. **Imports**: Importa los módulos necesarios, como `sys`, `signal`, `time` y `requests`. También importa `BeautifulSoup` desde `bs4`, que se utiliza para analizar el HTML.
    
2. **Definición de funciones**:
    
    - `handler(sig, frame)`: Esta función maneja la señal SIGINT (Ctrl+C) para permitir una salida limpia del script.
    - `commandexec(command)`: Esta función toma un comando como argumento, construye una URL específica para explotar la vulnerabilidad en el plugin WP File Manager y ejecuta el comando proporcionado en el servidor vulnerable.
    - `exploit()`: Esta función principal toma la URL del sitio web de WordPress y un comando como argumentos. Construye un payload específico para explotar la vulnerabilidad, carga un archivo PHP shell en el servidor objetivo y luego ejecuta el comando proporcionado utilizando la función `commandexec()`.
3. **Ayuda**: Define una función `help()` que muestra cómo utilizar el script.
    
4. **Main**: Verifica si se proporcionan dos argumentos (URL y comando) al script. Si se proporcionan, se llama a la función `exploit()`. De lo contrario, se muestra la ayuda.
    

En resumen, este script intenta explotar una vulnerabilidad en el plugin WP File Manager para ejecutar comandos arbitrarios en el servidor objetivo. Se recomienda usar este script solo con fines educativos y éticos, y no para fines maliciosos. Además, asegúrate de tener permiso legal para probar y utilizar este script en entornos controlados y autorizados.
```
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20121807.png)

Ahora una vez descargado el exploit vamos a completarlo para lanzar la url:

```console
1: colocamos entre "la direccion url donde con el apartado vulnerable en este caso (secret)", "colocamos una revershell"

2: en otra terminal hacemos un nc -nlvp 1234

3: le damos enter
```
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20121653.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20121836.png)

Ahora como obtuvimos la rever shell vamos a realizar el tratamiento de la tty, para eso vemos si tenemos instalado "bash"

Hacemos los siguiente:

```console
script /dev/null -c bash
ctrl+z
stty raw  -echo;fg
1]  + continued  nc -nlvp 443
                              reset
reset: unknown terminal type unknown
Terminal type? xterm
www-data@host:/$ export TERM=xterm
www-data@host:/$ export SHELL=bash
```
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20121954.png)

Vamos al apartado donde la mayoria de los wordpress ocultan sus credenciales:

/usr/share/wordpress/wp-config.php (o similar). Le damos enter y al parecer tenemos una passwd

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20122931.png)

Vamos a /home y tenemos un usuario "adrian", le damos "su" y colocamos la contraseña, y listo somos el user adrian.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20123026.png)

Ahora lo que queda es escalar privilegios, para eso probamos con sudo -l:

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20123115.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20123139.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20123655.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20123753.png)






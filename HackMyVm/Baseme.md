## MAQUINA BASEME

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20205426.png)

Escanemos la red para ver la ip de la maquina victima

```bash
netdiscover -i eth0 -r 192.168.0.162
```
![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20192319.png)

Hacemos un escaneo con nmap 

```bash
nmap -p- --open -sS -sV -sC -T5 -n -Pn -vvv 192.168.0.152
```
![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20192433.png)

Como resultado tenemos el puerto 22 y 80 abiertos, ingresamos al puerto 80 (http).

Dentro del codigo fuente de la pagina tenemos lo siguiente.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20194300.png)

Hay una cadena de texto que esta encodeada y una lista de palabras.

Lo que vamos a hacer es decodificar la cadena de texto que se encuentra en base64, para ver que lo que contiene.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20194448.png)

Nos dice que todo hasta las contraseñas estan cifradas en base64 y tenemos un usuario llamado "lucas"

Ahora pensando un poco nos dice que todo esta encodeado, por ende vamos probar encodeando la cadena de texto encontrada en el codigo fuente.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20155527.png)

Pero nada, no nos sirve. Por lo que intente encodear todo un diccionario de la wordlists y buscar directorios ocultos con ese diccionario encodeado.

Con el script ./base64_encoder.sh encodeamos la wordists.

```bash
./base64_encoder.sh common2.txt common3.txt

#!/bin/bash

for i in $(cat $1); do
        echo $i | base64 >> $2
done
        
```
![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20201619.png)

Fuzzeamos con el siguiente comando:

```bash
ffuf -u http://192.168.0.152/FUZZ -w /home/kali/Desktop/192.168.0.152/common3.txt -fc 403
```

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20201632.png)

Y ffuf nos encontro 2 rutas ocultas! un robots.txt y un id_rsa!

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20201604.png)

El id_rsa esta encodeado tambien asi que lo desencodeamos con "base64 -d"

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20202002.png)

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20202018.png)

Ahora vamos a crackear el rsa con john.. para eso vamos a utilizar el diccionario encontrado al principio (posibles.txt (iloveyou,etc))

```bash
1-Obtener hash #ssh2john id_rsa > hash 

2-Romper hash #john –wordlist=/usr/share/wordlist/rockyou.txt hash
```

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20203415.png)

Le damos permisos a la id_rsa con "chmod 600 id_rsa" e ingresamos atravez del ssh utilizando el usuario "lucas" pegamos la clave y listo.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20203947.png)

Ahora queda escalar maximos privilegios para ello utilizamos el comando sudo -l

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20204111.png)

Hay un SUID llamado base64 con esto podemos escalar privilegios.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20205158.png)

En LFILE=file to road : vamos a ingresar un archivo que podamos leer, en este caso vamos a ingresar un clave id_rsa como root

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20205140.png)

Luego creamos un archivo llamado id_rsa y le damos permisos 600 

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20205227.png)

Ingresamos con como el usuario root: "ssh -i id_rsa@localhost".

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-17%20205241.png)

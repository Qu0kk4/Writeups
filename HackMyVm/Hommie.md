## MAQUINA HOMMIE

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20202308.png)

Utilizamos netdiscover para ver las maquinas conectadas a nuestra red.

```bash
netdiscover -i eth0 -r 192.168.0.162
```

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20184513.png)

Una vez tengamos la IP de maquina victima lanzamos un ping para ver si tenemos conexion con ella.

```bash
ping -c 192.168.0.123
```

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20184600.png)

Seguido a esto usamos nmap para ver los servicio y puertos abiertos.

```bash
nmap --open -sC -sV -oN fullscan.txt
```

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20184818.png)

Tenemos como resultado el puerto 21 ftp, el puerto 22 ssh y el puerto 80 http.

Ingresamos al servidor web, con whatweb vemos mas info. sobre la pagina y luego tenemos una frase dirigida a "alexia" y dice que su "id_rsa esta expuesta"

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20185533.png)

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20185652.png)

El escaneo de script de nmap nos mostro que el puerto 21 ftp se puede loguear de forma anonima.

```bash
ftp 192.168.0.123

---> anonymous
```

Haciendo un ls -la dentro del ftp tenemos un directorio llamado ".web"

#atención!

En el directorio normal no podemos subir nada, en el directorio .web si! osea que vamos a tratar de subir una revershell para conectarnos a la maquina victima.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20194249.png)

Esto nos da resultado negativo y ya no tenemos ni idea de como seguir.. por eso se me dio x buscar en chatgpt si existe "otros servicio de tranferencia similares al ftp", y tenemos este resultado

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-19%20193121.png)

Claro ! existe el protocolo tftp, este servicio corre en el puerto 69 y se envian los archivos atravez de UDP. 

Ahora hacemos volvemos a escanear otra vez los puertos con nmap.

```bash
nmap -p- --open -sU -sS --min-rate 4000 -vvv -n -Pn 192.168.0.123
```
![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20200307.png)

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20200328.png)

Seguido al terminar el escaneo nos conectamos ya que no nos pide autorizacion y con el comando "help" vemos los comando a utilizar, descargamos la id_rsa con "get".

```bash
tftp 192.168.0.213
help
get id_rsa
```

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20200510.png)

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20200759.png)

Listo tenemos la clave id_rsa de la usuaria alexia.

Le damos permiso 600 a la ida_rsa

```bash
chmod 600 id_rsa
```
Y nos conectamos atravez del ssh

```bash
ssh -i ida_rsa alexia@192.168.0.213
```
Listo somos la usuario alexia y ahora nos queda elevar los maximos privilegios

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20200807.png)

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20200901.png)

Una vez adentro buscamos binarios SUID para poder escalar priv.

```bash
find  / -user root -perm /4000 2>/dev/null
```
Y tenemos la siguiente ruta:

>/opt/showMetheKey

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20201109.png)

Con el comando "strings" leemos el archivo para ver que es lo que hace
Y se ve que lee el comando "$HOME/.ssh/id_rsa"
Lo que hace se hace es un  PATHHIJACKING para cambiar la ruta en que lee el archivo configurandolo a root:

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20201121.png)

```bash
>echo $HOME
/home/alexia
>HOME=/root
>echo $HOME
/root
```

#!atencion esto es lo que hicimos!

Estos comandos están modificando y mostrando el valor de la variable de entorno `$HOME`, que generalmente apunta al directorio de inicio del usuario en sistemas Unix y Linux.

1. `echo $HOME`: Este comando muestra el valor actual de la variable de entorno `$HOME`. En este caso, muestra `/home/alexia`, lo que indica que el directorio de inicio actual del usuario es `/home/alexia`.
    
2. `HOME=/root`: Este comando modifica el valor de la variable de entorno `$HOME` y establece su nuevo valor en `/root`, que es el directorio de inicio del usuario root en sistemas Unix y Linux.
    
3. `echo $HOME`: Después de cambiar el valor de `$HOME`, este comando muestra el nuevo valor de la variable de entorno `$HOME`. En este caso, muestra `/root`, lo que indica que el directorio de inicio actual del usuario ha sido cambiado a `/root`.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20201729.png)

Volvemos a correr el archivo ./showMetheKey y proporcina como resultado una id_rsa (que este id_rsa es lo que lee el apartado anterior "cat $HOME/.ssh/id_rsa")

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20201729.png)

Damos permisos a la id_rsa y luego nos conectamos a la ip de la maquina como usuarios root y listo.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20201957.png)

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-03-18%20202115.png)
















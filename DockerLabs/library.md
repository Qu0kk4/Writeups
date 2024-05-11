## MAQUINA LIBRARY

Con nmap buscamos los puertos abiertos dentro de la maquina.

```console
nmap -p22,80 -sC -sV -O 172.17.0.2 -oN fullscan.txt
```

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20205755.png)

Tenemos los puertos 22 y 80 disponibles (open).

Lanzamos un whatweb a la pagina para obtener mas información.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20205917.png)

Entramos al servicio http que corre por el puerto 80.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20210006.png)

Ahora como no nos proporciona nada la web, vamos a realizar un escaneo de directorios con gobuster.

```console
gobuster dir -u http://172.17.0.2 -w /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-1.0.txt -x php,html -t50
```

La herramienta nos encontro 2 directorios ocultos, un php y un html nos andentramos dentro del html.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20224127.png)

Dentro del archivo index.html y nos aparece una cadena de texto.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20210151.png)

Ahora como no es ningun tipo de hash, ni nada por el estilo vamos a realizarle fuerza bruta al ssh ya que esta disponible para ver si esta puede ser alguna contraseña, para eso necesitamos encontrar un usuario valido.

```console
hydra -P /usr/share/wordlists/seclists/Usernames/Names/names.txt -l JIFGHDS87GYDFIGD ssh://172.17.0.2
```

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20223916.png)

La contraseña al parecer pertenece a un usuario llamado "carlos",  ahora nos intentamos loguear atravez del ssh.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20224308.png)

Buscamos un poco mas de info. (nunca esta mal).

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20224329.png)

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20224418.png)

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20224340.png)

Como tenemos un usuario solo llamado carlos, vamos a buscar la forma de escalar privelgios, en este caso buscamos binarios.

Utilizamos sudo -l.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20225618.png)

Tenemos un script en python que no requiere contraseña y todos pueden utilizarlos osea que root tambien (lo verificamos en la imagen de abajo)

Ahora vamos a eliminar el archivo script.py y creamos un archivo.py que nos permite loguearnos como usuario root.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20225555.png)

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-10%20225646.png)

SOMOS ROOT :D!








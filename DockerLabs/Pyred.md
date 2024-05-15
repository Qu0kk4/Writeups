##Maquina pyred (dockerlabs)

Iniciamos la maquina :D 

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20191622.png)

Luego lanzamos un ping para ver el ttl de la maquina.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20191617.png)

Al tener un ttl de 64 quiere decir que estariamos ante una maquina linux

Ahora con nmap hacemos un escaneo para ver los puertos abiertos.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20193323.png)

El escaneo nos muestra que solo tenemos el puerto 5000 disponible.

Abrimos firefox y colocamos la ip + el puerto.

Como resultado tenemos un panel donde podemos escribir algunos comando de python.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20193504.png)

Probamos haciendo una suma y nos muestra el resultado.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20193542.png)

Como funciona probamos leer algun archivo del sistema, para ellos utilizamos el siguiente comando.

```bash
import os

os.system('id,whoami,ls -la,etc')

```

Probamos el id y muestar un usuario llamado primpi.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20195052.png)

Buscamos la manera de tener una revershell, para eso hacemos lo siguiente:

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20200457.png)

PEQUEÑO DETALLE: al final del script >>> 1" ')  tiene un espacio entre la " y ' borrenlo si no no funciona..

Una vez colocado ese comando nos ponemos en escucha con netcat y enviamos la RV.

Si todo sale bien estamos dentro de la maquina victima.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20200751.png)

Hacemos el tratamiento de la tty con python porque con bash no funciona F (aca se me rompio el bash xD ignoren)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20200940.png)

Vamos a la carpeta home y aca empieza la busqueda de realizar la escala de privilegios

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20202039.png)

Con sudo -l tenemos un binario llamado "dnf"

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20202109.png)

INFORMACION:

```console
RPM, que significa Red Hat Package Manager (Gestor de paquetes Red Hat), es un sistema de gestión de paquetes utilizado principalmente en distribuciones de Linux basadas en Red Hat, como Red Hat Enterprise Linux (RHEL), CentOS y Fedora. También se utiliza en algunas otras distribuciones de Linux.

El formato de archivo RPM es utilizado para empaquetar software junto con metadatos relacionados, como nombre del paquete, versión, dependencias y scripts de instalación. Estos paquetes se pueden instalar, actualizar o eliminar fácilmente utilizando herramientas como rpm en la línea de comandos o herramientas gráficas como dnf (Dandified Yum) y yum, que son administradores de paquetes que utilizan RPM como base.

Los paquetes RPM contienen archivos binarios, bibliotecas, scripts y metadatos necesarios para instalar y gestionar el software en un sistema Linux. El sistema de gestión de paquetes RPM proporciona una forma eficiente de distribuir software y mantener sistemas Linux actualizados con las últimas versiones de software y parches de seguridad.
```

Ya sabemos que rmp contienen archivos binarios y demas... lo que quiere decir que podemos realizar algun tipo de script para que nos deje loguear como root.

Bueno para ellos entramos a GTFobins y vemos que podemos explotar ese binario.

Ahora hacemos lo siguiente:

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20202312.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20203811.png)

IMPORTANTE:

```console
Si no tienen instalado fpm aca les dejo una guia de como instalarlo.

https://fpm.readthedocs.io/en/latest/installation.html
```
Una vez creado el archivo rpm, vamos a abrir un servidor python en la maquina atacante y luego con curl descargamos el archivo en la maquina victima (no tiene wget).

ATACANTE:

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20204032.png)

VICTIMA

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20204049.png)

Ahora instalamos el exploit.rmp.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20204226.png)

Una vez terminado de instalar colocamos bash -p y listo somos usuario root.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-14%20204247.png)

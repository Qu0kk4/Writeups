## MAQUINA WALKINGCMS WRITEUP 

Con nmap hacemos un escaneo de puertos para ver los puertos que se encuentras abiertos, para ello usamos el siguiente comando.

````console
nmap -p80 -sC -sV "IP" -oN fullscan.txt
````
(Dense el gusto de utilizar otros comando je!)

En este caso nmap nos reporto que el puerto 80 donde corre un servicio http se encuentra abierto.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20191524.png)

Utilizamos un script de propio de nmap para enumerar el puerto 80. El script nos muestra que estamos frente a un wordpress y que tenemos una ruta llamada wp-login.php

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20191531.png)

Entramos a la directorio wordpress, ya que si solo entramos con la ip nos muestra la pagina de apache por default.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20191705.png)

Con gobuster hacemos un escaneo de directorio para encontrar rutas ocultas dentro del sitio web.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20192223.png)

Tenemos el mismo directorio que nos encontro el script de nmap, asi que ahora vamos a hacer el escaneo a la ruta wordpress.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20192701.png)

Gobuster encontro mas rutas ocultas, en las cuales vamos a ingresar a cada una, pero este caso nos vamos a centrar en la ruta /xmlrpc.php y /wp-login.php.

Estamos antes un wordpress lo que nos interesa que version esta corriendo, para ello utilizamos whatweb.
La version es 6.5.3

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20192315.png)

Bien ahora vamos a usar la herramienta wpscan para enumerar algunos plugins, usuarios y algun que otra vulnerabilidad.

````console
wpscan --url http://172.17.0.2/wordpress --enumerate vp,u
````
El resultado:

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20193519.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20193626.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20193638.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20193649.png)

WPSCAN nos muestras mas cosas, en este caso tenemos un usuarios llamado mario, un directorio llamado /upload, un archivo llamado xml-rpc (igual al que encontro gobuster) y los temas que usa el wordpress.

Ahora buscando un poco de información vemos que el xmlrpc.php es vulnerable a una (external entity injection) o XXE. 

````console
DESCRIPCION RAPIDA:

- **Qué es**: Una vulnerabilidad que permite a un atacante incluir una entidad externa en un documento XML procesado por una aplicación.
- **Cómo funciona**: El atacante inserta una entidad externa en el XML, que luego es procesada por el parser XML de la aplicación.
````
Para ello vamos a ingresar a la ruta donde se encontraba el xmlrpc.php

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20194100.png)

Nos dice que solo acepta  peticiones  POST, lo que vamos hacer ahora es realizar una peticion POST pero con cURL.

````console
curl -X POST 'http://172.17.0.2/wordpress/xmlrpc.php'

# la opcion -X se utiliza para llamar o cmabiar al metodo que se quiere utilizar ya que por defecto curl utiliza el metodo GET.
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20194048.png)

Nos copiamos el contenido y lo guardamos. Seguido de eso buscamos informacion de como poder hacer la injeccion XXE.

````console
INFORMACION: https://ms-official5878.medium.com/xml-rpc-php-wordpress-vulnerabilities-9a7d66068bde
````
Colocamos estos parametros dentro de un archivo llamado exploit.xml.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20201648.png)

Con el comando curl vamos a enviar el archivo exploit.xml, usamos la misma linea solo que le agregamos el parametro "-d@exploit.xml"

Como resultado nos vuelve una lista de metodos que soporta XML-RPC en el servidor.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20201825.png)

Buscamos el siguiente apartado wp.getUsersBlogs para hacerle fuerza bruta haciendo lo siguiente:
En un archivo xml vamos a ingresar esto:

````console
<?xml version="1.0" encoding="UTF-8"?>
<methodCall> 
<methodName>wp.getUsersBlogs</methodName> 
<params> 
<param><value>\{\{your username\}\}</value></param> 
<param><value>\{\{your password\}\}</value></param> 
</params> 
</methodCall>
````

Como tenemos un usuario llamado vamos a suplantar el "your username por mario" y la contraseña cualquiera porque no tenemos.
Lo guardamos en un archivo llamado cred.xml y volvemos a usar el comando curl.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20203610.png)

El resultado nos dice que es incorrecto, pero como podemos hacer fuerza bruta ya que tenemos disponible el metodo "wp.getUsersBlogs", usamos wpscan para hacerlo.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20204027.png)

Esperamos y tenemos la contraseña.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20204044.png)

Vamos al directorio wp-login.php y entramos con estas credenciales.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20204122.png)

Una vez adentro vamos a realizar estos pasos. "ATENTOS ACA"

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20211147.png)

1) Vamos a plugins
2) vamos a plugins code editor
3) Cambiamos el tema a theme editor
4) Seleccionamos theme_editor.php

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20211237.png)

5) Borramos el contenido de theme_editor y lo suplantamos por nuestra RV.php de pestestmokey.
6) Guardamos el cambio en "Update file"
7) Nos ponemos en escucha con netcat
8) Y actualizamos la pagina, esto nos devuelve la conexion al netcat (este paso es el 7 pero me equivoque je)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20211311.png)

Una vez adentro somo el usuario www-data, hacemos el tratamiento de la tty. Ahora buscamos la manera de poder tener los maximos privilegios dentro de la maquina.

Buscamos binarios SUID y encontrasmos uno interesante llamado /env.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-23%20121549.png)

En gtfobins encontramos la mnera de poder explotar este binario, colocando el siguiente comando.
Asi que vamos al directior donde se encuentra /env y lo ejecutamos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-23%20121611.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-22%20212404.png)

SOMOS ROOT!





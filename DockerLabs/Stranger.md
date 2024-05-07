##MAQUINA STRANGER

Iniciamos la maquina y esperamos que se configure automaticamente.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20154758.png)

Una vez que ya tenemos la ip de la maquina, utilizamos nmap para realizar un escaneo de puertos y servicios que corren en la maquina.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20154901.png)

Tenemos el puerto 21,22 y 80 en abiertos, ahora vamos a usar otro comando de nmap para que nos de mas informacion sobre los servicios.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20155020.png)

Comenzamos entrando en la web, y nos recibe con lo siguiente "BIENVENIDO MWHEELER" (guardamos el nombre).

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20155328.png)

Con whatweb buscamos un pocomas de info sobre la web.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20155845.png)

Ahora con gobuster buscamos directorios ocultos, la cual el escaneo encontro uno.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20190816.png)

Vamos a la ruta encontrada y nos redirige a un blog de will (guardamos el nombre). En el apartado july 1985 > archivos : hay cosas a tener encuenta

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20160208.png)

Bien aca como no hay a donde ir, con gobuster hacemos otro escaneo de directorios pero esta vez añadiendo la ruta encontrada anteriormente.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20162708.png)

Finalizando el escaneo tenemos 2 archivos interesante, private.txt y secret.html
En la ruta secret.html nos dice que haciendo fuerza bruta con el usuario admin podemos averiguar la password.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20162202.png)

Luego el directorio private.txt nos descarga un archivo.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20162225.png)

Usamos hydra para tratar de encontrar la contraseña de admin.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20162651.png)

Con la contraseña entramos al servidor ftp > admin:banana

Dentro del ftp descargamos el archivo.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20162729.png)

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20163009.png)

El contenido descargado parece ser una id_rsa o similar.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20163504.png)

Bueno usamos chatgpt, ¿porque? porque el archivo descargado "private.txt" parece estar encriptado, la IA me dio una pista.

O��N�����f-�]�T��K.Q�a���mgu�3��i������ȉ����P�+F�8Q[  : archivo encriptado

```console
El texto que has proporcionado parece estar en un formato binario que no es legible directamente para los humanos. No parece ser un formato comúnmente utilizado para almacenar datos cifrados o encriptados, como un archivo encriptado con OpenSSL.

Si necesitas determinar si este texto está encriptado, puedes utilizar herramientas y técnicas de criptoanálisis para intentar identificar el algoritmo de cifrado y la clave utilizados. Sin embargo, sin más contexto o información sobre cómo se generó este texto, puede ser difícil determinar cómo decodificarlo o descifrarlo.
```
Usamos la tool openssl para desencriptar el msj oculto con el siguiente comando (descripciones abajo)

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20183921.png)

````console
`rsautl`: Es un comando de OpenSSL utilizado para operaciones RSA.
- `-decrypt`: Especifica que se debe realizar una operación de desencriptación.
- `-in private.txt`: Especifica el archivo de entrada que se va a desencriptar.
- `-out privateOUT.txt`: Especifica el nombre del archivo de salida donde se guardará el resultado de la desencriptación.
- `-inkey private_key.pem`: Especifica el archivo que contiene la clave privada necesaria para la desencriptacion
````
Luego leemos el archivo privateOUT.txt y la desencritacion fue exitosa, el msj dice "demogorgon".

Genial, ahora que nos queda? probar algunas credenciales que funcionen en el servicio ssh.

En este caso vamos a probar con el nombre "mwheeler" y la contraseña demogorgon.

```console
ssh mrwheeler@170.17.0.2 > password: demogorgon
````

Una vez adentro, vamos a buscar escalar privilegios para ser usuario root.

Tenemos 3 directorios. admin - mwheeler y ubuntu.

El usuario mwheeler no nos proporciona ninguna opcion util para al escalada de priv, ahora si prestamos atencion tenemos el usuario admin (que es el del ftp y tambien esta en el directorio), asi que usamos el comando "su admin" y colocamos la contraseña.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20185835.png)

Somos user admin. A buscar binarios o algo para la escalada.

Si pasamos el comando sudo -l vemos que tenemos permiso para todo, asi que si colocamos sudo su, nos vamos a loguear como root.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-06%20185956.png)

Hacemos un sudo su y listo!




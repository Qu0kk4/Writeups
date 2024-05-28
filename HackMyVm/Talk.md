## MAQUINA TALK

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20201954.png)

Realizamos un escaneo de nuestra red con arp-scan.

![imagen](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-08%20194154.png)

Luego una vez obtenida la ip de la maquina victima realizamos un escaneo con nmap para ver los puertos abiertos.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-08%20194351.png)

Nmap encontro el puerto 22 ssh y puerto 80 http abiertos, iniciamos entrando al servicio web ya que no poseemos contraseñas.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-08%20195922.png)

Una vez dentro nos encontramos con un inicio de sesion.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-08%20195151.png)

Aca vamos a tener que utilizar algun payload para hacer un bypass al inicio de sesion, para ellos podemos encontrar y utilizar varios de https://github.com/swisskyrepo/PayloadsAllTheThings.

Cuando logramos loguearnos nos encontramos con un CHAT donde nona,tina y jerry mantienen una conversacion.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-08%20195242.png)

Probamos un sql-injection con sqlmap para recabar mas información. Para eso abriremos burspuite y encenderemos el proxy e interceptaremos la petición que se hace al hacer el login.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-08%20203804.png)

Con el siguiente comando vamos a realizar un escaneo con sqlmap para ver la base de datos.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-08%20204408.png)

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20192410.png)

Obtenemos las siguientes base de datos.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20192359.png)

Continuamos usando sqlmap pero esta vez leemos la decimos nos muestra la tablas de la base de datos.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20192936.png)

Y nos arroja las siguientes tablas.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20193049.png)

Ahora queda que nos muestre todo el contenido de la tabla "USER" de la siguiente manera

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20193726.png)

Listo tenemos una lista de usuarios y contraseñas

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20194829.png)

Nos copiamos los nombre y contraseñas a un archivo .txt por separado

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20195115.png)

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20195120.png)

Con hydra vamos a realizar fuerza bruta para validar si hay credenciales positivas.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20195207.png)

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20200126.png)

En este caso tenemos 3 credenciales validas, pero la intrucion la vamos a realizar en el usario "nona"

Ingreamos atravez del ssh :D

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20200228.png)

Buscamos escalar privilegios a usuario root, en este caso probamos con sudo -l y encontramos un binario llamado LYNX con el cual podemos logearnos sin contraseña.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20200939.png)

Investigando por internet LYNX es un servicio o una especie de shell. Dejo informacion y la web en la imagen.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20201740.png)

Iniciamos lynx y luego con su lynx nos logeamos con la contraseña de nona y accedemos como usuario root.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-11%20201700.png)


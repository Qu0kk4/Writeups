## Writeup Quick3 HMV

Con arp-scan hacemos un reconocimiento para ver las maquinas conectadas a nuestra red.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20183802.png)

Nos centraremos en l siguiente ip 192.168.0.98

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20183844.png)

Una vez obtenida la ip vamos a enumerar con nmap los puertos y servicios de la maquina victima.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20183947.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20192543.png)

Tenemos el puerto 22 y el 80 abiertos, vamos a ver que contiene el puerto 80 (servidor web)

Buscamos un poco mas de informacio sobre la web utilizando wappalyzer y whatweb.

WHATWEB:

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20202853.png)

WAPPALYZER

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20202931.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20202943.png)

Ingresamos a la web y nos ponemos a buscar cosas importantes.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20184719.png)

Buscando nos encontramos con un apartado donde aparece un inicio de session.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20185927.png)

Nos registramos para ver que contiene dentro la pagina, y vemos que podemos ver los demas miembros de la empresa.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20191637.png)

Vamos a nuestro perfil.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20194356.png)

Dentro del panel de sesion vemos algo interesante.

En la url, en el sector de los parametros podemos ver que nos esta enumerando que id o sesion somos. Si lo intentamos cambiar?

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20194434.png)

Si colocamos el id=1. Pasa lo siguiente, nos muestra que id de la session quick. Por ende podemos seguir probando la cantidad de usuarios que hay hasta el numero de nuestra sesion.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20194501.png)

Podemos ver un apartado con el nombre change password, que si ingresamos podemos ver que contiene una contraseña vieja y la nueva. Con el inspec podemos ver las contraseñas ya que las mismas no estan encodeadas, esto quiere decir que estan en texto plano.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20200409.png)

Ahora lo que vamos a hacer el anotar todas contraseñas nuevas como viejas en un archivo de texto, como tambien asi los nombres de cada persona.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20200450.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20200501.png)

Ahora utilizamos hydra para ver si podemos llegar a obtener alguna contraseña.
Para ello utilizamos HYDRA

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20202521.png)

Ya tenemos un cradencial valida, ahora atravez del ssh podemos ingresar como usuario mike.

Ahora nos queda escalar privilegios root.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20202558.png)

Ya dentro del sistema vamos a ver el contenido de la web, ya que si nos acordamos pudimos ver que la web almacena contraseñas, asi que supongo que deben estar ahi.

Nos dirijimos a la carpeta /var/www/html

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20210930.png)

Y ahi un archivo llamado config.php.. lo leemos y nos da una contraseña para logearnos como root

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20210952.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-31%20211103.png)

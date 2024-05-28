## MAQUINA CAPYPENGUIN

Lanzamos un escaneo con nmap para ver los puertos interesantes que se encuentran abiertos en la maquina victima.

```console
nmap -p- -sS --open --min-rate 5000 -vvv -n -Pn IP -oN escaneo.txt
```

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20195347.png)

El reporte de nmap nos muestra los puertos 22,80 y 3306, ahora con unos scripts basicos de nmap vamos a realizar una busqueda mas detallada en lo posible de estos puertos.

```console
nmap -p22,80,3306 -sC -sV IP -oN fullscan.txt
```

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20195558.png)

Ahora que tenemos un poco mas de info sobre que corre en cada puerto, vamos a ingresar al servidor web que corre por el puerto 80.

Dentro de esta nos encontramos con una pagina de debian por default, pero si vemos en el report de nmap hay una pagina llamada "Web de Capybaras".

Asi que hacemos una busqueda de directorios ocultos con nmap.

```console
gobuster dir -u IP -w /wordlists/ -x php,html,txt -t 50
```
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20200004.png)

Tenemos un archivo llamado index.html, lo colocamos dentro de la web y nos devuelve lo siguiente.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20200013.png)

Esta web nos brinda una información importante, la cual resalto en naranja.

Podemos utilizar estas pistas en el servidor SSH y MySQL. Si pensamos un poco, ya que el MySQL corre en MariaDB, esto podría significar que se está almacenando algo importante dentro de su base de datos.

Asi que vamos a utilizar el usuario que encontramos en el servicio MySQL.

Antes que eso hay que limpiar el rockyou ya que segun la info. aparece los ultimos rangos de la tabla. Porque limpiar? porque el diccionario contiene caracteres que hacen que la base de datos nos bloquee aparte debemos invertir el rockyou.

PASO 1:
Invertimos el rockyou

```console
tac rockyou.txt > rockyou_invertido.txt
```
PASO 2:
Eliminamos lo que no nos sirve.

```console
tr -cd '[:alnum:][:space:]\n' < rockyouinvertido.txt > rockyou_limpio.txt
```
PASO 3: 
Eliminamos los espacios.

```console
tr -d ' ' < rockyou_limpio.txt > rockyou_full.txt
```
Una vez hecho esto, vamos a usar la herramienta Medusa o Hydra, la que les venga mejor. Yo lo hice con Medusa porque Hydra me fallaba, no sé por qué.

```console
medusa -h IP -u capybarauser -P wordlists -M mysql
```
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20215822.png)

Ya tenemos la password del MySQL, asi que ingresamos alli.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20220011.png)

Una vez dentro verificamos el contenido listando la base de datos utilizando 

```console
show databases;
```
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20220121.png)

Tanemos un DB llamada pinguinasio_db, asi que ingresamos con el comando:

```console
use pinguinasio_db
```
Seguido listamos la tabla del contenido de la DB con el comando:

```console
show tables;
```
![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20220632.png)

Tenemos una tabla "users" ingresamos seleccionandola:

```console
SELECT * FROM users;
```
¡Tarán! Tenemos las posibles credenciales del SSH, por ende las guardamos y nos logueamos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20220644.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20220857.png)

Una vez estamos dentro, somos el usuario Mario. Ahora vamos a buscar la manera de obtener los privilegios máximos de la máquina. Ejecutamos un `sudo -l` y vemos que `nano` no requiere contraseña y que todos pueden acceder.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20221049.png)

Buscamos en GTFOBins y vemos que hay una manera de utilizar estos comandos para loguearnos como root. Una vez ingresamos estos parámetros, pudimos obtener los privilegios máximos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20221521.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-05-27%20221513.png)










## MAQUINA BANK

Hacemos un nmap para ver los puertos abiertos dentro de la maquina

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20190727.png)

Tenemos 3 puertos abiertos el 22,53 y 80.

El puerto 22 es vulnerable a enumeracion de usuarios, pero la via no es por aca.

Si ingresamos al servicio web que corre por el puerto 80 esta nos mando a la pagina de apache por default.

Como tenemos el puerto 53 que corre el servicio de dominio de la web, para ello tenemos hay una herramienta llamada "dig" que podemos usar para realizar consultas dns como buscar la ip de un dns o buscar algun que otro registro.

````console
dig axfr @10.10.10.29 bank.htb
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20200115.png)

Como resultado tenemos varios dominios, a estos lo vamos a agregar al /etc/hosts

### !atencion! El dominio bank.htb no hubo caso de encontrarlo, lo que me resulto muy muy tedioso intentar hacer esta maquina, segun yo lo supuse que el dominio era bank.htb como varias maquinas de HTB.

Con gobuster vamos a hacer fuerza bruta a los directorios para ver si hay algunos escondidos.

````console
gobuster dir -u http://bank.htb/ -w /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-1.0.txt -t 100 -x php,html,txt
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20212736.png)

La herramienta encontro varios directorios. Vamos a ingresar en el /login.php.

Colocamos http://bank.htb/login.php y nos redirige a un panel de sesion.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20193558.png)

Al no tener credenciales vamos a fuzzear con otra herramienta llamada ffuf.

````console
ffuf -w /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt -u http://bank.htb/FUZZ
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20210151.png)

Ffuf nos encontro otro directorio: balance-transfer, por lo cual vamosa ingresar.

Este directorio contiene varias cuenta pero todas se encuentran hasheadas, pero hay una cuenta que no contiene sus credenciales hasheadas, esto lo averiguamos clickeando en el apartado "size" 
que seria el tamaño del contenido.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20210301.png)

Una vez descargado tenemos lo siguiente.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20210439.png)

Como tenemos estas credenciales, volvemos al panel de session para probar loguearnos alli.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20210527.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20210541.png)

Una vez adentro nos vamos a support.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20212610.png)

En este lugar podemos subir algun archivo con alguan extension. Leemos el codigo fuente para ver si nos da alguna informacion de como seguir.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20212717.png)

Al parecer el creador de la web dejo una nota en el cual agrego la extension .htb para ejecutar codigo php.

Seguido a esto vamos a subir un script.php para inyectar comandos php.

Creamos el script <<

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20213704.png)

Luego vamos al panel de soporte.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20213213.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20213227.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20213235.png)

Una vez subido el script vamos a ir al directorio encontrado anteriormente /uplodas pero le agregamos el nuestro script.htb?cmd=ls

Al colocar ls nos muestra lo que subimos, lo que quiere decir que nuestra inyeccion de comando funciono.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20214108.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20214119.png)

Ahora vamos a conectarnos atravez de netcat haciendo una RV, para ellos usamos burpsuite para encodear nuestra shell inversa.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20214342.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20214358.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20214329.png)

Finalmente estamos dentro de la maquina victima como usuario www-data, ahora vamos a buscar la forma de escalar privilegios para ser usuario root.

Leemos el contenido del /etc/passwd y vemos que hay un usuario llamada chris.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20214603.png)

Buscamos archivos que tengan capacidad de usuario root.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20215349.png)

Aca hay algo interesante, hay un ruta llamada /ver/htb/bin/emergency, si leemos el contenido es un script de python en el cual si lo ejecutamos nos realiza una shell para acceder como root.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20215335.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-10%20215807.png)

SOMOS ROOT!













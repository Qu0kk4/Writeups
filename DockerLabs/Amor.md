## MAQUINA AMOR <3

Hacemos un escaneo con nmap para ver los puertos abiertos en la maquina.

```bash
nmap -p80,22 -sC -sV -O 172.17.0.2 -oN fullscan.txt
```
![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20212413.png)

Nos adentramos dentro del servidor web que corre por el puerto 80 y vemos que tenemos un aviso de una empresa, el siguiente apartado es interesante.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20212609.png)

Pobre juan, pero eso no se hace!, bueno aca hay 2 posibles usuarios :), juan y carlota. Aviso que fuzzear no ayuda en nada :(.

Hacemos un whatweb para no perder la constumbre.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20212904.png)

Al tener estos usuarios vamos a realizar fuerza bruta con hydra a los 2 usuarios. En este caso es a carlota, porque juan nos defraudo.

```bash
hydra -l carlota -w /usr/share/wordlists/rockyou.txt ssh://172.17.0.2
```

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20215946.png)

Hydra nos encontra la password, asi que entramos con estas credenciales atravez del puerto 22 ssh.

```bash
ssh -p22 carlota@172.17.0.2
```

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20220033.png)

Leemos el /etc/passwd y nos muestra que hay 3 usuarios dentro de la maquina: carlota, oscar y ubuntu.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20220138.png)

Dentro de las carpetas de carlota encontramos un imagen.jpg, la cual con python vamos a abrir un servidor web y nos descargamos la imagen a nuestra maquina atacante.

```bash
Maquina Victima:

--> python3 -m http.server 8080

Maquina Atacante:

---> wget http://172.17.0.2:8080/imagen.jpg
```
![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20220613.png)

Ahora en extraemos con la herramienta steghide el contenido de la imagen:

```bash
steghide extract -sf imagen-jpg
```

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20220725.png)

Esto nos devuelve un archivo .txt que al leerlo esta encodeado en base64, asi que tambien desencodeamos.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20220748.png)

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20220843.png)

El contenido desencodeado la utilizamos para ver si pude ser la contraseña de oscar.

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20221158.png)

Ya logrando acceder como oscar vamos la menera de escalar privilegios para lograr ser usuario root, para ellos usamos sudo -l y encontramos el siguiente:

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20221330.png)

Buscamos en https://gtfobins.github.io/ si se encuentra el binario ruby dando con el

Utilizamos el script y listo :D

![img](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Screenshot%202024-05-01%20221626.png)


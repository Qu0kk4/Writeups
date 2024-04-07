# Maquian Alzhimer
![imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-19%20220438.png)

Realizamos un escaneo de red para ver cuantas maquinas hay conectadas a ella.
-netdiscover -i eth0 -r "ip local"
![imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-19%20200630.png)

*Entonces, en resumen, el comando netdiscover -i eth0 -r 192.0.0.0 se utiliza para escanear la subred 192.0.0.0 en busca de dispositivos activos, utilizando la interfaz de red eth0 en el sistema.*
La ip victima es la 192.168.0.247, tenemos un ttl de 64 por ende se trataria de una maquina linux

Ahora con nmap hacemos un escaneo de los puertos y servicios.
nmap -p- --open -sC -sV 192.168.0.247 -oN target.txt.
![imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-19%20202255.png)

Como resultado de nmap esta el puerto 21 ftp, 22 ssh y el 80 http disponibles. asi que vamos a ingresar al puerto 80.
En este caso hay un texto que dice que *"medusa se olvido de donde dejo la pass, que solo recuerda que es un archivo .txt"*:
Ya tenemos un posible usuarios: MEDUSA.

![imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-19%20202344.png)

Ahora utilizamos la herramienta dirb para buscar directorios ocultos. Una vez que termina de realizar el escaeno como resultado tenemos 3 directorios: /home, /admin y /secret.
![imagen](https://github.com/Qu0kk4/Qu0kk4/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-03-19%20202910.png)

Entramos a las rutas encontradas, en este caso el directorio secret, *medusa comenta que su contraseña esta en un archivo oculto.*
[imagen]
Y el directorio /home, *medusa comenta que lo paso al "home"*

[imagen]

Que queda ahora? volvemos a hacer fuzzing esta al directorio /secret. "dirb 192.168.0.247/secret/" y encuentra un archivo llamado /home.
*Lo estoy intentando mucho. Estoy seguro de que recuperaré mi pase.*

[imagen]

Como ya exploramos por el completo la web, ingresamos al puerto 21-ftp ya que segun el escaneo de nmap podes ingresar de forma anonima.
Dentro del ftp tenemos un archiv llamado .secretnote.txt, lo descargamos y lo leemos.
[image]

Aca hay que buscar info porque no entendia nada, asi que agarre chat gpt y le mande el texto a ver que me dice con el siguiente resultado:
*El texto parece estar haciendo referencia al conceptop de "port knocking" o "golpear puertos". Es una tecnica de seguridad que c onsiste en enviar una secuencia especifica de solicitudes de conexion a un conjunto predefinido de puertos en un server, con el fin de desencantar la apertura de un puerto adcicional, conocido como "puerto oculto o puerto de servicio".
En este caso, parece que esta indicando que si se golpean los puertos 1000, 2000 y el 3000 en el servidor en el orden correcto y la secuencia adecuada, se abrira un puerto adicional en el servidor para permitir acceso.
El port knocking es una tecnica que se utiliza a menudo para aumentar la seguridad de un servidor al ocultar los servicios o puertos abiertos, y solo permitir aceso a cuando se recibe una secuencua especifica de solicitudes de conexion. Esto puede dificultar a los atacantes descubrir y aprovechar los servicios expuestos en el server.*

Bien, seguidamente vamos a utilizar el siguiente comando:
knock $ip $puerto $puerto $puerto

[imagen]

Una vez hecho el knocking, y encontrado una posible contraseña en el archivo .txt del ftp, ingreamos como el usuario medusa al ssh.
[imagen]

Listo somos usuario medusa, aca queda escalar privilegios, para ellos hacemos un "sudo -l" como resultado:
[imagen]

Abrimos un servidor python en nuestra maquina atacante y nos enviamos el linpeas.sh a la maquina victima.
Una vez recibido el archivo le damos permiso de ejecucion "chmod +x linpeas" y lo ejecutamos.
[imagen]

Como respuesta del linpeas tenemos un binario llamado "capsh". Buscamos en gtfobins y vemos que si podemos elevar privilegios.
Ejecutamos el comando y listo.



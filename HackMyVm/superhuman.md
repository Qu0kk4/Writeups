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

![](https://github.com/Qu0kk4/Quokka/blob/main/HackMyVm/image/Captura%20de%20pantalla%202024-04-13%20223932.png)

Para decodificar esto utilize la siguiente pagina ya que no podia decifrarla.

>https://www.dcode.fr/cipher-identifier

Una vez decodifcada dice lo siguiente:

>salome doesn't want me, I'm so sad... i'm sure god is dead...

>I drank 6 liters of Paulaner.... too drunk lol. I'll write her a poem and she'll

>desire me. I'll name it salome_and_?? I don't know.

>I must not forget to save it and put a good extension because I don't have much storage

![]()


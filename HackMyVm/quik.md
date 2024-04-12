## MAQUINA QUICK

Usamos la netdiscover para ver las maquinas conectadas en nuestra red

console
>netdicover -i eth0 -r 192.x.x.x/24

Una vez que tengamos la ip, con nmap vamos a enumerar los puertos y servicios de la misma.

>nmap -p- -open -sV -sC "ip" -oN TARGET

PORT
80/tcp open http

"STATE SERVICE VERSION
Apache httpd 2.4.41 ((Ubuntu))
l_http-server-header: Apache/2.4.41 (Ubuntu)
l_http-title: Quick Automative
MAC Address: 08:00:27:41:D3:56 (Oracle VirtualBox virtual NIC)"

Como tenemos el puerto 80 disponbile ingresamos a la pagina web.

Usamos nikto para ver si hay alguna vulnerabilidad en la web.

>nikto -h "ip"

/index.php?page=http://blog.cirt.net/rfiinc.txt ?: Remote File Inclusion (RFI)

Tenemos una posible vuln. en la web, se trata de un RFI.

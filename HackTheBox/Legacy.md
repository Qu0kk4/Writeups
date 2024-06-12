## MAQUINA LEGACY

Enumeramos con nmap los puertos que estan corriendo en la maquina.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-11%20222009.png)

Luego usamos el comando -sC para que lanzar unos comando basicos de reconocimiento y el comando -sV para ver las versiones que corren en estos puertos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-11%20222018.png)

Vemos que en puerto 135 corre el servicio msrpc.

En el puerto 139/445 hay un Windows XP como sistema operativo, el nombre de la computadora llamado "legacy".

Bien ahora vamos a utilizar unos script que otorga la propio herramienta nmap.

En este caso hacemos lo siguiente en el puerto 135.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-11%20222410.png)

Esto no nos arrojo ningun resultado para este puerto, ahora vamos a probar lo mismo el puerto 139-445.

En este caso usamos el siguiente comando.

````console
nmap -p139,445 --script smb* 10.10.10.4
````

Una vez terminado el escaneo a simple vista muestra que es vulnerable a eternal-blue (smb-vulns-ms17-010), esta vuln critica ejecuta un RCE si la version de smb es v1.

En protocolos, la version del smb es v1.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-11%20224255.png)

Bien aca no vamos a aprovechar  de esta vulnerabilidad, ya que solo corre si es windows xp 64 bits.

Buscando en google si existe alguna vuln en windows xp encontramos lo siguiente.

https://www.rapid7.com/db/modules/exploit/windows/smb/ms08_067_netapi/

Podemos abusar de este exploit que es compatible con windows XP.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-11%20231323.png)

Iniciamos metasploit y colocamos la ruta que muestra en la PoC.

Una vez adentro completamos los requerimientos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-11%20231450.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-11%20232353.png)

Una vez hecho esto con el comando exploit lanzamos el ataque.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-11%20232419.png)

Obtuvimos una meterpreter y  somos el usuario administrator.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-11%20232635.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-11%20232709.png)

## MAQUINA OPTIMUM

Comenzamos haciendo un escano de puertos con la herramienta nmap.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20223814.png)

El resultado del escaneo muestra que solo esta el puerto 80 abierto, en el corre un servicio http, asi que ingresamos al navegador y colocamos la ip.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20212209.png)

Nos encontramos con esta pagina en la cual tenemos un apartado de inicio de session, un archivo directorio llamado home y mas.

Como no tenemos credenciales validas no vamos a poder logearnos, si miramos donde dice "server information", tenemos la version de la app web.

Leyendo un poco nos encontramos de con información muy importante.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20212429.png)

Y tenemos que esta version tiene un error grave.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20212452.png)

Si leemos el codigo fuente de la web vemos tambien la version y el nombre de la app.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20212030.png)

Con la herramienta searchsploit buscamos si la version de esta app web tiene alguna vulnerabilidad.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20212605.png)

En este caso vamos a utilizar Metasploit.

## DEJO INFO SOBRE EL MODULO QUE VAMOS A UTILIZAR.

````console
Rejetto HttpFileServer (HFS) es vulnerable a un ataque de ejecución remota de comandos debido a un expresión regular deficiente en el archivo ParserLib.pas. Este módulo explota los comandos de secuencias de comandos HFS al usando '%00' para omitir el filtrado. Este módulo ha sido probado con éxito en HFS 2.3b sobre Windows XP SP3, Windows 7 SP1 y Windows 8.
````

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20214856.png)

Iniciamos metasploit luego seguimos los pasos como la PoC nos indica.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20215240.png)

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20215251.png)

Una vez lanzado el exploit vemos que nos devuelve una meterpreter.

Nos logeamos como el usuario kostas.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20215259.png)

Buscamos un poco mas de informacion.

Bien hacemos un background a la sesssion y ahora vamos a utilizar un modulo de metasploit 
llamado  windows suggester para ver de que manera podemos escalar privilegios.

Para ello seleccionamos la session en la cual vamos a utilizar el exploit y lo ejecutamos.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20222832.png)

Una vez que completamos las opciones requeridas lanzamos windows suggester y obtenemos estos resultados.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20222842.png)

Estos resultados muestran que hay exploit para poder utilizar, elegimos la opcion 4 ¿PORQUE? Lo explico a continuación.

````console
Que hace este exploit?

Este módulo es un programa que se aprovecha de un error en Windows que afecta a las versiones desde Windows 7 hasta Windows 10, y también a Windows Server desde 2008 hasta 2012. Funciona tanto en computadoras de 32 bits como de 64 bits.

El problema específico está relacionado con cómo Windows maneja ciertos identificadores (como números únicos para procesos) cuando se inicia el servicio de inicio de sesión. Si el sistema tiene instalado PowerShell 2.0 o una versión más nueva y tiene dos o más núcleos de CPU (el "cerebro" que hace funcionar la computadora), entonces este programa puede explotar esa debilidad.

En términos simples, este módulo puede ser usado por alguien con intenciones maliciosas para tomar control de una computadora que tenga estas versiones de Windows y cumpla con esas condiciones específicas. Es por eso que es importante mantener actualizado tu sistema operativo y ser consciente de las amenazas potenciales cuando se navega por Internet o se descargan programas de fuentes no confiables.
````

Cuando lo seleccionamos tenemos que volver a configurar el exploit con los datos que requiere. 

Volvemos a usar la session 2

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20223105.png)

Luego una vez ejecutado esperamos... y vemos que se ejecuto con exito.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20223129.png)

Volvemos a la meterpreter y somos el administrator.

![](https://github.com/Qu0kk4/Quokk4/blob/main/HackMyVm/image/Screenshot%202024-06-15%20223139.png)





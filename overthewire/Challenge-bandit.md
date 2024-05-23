# Challenge Bandit :D

bandit0:	````cat file.txt````

bandit2:	````cat space\ in \this \filename```` 
		````cat "spaces in this filename"````
		````cat /home/bandit2/*````

bandit3:	````cat inhere/ .hidden
		find . -name .hidden  "ve el contenido de la carpeta .hidden"
		find . "muestra el contenido de la carpeta"
		find . -name .hidden | xargs  cat ````

bandit4:	````find . -name -file*  "el * muestra todo el contenido del archivo file."
		file inhere/*  "* muestra el contenido de la carpeta inhere"
		find . -name -file007 | xargs cat "con xargs cat decimos que nos imprima el contenido del archivo file007"````

###bandit5:	find . -type f -readable ! -executable -size 1033c | cat
			find . -type f -readable ! -executable -size 1033c | xargs cat "El sufijo `c` indica que el tamaño está en bytes".

###bandit6:	find / -user bandit7 -group bandit6 -size 33c 2>/dewv/null
		find / -user bandit7 -group bandit6 -size 33c 2>/dewv/null | xargs cat

bandit7:cat data.txt | wc -l # wc -l lista la cantidad de palabras que hay
		    cat data.txt | grep "millionth"
		    grep "millionth" data.txt
		    cata data.txt | awk '/millionth' # awk '//' muestra el contenido de lo que hay en el argumento '/millionth/'

bandit8:cat data.txt | sort | uniq -u "sort lista las palabras y uniq -u imprime las palabras que no estan repetidas osea que son unicas.
		    sort data.txt | uniq -u # hace lo mismo

bandit9:strings data.txt  | grep "==="

bandit10:cat data.txt | base64 -d # -d desencodea el archivo

bandit11:cat data.txt | tr '[G-ZA-Fg-za-f]' '[T-ZA-St-za-s]'

bandit12: 

#!/bin/bash

nombre_archivo_descomprimido=$(7z l contenido.gzip| grep "Name" -A 2 | tail -n 1 | awk 'NF{print $NF}'
)

7z x contenido.gzip > /dev/null 2>&1

while true; do
        7z l $nombre_archivo_descomprimido > /dev/null 2>&1

        if [ "$(echo $?)" == "0" ]; then
                siguiente_comprimido=$(7z l $nombre_archivo_descomprimido | grep "Name" -A 2 | tail -n 1 | awk 'NF{print $NF}')
                7z x $nombre_archivo_descomprimido > /dev/null 2>&1 && nombre_archivo_descomprimido=$siguiente_comprimido
        else
                cat $nombre_archivo_descomprimido; rm data* 2>/dev/null
                exit 1
        fi
done


bandit13:scp -P 2220 bandit13@bandit.labs.overthewire.org:sshkey.private # nos traemos con archivo sshkeygen.private a nuestra maquina atacante.
# luego le damos permisos 700 con chmod
# ahora iniciamos sesion atravez del ssh siendo usuario bandit14.

		 ssh -i sshkey.private bandit14@bandit.labs.overthewire.org -p2220

# una vez dentro de la maquina bandit14 vamos a la ruta y leemos el archivo "/etc/bandit_pass/bandit14"
bandit14:telnet localhost 30000 # colocamos la contraseña de bandit y nos devuelve imprime la contraseña requerida. #jN2kgmIXJ6fShzhT2avhotn4Zcka6tnt

bandit15:

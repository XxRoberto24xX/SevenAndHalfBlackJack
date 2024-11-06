#!/bin/bash

#Practica1 2021-2022, juego 7 y media 2/11/2021

#VARIABLES Y PRIMERAS COMPROBACIONES

#comprobacion de que exixte config.cfg y que tiene los permisos necesarios
if test ! -e config.cfg
then
echo "El fichero config.cfg no existe"
sleep 3
clear
exit 0
fi

if test ! -w config.cfg
then
echo "El fichero config.cfg no tiene el permiso de escritura necesario"
sleep 3
clear
exit 0
fi

if test ! -r config.cfg
then
echo "El fichero config.cfg no tiene el permiso de lectura necesario"
sleep 3
clear
exit 0
fi

TOTALPARTIDAS=0
MEDAPUESTAS=0
MEDRONDAS=0
MEDTIEMPO=0
MEDDINEROJ=0
MEDDINEROB=0
TIEMPOTOTAL=0
PORGANAJ=0
PORSYM=0

FECHA=0
HORAINI=0
HORAFIN=0
HORA=0
MONEDASINICIO=0
MONEDASBANCAINICIO=0
TIEMPOTOTAL=0
RONDAS=1
BANCAGANA=0
VICTORIABANCA="0"
NUMSYM=0
NUMSYMB=0
HORAS=0
MINUTOS=0
SEGUNDOS=0
DIA=0
MES=0
ANO=0

OPCION=0    #variable de interaccion con el usuario
RAND=0      #variable con el numero aleatorio
JUGADOR=1   #variable que indica el jugador con el que jugamos
TEMP=0      #variable auxiliar cotidiana
AUX=0
CARTA=0
CARTAS1=" " #cadenas con las cartas de cada jugador
CARTAS2=" "
CARTAS3=" "
CARTASB=" "
CONT1=0
CONT2=0
CONT3=0
CONT4=0
CONT5=0
CONT6=0
CONT7=0
CONTJ=0
CONTQ=0
CONTK=0
MEDIA=false
CONFVAC=0
FALLOG1=false
FALLOG2=false
FLAG=false  #variable para acabar el juego
FLAGR=false #variable para acabar una ronda
FLAGJ=fasle #variable para acabar la jugada de cada jugador
FLAGCARTA=false  #variable para habilitar la carta o no si esta repetida demasiadas veces
CONT=0      #variable que cuenta los puntos de los jugaores en cada ronda
PASJ1=false  #variablse para seber cuando un jugador se pasa de 7 y media
PASJ2=false
PASJ3=false
PASB=false
SYMJ1=false  #variable para seber cuando un jugador consiguio 7 y media
SYMJ2=false
SYMJ3=false
SYMB=false
CONTJ1=0     #acumulador de los puntos de los jugadores
CONTJ2=0
CONTJ3=0
CONTB=0
MEDIAJ1=false
MEDIAJ2=false
MEDIAJ3=false
MEDIAB=false

#miramos que config.cfg no este vacio, para ello debemos definir antes las funciones que necesitamos

function convac
{

while read linea
do
CONFVA=1
done <config.cfg

if test $CONFVAC -eq 0
then

echo "El fichero config.cfg esta vacio"
echo ""
echo "Desea asiganarle un valor a las variables necesarias ahora?"
echo "S) Si, entrara en el menu de configuracion   N) No, saldra del programa"

read
OPCION=$REPLY
clear

case $OPCION in

        'S' )
        leervar
        ;;
        'N' )
        exit 0
        ;;
        * )
        echo "Opcion invalida, pulse INTRO"
        read
        clear
        convac
        ;;

esac

fi

true
}

function leervar
{

        echo "CONFIGURACION"
        echo " "
        echo " "

        read -p "introduce el numero de jugadores: " jugadores
        read -p "introduce el numero de monedas de la banca: " mbanca
        read -p "introduce el numero de monedas de los jugadores: " monedas
        read -p "introduce la apuesta en cada ronda: " apuesta
        read -p "introduce el nombre del fichero de registros: " fich

        echo "JUGADORES=$jugadores" >> texto.txt
        echo "MONEDASBANCA=$mbanca" >> texto.txt
        echo "MONEDAS=$monedas" >> texto.txt
        echo "APUESTA=$apuesta" >> texto.txt
        echo "LOG=$fich" >> texto.txt

        cat texto.txt > config.cfg
        rm texto.txt

        adjvar

true
}

function compvar
{

if test $NJUGADORES -lt 1 -o $NJUGADORES -gt 3
then
echo " "
echo "NO es valido el numero de jugadores, este debe estar entre 1 y 3"
echo " "
echo "Presione ENTER"
read
clear
leervar
fi

if test $DINEROJ1 -le 0
then
echo " "
echo "NO es valido el numero de monedas de los jugadores, este debe estar por encina de 0"
echo " "
echo "Presione ENTER"
read
clear
leervar
fi

if test $DINEROB -le 0
then
echo " "
echo "NO es valido el numero de monedas de la banca, este debe estar por encina de 0"
echo " "
echo "Presione ENTER"
read
clear
leervar
fi

if test $APUESTA -le 0
then
echo " "
echo "NO es valido el numero de la apuesta, este debe estar por encina de 0"
echo " "
echo "Presione ENTER"
read
clear
leervar
fi

complog2

true
}

function adjvar
{
LINEA=1
while read lineas
do

if test $LINEA -eq 1
then
        NJUGADORES=`echo "$lineas" | cut -f 2 -d "="`
elif test $LINEA -eq 2
then
        DINEROB=`echo "$lineas" | cut -f 2 -d "="`
        MONEDASBANCAINICIO=$DINEROB
elif test $LINEA -eq 3
then
        DINEROJ1=`echo "$lineas" | cut -f 2 -d "="`
        DINEROJ2=`echo "$lineas" | cut -f 2 -d "="`
        DINEROJ3=`echo "$lineas" | cut -f 2 -d "="`
        MONEDASINICIO=$DINEROJ1
elif test $LINEA -eq 4
then
        APUESTA=`echo "$lineas" | cut -f 2 -d "="`
elif test $LINEA -eq 5
then
        LOG=`echo "$lineas" | cut -f 2 -d "="`
fi

AUX=$(($LINEA+1))
LINEA=$AUX
done < config.cfg

compvar

true
}

function complog2
{

FALLOG1=false
FALLOG2=false

clear

if test ! -e $LOG
then
echo "El fichero $LOG no existe"
echo " "
echo "Pulse INTRO"
read
clear
FALLOG1=true
fi

if test ! -w $LOG
then
echo "El fichero $LOG no tiene el permiso de escritura necesario"
echo " "
echo "Pulse INTRO"
read
clear
FALLOG2=true
fi

if test ! -r $LOG
then
echo "El fichero $LOG no tiene el permiso de lectura necesario"
echo " "
echo "Pulse INTRO"
read
clear
FALLOG2=true
fi

if test $FALLOG1 = true -o $FALLOG2 = true
then

echo " "
echo "Desea que el programa cree el fichero o cambie los permisos?"
echo "S)si       N)no, se volveran a pedir los datos"
read
OPCION=$REPLY
clear

case $REPLY in

        'S' )
        if test $FALLOG1 = true
        then
        touch $LOG
        chmod 755 $LOG
        else
        chmod 755 $LOG
        fi
        adjvar
        ;;
        'N' )
        leervar
        ;;
        * )
        echo "Opcion invalida, pulse INTRO"
        read
        clear
        complog2
        ;;

esac

fi

true
}

#ahora que estan creadas las funciones podemos llamar a convac
convac

LINEA=1

while read lineas
do

if test $LINEA -eq 1
then
        NJUGADORES=`echo "$lineas" | cut -f 2 -d "="`
elif test $LINEA -eq 2
then
        DINEROB=`echo "$lineas" | cut -f 2 -d "="`
        MONEDASBANCAINICIO=$DINEROB
elif test $LINEA -eq 3
then
        #se lo añadimos a todos independientemente de cuantos jugadores sean pues la logica del programa esta asi creada
        DINEROJ1=`echo "$lineas" | cut -f 2 -d "="`
        DINEROJ2=`echo "$lineas" | cut -f 2 -d "="`
        DINEROJ3=`echo "$lineas" | cut -f 2 -d "="`
        MONEDASINICIO=$DINEROJ1
elif test $LINEA -eq 4
then
        APUESTA=`echo "$lineas" | cut -f 2 -d "="`
elif test $LINEA -eq 5
then
        LOG=`echo "$lineas" | cut -f 2 -d "="`
fi

AUX=$(($LINEA+1))
LINEA=$AUX

done < config.cfg

#comprobamos que las variables tienen datos correctos

if test $NJUGADORES -lt 1 -o $NJUGADORES -gt 3
then
echo " "
echo "NO es valido el numero de jugadores, este debe estar entre 1 y 3"
echo " "
echo "Debe cambiar el contenido del fichero de configuracion, Presione ENTER"
read
clear
exit 0
fi

if test $DINEROJ1 -le 0
then
echo " "
echo "NO es valido el numero de monedas de los jugadores, este debe estar por encina de 0"
echo " "
echo "Debe cambiar el contenido del fichero de configuracion, Presione ENTER"
read
clear
exit 0
fi

if test $DINEROB -le 0
then
echo " "
echo "NO es valido el numero de monedas de la banca, este debe estar por encina de 0"
echo " "
echo "Debe cambiar el contenido del fichero de configuracion, Presione ENTER"
read
clear
exit 0
fi

if test $APUESTA -le 0
then
echo " "
echo "NO es valido el numero de la apuesta, este debe estar por encina de 0"
echo " "
echo "Debe cambiar el contenido del fichero de configuracion, Presione ENTER"
read
clear
exit 0
fi

function complog1
{

FALLOG1=false
FALLOG2=false

clear

if test ! -e $LOG
then
echo "El fichero $LOG no existe"
echo " "
echo "Pulse INTRO"
read
clear
FALLOG1=true
fi

if test ! -w $LOG
then
echo "El fichero $LOG no tiene el permiso de escritura necesario"
echo " "
echo "Pulse INTRO"
read
clear
FALLOG2=true
fi

if test ! -r $LOG
then
echo "El fichero $LOG no tiene el permiso de lectura necesario"
echo " "
echo "Pulse INTRO"
read
clear
FALLOG2=true
fi

if test $FALLOG1 = true -o $FALLOG2 = true
then

echo " "
echo "Deseque el programa cree el fichero o cambie los permisos?"
echo "S)si       N)no, el programa se cerrar"
read
OPCION=$REPLY
clear

case $REPLY in

        'S' )
        if test $FALLOG1 = true
        then
        touch $LOG
        chmod 755 $LOG
        else
        chmod 755 $LOG
        fi
        ;;
        'N' )
        exit 0
        ;;
        * )
        echo "Opcion invalida, pulse INTRO"
        read
        clear
        complog1
        ;;

esac

fi

true
}

#comprobamos que el fichero que nos han mostrado en LOG exixte y tiene los permisos necesarios para eso la funcion debe estar definida antes

complog1

#FUNCIONES

#Necesaria pues si tenemos "09" es decir minuto, hora o segundo 9 no podemos opear si tiene el 0 delante
function adatiempo
{

if test $HORAS = "00"
then
HORAS=0
fi

if test $HORAS = "01"
then
HORAS=1
fi

if test $HORAS = "02"
then
HORAS=2
fi

if test $HORAS = "03"
then
HORAS=3
fi

if test $HORAS = "04"
then
HORAS=4
fi

if test $HORAS = "05"
then
HORAS=5
fi

if test $HORAS = "06"
then
HORAS=6
fi

if test $HORAS = "07"
then
HORAS=7
fi

if test $HORAS = "08"
then
HORAS=8
fi

if test $HORAS = "09"
then
HORAS=9
fi


if test $MINUTOS = "00"
then
MINUTOS=0
fi

if test $MINUTOS = "01"
then
MINUTOS=1
fi

if test $MINUTOS = "02"
then
MINUTOS=2
fi

if test $MINUTOS = "03"
then
MINUTOS=3
fi

if test $MINUTOS = "04"
then
MINUTOS=4
fi

if test $MINUTOS = "05"
then
MINUTOS=5
fi

if test $MINUTOS = "06"
then
MINUTOS=6
fi

if test $MINUTOS = "07"
then
MINUTOS=7
fi

if test $MINUTOS = "08"
then
MINUTOS=8
fi

if test $MINUTOS = "09"
then
MINUTOS=9
fi


if test $SEGUNDOS = "00"
then
SEGUNDOS=0
fi

if test $SEGUNDOS = "01"
then
SEGUNDOS=1
fi

if test $SEGUNDOS = "02"
then
SEGUNDOS=2
fi

if test $SEGUNDOS = "03"
then
SEGUNDOS=3
fi

if test $SEGUNDOS = "04"
then
SEGUNDOS=4
fi

if test $SEGUNDOS = "05"
then
SEGUNDOS=5
fi

if test $SEGUNDOS = "06"
then
SEGUNDOS=6
fi

if test $SEGUNDOS = "07"
then
SEGUNDOS=7
fi

if test $SEGUNDOS = "08"
then
SEGUNDOS=8
fi

if test $SEGUNDOS = "09"
then
SEGUNDOS=9
fi

true
}

function ganabancaronda #consideramos que un jugador gana una ronda si ha conseguido un numero de puntos mayor que el resto, como es la banca en caso de empate
                        #tambien gana
{

if test $CONTB -gt $CONTJ1 -a $CONTB -gt $CONTJ2 -a $CONTB -gt $CONTJ3
then
TEMP=$(($BANCAGANA+1))
BANCAGANA=$TEMP
fi

if test $CONTB -eq $CONTJ1 -a $CONTB -eq $CONTJ2 -a $CONTB -eq $CONTJ3 -a $MEDIAB = true
then
TEMP=$(($BANCAGANA+1))
BANCAGANA=$TEMP
fi

if test $CONTB -eq $CONTJ1 -a $CONTB -eq $CONTJ2 -a $CONTB -eq $CONTJ3
then
        if test $MEDIAB = false -a $MEDIAJ1 = false -a $MEDIAJ3 = false -a $MEDIAJ3 = false
        then
        TEMP=$(($BANCAGANA+1))
        BANCAGANA=$TEMP
        fi
fi

true
}

function ganabancafinal #consideramos que la banca gana la partida si acaba con mas dinero que el resto de jugadores
{

if test $DINEROB -gt $DINEROJ1 -a $DINEROB -gt $DINEROJ2 -a $DINEROB -gt $DINEROJ3
then
VICTORIABANCA="1"
else
VICTORIABANCA="0"
fi

true
}

function mes
{

if test $MES = enero
then
MES="01"
elif test $MES = febrero
then
MES="02"
elif test $MES = marzo
then
MES="03"
elif test $MES = abril
then
MES="04"
elif test $MES = mayo
then
MES="05"
elif test $MES = junio
then
MES="06"
elif test $MES = julio
then
MES="07"
elif test $MES = agosto
then
MES="08"
elif test $MES = septiembre
then
MES="09"
elif test $MES = octubre
then
MES="10"
elif test $MES = noviembre
then
MES="11"
elif test $MES = diciembre
then
MES="12"
fi

true
}

function conteoj1
{

                if test $PASJ1 = true
                then
                TEMP=$(($DINEROJ1-$APUESTA))
                DINEROJ1=$TEMP
                TEMP=$(($DINEROB+$APUESTA))
                DINEROB=$TEMP
                        if test $SYMB = true
                        then
                        TEMP=$(($DINEROJ1-$APUESTA))
                        DINEROJ1=$TEMP
                        TEMP=$(($DINEROB+$APUESTA))
                        DINEROB=$TEMP
                        fi
                fi

                if test $PASB = true -a $PASJ1 = false -a $SYMJ1 = false
                then
                        TEMP=$(($DINEROB-$APUESTA))
                        DINEROB=$TEMP
                        TEMP=$(($DINEROJ1+$APUESTA))
                        DINEROJ1=$TEMP
                fi

                if test $SYMB = true -a $PASJ1 = false
                then
                TEMP=$(($DINEROJ1-$(($APUESTA*2))))
                DINEROJ1=$TEMP
                TEMP=$(($DINEROB+$(($APUESTA*2))))
                DINEROB=$TEMP
                fi

                if test $SYMJ1 = true
                then
                        if test $SYMB = false
                        then
                        TEMP=$(($DINEROJ1+$(($APUESTA*2))))
                        DINEROJ1=$TEMP
                        TEMP=$(($DINEROB-$(($APUESTA*2))))
                        DINEROB=$TEMP
                        fi
                fi

                if test $SYMB = false -a $SYMJ1 = false -a $PASJ1 = false -a $PASB = false
                then

                if test $CONTJ1 -lt $CONTB
                then
                TEMP=$(($DINEROJ1-$APUESTA))
                DINEROJ1=$TEMP
                TEMP=$(($DINEROB+$APUESTA))
                DINEROB=$TEMP
                fi

                if test $CONTB -lt $CONTJ1
                then
                TEMP=$(($DINEROB-$APUESTA))
                DINEROB=$TEMP
                TEMP=$(($DINEROJ1+$APUESTA))
                DINEROJ1=$TEMP
                fi

                if test $CONTB -eq $CONTJ1
                then
                        if test $MEDIAB = true
                        then
                        TEMP=$(($DINEROJ1-$APUESTA))
                        DINEROJ1=$TEMP
                        TEMP=$(($DINEROB+$APUESTA))
                        DINEROB=$TEMP
                        elif test $MEDIAB = false
                        then
                                if test $MEDIAJ1 = false
                                then
                                TEMP=$(($DINEROJ1-$APUESTA))
                                DINEROJ1=$TEMP
                                TEMP=$(($DINEROB+$APUESTA))
                                DINEROB=$TEMP
                                else
                                TEMP=$(($DINEROB-$APUESTA))
                                DINEROB=$TEMP
                                TEMP=$(($DINEROJ1+$APUESTA))
                                DINEROJ1=$TEMP
                                fi
                        fi
                fi

                fi

true
}

function conteoj2
{

                if test $PASJ2 = true
                then
                TEMP=$(($DINEROJ2-$APUESTA))
                DINEROJ2=$TEMP
                TEMP=$(($DINEROB+$APUESTA))
                DINEROB=$TEMP
                        if test $SYMB = true
                        then
                        TEMP=$(($DINEROJ2-$APUESTA))
                        DINEROJ2=$TEMP
                        TEMP=$(($DINEROB+$APUESTA))
                        DINEROB=$TEMP
                        fi
                fi

                if test $PASB = true -a $PASJ2 = false -a $SYMJ2 = false
                then
                        TEMP=$(($DINEROB-$APUESTA))
                        DINEROB=$TEMP
                        TEMP=$(($DINEROJ2+$APUESTA))
                        DINEROJ2=$TEMP
                fi

                if test $SYMB = true -a $PASJ2 = false
                then
                TEMP=$(($DINEROJ2-$(($APUESTA*2))))
                DINEROJ2=$TEMP
                TEMP=$(($DINEROB+$(($APUESTA*2))))
                DINEROB=$TEMP
                fi

                if test $SYMJ2 = true
                then
                        if test $SYMB = false
                        then
                        TEMP=$(($DINEROJ2+$(($APUESTA*2))))
                        DINEROJ2=$TEMP
                        TEMP=$(($DINEROB-$(($APUESTA*2))))
                        DINEROB=$TEMP
                        fi
                fi

                if test $SYMB = false -a $SYMJ2 = false -a $PASJ2 = false -a $PASB = false
                then

                if test $CONTJ2 -lt $CONTB
                then
                TEMP=$(($DINEROJ2-$APUESTA))
                DINEROJ2=$TEMP
                TEMP=$(($DINEROB+$APUESTA))
                DINEROB=$TEMP
                fi

                if test $CONTB -lt $CONTJ2
                then
                TEMP=$(($DINEROB-$APUESTA))
                DINEROB=$TEMP
                TEMP=$(($DINEROJ2+$APUESTA))
                DINEROJ2=$TEMP
                fi

                if test $CONTB -eq $CONTJ2
                then
                        if test $MEDIAB = true
                        then
                        TEMP=$(($DINEROJ2-$APUESTA))
                        DINEROJ2=$TEMP
                        TEMP=$(($DINEROB+$APUESTA))
                        DINEROB=$TEMP
                        elif test $MEDIAB = false
                        then
                                if test $MEDIAJ2 = false
                                then
                                TEMP=$(($DINEROJ2-$APUESTA))
                                DINEROJ2=$TEMP
                                TEMP=$(($DINEROB+$APUESTA))
                                DINEROB=$TEMP
                                else
                                TEMP=$(($DINEROB-$APUESTA))
                                DINEROB=$TEMP
                                TEMP=$(($DINEROJ2+$APUESTA))
                                DINEROJ2=$TEMP
                                fi
                        fi
                fi

                fi
true
}

function conteoj3
{

                if test $PASJ3 = true
                then
                TEMP=$(($DINEROJ3-$APUESTA))
                DINEROJ3=$TEMP
                TEMP=$(($DINEROB+$APUESTA))
                DINEROB=$TEMP
                        if test $SYMB = true
                        then
                        TEMP=$(($DINEROJ3-$APUESTA))
                        DINEROJ3=$TEMP
                        TEMP=$(($DINEROB+$APUESTA))
                        DINEROB=$TEMP
                        fi
                fi

                if test $PASB = true -a $PASJ3 = false
                then
                        TEMP=$(($DINEROB-$APUESTA))
                        DINEROB=$TEMP
                        TEMP=$(($DINEROJ3+$APUESTA))
                        DINEROJ3=$TEMP
                fi

                if test $SYMB = true -a $PASJ3 = false -a $SYMJ3 = false
                then
                TEMP=$(($DINEROJ3-$(($APUESTA*2))))
                DINEROJ3=$TEMP
                TEMP=$(($DINEROB+$(($APUESTA*2))))
                DINEROB=$TEMP
                fi

                if test $SYMJ3 = true
                then
                        if test $SYMB = false
                        then
                        TEMP=$(($DINEROJ3+$(($APUESTA*2))))
                        DINEROJ3=$TEMP
                        TEMP=$(($DINEROB-$(($APUESTA*2))))
                        DINEROB=$TEMP
                        fi
                fi

                if test $SYMB = false -a $SYMJ3 = false -a $PASJ3 = false -a $PASB = false
                then

                if test $CONTJ3 -lt $CONTB
                then
                TEMP=$(($DINEROJ3-$APUESTA))
                DINEROJ3=$TEMP
                TEMP=$(($DINEROB+$APUESTA))
                DINEROB=$TEMP
                fi

                if test $CONTB -lt $CONTJ2
                then
                TEMP=$(($DINEROB-$APUESTA))
                DINEROB=$TEMP
                TEMP=$(($DINEROJ3+$APUESTA))
                DINEROJ3=$TEMP
                fi

                if test $CONTB -eq $CONTJ3
                then
                        if test $MEDIAB = true
                        then
                        TEMP=$(($DINEROJ3-$APUESTA))
                        DINEROJ3=$TEMP
                        TEMP=$(($DINEROB+$APUESTA))
                        DINEROB=$TEMP
                        elif test $MEDIAB = false
                        then
                                if test $MEDIAJ3 = false
                                then
                                TEMP=$(($DINEROJ3-$APUESTA))
                                DINEROJ3=$TEMP
                                TEMP=$(($DINEROB+$APUESTA))
                                DINEROB=$TEMP
                                else
                                TEMP=$(($DINEROB-$APUESTA))
                                DINEROB=$TEMP
                                TEMP=$(($DINEROJ3+$APUESTA))
                                DINEROJ3=$TEMP
                                fi
                        fi
                fi

                fi

true
}

function resetvar
{

PASJ1=false
PASJ2=false
PASJ3=false
PASB=false
SYMJ1=false
SYMJ2=false
SYMJ3=false
SYMB=false
CONTJ1=0
CONTJ2=0
CONTJ3=0
CONTB=0
MEDIAJ1=false
MEDIAJ2=false
MEDIAJ3=false
MEDIAB=false

false

}

function inccont
{

if test $RAND -le 7
then
TEMP=$(($CONT+$RAND))
CONT=$TEMP
elif test $MEDIA = false
then
MEDIA=true
else
TEMP=$(($CONT+1))
CONT=$TEMP
MEDIA=false
fi

false

}

function compfin
{

if test $CONT -ge 8
then
FLAGJ=true

        if test $NJUGADORES = 1
        then
                if test $JUGADOR = 1
                then
                PASJ1=true
                else
                PASB=true
                fi
        fi

        if test $NJUGADORES = 2
        then
                if test $JUGADOR = 1
                then
                PASJ1=true
                elif test $JUGADOR = 2
                then
                PASJ2=true
                else
                PASB=true
                fi
        fi

        if test $NJUGADORES = 3
        then
                if test $JUGADOR = 1
                then
                PASJ1=true
                elif test $JUGADOR = 2
                then
                PASJ2=true
                elif test $JUGADOR = 3
                then
                PASJ3=true
                else
                PASB=true
                fi
        fi

fi

false

}

function compsindinero
{

if test $DINEROJ1 -lt $APUESTA -o $DINEROJ2 -lt $APUESTA -o $DINEROJ3 -lt $APUESTA -o $DINEROB -lt $APUESTA
then

if test $DINEROJ1 -lt 0
then
DINEROJ1=0
fi

if test $DINEROJ2 -lt 0 -o $NJUGADORES -lt 2
then
DINEROJ2=0
fi

if test $DINEROJ3 -lt 0 -o $NJUGADORES -lt 3
then
DINEROJ3=0
fi

if test $DINEROB -lt 0
then
DINEROB=0
fi

#hemos pasado los numeros negativos a 0 para que no salga en pantalla dinero negativo y para que al guardar los datos no aparezca "-" que es un separador

        FLAG=true
        echo ""
        echo "_______________________________________________________"
        echo ""
        echo "GAME OVER"
        echo ""
        echo "MONEDERO J1: $DINEROJ1"
        echo "MONEDERO J2: $DINEROJ2"
        echo "MONEDERO J3: $DINEROJ3"
        echo ""
        echo "MONEDERO BANCA: $DINEROB"
        echo ""
        echo ""
        echo ""
        ganabancafinal
else
TEMP=$(($RONDAS+1))
RONDAS=$TEMP
fi

false

}

function compsieteymedia
{

if test $CONT -eq 7
then
        if test $MEDIA = true
        then
        FLAGJ=true

                if test $NJUGADORES = 1
                then
                        if test $JUGADOR = 1
                        then
                        SYMJ1=true
                        TEMP=$(($NUMSYM+1))
                        NUMSYM=$TEMP
                        else
                        SYMB=true
                        TEMP=$(($NUMSYMB+1))
                        NUMSYMB=$TEMP
                        fi
                fi

                if test $NJUGADORES = 2
                then
                        if test $JUGADOR = 1
                        then
                        SYMJ1=true
                        TEMP=$(($NUMSYM+1))
                        NUMSYM=$TEMP
                        elif test $JUGADOR = 2
                        then
                        SYMJ2=true
                        TEMP=$(($NUMSYM+1))
                        NUMSYM=$TEMP
                        else
                        SYMB=true
                        TEMP=$(($NUMSYMB+1))
                        NUMSYMB=$TEMP
                        fi
                fi

                if test $NJUGADORES = 3
                then
                        if test $JUGADOR = 1
                        then
                        SYMJ1=true
                        TEMP=$(($NUMSYM+1))
                        NUMSYM=$TEMP
                        elif test $JUGADOR = 2
                        then
                        SYMJ2=true
                        TEMP=$(($NUMSYM+1))
                        NUMSYM=$TEMP
                        elif test $JUGADOR = 3
                        then
                        SYMJ3=true
                        TEMP=$(($NUMSYM+1))
                        NUMSYM=$TEMP
                        else
                        SYMB=true
                        TEMP=$(($NUMSYMB+1))
                        NUMSYMB=$TEMP
                        fi
                fi

        fi
fi

true

}

function resetcartas
{

CARTAS1=" "
CARTAS2=" "
CARTAS3=" "
CARTASB=" "

CONT1=0
CONT2=0
CONT3=0
CONT4=0
CONT5=0
CONT6=0
CONT7=0
CONTJ=0
CONTQ=0
CONTK=0

true

}

function sumacarta1
{

TEMP="$CARTAS1 $CARTA"
CARTAS1="$TEMP"

true

}

function sumacarta2
{

TEMP="$CARTAS2 $CARTA"
CARTAS2="$TEMP"

true

}

function sumacarta3
{

TEMP="$CARTAS3 $CARTA"
CARTAS3="$TEMP"

true

}

function sumacartab
{

TEMP="$CARTASB $CARTA"
CARTASB="$TEMP"

true

}

function interjuego
{
if test $NJUGADORES -eq 3
then
echo " "
echo "RONDA: $RONDAS"
echo " "
echo " "
echo " "
echo " "
echo "JUGADOR 1: $CARTAS1"
echo "MONEDAS J1: $DINEROJ1"
echo " "
echo "JUGADOR 2: $CARTAS2"
echo "MONEDAS J2: $DINEROJ2"
echo " "
echo "JUGADOR 3: $CARTAS3"
echo "MONEDAS J3: $DINEROJ3"
echo " "
echo " "
echo " "
echo "BANCA: $CARTASB"
echo "MONEDAS BANCA: $DINEROB"
echo " "
fi

if test $NJUGADORES -eq 2
then

echo " "
echo "RONDA: $RONDAS"
echo " "
echo " "
echo " "
echo " "
echo "JUGADOR 1: $CARTAS1"
echo "MONEDAS J1: $DINEROJ1"
echo " "
echo "JUGADOR 2: $CARTAS2"
echo "MONEDAS J2: $DINEROJ2"
echo " "
echo " "
echo " "
echo "BANCA: $CARTASB"
echo "MONEDAS BANCA: $DINEROB"
echo " "
fi

if test $NJUGADORES -eq 1
then

echo " "
echo "RONDA: $RONDAS"
echo " "
echo " "
echo " "
echo " "
echo "JUGADOR 1: $CARTAS1"
echo "MONEDAS J1: $DINEROJ1"
echo " "
echo " "
echo " "
echo "BANCA: $CARTASB"
echo "MONEDAS BANCA: $DINEROB"
echo " "
fi

compfin

if test $FLAGJ = false
then
compsieteymedia
fi

if test $FLAGJ = false
then
echo " "
echo " "
echo "N)NUEVA CARTA   P)PASAR"
echo " "

read
OPCION=$REPLY

case $OPCION in
        'N' )
        ;;
        'P' )
        FLAGJ=true

        if test $NJUGADORES = 1
        then
                if test $JUGADOR = 1
                then
                CONTJ1=$CONT
                MEDIAJ1=$MEDIA
                else
                CONTB=$CONT
                MEDIAB=$MEDIA
                fi
        fi

        if test $NJUGADORES = 2
        then
                if test $JUGADOR = 1
                then
                CONTJ1=$CONT
                MEDIAJ1=$MEDIA
                elif test $JUGADOR = 2
                then
                CONTJ2=$CONT
                MEDIAJ2=$MEDIA
                else
                CONTB=$CONT
                MEDIAB=$MEDIA
                fi
        fi

        if test $NJUGADORES = 3
        then
                if test $JUGADOR = 1
                then
                CONTJ1=$CONT
                MEDIAJ1=$MEDIA
                elif test $JUGADOR = 2
                then
                CONTJ2=$CONT
                MEDIAJ2=$MEDIA
                elif test $JUGADOR = 3
                then
                CONTJ3=$CONT
                MEDIAJ3=$MEDIA
                else
                CONTB=$CONT
                MEDIAB=$MEDIA
                fi
        fi
        ;;
        * )
        echo "opcion invalida, Presino ENTER"
        read
        clear
        interjuego
        ;;
esac

fi

true

}

function carta
{

#con el numero aleatorio representara la carta
if test $RAND -le 7
then
CARTA=$RAND
elif test $RAND -eq 8
then
CARTA=J
elif test $RAND -eq 9
then
CARTA=Q
else
CARTA=K
fi

true

}

function rand
{

#primero usamos la fecha para obtener de los segundos un numero aleatorio segun el momento
#en que se llame a la funcion
RAND=$RANDOM

#ahora debemos hacer que ese numero este ente 1 y 10 para representar las cartas en cada palo
# 8=sota, 9=caballo, 10=ret

TEMP=$(($RAND % 10))
RAND=$(($TEMP + 1))

true

}

function menu
{

echo " "
echo "C)CONFIGURACION"
echo "J)JUGAR"
echo "E)ESTADISTICAS"
echo "F)CLASIFICACION"
echo "S)SALIR"
echo ""SieteYMedia". Introduzca una opcion>>"
echo " "
true
}

function nucleo
{

read
OPCION=$REPLY
#ya tenemos guardada la seleccion del usuario

case $OPCION in
        'C' )
        clear
        leervar  #lee y comprueba que los datos metidos son validos

        echo "Pulse INTRO para continuar"
        read
        clear
        menu
        nucleo
        ;;
        'J' )
        echo " "
        echo " "
        echo " "

        FLAG=false
        RONDAS=1

        while test $FLAG = false
        do

                FLAGR=false
                JUGADOR=1
                resetcartas
                resetvar

                while test $FLAGR = false
                do

                        FLAGJ=false
                        CONT=0
                        MEDIA=false

                        while test $FLAGJ = false
                        do
                                clear
                                FLAGCARTA=false

                                while test $FLAGCARTA = false
                                do

                                rand
                                carta
                                if test $CARTA = 1
                                then
                                        if test $CONT1 -le 3
                                        then
                                                TEMP=$(($CONT1+1))
                                                CONT1=$TEMP
                                                FLAGCARTA=true
                                        fi
                                fi

                                if test $CARTA = 2
                                then
                                        if test $CONT2 -le 3
                                        then
                                                TEMP=$(($CONT2+1))
                                                CONT2=$TEMP
                                                FLAGCARTA=true
                                        fi
                                fi

                                if test $CARTA = 3
                                then
                                        if test $CONT3 -le 3
                                        then
                                                TEMP=$(($CONT3+1))
                                                CONT3=$TEMP
                                                FLAGCARTA=true
                                        fi
                                fi

                                if test $CARTA = 4
                                then
                                        if test $CONT4 -le 3
                                        then
                                                TEMP=$(($CONT4+1))
                                                CONT4=$TEMP
                                                FLAGCARTA=true
                                        fi
                                fi

                                if test $CARTA = 5
                                then
                                        if test $CONT5 -le 3
                                        then
                                                TEMP=$(($CONT5+1))
                                                CONT5=$TEMP
                                                FLAGCARTA=true
                                        fi
                                fi

                                if test $CARTA = 6
                                then
                                        if test $CONT6 -le 3
                                        then
                                                TEMP=$(($CONT6+1))
                                                CONT6=$TEMP
                                                FLAGCARTA=true
                                        fi
                                fi

                                if test $CARTA = 7
                                then
                                        if test $CONT7 -le 3
                                        then
                                                TEMP=$(($CONT7+1))
                                                CONT7=$TEMP
                                                FLAGCARTA=true
                                        fi
                                fi

                                if test $CARTA = J
                                then
                                        if test $CONTJ -le 3
                                        then
                                                TEMP=$(($CONTJ+1))
                                                CONTJ=$TEMP
                                                FLAGCARTA=true
                                        fi
                                fi

                                if test $CARTA = Q
                                then
                                        if test $CONTQ -le 3
                                        then
                                                TEMP=$(($CONTQ+1))
                                                CONTQ=$TEMP
                                                FLAGCARTA=true
                                        fi
                                fi

                                if test $CARTA = K
                                then
                                        if test $CONTK -le 3
                                        then
                                                TEMP=$(($CONTK+1))
                                                CONTK=$TEMP
                                                FLAGCARTA=true
                                        fi
                                fi

                                done

                                if test $NJUGADORES -eq 1
                                then
                                        if test $JUGADOR -eq 1
                                        then
                                                sumacarta1
                                                inccont
                                        else
                                                sumacartab
                                                inccont
                                        fi
                                elif test $NJUGADORES -eq 2
                                then
                                        if test $JUGADOR -eq 1
                                        then
                                                sumacarta1
                                                inccont
                                        elif test $JUGADOR -eq 2
                                        then
                                                sumacarta2
                                                inccont
                                        else
                                                sumacartab
                                                inccont
                                        fi
                                else
                                        if test $JUGADOR -eq 1
                                        then
                                                sumacarta1
                                                inccont
                                        elif test $JUGADOR -eq 2
                                        then
                                                sumacarta2
                                                inccont
                                        elif test $JUGADOR -eq 3
                                        then
                                                sumacarta3
                                                inccont
                                        else
                                                sumacartab
                                                inccont
                                        fi
                                fi

                                interjuego

                        done

                        TEMP=$(($JUGADOR+1))
                        JUGADOR=$TEMP

                        if test $JUGADOR -gt $(($NJUGADORES+1))
                        then
                        FLAGR=true
                        fi


                done

                #aqui van los calculos de las monedas de cada jugador

                if test $NJUGADORES -eq 1
                then
                conteoj1
                elif test $NJUGADORES -eq 2
                then
                conteoj1
                conteoj2
                else
                conteoj1
                conteoj2
                conteoj3
                fi

                ganabancaronda
                compsindinero

        done

        #aqui empezamos a tratar los datos para guardarlos en el fichero log

        #debemos hacer esta comprobacion pues para los dias con un solo digito el formato es "lunes,  1 de noviembre de 2021, 11:12:12 CET" y el campo de la hora
        #pasa a se el 8 y no el 7 como era en fechas como "lunes, 21 de noviembre de 2021, 11:12:12 CET"

        AUX=`date | cut -f 2 -d " "`

        if test ! $AUX = " "
        then

        DIA=`date | cut -f 2 -d " "`
        MES=`date | cut -f 4 -d " "`
        mes
        ANO=`date | cut -f 6 -d " " | cut -f 2 -d "0" | cut -c 1-2`  #el ultimo corte de la coma es para quitar esa coma de FECHA
        FECHA="$DIA$MES$ANO"

        HORA=`date | cut -f 7 -d " "`
        else

        DIA=`date | cut -f 3 -d " "`
        MES=`date | cut -f 5 -d " "`
        mes
        ANO=`date | cut -f 7 -d " " | cut -f 2 -d "0" | cut -c 1-2`  #el ultimo corte de la coma es para quitar esa coma de FECHA
        FECHA="0$DIA$MES$ANO"

        HORA=`date | cut -f 8 -d " "`

        fi

        HORAS=`echo "$HORA" | cut -f 1 -d ":"`
        MINUTOS=`echo "$HORA" | cut -f 2 -d ":"`
        SEGUNDOS=`echo "$HORA" | cut -f 3 -d ":"`

        adatiempo

        TEMP=$(($HORAS*3600))
        HORAFIN=$TEMP

        AUX=$(($MINUTOS*60))
        TEMP=$(($HORAFIN+$AUX))
        HORAFIN=$TEMP

        TEMP=$(($HORAFIN+$SEGUNDOS))
        HORAFIN=$TEMP

        TEMP=$(($HORAFIN-$HORAINI))
        TIEMPOTOTAL="$TEMP"


TEMP="$FECHA|$HORA|$NJUGADORES|$MONEDASINICIO|$MONEDASBANCAINICIO|$APUESTA|1.$DINEROJ1-2.$DINEROJ2-3.$DINEROJ3|$DINEROB|$TIEMPOTOTAL|$RONDAS|$BANCAGANA|$VICTORIABANCA|$NUMSYM|$NUMSYMB"
        echo "$TEMP" >> $LOG

        echo " "
        echo "Pulse INTRO para continuar"
        read
        clear
        menu
        nucleo
        ;;
        'E' )
        clear
        echo "ESTADISTICAS"
        echo " "
        echo " "

        TOTALPARTIDAS=0
        MEDAPUESTAS=0
        MEDRONDAS=0
        MEDTIEMPO=0
        MEDDINEROJ=0
        MEDDINEROB=0
        TIEMPOTOTAL=0
        PORGANAJ=0
        PORSYM=0

        #los datos de medias y porcentajes estaran truncados pues bash solo permite trabajar con int

        while read linea
        do

        TEMP=$(($TOTALPARTIDAS+1))
        TOTALPARTIDAS=$TEMP

        AUX=`echo "$linea" | cut -f 6 -d "|"`
        TEMP=$(($MEDAPUESTAS+$AUX))
        MEDAPUESTAS=$TEMP

        AUX=`echo "$linea" | cut -f 10 -d "|"`
        TEMP=$(($MEDRONDAS+$AUX))
        MEDRONDAS=$TEMP

        AUX=`echo "$linea" | cut -f 9 -d "|"`
        TEMP=$(($MEDTIEMPO+$AUX))
        MEDTIEMPO=$TEMP

        AUX=`echo "$linea" | cut -f 4 -d "|"`
        TEMP=$(($MEDDINEROJ+$AUX))
        MEDDINEROJ=$TEMP

        AUX=`echo "$linea" | cut -f 5 -d "|"`
        TEMP=$(($MEDDINEROB+$AUX))
        MEDDINEROB=$TEMP

        AUX=`echo "$linea" | cut -f 12 -d "|"`
        if test $AUX = 0
        then
        TEMP=$(($PORGANAJ+1))
        PORGANAJ=$TEMP
        fi

        #contamos el numero de partidas en las cuales almenos una vez alguien ha sacado siete y media

        AUX=`echo "$linea" | cut -f 13 -d "|"`
        if test ! $AUX = 0
        then
        TEMP=$(($PORSYM+1))
        PORSYM=$TEMP
        else
        AUX=`echo "$linea" | cut -f 14 -d "|"`
        if test ! $AUX = 0
        then
        TEMP=$(($PORSYM+1))
        PORSYM=$TEMP
        fi
        fi

        done < $LOG

        #al llegar aqui ya tenemos todos los sumatorios de los datos que necesitamos para sacar las medias y porcentajes
        #primero comprobaremos que se haya jugado almenos una partida y en caso afirmativo ponemos los datos

        if test $TOTALPARTIDAS -gt 0
        then

        TIEMPOTOTAL=$MEDTIEMPO

        TEMP=$(($MEDAPUESTAS/$TOTALPARTIDAS))
        MEDAPUESTAS=$TEMP

        TEMP=$(($MEDRONDAS/$TOTALPARTIDAS))
        MEDRONDAS=$TEMP

        TEMP=$(($MEDTIEMPO/$TOTALPARTIDAS))
        MEDTIEMPO=$TEMP

        TEMP=$(($MEDDINEROJ/$TOTALPARTIDAS))
        MEDDINEROJ=$TEMP

        TEMP=$(($MEDDINEROB/$TOTALPARTIDAS))
        MEDDINEROB=$TEMP

        AUX=$(($PORGANAJ*100))
        TEMP=$(($AUX/$TOTALPARTIDAS))
        PORGANAJ=$TEMP

        #porcentaje de partidas en las que almenos una participante ha sacado siete y media
        AUX=$(($PORSYM*100))
        TEMP=$(($AUX/$TOTALPARTIDAS))
        PORSYM=$TEMP

        #ahora que tenemos todos los calculos los sacamos por pantalla
        echo "Total de partidas jugadas: $TOTALPARTIDAS"
        echo "Media de las apuestas: $MEDAPUESTAS"
        echo "Media de rondas en cada partida: $MEDRONDAS"
        echo "Media de tiempos que dura cada partida: $MEDTIEMPO"
        echo "Media de los monederos con los que empiezan los jugadores: $MEDDINEROJ"
        echo "Media del monedero con el que empieza la banca: $MEDDINEROB"
        echo "Total de tiempo jugado: $TIEMPOTOTAL"
        echo "Los jugadores ganan a la banca un $PORGANAJ % de las veces"
        echo "Almenos un participante saca siete y media en el $PORSYM % de las partidas"
        echo ""
        echo ""

        else
        echo "Todabia no se tienen registros de ninguna partida jugada"
        echo ""
        echo ""
        fi

        echo "Pulse INTRO para continuar"
        read
        clear
        menu
        nucleo
        ;;
        'F' )
        clear
        echo "CLASIFICACION"
        echo " "
        echo " "

        #antes de empezar las comparaciones les damos como valor inicial los valores de la primera variable

        LINEAS=0

        while read linea
        do
        TEMP=$(($LINEAS+1))
        LINEAS=$TEMP
        if test $LINEAS -eq 1
        then

        PMASCORTA=`echo "$linea" | cut -f 9 -d "|"`
        PMASLARGA=`echo "$linea" | cut -f 9 -d "|"`
        PMASRONDAS=`echo "$linea" | cut -f 10 -d "|"`
        PMENOSRONDAS=`echo "$linea" | cut -f 10 -d "|"`
        PMASAPUESTA=`echo "$linea" | cut -f 6 -d "|"`
        PMASMONEDASB=`echo "$linea" | cut -f 8 -d "|"`
        PMASMONEDASJ1=`echo "$linea" | cut -f 7 -d "|" | cut -f 1 -d "-" | cut -f 2 -d "."`
        PMASMONEDASJ2=`echo "$linea" | cut -f 7 -d "|" | cut -f 2 -d "-" | cut -f 2 -d "."`
        PMASMONEDASJ3=`echo "$linea" | cut -f 7 -d "|" | cut -f 3 -d "-" | cut -f 2 -d "."`
        if test $PMASMONEDASJ1 -ge $PMASMONEDASJ2 -a $PMASMONEDASJ1 -ge $PMASMONEDASJ3
        then
        PMASMONEDASJ=$PMASMONEDASJ1
        elif test $PMASMONEDASJ2 -ge $PMASMONEDASJ1 -a $PMASMONEDASJ2 -ge $PMASMONEDASJ3
        then
        PMASMONEDASJ=$PMASMONEDASJ2
        elif test $PMASMONEDASJ3 -ge $PMASMONEDASJ1 -a $PMASMONEDASJ3 -ge $PMASMONEDASJ2
        then
        PMASMONEDASJ=$PMASMONEDASJ3
        fi

        DATPMASCORTA=$linea
        DATPMASLARGA=$linea
        DATPMASRONDAS=$linea
        DATPMENOSRONDAS=$linea
        DATPMASAPUESTA=$linea
        DATPMASMONEDASB=$linea
        DATPMASMONEDASJ=$linea

        else

        TEMP=`echo "$linea" | cut -f 9 -d "|"`
        if test $TEMP -lt $PMASCORTA
        then
        PMASCORTA=$TEMP
        DATPMASCORTA=$linea
        fi

        TEMP=`echo "$linea" | cut -f 9 -d "|"`
        if test $TEMP -gt $PMASLARGA
        then
        PMASLARGA=$TEMP
        DATPMASLARGA=$linea
        fi

        TEMP=`echo "$linea" | cut -f 10 -d "|"`
        if test $TEMP -gt $PMASRONDAS
        then
        PMASRONDAS=$TEMP
        DATPMASRONDAS=$linea
        fi

        TEMP=`echo "$linea" | cut -f 10 -d "|"`
        if test $TEMP -lt $PMENOSRONDAS
        then
        PMENOSRONDAS=$TEMP
        DATPMENOSRONDAS=$linea
        fi

        TEMP=`echo "$linea" | cut -f 6 -d "|"`
        if test $TEMP -gt $PMASAPUESTA
        then
        PMASAPUESTA=$TEMP
        DATPMASAPUESTA=$linea
        fi

        TEMP=`echo "$linea" | cut -f 8 -d "|"`
        if test $TEMP -gt $PMASMONEDASB
        then
        PMASMONEDASB=$TEMP
        DATPMASMONEDASB=$linea
        fi

        PMASMONEDASJ1=`echo "$linea" | cut -f 7 -d "|" | cut -f 1 -d "-" | cut -f 2 -d "."`
        PMASMONEDASJ2=`echo "$linea" | cut -f 7 -d "|" | cut -f 2 -d "-" | cut -f 2 -d "."`
        PMASMONEDASJ3=`echo "$linea" | cut -f 7 -d "|" | cut -f 3 -d "-" | cut -f 2 -d "."`
        if test $PMASMONEDASJ1 -ge $PMASMONEDASJ2 -a $PMASMONEDASJ1 -ge $PMASMONEDASJ3
        then
                if test $PMASMONEDASJ1 -gt $PMASMONEDASJ
                then
                PMASMONEDASJ=$PMASMONEDASJ1
                DATPMASMONEDASJ=$linea
                fi
        elif test $PMASMONEDASJ2 -ge $PMASMONEDASJ1 -a $PMASMONEDASJ2 -ge $PMASMONEDASJ3
        then
                if test $PMASMONEDASJ2 -gt $PMASMONEDASJ
                then
                PMASMONEDASJ=$PMASMONEDASJ2
                DATPMASMONEDASJ=$linea
                fi
        elif test $PMASMONEDASJ3 -ge $PMASMONEDASJ1 -a $PMASMONEDASJ3 -ge $PMASMONEDASJ2
        then
                if test $PMASMONEDASJ3 -gt $PMASMONEDASJ
                then
                PMASMONEDASJ=$PMASMONEDASJ3
                DATPMASMONEDASJ=$linea
                fi
        fi

        fi

        done < $LOG

        if test $LINEAS -eq 0
        then

        echo "Todabia no se tienen registros de ninguna partida jugada"
        echo ""
        echo ""

        else

        echo "La partida mas corta duro: $PMASCORTA seg"
        echo "La partida mas larga duro: $PMASLARGA seg"
        echo "La partida con mas rondas son: $PMASRONDAS"
        echo "La partida con menos rondas son: $PMENOSRONDAS"
        echo "La partida con la apuesta mayor era: $PMASAPUESTA"
        echo "La partida en la que la banca acabo con mas monedas tenia: $PMASMONEDASB"
        echo "La partida en la que un jugador consiguio mas monedas tenia: $PMASMONEDASJ"
        echo " "
        echo " "
        echo " "

        echo "PMASCORTA   |$DATPMASCORTA"
        echo "PMASLARGA   |$DATPMASLARGA"
        echo "PMASRONDAS  |$DATPMASRONDAS"
        echo "PMENOSRONDAS|$DATPMENOSRONDAS"
        echo "PMASAPUESTA |$DATPMASAPUESTA"
        echo "PMASMONEDASB|$DATPMASMONEDASB"
        echo "PMASMONEDASJ|$DATPMASMONEDASJ"
        echo ""
        echo ""
        echo ""

        fi

        echo "Pulse INTRO para continuar"
        read
        clear
        menu
        nucleo
        ;;
        'S' )
        clear
        exit 0
        ;;
        * )
        echo "Opcion invalida, Pulse INTRO para continuar"
        read
        clear
        menu
        nucleo
        ;;
esac
true
}
#PROGRAMA

#primero comprobamos si la invocacion a la funcion es valida

if test "$*" = "-g"
then
clear
echo Programa creado por Victor Orega Ramos Y Roberto Gonzalez Navas 2/11/2021
echo ""
echo "pulse INTRO"
read
clear
exit 0
elif test $# -eq 0
then
echo "" #si entra aqui simplemente continua el programa
else
echo NUMERO Y TIPO INVALIDO DE ARGUMENTOS
exit 1
fi

#debemos hacer esta comprobacion pues para los dias con un solo digito el formato es "lunes,  1 de noviembre de 2021, 11:12:12 CET" y el campo de la hora pasa
#a se el 8 y no el 7 como era en fechas como "lunes, 21 de noviembre de 2021, 11:12:12 CET"

AUX=`date | cut -f 2 -d " "`

if test ! $AUX = " "
then
TEMP=`date | cut -f 7 -d " "`
else
TEMP=`date | cut -f 8 -d " "`
fi

HORAS=`echo "$TEMP" | cut -f 1 -d ":"`
MINUTOS=`echo "$TEMP" | cut -f 2 -d ":"`
SEGUNDOS=`echo "$TEMP" | cut -f 3 -d ":"`

adatiempo

TEMP=$(($HORAS*3600))
HORAINI=$TEMP

AUX=$(($MINUTOS*60))
TEMP=$(($HORAINI+$AUX))
HORAINI=$TEMP

TEMP=$(($HORAINI+$SEGUNDOS))
HORAINI=$TEMP


#presentamos por primera vez el menu y hacemos la primera
#llamada a la funcion eleccion el resto ocurre en bucles
menu
nucleo

exit 0
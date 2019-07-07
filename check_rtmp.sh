#!/bin/sh
# FILE: "check_rtmp"
# DESCRIPTION:nagios plugin for checking rtmp streams.
# REQUIRES: rtmpdump (http://rtmpdump.mplayerhq.hu/)
# AUTHOR: Toni Comerma
# DATE: jan-2013
# $Id:$
#

PROGNAME=`readlink -f $0`
PROGPATH=`echo $PROGNAME | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
REVISION=`echo '$Revision: .2 $' | sed -e 's/[^0-9.]//g'`

RTMPDUMP=`which rtmpdump`

print_usage() {
  echo "Usage:"
  echo "  $PROGNAME -u <url> -t <timeout> "
  echo "  $PROGNAME -h "

  
}

print_help() {
  print_revision $PROGNAME $REVISION
  echo ""
  print_usage
  
	echo "Comprova l'estat d'un stream RTMP"
	echo ""
	echo "Opcions:"
	echo "	-u URL a testejar Exemple: rtmp://server/app/streamName"
	echo "	-t Temps a monitoritzar"
	echo ""
  exit $STATE_UNKNOWN
}



STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

URL=""
TIMEOUT=2

# Proces de parametres
while getopts ":u:t:h" Option
do
	case $Option in 
		u ) URL=$OPTARG;;
		t ) TIMEOUT=$OPTARG;;
		h ) print_help;;
		* ) echo "unimplemented option";;
		
		esac
done

if [ ! $URL ] ; then 
	echo " Error - No s'ha indicat URL a monitoritzar "
	echo ""
	print_help
	echo ""
fi

# Construir noms de fitxers temporals
NAME=`echo $URL | sed -e s/[^A-Za-z0-9.]/_/g`
ERR=/tmp/check_rtmp_err_$NAME.tmp

# Testejant
$RTMPDUMP --live -r $URL --stop $TIMEOUT > /dev/null 2> $ERR & sleep 3
status=$?
sleep 4 && ps -ef | grep "$RTMPDUMP --live -r $URL" | grep -v grep | awk '{print $2}' | xargs -r sudo kill -9

# Retorn de resultats
CONNECTA=`grep "INFO: Connected" $ERR`

if [ -z "$CONNECTA" ]
then
  echo "CRITICAL - No es pot connectar al servidor: $URL"
  exit $STATE_CRITICAL
else
   ERROR=`grep "INFO: Metadata:" $ERR`
   if [ ! -z "$ERROR" ]
   then
       echo "OK - Stream funcionant: $URL"
       exit $STATE_OK
    fi
    echo "CRITICAL - Stream NO emetent: $URL"
    exit $STATE_CRITICAL
fi

echo "UNKNOWN - Alguna condicio no esperada ha permes arribar fins aqui. Revisar check"
exit $STATE_UNKNOWN


#!/bin/bash

###############################################
#                  ARCH NEWS                  #
#---------------------------------------------#
# The  script  downloads  arch linux web page #
# with  news  and  checks  whether  there  is #
# something new or not. It needs to store the #
# timestamp   of   the  last  news  (See  the #               
# constants below).                           #
###############################################

# CONSTANTS
FILE="./data/last_arch_news"
HTML_FILE="./data/arch.html"
TAILED_FILE="./data/arch_tailed.html"


print_news()
{
	line=`cat $HTML_FILE | grep -inm 1 "article-content" | awk -F: '{print $1}'`
	cat $HTML_FILE | tail +$line > $TAILED_FILE

	line=`cat $TAILED_FILE | grep -inm 1 "</div>" | awk -F: '{print $1}'`

	echo "*** Last news ***"
	cat $TAILED_FILE | head -$line | sed 's/<[^>]*>//g'
	echo "*****************"
}

clean()
{
	if [ -f "$HTML_FILE" ]; then
		rm $HTML_FILE
	fi

	if [ -f "$TAILED_FILE" ]; then
		rm $TAILED_FILE
	fi
}


if [ ! -d "./data" ]; then
       mkdir ./data
fi       

curl https://www.archlinux.org > $HTML_FILE

last_date=`cat $HTML_FILE | grep -im 1 'timestamp' | awk -F '[<>]' '{print $3}'`

timestamp=`date -d "$last_date" +"%s"`

if [ -f "$FILE" ]; then
	prev_timestamp=`cat $FILE`
	
	if [ "$timestamp" -gt "$prev_timestamp" ]; then
		print_news
	else
		echo "Nothing new there."
	fi
else
	print_news
fi

echo "$timestamp" > $FILE

clean


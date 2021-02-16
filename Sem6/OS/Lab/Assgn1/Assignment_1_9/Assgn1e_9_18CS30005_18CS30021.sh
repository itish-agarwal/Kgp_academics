len=${1:-16}
if((len<0));then
	echo "Invalid_input"
	exit
fi
</dev/urandom tr -dc _A-Za-z0-9 | head -c$len

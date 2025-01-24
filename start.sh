#!/bin/bash
# certstrap: https://github.com/square/certstrap

hosts_file="hosts.txt"
out="conf"
ca="simple-ca"
ca_expires="20 years"
cert="allname"
cert_expires="20 years"
hosts=""
map_host_file="${out}/map-host.conf"
map_addr_file="${out}/map-addr.conf"
map_sni_file="${out}/map-sni.conf"

chmod 755 ./bin/{nginx,certstrap}

if [[ ! -f "${out}/${ca}.crt" ]]; then
    ./bin/certstrap --depot-path="$out" init --passphrase="" --expires="$ca_expires" --common-name="$ca" >/dev/null
fi

echo "" > $map_host_file
echo "" > $map_addr_file
echo "" > $map_sni_file
while IFS='' read -r line; do
    if [[ "$line" =~ ^[\*|[:alnum:]].*$ ]]; then
	host=$(echo $line |cut -d ',' -f 1)
	proxy_conn=$(echo $line |cut -d ',' -f 2)
	addr=$(echo $line |cut -d ',' -f 3)
	sni=$(echo $line |cut -d ',' -f 4)
        echo "$host ${proxy_conn};" >> $map_host_file
        if [[ "$addr" ]]; then
            echo "$host ${addr};" >> $map_addr_file
        fi
        if [[ "$sni" ]]; then
            echo "$host ${sni};" >> $map_sni_file
        fi
        hosts="${hosts}${host},"
    fi
done < "$hosts_file"
allhosts="${hosts}localhost"

rm -f ${out}/${cert}.*

./bin/certstrap --depot-path="$out" request-cert --passphrase="" --common-name="$cert" --domain="$allhosts" >/dev/null
./bin/certstrap --depot-path="$out" sign "$cert" --passphrase="" --expires="$cert_expires" --CA="$ca" >/dev/null

echo "nginx running..."
./bin/nginx


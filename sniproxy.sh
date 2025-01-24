#!/bin/bash

echo "sni nginx running..."
bin/nginx -c conf/sniproxy.conf

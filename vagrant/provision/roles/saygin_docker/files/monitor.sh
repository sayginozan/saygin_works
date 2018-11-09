#! /bin/bash

# Monitoring Traffic. Every 1 Second for HTTP/HTTPS Ports

watch -n 1 -c "netstat -ntupw | head -n 2 && netstat -ntupw | tail -n 10 | grep -v 'Active\|Proto' | grep '":80"\|":908"\|":44"' && echo '\n \n' && echo '  'Count IP && netstat -ntu | awk '{print \$5}' | cut -d: -f1 | sort | uniq -c | sort -rn | tail -n 10"

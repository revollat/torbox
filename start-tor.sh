#!/bin/bash
HOME="/home/tor"
chmod -R 600 /home/tor/.tor
chown -R tor:tor /home/tor/.tor
su tor << EOF
cd "$HOME"
bin/tor -f etc/torrc 
EOF

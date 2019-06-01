#! /bin/bash

port=28
username=${1}
final_ip=${2}
ip=172.17.0.${final_ip}

xhost +
ssh -2 -p${port} -XY ${username}@${ip}

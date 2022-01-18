#!/bin/bash

cd /home/k8s-cloud-node/Desktop/Federico/DigitalTwin_service
git add *;
git commit -a -m "settings";
git push;
sshpass -p k8snode ssh k8s-enb-node@10.0.1.44 'cd ~/Desktop/federico/DigitalTwin_service/; git pull'

for run in {1..10}; do curl http://ion-motors.nuage.lab:5000/; sleep 1; done;
for run in {1..10}; do curl --connect-timeout 5 https://www.netflix.com/ > /dev/null; done;
for run in {1..5}; do curl https://www.chase.com/ > /dev/null; done;
for run in {1..10}; do curl https://www.statefarm.com/ > /dev/null; done;
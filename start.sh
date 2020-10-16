#!/bin/bash

rm -rf ~/.relayer/
docker stop $(docker ps -q)

SEED0="pitch orient aunt brief battle width reunion labor swim december december citizen pride model whale squeeze mango network enable lumber page cliff box when"
SEED1="worry lock purity labor alpha obvious drama magic curious neutral hair vapor portion retreat expire muscle search turtle aisle ship celery limit frog torch"
rly config init
rly config add-dir config/
rly keys restore freeflix-media-hub-0 testkey "$SEED0"
rly keys restore freeflix-media-hub-1 testkey "$SEED1"

echo "Starting docker container"
docker run -p 26657:26657 saisunkari19/ff-hub:ibc-alpha freeflix-media-hub-0 freeflix13f04sutqapvvj8eqt7g0lyhukl35pf2tljzxsm >logs/ff0.log 2>&1 &
sleep 2s
docker run -p 26557:26657 saisunkari19/ff-hub:ibc-alpha freeflix-media-hub-1 freeflix19ap327kdc38u9rjm5lm3sk2q3snf9kqu0qgr2n >logs/ff1.log 2>&1 &
echo "sleep for 10s"
sleep 10s

rly lite init freeflix-media-hub-0 -f
rly lite init freeflix-media-hub-1 -f

rly tx full-path path --timeout 3s

while true; do
  echo "Transfer from freeflix-media-hub-0"
  rly tx raw xfer-send freeflix-media-hub-0 freeflix-media-hub-1 10mdm true $(rly chains addr freeflix-media-hub-1)
  rly tx raw xfer-send freeflix-media-hub-0 freeflix-media-hub-1 10mdm true $(rly chains addr freeflix-media-hub-1)
  echo "After send balance need to"
  rly q bal freeflix-media-hub-0

  echo "Transfer from freeflix-media-hub-1"
  rly tx raw xfer-send freeflix-media-hub-1 freeflix-media-hub-0 10mdm true $(rly chains addr freeflix-media-hub-0)
  rly tx raw xfer-send freeflix-media-hub-1 freeflix-media-hub-0 10mdm true $(rly chains addr freeflix-media-hub-0)
  echo "After send balance need to"
  rly q bal freeflix-media-hub-1

  echo "Query relay path"
  rly q queue path
  sleep 2s

  echo "Relayer start"
  rly start path >logs/rly.log 2>&1 &

  sleep 3s
  echo "Reverse transfers"
  rly q queue path
  rly q bal freeflix-media-hub-0
  rly q bal freeflix-media-hub-1
  rly tx raw xfer-send freeflix-media-hub-0 freeflix-media-hub-1 20mdm false $(rly chains addr freeflix-media-hub-1)
  rly q bal freeflix-media-hub-0
  rly q bal freeflix-media-hub-1
  rly tx raw xfer-send freeflix-media-hub-1 freeflix-media-hub-0 20mdm false $(rly chains addr freeflix-media-hub-0)
  sleep 6s

  echo "Query balances"
  rly q bal freeflix-media-hub-0
  rly q bal freeflix-media-hub-1

  sleep 60s

  #  echo "updating clients"
  #  rly tx raw update-client ic0 ic1 ibczeroclient
  #  rly tx raw update-client ic1 ic0 ibconeclient
done

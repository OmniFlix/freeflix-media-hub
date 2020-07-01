# FreeFlix-Media-Hub

FreeFlix-Media-Hub

## IBC Transactions

### Local Setup

#### Relayer configurations
- download the latest  [realyer](https://github.com/iqlusioninc/relayer) 
- install the relayer

Then config the relayer for the chain
```bash
rly config init
rly config list
rly config add-dir config/

rly keys restore ic0 testkey "pitch orient aunt brief battle width reunion labor swim december december citizen pride model whale squeeze mango network enable lumber page cliff box when"
rly keys restore ic1 testkey "worry lock purity labor alpha obvious drama magic curious neutral hair vapor portion retreat expire muscle search turtle aisle ship celery limit frog torch"

```
Use above keys to Start the chains
```bash
rly chains addr freeflix-media-hub-0
rly chains addr freeflix-media-hub-1
```

#### Docker configuration
- Use the docker containers to init the chains

```bash
docker pull saisunkari19/ff-hub:0265266
```
- Starts the chains
```bash
docker run -p 26657:26657 <image:tag> <chain-id> <relayer address>

docker run -p 26657:26657 saisunkari19/ff-hub:0265266 $(rly chains addr freeflix-media-hub-0) > logs/ff0.log 2>&1 &

docker run -p 26557:26657 saisunkari19/ff-hub:0265266 $(rly chains addr freeflix-media-hub-1) > logs/ff1.log 2>&1 &
```

- Init the lite client b/w two chains
```bash
rly lite init ic0 -f
rly lite init ic1 -f
```

- Create Client, Connections & Channel b/w two chains

```bash
rly tx full-path path --timeout 7s
```

- Send transactions
```bash
rly tx raw xfer-send freeflix-media-hub-0 freeflix-media-hub-1 10mdm true $(rly chains addr freeflix-media-hub-1)
rly tx raw xfer-send freeflix-media-hub-0 freeflix-media-hub-1 10mdm true $(rly chains addr freeflix-media-hub-1)
rly q bal freeflix-media-hub-0
  
rly tx raw xfer-send freeflix-media-hub-1 freeflix-media-hub-0 10mdm true $(rly chains addr freeflix-media-hub-0)
rly tx raw xfer-send freeflix-media-hub-1 freeflix-media-hub-0 10mdm true $(rly chains addr freeflix-media-hub-0)
rly q bal freeflix-media-hub-1

rly q queue path
```
- Start the Relayer
```bash
rly start path >logs/rly.log 2>&1 &
```
Reverse the transactions b/w chains

```bash
rly q queue path
rly q bal freeflix-media-hub-0
rly q bal freeflix-media-hub-1

rly tx xfer freeflix-media-hub-0 freeflix-media-hub-1 20mdm false $(rly chains addr freeflix-media-hub-1)
rly tx xfer freeflix-media-hub-1 freeflix-media-hub-0 20mdm false $(rly chains addr freeflix-media-hub-0)

rly q bal freeflix-media-hub-0
rly q bal freeflix-media-hub-1

```

> you can directly run start.sh for all these 

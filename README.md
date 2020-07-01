# FreeFlix-Media-Hub

FreeFlix-Media-Hub

## Full Node Quick Start

### Note: Requires [Go 1.14+](https://golang.org/dl/)

### Build, Install and Start your Node
```bash
# Clone FreeFlix-Media-Hub from https://github.com/FreeFlixMedia/freeflix-media-hub
git clone https://github.com/FreeFlixMedia/freeflix-media-hub

# Enter the folder freeflix-media-hub was cloned into
cd freeflix-media-hub

# Compile and install ff
make install

# Create genesis account key and copy the address
ffcli keys add {keyName}
Ex: ffcli keys add genesis

# Run entry-point.sh to start chain
sh entry-point.sh {chain_id} {genesis_account_address_copied_from_above_step}
Ex: sh entry-point.sh freeflix-media-hub freeflix1f3pvvs6at2m79rjurl7q8tygtknjkq9290ej3q

```

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

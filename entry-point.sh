#!/bin/sh

CHAINID=$1
GENACCT=$2

if [ -z "$1" ]; then
  echo "Need to input chain id..."
  exit 1
fi

if [ -z "$2" ]; then
  echo "Need to input genesis account address..."
  exit 1
fi

# Build genesis file incl account for passed address
coins="1000000000000000ffmt,1000000000000000mdm"
ffd init --chain-id $CHAINID $CHAINID --stake-denom ffmt
ffcli keys add validator
ffd add-genesis-account validator $coins
ffd add-genesis-account $GENACCT $coins
ffd gentx --name validator --amount 100000000ffmt
ffd collect-gentxs

# Set proper defaults and change ports
sed -i 's/"leveldb"/"goleveldb"/g' ~/.ffd/config/config.toml
sed -i 's#"tcp://127.0.0.1:26657"#"tcp://0.0.0.0:26657"#g' ~/.ffd/config/config.toml
sed -i 's/timeout_commit = "5s"/timeout_commit = "1s"/g' ~/.ffd/config/config.toml
sed -i 's/timeout_propose = "3s"/timeout_propose = "1s"/g' ~/.ffd/config/config.toml
sed -i 's/index_all_keys = false/index_all_keys = true/g' ~/.ffd/config/config.toml

ffd start --pruning=nothing

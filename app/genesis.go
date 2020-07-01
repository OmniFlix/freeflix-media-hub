package app

import (
	"encoding/json"

	codecstd "github.com/cosmos/cosmos-sdk/std"
)

type GenesisState map[string]json.RawMessage

func NewDefaultGenesisState() GenesisState {
	cdc := codecstd.MakeCodec(ModuleBasics)
	return ModuleBasics.DefaultGenesis(cdc)
}

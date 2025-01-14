-include .env

.PHONY: all clean remove install update build test snapshot format anvil deploy verify

RPC_URL := http://127.0.0.1:8545

all: clean remove install update build

clean:
	@forge clean

remove:
	@rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install:
	@forge install cyfrin/foundry-devops@0.2.2 --no-commit
	@forge install foundry-rs/forge-std@v1.8.2 --no-commit
	@forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit

update:
	@forge update

build:
	@forge build

test:
	@forge test 

snapshot:
	@forge snapshot

format:
	@forge fmt

anvil:
	@anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

deploy:
	@forge script script/DeployOurToken.s.sol:DeployOurToken --rpc-url $(RPC_URL) --private-key $(DEFAULT_ANVIL_KEY) --broadcast
deploy:
	@forge script script/DeployMyERCToken.s.sol:DeployMyERCToken --rpc-url $(RPC_URL) --private-key $(DEFAULT_ANVIL_KEY) --broadcast

verify:
	@forge verify-contract --chain-id 11155111 --num-of-optimizations 200 --watch --constructor-args 0x00000000000000000000000000000000000000000000d3c21bcecceda1000000 --etherscan-api-key $(ETHERSCAN_API_KEY) --compiler-version v0.8.19+commit.7dd6d404 0x089dc24123e0a27d44282a1ccc2fd815989e3300 src/OurToken.sol:OurToken

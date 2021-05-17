FROM ubuntu:18.04

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
	; \
	rm -rf /var/lib/apt/lists/*

ARG VERSION

RUN set -ex; \
	curl -fLo /usr/bin/bnbchaind https://github.com/binance-chain/node-binary/blob/master/fullnode/prod/${VERSION}/linux/bnbchaind?raw=true; \
	chmod +x /usr/bin/bnbchaind

RUN useradd -m -u 1000 -s /bin/bash runner
USER runner

RUN set -ex; \
	mkdir -p ~/.bnbchaind/config; \
	curl -fLo ~/.bnbchaind/config/app.toml     https://github.com/binance-chain/node-binary/blob/master/fullnode/prod/${VERSION}/config/app.toml?raw=true;     \
	curl -fLo ~/.bnbchaind/config/config.toml  https://github.com/binance-chain/node-binary/blob/master/fullnode/prod/${VERSION}/config/config.toml?raw=true;  \
	curl -fLo ~/.bnbchaind/config/genesis.json https://github.com/binance-chain/node-binary/blob/master/fullnode/prod/${VERSION}/config/genesis.json?raw=true; \
	sed -i 's/logToConsole.*/logToConsole = true/g' ~/.bnbchaind/config/app.toml; \
	sed -i 's/open_files_cache_capacity.*/open_files_cache_capacity = 4096/g' ~/.bnbchaind/config/config.toml; \
	sed -i 's/fast_sync.*/fast_sync = false/g' ~/.bnbchaind/config/config.toml; \
	sed -i 's/state_sync_reactor.*/state_sync_reactor = false/g' ~/.bnbchaind/config/config.toml; \
	sed -i 's/state_sync_height.*/state_sync_height = -1/g' ~/.bnbchaind/config/config.toml;

ENTRYPOINT ["bnbchaind"]

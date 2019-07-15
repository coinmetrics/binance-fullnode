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
	curl -Lo /usr/bin/bnbchaind https://github.com/binance-chain/node-binary/blob/master/fullnode/prod/${VERSION}/linux/bnbchaind?raw=true; \
	chmod +x /usr/bin/bnbchaind

RUN useradd -m -u 1000 -s /bin/bash runner
USER runner

RUN set -ex; \
	mkdir -p ~/.bnbchaind/config; \
	curl -Lo ~/.bnbchaind/config/app.toml     https://github.com/binance-chain/node-binary/blob/master/fullnode/prod/${VERSION}/config/app.toml;     \
	curl -Lo ~/.bnbchaind/config/config.toml  https://github.com/binance-chain/node-binary/blob/master/fullnode/prod/${VERSION}/config/config.toml;  \
	curl -Lo ~/.bnbchaind/config/genesis.json https://github.com/binance-chain/node-binary/blob/master/fullnode/prod/${VERSION}/config/genesis.json; \
	true

ENTRYPOINT ["bnbchaind"]

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
	curl -Lo /usr/bin/bnbchaind https://raw.githubusercontent.com/binance-chain/node-binary/master/fullnode/prod/${VERSION}/linux/bnbchaind; \
	chmod +x /usr/bin/bnbchaind

RUN useradd -m -u 1000 -s /bin/bash runner
USER runner

RUN set -ex; \
	mkdir -p ~/.bnbchaind/config; \
	curl -Lo ~/.bnbchaind/config/app.toml     https://raw.githubusercontent.com/binance-chain/node-binary/master/fullnode/prod/${VERSION}/config/app.toml;     \
	curl -Lo ~/.bnbchaind/config/config.toml  https://raw.githubusercontent.com/binance-chain/node-binary/master/fullnode/prod/${VERSION}/config/config.toml;  \
	curl -Lo ~/.bnbchaind/config/genesis.json https://raw.githubusercontent.com/binance-chain/node-binary/master/fullnode/prod/${VERSION}/config/genesis.toml; \
	true

ENTRYPOINT ["bnbchaind"]

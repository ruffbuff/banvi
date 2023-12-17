```bash
██████╗  █████╗ ███╗   ██╗  ██╗   ██╗ ██╗
██╔══██╗██╔══██╗████╗  ██║  ██║   ██║ ██║
██████╔╝███████║██╔██╗ ██║  ██║   ██║ ██║
██╔══██╗██╔══██║██║╚██╗██║  ╚██╗ ██╔╝ ██║
██████╔╝██║  ██║██║ ╚████║   ╚████╔╝  ██║
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝    ╚═══╝   ╚═╝
```

**Developed by:**
- 1: [@ruffbuff](https://github.com/ruffbuff)

> [!TIP]
> Create, modifiy and deploy you own smart contract with BANVI 💥

**BANVI environments:**
- [Foundary](https://book.getfoundry.sh/)
- [Ethers](https://docs.ethers.org/v5/) {SOON}
- [Alchemy](https://docs.alchemy.com/reference/api-overview) {SOON}

# BANVI Lib
```bash
src─┳─Standards
    ┠──ERC20R.sol
    ┠──ERC721R.sol
    ┠──ERC1155R.sol
    ┠─Utility
    ┠──[SOON]
    ┖──[SOON]
```

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
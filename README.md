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
- [Foundry](https://book.getfoundry.sh/)
- [Ethers](https://docs.ethers.org/v5/) {SOON}
- [Alchemy](https://docs.alchemy.com/reference/api-overview) {SOON}

# BANVI Lib
```bash
╔═src
╠══Mocks
╠═══MockERC20.sol
╠═══[SOON]
╠══Standards
╠═══ERC-20R.sol
╠═══ERC-721R.sol
╠═══ERC-1155R.sol
╠══Utility
╠═══Drop-R.sol
╚═══[SOON]

╔═test
╠══ERC-20R.t.sol
╠══ERC-721R.t.sol
╠══ERC-1155R.t.sol
╚══[SOON]
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
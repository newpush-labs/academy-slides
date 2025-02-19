---
title: Introduction to Bitcoin Smart Contracts
subtitle: University Course Session (90 Minutes)
theme: ../../themes/np-slides-theme
background: https://source.unsplash.com/1600x900/?technology,ai
transition: slide-left
mdc: true
layout: intro
---

# Introduction to Bitcoin Smart Contracts
## Session #1

<!--
Welcome to our first session on Bitcoin Smart Contracts. Today we'll explore the basics of Bitcoin's transaction model, introduce Bitcoin Script, discuss smart contract capabilities in Bitcoin, compare it with other blockchain platforms, and set up our development environment.
-->

---

# Understanding the Bitcoin Blockchain

- **Definition:**
  - Decentralized ledger of all transactions
  - Chain of cryptographically linked blocks
  - Maintained by a network of nodes
- **Key Properties:**
  - Immutable record
  - Transparent
  - Permissionless
  - Censorship resistant

<!--
The Bitcoin blockchain is a revolutionary technology that enables trustless, peer-to-peer value transfer. Each block contains a set of transactions and is cryptographically linked to the previous block, creating an immutable chain of records.

The decentralized nature means no single entity controls the network. Instead, it's maintained by thousands of nodes worldwide, each validating transactions and blocks according to consensus rules.

These properties make Bitcoin ideal for programmable money, as the rules are enforced by mathematics and network consensus rather than traditional institutions.
-->

---

# How Bitcoin Blocks Work

- **Block Structure:**
  - Block header
  - Transaction list
  - Merkle tree
- **Mining Process:**
  - Transaction selection
  - Proof of Work
  - Block propagation
- **Consensus Rules:**
  - Valid transaction verification
  - Block validation
  - Chain selection (longest chain)

<!--
Bitcoin blocks are the fundamental building blocks of the blockchain. Each block contains a header with metadata and a list of transactions organized in a Merkle tree for efficient verification.

The mining process involves selecting valid transactions, solving a computational puzzle (Proof of Work), and broadcasting the solution to the network. This process secures the network and makes it extremely costly to alter historical records.

Consensus rules ensure all nodes agree on the state of the network. These rules define what makes transactions and blocks valid, and how to handle competing chains (always follow the chain with the most accumulated proof of work).
-->

---

# Blockchain Security Model

- **Cryptographic Foundations:**
  - Public key cryptography
  - Hash functions
  - Digital signatures
- **Network Security:**
  - Decentralized validation
  - Economic incentives
  - Game theory
- **Trust Model:**
  - Trust in mathematics
  - No trusted third parties
  - Verifiable by anyone

<!--
Bitcoin's security model is built on proven cryptographic primitives. Public key cryptography enables secure ownership, hash functions ensure data integrity, and digital signatures prove authorization.

The network's security comes from decentralized validation by nodes and miners. Economic incentives align participants' interests with network security, while game theory principles make attacks costly and unprofitable.

This security model enables trustless smart contracts - agreements that are enforced by code and network consensus rather than legal systems or intermediaries.
-->

---

# Bitcoin Transaction Model Overview

- **Definition:**  
  Bitcoin transactions are the transfer of value between Bitcoin wallets that get included in the blockchain.
- **Components:**  
  - Inputs: References to previous transactions.
  - Outputs: Specifies the new owner of the transferred Bitcoin.
- **UTXO Model:**  
  - Unspent Transaction Outputs (UTXOs) are the outputs of previous transactions that can be used as inputs in new transactions.

<!--  
Bitcoin's transaction model is based on the UTXO (Unspent Transaction Output) model. Each transaction consumes previous UTXOs and creates new ones, ensuring that the total value of inputs equals the total value of outputs.

Inputs reference previous transaction outputs and must be signed by the owner. Outputs define the new owner and the amount of Bitcoin being transferred.

This model provides a clear and secure way to track ownership and prevent double-spending.
-->

---

# Transaction Lifecycle

- **Creation:**
  - Transaction is constructed with inputs and outputs
  - Signatures are added to prove ownership
- **Propagation:**
  - Transaction is broadcast to the Bitcoin network
  - Nodes validate and relay the transaction
- **Mining:**
  - Miners include transaction in a block
  - Block is added to the blockchain
- **Confirmation:**
  - Additional blocks build on top
  - Transaction becomes increasingly secure

<!--
The lifecycle of a Bitcoin transaction involves multiple stages that ensure security and finality. When a transaction is created, it includes references to previous outputs (UTXOs) and specifies new outputs. The owner must sign the transaction to prove they have the right to spend the inputs.

The transaction is then broadcast to the network where nodes validate its format, signatures, and ensure inputs haven't been spent. Miners select valid transactions to include in new blocks, considering fees and other factors.

Each additional block built on top of the one containing the transaction increases its security through the concept of confirmations. Most services consider 6 confirmations as sufficient for high-value transactions.
-->

---

# Transaction Components in Detail

- **Transaction ID (TXID):**
  - Unique identifier
  - Hash of transaction data
- **Inputs:**
  - Previous transaction references
  - Unlocking scripts (scriptSig)
  - Sequence numbers
- **Outputs:**
  - Amount
  - Locking scripts (scriptPubKey)
- **Additional Fields:**
  - Version number
  - Locktime
  - Witness data (for SegWit)

<!--
Each Bitcoin transaction has a specific structure with multiple components serving different purposes. The TXID is a unique identifier created by hashing the transaction data, making it tamper-evident.

Inputs contain references to previous transactions (TXID and output index), along with scripts that prove the right to spend those outputs. Sequence numbers enable features like time locks.

Outputs specify amounts and conditions for spending (locking scripts). Additional fields like version and locktime enable protocol upgrades and time-based features.

Understanding these components is crucial for working with Bitcoin transactions and developing smart contracts.
-->

---

# UTXO Model Visualization

```
Transaction 1:
Input: [Previous UTXO] → Output: [5 BTC to Alice]

Transaction 2:
Input: [5 BTC from Alice] → Outputs: [3 BTC to Bob, 1.9 BTC back to Alice (change)]
```

- **Benefits:**
  - Deterministic transaction validation
  - Parallel processing capability
  - Enhanced privacy
- **Considerations:**
  - Need to handle change outputs
  - Account balance is sum of UTXOs
  - Each UTXO must be spent entirely

<!--
The UTXO model can be visualized as a series of discrete "coins" that must be consumed entirely when spent. When Alice wants to send 3 BTC to Bob but has a single 5 BTC UTXO, she must create a transaction with two outputs: one for Bob's 3 BTC and another returning 1.9 BTC to herself (assuming 0.1 BTC fee).

This model differs from account-based systems (like Ethereum) and has important implications for smart contract design. The deterministic nature of UTXO validation makes it easier to verify transactions and process them in parallel.

Understanding UTXO management is crucial for efficient transaction creation and fee optimization.
-->

---

# Bitcoin Addresses Explained

- **Address Types:**
  - Legacy (P2PKH): Starts with '1'
  - SegWit (P2SH): Starts with '3'
  - Native SegWit (P2WPKH): Starts with 'bc1'
- **Generation Process:**
  - Public key → Hash → Encoding
- **Features:**
  - Error detection
  - Network identification
  - Format versioning

<!--
Bitcoin addresses are human-readable representations of public key hashes or scripts. Different address types reflect the evolution of Bitcoin's transaction capabilities.

The address generation process involves multiple steps of hashing and encoding to create a string that's both secure and user-friendly. Error detection through checksums helps prevent mistakes in address handling.

Understanding address types is crucial for compatibility and optimal fee structures. Native SegWit addresses provide the most efficient transaction format for modern Bitcoin operations.
-->

---

# Types of Bitcoin Scripts

- **Standard Scripts:**
  - Pay to Public Key Hash (P2PKH)
  - Pay to Script Hash (P2SH)
  - Pay to Witness Public Key Hash (P2WPKH)
  - Multi-signature (multisig)
- **Time-Based Scripts:**
  - Checklocktimeverify (CLTV)
  - Checksequenceverify (CSV)
- **Future Enhancements:**
  - Taproot
  - Schnorr signatures

<!--
Bitcoin supports various script types for different use cases. Standard scripts are widely supported and cover most common scenarios. P2PKH is the classic transaction type, while P2SH enables more complex conditions to be encoded efficiently.

Time-based scripts add temporal controls, enabling features like time-locked transactions and payment channels. These are fundamental for Layer 2 solutions like Lightning Network.

Future enhancements like Taproot will improve privacy and efficiency while enabling more sophisticated smart contracts.
-->

---

# Real-World Use Cases

- **Multi-signature Wallets:**
  - Corporate treasury management
  - Shared custody solutions
  - Enhanced security setups
- **Time-Locked Transactions:**
  - Inheritance planning
  - Vesting schedules
  - Trust fund management
- **Payment Channels:**
  - Lightning Network nodes
  - Micro-payment systems
  - Streaming payments

<!--
Bitcoin scripts enable various real-world applications beyond simple transfers. Multi-signature wallets require multiple parties to approve transactions, perfect for corporate governance or shared custody arrangements.

Time-locked transactions enable sophisticated financial planning, like creating inheritance plans or vesting schedules for employee compensation. These can be combined with other script types for complex conditions.

Payment channels, particularly the Lightning Network, use scripts to enable fast, cheap transactions while maintaining Bitcoin's security model.
-->

---

# Security Best Practices

- **Key Management:**
  - Secure key generation
  - Backup procedures
  - Hardware wallet usage
- **Testing Strategy:**
  - Always use testnet first
  - Thorough script validation
  - Edge case testing
- **Common Pitfalls:**
  - Insufficient fee estimation
  - Incorrect script construction
  - Inadequate error handling

<!--
Security is paramount when working with Bitcoin scripts. Proper key management is the foundation of security, including secure generation, reliable backup procedures, and preferably hardware wallet usage for high-value operations.

Testing is crucial - always develop and test on testnet before moving to mainnet. Thorough validation should include edge cases and error conditions.

Common pitfalls can lead to lost funds or stuck transactions. Understanding fee estimation, proper script construction, and error handling helps avoid these issues.
-->

---

# Preparing for Bitcoin Script

- **Stack-Based Thinking:**
  - Last-In-First-Out (LIFO) operations
  - Data and operator interaction
  - Stack manipulation basics
- **Basic Operators:**
  - Arithmetic operations
  - Boolean logic
  - Cryptographic functions
- **Execution Flow:**
  - Sequential processing
  - Conditional execution
  - Script validation rules

<!--
Bitcoin Script uses a stack-based paradigm that may be unfamiliar to many developers. Understanding how the stack works is crucial for writing effective scripts.

Basic operators form the building blocks of all Bitcoin scripts. These include arithmetic operations for number manipulation, boolean logic for conditions, and cryptographic functions for security.

The execution flow is deterministic and sequential, with special considerations for conditional execution. Understanding these fundamentals prepares you for more advanced scripting concepts.
-->

---

# Introduction to Bitcoin Script

- **Definition:**  
  Bitcoin Script is a stack-based, Forth-like programming language used to secure Bitcoin transactions.
- **Purpose:**  
  It defines the conditions under which funds can be spent.
- **Design Philosophy:**  
  - Non-Turing complete to reduce risk.
  - Simple yet powerful enough to enable smart contracts.

<!--  
Bitcoin Script is the foundation of Bitcoin's programmability. Let's break down its key aspects:

The stack-based nature means operations work by pushing and popping values from a stack, similar to old HP calculators. Being Forth-like refers to its similarity to the Forth programming language, known for its simplicity and efficiency.

The main purpose is to create "smart contracts" - not in the Ethereum sense, but as programmable conditions for spending Bitcoin. For example, requiring multiple signatures or time locks.

The design philosophy prioritizes security over flexibility. By being non-Turing complete, it intentionally lacks loops and recursion, preventing infinite loops and making script execution predictable. This makes Bitcoin scripts more secure and easier to analyze, though less expressive than Turing-complete languages.
-->
---

# Smart Contract Capabilities in Bitcoin

- **Basic Capabilities:**
  - Multi-signature transactions.
  - Time-locked transactions.
  - Conditional payments.
- **Advanced Use Cases:**
  - Escrow services.
  - Atomic swaps.
  - Decentralized finance (DeFi) applications.

<!--
Bitcoin's smart contract capabilities are built on its scripting language. While not as flexible as Ethereum's smart contracts, Bitcoin Script can still enable powerful functionalities.

Multi-signature transactions require multiple parties to sign off on a transaction, enhancing security. Time-locked transactions ensure funds can only be spent after a certain time.

Conditional payments allow for more complex transaction conditions, such as requiring specific data to be provided.

Advanced use cases include escrow services, where funds are held until certain conditions are met, and atomic swaps, which enable cross-chain exchanges without intermediaries. DeFi applications are also emerging, leveraging Bitcoin's security and decentralization.
-->
---

# Comparison with Other Blockchain Platforms

- **Bitcoin vs. Ethereum:**
  - Bitcoin: Focused on security and simplicity.
  - Ethereum: Turing-complete language for complex smart contracts.
- **Bitcoin vs. Other Blockchains:**
  - Bitcoin: Proven security and decentralization.
  - Other Blockchains: Varying degrees of flexibility and security.

<!--
When comparing Bitcoin to other blockchain platforms, it's important to understand the trade-offs.

Bitcoin prioritizes security and simplicity, using a non-Turing complete scripting language to minimize risks. This makes it less flexible but more secure.

Ethereum, on the other hand, uses a Turing-complete language called Solidity, allowing for more complex smart contracts but also introducing more potential vulnerabilities.

Other blockchains offer different balances of flexibility and security, with varying levels of decentralization and use cases.
-->
---

# Development Environment Setup

- **Tools Needed:**
  - Bitcoin Core.
  - Bitcoin Script IDEs.
  - Testnet for safe experimentation.
- **Installation Steps:**
  - Download and install Bitcoin Core.
  - Set up a testnet wallet.
  - Explore Bitcoin Script development tools.

<!--
Setting up your development environment is crucial for experimenting with Bitcoin smart contracts.

First, download and install Bitcoin Core, the reference implementation of Bitcoin. This will allow you to run a full node and interact with the Bitcoin network.

Next, set up a testnet wallet. Testnet is a separate blockchain used for testing, where you can experiment without risking real funds.

Finally, explore Bitcoin Script development tools, such as IDEs and debuggers, to write and test your scripts.
-->
---

# Practical: Setting Up Bitcoin Core

**Step-by-Step Guide:**
  1. Download Bitcoin Core from the official website.
  2. Install and run Bitcoin Core.
  3. Configure Bitcoin Core to use testnet.
  4. Create a testnet wallet.

<!--
Let's walk through setting up Bitcoin Core:

1. Download Bitcoin Core from the official Bitcoin website.
2. Install the software on your computer and run it.
3. Configure Bitcoin Core to use testnet by adding `-testnet` to the startup options.
4. Create a testnet wallet to start experimenting with Bitcoin transactions.

This setup will provide a safe environment to practice writing and testing Bitcoin scripts.
-->
---

# Practical: Creating a Testnet Wallet

**Steps:**
  1. Open Bitcoin Core with testnet enabled.
  2. Create a new wallet.
  3. Obtain testnet Bitcoin from a faucet.
  4. Verify the wallet balance.

<!--
Creating a testnet wallet is straightforward:

1. Open Bitcoin Core with testnet enabled.
2. Create a new wallet through the interface.
3. Obtain testnet Bitcoin from a faucet, which provides free testnet coins.
4. Verify your wallet balance to ensure you have received the testnet Bitcoin.

This wallet will be used for all your testnet transactions and script testing.
-->
---

# Practical: Basic Bitcoin Script Examples

**Example 1: Simple Pay-to-PubKeyHash (P2PKH) Script**
```
scriptPubKey: OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
scriptSig:    <signature> <pubKey>
```

**Example 2: Multi-signature (2-of-3) Script**
```
scriptPubKey: OP_2 <pubKey1> <pubKey2> <pubKey3> OP_3 OP_CHECKMULTISIG
scriptSig:    OP_0 <signature1> <signature2>
```

**Example 3: Time-Locked Transaction**
```
scriptPubKey: <locktime> OP_CHECKLOCKTIMEVERIFY OP_DROP <pubKey> OP_CHECKSIG
scriptSig:    <signature>
```

<!--
Let's examine these basic Bitcoin Script examples:

1. P2PKH is the most common transaction type. The locking script requires:
   - A public key that hashes to the specified hash
   - A valid signature from the corresponding private key

2. Multi-signature requires M-of-N signatures:
   - In this case, any 2 signatures from the 3 specified public keys
   - OP_0 is needed due to an off-by-one error in CHECKMULTISIG

3. Time-locked transactions prevent spending until a specific time:
   - CHECKLOCKTIMEVERIFY ensures funds remain locked until the specified time
   - After the time lock expires, requires a signature like normal

These examples demonstrate the flexibility of Bitcoin Script while maintaining security.
-->

---

# Next Steps

- **Practice with Test Networks:**
  - Create and test different script types
  - Experiment with transaction construction
  - Debug script execution
- **Explore Advanced Concepts:**
  - Complex script combinations
  - Lightning Network concepts
  - Taproot/Schnorr capabilities
- **Join the Developer Community:**
  - Bitcoin Core GitHub
  - Developer mailing lists
  - Local Bitcoin meetups

<!--
As you continue your journey with Bitcoin smart contracts:

Start with simple scripts on testnet to build confidence. Use debugging tools to understand script execution flow and potential errors.

Gradually explore more complex script combinations and Layer 2 solutions like Lightning Network. Stay updated with new developments like Taproot.

Engage with the developer community through GitHub, mailing lists, and local meetups to learn from others' experiences and contribute to the ecosystem.
-->

---
title: Bitcoin Scripting
subtitle: University Course Session (90 Minutes)
theme: ../../themes/np-slides-theme
background: https://source.unsplash.com/1600x900/?technology,ai
transition: slide-left
mdc: true
layout: intro
---

# Programmable Money
## Building Smart Contracts with Bitcoin Script
### Session #2

<!--
Welcome to our second session on Bitcoin Script. Today we'll explore how Bitcoin enables programmable money through its scripting language. We'll cover the fundamentals of Bitcoin Script, understand how transactions work, and learn to write basic smart contracts.
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

# The Architecture of Bitcoin Transactions

- **Two Main Parts:**
  - **Locking Script (scriptPubKey):**  
    Attached to transaction outputs; sets spending conditions.
  - **Unlocking Script (scriptSig):**  
    Provided in transaction inputs; supplies data to meet those conditions.
- **How They Work Together:**  
  The unlocking script "solves" the puzzle posed by the locking script, allowing the UTXO to be spent.

<!--
The architecture of Bitcoin transactions is built around the concept of locking and unlocking funds. Think of it like a puzzle box - the locking script creates the puzzle, and the unlocking script provides the solution.

The locking script (scriptPubKey) is like setting a combination lock. It's attached to the transaction output and defines what conditions must be met to spend those funds. Common conditions include providing a valid signature from a specific public key.

The unlocking script (scriptSig) is like entering the combination. When someone wants to spend the funds, they must provide an unlocking script that satisfies all the conditions set in the locking script. This usually involves providing signatures and public keys.

This two-part structure is fundamental to Bitcoin's security model, ensuring that only authorized parties can spend funds.
-->

---

# Understanding the Stack

**Stack Basics:**
  - Data structure used in Bitcoin Script.
  - Follows Last-In, First-Out (LIFO) order.
  
**How It Works:**
  - **Push:**  When a constant is encountered, it is pushed onto the stack.
  - **Pop:**  When an opcode is executed, it typically pops values from the stack.
  
**Example Bitcoin Script:**  
 `1 2 OP_ADD`  
**Execution:**

  Pushes `1`  →  Pushes `2` → `OP_ADD` pops `1` and `2`, adds them, and pushes `3`

<!--
The stack is the core data structure in Bitcoin Script. It works like a stack of plates - you can only add or remove items from the top.

LIFO (Last-In, First-Out) means that the last item you put on the stack is the first one you can take off. This is crucial for understanding how Bitcoin Script executes.

When executing a script, constants (like numbers or public keys) are pushed onto the stack. Opcodes then operate on these stack items, typically by popping one or more values, performing an operation, and pushing the result back.

The example shows a simple arithmetic operation: pushing 1 and 2 onto the stack, then using OP_ADD to pop both numbers, add them, and push the result (3) back onto the stack.
-->

---

# Bitcoin Script Execution Flow

**Reverse Polish Notation:**  
  Operands come before operators.

**Step-by-Step Execution:**
  1. Read the script from left to right.
  2. Push constants onto the stack.
  3. Execute opcodes, manipulating the stack.
   
**Outcome:**  
  The script is considered successful if it ends with a non-zero value at the top of the stack.

<!--
Bitcoin Script uses Reverse Polish Notation (RPN), which might seem unfamiliar if you're used to standard mathematical notation. Instead of writing "1 + 2", in RPN we write "1 2 +" - the numbers (operands) come before the operation.

The execution flow is straightforward but requires careful attention:
1. The script is read from left to right
2. When a number or data is encountered, it's pushed onto the stack
3. When an opcode is encountered, it performs its operation using values from the stack

Success is determined by the final stack state - if the top value is non-zero (typically 1 for true), the script succeeds. If it's zero or the stack is empty, the script fails.

This deterministic execution model is crucial for Bitcoin's security and predictability.
-->

---

# Key Bitcoin Script Opcodes

**Basic Opcodes:**
  - `OP_DUP:` Duplicates the top stack item.
  - `OP_HASH160:` Hashes the top stack item.
  - `OP_EQUALVERIFY:` Compares two items and verifies equality.
  - `OP_CHECKSIG:` Checks if a signature is valid for a given public key.
  
**Control Flow Opcodes:**
  - `OP_IF`, `OP_ELSE`, `OP_ENDIF`:  
    Enable conditional execution.

**Significance:**  
  These opcodes form the building blocks for more complex scripts and smart contract functionality.

<!--
Bitcoin Script provides a set of opcodes that serve as the building blocks for creating transaction conditions. Let's understand the most important ones:

OP_DUP is used to duplicate data, often a public key that needs to be both hashed and used for signature verification.

OP_HASH160 performs a double hash (SHA256 followed by RIPEMD160) on the top stack item, commonly used with public keys.

OP_EQUALVERIFY is crucial for comparing values - it fails the entire script if the comparison fails, ensuring security conditions are met.

OP_CHECKSIG verifies cryptographic signatures, the cornerstone of Bitcoin's security.

The control flow opcodes allow for more complex logic, enabling conditional execution based on various criteria.

Understanding these opcodes is essential for creating secure and effective Bitcoin scripts.
-->

---

# Testing Bitcoin Scripts

**Why Test?**

- To ensure the script behaves as expected.
- To prevent funds from being irretrievably locked.

**Testing Methods:**
- **btcdeb:**  
  A command-line debugger for stepping through script execution.
- **Online Simulators:**  
  Visual tools for testing scripts, though they may not fully emulate network conditions.
- **Testnet Deployment:**  
  The final step to validate the script in a real network environment.

**Best Practice:**  
 Always test thoroughly on Testnet before moving to Mainnet.

<!--
Testing Bitcoin scripts is crucial because mistakes can lead to permanent loss of funds. Unlike traditional programming where bugs can often be fixed with updates, Bitcoin script errors can be irreversible.

btcdeb is an invaluable tool for developers, allowing step-by-step execution and stack inspection. It helps catch logical errors before deployment.

Online simulators provide a user-friendly interface for testing, but remember they may not capture all network conditions or edge cases.

Testnet deployment is essential as the final testing phase. It provides a real-world environment without risking real funds.

The golden rule: Never deploy untested scripts to Mainnet. The cost of a mistake is too high to skip thorough testing.
-->

---

# Detailed Locking Script

**Definition:**  
  The Locking Script (scriptPubKey) is embedded in a transaction's output. It sets the rules for who can spend the funds.

**Purpose:**  
  To "lock" funds by specifying the exact conditions that must be met to later spend the UTXO.

**Key Components (Typical P2PKH Example):**
  - **OP_DUP:**  Duplicates the top stack item (usually the public key provided later).
  - **OP_HASH160:**  Hashes the duplicated public key using SHA-256 followed by RIPEMD-160.
  - **pubKeyHash:**   A constant representing the hash of the recipient's public key.
  - **OP_EQUALVERIFY:**   Compares the computed hash with the provided `<pubKeyHash>` aborts if they differ.
  - **OP_CHECKSIG:** Verifies that the provided signature is valid for the public key.

<!--
The locking script is like creating a digital lock with specific requirements to open it. In the most common form (P2PKH), it creates a lock that can only be opened by proving ownership of a specific Bitcoin address.

Each component serves a specific security purpose:
- OP_DUP creates a copy of the public key for multiple operations
- OP_HASH160 creates a hash that must match the recipient's address
- OP_EQUALVERIFY ensures the provided public key matches the expected recipient
- OP_CHECKSIG provides cryptographic proof of ownership

This combination of operations creates a secure way to ensure only the intended recipient can spend the funds.
-->

---

# Detailed Locking Script (cnt.)

**Execution Flow:**  
  When someone tries to spend the funds, the unlocking script must supply data that makes the locking script return true.

**Security Aspect:**  
  Ensures only the holder of the corresponding private key can produce the valid signature needed to unlock the funds.

--- 
title: Full Locking Script
---
**Full Locking Script:**

```python
OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
 
1. `OP_DUP`: Takes the public key and makes a copy of it
   - Stack before: [ `<signature>`, `<public key>` ]
   - Stack after: [ `<signature>`, `<public key>`, `<public key>` ]

2. `OP_HASH160`: Takes the top public key copy and hashes it with RIPEMD160(SHA256())
   - Stack before: [ `<signature>`, `<public key>`, `<public key>` ]
   - Stack after: [ `<signature>`, `<public key>`, `<hashed_pubkey>` ]

3. `<pubKeyHash>`: Pushes the expected public key hash onto stack
   - Stack before: [ `<signature>`, `<public key>`, `<hashed_pubkey>` ]
   - Stack after: [ `<signature>`, `<public key>`, `<hashed_pubkey>`, `<pubKeyHash>` ]

4. `OP_EQUALVERIFY`: Compares the two hashes and fails if they don't match
   - Stack before: [ `<signature>`, `<public key>`, `<hashed_pubkey>`, `<pubKeyHash>` ]
   - Stack after: [ `<signature>`, `<public key>` ]

5. `OP_CHECKSIG`: Verifies the signature matches the public key
   - Stack before: [ `<signature>`, `<public key>` ]
   - Stack after: [ true/false ]

The script succeeds only if the final result is true, 
meaning both the public key hash matched and the signature was valid.
```



<!--
Let's walk through this full locking script in detail. This is one of the most common script patterns in Bitcoin, used for standard Pay-to-Public-Key-Hash (P2PKH) transactions.

First, notice how we start with two pieces of data on our stack - a signature and a public key. These come from the unlocking script that's trying to spend the funds.

The OP_DUP operation is clever - it duplicates the public key because we need it twice: once for checking the hash matches, and once for verifying the signature.

OP_HASH160 performs a double hash - first SHA256, then RIPEMD160. This creates the same hash format used in Bitcoin addresses.

Next, we push the expected public key hash - this is essentially the recipient's address in raw form.

OP_EQUALVERIFY is like doing OP_EQUAL followed by OP_VERIFY. It checks the hashes match and fails immediately if they don't.

Finally, OP_CHECKSIG verifies the signature against the public key, confirming the spender has the private key.

Each step builds on the previous ones, creating multiple layers of verification that must all pass for the script to succeed. This is what makes Bitcoin's scripting system both flexible and secure.

-->

---

# Detailed Unlocking Script

**Definition:**  
  The Unlocking Script (scriptSig) is provided in the transaction input that spends a UTXO. It "unlocks" the conditions set by the locking script.

**Purpose:**  
  To supply the necessary data (like signatures and public keys) that satisfy the conditions of the locking script.

**Key Components (Typical P2PKH Example):**
  - **`<signature>`:**  
    A digital signature generated with the private key corresponding to the public key.
  - **`<public key>`:**  
    The public key that, when hashed, must match the `<pubKeyHash>` specified in the locking script.

<!--
The unlocking script is a crucial part of Bitcoin's transaction validation process. Let's break down its key aspects:

The signature proves ownership - it's created by signing the transaction with the private key. This is cryptographic proof that the person spending the coins controls the private key.

The public key serves two purposes:
1. When hashed, it must match the pubKeyHash in the locking script
2. It's used to verify the signature

Together, these components form a cryptographic puzzle that can only be solved by the rightful owner of the coins. The beauty is in its simplicity - just two pieces of data that provide multiple layers of security.

The unlocking script doesn't contain any operations itself - it just provides the data needed by the locking script. This separation of data (unlocking) from logic (locking) is an important security feature.

When teaching this concept, it's helpful to emphasize how this mirrors physical security - like having both a key (signature) and ID (public key) to access a safety deposit box.
-->

--- 

# Detailed Unlocking Script (cnt.)

**Execution Flow:**  
  1. The unlocking script is executed first, pushing the `<signature>` and `<public key>` onto the stack.
  2. These values are then used by the locking script to verify the transaction.

**Outcome:**  
  If the data provided is valid and meets the conditions, the combined script execution will leave a true value on the stack, permitting the transaction.

**Full Unlocking Script:**

```python
<signature> <public key>
```
<!--
When teaching about unlocking scripts, it's important to emphasize these key points:

1. The unlocking script is just data - it contains no operations, only the signature and public key needed to satisfy the locking script's conditions.

2. The signature proves ownership by demonstrating control of the private key. This is a fundamental concept in public key cryptography.

3. The public key serves dual purposes:
   - When hashed, it must match the pubKeyHash from the locking script
   - It's used to verify the signature's validity

4. The order matters - signature comes before public key because that's the order the locking script expects them.

5. The unlocking script is part of the spending transaction, not the original transaction that created the UTXO.

Common student questions:
- "Why do we need both signature and public key?" - To prove both identity (public key) and ownership (signature)
- "Why isn't the private key used?" - The private key is only used to create the signature, never shared
- "What happens if the signature is invalid?" - The script fails and the transaction is rejected

Real-world analogy: Think of it like a safety deposit box where you need both your ID (public key) and a signature on a form (digital signature) to access the contents.
-->

---

# How Locking and Unlocking Scripts Work Together

**Combined Execution Process:**
1. **Unlocking Script Execution:**  
  - Pushes `<signature>` and `<public key>` onto the stack.
2. **Locking Script Execution:**  
  - Uses `OP_DUP` to duplicate `<public key>`.
  - Uses `OP_HASH160` to hash the duplicate.
  - Compares the hash with `<pubKeyHash>` using `OP_EQUALVERIFY`.
  - Uses `OP_CHECKSIG` to verify that `<signature>` is valid for `<public key>`.
3. **Final Check:**  
  - The script returns true if all operations complete successfully, allowing the UTXO to be spent.

  This process prevents unauthorized spending, ensuring that only the rightful owner (with the correct private key) can unlock the funds.


<!--
Speaker Notes:

1. Locking and Unlocking Scripts Fundamentals
- Explain how these scripts work together as Bitcoin's "smart contract" system
- Emphasize that this is Bitcoin's way of enforcing ownership and spending conditions
- Note that scripts are evaluated sequentially, and all conditions must be met

2. Script Execution Process
- Walk through each step of the combined script execution
- Show how the stack changes with each operation
- Highlight critical security checks (hash comparison, signature verification)

3. Real-world Analogies
- Compare to a bank vault with multiple security checks
- Explain how public key cryptography is like a digital signature system
- Use the safety deposit box analogy for P2PKH transactions

4. Common Pitfalls and Questions
- Address misconceptions about private keys in scripts
- Explain why both signature and public key are needed
- Discuss what happens when script validation fails

5. Technical Deep Dive
- Explain the importance of stack-based execution
- Show how opcodes manipulate the stack
- Demonstrate why the order of operations matters

6. Security Implications
- Discuss the cryptographic security guarantees
- Explain how this prevents unauthorized spending
- Highlight the immutable nature of the script conditions

Remember to:
- Encourage questions about script execution
- Connect concepts to practical Bitcoin transactions
-->

---

# Visualizing the Process

**Step 1: Unlocking Script Pushes Data**  
  - Initial Stack: [ `<signature>`, `<public key>` ]
**Step 2: Locking Script Processes Data**
  - **OP_DUP:**  Duplicates `<public key>` → Stack: [ `<signature>`, `<public key>`, `<public key>` ]
  - **OP_HASH160:**  Hashes the top `<public key>` → Stack: [ `<signature>`, `<public key>`, `<hash>` ]
  - **Push `<pubKeyHash>`:**  Adds the expected hash → Stack: [ `<signature>`, `<public key>`, `<hash>`, `<pubKeyHash>` ]
  - **OP_EQUALVERIFY:**  Compares `<hash>` with `<pubKeyHash>` and removes them if equal.
  - **OP_CHECKSIG:**   Verifies the `<signature>` against the `<public key>`.

**Final Outcome:**  

If the final stack evaluates to true, the script conditions are satisfied, and the funds can be spent.
<!--
Speaker Notes:

1. Visualization Process
- Emphasize that this is a step-by-step breakdown of how Bitcoin validates transactions
- The stack operations show exactly how Bitcoin verifies ownership
- Point out that this is happening on every full node in the network

2. Key Points to Stress
- The stack starts empty and each operation modifies it
- Every step must succeed or the entire validation fails
- This is deterministic - same inputs always produce same results

3. Common Questions
- "Why do we need the public key if we have the hash?" - Explain signature verification
- "What happens if a step fails?" - Transaction is invalid, rejected by network
- "Can someone modify the script?" - No, it's part of consensus rules

4. Technical Details
- The stack is a LIFO (Last In, First Out) data structure
- Each operation has specific rules about stack manipulation
- Script execution is intentionally limited for security

5. Real World Applications
- This is how Bitcoin ensures only rightful owners can spend
- Similar principles used in smart contracts
- Forms basis for more complex Bitcoin scripts

6. Security Considerations
- Cryptographic operations ensure mathematical certainty
- Multiple validation steps provide defense in depth
- Network consensus keeps everyone honest
-->

---

# Summary of Locking & Unlocking Scripts

**Locking Script (scriptPubKey):**
  - Sets the spending conditions.
  - Is part of the transaction output.
  - Uses opcodes to enforce that only a specific public key (or set of keys) can unlock the funds.

**Unlocking Script (scriptSig):**
  - Provides the data required to meet the locking script's conditions.
  - Is part of the transaction input.
  - Must supply a valid signature and public key to satisfy the locking script.

**Combined Mechanism:**  
  The interplay between these scripts ensures that only authorized transactions can spend the funds, forming the core security model of Bitcoin.
<!--
Speaker Notes:

1. Locking & Unlocking Scripts Overview
- Emphasize the fundamental security model of Bitcoin transactions
- Explain how these scripts work together to enforce ownership
- Highlight that this is the basis for all Bitcoin transactions

2. Key Concepts
- Locking script (scriptPubKey) is like a puzzle that needs to be solved
- Unlocking script (scriptSig) provides the solution to that puzzle
- Both must work together perfectly for the transaction to be valid

3. Technical Details
- scriptPubKey is stored with the UTXO
- scriptSig is provided when spending
- Combined validation ensures cryptographic proof of ownership

4. Common Questions
- "What happens if the scripts don't match?" - Transaction is invalid
- "Can someone modify the locking script?" - No, it's part of the UTXO
- "Why do we need both scripts?" - Separation of concerns and security

5. Practical Implications
- This mechanism enables trustless transactions
- Forms the basis for more complex smart contracts
- Essential for understanding Bitcoin's security model

6. Security Considerations
- Scripts are deterministic and non-Turing complete
- Limited instruction set prevents potential attacks
- Network consensus ensures consistent validation
-->

---

# Practical Example: Scripting a P2PKH Transaction

**Locking Script:**  
  `OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG`

**Unlocking Script:**  
  `<signature> <pubKey>`

**Execution Flow:**
  1. **OP_DUP:** Duplicates `<pubKey>`.
  2. **OP_HASH160:** Hashes the duplicated key.
  3. **OP_EQUALVERIFY:** Compares the resulting hash to `<pubKeyHash>`.
  4. **OP_CHECKSIG:** Verifies the `<signature>` against `<pubKey>`.
   
**Outcome:**  
  Successful verification means the UTXO can be spent.

<!--
Speaker Notes:

1. Execution Flow Explanation
- Walk through each operation step-by-step
- Emphasize how the stack changes at each step
- Show how verification happens in sequence

2. Real-world Analogy
- Compare to a lock and key mechanism
- The public key hash is like a lock's internal mechanism
- The signature and public key together act as the key

3. Common Pitfalls
- Explain why order matters in script execution
- Highlight common debugging scenarios
- Discuss what happens if verification fails

4. Security Implications
- Discuss the cryptographic strength of this approach
- Explain why this is resistant to various attacks
- Emphasize the importance of proper key management

5. Performance Considerations
- Discuss script execution costs
- Explain why this is efficient for basic transactions
- Compare with other script types

6. Best Practices
- When to use P2PKH vs other script types
- Key generation and storage recommendations
- Transaction signing considerations
-->

---

# Practical Example: Scripting a P2WPKH Transaction (SegWit)
 Uses witness data instead of traditional scriptSig.

**Locking Script:**    `0 <pubKeyHash>`

**Witness Data:** Contains `<signature>` and `<pubKey>` in the `txinwitness` field.

**Advantages of SegWit:**
  - Reduced transaction weight.
  - Increased block capacity.
  
**Execution Differences:**
  - Old nodes see the simplified script as "anyone-can-spend" but rely on miner consensus.
  - New nodes verify the witness data to ensure validity.

---

# Comparing P2PKH and P2WPKH

| **Aspect**               | **P2PKH**                                      | **P2WPKH (SegWit)**                         |
|----------------------|--------------------------------------------|-----------------------------------------|
| Data Location        | scriptSig and scriptPubKey                 | Witness field and simplified locking script |
| Structure            | More traditional, detailed scripts         | Streamlined for efficiency              |
| Transaction Weight   | Standard weight                            | Lower weight due to segregated witness  |
| Compatibility        | Legacy support                             | Backward compatible with improved features |


<!--
Speaker Notes:

1. Comparison Table Explanation
- Walk through each row of the table in detail
- Emphasize how P2WPKH evolved from P2PKH
- Highlight the practical benefits of using SegWit

2. Technical Deep Dive
- Explain how witness data separation works
- Discuss the impact on transaction malleability
- Show real transaction examples if time permits

3. Migration Considerations
- Discuss wallet compatibility
- Address format differences
- Cost savings in practice

4. Best Practices
- When to use P2WPKH vs P2PKH
- Address generation considerations
- Transaction signing workflow

5. Common Questions
- Address backward compatibility
- Fee calculation differences
- Security implications
-->

---

# Advanced Concepts in Bitcoin Scripting

**Multisignature Scripts:**
  - Require multiple signatures to authorize spending.
  - Enhances security for shared or corporate funds.
  
**Timelocks:**
  - `OP_CHECKLOCKTIMEVERIFY` and `OP_CHECKSEQUENCEVERIFY` allow funds to be locked until a certain time. (Useful for escrow and delayed transactions.)
  
**P2SH (Pay-to-Script-Hash):**
  - Embeds complex scripts within a hash.
  - Simplifies transaction data while allowing advanced scripts.
  
**Smart Contracts on Bitcoin:**
  - Combining these features enables more sophisticated contract conditions.

<!--
Speaker Notes:

1. Multisignature Scripts
- Explain the M-of-N concept in multisig
- Show practical examples (2-of-3, 3-of-5)
- Discuss use cases like corporate treasuries
- Cover technical implementation details

2. Timelock Deep Dive
- Explain absolute vs relative timelocks
- Show how to implement inheritance planning
- Discuss escrow implementations
- Cover edge cases and limitations

3. P2SH Implementation
- Walk through the P2SH structure
- Compare with raw script execution
- Show redeem script construction
- Discuss verification process

4. Smart Contract Examples
- Demonstrate simple atomic swaps
- Show HTLC (Hash Time Locked Contract) example
- Cover common patterns and anti-patterns
- Discuss limitations vs other platforms

5. Interactive Demos
- Live script building if time permits
- Common debugging scenarios
- Best practices for testing
-->


---

# Future Directions and Next Steps

**Experimentation:**
  - Write and test your own custom scripts.
  - Use btcdeb and Testnet environments for hands-on practice.
**Deep Dive Topics:**
  - Advanced multisig setups.
  - Custom script patterns for decentralized applications.
**Continued Learning:**
  - Stay updated with Bitcoin Improvement Proposals (BIPs) and community developments.
  - Explore how evolving Bitcoin standards (like Taproot) further impact scripting capabilities.

---

# Thank You!

- Thank you for joining this comprehensive overview of Bitcoin Scripting.
- Continue exploring, experimenting, and innovating in the world of Bitcoin smart contracts.
- Happy scripting and safe transactions!

--- 

# Links


***Bitcoin Script Development Tools***

- [BitIDE](https://bitide.qedprotocol.com/) - Interactive Bitcoin Script IDE
- [Bitcoin IDE](https://siminchen.github.io/bitcoinIDE/build/editor.html) - Visual Bitcoin Script Editor
- [Bitcoin Script Online Debugger](https://bitcoin-script-debugger.visvirial.com/) - Step-through Script Debugger
- [Bitauth IDE](https://ide.bitauth.com/) - Advanced Bitcoin Script Development Environment

***Documentation and References***
- [Bitcoin Script Wiki](https://en.bitcoin.it/wiki/Script) - Comprehensive Script Documentation
- [P2PKH Script Guide](https://learnmeabitcoin.com/technical/script/p2pkh/) - Pay To Public Key Hash Tutorial
- [Bitcoin Script Tools Overview](https://www.perplexity.ai/search/bitcoin-script-tools-and-websi-U9llSn1yRP63EFlDjhFm_g) - Curated List of Development Tools

***Learning Resources***
- [Learning Bitcoin from the Command Line](https://github.com/BlockchainCommons/Learning-Bitcoin-from-the-Command-Line) - Complete Course for Bitcoin Programming
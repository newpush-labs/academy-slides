---
title: "Session 3: Advanced Bitcoin Script"
subtitle: University Course Session (90 Minutes)
theme: ../../themes/np-slides-theme
background: https://source.unsplash.com/1600x900/?technology,bitcoin
transition: slide-left
mdc: true
layout: intro
---

# Advanced Bitcoin Script
## Session #3

<!--
Welcome to our advanced session on Bitcoin Script. Today we'll explore sophisticated scripting techniques, practical implementations, and real-world applications of Bitcoin's smart contract capabilities.
-->

---

# Agenda

- Time-based Script Controls (CLTV & CSV)
- Hash-Locks and Atomic Swaps
- Pay-to-Script-Hash (P2SH) Deep Dive
- Witness Programs and SegWit Integration
- Script Optimization and Best Practices

**Hands-on Practice:**
- Building Time-Locked Contracts
- Implementing Hash-Locked Transactions
- Creating and Using P2SH Addresses

<!--
Today's session focuses on practical implementations. We'll not just learn the theory, but actually write and analyze real Bitcoin scripts. Each concept will be accompanied by concrete examples and use cases.
-->

---

# Time-Locks: CHECKLOCKTIMEVERIFY (CLTV)

**Purpose:** Lock funds until a specific block height or timestamp

**Script Example:**
```python
<timestamp/blockheight> OP_CHECKLOCKTIMEVERIFY OP_DROP
OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
```

**Real Implementation:**
```python
// Lock funds until block 780000
780000 OP_CHECKLOCKTIMEVERIFY OP_DROP
OP_DUP OP_HASH160 a23b22f70239e34c4c95a111c0f1c0d4f45e297a OP_EQUALVERIFY OP_CHECKSIG
```

**Stack Evolution:**
1. Initial: [timestamp, pubkey, sig]
2. After CLTV: [pubkey, sig]
3. Final verification: [true/false]

<!--
CLTV (BIP-65) adds time-based restrictions to Bitcoin transactions. The timestamp can be specified as either a Unix timestamp or a block height.

The OP_DROP after CLTV is necessary because CLTV leaves the time value on the stack after verification.

Common use cases include trust-less escrow services, inheritance planning, and time-delayed security measures.
-->

---

# Time-Locks: CHECKSEQUENCEVERIFY (CSV)

**Purpose:** Lock funds for a relative time period after UTXO creation

**Script Example:**
```python
<relative_blocks> OP_CHECKSEQUENCEVERIFY OP_DROP
OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
```

**Practical Implementation:**
```python
// Lock for 144 blocks (~1 day) after UTXO creation
144 OP_CHECKSEQUENCEVERIFY OP_DROP
OP_DUP OP_HASH160 89abcdef0123456789abcdef01234567 OP_EQUALVERIFY OP_CHECKSIG
```

**Use Cases:**
- Payment Channels
- Two-Factor Wallet Security
- Delayed Recovery Mechanisms

<!--
CSV (BIP-112) enables relative time locks, counting from when the UTXO was created. This is particularly useful for payment channel constructions and security features.

The relative timelock can be specified in blocks or time units. For security-critical applications, using block heights is recommended as it's more predictable.
-->

---

# Hash-Locks and Pre-Images

**Basic Hash-Lock Script:**
```python
OP_HASH160 <hash_of_secret> OP_EQUALVERIFY
OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
```

**Complete HTLC Example:**
```python
OP_IF
    OP_HASH160 <hash_of_secret> OP_EQUALVERIFY
    <recipient_pubkey> OP_CHECKSIG
OP_ELSE
    <timeout> OP_CHECKLOCKTIMEVERIFY OP_DROP
    <sender_pubkey> OP_CHECKSIG
OP_ENDIF
```

**Unlocking Paths:**
1. **Success Path:** [secret, true, signature]
2. **Timeout Path:** [false, signature]

<!--
Hash-Locks are fundamental to many advanced Bitcoin contracts. The pre-image (secret) must hash to a specific value to unlock the funds.

HTLCs (Hashed Time-Locked Contracts) combine hash-locks with time-locks, creating powerful conditional payment mechanisms used in Lightning Network and atomic swaps.
-->

---

# Atomic Swap Implementation

**Alice's Contract:**
```python
OP_IF
    // Hash-Lock Branch
    OP_HASH160 <hash_of_secret> OP_EQUALVERIFY
    <bob_pubkey> OP_CHECKSIG
OP_ELSE
    // Refund Branch
    <24_hours> OP_CHECKLOCKTIMEVERIFY OP_DROP
    <alice_pubkey> OP_CHECKSIG
OP_ENDIF
```

**Bob's Contract:**
```python
OP_IF
    // Hash-Lock Branch
    OP_HASH160 <same_hash> OP_EQUALVERIFY
    <bob_pubkey> OP_CHECKSIG
OP_ELSE
    // Refund Branch
    <12_hours> OP_CHECKLOCKTIMEVERIFY OP_DROP
    <alice_pubkey> OP_CHECKSIG
OP_ENDIF
```

**Execution Flow:**
1. Alice creates secret S
2. Both parties create their HTLCs
3. Bob claims his coins revealing S
4. Alice uses revealed S to claim her coins

<!--
Atomic swaps enable trustless exchange of different cryptocurrencies. The same secret is used in both contracts, ensuring atomicity - either both transactions complete or neither does.

The timeouts are staggered (24h vs 12h) to ensure Alice can claim her coins if Bob claims his.
-->

---

# Pay-to-Script-Hash (P2SH) Deep Dive

**Standard P2SH Structure:**
```python
// Redeem Script (stored off-chain)
2 <pubkey1> <pubkey2> <pubkey3> 3 OP_CHECKMULTISIG

// Locking Script
OP_HASH160 <hash_of_redeem_script> OP_EQUAL

// Unlocking Script
<sig1> <sig2> <redeem_script>
```

**Creating P2SH Address:**
1. Write redeem script
2. Hash: SHA256 then RIPEMD160
3. Add version byte (0x05 for mainnet)
4. Double SHA256 checksum
5. Base58Check encode

<!--
P2SH (BIP-16) moves complex script conditions off-chain until spending time. This reduces initial transaction size and improves privacy.

The redeem script is only revealed when spending, allowing complex conditions to be hidden behind a simple hash.
-->

---

# P2SH Practical Example: 2-of-3 Multisig

**Complete Implementation:**
```python
// Redeem Script
OP_2
0x02a8d02a2d6e84dcd815c4bd7e47a8215b48e2c3e8338d9ce845325e7f87527a4d
0x03a627f934c4f3bb1747a42f6e0782fb5d5cab2274f9114e26eb64787f61dcc2cc
0x02b006deae9f1471e436aa54e4c851f4f2f55a5b92b8f0f5e6cfc4220c2d2b8cb0
OP_3
OP_CHECKMULTISIG

// P2SH Script
OP_HASH160 89abcdef0123456789abcdef01234567 OP_EQUAL
```

**Spending Example:**
```python
// Unlocking Script
OP_0  // Due to CHECKMULTISIG bug
<sig1>
<sig3>
<redeem_script>
```

<!--
The OP_0 is required due to an early bug in OP_CHECKMULTISIG that consumes an extra stack item.

When spending, signatures must be provided in the same order as their corresponding public keys in the redeem script.
-->

---

# Witness Programs: P2WPKH and P2WSH

**P2WPKH Structure:**
```python
// Native SegWit Output
0 <20-byte-key-hash>

// Witness (not in scriptSig)
<signature> <pubkey>
```

**P2WSH Structure:**
```python
// Native SegWit Output
0 <32-byte-script-hash>

// Witness
<signature> <pubkey> <script>
```

**Weight Calculation:**
- Base size: 4 vBytes per byte
- Witness size: 1 vByte per byte
- Virtual size = (Base * 4 + Witness) / 4

<!--
SegWit separates signature data (witness) from the transaction hash, fixing transaction malleability and reducing effective transaction size.

The '0' version byte indicates native SegWit. Future versions may enable new script features.
-->

---

# Script Optimization Techniques

**Before Optimization:**
```python
OP_DUP OP_DUP OP_HASH160 <pubKeyHash>
OP_EQUALVERIFY OP_HASH160 <pubKeyHash2>
OP_EQUALVERIFY OP_CHECKSIG
```

**After Optimization:**
```python
OP_DUP OP_HASH160 <pubKeyHash>
OP_EQUALVERIFY OP_CHECKSIG
```

**Common Optimizations:**
1. Remove redundant operations
2. Use minimal push operations
3. Combine multiple checks
4. Leverage OP_EQUALVERIFY vs OP_EQUAL OP_VERIFY

<!--
Script optimization reduces transaction size and execution cost. However, always balance optimization against readability and maintainability.

Testing optimized scripts thoroughly is crucial, as optimization can introduce subtle bugs.
-->

---

# Testing and Debugging Scripts

**Using btcdeb:**
```bash
# Test a P2PKH script
btcdeb --tx=<hex> --txin=<hex> \
  --script="OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG"
```

**Common Testing Scenarios:**
1. Happy path (expected usage)
2. Edge cases (minimum/maximum values)
3. Error conditions
4. Timeout scenarios
5. Invalid signatures/data

<!--
Thorough testing is essential for Bitcoin scripts. Use testnet for live testing and btcdeb for step-by-step debugging.

Always test both successful and failure paths to ensure the script behaves correctly in all scenarios.
-->

---

# Security Best Practices

**Script Design:**
- Use standard templates when possible
- Implement proper timeout mechanisms
- Include emergency recovery paths
- Validate all input data

**Testing Protocol:**
1. Debug with btcdeb
2. Test on regtest
3. Verify on testnet
4. Small amounts on mainnet first

**Common Pitfalls:**
- Insufficient timeout values
- Missing error handling
- Inadequate testing
- Complex script combinations

<!--
Security in Bitcoin scripts is paramount - mistakes can lead to permanent loss of funds.

Start with proven patterns and modify carefully. Always include timeout-based recovery mechanisms.
-->

---

# Advanced Script Patterns

**Covenant Example:**
```python
// Restrict where funds can be spent
OP_DUP OP_HASH160 <pubKeyHash>
OP_EQUALVERIFY OP_CHECKSIG
OP_RETURN <allowed_destination>
```

**Recovery Mechanism:**
```python
OP_IF
    // Normal spending path
    <timeout> OP_CHECKLOCKTIMEVERIFY OP_DROP
    <primary_pubkey> OP_CHECKSIG
OP_ELSE
    // Recovery path
    <recovery_timeout> OP_CHECKLOCKTIMEVERIFY OP_DROP
    <backup_pubkey> OP_CHECKSIG
OP_ENDIF
```

<!--
Advanced patterns enable sophisticated smart contracts while maintaining Bitcoin's security model.

These patterns can be combined to create complex yet secure contract conditions.
-->

---

# Future Developments

- **Taproot/Schnorr:**
  - Enhanced privacy
  - Reduced script size
  - More efficient multisig

- **New BIPs:**
  - Cross-input script sharing
  - Improved covenant capabilities
  - Enhanced scripting features

<!--
Stay informed about upcoming Bitcoin improvements. New features often enable more efficient or powerful scripting capabilities.

Consider future compatibility when designing long-term contract solutions.
-->

---

# Resources and Tools

**Development Tools:**
- [Bitcoin Script IDE](https://siminchen.github.io/bitcoinIDE)
- [btcdeb](https://github.com/bitcoin-core/btcdeb)
- [Bitcoin Script Playground](https://bitcoin-script-debugger.visvirial.com/)

**Documentation:**
- [Bitcoin Wiki: Script](https://en.bitcoin.it/wiki/Script)
- [Bitcoin Optech](https://bitcoinops.org/)
- [Bitcoin Core Docs](https://bitcoin.org/en/developer-documentation)

<!--
These resources provide valuable tools and information for Bitcoin script development.

Regular practice with these tools helps build confidence in script writing and debugging.
-->

---

# Thank You!

**Key Takeaways:**
- Advanced scripting enables powerful smart contracts
- Always prioritize security and testing
- Use standard patterns when possible
- Stay updated with Bitcoin development

**Next Steps:**
- Practice with provided examples
- Experiment on testnet
- Join the Bitcoin development community

<!--
Thank you for participating in this advanced Bitcoin scripting session. Remember to always test thoroughly and start with small amounts when moving to mainnet.
-->

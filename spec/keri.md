## KERI Fundamentals
This section is informative.

[[ref: Key Event Receipt Infrastructure (KERI)]] is a protocol for managing cryptographic keys, identifiers, and associated verifiable data structures. KERI was first described in an [academic paper](https://arxiv.org/abs/1907.02143), and its [specification](https://github.com/trustoverip/tswg-keri-specification) is currently incubated under [Trust Over IP Foundation](https://trustoverip.org/). The open source community that develops KERI-related technologies can be found at https://github.com/WebOfTrust. This section outlines the fundamentals and components of the KERI protocol that are related to the `did:webs` method.

### Autonomic Identifier (AID)

An [[ref: autonomic identifier (AID)]] is a globally-unique persistent self-certifying identifier that serves as the primary root-of-trust of the KERI protocol. An AID is cryptographically bound to a [[ref: KEL]] that determines the evolution of its [[ref: key state]] using the [[ref: pre-rotation]] mechanism. AIDs and the underlying KERI protocol, by themselves, satisfy most of the [properties](https://www.w3.org/TR/did-core/#design-goals) that DIDs require, including decentralization, control, security, proof-based, and portability. For example, DIDs that have the same AID component are considered [equivalent](#equivalent-identifiers), allowing AIDs to be portable across different DID methods such as `did:webs` and `did:keri`.

### Key Event Log (KEL)

The binding between an [[ref: AID]] and its cryptographic keys is proved by a data structure called a [[ref: key event log (KEL)]] that allows the [[ref: key states]] of the AID to evolve. For a `did:webs` DID, a KEL is an essential component in the [[ref: KERI event stream]] that is used to verify its authenticity.

A KEL is a hash-chain append-only log and can be considered a variant of blockchain. However, a KEL differs from the traditional blockchain technology in at least two important ways:

* It records the [[ref: key event]] history of a single AID with a single [[ref: controller]], instead of an arbitrarily large collection updated by other participants in the network. This makes a KEL memory-efficient, fast, cheap, and trivially scalable.
* It is fully [[ref: self-certifying]], meaning its correctness can be proved by direct inspection, without a distributed consensus algorithm or assumptions about trust in an external data source or its governance.

These properties allows a KEL to be published anywhere, without special guarantees from its storage mechanism. For example, a KEL of an AID could be published and migrated between different KERI-compatible blockchain networks that use different DID methods. A KEL also records changes to key types and cryptographic algorithms, providing the AID portability and adaptability to multiple ecosystems throughout its lifecycle.

### AID Derivation

The value of an [[ref: AID]] is derived from the first [[ref: key event]], called the [[ref: inception event]], of a [[ref: KEL]]. The inception event includes inital public key(s), called the _current_ key(s), that can be used to control the AID. The cryptographic relationship between the AID and its keys eliminates an early chain-of-custody risk that plagues many other DID methods where an attacker uses compromised keys to create a DID without the DID controller's knowledge. This derivation process is similar to techniques used by `did:key`, `did:peer`, `did:sov`, and `did:v1`.

The simplest AIDs, called non-transferrable [[ref: direct mode]] AIDs, have no additional input to the derivation function, and expose a degenerate KEL that can hold only the inception event. This KEL is entirely derivable from the AID itself, and thus requires no external data. Non-transferrable direct mode AIDs are ideal for ephemeral use cases and are excellent analogs to `did:key` and `did:peer` with `numalgo=0`. This is by no means not the only option as KERI offers richer choices that are especially valuable if an AID is intended to have a long lifespan.

### Pre-rotation

Public keys in the [Verification Methods](#verification-methods) of a `did:webs` DID can be changed via a mechanism called [[ref: pre-rotation]]. With pre-rotation, the inception event of the associated AID also includes the hash(s) of the _next_ key(s) that can be used to change the [[ref: key state]] of the AID. AIDs with one or more pre-rotated _next_ keys are called _transferrable_ AIDs because their control can be transferred to new keys. AIDs that do not use pre-rotation cannot change their keys and are thus _non-transferrable_.

Pre-rotation has profound security benefits. If a malicious party steals the _current_ private key for a transferrable AID, they only accomplish _temporary_ mischief, because the already-existing KEL contains a commitment to a future state. This prevents them from rotating the stolen AID's key to an arbitrary value of their choosing. As soon as the AID controller suspects a compromise, they can change the key state of the AID using the pre-rotated _next_ key and locks the attacker out again.

### Weighted Multisig

The [[ref: KERI]] protocol supports weighted multi-signature scheme that allows for [conditional proof](#thresholds) in the [Verification Methods](#verification-methods). A multisig [[ref: AID]] distributes its control among multiple key holders. This includes simple M-of-N rules such as "3 of 5 keys must sign to change the AID's [[ref: key state]]". More sophisticated configurations are also supported: "Acme Corp's AID is controlled by the keys of 4 of 7 board members, or by the keys of the CEO and 2 board members, or by the keys of the CEO and the Chief Counsel."

The security and recovery benefits of this feature are obvious when an AID references organizational identity. However, even individuals can benefit from this, when stakes are high. They simply store different keys on different devices, and then configure how their devices constitute a management quorum. This decreases risks from lost phones, for example.

### Witnesses

In the [[ref: direct mode]], the [[ref: controller]] of an [[ref: AID]] is responsible for the distribution of its [[ref: KEL]]. Since the controller may not be highly available, the controller may designate additional supporting infrastructure, called [[ref: witnesses]], for the [[ref: indirect mode]] distribution of the [[ref: KELs]]. Witnessess may or may not be under direct control of the AID's controller and could be deployed on either centralized or decentralized architectures, including blockchains. The witnesses are embedded in the AID's [[ref: key event]] and, if included in the [[ref: inception event]], alter the AID value.

Unlike a blockchain with a distributed consensus mechanism, witnesses do not coordinate or come to consensus with one another during an update to its AID's [[ref: key event]] history. Hence, they need not be deeply trustworthy; merely by existing, they improve trust. This is because anyone changing an AID's key state or its set of witnesses, including the AID's legitimate controller, has to report those changes to the witnesses that are currently active, to produce a valid evolution of the KEL. The AID controller and all witnesses thus hold one another accountable. Further, it becomes possible to distinguish between duplicity and imperfect replication of key states.

### Transaction Event Log (TEL)

The [[ref: KERI]] protocol supports a verifiable data structure, called the [[ref: transaction event log (TEL)]], that binds an [[ref: AID]] to non-repudiable data that is deterministically bound to the [[ref: key event]] history in the [[ref: KEL]]. Transactions that are recorded in a TEL may include things like the issuance and revocation of verifiable credentials or the fact that listeners on various service endpoints started or stopped. Like KELs, TELs are self-certifying and may also be published by KERI witnesses to enhance discoverability and provide watcher networks the ability to detect duplicity. For example, we demonstrate that in this spec in how we anchor [[ref: designated aliases]] as [[ref: verifiable data on a TEL]]. 

### Web Independence

Although _this DID method depends on web technology, KERI itself does not_. It's as easy to create AIDs on IOT devices as it is on the web. AIDs offer the same features regardless of their origin and besides HTTP, they are shareable over Lo-Ra, Bluetooth, NFC, Low Earth Orbit satellite protocols, service buses on medical devices, and so forth. Thus, KERI's AIDs offer a bridge between a web-centric DID method and lower-level IOT ecosystems.

### Flexible Serialization

[[ref: KELs]] and [[ref: TELs]] of `did:webs` DIDs (i.e., AIDs) are included in the [[ref: KERI event streams]] for verification of the DID documents. The KERI event streams use [[ref: Composable Event Streaming Representation ([[ref: CESR]])]] for data serialization. Although [[ref: CESR]] is a deep subject all by itself, at a high level, it has two essential properties:

*   **Content in [[ref: CESR]] is self-describing and supports serialization as binary and text**: That is in [[ref: CESR]], _a digital signature on a [[ref: CESR]] data structure is stable no matter which underlying serialization format is used_.  In effect it supports multiple popular serialization formats like JSON, CBOR, and MsgPack with room for many more. These formats can be freely mixed and combined in a [[ref: CESR]] stream because of the self-describing nature of these individual [[ref: CESR]] data structures.  The practical effect is that developers get the best of both worlds: they can produce and consume data as text to display and debug in a human-friendly form and they can store and transmit this data in its tersest form, _all without changing the signature on the data structures_.
*   **Cryptographic primitives are structured into compact standard representations**: Cryptographic primitives such as keys, hashes, digests, sealed-boxes, signatures, etc... are structured strings with a recognizable data type prefix and a standard representation in the stream. This means they are very terse and there is no need for the variety of representation methods that create interoperability challenges in other DID methods (`publicKeyJwk` versus `publicKeyMultibase` versus other; see the verification material section of the [[ref: DID specification]].

Despite this rich set of features, KERI imposes only light dependencies on developers. The cryptography it uses is familiar and battle-hardened, exactly what one would find in standard cryptography toolkits. For example, the python implementation (keripy) only depends on the `pysodium`, `blake3`, and `cryptography` python packages. Libraries for KERI exist in javascript, rust, and python.

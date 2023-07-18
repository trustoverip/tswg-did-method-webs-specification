## KERI Fundamentals

[[ref: KERI]] ([[ref: Key Event Receipt Infrastructure]]) is a methodology for managing cryptographic keys, plus the identifiers and verifiable data structures that depend on them. KERI was first described in an [academic paper](https://arxiv.org/abs/1907.02143), and is now a [draft IETF RFC](https://weboftrust.github.io/ietf-keri/draft-ssmith-keri.html). The open source community that develops KERI-related technologies can be found at https://github.com/WebOfTrust.

In KERI, an [[ref: autonomic identifier]] ([[ref: AID]]) is a globally unique string that is bound to cryptographic keys in a special way. AIDs have most of the properties that DIDs require, plus a few that give them unusually special security and decentralization.

[[def: Key Event Log, KEL]]

The binding between an AID and its cryptographic keys is proved by a data structure called a key event log (KEL). This data structure has certain blockchain-like properties. However, a KEL differs from blockchain technology in at least two important ways:

1.  It records the history of a single AID with a single owner, instead of an arbitrarily large collection updated by the public. This makes it tiny (a few KB), fast, cheap, and trivially scalable.
2.  It is fully [[ref: self-certifying]], meaning its correctness can be proved by direct inspection, without a consensus algorithm or assumptions about trust in an external data source or its governance.

Because of these properties, a KEL can be published anywhere, without special guarantees from its storage mechanism. Also, since KELs can be shared directly by the owner of an AID, and can be deleted from a particular location as needed, they avoid thorny regulatory issues like GDPR's right of erasure.

A KEL allows the state of the AID to evolve. Importantly, it can record changes to key types and cryptographic algorithms. This lets an AID adapt itself to more than one blockchain ecosystem over its lifecycle. It also lets an AID adopt quantum-safe mechanisms without having to upgrade a whole blockchain ecosystem; AIDs are not locked into the cryptography used to create them.

[[def: Derived from Public Key]]

The KEL begins with an [[ref: inception event]]. This event derives the AID value from the initial public key that will be used to control it. Conceptually: `derive( initial_pub_key ) → AID`. Forcing a relationship between AID and key in this way eliminates an early chain-of-custody risk that plagues many DID methods (an attacker creates a DID without a key-owner's knowledge, using compromised keys). It is similar to techniques used by `did:key`, `did:peer`, `did:sov`, and `did:v1`.

The simplest AIDs (called [[ref: direct mode]] AIDs in KERI) have no additional input to the derivation function, and expose a degenerate KEL that can hold only the inception event. This KEL is entirely derivable from the AID itself, and thus requires no external data. Direct mode AIDs are ideal for ephemeral use cases and are excellent analogs (and convenient interop tools) to `did:key` and `did:peer` with `numalgo=0` (see [Transformations](#transformations).) However, this is not the only option. KERI offers richer choices that are especially valuable if an AID is intended to have a long lifespan.

[[def: Pre-rotation]]

Optionally, the inception event of an AID can also reference the hash of the _next_ key that will be used to control the AID. This changes how the AID is derived: `derive( initial_public_key, next_key_hash )`. KERI calls this feature [[ref: pre-rotation]]; AIDs that use it are called [[ref: transferrable]] AIDs because their control can be transferred to new keys. AIDs that do not use pre-rotation cannot change their keys, and are thus thus [[ref: non-transferrable]].

Pre-rotation has profound security benefits. If a malicious party steals the private key for an AID with this feature, they only accomplish _temporary_ mischief, because the already-existing KEL contains a commitment to future state. This prevents them from rotating the stolen AID's key to an arbitrary value of their choosing. As soon as the AID owner suspects a compromise, they can do a valid rotation that locks the attacker out again.

[[def: Weighted Multisig]]

KELs can enforce the choice to distribute control among multiple key-holders. This includes simple M-of-N rules like "3 of 5 keys must sign to change the AID's state," but also more sophisticated configurations: "Acme Corp's AID is controlled by the keys of 4 of 7 board members, or by the keys of the CEO and 2 board members, or by the keys of the CEO and the Chief Counsel."

The security and recovery benefits of this feature are obvious when an AID references organizational identity. However, even individuals can benefit from this, when stakes are high. They simply store different keys on different devices, and then configure how their devices constitute a management quorum. This decreases risks from lost phones, for example.

[[def: Witnesses]]

In addition, KELs allow an AID owner to declare that an AID has [[ref: witnesses]]. This choice also changes how the AID value is derived: `derive( initial_public_key, next_key_hash, witnesses )`. Witnesses are independent, highly decentralized parties (web sites, blockchains, etc.) that each publish a copy of the KEL.

Witnesses do not coordinate or come to consensus with one another, and they need not be deeply trustworthy; merely by existing, they improve trust. This is because anyone changing an AID's key state or its set of witnesses (including the AID's legitimate owner) has to report those changes to the witnesses that are currently active, to produce a valid evolution of the KEL. The AID owner and all witnesses thus hold one another accountable. Further, it becomes possible to distinguish between duplicity and imperfect replication of state.

[[def: Transaction Event Log]]

KERI supports an official mechanism for binding an identifier to important, non-repudible actions that must relate with deterministic order to the key rotation events in the KEL. This [[ref: transaction event log]] ([[ref: TEL]]) is how an AID can tell the world it has issued and revoked credentials, started or stopped listening on a service endpoint, and so forth. TELs are <a>self-certifying</a>, just like KELs, but are also published by witnesses to enhance discoverability and accountability.

[[def: Web Independence]]

Although _this DID method_ depends on web technology, _KERI itself_ does not. It's as easy to create AIDs on IOT devices as it is on the web. AIDs offer the same features regardless of their origin, and besides HTTP, they are shareable over Lo-Ra, BlueTooth, NFC, Low Earth Orbit satellite protocols, service buses on medical devices, and so forth. Thus, KERI's AIDs offer a bridge between a web-centric DID method and lower-level IOT ecosystems.

[[def: Flexible Serialization]]

KERI uses [[[ref: CESR]] ](https://weboftrust.github.io/ietf-cesr/draft-ssmith-cesr.html)([[ref: Composable Event Streaming Representation]]) to serialize data. This is a deep subject all by itself, but at a high level, it means two things:

*   JSON, CBOR, and MsgPack are all valid and equivalent ways to represent a KERI data structure. Further, JSON, CBOR, and MsgPack can be freely mixed/combined, because CESR makes each chunk of content self-describing, _and a digital signature on a CESR data structure is stable no matter which format is used_. The practical effect is that developers get the best of both worlds: they can produce and consume data structures mostly using whatever toolset they like, they can displayed and debug data structures in a human-friendly form, and they can store or transmit data in its tersest form, _all without changing the signature_.
*   Cryptographic primitives such as keys, hashes, and signatures are structured strings with a recognizable data type prefix and a standard representation. This means they are very terse, and there is no need for the variety of representation methods that create interoperability challenges in other DID methods (`publicKeyJwk` versus `publicKeyMultibase` versus other; see [section 5.2 of the DID spec](https://www.w3.org/TR/did-core/#verification-material)).

Despite this rich set of features, KERI imposes only light dependencies on developers. The cryptography it uses is familiar and battle-hardened — exactly what you'd find in standard toolkits for big numbers and elliptic curves. For example, the python implementation uses just the `pysodium`, `blake3`, and `cryptography` packages. Libraries for KERI exist in javascript, rust, and python.
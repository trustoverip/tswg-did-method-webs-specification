## Terminology

[[def: authentic chained data container (ACDC), ACDC, ACDCs]]
~ a variant of [the Verifiable Credential (VC) specification](https://www.w3.org/TR/vc-data-model/) that inherit the security model derived from [[ref: KERI]], as defined by the [draft ACDC specification](https://trustoverip.github.io/tswg-acdc-specification/draft-ssmith-acdc.html). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/authentic-chained-data-container) for more detail.

[[def: autonomic identifier (AID), AID, AIDs]]
~ A [[ref: DID]] that is self-certifying and cryptographically bound to a [[ref: key event log]] ([[ref: KEL]]), as defined by the [draft KERI specification](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#name-autonomic-identifier-aid). An AID is either non-transferable or transferable. A non-transferable AID does not support key rotation while a transferable AID supports key rotation using a key [[ref: pre-rotation]] mechanism that enables the AID to persist in spite of the evolution of its key state. See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/autonomic-identifier) for more detail.

[[def: compact event streaming representation (CESR), CESR]]
~ An encoding format that enables round-trip text-binary conversion of concatenated cryptographic primitives and general data types, as defined by the [draft CESR specification](https://trustoverip.github.io/tswg-cesr-specification/draft-ssmith-cesr.html) and [draft CESR Proof Signature specification](https://trustoverip.github.io/tswg-cesr-proof-specification/draft-pfeairheller-cesr-proof.html).  See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/composable-event-streaming-representation) for more detail.

[[def: controller, constrollers]]
~ A controlling entity that can cryptographically prove the control authority (signing and rotation) over an [[ref: AID]] as well as make changes on the associated [[ref: KEL]]. A controller may consist of multiple controlling entities in a multi-signature scheme. See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/controller) for more detail.

[[def: decentralized identifier (DID), DID, DIDs]]
~ A globally unique persistent identifier, as defined by the [DID Core](https://www.w3.org/TR/did-core/#dfn-decentralized-identifiers).

[[def: DID document, DID documents]]
~ A set of data describing the subject of a [[ref: DID]], as defined by [DID Core](https://www.w3.org/TR/did-core/#dfn-did-documents). See also section [DID Documents](#did-documents).

[[def: direct mode]]
~ an operational mode of the [[ref: KERI]] protocol where a controller and a verifier of an [[ref: AID]] exchange the [[ref: KEL]] of the AID directly, as defined by the [KERI whitepaper](https://github.com/SmithSamuelM/Papers/blob/master/whitepapers/KERI_WP_2.x.web.pdf). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/direct-mode) for more detail.

[[def: inception event, inception events]]
~ A key event that provides the incepting information needed to derive an [[ref: AID]] and establish its initial [[ref: key state]], as defined by the [draft KERI specification](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#section-2). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/inception-event) for more detail.

[[def: indirect mode]]
~ An operational mode of the [[ref: KERI]] protocol where the [[ref: KEL]] of an [[ref: AID]] is discovered a [[ref: verifier]] via [[ref: witnesses]], as defined by the [KERI whitepaper](https://github.com/SmithSamuelM/Papers/blob/master/whitepapers/KERI_WP_2.x.web.pdf). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/indirect-mode) for more detail.

[[def: interaction event, interaction events]]
~ A key event that anchors external data to an [[ref: AID]], as defined by the [draft KERI specification](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#section-2). An interaction event does not change the [[ref: key state]] of the [[ref: AID]]. See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/interaction-event) for more detail.

[[def: key event, key events]]
~ A serialized data structure of an entry in the [[ref: key event log]]([[ref: KEL]]) for an [[ref: AID]], as defined by the [draft KERI specification](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#section-2). There are three types of key events, namely [[ref: inception event]], [[ref: rotation event]], and [[ref: interaction event]]. See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/key-event) for more detail.

[[def: key event log, KEL, KELs]]
~ A verifiable append-only log of [[ref: key events]] for an [[ref: AID]] that is both backward and forward-chained, as defined by the [draft KERI specification](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#section-2). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/key-event-log) for more detail.

[[def: key event receipt]]
~ A message whose body references a [[ref: key event]] of an [[ref: AID]] and includes one or more signatures on that key event, as defined by the [draft KERI specification](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#section-2). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/key-event-receipt) for more detail.

[[def: key event receipt log (KERL), KERL]]
~ A verifiable append-only log that includes all the consistent [[ref: key event receipt]] messages, as defined by the [draft KERI specification](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#section-2). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/key-event-receipt-log) for more detail.

[[def: key event receipt infrastructure (KERI), KERI]]
~ A protocol that provides an identity system-based secure overlay for the internet and uses [[ref: AIDs]] as the primary roots of trust, as defined by the [draft KERI specification](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/key-event-receipt-infrastructure) for more detail.

[[def: KERI event stream, KERI event streams]]
~ A stream of verifiable KERI data, consisting of the [[ref: key event log]] ([[ref: KEL]]) and other data such as a [[ref: transaction event log]] ([[ref: TEL]]). This data is a [[ref: CESR]] event stream (TODO: link to IANA application/cesr media type) and may be serialized in a file using [[ref: CESR]] encoding. We refer to these CESR stream resources as KERI event streams to simplify the vocabulary. See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/keri-event-stream) for more detail. 

[[def: key state, key states]]
~ The set of currently authoritative keypairs (current keys) for an [[ref: AID]] and any other information necessary to secure or establish control authority over the AID. See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/key-state) for more detail.

[[def: method-specific identifier, MSI]]
~ The `method-specific-id` part of DID Syntax, as defined in [DID Core](https://www.w3.org/TR/did-core/#did-syntax). See section [Method-Specific Identifier](#method-specific-identifier).

[[def: out-of-band introduction (OOBI), OOBI, OOBIs, OOBI specification]]
~ A protocol for discovering verifiable information on an [[ref: AID]] or a [[ref: SAID]], as defined by the [draft OOBI specification](https://trustoverip.github.io/tswg-oobi-specification/draft-ssmith-oobi.html). The OOBI by itself is insecure, and the information discovered by the OOBI must be verified. See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/out-of-band-introduction) for more detail.

[[def: pre-rotation, pre-rotated]]
~ A key rotation mechanism whereby a set of rotation keys are pre-commited using cryptographic digests, as defined by the [draft KERI specification](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#section-2). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/pre-rotation) for more detail.

[[def: rotation event, rotation events]]
~ A key event that provides the information needed to change the [[ref: key state]] for an [[ref: AID]] using [[ref: pre-rotation]], as defined by the [draft KERI specification](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#section-2). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/rotation-event) for more detail.

[[def: self-addressing identifier (SAID), SAID, SAIDs]]
~ An identifier that is uniquely and cryptographically bound to a serialization of data (content-addressable) while also being included as a component in that serialization (self-referential), as defined by the [draft SAID specification](https://trustoverip.github.io/tswg-said-specification/draft-ssmith-said.html). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/self-addressing-identifier) for more detail.

[[def: transaction event log (TEL), TEL, TELs]]
~ A verifiable append-only log of transaction data that are cryptographically anchored to a [[ref: KEL]]. The transaction events of a TEL may be used to establish the issuance or revocation state of [[ref: ACDC]]s. See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/transaction-event-log) for more detail.

[[def: verifier, verifiers]]
~ An entity or component that cryptographically verifies the signature(s) on an event message. See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/verifier) for more detail.

[[def: watcher, watchers]]
~ An entity that keeps a copy of a [[ref: KERL]] of an [[ref: AID]] to detect duplicity of [[ref: key events]], as defined by the [KERI whitepaper](https://github.com/SmithSamuelM/Papers/blob/master/whitepapers/KERI_WP_2.x.web.pdf). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/watcher) for more detail.

[[def: witness, witnesses]]
~ An entity that is designated by the [[ref: controller]] of an [[ref: AID]] to verify, sign, and keep the key events associated with the AID, as defined by the [KERI whitepaper](https://github.com/SmithSamuelM/Papers/blob/master/whitepapers/KERI_WP_2.x.web.pdf). See [WebOfTrust wiki](https://github.com/WebOfTrust/WOT-terms/wiki/witness) for more detail.
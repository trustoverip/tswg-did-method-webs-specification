## Appendix

### Trust Over IP Glossary - Controlled Terms 

[[def: autonomous identifier]] 
~ Another term for [[ref: self-certifying identifier (SCID)]]. 

[[def: cryptographically verifiable]]
~ A property of a data structure that has been digitally signed using a private key such that the digital signature can be verified using the public key. Verifiable data, verifiable messages, verifiable credentials, and verifiable data registries are all cryptographically verifiable. Cryptographic verifiability is a primary goal of the ToIP Technology Stack.

[[def: identifier]]
~ A single attribute—typically a character string—that uniquely identifies an entity within a specific context (which may be a global context). Examples include the name of a party, the URL of an organization, or a serial number for a man-made thing. Supporting definitions: eSSIF-Lab: a character string that is being used for the identification of some entity (yet may refer to 0, 1, or more entities, depending on the context within which it is being used).

[[def: self-certifying identifier (SCID), SCID, SCIDs]]
~ A subclass of verifiable identifier ([[ref: VID]]) that is [[ref: cryptographically verifiable]] without the need to rely on any third party for verification because the [[ref: identifier]] is cryptographically bound to the cryptographic keys from which it was generated. Also known as: [[ref: autonomous identifier]].

[[def: verifiable identifier (VID), VID, VIDs]]
~ An identifier over which the controller can provide cryptographic proof of control.
See also: decentralized identifier, [ref: self-certifying identifier (SCID)].


### Terminology

[[def: AID controlled identifiers, AID controlled identifier]]
~ Any identifier, including `did:webs` DIDs, that have the same AID are by definition referencing the same identity. As defined by [KERI]() TODO: Add link to KERI documentation here.

[[def: authentic chained data container (ACDC), ACDC, ACDCs]]
~ a variant of [[ref: the Verifiable Credential (VC) specification]] that inherits the security model derived from [[ref: KERI]], as defined by the [[ref:  ACDC specification]]. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/authentic-chained-data-container) for more detail.

[[def: autonomic identifier (AID), AID, AIDs]]
~ A [[ref: self-certifying identifier (SCID)]] that is cryptographically bound cryptographically bound to a [[ref: key event log]] ([[ref: KEL]]), as defined by the [[ref: KERI specification]]. An AID is either non-transferable or transferable. A non-transferable AID does not support key rotation while a transferable AID supports key rotation using a key [[ref: pre-rotation]] mechanism that enables the AID to persist in spite of the evolution of its key state. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/autonomic-identifier) for more detail.

[[def: BADA-RUN]]
~ Best available data acceptance - Read/Update/Nullify provides a medium level of security because events are ordered in a consistent way, using a combination of date-time and a key state. The latest event is the one with the latest date-time for the latest key state. See [The KERI spec](https://trustoverip.github.io/tswg-keri-specification/#bada-best-available-data-acceptance-policy) for more detail.

[[def: compact event streaming representation (CESR), CESR]]
~ An encoding format that enables round-trip text-binary conversion of concatenated cryptographic primitives and general data types, as defined by the [[ref:  CESR specification]] and [[ref:  CESR Proof Signature specification]].  See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/composable-event-streaming-representation) for more detail.

[[def: controller, constrollers]]
~ A controlling entity that can cryptographically prove the control authority (signing and rotation) over an [[ref: AID]] as well as make changes on the associated [[ref: KEL]]. A controller may consist of multiple controlling entities in a multi-signature scheme. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/controller) for more detail.

[[def: decentralized identifier (DID), DID, DIDs]]
~ A globally unique persistent identifier, as defined by [DID Core](https://www.w3.org/TR/did-core/#dfn-decentralized-identifiers).

[[def:  designated aliases, designated alias]]
~ An array of [[ref:AID controlled identifiers]] that have been designated by the AID controller to be used as aliases for `equivalentId` and `alsoKnownAs` DID document metadata and to foster verification of redirection to different did:webs identifiers. See [WebOfTrust glossary](https://github.com/WebOfTrust/WOT-terms/wiki/designated-aliases) for more detail.

[[def: DID document, DID documents]]
~ A set of data describing the subject of a [[ref: DID]], as defined by [DID Core](https://www.w3.org/TR/did-core/#dfn-did-documents). See also section [DID Documents](#did-documents).

[[def: direct mode]]
~ an operational mode of the [[ref: KERI]] protocol where a controller and a verifier of an [[ref: AID]] exchange the [[ref: KEL]] of the AID directly, as defined by the [KERI whitepaper](https://github.com/SmithSamuelM/Papers/blob/master/whitepapers/KERI_WP_2.x.web.pdf). See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/direct-mode) for more detail.

[[def: host, hosts, host name, host names]]
~ The part of a URL that can be either a domain name or an IP address. This component specifies the server that the client needs to communicate with in order to access the desired resource on the web.

[[def: inception event, inception events]]
~ A key event that provides the incepting information needed to derive an [[ref: AID]] and establish its initial [[ref: key state]], as defined by the [[ref: KERI specification]]. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/inception-event) for more detail.

[[def: indirect mode]]
~ An operational mode of the [[ref: KERI]] protocol where the [[ref: KEL]] of an [[ref: AID]] is discovered by a [[ref: verifier]] via [[ref: witnesses]], as defined by the [KERI whitepaper](https://github.com/SmithSamuelM/Papers/blob/master/whitepapers/KERI_WP_2.x.web.pdf). See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/indirect-mode) for more detail.

[[def: interaction event, interaction events]]
~ A key event that anchors external data to an [[ref: AID]], as defined by the [[ref: KERI specification]]. An interaction event does not change the [[ref: key state]] of the [[ref: AID]]. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/interaction-event) for more detail.

[[def: key event, key events]]
~ A serialized data structure of an entry in the [[ref: key event log]]([[ref: KEL]]) for an [[ref: AID]], as defined by the [[ref: KERI specification]]. There are three types of key events, namely [[ref: inception event]], [[ref: rotation event]], and [[ref: interaction event]]. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/key-event) for more detail.

[[def: key event log (KEL), KEL, KELs]]
~ A verifiable append-only log of [[ref: key events]] for an [[ref: AID]] that is both backward and forward-chained, as defined by the [[ref: KERI specification]]. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/key-event-log) for more detail.

[[def: KEL backed data]]
~ [[ref: KEL]] backed data in `did:webs` provides the highest level of data security assurance and such data can be found either in the KEL or anchored to an event in the KEL. This means that the signatures on the events in the KEL are strongly bound to the key state at the time the events are entered in the KEL, that is the data. This provides strong guarantees of non-duplicity to any verifiers receiving a presentation as the KELs are protected and can be watched by agents ([[ref: watcher]]) of the verifiers. The information is end-verifiable and any evidence of duplicity in the events is evidence that the data or presentation should not be trusted. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/kel-backed-data) for more detail.

[[def: key event receipt]]
~ A message whose body references a [[ref: key event]] of an [[ref: AID]] and includes one or more signatures on that key event, as defined by the [[ref: KERI specification]]. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/key-event-receipt) for more detail.

[[def: key event receipt log (KERL), KERL]]
~ A verifiable append-only log that includes all the consistent [[ref: key event receipt]] messages, as defined by the [[ref: KERI specification]]. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/key-event-receipt-log) for more detail.

[[def: key event receipt infrastructure (KERI), KERI]]
~ A protocol that provides an identity system-based secure overlay for the internet and uses [[ref: AIDs]] as the primary roots of trust, as defined by the [[ref: KERI specification]]. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/key-event-receipt-infrastructure) for more detail.

[[def: KERI event stream, KERI event streams]]
~ A stream of verifiable KERI data, consisting of the [[ref: key event log]] ([[ref: KEL]]) and other data such as a [[ref: transaction event log]] ([[ref: TEL]]). This data is a [[ref: CESR]] event stream (TODO: link to IANA application/cesr media type) and may be serialized in a file using [[ref: CESR]] encoding. We refer to these CESR stream resources as KERI event streams to simplify the vocabulary. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/keri-event-stream) for more detail. 

[[def: key state, key states]]
~ The set of currently authoritative key pairs (current keys) for an [[ref: AID]] and any other information necessary to secure or establish control authority over the AID. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/key-state) for more detail.

[[def: KERI Request Authentication Mechanism, KRAM]]
~ A non-interactive replay attack protection algorithm that uses a sliding window of date-time stamps and key state (similar to the tuple in [[ref: BADA-RUN]]) but the date-time is the replier’s not the querier’s. **KRAM is meant to protect a host**. See the [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/keri-request-authentication-method) for more detail.

[[def: method-specific identifier, MSI]]
~ The `method-specific-id` part of DID Syntax, as defined in [DID Core](https://www.w3.org/TR/did-core/#did-syntax). See section [Method-Specific Identifier](#method-specific-identifier).

[[def: out-of-band introduction (OOBI), OOBI, OOBIs, OOBI specification]]
~ A protocol for discovering verifiable information on an [[ref: AID]] or a [[ref: SAID]], as defined by the [[ref:  KERI specification]]. The OOBI by itself is insecure, and the information discovered by the OOBI must be verified. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/out-of-band-introduction) for more detail.

[[def: pre-rotation, pre-rotated]]
~ A key rotation mechanism whereby a set of rotation keys are pre-commited using cryptographic digests, as defined by the [[ref: KERI specification]]. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/pre-rotation) for more detail.

[[def: rotation event, rotation events]]
~ A key event that provides the information needed to change the [[ref: key state]] for an [[ref: AID]] using [[ref: pre-rotation]], as defined by the [[ref: KERI specification]]. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/rotation-event) for more detail.

[[def: self-addressing identifier (SAID), SAID, SAIDs]]
~ An identifier that is uniquely and cryptographically bound to a serialization of data (content-addressable) while also being included as a component in that serialization (self-referential), as defined by the [[ref:  CESR specification]]. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/self-addressing-identifier) for more detail.

[[def: transaction event log (TEL), TEL, TELs]]
~ A verifiable append-only log of transaction data that are cryptographically anchored to a [[ref: KEL]]. The transaction events of a TEL may be used to establish the issuance or revocation state of [[ref: ACDCs]]. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/transaction-event-log) for more detail.

[[def: verifier, verifiers]]
~ An entity or component that cryptographically verifies the signature(s) on an event message. See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/verifier) for more detail.

[[def: watcher, watchers]]
~ An entity that keeps a copy of a [[ref: KERL]] of an [[ref: AID]] to detect duplicity of [[ref: key events]], as defined by the [KERI whitepaper](https://github.com/SmithSamuelM/Papers/blob/master/whitepapers/KERI_WP_2.x.web.pdf). See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/watcher) for more detail.

[[def: witness, witnesses]]
~ An entity that is designated by the [[ref: controller]] of an [[ref: AID]] to verify, sign, and keep the key events associated with the AID, as defined by the [KERI whitepaper](https://github.com/SmithSamuelM/Papers/blob/master/whitepapers/KERI_WP_2.x.web.pdf). See [WebOfTrust glossary](https://weboftrust.github.io/WOT-terms/docs/glossary/witness) for more detail.
## Terminology

[[def: authentic chained data container (ACDC), ACDC]]
~ a variant of [the Verifiable Credential (VC) specification](https://www.w3.org/TR/vc-data-model/). Some of the major distinguishing features of ACDCs include normative support for chaining, use of composable JSON Schema, multiple serialization formats, support for Ricardian contracts, support for chain-link confidentiality compact formats for resource constrained applications, simple partial disclosure mechanisms and simple selective disclosure mechanisms. ACDCs inherit the security model derived from [[ref: KERI]]. See [ACDC](https://github.com/WebOfTrust/WOT-terms/wiki/authentic-chained-data-container) for more detail.

[[def: autonomic identifier (AID), AID]]
~ A self-managing identifier that is self-certifying (i.e., self-authenticating) and cryptographically bound to a [[ref: key event log]] ([[ref: KEL]]). An AID is either non-transferable or transferable. A non-transferable AID does not support key rotation while a transferable AID support key rotation using a key [[ref: pre-rotation]] mechanism that enables the AID to persist in spite of the evolution of its key state. See [AID](https://github.com/WebOfTrust/WOT-terms/wiki/autonomic-identifier) for more detail.

[[def: compact event streaming representation (CESR), CESR]]
~ A dual text-binary encoding format that has the unique property of text-binary concatenation composability. The composability property enables the round trip conversion en-masse of concatenated primitives between the text domain and binary domain while maintaining the separability of individual primitives. See [CESR](https://github.com/WebOfTrust/WOT-terms/wiki/composable-event-streaming-representation) for more detail.

[[def: controller]]
~ A controlling entity that can cryptographically prove the control authority (signing and rotation) over an [[ref: AID]], as well as make changes on the associated [[ref: KEL]]. A controller may consist of multiple controlling entities in a multi-signature scheme. See [controller](https://github.com/WebOfTrust/WOT-terms/wiki/controller) for more detail.

[[def: DID document]]
~ As defined by [DID Core](https://www.w3.org/TR/did-core/#dfn-did-documents). See section [DID Documents](#did-documents).

[[def: direct mode]]
~ an operational mode of the [[ref: KERI]] protocol where a controller and a verifier of an [[ref: AID]] exchange the [[ref: KEL]] of the AID directly. Upon reception of the KEL, the verifier sends a key event receipt, which includes the verifier's signature, to the controller as an acknowledgment. The signed key event receipt attests that the verifier received and verified the key event message. See [direct mode](https://github.com/WebOfTrust/WOT-terms/wiki/direct-mode) for more detail.

[[def: inception event]]
~ A key establishment event that provides the incepting information needed to derive an [[ref: AID]] and establish its initial [[ref: key state]]. See [inception event](https://github.com/WebOfTrust/WOT-terms/wiki/inception-event) for more detail.

[[def: indirect mode]]
~ An operational mode of the [[ref: KERI]] protocol where the [[ref: KEL]] of an [[ref: AID]] is promulgated to a verifier using witnesses that are disignated by the AID's controller. See [indirect mode](https://github.com/WebOfTrust/WOT-terms/wiki/indirect-mode) for more detail.

[[def: interaction event]]
~ A key non-establishment event that anchors external data to the [[ref: key state]] of an [[ref: AID]] as established by the most recent prior establishment event. See [interaction event](https://github.com/WebOfTrust/WOT-terms/wiki/interaction-event) for more detail.

[[def: key event]]
~ A serialized data structure of an entry in the [[ref: key event log]]([[ref: KEL]]) for an [[ref: AID]]. A key event is either establishment or non-establshment. An establishment event changes the [[ref: key state]] of an AID while a non-establishment event does not. See [key event](https://github.com/WebOfTrust/WOT-terms/wiki/key-event) for more detail.

[[def: key event log, KEL]]
~ A verifiable append-only log of key events for an [[ref: AID]] that is both backward and forward-chained as defined by [KERI](https://github.com/WebOfTrust/WOT-terms/wiki/key-event-log). See [KEL](https://github.com/WebOfTrust/WOT-terms/wiki/key-event-log) for more detail.

[[def: key event receipt]]
~ A message whose body references a [[ref: key event]] of an [[ref: AID]] and includes one or more signatures on that key event. See [key event receipt](https://github.com/WebOfTrust/WOT-terms/wiki/key-event-receipt) for more detail.

[[def: key event receipt log (KERL), KERL]]
~ A verifiable append-only log that includes all the consistent [[ref: key event receipt]] messages created by [[ref: witness]]es. See [KERL](https://github.com/WebOfTrust/WOT-terms/wiki/key-event-receipt-log) for more detail.

[[def: key event receipt infrastructure (KERI), KERI]]
~ A protocol that provides an identity system-based secure overlay for the internet. The KERI protocol includes a primary root-of- trust in self-certifying identifiers (SCIDs), called [[ref: autonomic identifier]]s ([[ref: AID]]s), that are strongly bound to an append-only chained [[ref: key event log]] ([[ref: KEL]]) of signed transfer statements provides end verifiable control provenance. See [KERI](https://github.com/WebOfTrust/WOT-terms/wiki/key-event-receipt-infrastructure) for more detail.

[[def: KERI event stream, KERI event streams]]
~ A stream of verifiable KERI data, consisting of the [[ref: key event log]] ([[ref: KEL]]) and other data such as a [[ref: transaction event log]] ([[ref: TEL]]). This data is a [[ref: CESR]] event stream (TODO: link to IANA application/cesr media type) and may be serialized in a file using [[ref: CESR]] encoding. We refer to these CESR stream resources as KERI event streams to simplify the vocabulary. See [KERI event stream](https://github.com/WebOfTrust/WOT-terms/wiki/keri-event-stream) for more detail. 

[[def: key state]]
~ The set of currently authoritative keypairs (current keys) for an [[ref: AID]] and any other information necessary to secure or establish control authority over the AID. See [key state](https://github.com/WebOfTrust/WOT-terms/wiki/key-state) for more detail.

[[def: method-specific identifier, MSI]]
~ The `method-specific-id` part of DID Syntax, as defined in [DID Core](https://www.w3.org/TR/did-core/#did-syntax). See section [Method-Specific Identifier](#method-specific-identifier).

[[def: out-of-band introduction (OOBI), OOBI, OOBI specification]]
~ A protocol for discovering verifiable information on an [[ref: AID]] or a [[ref: SAID]]. The OOBI by itself is insecure, and the information discovered by the OOBI must be verified. See [OOBI](https://github.com/WebOfTrust/WOT-terms/wiki/out-of-band-introduction) for more detail.

[[def: pre-rotation, pre-rotated]]
~ A key rotation mechanism whereby a set of rotation keys are pre-commited using cryptographic digests. The pre-rotation mechanism enables an entity to persistently maintain or regain control over an [[ref: AID]] in spite of the exposure-related weakening over time or even compromise of the current set of controlling (signing) keypairs. See [pre-rotation](https://github.com/WebOfTrust/WOT-terms/wiki/pre-rotation) for more detail.

[[def: rotation event]]
~ A key establishment event that provides the information needed to change the [[ref: key state]] which includes a change to the set of authoritative key pairs for an [[ref: AID]]. See [rotation event](https://github.com/WebOfTrust/WOT-terms/wiki/rotation-event) for more detail.

[[def: self-addressing identifier (SAID), SAID]]
~ An identifier that is content-addressable and self-referential. A SAID is uniquely and cryptographically bound to a serialization of data that includes the SAID as a component (or field) in that serialization. See [SAID](https://github.com/WebOfTrust/WOT-terms/wiki/self-addressing-identifier) for more detail.

[[def: transaction event log (TEL), TEL]]
~ A verifiable append-only log of transaction data that are anchored to a [[ref: KEL]]. The transaction events of a TEL may be used to establish the issuance or revocation state of [[ref: ACDC]]s that are issued by the controller of an [[ref: AID]]. See [TEL](https://github.com/WebOfTrust/WOT-terms/wiki/transaction-event-log) for more detail.

[[def: watcher]]
~ An entity that keeps a copy of a [[ref: KERL]] of an [[ref: AID]]. A set of watchers may be used as a supporting infrastructure for validating the AID and transactions that are anchored to its [[ref: KEL]]. Unlike witnesses, watchers are not designated by the [[ref: controller]] of the AID. See [watcher](https://github.com/WebOfTrust/WOT-terms/wiki/watcher) for more detail.

[[def: witness]]
~ An entity that is designated by the [[ref: controller]] of an [[ref: AID]]. The primary role of a witness is to verify, sign, and keep the key events associated with the AID. Designation of witnesses is included in key establishment events. When designated, witnesses become part of the supporting infrastructure for maintaining and verifying the AID. See [witness](https://github.com/WebOfTrust/WOT-terms/wiki/witness) for more detail.
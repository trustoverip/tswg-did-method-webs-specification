## Terminology

::: todo
:::

[[def: method-specific identifier, MSI]]
~ The `method-specific-id` part of DID Syntax, as defined in [DID Core](https://www.w3.org/TR/did-core/#did-syntax). See section [Method-Specific Identifier](#method-specific-identifier).

[[def: DID document]]
~ As defined by [DID Core](https://www.w3.org/TR/did-core/#dfn-did-documents). See section [DID Documents](#did-documents).

[[def: Key Event Log, KEL]]
~ A key event log is KERI's verifiable data structure and the proof of key state of its identifier. These logs are blockchains in a narrow definition, but not in the sense of ordering (they are not ordered) or global consensus mechanisms (which is not needed).  
Distilled from the definition in [KERI](https://github.com/WebOfTrust/WOT-terms/wiki/key-event-log) glossary.

[[def: Transaction Event Log, TEL]]
~ An externally anchored transactions log via cryptographic commitments in a [[ref: KEL]]. The TEL provides a cryptographic proof of registry state by reference to the corresponding controlling KEL.  
Distilled from the [KERI](https://github.com/WebOfTrust/WOT-terms/wiki/transaction-event-log) definition.

[[def: KERI event stream, KERI event streams]]
~ A stream of verifiable KERI data, consisting of the [[ref: key event log]] ([[ref: KEL]]) and other data such as a [[ref: transaction event log]] ([[ref: TEL]]). This data is a [[ref: CESR]] event stream (TODO: link to IANA application/cesr media type) and may be serialized in a file using [[ref: CESR]] encoding. We refer to these CESR stream resources as KERI event streams to simplify the vocabulary.  
Definition also included in [KERI](https://github.com/WebOfTrust/WOT-terms/wiki/keri-event-stream) glossary.

[[def: Pre-rotation, pre-rotated]]
~ Cryptographic commitment to next rotated key set in previous rotation or inception event.  
Elaborated on in [KERI](https://github.com/WebOfTrust/WOT-terms/wiki/pre-rotation) glossary.

[[def: Authentic chained data container, ACDC, ACDCs]]
~ An ACDC proves digital data consistency and authenticity in one go. An ACDC cryptographically secures commitment to data contained, and its identifiers are self-addressing, which means they point to themselves and are also contained ìn the data.  
Distilled from [KERI](https://github.com/WebOfTrust/WOT-terms/wiki/authentic-chained-data-container) glossary.

[[def: Out-of-band introduction, OOBI, OOBI specification]]
~ Out-of-band Introductions are discovery and validation of IP resources for KERI's autonomic identifiers. Discovery via URI, trust via KERI.  
As further defined in [KERI](https://github.com/WebOfTrust/WOT-terms/wiki/out-of-band-introduction) glossary.

[[def: Direct mode]]
~ In the direct (one-to-one) mode, the identity controller establishes control via verified signatures of the controlling key-pair. The direct mode doesn't use witnesses nor KERLs but has direct (albeit intermittent) network contact with the validator.
Elaborated on in [KERI](https://github.com/WebOfTrust/WOT-terms/wiki/direct-mode) glossary.

[[def: Indirect mode]]
~ The indirect mode extends a KERI [[ref: direct mode]] trust basis with witnessed key event receipt logs (KERL) for validating events. The security and accountability guarantees of indirect mode are provided by KA2CE or KERI’s Agreement Algorithm for Control Establishment among a set of witnesses.
Elaborated on in [KERI](https://github.com/WebOfTrust/WOT-terms/wiki/indirect-mode) glossary.


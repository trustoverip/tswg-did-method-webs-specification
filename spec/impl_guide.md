## Implementors Guide
This section is informative.

### Key Agreement
[[def: key agreement]]
~ This section is informative:
There are multiple ways to establish key agreement in KERI. We detail common considerations and techniques:
* If the 'k' field references a Ed25519 key, then key agreement may be established using the corresponding x25519 key for Diffie-Helman key exchange.
* If the key is an ECDSA or other NIST algorithms key then it will be the same key for signatures and encryption and can be used for key agreement.

* *BADA-RUN for key agreement:* Normally in KERI we would use [[ref: BADA-RUN]], similar to how we specify endpoints, [[ref: host]] migration info, etc. This would allow the controller to specify any Key Agreement key, without unnecessarily adding KERI events to their [[ref: KEL]].
* *Key agreement from `k` field keys:* It is important to note that KERI is cryptographically agile and can support a variety of keys and signatures.
* *Key agreement anchored in KEL:* It is always possible to anchor arbitrary data, like a key agreement key, to the KEL.
  * Likely the best mechanism is to anchor an [[ref: ACDC]] to a [[ref: TEL]] which is anchored to the KEL.

### Other Key Commitments
[[def: Other Key Commitments]]
~ This section is informative.
Data structures similar to Location Scheme and Endpoint Authorizations and managed in KERI using [[ref: BADA-RUN]] may be created and used for declaring other types of keys, for example encryption keys, etc

To support new data structures, propose them in KERI and detail the transformation in the spec.
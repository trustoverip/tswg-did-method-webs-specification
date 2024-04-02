## Implementors Guide
These sections are informative.

### Key Agreement
[[def: key agreement]]
~ This section is informative:
There are multiple ways to establish key agreement in KERI. We detail common considerations and techniques:
* If the 'k' field references a Ed25519 key, then key agreement may be established using the corresponding x25519 key for Diffie-Helman key exchange.
* If the key is an ECDSA or other NIST algorithms key then it will be the same key for signatures and encryption and can be used for key agreement.

* *BADA-RUN for key agreement:* Normally in KERI we would use [[ref: BADA-RUN]], similar to how we specify endpoints, [[ref: host]] migration info, etc. This would allow the controller to specify any Key Agreement key, without unnecessarily adding KERI events to their [[ref: KEL]].
* *Key agreement from `k` field keys:* It is important to note that KERI is cryptographically agile and can support a variety of keys and signatures.
* *Key agreement anchored in KEL:* It is always possible to anchor arbitrary data, like a key agreement key, to the KEL.
  * The best mechanism is to anchor an [[ref: ACDC]] to a [[ref: TEL]] which is anchored to the KEL. The data would be the basis of the key agreement information. The concept is similar to how we anchor [[ref: designated aliases]] as [[ref: verifiable data on a TEL]].

### Other Key Commitments
[[def: Other Key Commitments]]
~ This section is informative.
Data structures similar to Location Scheme and Endpoint Authorizations and managed in KERI using [[ref: BADA-RUN]] may be created and used for declaring other types of keys, for example encryption keys, etc

To support new data structures, propose them in KERI and detail the transformation in the spec.

### On-Disk Storage
[[def: On-Disk Storage]]
~ This section is informative.
Both KEL backed data and [[ref: BADA-RUN]] security approaches are suitable for storing information on disk because both provide a link between the keystate and date-time on some data when a signature by the source of the data was created. [[ref: BADA-RUN]] is too weak for important information because an attacker who has access to the database on disk can overwrite data on disk without being detected by a verifier hosting the on-disk data either through a replay of stale data (data regression attack) or if in addition to disk access the attacker has compromised a given key state, then the attacker can forge new data with a new date-time stamp for a given compromised key and do a regression attack so that the last seen key state is the compromised key state.

With BADA, protection from a deletion (regression) attack requires redundant disk storage. At any point in time where there is a suspicion of loss of custody of the disk, a comparison to the redundant disks is made and if any disk has a later event given [[ref: BADA-RUN]] rules then recovery from the deletion attack is possible.

[[ref: KRAM]] on a query is not usable for on disk storage by itself. Because it's just a bare signature (the datetime is not of the querier but of the host at the time of a query). However, the reply to a query can be stored on disk if the querier applies BADA to the reply. To elaborate, Data obtained via a KRAMed query-reply may be protected on-disk by being using BADA on the reply. This is how KERI stores service endpoints. However, KERI currently only uses BADA for discovery data not more important data. More important data should be wrapped (containerized) in an [[ref: ACDC]] that is [[ref: KEL]] backed and then stored on-disk

In the hierarchy of attack surfaces, exposure as on disk (unencrypted) is the weakest. Much stronger is exposure that is only in-memory. To attack in-memory usually means compromising the code supply chain which is harder than merely gaining disk access. Encrypting data on disk does not necessarily solve attacks that require a key compromise (because decryption keys can be compromised), and it does not prevent a deletion attack. Encryption does not provide authentication protection. However, encryption does protect the confidentiality of data.

The use of DH key exchange as a weak form of authentication is no more secure than an HMAC for authentication. It is sharing secrets, so anyone with the secret can impersonate any other member of the group that has the shared secret.

Often, DID methods have focused on features that erode security characteristics. The paper [Five DID Attacks](https://github.com/WebOfTrustInfo/rwot11-the-hague/blob/master/final-documents/taking-out-the-crud-five-fabulous-did-attacks.pdf) highlights some attacks to which `did:webs` should NOT be vulnerable. So when a pull request exposes `did:webs` to a known attack, it should not be accepted.

### Alignment of Information to Security Posture
[[def: Alignment of Information to Security Posture]]
~ This section is informative.
As a general security principle each block of information should have the same security posture for all the sub-blocks. One should not attempt to secure a block of information that mixes security postures across is constituent sub-blocks. The reason is that the security of the block can be no stronger than the weakest security posture of any sub-block in the block. Mixing security postures forces all to have the lowest common denominator security. The only exception to this rule is if the block of information is purely informational for discovery purposes and where it is expected that each constituent sub-block is meant to be verified independently.

This means that any recipient of such a block information with mixed security postures across its constituent sub-blocks must explode the block into sub-blocks and then independently verify the security of each sub-block. However, this is only possible if the authentication factors for each sub-block are provided independently. Usually when information is provided in a block of sub-blocks, only one set of authentication factors are provided for the block as a whole and therefore there is no way to independently verify each sub-block of information.

Unfortunately, what happens in practice is that users are led into a false sense of security because they assume that they don’t have to explode and re-verify, but merely may accept the lowest common denominator verification on the whole block of information. This creates a pernicious problem for downstream use of the data. A downstream use of a constituent sub-block doesn’t know that it was not independently verified to its higher level of security. This widens the attack surface to any point of down-stream usage. This is a root cause of the most prevalent type of attack called a BOLA.

### Applying the concepts of KEL, BADA-RUN, and KRAM to `did:webs`
[[def: Applying the concepts of KEL, BADA-RUN, and KRAM]]
~ This section is informative.
Lets explore the implications of applying these concepts to various `did:webs` elements.
Using [[ref: KEL]] backed elements in a DID doc simplifies the security concerns. However, future discovery features related to endpoints might consider BADA-RUN. For instance, 'whois' data could be used with [[ref: BADA-RUN]] whereas did:web aliases should not because it could lead to an impersonation attack. We could have a DID document that uses [[ref: BADA-RUN]] if we modify the DID CRUD semantics to be RUN semantics without necessarily changing the verbs but by changing the semantics of the verbs. Then any data that fits the security policy of BADA (i.e. where BADA is secure enough) can be stored in a DID document as a database in the sky. For sure this includes service endpoints for discovery. One can sign with [[ref: CESR]] or JWS signatures. The payloads are essentially KERI reply messages in terms of the fields (with modifications as needed to be more palatable), but are semantically the same. The DID doc just relays those replies. Anyone reading from the DID document is essentially getting a KERI reply message, and they then should apply the BADA rules to their local copy of the reply message.

To elaborate, these security concepts point us to modify the DID CRUD semantics to replicate RUN semantics. _Create_ becomes synonymous with _Update_ where Update uses the RUN update. _Delete_ is modified to use the Nullify semantics. _Read_ data is modified so that any recipient of the Read response can apply BADA to its data (Read is a GET). So we map the CRUD of DID docs to RUN for the `did:webs` method. Now you have reasonable security for things like signed data. If its [[ref: KEL]] backed data you could even use an [[ref: ACDC]] as a data attestation for that data and the did resolver would become a caching store for [[ref: ACDCs]] issued by the AID controller.

Architecturally, a Read (GET) from the did resolver acts like how KERI reply messages are handled for resolving service endpoint discovery from an [[ref: OOBI]]. The query is the read in RUN and so uses KRAM. The reply is the response to the READ request. The controller of the AID updates the DID resolvers cache with updates(unsolicited reply messages). A trustworthy DID resolver applies the BADA rules to any updates it receives. Optionally the DID resolver may apply [[ref: KRAM]] rules to any READ requests to protect it from replay attacks.

In addition, a DID doc can be a discovery mechanism for an [[ref: ACDC]] caching server by including an index (label: said) of the [[ref: SAIDs]] of the [[ref: ACDCs]] held in the resolvers cache.

### The set of KERI features needed
[[def: The set of KERI features needed]]
~ This section is informative.
The set of KERI features needed for most `did:webs` use cases is modest, with limited dependencies. These basics are summarized in the [KERI Fundamentals](#keri-fundamentals) section of this specification. This specification assumes a working knowledge of the concepts there. The inclusion of KERI in `did:webs` enables a number of capabilities for securing a `did:webs` identifier, including multi-signature support and the creation of [[ref: pre-rotated]] keys to prevent loss of control of the identifier if the current private key were to be compromised.
You may find the [did:webs feature dependency diagram](https://github.com/trustoverip/tswg-did-method-webs-specification/blob/main/WEBS_FEATURE_DEPS.md) helpful as a visual guide to the features and dependencies of `did:webs`.

### Stable identifiers on an unstable web
[[def: Stable identifiers on an unstable web]]
~ This section is informative.
The web is not a very stable place, and documents are moved around and copied frequently. When two or more companies merge, often the web presence of some of the merged entities "disappears". It may not be possible to retain a permanent `did:webs` web location.
The purpose of the history of [[ref: designated aliases]] for the AID is so that if the `did:webs` DID has been put in long-lasting documents, and its URL instantiation is redirected or disappears, the controller can explicitly indicate that the new DID is an `equivalentId` to the old one.

Since the AID is globally unique and references the same identifier, regardless of the rest of the string that is the full `did:webs`, web searching could yield either the current location of the DID document, or a copy of the DID that may be useful. For example, even the [Internet Archive: Wayback Machine](https://archive.org/web) could be used to find a copy of the DID document and the [[ref: KERI event stream]] at some point in the past that may be sufficient for the purposes of the entity trying to resolve the DID. This specification does not rely on the Wayback Machine, but it might be a useful `did:webs` discovery tool.

The DID document, [[ref: KERI event stream]] and other files related to a DID may be copied to other web locations. For example, someone might want to keep a cache of DIDs they use, or an entity might want to run a registry of "useful" DIDs for a cooperating group. While the combination of DID document and [[ref: KERI event stream]] make the DID and DID document verifiable, just as when published in their "intended" location, the absence of the `did:webs` in the [[ref: designated aliases]] for those locations in the DID document `equivalentId` means that the controller of the DID is not self-asserting any sort of tie between the DID and the location to which the DID-related documents have been copied. In contrast, if the controller confirms the link between the source and the copy with an `equivalentId`, the related copies will have to be kept in sync.

Were the AID of a `did:webs` identifier to change, it would be an altogether new DID, unconnected to the first DID.
A `did:webs` could be moved to use another DID method that uses the AID for uniqueness and the [[ref: KERI event stream]] for validity, but that is beyond the scope of this specification.

### KERI event stream chain of custody
[[def: KERI event stream chain of custody]]
~ This section is informative.
The [[ref: KERI event stream]] represents a cryptographic chain of trust originating from the [[ref: AID]] of the controller to the current operational set of keys (signing and otherwise) as well as the cryptographic commitments to the keys the controller will rotate to in the future. The [[ref: KERI event stream]] also contains events that do not alter the [[ref: AID]] key state, but are useful metadata for the DID document such as, the supported [[ref: hosts]], the current set of service endpoints, etc. A did:webs resolver produces the DID document by processing the [[ref: KERI event stream]] to determine the current key state. We detail the different events in "Basic KERI event details" and show how they change the DID Document. The mapping from the [[ref: KERI event stream]] to the DID Document properties compose the core of the did:webs resolver logic.  Understanding the optimal way to update and maintain the [[ref: KERI event stream]] (publish static keri.cesr files, dynamically generate the keri.cesr resource, etc) is beyond the scope of the spec, but the [[ref: did:webs Reference Implementation]] of the resolver demonstrate some of these techniques. The important concept is that the entire [[ref: KERI event stream]] is used to produce and verify the DID document.

### Verifiable data on a TEL
[[def: verifiable data on a TEL]]
~ This section is informative.
Below is an example highlighting how verifiable data is anchored to a [[ref: KEL]] using a [[ref: TEL]]. We use this spec's [[ref: designated aliases]] feature as a real-world example. You can walk through this example in the [[ref: did:webs Reference Implementation]].
The attestation (self-issued credential) is as follows:
```json
{
    "v": "ACDC10JSON0005f2_",
    "d": "EIGWggWL2IHiUzj1P2YuPA0-Uh55LTIu14KTvVQGrfvT",
    "i": "ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "ri": "EAtQJEQMkkvlWxyfLbcLyv4kNeAI5Qsqe65vKIWnHKpx",
    "s": "EN6Oh5XSD5_q2Hgu-aqpdfbVepdpYpFlgz6zvJL5b_r5",
    "a": {
        "d": "EJJjtYa6D4LWe_fqtm1p78wz-8jNAzNX6aPDkrQcz27Q",
        "dt": "2023-11-13T17:41:37.710691+00:00",
        "ids": [
            "did:web:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:webs:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:web:example.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:web:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:webs:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe"
        ]
    },
    "r": {
        "d": "EEVTx0jLLZDQq8a5bXrXgVP0JDP7j8iDym9Avfo8luLw",
        "aliasDesignation": {
            "l": "The issuer of this ACDC designates the identifiers in the ids field as the only allowed namespaced aliases of the issuer's AID."
        },
        "usageDisclaimer": {
            "l": "This attestation only asserts designated aliases of the controller of the AID, that the AID controlled namespaced alias has been designated by the controller. It does not assert that the controller of this AID has control over the infrastructure or anything else related to the namespace other than the included AID."
        },
        "issuanceDisclaimer": {
            "l": "All information in a valid and non-revoked alias designation assertion is accurate as of the date specified."
        },
        "termsOfUse": {
            "l": "Designated aliases of the AID must only be used in a manner consistent with the expressed intent of the AID controller."
        }
    }
}
```

Now we show that the information is anchored to the KEL in a way that allows for changes in key state while not invalidating it.  We will:
* chain an interaction event on the KEL, to a registry we call a TEL
* The TEL maintains the 'state' of issued or revoked for the attestation. If the controller wants to update the list they would revoke the attestation and issue a new attestation with the updated list of aliases that they want to designate.
* The TEL must chain to the attestation itself.
This is what forms the end-to-end verifiablity all the way from the attestation to the AID itself. Here is the [[ref: KERI Event Stream]] of each part:
#### The interaction event on the KEL
This interaction event connects the TEL registry to the KEL. Notice the `a` field with the nested `i` field that references the registry
```json
    "v": "KERI10JSON00013a_",
    "t": "ixn",
    "d": "ED-4iQIVxwMcrTOW6fVs9oPpLTIxtqh_vcvLmE999zsU",
    "i": "ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "s": "1",
    "p": "ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "a": [
        {
            "i": "EAtQJEQMkkvlWxyfLbcLyv4kNeAI5Qsqe65vKIWnHKpx",
            "s": "0",
            "d": "EAtQJEQMkkvlWxyfLbcLyv4kNeAI5Qsqe65vKIWnHKpx"
        }
    ]
```
#### The TEL registry
This TEL registry connects the KEL interaciton event to the registry status. Notice the `d` field matches the nested `i` field of the `a` field of the interaction event making them cryptographically chained together.
```json
    "v": "KERI10JSON000113_",
    "t": "vcp",
    "d": "EAtQJEQMkkvlWxyfLbcLyv4kNeAI5Qsqe65vKIWnHKpx",
    "i": "EAtQJEQMkkvlWxyfLbcLyv4kNeAI5Qsqe65vKIWnHKpx",
    "ii": "ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "s": "0",
    "c": [
        "NB"
    ],
    "bt": "0",
    "b": [],
    "n": "AAfqHwMDdBoIWk_4Z6hvVJuhtvjA_gk8Y9bEUoP_rC_p"
  ```
#### The attestation status
The current status of the attestation is in the `t` field. `iss` means issued. Notice the `ri` field cryptographically binds this issued status to the registry above. Notice the `i` field cryptographically binds to the attestation `d` field.
```json
    "v": "KERI10JSON0000ed_",
    "t": "iss",
    "d": "EJQvCZQYn8oO1z3_f8qhxXjk7TcLol4G3RdHVTwfGV3L",
    "i": "EIGWggWL2IHiUzj1P2YuPA0-Uh55LTIu14KTvVQGrfvT",
    "s": "0",
    "ri": "EAtQJEQMkkvlWxyfLbcLyv4kNeAI5Qsqe65vKIWnHKpx",
    "dt": "2023-11-13T17:41:37.710691+00:00"
```
#### The full KERI Event Stream
This is the above sections as they trully are in the keri.cesr file. Notice the CESR verifiable signatures between events.
```json
{
    "v": "KERI10JSON00012b_",
    "t": "icp",
    "d": "ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "i": "ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "s": "0",
    "kt": "1",
    "k": [
        "DHr0-I-mMN7h6cLMOTRJkkfPuMd0vgQPrOk4Y3edaHjr"
    ],
    "nt": "1",
    "n": [
        "ELa775aLyane1vdiJEuexP8zrueiIoG995pZPGJiBzGX"
    ],
    "bt": "0",
    "b": [],
    "c": [],
    "a": []
}-VAn-AABAADjfOjbPu9OWce59OQIc-y3Su4kvfC2BAd_e_NLHbXcOK8-3s6do5vBfrxQ1kDyvFGCPMcSl620dLMZ4QDYlvME-EAB0AAAAAAAAAAAAAAAAAAAAAAA1AAG2024-04-01T17c40c48d329209p00c00{
    "v": "KERI10JSON00013a_",
    "t": "ixn",
    "d": "ED-4iQIVxwMcrTOW6fVs9oPpLTIxtqh_vcvLmE999zsU",
    "i": "ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "s": "1",
    "p": "ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "a": [
        {
            "i": "EAtQJEQMkkvlWxyfLbcLyv4kNeAI5Qsqe65vKIWnHKpx",
            "s": "0",
            "d": "EAtQJEQMkkvlWxyfLbcLyv4kNeAI5Qsqe65vKIWnHKpx"
        }
    ]
}-VAn-AABAACNra5mDg7YHFtBeXiwIGqnHkyq7F55FGNYG1wH95akjSWCb1HzNI3E05ufT0HffClDxnJF_DmAUW2SBb0EJeoO-EAB0AAAAAAAAAAAAAAAAAAAAAAB1AAG2024-04-01T17c42c37d704426p00c00{
    "v": "KERI10JSON00013a_",
    "t": "ixn",
    "d": "EBjw0a_L8M0F4xYND99dvahlrkpxODi9Wc9VzUvkhD0t",
    "i": "ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "s": "2",
    "p": "ED-4iQIVxwMcrTOW6fVs9oPpLTIxtqh_vcvLmE999zsU",
    "a": [
        {
            "i": "EIGWggWL2IHiUzj1P2YuPA0-Uh55LTIu14KTvVQGrfvT",
            "s": "0",
            "d": "EJQvCZQYn8oO1z3_f8qhxXjk7TcLol4G3RdHVTwfGV3L"
        }
    ]
}-VAn-AABAABo_okwAmWIYWI93EtUONZiEvsGuSRkKnj0mopX_RoXwWHZ_1V5hQ0BxcntsmAi21DbusyCmK-fHwTNtSxUSsoN-EAB0AAAAAAAAAAAAAAAAAAAAAAC1AAG2024-04-01T17c42c39d995867p00c00{
    "v": "KERI10JSON000113_",
    "t": "vcp",
    "d": "EAtQJEQMkkvlWxyfLbcLyv4kNeAI5Qsqe65vKIWnHKpx",
    "i": "EAtQJEQMkkvlWxyfLbcLyv4kNeAI5Qsqe65vKIWnHKpx",
    "ii": "ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "s": "0",
    "c": [
        "NB"
    ],
    "bt": "0",
    "b": [],
    "n": "AAfqHwMDdBoIWk_4Z6hvVJuhtvjA_gk8Y9bEUoP_rC_p"
}-VAS-GAB0AAAAAAAAAAAAAAAAAAAAAABED-4iQIVxwMcrTOW6fVs9oPpLTIxtqh_vcvLmE999zsU{
    "v": "KERI10JSON0000ed_",
    "t": "iss",
    "d": "EJQvCZQYn8oO1z3_f8qhxXjk7TcLol4G3RdHVTwfGV3L",
    "i": "EIGWggWL2IHiUzj1P2YuPA0-Uh55LTIu14KTvVQGrfvT",
    "s": "0",
    "ri": "EAtQJEQMkkvlWxyfLbcLyv4kNeAI5Qsqe65vKIWnHKpx",
    "dt": "2023-11-13T17:41:37.710691+00:00"
}-VAS-GAB0AAAAAAAAAAAAAAAAAAAAAACEBjw0a_L8M0F4xYND99dvahlrkpxODi9Wc9VzUvkhD0t{
    "v": "ACDC10JSON0005f2_",
    "d": "EIGWggWL2IHiUzj1P2YuPA0-Uh55LTIu14KTvVQGrfvT",
    "i": "ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "ri": "EAtQJEQMkkvlWxyfLbcLyv4kNeAI5Qsqe65vKIWnHKpx",
    "s": "EN6Oh5XSD5_q2Hgu-aqpdfbVepdpYpFlgz6zvJL5b_r5",
    "a": {
        "d": "EJJjtYa6D4LWe_fqtm1p78wz-8jNAzNX6aPDkrQcz27Q",
        "dt": "2023-11-13T17:41:37.710691+00:00",
        "ids": [
            "did:web:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:webs:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:web:example.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:web:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:webs:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe"
        ]
    },
    "r": {
        "d": "EEVTx0jLLZDQq8a5bXrXgVP0JDP7j8iDym9Avfo8luLw",
        "aliasDesignation": {
            "l": "The issuer of this ACDC designates the identifiers in the ids field as the only allowed namespaced aliases of the issuer's AID."
        },
        "usageDisclaimer": {
            "l": "This attestation only asserts designated aliases of the controller of the AID, that the AID controlled namespaced alias has been designated by the controller. It does not assert that the controller of this AID has control over the infrastructure or anything else related to the namespace other than the included AID."
        },
        "issuanceDisclaimer": {
            "l": "All information in a valid and non-revoked alias designation assertion is accurate as of the date specified."
        },
        "termsOfUse": {
            "l": "Designated aliases of the AID must only be used in a manner consistent with the expressed intent of the AID controller."
        }
    }
}-VA0-FABENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe0AAAAAAAAAAAAAAAAAAAAAAAENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe-AABAADQOX208DAmZEPb2v0XXF0N6WgxOdOxB3AsCBJds_vbAr7v1PQBA4MWNsXc8unk5UykbB8j538XGkzLtujekvIP
```


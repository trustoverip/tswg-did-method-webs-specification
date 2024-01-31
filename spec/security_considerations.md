## Security Considerations
There are many security considerations related to web requests, storing information securely, etc. It is useful to address these considerations along with the common security threats found on the web. 

### Common security threats

1. All `did:webs` features MUST reduce the attack surface against common threats, such as:
    1. Broken Object Level Authorization (BOLA)
    1. Denial of service (DoS) attack
    1. Deletion attack
    1. Duplicity detection
    1. Eclipse attack
    1. Forgery
    1. Impersonation attack
    1. Key Compromise attack
    1. Malleability attack
    1. Replay attack

### Using HTTPS
Perfect protection from eavesdropping is not possible with HTTPS, for various
reasons.
1. URLs of DID documents and [[ref: KERI event streams]] SHOULD be hosted in a way that embodies accepted cybersecurity best practice. This is not strictly necessary to guarantee the authenticity of the data. However, the usage of HTTPS MUST:
    1. Safeguard privacy
    1. Discourage denial of service
    1. Work in concert with defense-in-depth mindset
    1. Aid regulatory compliance
    1. Allow for high-confidence fetches of the DID document and a [[ref: KERI event stream]]
1. A [[ref: host]] that uses a fully qualified domain name of the [[ref: method-specific identifier]] MUST be secured by a TLS/SSL certificate.
    1. The fully qualified domain name MUST match the common name used in the SSL/TLS certificate.
    1. The common name in the SSL/TLS certificate from the server MUST correspond to the way the server is referenced in the URL. This means that if the URL includes `www.example.com`, the common name in the SSL/TLS certificate must be `www.example.com` as well.
1. Unlike `did:web`, the URL MAY use an IP address instead.
    1. If it does, then the common name in the certificate must be the IP address as well.
1. Essentially, the URL and the certificate MUST NOT identify the server in contradictory ways; subject to that constraint, how the server is identified is flexible.
    1. The server certificate MAY be self-issued
    1. OR it MAY chain back to an unknown certificate authority. However, to ensure reasonable security hygiene, it MUST be valid. This has two meanings, both of which are required:
1. The certificate MUST satisfy whatever requirements are active in the client, such that the client does accept the certificate and use it to build and communicate over the encrypted HTTPS session where a DID document and [[ref: KERI event stream]] are fetched.
1. The certificate MUST pass some common-sense validity tests, even if the client is very permissive:
    1. It MUST have a valid signature
    1. It MUST NOT be expired or revoked or deny-listed
    1. It MUST NOT have any broken links in its chain of trust.
1. If a URL of a DID document or [[ref: KERI event streams]] results in a redirect, each URL MUST satisfy the same security requirements.
`www.example.com` as well.

### International Domain Names

1. As with `did:web`, implementers of this method SHOULD consider how non-ASCII characters manifest in URLs and DIDs.
    1. The [[spec:DID-CORE]] identifier syntax does not allow the direct representation of such characters in method name or method specific identifiers.This prevents a `did:webs` value from embodying a homograph attack.
    1. However, `did:webs` MAY hold data encoded with punycode or percent encoding. This means that IRIs constructed from DID values could contain non-ASCII characters that were not obvious in the DID, surprising a casual human reader.
    1. Caution is RECOMMENDED when treating a `did:webs` as the equivalent of an IRI.
    1. Treating it as the equivalent of a URL, instead, is RECOMMENDED as it preserves the punycode and percent encoding and is therefore safe.

See also:
* [UTS-46](https://unicode.org/reports/tr46/)
* [[spec:rfc5895]]

### Concepts for securing `did:webs` information

The following security concepts are used to secure the data, files, signatures and other information in `did:webs`.
1. All security features and concepts in `did:webs` MUST be use one or more of the following mechanisms:
    1. All data that requires the highest security MUST be [[ref: KEL]] backed. This includes any information that needs to be end-verifiably authentic over time:
        1. All [[ref: ACDCs]] used by a `did:webs` identifier MUST be anchored to a KEL directly.
        1. OR indirectly through a [[ref: TEL]] that itself is anchored to a KEL.
    1. All data that does not need to incur the cost of [[ref: KEL]] backing for secuirty but can benefit from the latest data-state such as a distributed data-base MUST use _Best Available Data - Read, Update, Nullify_ ([[ref: BADA-RUN]]).
        1. BADA-RUN information MUST be ordered in a consistent way, using a combination of:
            1. date-time
            1. key state
        1. Discovery information MAY use [[ref: BADA-RUN]] because the worst-case attack on discovery information is a DDoS attack where nothing gets discovered.
            1. The controller(s) of the AID for a `did:webs` identifier MAY use [[ref: BADA-RUN]] for service end-points as discovery mechanisms.
    1. All data that does not need the security of being [[ref: KEL]] backed nor [[ref: BADA-RUN]] should be served using _KERI Request Authentication Mechanism_ ([[ref: KRAM]]).
        1. For a `did:webs` resolver to be trusted it SHOULD use KRAM to access the service endpoints providing KERI event streams for verification of the DID document.

### On-Disk Storage
This section is non-normative.

Both KEL backed data and [[ref: BADA-RUN]] security approaches are suitable for storing information on disk because both provide a link between the keystate and date-time on some data when a signature by the source of the data was created. [[ref: BADA-RUN]] is too weak for important information because an attacker who has access to the database on disk can overwrite data on disk without being detected by a verifier hosting the on-disk data either through a replay of stale data (data regression attack) or if in addition to disk access the attacker has compromised a given key state, then the attacker can forge new data with a new date-time stamp for a given compromised key and do a regression attack so that the last seen key state is the compromised key state.

With BADA, protection from a deletion (regression) attack requires redundant disk storage. At any point in time where there is a suspicion of loss of custody of the disk, a comparison to the redundant disks is made and if any disk has a later event given [[ref: BADA-RUN]] rules then recovery from the deletion attack is possible.

[[ref: KRAM]] on a query is not usable for on disk storage by itself. Because it's just a bare signature (the datetime is not of the querier but of the host at the time of a query). However, the reply to a query can be stored on disk if the querier applies BADA to the reply. To elaborate, Data obtained via a KRAMed query-reply may be protected on-disk by being using BADA on the reply. This is how KERI stores service endpoints. However, KERI currently only uses BADA for discovery data not more important data. More important data should be wrapped (containerized) in an [[ref: ACDC]] that is [[ref: KEL]] backed and then stored on-disk

In the hierarchy of attack surfaces, exposure as on disk (unencrypted) is the weakest. Much stronger is exposure that is only in-memory. To attack in-memory usually means compromising the code supply chain which is harder than merely gaining disk access. Encrypting data on disk does not necessarily solve attacks that require a key compromise (because decryption keys can be compromised), and it does not prevent a deletion attack. Encryption does not provide authentication protection. However, encryption does protect the confidentiality of data.

The use of DH key exchange as a weak form of authentication is no more secure than an HMAC for authentication. It is sharing secrets, so anyone with the secret can impersonate any other member of the group that has the shared secret.

Often, DID methods have focused on features that erode security characteristics. The paper [Five DID Attacks](https://github.com/WebOfTrustInfo/rwot11-the-hague/blob/master/final-documents/taking-out-the-crud-five-fabulous-did-attacks.pdf) highlights some attacks to which `did:webs` should NOT be vulnerable. So when a pull request exposes `did:webs` to a known attack, it should not be accepted.

### Alignment of Information to Security Posture
This section is non-normative.

As a general security principle each block of information should have the same security posture for all the sub-blocks. One should not attempt to secure a block of information that mixes security postures across is constituent sub-blocks. The reason is that the security of the block can be no stronger than the weakest security posture of any sub-block in the block. Mixing security postures forces all to have the lowest common denominator security. The only exception to this rule is if the block of information is purely informational for discovery purposes and where it is expected that each constituent sub-block is meant to be verified independently.

This means that any recipient of such a block information with mixed security postures across its constituent sub-blocks must explode the block into sub-blocks and then independently verify the security of each sub-block. However, this is only possible if the authentication factors for each sub-block are provided independently. Usually when information is provided in a block of sub-blocks, only one set of authentication factors are provided for the block as a whole and therefore there is no way to independently verify each sub-block of information.

Unfortunately, what happens in practice is that users are led into a false sense of security because they assume that they don’t have to explode and re-verify, but merely may accept the lowest common denominator verification on the whole block of information. This creates a pernicious problem for downstream use of the data. A downstream use of a constituent sub-block doesn’t know that it was not independently verified to its higher level of security. This widens the attack surface to any point of down-stream usage. This is a root cause of the most prevalent type of attack called a BOLA.

#### Applying the concepts
This section is non-normative.

Lets explore the implications of applying these concepts to various `did:webs` elements.

Using [[ref: KEL]] backed elements in a DID doc simplifies the security concerns. However, future discovery features related to endpoints might consider BADA-RUN. For instance, 'whois' data could be used with [[ref: BADA-RUN]] whereas did:web aliases should not because it could lead to an impersonation attack. We could have a DID document that uses [[ref: BADA-RUN]] if we modify the DID CRUD semantics to be RUN semantics without necessarily changing the verbs but by changing the semantics of the verbs. Then any data that fits the security policy of BADA (i.e. where BADA is secure enough) can be stored in a DID document as a database in the sky. For sure this includes service endpoints for discovery. One can sign with [[ref: [[ref: CESR]]]] or JWS signatures. The payloads are essentially KERI reply messages in terms of the fields (with modifications as needed to be more palatable), but are semantically the same. The DID doc just relays those replies. Anyone reading from the DID document is essentially getting a KERI reply message, and they then should apply the BADA rules to their local copy of the reply message.

To elaborate, these security concepts point us to modify the DID CRUD semantics to replicate RUN semantics. _Create_ becomes synonymous with _Update_ where Update uses the RUN update. _Delete_ is modified to use the Nullify semantics. _Read_ data is modified so that any recipient of the Read response can apply BADA to its data (Read is a GET). So we map the CRUD of DID docs to RUN for the `did:webs` method. Now you have reasonable security for things like signed data. If its [[ref: KEL]] backed data you could even use an [[ref: [[ref: ACDC]]]] as a data attestation for that data and the did resolver would become a caching store for [[ref: [[ref: ACDCs]]]] issued by the AID controller.

Architecturally, a Read (GET) from the did resolver acts like how KERI reply messages are handled for resolving service endpoint discovery from an [[ref: OOBI]]. The query is the read in RUN and so uses KRAM. The reply is the response to the READ request. The controller of the AID updates the DID resolvers cache with updates(unsolicited reply messages). A trustworthy DID resolver applies the BADA rules to any updates it receives. Optionally the DID resolver may apply [[ref: KRAM]] rules to any READ requests to protect it from replay attacks.

In addition, a DID doc can be a discovery mechanism for an [[ref: [[ref: ACDC]]]] caching server by including an index (label: said) of the [[ref: [[ref: SAIDs]]]] of the [[ref: [[ref: ACDCs]]]] held in the resolvers cache.

#### Narrowing the attack surface
This section is non-normative.
This section is non-normative.

The above considerations have lead us to focus on [[ref: KEL]] backed DID document blocks and data (whois files, signatures, etc) so that the trusted (local) did:webs resolver is secure. Any future features that could leverage [[ref: BADA-RUN]] and [[ref: KRAM]] should be considered carefully according to the above considerations.

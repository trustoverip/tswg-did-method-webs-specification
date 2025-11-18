## Security Considerations
This section is normative.

There are many security considerations related to web requests, storing information securely, etc. It is useful to address these considerations along with the common security threats found on the web. 

### Common security threats

1. All `did:webs` features MUST reduce the attack surface against common threats:
    1. Broken Object Level Authorization (BOLA) attacks MUST be eliminated or reduced.
    1. Denial of service (DoS) attacks MUST be eliminated or reduced.
    1. Deletion attacks MUST be eliminated or reduced.
    1. Duplicity detection MUST be available and reliable.
    1. Eclipse attacks MUST be eliminated or reduced.
    1. Forgery attacks MUST be eliminated or reduced.
    1. Impersonation attacks MUST be eliminated or reduced.
    1. Key Compromise attacks MUST be eliminated or reduced.
    1. Malleability attacks MUST be eliminated or reduced.
    1. Replay attacks MUST be eliminated or reduced.

### Using HTTPS
Perfect protection from eavesdropping is not possible with HTTPS, for various
reasons.
1. URLs of DID documents and [[ref: KERI event streams]] SHOULD be hosted in a way that embodies accepted cybersecurity best practice. This is not strictly necessary to guarantee the authenticity of the data. However, the usage:
    1. MUST safeguard privacy
    1. MUST discourage denial of service
    1. MUST work in concert with defense-in-depth mindset
    1. MUST aid regulatory compliance
    1. MUST allow for high-confidence fetches of the DID document and a KERI event stream
1. A [[ref: host]] that uses a fully qualified domain name of the [[ref: method-specific identifier]] MUST be secured by a TLS/SSL certificate.
    1. The fully qualified domain name MUST match the common name used in the SSL/TLS certificate.
    1. The common name in the SSL/TLS certificate from the server MUST correspond to the way the server is referenced in the URL. This means that if the URL includes `www.example.com`, the common name in the SSL/TLS certificate must be `www.example.com` as well.
1. Unlike `did:web`, the URL MAY use an IP address instead.
    1. If it does, then the common name in the certificate MUST be the IP address as well.
1. Essentially, the URL and the certificate MUST NOT identify the server in contradictory ways; subject to that constraint, how the server is identified is flexible.
    1. The server certificate MAY be self-issued
    1. OR it MAY chain back to an unknown certificate authority. However, to ensure reasonable security hygiene, it MUST be valid. This has two meanings, both of which are required:
1. The certificate MUST satisfy whatever requirements are active in the client, such that the client does accept the certificate and use it to build and communicate over the encrypted HTTPS session where a DID document and KERI event stream are fetched.
1. The certificate MUST pass some common-sense validity tests, even if the client is very permissive:
    1. It MUST have a valid signature
    1. It MUST NOT be expired or revoked or deny-listed
    1. It MUST NOT have any broken links in its chain of trust.
1. If a URL of a DID document or KERI event streams results in a redirect, each URL MUST satisfy the same security requirements.
`www.example.com` as well.

### International Domain Names

1. As with `did:web`, implementers of `did:webs` SHOULD consider how non-ASCII characters manifest in URLs and DIDs.
    1. `did:webs` MUST follow the [[ref: DID-CORE]] identifier syntax which does not allow the direct representation of such characters in method name or method specific identifiers. This prevents a `did:webs` value from embodying a homograph attack.
    1. However, `did:webs` MAY hold data encoded with punycode or percent encoding. This means that IRIs constructed from DID values could contain non-ASCII characters that were not obvious in the DID, surprising a casual human reader.
    1. Caution is RECOMMENDED when treating a `did:webs` as the equivalent of an IRI.
    1. Treating it as the equivalent of a URL, instead, is RECOMMENDED as it preserves the punycode and percent encoding and is therefore safe.

### Concepts for securing `did:webs` information

The following security concepts are used to secure the data, files, signatures and other information in `did:webs`.
1. All security features and concepts in `did:webs` MUST use one or more of the following mechanisms:
    1. All data that requires the highest security MUST be [[ref: KEL]] backed. This includes any information that needs to be end-verifiably authentic over time:
        1. All [[ref: ACDCs]] used by a `did:webs` identifier MUST be one of the following:
            1. MAY be anchored to a KEL directly.
            1. MAY be anchored indirectly through a [[ref: TEL]] that itself is anchored to a KEL.
    1. All data that does not need to incur the cost of [[ref: KEL]] backing for secuirty but can benefit from the latest data-state such as a distributed data-base MUST use _Best Available Data - Read, Update, Nullify_ ([[ref: BADA-RUN]]).
        1. BADA-RUN information MUST be ordered in a consistent way, using the following:
            1. date-time MUST be used.
            1. key state MUST be used.
        1. Discovery information MAY use BADA-RUN because the worst-case attack on discovery information is a DDoS attack where nothing gets discovered.
            1. The controller(s) of the AID for a `did:webs` identifier MAY use  BADA-RUN for service end-points as discovery mechanisms.
    2. All data that does not need the security of being KEL backed nor BADA-RUN SHOULD be served using _KERI Request Authentication Mechanism_ ([[ref: KRAM]]).
        1. For a `did:webs` resolver to be trusted it SHOULD use KRAM to access the service endpoints providing KERI event streams for verification of the DID document.

#### Reducing the attack surface
This section is informative.

The above considerations have lead us to focus on KEL backed DID document blocks and data (designated alias ACDCs, signatures, etc) so that the trusted (local) did:webs resolver is secure. Any future features that could leverage BADA-RUN and [[ref: KRAM]] should be considered carefully according to the above considerations.

See the implementors guide for more details about KEL backed, BADA-RUN, and KRAM:
* [[ref: On-Disk Storage]]
* [Alignment of Information to Security Posture](#alignment-of-information-to-security-posture)
* [Applying the concepts of KEL, BADA-RUN, and KRAM](#applying-the-concepts-of-kel)

## Signed Files
This section is normative.

`did:webs` signed files combine the semantics of folders of files on web servers, and the [[ref: DID Specification]]'s [[ref: DID URL path]] semantics to enable the controller of the DID to publish documents cryptographically signed using the verification key(s) of the DID. This kind of signed file capability has been implemented in a variety of ways in the past, such as with [hashlinks](https://datatracker.ietf.org/doc/html/draft-sporny-hashlink). The value of including this as part of the `did:webs` DID method is that it ensures consistency in its application, including how the signed files can be verified when using a [[ref: multisig]]-enabled DID, and in the face of rotations of the DID's key(s).

1. In publishing a file, the controller of the DID MAY use the KERI [[ref: TEL]] to record the signing event, prior to publishing the file. In that case, in processing the KERI Audit log, the publication event MUST be found, verified, and ordered relative to key state changes and other signing events.

1. If the file is NOT [[ref: KEL backed data]] or if the controller would like to provide additional signature, the controller MUST do the following:
    1. The controller of the DID MAY place arbitrary files into the folder structure below the root did:webs folder.
    1. The DID URL for the signed file MUST be of the form `<did:webs DID>/<path to file>`.
    1. The HTTPS path to the file MUST be `<HTTPS URL conversion of did:webs identifier>/<path to file>`.
    1. To be a valid `did:webs` signed file, each file MUST have an associated JSON Web Signature file named `<filename>.jws` beside (in the same Web folder as) the file. For example, a file `revocation_registry.bin` MUST have a file `revocation_registry.bin.jws` beside it.
    1. The HTTPS path to the associated JWS file MUST be `<HTTPS URL conversion of did:webs identifier>/<path to file>.jws`.
    1. The JWS web signature MUST apply the following rules:
        1. MUST use the [[ref: JSON Serialization]] form of the JWS. This is necessary to support multi-signatures in the JWS.
        1. MUST have a payload that is the [multiformat multihash] hash of the content of the associated signed file.
        1. MUST be signed with a verification key(s) that is (are) either currently in the DIDDoc of the DID, or found in the [[ref: KEL]] associated with the DID. A verification key found in a valid [[ref: KEL]] represents a key that had been in use previously, but has been rotated away.
        1. MUST be verified such that:
            1. A calculated hash of the file MUST match the hash in the JWS.
            1. The signature(s) in the JWS MUST be valid.
            1. If the DID has (or had at the time of signing) [[ref: multisig]] requirements, those requirements MUST be met.

See:
* [[ref: JSON Serialization]]
* [[ref: multiformat multihash]]

The following is informative.
Examples:
* DID URL: `did:webs:w3c-ccg.github.io:12124313423525/members-list.txt`
  * HTTPS URL: `https://w3c-ccg.github.io/12124313423525/members-list.txt`
  * HTTPS JWS URL: `https://w3c-ccg.github.io/12124313423525/members-list.txt.jws`
* DID URL: `did:webs:mines.gov.bc.ca:VCissuer:12124313423525/mines-permit/v1.0/schema.json`
  * HTTPS URL: `https://mines.gov.bc.ca/VCissuer/12124313423525/mines-permit/v1.0/schema.json`
  * HTTPS JWS URL: `https://mines.gov.bc.ca/VCissuer/12124313423525/mines-permit/v1.0/schema.json.jws`

The core use case for this feature is providing an easy way for a DID controller to publish files such that those receiving the file can be confident that the file was explicitly published by the DID controller (they signed it), and has not been tampered with since it was published. A few examples of where this might be useful in verifiable credential-related use cases include:
* Revocation registries such as [[ref: StatusList2021]] published by the issuer (and revoker) of a set of revocable credentials.
* [Hyperledger AnonCreds] objects such as those published by an Issuer when [setting up to publish AnonCreds verifiable credential]
* JSON-LD context files.
* Verifiable Credential rendering data files and images published by verifiable credential issuers, such as those proposed in the [W3C VC Rendering Methods specification] and used in the [Overlay Capture Architecture (OCA) for Aries] specification.

See:
* [[ref: StatusList2021]]
* [[ref: Hyperledger AnonCreds]]
* [[ref: W3C VC Rendering Methods specification]]
* [[ref: Overlay Capture Architecture]] (OCA) for Aries
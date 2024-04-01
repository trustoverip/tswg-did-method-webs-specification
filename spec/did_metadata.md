## DID Metadata
This section is normative.

This section describes the support of the `did:webs` method for metadata, including [[ref: DID resolution metadata]] and [[ref: DID document metadata]]. This metadata is returned by a DID Resolver in addition to the DID document. Also see the [DID Resolution](https://w3c-ccg.github.io/did-resolution/) specification for further details.

### DID Resolution Metadata

At the moment, this specification does not define the use of any specific [[ref: DID resolution metadata]] properties in the `did:webs` method, but may in the future include various metadata, such as which KERI Watchers were used during the resolution process.

### DID Document Metadata

This section of the specification defines how various DID document metadata properties are used by the `did:webs` method.

#### Use of `versionId`

The `versionId` DID document metadata property indicates the current version of the DID document that has been resolved.

1. The `did:webs` versionId MUST be the sequence number (i.e. the `s` field) of the last event in the [[ref: KERI event stream]] that was used to construct the DID document according to the rules in section [DID Document from KERI Events](#did-document-from-keri-events).
1. If the DID parameter `versionId` (see section [Support for `versionId`](#support-for-versionid)) was used when resolving the `did:webs` DID, and if the DID Resolution process was successful, then this corresponding DID document metadata property MUST be guaranteed to be equal to the value of the DID parameter.

Example:

```json
{
  "didDocument": {
    "id": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
    // ... other properties
  },
  "didResolutionMetadata": {
  },
  "didDocumentMetadata": {
    "versionId": "2"
  }
}
```

#### Use of `nextVersionId`

The `nextVersionId` DID document metadata property indicates the next version of the DID document after the version that has been resolved.

1. The `did:webs` `nextVersionId` MUST be the sequence number (i.e. the `s` field) of the next event in the [[ref: KERI event stream]] after the last one that was used to construct the DID document according to the rules in section [DID Document from KERI Events](#did-document-from-keri-events).
1. This DID document metadata property MUST be present if the DID parameter `versionId`
(see section [Support for `versionId`](#support-for-versionid)) was used when resolving the `did:webs` DID, and if the value of that DID parameter was not the sequence number of the last event in the [[ref: KERI event stream]].

Example:

```json
{
  "didDocument": {
    "id": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
    // ... other properties
  },
  "didResolutionMetadata": {
  },
  "didDocumentMetadata": {
    "versionId": "1",
    "nextVersionId": "2"
  }
}
```

#### Use of `equivalentId`

The `equivalentId` DID document metadata property indicates other DIDs that refer to the same subject and are logically equivalent to the DID that has been resolved. It is similar to the `alsoKnownAs` DID document property (see section [Also Known As](#also-known-as)), but it has even stronger semantics, insofar as the logical equivalence is guaranteed by the DID method itself.

1. The `did:webs` `equivalentId` metadata property SHOULD contain a list of the controller AID [[ref: designated aliases]] `did:webs` DIDs that differ in the [[ref: host]] and/or port portion of the [[ref: method-specific identifier]] but share the same AID. Also see section [[ref: AID controlled identifiers]].
1. `equivalentId` depends on the controller AIDs array of [[ref: designated aliases]]. A `did:webs` identifier MUST not verify unless it is found in the `equivalentId` metadata that corresponds to the [[ref: designated aliases]].

> Note that [[ref: AID controlled identifiers]] like `did:web` and `did:keri` identifiers with the same AID are not listed in `equivalentId` because they do not have the same DID method. A `did:web` identifier with the same domain and AID does not have the same security characteristics as the `did:webs` identifier. Conversely, a `did:keri` identifier with the same AID has the same security characterisitcs but not the same dependence on the web. For these reasons, they are not listed in `equivalentId`. 

Example:

```json
{
    "didDocument": {
        "id": "did:webs:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
        "verificationMethod": [
            {
                "id": "#DHr0-I-mMN7h6cLMOTRJkkfPuMd0vgQPrOk4Y3edaHjr",
                "type": "JsonWebKey",
                "controller": "did:webs:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
                "publicKeyJwk": {
                    "kid": "DHr0-I-mMN7h6cLMOTRJkkfPuMd0vgQPrOk4Y3edaHjr",
                    "kty": "OKP",
                    "crv": "Ed25519",
                    "x": "evT4j6Yw3uHpwsw5NEmSR8-4x3S-BA-s6Thjd51oeOs"
                }
            }
        ],
        "service": [],
        "alsoKnownAs": [
            "did:web:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:webs:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:web:example.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:web:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:webs:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe"
        ]
    },
    "didResolutionMetadata": {
        "contentType": "application/did+json",
        "retrieved": "2024-04-01T17:43:24Z"
    },
    "didDocumentMetadata": {
        "witnesses": [],
        "versionId": "2",
        "equivalentId": [
            "did:webs:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:webs:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe"
        ],
        "didDocUrl": "http://did-webs-service:7676/ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe/did.json",
        "keriCesrUrl": "http://did-webs-service:7676/ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe/keri.cesr"
    }
}
```
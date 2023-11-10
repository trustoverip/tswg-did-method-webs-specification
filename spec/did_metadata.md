## DID Metadata

This section describes the support of the `did:webs` method for metadata, as described in sections
[DID Resolution Metadata](https://www.w3.org/TR/did-core/#did-resolution-metadata) and
[DID Document Metadata](https://www.w3.org/TR/did-core/#did-document-metadata) in the DID Core specification.

This metadata is returned by a DID Resolver in addition to the DID document. Also see the 
[DID Resolution](https://w3c-ccg.github.io/did-resolution/) specification for further details.

### DID Resolution Metadata

DID resolution metadata is metadata about the DID Resolution process that was performed in order to obtain
the DID document for a given DID.

At the moment, this specification does not define the use of
any specific DID Resolution metadata properties in the `did:webs` method, but may in the future include
various metadata, such as which KERI Watchers were used during the resolution process.

### DID Document Metadata

DID document metadata is metadata about the DID and the DID document that is the result of the DID
Resolution process. This specification defines how various DID document metadata properties are used
by the `did:webs` method.

#### Use of `versionId`

This DID document metadata property indicates the current version of the DID document that has been
resolved.

In the case of `did:webs`, this is defined to be the sequence number (i.e. the `s` field) of
the last event in the [[ref: KERI event stream]] that was used to construct the DID document according to
the rules in section [DID Document from KERI Events](#did-document-from-keri-events).

If the DID parameter `versionId` (see section [Support for `versionId`](#support-for-versionid)) was used when
resolving the `did:webs` DID, and if the DID Resolution process was successful, then this corresponding DID
document metadata property is guaranteed to be equal to the value of the DID parameter.

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

This DID document metadata property indicates the next version of the DID document after the version that has been
resolved.

In the case of `did:webs`, this is defined to be the sequence number (i.e. the `s` field) of
the next event in the [[ref: KERI event stream]] after the last one that was used to construct the DID document
according to the rules in section [DID Document from KERI Events](#did-document-from-keri-events).

This DID document metadata property is only present if the DID parameter `versionId`
(see section [Support for `versionId`](#support-for-versionid)) was used when resolving the `did:webs` DID, and
if the value of that DID parameter was not the sequence number of the last event in the [[ref: KERI event stream]].

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

This DID document metadata property indicates other DIDs that refer to the same subject and are logically equivalent
to the DID that has been resolved. It is similar to the `alsoKnownAs` DID document property (see section
[Also Known As](#also-known-as)), but it has even stronger semantics, insofar as the logical equivalence is
guaranteed by the DID method itself.

In the case of `did:webs`, this metadata property SHOULD contain a list of the controller AID authorized `did:webs` DIDs that differ
in the domain name and/or port portion of the [[ref: method-specific identifier]]
but share the same AID. Also see section [[ref:AID controlled identifiers]].

Note that [[ref:AID controlled identifiers]] like `did:web` and `did:keri` identifiers with the same AID are not listed in `equivalentId` because they do not have the same DID method. A `did:web` identifier with the same domain and AID does not have the same security characteristics as the `did:webs` identifier. Conversly, a `did:keri` identifier with the same AID has the same security characterisitcs but not the same dependence on the web. For these reasons, they are not listed in `equivalentId`.

`equivalentId` depends on the controller AIDs set of [[ref: Authorized Identifiers]]. A `did:webs` identifier is not valid unless it is found in the `equivalentId` metadata that corresponds to the [[ref: Authorized Identifiers]] attestation as defined in this spec. 

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
    "equivalentId": [
      "did:webs:example.com%3A8080:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "did:webs:foo.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "did:webs:bar.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
    ]    
  }
}
```

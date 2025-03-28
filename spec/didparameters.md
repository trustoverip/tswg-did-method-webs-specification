## DID Parameters
This section is normative.

This section describes the support of the `did:webs` method for certain DID parameters.

### Support for `versionId`

The `did:webs` DID method supports the `versionId` DID parameter. This DID parameter is defined [here](https://www.w3.org/TR/did-core/#did-parameters).

This allows clients to instruct a DID Resolver to return a specific version of a DID document, as opposed to the latest version. The `did:webs` DID method is ideally suited for this functionality, since a continuous, self-certifying stream of events lies at the heart of the DID method's design, see section [KERI Fundamentals](#keri-fundamentals).

1. Valid values for this DID parameter MUST be the sequence numbers of events in the [[ref: KERI event stream]].
1. When a `did:webs` DID is resolved with this DID parameter, a `did:webs` resolver MUST construct the DID document based on an AID's associated KERI events from the [[ref: KERI event stream]] only up to (and including) the event with the sequence
number (i.e. the `s` field) that corresponds to the value of the `versionId` DID parameter.

> See section [DID Documents](#did-documents) for details.

Example:

```
did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M?versionId=1
```

### Support for `transformKeys`

The `did:webs` DID method supports the `transformKeys` DID parameter. This DID parameter is defined [here](https://github.com/decentralized-identity/did-spec-extensions/blob/main/parameters/transform-keys.md).

1. This parameter MUST be implemented for a DID Resolver to return verification methods in a DID document in a desired format, such as `JsonWebKey` or `Ed25519VerificationKey2020`.

Example:

```
did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M?transformKeys=CesrKey
```

#### `CesrKey` and `publicKeyCesr`

This specification defines the following extensions to the DID document data model in accordance with the [[ref: DID Spec Registries]]:

1. Extension verification method `type` `CesrKey` MAY be available in a `did:webs` DID document to express a public key encoded in [[ref: CESR]] format.
1. Extension verification method property `publicKeyCesr` MAY be available in a `did:webs` DID document to provide a string value whose content is the [[ref: CESR]] representation of a public key.
1. The verification method type `CesrKey` MAY be used as the value of the `transformKeys` DID parameter.

For example, a KERI AID with only the following inception event in its KEL:
```json
{
  "v": "KERI10JSON0001b7_",
  "t": "icp",
  "d": "Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "i": "Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "s": "0",
  "kt": "1",
  "k": [
    "1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",  // Secp256k1 Key
    "DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",      // Ed25519 Key
    "DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu"       // Ed25519 Key
  ],
  // ...
}
```
and given the following the DID URL:
```
did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M?transformKeys=CesrKey
```
would result in a DID document with the following verification methods array:
```json
{
  "verificationMethod": [
    {
      "id": "#1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",
      "type": "CesrKey",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "publicKeyCesr": "1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk"
    },
    {
      "id": "#DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",
      "type": "CesrKey",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "publicKeyCesr": "DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE"
    },
    {
      "id": "#DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu",
      "type": "CesrKey",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "publicKeyCesr": "DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu"
    }
  ]
}
```

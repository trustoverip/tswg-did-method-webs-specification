## DID Parameters

This section describes the support of the `did:webs` method for certain DID parameters.

### Support for `versionId`

TODO, see https://github.com/trustoverip/tswg-did-method-webs-specification/issues/24

### Support for `transformKeys`

The `did:webs` DID method supports the `transformKeys` DID parameter. This DID parameter is defined
[here](https://github.com/decentralized-identity/did-spec-extensions/blob/main/parameters/transform-keys.md). (TODO:
Add proper references to external documents).

This allows clients to instruct a DID Resolver to return verification methods in a DID document in a desired format,
such as `JsonWebKey` or `Ed25519VerificationKey2020`. 

#### `CesrKey` and `publicKeyCesr`

This specification defines the following extensions to the DID document data model in accordance with the
[DID Spec Registries](https://w3c.github.io/did-spec-registries/):

* Extension verification method type `CesrKey`: This verification method type can be used in a DID document to 
express a public key encoded in [[ref: CESR]] format.

* Extension verification method property `publicKeyCesr`: This verification method property has a string value
whose content is the CESR representation of a public key.

The verification method type `CesrKey` can be used as the value of the `transformKeys` DID parameter.

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

... and given the following the DID URL:

```
did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M?transformKeys=CesrKey
```

... would result in a DID document with the following verification methods array:

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

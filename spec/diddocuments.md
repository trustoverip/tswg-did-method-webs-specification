## DID Documents

### Introduction
DID documents in this method are generated or derived from the key state of the
corresponding AID. By processing the [[ref: KERI event stream]] of the AID, the generation algorithm will be reading the AID [[ref: KEL]] (and possibly [[ref: TEL]])
to produce the DID document. 

DID documents for this method are pure JSON. They may be processed as JSON-LD by
prepending an `@context` if consumers of the documents wish.

Hashes, cryptographic keys, and signatures are represented as CESR strings. This
is an approach similar to multibase, making them self-describing and terse.

### DID Document from KERI Events
The [[ref: KERI event stream]] represents a cryptographic chain
of custody from the [[ref: AID]] itself down to the current set of keys and the cryptographic commitment to the next rotation key(s). The [[ref: KERI event stream]] also contains events that do not alter the [[ref: AID]] key state, but are useful for the DID document, such as the supported domains, current set of service endpoints, etc. A did:webs resolver produces the DID document by processing the [[ref: KERI event stream]] to determine the current key state. We detail the different events in (KERI event details)[#KERI-event-details] below and show how they change the DID Document. The mapping from [[ref: KERI event stream]] to the properties of the DID Document is the core of the did:webs resolver logic.  Understanding the optimal way to update and maintain the [[ref: KERI event stream]] (publish static keri.cesr files, dyanamically generate the keri.cesr resource, etc) is beyond the scope of the spec, but a reference implementation of the resolver that details these techniques is being developed alongside this spec. The important concepts are that the entire [[ref: KERI event stream]] is used to produce and verify the DID document.

In KERI the calculated values that result from processing the [[ref: KERI event stream]] are referred to as the "current key state" and expressed
in the Key State Notice (KSN) record.  An example of a KERI KSN record can be seen here:

```json
{
    "v": "KERI10JSON000274_",
    "i": "EeS834LMlGVEOGR8WU3rzZ9M6HUv_vtF32pSXQXKP7jg",
    "s": "1",
    "t": "ksn",
    "p": "ESORkffLV3qHZljOcnijzhCyRT0aXM2XHGVoyd5ST-Iw",
    "d": "EtgNGVxYd6W0LViISr7RSn6ul8Yn92uyj2kiWzt51mHc",
    "f": "1",
    "dt": "2021-11-04T12:55:14.480038+00:00",
    "et": "ixn",
    "kt": "1",
    "k": [
      "DTH0PwWwsrcO_4zGe7bUR-LJX_ZGBTRsmP-ZeJ7fVg_4"
    ],
    "nt": 1,
    "n": [
      "E6qpfz7HeczuU3dAd1O9gPPS6-h_dCxZGYhU8UaDY2pc"
    ],
    "bt": "3",
    "b": [
      "BGKVzj4ve0VSd8z_AmvhLg4lqcC_9WYX90k03q-R_Ydo",
      "BuyRFMideczFZoapylLIyCjSdhtqVb31wZkRKvPfNqkw",
      "Bgoq68HCmYNUDgOz4Skvlu306o_NY-NrYuKAVhk3Zh9c"
    ],
    "c": [],
    "ee": {
      "s": "0",
      "d": "ESORkffLV3qHZljOcnijzhCyRT0aXM2XHGVoyd5ST-Iw",
      "br": [],
      "ba": []
    },
    "di": ""
}
```

Using this key state as reference, we can identify the fields from the current key state that will translate to values
in the DID document.  The following table lists the values from the example KSN and their associated values in a DID document:

| Key State Field | Definition                             | DID Document Value                                                                           |
|:---------------:|:---------------------------------------|:---------------------------------------------------------------------------------------------|
|       `i`       | The AID value                          | The DID Subject and DID Controller                                                           |
|       `k`       | The current set of public signing keys | Verification Methods with associated authentication and assertion verification relationships |
|      `kt`       | The current signing keys threshold     | The threshold in a Verification Method of type `ConditionalProof2022`                        |

In several cases above, the value from the key state is not enough by itself to populate the DID document.  The following
sections detail the algorithm to follow for each case.

#### DID Subject
The value of the `id` property in the DID document MUST be the `did:webs` DID that is being created or resolved.
It reflects the current combined web location and AID of the identifier.
The value from the `i` field MUST be the value after the last `:` in the
[[ref: method-specific identifier]] ([[ref: MSI]]) of the `did:webs` DID, according to the syntax rules in section
[Method-Specific Identifier](#method-specific-identifier).

```json
{
  "id": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
}
```

#### DID Controller
The value of the `controller` property MUST be a single string that is the same as the `id` (the DID Subject).

```json
{
  "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
}
```

#### Also Known As
The `alsoKnownAs` property in the root of the DID document MAY contain other equivalent,
resolvable `did:webs` DIDs. The `alsoKnownAs` property MAY contain `did:web` versions of the `did:webs` DID(s).

It is anticipated that implementations of this DID method will be able to serve the same AID
as multiple DIDs, all of which are synonymous for each other.  Any implementation will be able
to provide the URL endpoint required to serve any AID it is serving as a `did:webs` DID as for
`did:web` resolution.  Likewise, any implementation should be able to serve any AID it is serving
as a `did:webs` DID and as a `did:keri` DID as well.  Finally, the same AID may be served under
multiple domains at the same time and they should be considered the same DID since the AID portion
of the DIDs are the same.

For each synonymous DID defined above (we need a way in KERI to declare other domains it is being
served under, unless this is an implementation specific detail) an entry in the `alsoKnownAs` array
in the DID document should be created.  For the DID
`did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M` the following `alsoKnownAs`
entries could be created:

```json
{
  "alsoKnownAs": [
    "did:web:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:webs:foo.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:keri:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
  ]
}
```

#### Verification Methods
KERI identifiers express public signing keys as Composable Event Streaming Representation (CESR) encoded strings in the
`k` field of establishment events and the key state notice.  CESR encoding encapsulates all the information needed to
determine the cryptographic algorithm used to generate the key pair.  For each key listed in the array value of the `k` field
a corresponding verification method will be generated in the DID document.  The 'type' property  in the verification method for each
public key will be determined by the algorithm used to generate the public key.  At the time of this writing, KERI currently
supports public key generation for Ed25519, Secp256k1 and Secp256r1 keys, however the protocol allows for others to be added at any time.
We must define the subset of public key algorithms for KERI AIDs that this specification will accept, so we can define mappings to existing verification method types as registered in the DID Specification Registries.  As KERI evolves with more algorithms, new verification method types must be registered in the DID Specification Registries and added to this specification.

The `id` property of the verification method must be a relative DID URL and use the KERI key CESR value as the value of the fragment component, e.g., `"id": "#<identifier>"`.

The `controller` property of the verification method must be the value of the `id` property of DID document. (Does the method spec need to specify this?)

For example, the key `DFkI8OSUd9fnmdDM7wz9o6GT_pJIvw1K_S21AKZg4VwK` in the DID document for the AID `EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2` becomes:

```json
  "verificationMethod": [
    {
      "id": "#DFkI8OSUd9fnmdDM7wz9o6GT_pJIvw1K_S21AKZg4VwK",
      "controller": "did:webs:example.com:EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2",
      ...
    }
  ]
```

##### Ed25519
Ed25519 public keys must be converted to a verification method with a type of `JsonWebKey` and `publicKeyJwk` property whose value is generated by decoding the CESR representation of the public key out of the KEL and into its binary form (minus the leading 'B' or 'D' CESR codes) and generating the corresponding representation of the key in JSON Web Key form.

For example, a KERI AID with only the following inception event in its KEL:

```json
{
  "v": "KERI10JSON0001ad_",
  "t": "icp",
  "d": "EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2",
  "i": "EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2",
  "s": "0",
  "kt": "1",
  "k": [
    "DFkI8OSUd9fnmdDM7wz9o6GT_pJIvw1K_S21AKZg4VwK",
  ]
  // ...
}
```

... would result in a DID document with the following verification methods array:

```json
  "verificationMethod": [
    {
      "id": "#DFkI8OSUd9fnmdDM7wz9o6GT_pJIvw1K_S21AKZg4VwK",
      "type": "JsonWebKey",
      "controller": "did:webs:example.com:EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2",
      "publicKeyJwk": {
        "kid": "DFkI8OSUd9fnmdDM7wz9o6GT_pJIvw1K_S21AKZg4VwK",
        "kty": "OKP",
        "crv": "Ed25519",
        "x": "FkI8OSUd9fnmdDM7wz9o6GT_pJIvw1K_S21AKZg4VwI"
      }
    }
  ]
```

##### Secp256k1
Secp256k1 public keys must be converted to a verification method with a type of `JsonWebKey` and `publicKeyJwk` property whose value is generated by decoding the CESR representation of the public key out of the KEL and into its binary form (minus the leading '1AAA' or '1AAB' CESR codes) and generating the corresponding representation of the key in JSON Web Key form.

For example, a KERI AID with only the following inception event in its KEL:

```json
{
  "v": "KERI10JSON0001ad_",
  "t": "icp",
  "d": "EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2",
  "i": "EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2",
  "s": "0",
  "kt": "1",
  "k": [
    "1AAAAmbFVu-Wf8NCd63B9V0zsy7EgB_ocX2_n_Nh1FCmgF0Y",
  ]
  // ...
}
```

... would result in a DID document with the following verification methods array:

```json
  "verificationMethod": [
    {
      "id": "#1AAAAmbFVu-Wf8NCd63B9V0zsy7EgB_ocX2_n_Nh1FCmgF0Y",
      "type": "JsonWebKey",
      "controller": "did:webs:example.com:EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2",
      "publicKeyJwk": {
        "kid": "1AAAAmbFVu-Wf8NCd63B9V0zsy7EgB_ocX2_n_Nh1FCmgF0Y",
        "kty": "EC",
        "crv": "secp256k1",
        "x": "ZsVW75Z_w0J3rcH1XTOzLsSAH-hxfb-Q82HUUKaAXRg",
        "y": "Lu6Uw785U3K05D-NPNoUInHPNUz9cGqWwjKjm5KL8FI"
      }
    }
  ]
```

##### Thresholds
If the current signing keys threshold (the value of the `kt` field) is a string containing a number that is greater than 1,
or if it is an array containing fractionally weighted thresholds, then in addition to the verification
methods generated according to the rules in the previous sections, another verification method
with a type of `ConditionalProof2022` will be generated in the DID document. This verification method type is defined here:
https://w3c-ccg.github.io/verifiable-conditions/ (TODO: add proper references).

It is constructed according to the following rules:

* The `id` property of the verification method MUST be a relative DID URL and use the AID as the value of the fragment component, e.g., `"id": "#<aid>"`.

* The `controller` property of the verification method MUST be the value of the `id` property of the DID document. (Does the method spec need to specify this?)

* If the value of the `kt` field is a string containing a number that is greater than 1:

    * The `threshold` property of the verification method MUST be the integer value of the `kt` field in the current key state.
    * The `conditionThreshold` property of the verification method MUST contain an array. For each key listed in the array value of the `k` field in the
      key state:
      * The relative DID URL corresponding to the key MUST be added to the array value of the `conditionThreshold` property.

For example, a KERI AID with only the following inception event in its KEL:

```json
{
  "v": "KERI10JSON0001b7_",
  "t": "icp",
  "d": "Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "i": "Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "s": "0",
  "kt": "2",  // Signing Threshold
  "k": [
    "1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",  // Secp256k1 Key
    "DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",      // Ed25519 Key
    "DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu"       // Ed25519 Key
  ],
}
```

... would result in a DID document with the following verification methods array:

```json
{
  "verificationMethod": [
    {
      "id": "#Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "type": "ConditionalProof2022",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "threshold": 2,
      "conditionThreshold": [
        "#1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",
        "#DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",
        "#DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu"
      ]
    },
    {
      "id": "#1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",
      "type": "JsonWebKey",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "publicKeyJwk": {
        "kid": "1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",
        "kty": "EC",
        "crv": "secp256k1",
        "x": "NtngWpJUr-rlNNbs0u-Aa8e16OwSJu6UiFf0Rdo1oJ4",
        "y": "qN1jKupJlFsPFc1UkWinqljv4YE0mq_Ickwnjgasvmo"
      }
    },
    {
      "id": "#DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",
      "type": "JsonWebKey",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "publicKeyJwk": {
        "kid": "DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",
        "kty": "OKP",
        "crv": "Ed25519",
        "x": "A-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE"
      }
    },
    {
      "id": "#DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu",
      "type": "JsonWebKey",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "publicKeyJwk": {
        "kid": "DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu",
        "kty": "OKP",
        "crv": "Ed25519",
        "x": "LWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNws"
      }
    }
  ]
}
```

* If the value of the `kt` field is an array containing fractionally weighted thresholds:

    * The `threshold` property of the verification method MUST be half of the lowest common denominator (LCD) of all the fractions
      in the `kt` array.
    * The `conditionWeightedThreshold` property of the verification method MUST contain an array. For each key listed in the array value of the `k` field in the
      key state, and for each corresponding fraction listed in the array value of the `kt` field:
      * A JSON object MUST be added to the array value of the `conditionWeightedThreshold` property.
      * The JSON object MUST contain a property `condition` whose value is the relative DID URL corresponding to the key.
      * The JSON object MUST contain a property `weight` whose value is the numerator of the fraction after it has been expanded over the lowest common denominator (LCD) of all the fractions.

For example, a KERI AID with only the following inception event in its KEL:

```json
{
  "v": "KERI10JSON0001b7_",
  "t": "icp",
  "d": "Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "i": "Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "s": "0",
  "kt": ["1/2", "1/3", "1/4"],  // Signing Threshold
  "k": [
    "1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",  // Secp256k1 Key
    "DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",      // Ed25519 Key
    "DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu"       // Ed25519 Key
  ],
}
```

... would result in a DID document with the following verification methods array:

```json
{
  "verificationMethod": [
    {
      "id": "#Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "type": "ConditionalProof2022",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "threshold": 12,
      "conditionWeightedThreshold": [
        {
          "condition": "#1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",
          "weight": 6
        },
        {
          "condition": "#DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",
          "weight": 4
        },
        {
          "condition": "#DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu",
          "weight": 3
        }
      ]
    },
    {
      "id": "#1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",
      "type": "EcdsaSecp256k1VerificationKey2019",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "publicKeyJwk": {
        "crv": "secp256k1",
        "x": "NtngWpJUr-rlNNbs0u-Aa8e16OwSJu6UiFf0Rdo1oJ4",
        "y": "qN1jKupJlFsPFc1UkWinqljv4YE0mq_Ickwnjgasvmo",
        "kty": "EC",
        "kid": "WjKgJV7VRw3hmgU6--4v15c0Aewbcvat1BsRFTIqa5Q"
      }
    },
    {
      "id": "#DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",
      "type": "Ed25519VerificationKey2020",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "publicKeyMultibase": "zH3C2AVvLMv6gmMNam3uVAjZpfkcJCwDwnZn6z3wXmqPV"
    },
    {
      "id": "#DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu",
      "type": "Ed25519VerificationKey2020",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "publicKeyMultibase": "zDqYpw38nznAUJeeFdhKBQutRKpyDXeXxxi1HjYUQXLas"
    }
  ]
}
```

#### Verification Relationships
KERI AID public keys can be used to sign a variety of data.  This includes but is not limited to logging into a website,
challenge-response exchanges and credential issuances.  It follows that:

If the value of `kt` == 1:
- For each public key in `k` and its corresponding verification method, two verification relationships MUST be generated
  in the DID document.  One verification relationship of type `authentication` and one
  verification relationship of type `assertionMethod`.  The `authentication` verification relationship defines that the
  DID controller can authenticate using each key, and the `assertionMethod` verification relationship defines that the DID
  controller can express claims using each key.

If the value of `kt` > 1 or if the value of `kt` is an array containing fractionally weighted thresholds:
- For the verification method of type `ConditionalProof2022` (see section [Thresholds](#thresholds)), two verification relationships MUST be generated
  in the DID document.  One verification relationship of type `authentication` and one
  verification relationship of type `assertionMethod`.  The `authentication` verification relationship defines that the
  DID controller can authenticate using a combination of multiple keys above the threshold, and the `assertionMethod` verification relationship defines that the DID
  controller can express claims using a combination of multiple keys above the threshold.

References to verification methods in the DID document MUST use the relative form of the identifier, e.g., `"authentication": ["#<identifier>"]`.

##### Key Agreement
There are multiple ways to establish key agreement in KERI. We detail common considerations and techniques:
* *BADA-RUN for key agreement:* Normally in KERI we would use [[ref: BADA-RUN]], similar to how we are specify endpoints, domain migration info, etc. This would allow the controller to specify any Key Agreement key, without unnecessarily adding KERI events to their [[ref: KEL]].
* *Key agreement from `k` field keys:* It is important to note that KERI is cryptographically agile and can support a variety of keys and signatures. If the 'k' field references a Ed25519 key, then key agreement could be established using the corresponding x25519 key for Diffie-Helman key exchange. Alternatively if the key is an ECDSA or other NIST algorithms key then it will be the same key for signatures and encryption and can be used for key agreement.
* *Key agreement anchored in KEL:* It is always possible to anchor arbitrary data, like a key agreement key, to the KEL. Likely the best mechanism is to anchor an ACDC to a [[ref: TEL]] which is anchored to the KEL.

#### Service Endpoints
`did:webs` supports service endpoints, including types declared in the DID Specification Registries, such as [DIDCommMessaging](https://www.w3.org/TR/did-spec-registries/#didcommmessaging).  For additional details about the mapping between KERI events and the Service Endpoints in the DID Document, see [Service Endpoint KERI events](#service-endpoint-event-details).  It is important to note that DID document service endpoints are different than the KERI service endpoints detailed in [KERI Service Endpoints as DID Document Metadata](#keri-service-endpoints-as-did-document-metadata).


##### KERI Service Endpoints as DID Document Metadata
In KERI, service endpoints are defined by 2 sets of signed data using Best Available Data - Read, Update, Nullify ([[ref: BADA-RUN]]) rules for data processing.  The protocol ensures that all data is signed in transport and at rest and versioned to ensure only the latest signed data is available.

The two data sets used to define service endpoints are called Location Schemes and Endpoint Role Authorizations and are expressed in KERI `rpy` events.  Location Schemes define URLs for any URL scheme that an AID has exposed.  For example, the following `rpy` method declares that the AID `EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1` exposes the URL `http://localhost:3902` for scheme `http`:

```json
{
    "v": "KERI10JSON0000fa_",
    "t": "rpy",
    "d": "EOGL1KGpOnRaZDIB11uZDCkhHs52_MtMXHd7EqUqwtA3",
    "dt": "2022-01-20T12:57:59.823350+00:00",
    "r": "/loc/scheme",
    "a": {
      "eid": "EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1",
      "scheme": "http",
      "url": "http://127.0.0.1:3901/"
    }
  }
```

Endpoint Role Authorizations associate a role for one AID in relation to another AID.  Endpoint role authorizations are expressed in KERI `rpy` events with the following structure:


```json
{
    "v": "KERI10JSON000116_",
    "t": "rpy",
    "d": "EBiVyW6jPOeHX5briFYMQ4CefzqIZHgl-rrcXqj_t9ex",
    "dt": "2022-01-20T12:57:59.823350+00:00",
    "r": "/end/role/add",
    "a": {
      "cid": "EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1",
      "role": "agent",
      "eid": "EOGL1KGpOnRaZDIB11uZDCkhHs52_MtMXHd7EqUqwtA3"
    }
}
```

The AID listed in `cid` is the source of the authorization, the `role` is the role and the AID listed in the `eid` field is the target of the authorization.  So in this example, `EOGL1KGpOnRaZDIB11uZDCkhHs52_MtMXHd7EqUqwtA3` is being authorized as an Agent for `EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1`.



The current set of endpoint roles in KERI is contained in the following table:

| Role | Description |
|:-----|:------------|
|`controller` | The association of the key controller of an AID.  These are always self-referential. |
|`witness` | A witness for an AID.  This role is already cryptographically committed to the KEL of the source AID and thus does not require and explicit `rpy` authroization event.|
|`registrar` | Currently unused.|
| `watcher` | A componenet serving as a Watcher as defined by the KERI protocol (beyond the scope of this document).|
|`judge` | Currently unused. |
|`juror` | Currently unused. |
|`peer` | Currently unused. |
|`mailbox` | A component authorized to serve as a store and forward mailbox for the source identifier.  This component usually provides a persistent internet connection for AID controllers that are usually off line.|
|`agent` | A component authorized to serve as an agent running with persistent internet connection.  Provides more funcitonality than a `mailbox`|

###### Defining new service types
KERI service endpoints roles beyond `witness` can be defined using Location Scheme and Endpoint Authorization records in KERI.  This section will map the current roles in KERI to service `type` values in resulting DID documents and propose a new role in KERI to map to the existing [DIDCommMessaging](https://www.w3.org/TR/did-spec-registries/#didcommmessaging) service type declared in DID Specification Registries.

```json
{
  "service": [
      {
        "id":"#Bgoq68HCmYNUDgOz4Skvlu306o_NY-NrYuKAVhk3Zh9c",
        "type": "DIDCommMessaging", 
        "serviceEndpoint": "https://bar.example.com"
      }
      {
        "id":"#BuyRFMideczFZoapylLIyCjSdhtqVb31wZkRKvPfNqkw",
        "type": "KERIAgent", 
        "serviceEndpoint": {
          "tcp": "tcp://bar.example.com:5542",
          "https": "https://bar.example.com" 
        }
      }
  ]
}
```

TODO:  Detail the transformation


#### Other Key Commitments
Data structures similar to Location Scheme and Endpoint Authorizations and managed in KERI using [[ref: BADA-RUN]] could be created that would be used for declaring other types of keys, for example encryption keys, etc

TODO:  Propose new data structures in KERI and Detail the transformation

### Transformation to `did:web` DID Document

The DID document that exists as a resource on a webserver is compatible with the `did:web` DID method and therefore
necessarily different from a `did:webs` DID document with regard to the `id`, `controller`, and `alsoKnownAs` properties. This section
defines a simple transformation algorithm from a `did:webs` DID document to a `did:web` DID document.

Given a `did:webs` DID document, construct a new `did:web` DID document with the following differences:

- In the values of the top-level `id` and `controller` properties of the DID document, replace the `did:webs` prefix string with `did:web`.
- In the value of the top-level `alsoKnownAs` property, replace the entry that is now the new value of the `id` property (using `did:web`)
  with the old value of the `id` property (using `did:webs`).
- All other content of the DID document is simply copied without modifications.

This transformation is used during the [Create](#create) DID method operation.

For example, given the following `did:webs` DID document:
```json
{
  "id": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "alsoKnownAs": [
    "did:web:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:webs:foo.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:keri:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
  ],
  ...
}
```

The result of the transformation algorithm is the following `did:web` DID document:
```json
{
  "id": "did:web:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "controller": "did:web:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "alsoKnownAs": [
    "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:webs:foo.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:keri:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
  ],
  ...
}
```

### Transformation to `did:webs` DID Document

This section defines an inverse transformation algorithm from a `did:web` DID document to a `did:webs` DID document.

Given a `did:web` DID document, construct a new `did:webs` DID document with the following differences:

- In the values of the top-level `id` and `controller` properties of the DID document, replace the `did:web` prefix string with `did:webs`.
- In the value of the top-level `alsoKnownAs` property, replace the entry that is now the new value of the `id` property (using `did:webs`)
  with the old value of the `id` property (using `did:web`).
- All other content of the DID document is simply copied without modifications.

This transformation is used during the [Read (Resolve)](#read-resolve) DID method operation.

For example, given the following `did:web` DID document:
```json
{
  "id": "did:web:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "controller": "did:web:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "alsoKnownAs": [
    "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:webs:foo.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:keri:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
  ],
  ...
}
```

The result of the transformation algorithm is the following `did:webs` DID document:
```json
{
  "id": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "alsoKnownAs": [
    "did:web:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:webs:foo.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:keri:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
  ],
  ...
}
```

### Full Example
The following blocks contain full annotated examples of a KERI AID with two events, an inception event and an interaction event, some witnesses, multiple public signing and rotation keys and an Agent with the resulting DID document that an implementation would generate assuming the implementation was running on the `example.com` domain with no unique port and no additional path defined:

```json
{
    "v": "KERI10JSON0001b7_",
    "t": "icp",
    "d": "Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "i": "Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "s": "0",
    "kt": "2",  // Signing Threshold
    "k": [
      "1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",  // Secp256k1 Key
      "DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",      // Ed25519 Key
      "DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu"       // Ed25519 Key
    ],
    "nt": "2",
    "n": [
      "Eao8tZQinzilol20Ot-PPlVz6ta8C4z-NpDOeVs63U8s",
      "EAcNrjXFeGay9qqMj96FIiDdXqdWjX17QXzdJvq58Zco",
      "EPoly9Tq4IPx41U-AGDShLDdtbFVzt7EqJUHmCrDxBdb"
    ],
    "bt": "3",
    "b": [
      "BGKVzj4ve0VSd8z_AmvhLg4lqcC_9WYX90k03q-R_Ydo",
      "BuyRFMideczFZoapylLIyCjSdhtqVb31wZkRKvPfNqkw",
      "Bgoq68HCmYNUDgOz4Skvlu306o_NY-NrYuKAVhk3Zh9c"
    ],
    "c": [],
    "a": []
  }
...
{
  "v": "KERI10JSON00013a_",
  "t": "ixn",
  "d": "Ek48ahzTIUA1ynJIiRd3H0WymilgqDbj8zZp4zzrad-w",
  "i": "Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "s": "1",
  "p": "Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "a": [
    {
      "i": "EoLNCdag8PlHpsIwzbwe7uVNcPE1mTr-e1o9nCIDPWgM",
      "s": "0",
      "d": "EoLNCdag8PlHpsIwzbwe7uVNcPE1mTr-e1o9nCIDPWgM"
    }
  ]
}
...
{
  "v": "KERI10JSON000116_",
  "t": "rpy",
  "d": "EBiVyW6jPOeHX5briFYMQ4CefzqIZHgl-rrcXqj_t9ex",
  "dt": "2022-01-20T12:57:59.823350+00:00",
  "r": "/end/role/add",
  "a": {
    "cid": "Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "role": "agent",
    "eid": "EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1"
  }
}
...
{
  "v": "KERI10JSON000116_",
  "t": "rpy",
  "d": "EBiVyW6jPOeHX5briFYMQ4CefzqIZHgl-rrcXqj_t9ex",
  "dt": "2022-01-20T12:57:59.823350+00:00",
  "r": "/end/role/add",
  "a": {
    "cid": "EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1",
    "role": "controller",
    "eid": "EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1"
  }
}
...
{
  "v": "KERI10JSON0000fa_",
  "t": "rpy",
  "d": "EOGL1KGpOnRaZDIB11uZDCkhHs52_MtMXHd7EqUqwtA3",
  "dt": "2022-01-20T12:57:59.823350+00:00",
  "r": "/loc/scheme",
  "a": {
    "eid": "EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1",
    "scheme": "http",
    "url": "http://foo.example.com:3901/"
  }
}


...
{
  "v": "KERI10JSON000116_",
  "t": "rpy",
  "d": "EBiVyW6jPOeHX5briFYMQ4CefzqIZHgl-rrcXqj_t9ex",
  "dt": "2022-01-20T12:57:59.823350+00:00",
  "r": "/end/role/add",
  "a": {
    "cid": "EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1",
    "role": "controller",
    "eid": "EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1"
  }
}
...
{
  "v": "KERI10JSON0000fa_",
  "t": "rpy",
  "d": "EOGL1KGpOnRaZDIB11uZDCkhHs52_MtMXHd7EqUqwtA3",
  "dt": "2022-01-20T12:57:59.823350+00:00",
  "r": "/loc/scheme",
  "a": {
    "eid": "EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1",
    "scheme": "http",
    "url": "http://foo.example.com:3901/"
  }
}

```

Resulting DID document:
```json
{
  "id": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
  "alsoKnownAs": [
    "did:web:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:webs:foo.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:keri:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
  ],
  "verificationMethod": [
    {
      "id": "#Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "type": "ConditionalProof2022",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "threshold": 2,
      "conditionThreshold": [
        "#1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",
        "#DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",
        "#DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu"
      ]
    },
    {
      "id": "#1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",
      "type": "JsonWebKey",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "publicKeyJwk": {
        "kid": "1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",
        "kty": "EC",
        "crv": "secp256k1",
        "x": "NtngWpJUr-rlNNbs0u-Aa8e16OwSJu6UiFf0Rdo1oJ4",
        "y": "qN1jKupJlFsPFc1UkWinqljv4YE0mq_Ickwnjgasvmo"
      }
    },
    {
      "id": "#DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",
      "type": "JsonWebKey",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "publicKeyJwk": {
        "kid": "DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",
        "kty": "OKP",
        "crv": "Ed25519",
        "x": "A-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE"
      }
    },
    {
      "id": "#DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu",
      "type": "JsonWebKey",
      "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
      "publicKeyJwk": {
        "kid": "DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu",
        "kty": "OKP",
        "crv": "Ed25519",
        "x": "LWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNws"
      }
    }
  ],
  "authentication": [
    "#Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
  ],
  "assertionMethod": [
    "#Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
  ],
  "service": [
    {
      "id": "#EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1",
      "type": "KeriAgent",
      "serviceEndpoint": "http://foo.example.com:3901/"
    }
  ]
}
```

### Basic KERI event details
[DID Document from KERI Events](#did-document-from-keri-events) introduced the core [[ref: KERI event stream]] and related DID Document concepts. This section provides additional details regarding the basic types of KERI events and how they relate to the DID document.

#### Key state events
When processing the [[ref: KERI event stream]] there are two broad types of key state events (KERI parlance is 'establishment events') that can alter the key state of the AID. Any change in key state of the AID will be reflected in the DID document.
If a key state event does not commit to a future set of rotation key hashes, then the AID can't be rotated to new keys in the future (KERI parlance is that the key state of the AID becomes 'non-transferrable'). If a key state event does commit to a future set of rotation key hashes, then any future key state rotation must be to those commitment keys. This is the foundation of [[ref: pre-rotation]], is post-quantum safe, and allows the controller to recover from key compromise.
* [[def: Inception event]]: The inception event is the first event in the [[ref: KEL]] that establishes the AID. This defines the initial key set and if the controller(s) desire future key rotation (transfer) then the inception event must commit to a set of future rotation key hashes. When processing the [[ref: KERI event stream]], if there are no rotation events after the inception event, then this is the current key state of the AID and will be reflected in the DID Document as specified in [Verification Methods](#verification-methods) and [Verification Relationships](#verification-relationships). You can learn more about the inception event in the [KERI specification](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#name-basic-terminology) and you can see an [example inception event](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#name-inception-event). To learn about future rotation key commitment, see the sections about [pre-rotation](#pre-rotation) and the [KERI specification section on pre-rotation](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#name-key-pre-rotation-concept)
* [[def: Rotation event]]: Rotation events come after inception events and can only change the key state to the previously committed to rotation keys and if the controller(s) desires future key rotation (transfer) then the rotation event must commit to a set of future rotation key hashes. When processing the [[ref: KERI event stream]], if there are rotation events after the inception event, then the last rotation event is the current key state of the AID and will be reflected in the DID Document as specified in [Verification Methods](#verification-methods) and [Verification Relationships](#verification-relationships). You can learn more about rotation events in the [KERI specification](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#name-basic-terminology) and you can see an [example rotation event](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#name-rotation-event-message-body). To learn about future rotation key commitment, see the sections about [pre-rotation](#pre-rotation) and the [KERI specification section on pre-rotation](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#name-key-pre-rotation-concept)

### Delegation KERI event details
This section focuses on delegation relationships between KERI AIDs. [DID Document from KERI Events](#did-document-from-keri-events) introduced the core [[ref: KERI event stream]] and related DID Document concepts. This section provides additional details regarding the basic types of KERI events and how they relate to the DID document. [Basic KERI event details](#basic-keri-event-details) provides additional details on the basic types of KERI events and how they relate to the DID document.

#### Delegation key state events
* [[def: Delegated inception event]]: Establishes a delegated identifier for which either the delegator or the delegate can end the delegation commitment. All delegation relationships start with a delegated inception event. The KERI specification provides [an example of a delegated inception event](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#name-delegated-inception-event-m).
* [[def: Delegated rotation event]]: Updates the delegated identifier commitment. Either the delegator or the delegate can end the delegation commitment. Any change to the [[ref: Delegated inception event]] key state or delegated rotation event key state requires a delegated rotation event. The KERI specification provides [an example of a delegated rotation event](https://trustoverip.github.io/tswg-keri-specification/draft-ssmith-keri.html#section-8.2)

### Service Endpoint event details
TODO:  Define and detail the service endpoint events
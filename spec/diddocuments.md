## DID Documents
This section is normative.

1. `did:webs` DID documents MUST be generated or derived from the [[ref: Keri event stream]] of the corresponding AID.
    1. Processing the [[ref: KERI event stream]] of the AID, the generation algorithm MUST read the AID [[ref: KEL]] and any anchored [[ref: TELs]] to produce the DID document. 
1. `did:webs` DID documents MUST be pure JSON. They MAY be processed as JSON-LD by prepending an `@context` if consumers of the documents wish.
1. All hashes, cryptographic keys, and signatures MUST be represented as [[ref: CESR]] strings. This is an approach similar to multibase, making them self-describing and terse.

* See the implementors guide for more information about the [[def: KERI event stream chain of custody]]

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

### DID Subject
1. The value of the `id` property in the DID document MUST be the `did:webs` DID that is being created or resolved.
1. The value from the `i` field MUST be the value after the last `:` in the [[ref: method-specific identifier]] ([[ref: MSI]]) of the `did:webs` DID, according to the syntax rules in section [Method-Specific Identifier](#method-specific-identifier).

```json
{
  "id": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
}
```

### DID Controller
1. The value of the `controller` property MUST be a single string that is the same as the `id` (the DID Subject).

```json
{
  "controller": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
}
```

### Also Known As

1. The `alsoKnownAs` property in the root of the DID document MAY contain any DID that has the same AID. See the [[ref: designated aliases]] section for information on how an AID anchors the `alsoKnownAs` identifiers to their [[ref: KERI event stream]].
1. `did:webs` DIDs MUST serve the `did:webs` and corresponding `did:web`as an `alsoKnownAs` identifier.
1. `did:webs` DIDs MUST provide the corresponding `did:keri` as an `alsoKnownAs` identifier.
1. The same AID MAY be associated with multiple `did:webs` DIDs, each with a different [[ref: host]] and/or path, but with the same AID.
1. `did:webs` DIDs MUST be listed in the [[ref: designated aliases]] attestation of the AID.
1. For each [[ref: AID controlled identifier]] DID defined above, an entry in the `alsoKnownAs` array in the DID document MUST be created.

For the example DID `did:webs:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe` the following `alsoKnownAs` entries could be created:
```json
{
  "alsoKnownAs": [
    "did:web:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "did:webs:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "did:web:example.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "did:web:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
    "did:webs:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe"
  ]
}
```

### Verification Methods
1. For each key listed in the array value of the `k` field of the KSN, a corresponding verification method MUST be generated in the DID document.
1. The 'type' property in the verification method for each public key MUST be determined by the algorithm used to generate the public key.
1. The verification method types used MUST be registered in the [DID Specification Registries](https://w3c.github.io/did-spec-registries/#verification-method-types) and added to this specification.
1. The `id` property of the verification method MUST be a relative DID URL and use the KERI key [[ref: CESR]] value as the value of the fragment component, e.g., `"id": "#<identifier>"`.
1. The `controller` property of the verification method MUST be the value of the `id` property of the DID document.

> KERI identifiers express public signing keys as Composable Event Streaming Representation ([[ref: CESR]]) encoded strings in the `k` field of establishment events and the key state notice.  [[ref: CESR]] encoding encapsulates all the information needed to determine the cryptographic algorithm used to generate the key pair.

> At the time of this writing, KERI currently supports public key generation for Ed25519, Secp256k1 and Secp256r1 keys, and the protocol allows for others to be added at any time.

For example, the key `DHr0-I-mMN7h6cLMOTRJkkfPuMd0vgQPrOk4Y3edaHjr` in the DID document for the AID `ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe` becomes:

```json
  "verificationMethod": [
    {"id": "#DHr0-I-mMN7h6cLMOTRJkkfPuMd0vgQPrOk4Y3edaHjr",
    "type": "JsonWebKey",
    "controller": "did:webs:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe", 
    "publicKeyJwk": {
      "kid": "DHr0-I-mMN7h6cLMOTRJkkfPuMd0vgQPrOk4Y3edaHjr", 
      "kty": "OKP", 
      "crv": "Ed25519", 
      "x": "evT4j6Yw3uHpwsw5NEmSR8-4x3S-BA-s6Thjd51oeOs"
      }
    }
  ]
```

#### Ed25519
1. Ed25519 public keys MUST be converted to a verification method with a type of `JsonWebKey` and `publicKeyJwk` property whose value is generated by decoding the [[ref: CESR]] representation of the public key out of the KEL and into its binary form (minus the leading 'B' or 'D' [[ref: CESR]] codes) and generating the corresponding representation of the key in JSON Web Key form.

For example, a KERI AID with only the following inception event in its KEL:
```json
{
  "v":"KERI10JSON00012b_",
  "t":"icp",
  "d":"ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe","i":"ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
  "s":"0",
  "kt":"1",
  "k":["DHr0-I-mMN7h6cLMOTRJkkfPuMd0vgQPrOk4Y3edaHjr"],
  "nt":"1",
  "n":["ELa775aLyane1vdiJEuexP8zrueiIoG995pZPGJiBzGX"],
  "bt":"0",
  "b":[],
  "c":[],
  "a":[]
}
```
would result in a DID document with the following verification methods array:
```json
  "verificationMethod": [
    {
      "id": "#DHr0-I-mMN7h6cLMOTRJkkfPuMd0vgQPrOk4Y3edaHjr", 
      "type": "JsonWebKey", 
      "controller": "did:webs:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe", "publicKeyJwk": {
        "kid": "DHr0-I-mMN7h6cLMOTRJkkfPuMd0vgQPrOk4Y3edaHjr", 
        "kty": "OKP", 
        "crv": "Ed25519", 
        "x": "evT4j6Yw3uHpwsw5NEmSR8-4x3S-BA-s6Thjd51oeOs"
        }
    }
  ]
```

#### Secp256k1
1. Secp256k1 public keys MUST be converted to a verification method with a type of `JsonWebKey` and `publicKeyJwk` property whose value is generated by decoding the [[ref: CESR]] representation of the public key out of the KEL and into its binary form (minus the leading '1AAA' or '1AAB' [[ref: CESR]] codes) and generating the corresponding representation of the key in JSON Web Key form.

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
would result in a DID document with the following verification methods array:

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

#### Thresholds
1. If the current signing keys threshold (the value of the `kt` field) is a string containing a number that is greater than 1, or if it is an array containing fractionally weighted thresholds, then in addition to the verification methods generated according to the rules in the previous sections, another verification method with a type of `ConditionalProof2022` MUST be generated in the DID document. This verification method type is defined [here](https://w3c-ccg.github.io/verifiable-conditions/).
    1. It MUST be constructed according to the following rules:
        1. The `id` property of the verification method MUST be a relative DID URL and use the AID as the value of the fragment component, e.g., `"id": "#<aid>"`.
        1. The `controller` property of the verification method MUST be the value of the `id` property of the DID document. (Does the method spec need to specify this?)
        1. If the value of the `kt` field is a string containing a number that is greater than 1 then the following rules MUST be applied:
            1. The `threshold` property of the verification method MUST be the integer value of the `kt` field in the current key state.
            1. The `conditionThreshold` property of the verification method MUST contain an array. For each key listed in the array value of the `k` field in the key state:
                1. The relative DID URL corresponding to the key MUST be added to the array value of the `conditionThreshold` property.
        1. If the value of the `kt` field is an array containing fractionally weighted thresholds then the following rules MUST be applied:
            1. The `threshold` property of the verification method MUST be half of the lowest common denominator (LCD) of all the fractions in the `kt` array.
            1. The `conditionWeightedThreshold` property of the verification method MUST contain an array. For each key listed in the array value of the `k` field in the key state, and for each corresponding fraction listed in the array value of the `kt` field:
                1. A JSON object MUST be added to the array value of the `conditionWeightedThreshold` property.
                1. The JSON object MUST contain a property `condition` whose value is the relative DID URL corresponding to the key.
                1. The JSON object MUST contain a property `weight` whose value is the numerator of the fraction after it has been expanded over the lowest common denominator (LCD) of all the fractions.

        For example, a KERI AID with only the following inception event in its KEL, and with a `kt` value greater than 1:
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
        results in a DID document with the following verification methods array:
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

        For example, a KERI AID with only the following inception event in its KEL, and a `kt` containing fractionally weighted thresholds:
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
        would result in a DID document with the following verification methods array:

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

### Verification Relationships
1. If the value of `kt` == 1 then the following rules MUST be applied:
    1. For each public key in `k` and its corresponding verification method, two verification relationships MUST be generated in the DID document. One verification relationship of type `authentication` and one verification relationship of type `assertionMethod`.
        1. The `authentication` verification relationship SHALL define that the DID controller can authenticate using each key.
        1. The `assertionMethod` verification relationship SHALL define that the DID controller can express claims using each key.
1. If the value of `kt` > 1 or if the value of `kt` is an array containing fractionally weighted thresholds then the following rules MUST be applied:
    1. For the verification method of type `ConditionalProof2022` (see section [Thresholds](#thresholds)), two verification relationships MUST be generated in the DID document. One verification relationship of type `authentication` and one verification relationship of type `assertionMethod`.
        1. The `authentication` verification relationship SHALL define that the DID controller can authenticate using a combination of multiple keys above the threshold.
        1. The `assertionMethod` verification relationship SHALL define that the DID controller can express claims using a combination of multiple keys above the threshold.
1. References to verification methods in the DID document MUST use the relative form of the identifier, e.g., `"authentication": ["#<identifier>"]`.

> Private keys of a KERI AID can be used to sign a variety of data.  This includes but is not limited to logging into a website, challenge-response exchanges, credential issuances, etc.

For more information, see the [[ref: key agreement]] and [[ref: other key commitments]] section in the Implementors Guide.

### Service Endpoints
1. `did:webs` DIDs MUST support service endpoints, including types declared in the DID Specification Registries, such as [DIDCommMessaging](https://www.w3.org/TR/did-spec-registries/#didcommmessaging).

> For additional details about the mapping between KERI events and the Service Endpoints in the DID Document, see [Service Endpoint KERI events](#service-endpoint-event-details).

> It is important to note that DID document service endpoints are different than the KERI service endpoints detailed in [KERI Service Endpoints as DID Document Metadata](#keri-service-endpoints-as-did-document-metadata).


#### KERI Service Endpoints as DID Document Metadata
1. `did:webs` endpoints MUST be specified using the two data sets KERI uses to define service endpoints; Location Schemes and Endpoint Role Authorizations.
    1. Both MUST be expressed in KERI `rpy` events.
    1. For URL scheme endpoints that an AID has exposed, `did:webs` DIDs MUST use Location Schemes URLs.
    1. For endpoints that relate a role of one AID to another, `did:webs` DIDs MUST use KERI Endpoint Role Authorizations.

    For example, the following `rpy` method declares that the AID `EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1` exposes the URL `http://localhost:3902` for scheme `http`:
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
    For example, the AID listed in `cid` is the source of the authorization, the `role` is the role and the AID listed in the `eid` field is the target of the authorization.  So in this example `EOGL1KGpOnRaZDIB11uZDCkhHs52_MtMXHd7EqUqwtA3` is being authorized as an Agent for `EIDJUg2eR8YGZssffpuqQyiXcRVz2_Gw_fcAVWpUMie1`.
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

1. KERI service endpoints roles beyond `witness` SHOULD be defined using Location Scheme and Endpoint Authorization records in KERI.

The following table contains the current set of endpoint roles in KERI and maps the current roles in KERI to service `type` values in the resulting DID documentsis:
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

TODO: Detail the transformation with an example, for example:
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
TODO:  Propose a new role in KERI to map to the existing [DIDCommMessaging](https://www.w3.org/TR/did-spec-registries/#didcommmessaging) service type declared in DID Specification Registries.

> In KERI, service endpoints are defined by 2 sets of signed data using Best Available Data - Read, Update, Nullify ([[ref: BADA-RUN]]) rules for data processing.  The protocol ensures that all data is signed in transport and at rest and versioned to ensure only the latest signed data is available.

### Transformation to `did:web` DID Document

The DID document that exists as a resource on a webserver is compatible with the `did:web` DID method and therefore necessarily different from a `did:webs` DID document with regard to the `id`, `controller`, and `alsoKnownAs` properties.
1. To transform the `did:web` form of the DID Document to a `did:webs` the transformation MUST do the following:
    1. In the values of the top-level `id` and `controller` properties of the DID document, the transformation MUST replace the `did:webs` prefix string with `did:web`.
    1. In the value of the top-level `alsoKnownAs` property, the transformation MUST replace the entry that is now the new value of the `id` property (using `did:web`) with the old value of the `id` property (using `did:webs`).
    1. All other content of the DID document MUST not be modified.

    For example, this transformation is used during the [Create](#create) DID method operation, given the following `did:webs` DID document:
    ```json
    {
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
            "did:web:example.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:web:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:webs:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe"
        ]
    }
    ```
    the result of the transformation algorithm is the following `did:web` DID document:
    ```json
    {
      "id": "did:web:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
      "verificationMethod": [
          {
              "id": "#DHr0-I-mMN7h6cLMOTRJkkfPuMd0vgQPrOk4Y3edaHjr",
              "type": "JsonWebKey",
              "controller": "did:web:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
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
          "did:webs:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
          "did:web:example.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
          "did:web:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
          "did:webs:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe"
      ]
    }
    ``` 

### Transformation to `did:webs` DID Document

This section defines an inverse transformation algorithm from a `did:web` DID document to a `did:webs` DID document.
1. Given a `did:web` DID document, a transformation to a `did:webs` DID document MUST have the following differences:
    1. The values of the top-level `id` and `controller` properties of the DID document MUST be replaced; the `did:web` prefix string with `did:webs`.
    1. The value of the top-level `alsoKnownAs` property MUST replace the entry that is now the new value of the `id` property (using `did:webs`) with the old value of the `id` property (using `did:web`).
    1. All other content of the DID document MUST not be modificatied.
1. A `did:webs` resolver MUST use this transformation during the [Read (Resolve)](#read-resolve) DID method operation.

    For example, given the following `did:web` DID document:
    ```json
    {
      "id": "did:web:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
      "verificationMethod": [
          {
              "id": "#DHr0-I-mMN7h6cLMOTRJkkfPuMd0vgQPrOk4Y3edaHjr",
              "type": "JsonWebKey",
              "controller": "did:web:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
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
          "did:webs:did-webs-service%3a7676:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
          "did:web:example.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
          "did:web:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
          "did:webs:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe"
      ]
    }
    ```
    the result of the transformation algorithm is the following `did:webs` DID document:
    ```json
    {
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
            "did:web:example.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:web:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe",
            "did:webs:foo.com:ENro7uf0ePmiK3jdTo2YCdXLqW7z7xoP6qhhBou6gBLe"
        ]
    }
    ```

### Full Example
This section is informative.

To walk through a real-world example, please see the GETTING STARTED example of the original [[ref: did:webs Reference Implementation]] as it walks users through many did:webs related examples (and associated KERI commands) to show how they work together.

The following blocks contain fully annotated examples of a KERI AID with two events, an [[ref: inception event]] and an [[ref: interaction event]].
* The [[ref: inception event]] designates some [[ref: witnesses]] in the `b` field.
* The [[ref: inception event]] designates multiple public signing keys in the `k` field.
* The [[ref: inception event]] designates multiple rotation keys in the `n` field.
* The [[ref: interaction event]] cryptographically anchors data associated with the SAID `EoLNCdag8PlHpsIwzbwe7uVNcPE1mTr-e1o9nCIDPWgM`.
* The reply 'rpy' events specify an Agent endpoint, etc.

After the below KERI Event Stream we show the resulting DID document that an implementation would generate assuming the implementation was running on the `example.com` domain with no unique port and no additional path defined:

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
  "didDocument": {
    "id": "did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "alsoKnownAs": [
      "did:web:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
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
  }...
```

### Basic KERI event details
[DID Document from KERI Events](#did-document-from-keri-events) introduced the core [[ref: KERI event stream]] and related DID Document concepts. This section provides additional details regarding the basic types of KERI events and how they relate to the DID document.

#### Key state events
1. When processing the [[ref: KERI event stream]] `did:webs` MUST account for two broad types of key state events (KERI parlance is 'establishment events') that can alter the key state of the AID.
1. Any change in key state of the AID MUST be reflected in the DID document.
1. If a key state event does not commit to a future set of rotation key hashes, then the AID SHALL NOT be rotated to new keys in the future (KERI parlance is that the key state of the AID becomes 'non-transferrable').
1. If a key state event does commit to a future set of rotation key hashes, then any future key state rotation MUST be to those commitment keys. This foundation of [[ref: pre-rotation]] is post-quantum safe and allows the `did:webs` controller to recover from key compromise.
1. The [[ref: Inception event]] MUST be the first event in the [[ref: KEL]] that establishes the AID.  
    1. This MUST define the initial key set
    1. If the controller(s) desire future key rotation (transfer) then the inception event MUST commit to a set of future rotation key hashes.
    1. When processing the [[ref: KERI event stream]], if there are no rotation events after the inception event, then this is the current key state of the AID and MUST be reflected in the DID Document as specified in [Verification Methods](#verification-methods) and [Verification Relationships](#verification-relationships). 
1. [[ref: Rotation events]] MUST come after inception events.
1. If the controller(s) desires future key rotation (transfer) then the rotation event MUST commit to a set of future rotation key hashes.
1. [[ref: Rotation events]] MUST only change the key state to the previously committed to rotation keys.
1. The last rotation event is the current key state of the AID and MUST be reflected in the DID Document as specified in [Verification Methods](#verification-methods) and [Verification Relationships](#verification-relationships).

> You can learn more about the inception event in the [[ref: KERI specification]] and you can see an example inception event.
> To learn about future rotation key commitment, see the sections about [pre-rotation](#pre-rotation) and the [[ref: KERI specification]].

> You can learn more about rotation events in the [[ref: KERI specification]] and you can see an example rotation event.
> To learn about future rotation key commitment, see the sections about [pre-rotation](#pre-rotation) and the [[ref: KERI specification]].

### Delegation KERI event details
This section focuses on delegation relationships between KERI AIDs. [DID Document from KERI Events](#did-document-from-keri-events) introduced the core [[ref: KERI event stream]] and related DID Document concepts. This section provides additional details regarding the basic types of KERI events and how they relate to the DID document. [Basic KERI event details](#basic-keri-event-details) provides additional details on the basic types of KERI events and how they relate to the DID document.

#### Delegation key state events
1. All delegation relationships MUST start with a delegated inception event.
1. Any change to the [[ref: Delegated inception event]] key state or delegated rotation event key state MUST be the result of a delegated rotation event.

> Delegated [[ref: inception event]]: Establishes a delegated identifier. Either the delegator or the delegate can end the delegation commitment.

> Delegated [[ref: rotation event]]: Updates the delegated identifier commitment. Either the delegator or the delegate can end the delegation commitment.

> See the [[ref: KERI specification]] for an example of a delegated inception and rotation events.

### Service Endpoint event details
TODO:  Define and detail the service endpoint events

### Designated Aliases
1. An AID controller SHALL specify the [[ref: designated aliases]] that will be listed in the `equivalentId` and `alsoKnownAs` properties by issuing a [[ref: designated aliases]] verifiable attestation.
    1. This attestation MUST contain a set of [[ref: AID controlled identifiers]] that the AID controller authorizes.
    1. If the identifier is a `did:webs` identifier then it is truly equivalent and MUST be listed in the `equivalentId` property.
    1. If the identifier is a DID then it MUST be listed in the `alsoKnownAs` property.

#### Designated Aliases event details

This is an example [[ref: designated aliases]] [[ref: ACDC]] attestation showing five designated aliases:
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
The resulting DID document based on the [[ref: designated aliases]] attestation above, contains:
* An `equivalentId` metadata for the did:webs:foo.com identifier
* Three `alsoKnownAs` identifiers:
  * the did:webs:foo.com identifier is a [[ref: designated alias]] which is also in the equivalentId did document metadata.
  * the did:web:example.com is a [[ref: designated alias]]
  * NOTE: if the did:keri identifier were automatically generated and included from the AID then that would be a valid designated alias and alsoKnownAs value based on the AID
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
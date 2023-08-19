## DID docs

### Introduction
DID docs in this method are generated or derived from the key state of the
corresponding AID. If the AID in question is [[ref: non-transferrable]], then the
DID doc is generated algorithmically from the DID value itself, and nothing
else. If the AID is [[ref: transferrable]], then the [[ref: KEL]] and the [[ref: TEL]]
are also required inputs to the generation algorithm.

DID docs are processable as pure JSON. Parties who wish to process them as
JSON-LD can do so by referencing [this @context](https://example.com/context).

The algorithm for transforming an AID to a DID doc begins with the same
algorithm as the did:key method. TODO: add info from TEL for service endpoints
and other keys.

Hashes, cryptographic keys, and signatures are represented as CESR strings. This
is an approach similar to multibase, making them self-describing and terse.

### DID doc from the KERI KEL
The key event log [[ref: KEL]] represents a cryptographic chain
of custody from the [[ref: AID]] itself down to the current set of signing keys and next rotation key commitments.  When generating a
DID Document an implementation must "walk the KEL" (follow the chain of key events) to determine the current key state.  Due to the fact that the KERI protocol
allows for non-establishment event (events that don't change key state) to be intermixed in a KEL with establishment
events (those that change key state), the last event may not be an establishment event and thus can not be relied on to
provide key information.  In addition, the current set of witnesses is calculated from the initial set declared in the
inception event and "adds" and "cuts" declared in rotation events.

In KERI the calculated values that result from walking the KEL is refered to as the "current key state" and is expressed
in the Key State Notice (KSN) record.  An example of a KSN can be seen here:

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
in the DID Document.  The following table lists the values from the example KSN and their associated values in a DID Document:

| Key State Field | Definition                                            | DID Document Value                                                                           |
|:---------------:|:------------------------------------------------------|:---------------------------------------------------------------------------------------------| 
|       `i`       | The AID value                                         | The value after the last ":" in the DID (both subject and controller)                        |
|       `k`       | The current set of public signing keys                | Verification Methods with associated authentication and assertion verification relationships |




In several cases above, the value from the key state is not enough by itself to populate the DID Document.  The following
sections detail the algorithm to follow for each case.

#### AID Value
The [[ref: AID]] value is the single string representation of the identfier.  The algorithm used to generate the AID depends on
the type of AID.  If the AID is transferable (supports key rotation) the AID is generated by taking a cryptographic
digest of the inception event of the KEL of the AID.  If the AID is non-transferable (does not support key rotation) the
AID is generated by taking a cryptographic digest of the first (and only) public key of the identifier. See the [[ref: KERI Fundamentals]] section for more details.

The value from the `i` field MUST be the value after the last `:` in the method specific identifier (MSI) of the DID.  The
rest of the MSI is generated using the rules defined in the DID Web Specification regarding hostname, port and path:

The method specific identifier MUST match the common name used in the SSL/TLS certificate, and it MUST NOT include IP
addresses. A port MAY be included and the colon MUST be percent encoded to prevent a conflict with paths.
Directories and subdirectories MAY optionally be included, delimited by colons rather than slashes.

webs-did = "did:webs:" domain-name ":" aid

webs-did = "did:webs:" domain-name * (":" path) ":" aid

#### Also Known as DIDs
It is anticipated that implementations of this DID method will be able to serve the same AID as multiple DIDs, all of which are synonymous for each other.  Any implementation will be able to provide the URL endpoint required to serve any AID it is serving as a did:webs DID as for did:web resolution.  Likewise, any implementation should be able to service any AID it is service as a did:webs DID as a did:keri DID as well.  Finally, the same AID may be served under multiple domains at the same time and they should be considered the same DID since the AID portion of the DIDs are the same.

For each synonymous DID defined above (we need a way in KERI to declare other domains it is being served under, unless this is an implementation specific detail) an entry in the `alsoKnownAs` array in the DID Document should be created.  For the DID `did:webs:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M` the follow `alsoKnownAs` entry could be created:

```json
{
  "alsoKnownAs": [
    "did:web:example.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:webs:foo.com:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M",
    "did:keri:Ew-o5dU5WjDrxDBK4b4HrF82_rYb6MX6xsegjq4n0Y7M"
  ]
}
```

#### Current Set of Public Signing Keys
KERI identifiers express public signing keys as Composable Event Streaming Representation (CESR) encoded strings in the
`k` field of establishment events and the key state notice.  CESR encoding encapsulates all the information needed to
determine the cryptographic algorithm used to generate the key pair.  For each key listed in the array value of the `k` field
a cooresponding Verification Method will be generated in the DID Document.  The 'type' field  in the verification method for each
public key will be determined by the algorithm used to generate the public key.  At the time of this writing, KERI currently
supports public key generation for Ed25519, Secp256k1 and Secp256r1 keys however the protocol allows for others to be added at any time.
We must define the subset of public key algorithms for KERI AIDs that this specification will accept so we can define mappings to existing verification method types as registered in the DID Specification Registries.  As KERI evolves with more algorithms, new verification method types must be registered in the DID Specification Registries and added to this specification.

The `controller` field of the verification method must be the value of the `id` field of DID Document. (Does the method spec need to specify this?)

The `id` field of the verification method must conforms to the rules of DID URL syntax and use the KERI key CESR value as the anchor refernce in the url.  For example, the key `DFkI8OSUd9fnmdDM7wz9o6GT_pJIvw1K_S21AKZg4VwK` in the DID Document for the AID `EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2` becomes:

```
did:webs:example.com:EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2#DFkI8OSUd9fnmdDM7wz9o6GT_pJIvw1K_S21AKZg4VwK
```



##### Ed25519
Ed25519 public keys must be converted to a verification method with a type of `Ed25519VerificationKey2020` with a cooresponding `publicKeyMultibase` field whose value is generated by decoding the CESR representation of the public key out of the KEL into its binary form and re-encoding is as multibase. For example, a KERI AID with only the following inception event in its KEL:

```json
{
  "v": "KERI10JSON0001ad_",
  "t": "icp",
  "d": "EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2",
  "i": "EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2",
  "s": "0",
  "kt": 1,
  "k": [
    "DFkI8OSUd9fnmdDM7wz9o6GT_pJIvw1K_S21AKZg4VwK",
  ]
  // ...  
}
```

would result in a DID Document with the following verification methods array:

```json
  "verificationMethod": [
    {
      "id": "did:webs:example.com:EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2#DFkI8OSUd9fnmdDM7wz9o6GT_pJIvw1K_S21AKZg4VwK",
      "type": "Ed25519VerificationKey2020",
      "controller": "did:webs:example.com:EDP1vHcw_wc4M__Fj53-cJaBnZZASd-aMTaSyWEQ-PC2",
      "publicKeyMultibase": "zFC8PE5Ney3ScmNawy1e1bzXJZQmN7ENGDRy1iPuBPUtr"
    }
  ]
```

##### Secp256k1
Secp256k1 public keys must be converted to a verification method with a type of `EcdsaSecp256k1VerificationKey2019` with a cooresponding `publicKeyJwk` field whose value is generated by decoding the CESR representation of the public key out of the KEL and into its binary form and generating the mapping representation of the key in JSON Web Key form.

TODO: Add example of Secp256k1 key in a KEL and the resultant verification method

##### Verification Relationships
KERI AID public keys can be use to sign a variety of data.  This includes but is not limited to logging into a website, challenge-response exchanges and credential issuances.  It follows that for each public key in `k` two verification relationships must be generated in the DID Document.  One verification relationshp of type `authentication` and one verfication relationship of type `assertionMethod`.  The `authentication` verification relationship defines that the DID subject can authenticate using each key and the `assertionMethod` verification relationship defines that the DID subject can express claims with each key (should we address multisig and thresholds here?).


#### KERI Service Endpoints
In KERI, service endpoints are defined by 2 sets of signed data that follow the Best Available DAta - Read, Update, Nullify (BADA-RUN) (ref?) rules for data processing.  Detailing the rules of BADA-RUN is beyond the scope of this document but to summarize, the protocol ensures that all data is signed in transport and at rest and versioned to ensure only the latest signed data is available.

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


##### KERI Service Endpoints as Services
As defined above in [KERI Service Endpoints](#KERI-Service-Endpoints) service endpoints roles beyond `witness` can be defined using Location Scheme and Endpoint Authorization records in KERI.  This section will map the current roles in KERI to service `type` values in resulting DID Documents and propose a new role in KERI to map to the existing `DIDCommMessaging` service type declared in DID Specification Registries (ref?).

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
Data structures similar to Location Scheme and Endpoint Authorizations and managed in KERI using BADA-RUN could be created that would be used for declaring other types of keys, for example encryption keys, etc

TODO:  Propose new data structures in KERI and Detail the transformation


### Full Example
The following blocks contain full annotated examples of a KERI AID with two events, an inception event and an interaction event, some witnesses, multiple public signing and rotation keys and an Agent with the resulting DID Document that an implementation would generate assuming the implementation was running on the `example.com` domain with no unique port and no additional path defined:

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

Resulting DID Document:
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
  ],
  "authentication": [
    "#1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",
    "#DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",
    "#DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu"
  ],
  "assertionMethod": [
    "#1AAAAg299p5IMvuw71HW_TlbzGq5cVOQ7bRbeDuhheF-DPYk",
    "#DA-vW9ynSkvOWv5e7idtikLANdS6pGO2IHJy7v0rypvE",
    "#DLWJrsKIHrrn1Q1jy2oEi8Bmv6aEcwuyIqgngVf2nNwu"
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
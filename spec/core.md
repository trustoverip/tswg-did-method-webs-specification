## Core Characteristics
This section is normative.

### Method Name

1. The method name that identifies this DID method SHALL be: `webs`.
1. A DID that uses this method MUST begin with the following prefix: `did:webs:`.
1. Per the DID specification, this string MUST be lower case.
1. The remainder of the DID, after the prefix, MUST be the case-sensitive [[ref: method-specific identifier]]
([[ref: MSI]]) described [below](#method-specific-identifier).

> Note: when pronounced aloud, “webs” should become two syllables: the word “web” and the letter “s” (which stands for “secure”). Separating the final letter this way emphasizes that the method offers a security upgrade surpassing the one HTTPS gives to HTTP.

### Method-Specific Identifier

1. The `did:webs` [[ref: method-specific identifier]] MUST have two parts, a [[ref: host]] with an optional path (identical to `did:web`), plus a KERI AID (autonomic identifier) that is always the final component of the path.
1. The [[ref: ABNF]] definition of a `did:webs` DID MUST be as follows:

    ```abnf
    webs-did = "did:webs:" host [pct-encoded-colon port] *(":" path) ":" aid

    ; 'host' as defined in RFC 1035 and RFC 1123
    host = *( ALPHA / DIGIT / "-" / "." )  ; Simplified representation, actual RFCs
                                          ; have more complex rules for domains and IP addresses.
                                          ; IN ACTUAL IMPLEMENTATIONS REPLACE WITH A MATURE 
                                          ; HOST PARSING LIBRARY.

    ; 'pct-encoded-colon' represents a percent-encoded colon
    pct-encoded-colon = "%3A" / "%3a"  ; Percent encoding for ':'

    ; 'port' number (simplified version)
    port = 1*5(DIGIT)

    ; 'path' definition
    path = 1*(ALPHA / DIGIT / "-" / "_" / "~" / "." / "/")

    ; 'aid' as base64 encoded value
    aid = 1*(ALPHA / DIGIT / "+" / "/" / "=") ; Base64 characters

    ; ALPHA, DIGIT are standard ABNF primitives for alphabetic and numeric characters
    ```

1. The [[ref: host]] MUST abide by the formal rules describing valid syntax found in [[ref: RFC1035]], [[ref: RFC1123]], and [[ref: RFC2181]].
1. A port MAY be included and the colon MUST be percent encoded, like `%3a`, to prevent a conflict with paths.
1. Directories and subdirectories MAY optionally be included, delimited by colons rather than slashes.
1. The KERI AID is a unique identifier and MUST be derived from the [[ref: inception event]] of a KERI identifier.

> To be compatible with `did:web`, the AID is "just a path", the final (and perhaps only) path element. The presence of the required AID as a path element means that a `did:webs` always has a path,and so the "no path" version of a `did:web` that implicitly uses the `.well-known` folder is not supported by `did:webs`. Any `did:webs` can be expressed as a `did:web` but the inverse is not true--a `did:webs` must include an AID.

### Target System(s)
1. As with `did:web`, `did:webs` MUST read data from whatever web server is referenced when the [[ref: host]] portion of one of its DID is resolved.
1. A `did:webs` DID MUST resolve to a [[ref: DID document]] using a simple text transformation to an HTTPS URL in the same way as a `did:web` DID.
1. A `did:web` DID and `did:webs` DID with the same [[ref: method-specific identifier]] SHOULD return the same DID document, except for minor differences in the `id`, `controller`, and `alsoKnownAs` top-level properties that pertain to the identifiers themselves.
1. As with `did:web`, the location of the [[ref: DID document]] MUST be determined by transforming the DID to an HTTPS URL as follows:
    1. MUST replace `did:webs` with `https://`
    1. MUST replace the "`:`"s in the method-specific identifier with path separators, "'/'"s
    1. MUST convert the optional port percent encoding ("`%3A`"`) to a colon if present.
    1. MUST append "`/did.json`" to the resulting string.
1. A GET on that URL MUST return the DID document.
1. The location of the [[ref: KERI event stream]] MUST be determined by transforming the previous URL as follows:
    1. MUST replace the trailing "`/did.json`" with "`/keri.cesr`".
    1. A GET on that URL MUST return the [[ref: KERI event stream]] for the AID in the `did:webs` identifier.
    1. The [[ref: KERI event stream]] MUST be [[ref: CESR]]-formatted (media type of application/cesr) and the KERI events must be verifiable using the KERI rules.
1. The `did:web` version of the DIDs MUST be the same (minus the `s`) and point to the same `did.json` file, but have no knowledge of the `keri.cesr` file.

For more information, see the following sections in the implementors guide:
* [[ref: the set of KERI features needed]] to support `did:webs`

> A target system cannot forge or tamper with data protected by KERI, and if it deliberately serves an outdated copy, the duplicity is often detectable. Thus, any given target system in isolation can be viewed by this method as a dumb, untrusted server of content. It is the combination of target systems and some KERI mechanisms, _together_, that constitutes this method's verifiable data registry. In short, verifying the DID document by processing the [[ref: KERI event stream]] using KERI puts the "s" of "security" in `did:webs`.

The following are some example `did:webs` DIDs and their corresponding DID documents and [[ref: KERI event stream]]
URLs, based on the examples from the [[ref: did:web Specification]], but with the (faked) AID
`12124313423525` added:
* `did:webs:w3c-ccg.github.io:12124313423525`
  * The DID document URL would look like: `https://w3c-ccg.github.io/12124313423525/did.json`
  * [[ref: KERI event stream]] URL would look like: `https://w3c-ccg.github.io/12124313423525/keri.cesr`
* `did:webs:w3c-ccg.github.io:user:alice:12124313423525`
  * DID document URL would look like: `https://w3c-ccg.github.io/user/alice/12124313423525/did.json`
  * [[ref: KERI event stream]] URL would look like: `https://w3c-ccg.github.io/user/alice/12124313423525/keri.cesr`
* `did:webs:example.com%3A3000:user:alice:12124313423525`
  * DID document URL would look like: `https://example.com:3000/user/alice/12124313423525/did.json`
  * [[ref: KERI event stream]] URL would look like: `https://example.com:3000/user/alice/12124313423525/keri.cesr`


### AID controlled identifiers
1. [[ref: AID controlled identifiers]] MAY vary in how quickly they reflect the current identity information, DID document and [[ref: KERI event stream]]. Notably, as defined in section [Identifiers in a `did:webs` DID document](#identifiers-in-a-didwebs-did-document), the `id` property in the DID document will differ based on the web location of the DID document.
1. Different versions of the DID document and [[ref: KERI event stream]] MAY reside in different locations depending on the replication capabilities of the controlling entity.
1. If the [[ref: KERI event streams]] differ for `did:webs` DIDs with the same AID, the smaller [[ref: KERI event stream]] MUST be a prefix of the larger [[ref: KERI event stream]] (e.g., the only difference in the [[ref: KERI event streams]] being the extra events in one of the [[ref: KERI event streams]], not yet reflected in the other).
1. If the [[ref: KERI event streams]] diverge from one other (e.g., one is not a subset of the other), both the [[ref: KERI event streams]] and the DIDs MUST be considered invalid.
1. The verification of the [[ref: KERI event stream]] SHOULD provide mechanisms for detecting the forking of the [[ref: KERI event stream]] by using mechanisms such as KERI witnesses and watchers.


> Since an AID is a unique cryptographic identifier that is inseparably bound to the [[ref: KERI event stream]] it is associated with any AIDs and any `did:webs` DIDs that have the same AID component. It can be verifiably proven that they have the same controller(s).

### Handling Web Redirection

1. A `did:webs` MAY be a "stable" (long-lasting) identifier that can be put into documents such as verifiable credentials, to be useful for a very long time -- generations.
1. When a `did:webs` is updated for another location the following rules MUST apply:
    1. Its AID MUST not change.
    1. The same [[ref: KERI event stream]] MUST be used to verify the DID document, with the only change being the [[ref: designated aliases]] list reflecting the new location identifier.
    1. If a resolver can find a newly named DID that uses the same AID, and the [[ref: KERI event stream]] verifies the DID, then the resolver MAY consider the resolution to be successful and should note it in the resolution metadata. 

1. The following resolution paths that `did:webs` identfiers SHALL leverage to help in the face of resolution uncertainty:
    1. The `did:webs` DID SHALL provide other [[ref: designated aliases]] DID(s) that are anchored to the [[ref: KERI event stream]].
    1. When a `did:webs` is permanently moved to some other location the resolver MAY redirect to any other `equivalentId` [[ref: designated aliases]].
        1. The `id` in the DID document MUST be set to the new location.
        1. An `equivalentId` entry of the old location SHOULD remain for historical purposes and anchored to the [[ref: KERI event stream]] using [[ref: designated aliases]]. See section [Use of `equivalentId`](#use-of-equivalentid) for more details.
        1. If possible, the controller of the DID MAY use web redirects to allow resolution of the old location of the DID to the new location.
    1. If the previously published location of a `did:webs` is not redirected, an entity trying to resolve the DID MAY be able to find the data for the DID somewhere else using just the AID.

* The implementors guide contains more information about `did:webs` [[ref: stable identifiers on an unstable web]]. 

### DID Method Operations

#### Create

1. Creating a `did:webs` DID MUST follow these rules:
    1. MUST choose the web URL where the DID document for the DID will be published, excluding the last element that will be the AID, once defined.
    1. MUST create a KERI AID and add it as the last element of the web URL for the DID.
    1. MUST add the appropriate KERI events to the AID's KERI logs that will correspond to properties of the DID document, such as verification methods and service endpoints.
    1. MUST derive the `did:webs` [[ref: DID document]] by processing the [[ref: KERI event stream]] according to section [DID Document from KERI Events](#did-document-from-keri-events).
    1. For compatibility reasons, transformation of the derived `did:webs` DID document to the corresponding `did:web` DID document MUST be according to section [Transformation to did:web DID Document](#transformation-to-didweb-did-document).
    1. MUST create the AID folder on the web server at the selected location, and place the `did:web` DID document resource (`did.json`) and the [[ref: KERI event stream]] resource (`keri.cesr`) into that folder. See section [Target System(s)](#target-systems) for further details about the locations of these resources.

> Of course, the web server that serves the resources when asked might be a simple file server (as implied above) or an active component that generates them dynamically. Further, the publisher of the resources placed on the web can use capabilities like [CDNs] to distribute the resources. How the resources are posted at the required location is not defined by this spec; complying implementations need not support any HTTP methods other than GET.

> An active component might be used by the controller of the DID to automate the process of publishing and updating the DID document and [[ref: KERI event stream]] resources.

#### Read (Resolve)

1. Resolving a `did:webs` DID MUST follow these steps:
    1. MUST convert the `did:webs` DID back to HTTPS URLs as described in section [Target System(s)](#target-systems).
    1. MUST execute HTTP GET requests on both the URL for the DID document (ending in `/did.json`) and the URL for the [[ref: KERI event stream]] (ending in `/keri.cesr`).
    1. MUST process the [[ref: KERI event stream]] using [KERI Rules] to verify it, then derive the `did:webs` [[ref: DID document]] by processing the [[ref: KERI event stream]] according to section [DID Document from KERI Events](#did-document-from-keri-events).
    1. MUST transform the retrieved `did:web` DID document to the corresponding `did:webs` DID document according to section [Transformation to did:webs DID Document](#transformation-to-didwebs-did-document).
    1. MUST verify that the derived `did:webs` DID document equals the transformed DID document.
    1. KERI-aware applications MAY use the [[ref: KERI event stream]] to make use of additional capabilities enabled by the use of KERI.

> Capabilities beyond the verification of the DID document and [[ref: KERI event stream]] are outside the scope of this specification.

#### Update

1. If the AID of the `did:webs` DID is updatable, updates MUST be made to the AID by adding KERI events to
the [[ref: KERI event stream]].
1. Updates to the [[ref: KERI event stream]] that relate to the `did:webs` DID MUST be reflected in the DID Document as soon as possible.
    1. If the `did:webs` DID files are statically hosted then they MUST be republished to the web server, overwriting the existing files.

#### Deactivate

1. To deactivate a `did:webs` DID, A controller SHOULD execute a KERI event that has the effect of rotating the key(s) to null and continue to publish the DID document and [[ref: KERI event stream]].
    1. Once the deactivation events have been applied, the controller SHOULD regenerate the DID document from the [[ref: KERI event stream]] and republish both documents (did.json and keri.cesr) to the web server, overwriting the existing files.
    1. A controller SHOULD NOT remove the DID folder and files from the web server on which it has been published. This is considered to be a bad approach, as those resolving the DID will not be able to determine if the web service is offline or the DID has been deactivated. 
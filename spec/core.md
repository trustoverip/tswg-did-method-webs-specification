## Core Characteristics

### Method Name

The method name that identifies this DID method SHALL be: `webs`.

> Note: when pronounced aloud, "webs" SHOULD become two syllables: the word
> "web" and the letter "s" (which stands for "secure"). Separating the final
> letter this way emphasizes that the method offers a security upgrade analogous
> to the one HTTPS gives to HTTP.

A DID that uses this method MUST begin with the following prefix: `did:webs:`.
Per the DID specification, this string MUST be lower-case. The remainder of the
DID, after the prefix, is the case-sensitive [[ref: method-specific identifier]]
([[ref: MSI]]) described [below](#method-specific-identifier).

### Target System(s)

As with `did:web`, this method reads data from whatever web server is referenced
when the (host+)domain portion of one of its DIDs is resolved through the Domain
Name System (DNS). In fact, a `did:webs` can be resolved to a [[ref: DIDDoc]]
using a simple text transformation to an HTTPS URL in exactly the same way as a
`did:web`. Thus, a `did:web` and `did:webs` with the same [[ref: method-specific
identifier]] will return the same DIDDoc.

::: todo

We need to rename the "KEL" as used here as we need a single file that contains
what KERI calls the KEL and the TEL.

:::

However, this method introduces an important nuance about the target system. In
many DID methods, the target system equals a [[ref: verifiable data registry]] —
besides publishing data, its security attributes make that data trustworthy. In
this DID method, the target system's role is more limited. It is expected to
serve data about the DID, and to follow acknowledged cybersecurity best
practices to preserve good hygiene. However, the authenticity of data is
guaranteed by the DID value itself, in conjunction with a digitally signed JSON
data structure called a [[ref: key event log]] ([[ref: KEL]])  These trust
mechanisms — the integrity checks built into the DID value, and the workings of
the [[ref: KEL]] — are defined by [[ref: KERI]]. The set of KERI features needed
for most `did:webs` use cases is modest, with limited dependencies. These basics
are summarized in the [KERI Fundamentals](#keri-fundamentals) section of this
specification. The rest of this spec assumes a working knowledge of the concepts
there. The inclusion of KERI in `did:webs` enables a number of capabilities for
securing a `did:webs` identifier, including multi-signature support and the
creation of pre-rotated keys to prevent loss of control of the identifier if the
current private key is compromised.

A target system cannot forge or tamper with data protected by KERI, and if it
deliberately serves an outdated copy, the duplicity is often detectable. Thus,
any given target system in isolation can be viewed by this method as a dumb,
untrusted server of content. It is the combination of target systems and some
KERI mechanisms, _together_, that constitutes this method's verifiable data
registry. In short, verifying the DIDDoc by processing the KEL using KERI puts
the "s" in `did:webs`.

### Method-Specific Identifier

The `did:webs` method specific identifier should be considered to have two
parts, a fully qualified domain name with an optional path (identical to
`did:web`), plus a KERI AID (autonomic identifier) that is always the final
component of the path. A KERI AID is a unique-identifier derived from the
inception event of a KERI identifier--the first item in the [[ref: KEL]]. Any
KERI identifier (DIDs or AIDs) that reference the same AID must, by definition,
refer to the same KEL, and hence, be the same identifier. An `did:webs` DIDs
that have the same AID are by definition, synonyms of one another.

The fully qualified domain name is secured by a TLS/SSL certificate with an
optional path. The formal rules describing valid domain name syntax are
described in [RFC1035], [RFC1123], and [RFC2181]. The fully qualified domain
name MUST match the common name used in the SSL/TLS certificate, and MUST NOT
include IP addresses. A port MAY be included and the colon MUST be percent
encoded to prevent a conflict with paths. Directories and subdirectories MAY
optionally be included, delimited by colons rather than slashes.

After the fully qualified domain name and optional path in a `did:webs` is a
final path component, a colon and the AID. To be compatible with `did:web`, the
AID is "just a path", the final (and perhaps only) path element. The presence of
the required AID as a path element means that a `did:webs` always has a path,
and so the "no path" version of a `did:web` that implicitly uses the
`.well-known` folder is not supported by `did:webs`. Any `did:webs` can be
expressed as a `did:web` but the inverse is not true--a `did:webs` MUST include
an AID.

As with `did:web`, the DIDDoc is found by transforming the DID to an
HTTPS URL as follows:

- Replace `did:webs` with `https://`
- Replace the "`:`"s in the method-specific identifier with path separators, "'/'"s
- Convert the optional port percent encoding ("`%3A`"`) to a colon.
- Append "`/did.json`" to the resulting string.

A GET on that URL MUST return the DIDDoc.

Another transformation produces a second URL that is used to retrieve the KERI KEL:

- Replace the trailing "`/did.json`" with "`/did.kel`".

A GET on that URL MUST return the KEL for the AID in the `did:webs` identifier.

After retrieval, the KEL SHOULD BE processed using KERI rules by anyone
resolving the DIDDoc to verify it's contents. Further, KERI-aware applications
MAY use the KEL to make use of additional capabilities enabled by the use of
KERI. Capabilities beyond the verification of the KEL and DIDDoc are outside of
the scope of this specification.

The following are some `did:webs` DIDs and their corresponding DIDDoc and KEL
URLs, based on the examples from the [DID Web Specification], but with the (faked) AID
(`12124313423525`) added:

- `did:webs:w3c-ccg.github.io:12124313423525`
  - DIDDoc URL: https://w3c-ccg.github.io/12124313423525/did.json
  - KEL URL: https://w3c-ccg.github.io/12124313423525/did.kel
- `did:webs:w3c-ccg.github.io:user:alice:12124313423525`
  - DIDDoc URL: https://w3c-ccg.github.io/user/alice/12124313423525/did.json
  - KEL URL: https://w3c-ccg.github.io/user/alice/12124313423525/did.kel
- `did:webs:example.com%3A3000:user:alice:12124313423525`
  - DIDDoc URL: https://example.com:3000/user/alice/12124313423525/did.json
  - KEL URL: https://example.com:3000/user/alice/12124313423525/did.kel

The `did:web` version of the DIDs are the same (minus the `s`) and point
to the same `did.json` file, but have no knowledge of the `did.kel` file.

::: todo
> TODO: what about intl chars? Does DID spec allow them like URL spec does? What
about localhost vs. 127.0.0.1 vs. ::1?
:::

::: todo

TODO: Consider merging this and the next section and propose that an entity
SHOULD only publish one "current" `did:webs`, with defined support for redirects
Copies of a the `did:webs` data should be just that -- copies.

:::

Since an AID is a unique identifier that is inextricably bound to the KEL from
which it is associated, any `did:webs` DIDs that have the same AID component
MUST return an equivalent, although not necessarily identical, DIDDoc and KEL.
Notably, as defined in the [next section](#identifiers-in-a-didwebs-diddoc), the
`id` field in the DIDDoc will differ based the web location of the DIDDoc. As
well, different versions of the DIDDoc and KEL may reside in different locations
depending on the replication capabilities of the controlling entity. If the KELs
differ for `did:webs` DIDs with the same AID, the smaller KEL MUST be a prefix
of the larger KEL (e.g., the only difference in the KELs be extra events in one
of the KELs, not yet reflected in the other). If the KELs diverge from one other
(e.g., one is not a subset of the other), both the KELs and the DIDs MUST be
considered invalid.

The web supports a number of ways to redirect users. Please the section on
[Handling Web Redirections](#) later in this specification.

KERI anticipates the possibility of a duplicitous actor with an AID that forks a
KEL and shares different versions of the KEL containing different events, such
as publishing different versions of the KEL on different web servers. The
verification of the KEL MAY provide mechanisms for detecting such behavior, such
as KERI witnesses and watchers.

### Handling Web Redirection

A `did:webs` is intended to be a "stable" (long-lasting) identifier that can be
put into documents, such as verifiable credentials, that are intended to be
useful for a very long time -- generations. However, the web is not a very
stable place, and documents are moved around and copied frequently. When two or
more companies merge, often the web presence of some of the merged entities
"disappears". It may not be possible to retain a permanent `did:webs` web
location.

When a `did:webs` moves, its AID does not change. The same KEL is used to verify
the DIDDoc. Were the AID to change, it would be an altogether new DID,
unconnected to the first DID. So if a resolver can find a newly named DID that
uses the same AID, and the KEL verifies the DID, then they have resolved the
DID. In fact, a `did:webs` could be moved to use another DID method that uses
the AID for uniqueness and KEL for validity.

The following are the capabilities in `did:webs` to help in the face of
resolution uncertainty.

- The `did:webs` is bound to its location via an event recording in the KEL, and
  as the `id` in the DIDDoc.
- When a `did:webs` is permanently moved to some other location, an event in the
  KEL records the change.
  - The `id` in the DIDDoc is set to the new location.
  - An `AlsoKnownAs` entry is added to the DIDDoc for the old location.
  - If possible, the controller of the DID MAY use web redirects to allow
    resolution of the old location of the DID to the new location.

If the previously published location of a `did:webs` is not redirected, an
entity trying to resolve the DID MAY be able to find the data for the DID
somewhere else using just the AID. Since the AID is globally unique and
references the same identifier, regardless of the rest of the string that is the
full `did:webs`, web searching could yield either the current location of the
DIDDoc, or a copy of the DID that may be useful. For example, even the [Internet
Archive: Wayback Machine](https://archive.org/web) could be used to find a copy
of the DIDDoc and KEL at some point in the past, that may be sufficient for the
purposes of the entity trying to resolve the DID. This specification does not
rely on the Wayback Machine, but it might be a useful DID resolver tool.

The DIDDoc, KEL and other files related to the DID may be cop

### Identifiers in a `did:webs` DIDDoc

Within the DIDDoc of a `did:webs` DID, the following rules are followed:

- The `id` field in the root of the DIDDoc is the `did:webs` DID, reflecting the current combined web location and AID of the identifier.
- The `alsoKnownAs` field in the root of the DIDDoc MAY contain other synonym resolvable `did:webs` DIDs. The `alsoKnownAs` field MAY contain `did:web` versions of the `did:webs` DID(s).
- `id` items elsewhere in the DIDDoc MUST use the relative form of the identifier, e.g., `"id" : "#<identifier>"`.

### Key Material and Document Handling

DID docs for this method are pure JSON. They may be processed as JSON-LD by
prepending an `@context` if consumers of the documents wish.

The KELs are also pure JSON and are processed per the KERI specification rules.

### DID Method Operations

#### Create (Register)

Creating a DID involves these steps:

- Choose the web URL where the DID doc for the DID will be published, excluding
  the last element that will be the AID, once defined.
- Create a KERI AID and add the appropriate KERI events that will (at least)
  produce the DIDDoc. That process is described in the [DIDDoc and KEL](#)
  generation section of this specification.
- Choose the web URL where the DID doc for the DID will be published, including
  the last element of the path, which MUST be the AID.
- Derive the DIDDoc by processing the [[ref: KEL]].
- Create the AID folder on the web server at the selected location, and place
the DIDDoc and KEL files into that folder.

Of course, the web server that serves the files when asked might be a simple
file server (as implied above) or an active component that retrieves them
dynamically. Further, the publisher of the files placed on the web can use
capabilities like [CDNs] to distribute the files.

Likewise, an active component might be used by the controller of the DID to
automate the process of publishing and updating the DIDDoc and KEL.

#### Read (Resolve)

Before a `did:webs` DID can undergo standard resolution, it must be converted
back to an HTTPS URL [as described above](#method-specific-identifier). The
reader then does a GET on both the URL for the DIDDoc (ending in `/did.json`)
and on the URL for the KEL (ending in `/did.kel`)

On receipt of the two documents, the KEL is processed using [KERI Rules] to
verify the validity of the KEL itself, and of the DIDDoc.

#### Update

Updates are made to the AID by adding KERI events to the [[ref: KEL]]. Some of
those events may cause the DIDDoc to be updated. Once a set of events have been
applied, derive the DIDDoc from the KEL and republish both documents to the web
server, overwriting the existing files.

#### Deactivate

Execute a KERI event that has the effect of rotating the key(s) to null. Once
the deactivation events have been applied, derive the DIDDoc from the KEL and
republish both documents to the web server, overwriting the existing files.

A controller may choose to simply remove the DID folder and files from the web
server on which it has been published. This is considered to a bad approach, as
those resolving the DID will not be able to determine if the web service is
offline or the DID has been deactivated. It is a much better practice to rotate
the keys to null and continuing to publish the DIDDoc and KEL.

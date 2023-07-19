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
Name System (DNS).

However, this method introduces an important nuance about the target system. In
many DID methods, the target system equals a [[ref: verifiable data registry]] —
besides publishing data, its security attributes make that data trustworthy. In
this DID method, the target system's role is more limited. It is expected to
serve data about the DID, and to follow acknowledged cybersecurity best
practices to preserve good hygiene. However, the authenticity of data is
guaranteed by the DID value itself, typically in conjunction with a digitally
signed JSON data structure called a [[ref: key event log]] ([[ref: KEL]]).

These trust mechanisms — the integrity checks built into the DID value, and the
workings of the KEL — are defined by [[ref: KERI]]. KERI is a complex technology,
far too rich to explain here. However, the subset of KERI features needed for
most `did:webs` use cases is modest, with limited dependencies. These basics are
summarized in [KERI Fundamentals](#keri-fundamentals). The rest of this spec
assumes a working knowledge of the concepts there.

A target system cannot forge or tamper with data protected by KERI, and if it
deliberately serves an outdated copy, the duplicity is often detectable. Thus,
any given target system in isolation can be viewed by this method as a dumb,
untrusted server of content. It is the combination of target systems and a few
KERI mechanisms, _together_, that constitutes this method's verifiable data
registry.

### Method-Specific Identifier

There are two forms of [[ref: method-specific identifier]] ([[ref: MSI]]) for
`did:webs`. One is _resolvable_; the other is _stable_. The resolvable form is
more common and intuitive.

### Resolvable Form

A [[ref: resolvable]] MSI is constructed by transforming an input called the
[[ref: DID doc URL]] ([[ref: DDURL]]). This MUST be an HTTPS URL that references
a DID doc (either directly, or ultimately, via redirects). The transformation to
MSI must be reversible back to DDURL, because resolving the DID requires clients
to fetch DID docs from the MSI.

The DDURL MUST NOT include a query string (although it could redirect to a URL
that contains one). The DDURL MUST NOT include relative path components ("./" or
"../"). The DDURL MUST NOT include multiple consecutive slashes once the path
portion begins. The DDURL MUST NOT include a fragment OR redirect to a URL that
includes a fragment. It MUST return a resource that the web server identifies in
headers as IANA media type `application/json`. The DDURL and its corresponding
X509 certificate(s) also have some security requirements described
[elsewhere](#security_considerations).

The transformation begins by removing the "https://" prefix from this URL. If
the path portion of the URL consists exactly of "/.well-known/did.json", this
suffix is also removed. If the URL ends in a slash, the final slash is removed.
All remaining slashes in the URL are replaced with colons. If the URL ends with
".json", this suffix is deleted. If the URL includes a port, the colon that
delimits the port number MUST be percent-encoded so colons in the MSI map only
to slashes.

> TODO: what about intl chars? Does DID spec allow them like URL spec does? What
about localhost vs. 127.0.0.1 vs. ::1?

Sample DDURL → MSI → DID transformations:

```
https://example.com/a/b.json → example.com:a:b → did:webs:example.com:a:b
https://192.168.1.55:8080/a/b → 192.168.1.55%3A8080:a:b → did:webs:192.168.1.55%3A8080:a:b
```

### Stable Form

Although URLs are wonderfully useful, they are also notoriously unstable. A DID
defined by a URL can disappear (or acquire an entirely new value with identical
keys) due to URL revisions outside the scope of control of the DID owner -- and
the DID owner might not even be aware. A DID URL can be reused, including by
hackers. In addition, the same content can be hosted at more than one URL (due
to redirects, CDNs, load balancers, NAT, IPv4 vs. IPv6, symbolic links,
/etc/hosts files, intranet DNS overrides, or just redundant publication). This
can create interpretation challenges for DIDs based on URLs.

To avoid ambiguity, the `did:webs` method adds an additional, [[ref: stable]]
form of MSI. This is a special [[ref: CESR]]-encoded string datatype that KERI
calls an [[ref: AID]] ( [[ref: autonomic identifier]]). An AID uniquely and stably
identifies a DID and its DID doc, regardless of where the DID doc is hosted. The
DID doc for any `did:webs` DID MUST store the stable form of the MSI in its
top-level `id` property.

In stable form, `did:webs` MSIs are simply the AID, with no further information.
Combining such an MSI with the prefix produces a [[ref: stable DID]] that look
like this:

<pre class="example" title="sample AID → DID transformation">        EmkPreYpZfFk66jpf3uFv7vklXKhzBrAqjsKAn2EDIPM → did:webs:EmkPreYpZfFk66jpf3uFv7vklXKhzBrAqjsKAn2EDIPM
    </pre>

Stable DIDs don't carry information about how they can be resolved. They are
thus very similar to URNs, and have limited utility for a party who has never
resolved them before. However, they can be resolved if the controller of the DID
passes resolution material directly to the resolver (see [Read
(Resolve)](#read)). Systems that process `did:webs` MAY also store them as a
placeholder, to be resolved later. Since the AIDs in stable DIDs lack any
dependence on web technologies for resolution and discovery, they form the basis
of a potential interoperability strategy with a DID method that works over other
protocols.

Across all time, all `did:webs` DID docs that are identified by the same AID (or
stable DID) MUST be understood to characterize the same DID, and implementations
of this method MUST require them to be logically consistent with one another. On
the other hand, DID docs identified by different AIDs MUST be understood to
characterize different DIDs, even if they are accessed via the same URL (e.g.,
at different times). This makes accidental or deliberate collisions into errors.
Implementations MUST treat them as such (e.g., alerting the user that the
non-stable form of the DID is ambiguous). It also creates the possibility to
publish the same DID in different places; the non-stable forms of each DID are
just synonyms. Internal processing of DID docs (which uses only the stable form)
is deterministic and independent of context that a DID owner may not control.

### Key Material and Document Handling

DID docs for this method are pure JSON. They may be processed as JSON-LD by
prepending an `@context` if consumers of the documents wish.

DID URLs in DID docs MUST be absolute and MUST use the [[ref: stable]] form of the
DID's MSI.

### DID Method Operations

#### Create (Register)

Creating a DID involves these steps:

Create a KERI AID. This process is documented in KERI materials.

Choose a [[ref: DDURL]] where the DID doc for the DID will be published.

Append `.kel` to the DDURL and publish the KEL of the AID at this location.

Derive the DID doc from the KEL and publish it at the DDURL. TODO: how!

#### Read (Resolve)

Before a `did:webs` DID can undergo standard resolution, it must be converted
back to a DDURL. This is done by replacing the "did:webs:" prefix with
https://", converting a percent-encoded port delimiter back to a colon, and
replacing all other colons with slashes. In addition, if the DID includes no
path, then "/.well-known/did.json" is appended.

An HTTP GET is now performed on the DDURL to fetch a DID doc. This operation
MUST follow both temporary and permanent redirects, but MUST break redirect
cycles and MUST NOT allow excessive redirects. The final URL once all redirects
have been followed is called the [[ref: terminal URL]]. If GETting the terminal
URL returns HTTP status code 404, if the terminal url contains a path, and if
the terminal url does not end in ".json", then a client MUST append ".json" to
the terminal URL and make a second attempt to GET the resource with the revised
URL.

Unlike `did:web`, the resolution process is not assumed to produce valid output
simply because a DID doc is returned. The top-level `id` property in the doc
contains a KERI AID rather than the value of the DID itself. DID doc is
analyzed, and If the DID is a A second GET MUST also be performed. This one
fetches the KEL. The URL for the KEL is generated as follows:

1.  Start with the final URL that successfully fetched a DID doc after all
    redirects were followed.
2.  If this URL ends with ".json", change it to end with ".kel.json". Otherwise,
    just append ".kel".

When a DID is converted back into a DDURL for resolution to a DID doc,

TODO: what about OOBIs? TODO: what about resolution against a previous version
TODO: what args are valid in DID URL? TODO: service endpoints TODO: security and
privacy considerations, from did:web TODO: read did:web DNS sections

#### Update

This operation is not possible if the AID uses [[ref: direct mode]]. Otherwise:

1.  Modify the AID's key state or its [[ref: witnesses]] (resulting in an updated
    [[ref: KEL]], and/or its transaction history (resulting in an updated
    [[ref: TEL]]), using KERI mechanisms. This may involve notifying witnesses.
2.  Re-derive the DID doc.
3.  Republish the KEL and the TEL on the website.

#### Deactivate

This operation is only possible if the AID is [[ref: transferrable]]. Simply use
KERI to rotate the key to null (notifying [[ref: witnesses]] if applicable). This
signals the end of the identifier's lifecycle to all stakeholders.

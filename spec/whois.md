## The `whois` Folder

The `did:webs` method defines that a controller MAY place a folder called
`whois` within the root folder of the `did:webs` web location and place into
that [signed files](#signed-files) that are [verifiable credentials] (VCs) or
[verifiable presentations] (VPs) in which the `did:webs` DID is the subject of the
verifiable credential. This convention enables those that have the DID for the
controller to retrieve and verify any VCs or VPs the DID controller has
decided to publish about itself. The intention is that anyone interested in a
particular `did:webs` DID can see if there is a `whois` web folder, and if so,
see if it contains any useful (to the resolver) VCs or VPs that might help
in learning more about the controller of the DID (the subject of the VCs or VPs).

### `whois` Use Case

The following is a use case for this capability. Consider an example of the
`did:webs` controller being an educational institution that issues "degree"
verifiable credentials to its graduate students. A graduate from the school
submits as part of their job application to a company a [verifiable
presentation] derived from the verifiable credential they received from the
school. The company receiving the presentation can verify the cryptography of
the presentation, but can they trust the school that issued the verifiable
credential? If the school issued the verifiable credential using its `did:webs`
DID, the company can resolve the DID (included in the verifiable presentation
from the student), and verify the [[ref: KEL]]. Then it can look in the DID's
`whois` folder where it might find a couple of useful VCs or VPs with the
`did:webs` DID as the subject. For example:

- A verifiable presentation derived from a credential issued by the Legal Entity
  Registrar for the jurisdiction in which the school is headquartered.
  - Since the company knows about the Legal Entity Registrar, they can automate
    the lookup to get more information about the school -- its legal name, when
    it was registered, contact information, etc.
- A verifiable credential issued by the "Association of Colleges and
  Universities" for the jurisdiction of the school.
  - Since they don't know about the Association for that jurisdiction, the company can
    repeat the process for the issuer of _that_ credential. They might (for
    example), learn that the Association has in its `did:webs` `whois` folder a
    verifiable credential issued by the government of the jurisdiction, and
    the company recognizes that government.
- A verifiable presentation derived from a credential issued by US News about
  the school's placement on the [US News Rankings of Colleges and Universities].

Such checks can all be done with a handful of HTTPS requests and the processing
of the verifiable presentations. The result is an efficient, verifiable
credential-based, decentralized, multi-domain trust registry.

[https://www.usnews.com/best-colleges/rankings/national-universities]: https://www.usnews.com/education/best-global-universities

### `whois` folder Conventions

The `whois` folder, if it exists, MUST be directly below the web root folder of
the DID. The [DID URL path] to the folder MUST be `<did:webs DID>/whois`.

The HTTPS path to the `whois` folder MUST be `<HTTPS URL conversion of did:webs
identifier>/whois`. The Web Server that serves the `did:webs` documents MUST
respond to a request for the HTTPS path to the `whois` folder with a list of the
files within the folder so that an entity looking for information about the
controller of the `did:webs` DID can see what verifiable credentials or
verifiable presentations are available for review.

The files in the `whois` folder must be [signed files](#signed-files), each with
an associated [JSON Web Signature] file. The files in the folder must be either
[verifiable credentials] or [verifiable presentations] with the verifiable
credential subject `id` being the `did:webs` DID. If the file is a verifiable
presentation, the verifiable presentation proof must be signed with the
`did:webs` DID key(s). As with any [signed files](#signed-files), the
accompanying [JSON Web Signature] file MUST be signed by the `did:webs` DID
key(s).

::: todo

Rationalize/explain the redundant signature of the subject of the verifiable
credential in a verifiable presentation, and the `signed files` signature of the
controller of the DID in the JWS file beside the verifiable presentation. By
definition, both must come from keys in the the DID, although perhaps at
different points in the history of the DID, and that is verifiable by the
resolver via the KEL/TEL.

:::

The verifiable credential or verifiable presentation format of the files can be
(at least partially) identified by the file extension. The following extensions
are recognized:

- `.jsonld` a W3C Verifiable Credentials Data Model Standard JSON-LD signed with a Data Integrity proof.
- `.jwt`  a W3C Verifiable Credentials Data Model Standard JSON Web Token.

When the files are requested, the web server SHOULD be configured to include
the applicable IANA media types in the response content header.

The naming of the [verifiable credentials] or [verifiable presentations] files
(other than the file extension) is up to the DID controller. A future version of
this specification may define rules that DID controllers should use to make it
easier for those processing the presentations to understand them (issuer,
purpose, etc.). Similarly, verifiable credential issuers and trust communities
may define naming conventions for these files as used in their community. For
example, a registry might be created for the name of a `whois` file as an
"authority to issue" a specific type of credential, for any type of credential.
Or, the Education Community might develop naming conventions specifically for
the authority to issue an education credential.

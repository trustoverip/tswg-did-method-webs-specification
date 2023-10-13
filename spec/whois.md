## The `whois` Folder

The `did:webs` method defines that a controller MAY publish a W3C Verifiable
Credentials Data Model Standard [[ref: Verifiable Presentation]] beside the DID
Doc (`did.json`). The Verifiable Presentation is referenced using the [[ref: DID
URL]] `<did>/whois` and can be resolved using the HTTPS DID path `<DID
URL>/whois`. The Verifiable Presentation MUST ONLY contain Verifiable
Credentials where the `did:webs` DID is the subject of the Credential.

This convention enables those that receive the DID to retrieve and verify the
Verifiable Presentation (and embedded Verifiable Credentials) the DID controller
has decided to publish about itself. The intention is that anyone interested in
a particular `did:webs` DID can see if there is a `whois` Verifiable
Presentation, and if so, see if it contains any useful (to the resolver)
Verifiable Credentials that might help in learning more about who is the
controller of the DID.

### `whois` Use Case

The following is a use case for this capability. Consider an example of the
`did:webs` controller being an educational institution that issues "degree"
verifiable credentials to its graduate students. A graduate from the school
submits as part of their job application to a company a [[ref: Verifiable
Presentation]] derived from the verifiable credential they received from the
school. The company receiving the presentation can verify the cryptography of
the presentation, but can they trust the school that issued the verifiable
credential? If the school issued the verifiable credential using its `did:webs`
DID, the company can resolve the DID. It can also resolve the DID's
`whois` DID URL where it might find VCs from issuers it trusts with the
`did:webs` DID as the subject. For example:

- A verifiable credential issued by the Legal Entity Registrar for the
  jurisdiction in which the school is headquartered.
  - Since the company knows about the Legal Entity Registrar, they can automate
    this lookup to get more information about the school -- its legal name, when
    it was registered, contact information, etc.
- A verifiable credential issued by the "Association of Colleges and
  Universities" for the jurisdiction of the school.
  - Perhaps the company does not know about the Association for that
    jurisdiction. The company can repeat the process for the issuer of _that_
    credential. They might (for example), resolve and verify the `did:webs` DID,
    and then resolve the `whois` DID URL to find a verifiable credential issued
    by the government of the jurisdiction, and the company recognizes and trusts
    that government's authority.
- A verifiable credential issued by US News magazine about the school's
  placement on the [US News Rankings of Colleges and Universities].

Such checks can all be done with a handful of HTTPS requests and the processing
of the verifiable presentation. The result is an efficient, verifiable
credential-based, decentralized, multi-domain trust registry.

[https://www.usnews.com/best-colleges/rankings/national-universities]: https://www.usnews.com/education/best-global-universities

### `whois` DID URL Conventions

The `whois` object, if it exists, MUST be directly beside the `did:json`
file, the DID Document for the DID. The [DID URL path] to the folder MUST be
`<did:webs DID>/whois`.

The HTTPS path to the `whois` folder MUST be `<HTTPS URL conversion of did:webs
identifier>/whois`. The Web Server that serves the `did:webs` documents
MUST respond to a request for the HTTPS `whois` URL the `Verifiable
Presentation` published there by the DID Controller. If the controller of the
`did:webs` DID has not published a `whois` Verifiable Presentation, the Web
Server must respond with an HTTP `404` response ("Not Found").

The resolved `whois` MUST contain [[ref: data URL]] containing the Verifiable Presentation in which the
presentation proof is signed by a key or keys from the current DID Document or a
valid previous version of the DID Document. All of the Verifiable Credentials in the
Verifiable Presentation MUST have the `did:webs` DID as the credential subject.

The Verifiable Presentation may be in one of two formats:

- A W3C Verifiable Credentials Data Model Standard JSON-LD Verifiable
  Presentation signed with a Data Integrity proof.
- `A W3C Verifiable Credentials Data Model Standard JSON Web Token
  Verifiable Presentation.

When the Verifiable Presentation is requested, the [[ref: Data URL]] must
contain the appropriate MIME type of the Verifiable Presentation format.

It is up to the DID Controller to decide to publish a Verifiable Presentation
and if so, which Verifiable Credentials to put into the Verifiable Presentation.

## The `whois` DID URL
This convention enables those that receive the DID to retrieve and verify the verifiable presentation (and embedded Verifiable Credentials) the DID controller has decided to publish about itself. The intention is that anyone interested in a particular `did:webs` DID can see if there is a `whois` Verifiable Presentation, and if so, if it contains any useful (to the resolver) Verifiable Credentials that might help in learning more about who is the controller of the DID.

### `whois` DID URL Conventions
1. The `whois` object, if it exists, MUST be directly beside the `did.json` file, the DID Document for the DID.
1. The [[ref: DID URL path]] to the folder MUST be `<did:webs DID>/whois`.
1. The HTTPS path to the `whois` folder MUST be `<HTTPS URL conversion of did:webs identifier>/whois.vp`.
1. The Web Server that serves the `did:webs` documents MUST respond to a request for the HTTPS `whois` URL the `Verifiable Presentation` published there by the DID Controller.
1. If the controller of the `did:webs` DID has not published a `whois` verifiable presentation, the Web Server must respond with an HTTP `404` response ("Not Found").
1. The resolved `whois` DID URL MUST resolve to a verifiable presentation in which the presentation proof is signed by a key or keys from the current `did:webs` DID Document or a valid previous version of the DID Document.
1. All of the Verifiable Credentials in the verifiable presentation MUST have the `did:webs` DID as the credential subject.
1. The verifiable presentation may be in one of three formats:
    1. A W3C Verifiable Credentials Data Model Standard JSON-LD [[ref: Data Integrity Proof]] Verifiable Presentation.
    1. A W3C Verifiable Credentials Data Model Standard [[ref: JSON Web Token Verifiable Presentation]].
    1. An [[ref: ACDC]] or [[ref: ACDC IPEX]] disclosure.
1. When the verifiable presentation is requested, the resolved object MUST contain the appropriate MIME type of the verifiable presentation format.

> It is up to the DID Controller to decide to publish a verifiable presentation and if so, which Verifiable Credentials to put into the verifiable presentation.

### `whois` Use Case
This section is non-normative.

The following is a use case for this capability. Consider an example of the `did:webs` controller being an educational institution that issues "degree" verifiable credentials to its graduate students. A graduate from the school submits as part of their job application to a company a [[ref: Verifiable Presentation]] derived from the verifiable credential they received from the school. The company receiving the presentation can verify the cryptography of the presentation, but can they trust the school that issued the verifiable credential? If the school issued the verifiable credential using its `did:webs` DID, the company can resolve the DID. It can also resolve the DID's `whois` DID URL where it might find VCs from issuers it trusts with the `did:webs` DID as the subject. For example:

* A verifiable credential issued by the Legal Entity Registrar for the jurisdiction in which the school is headquartered.
  * Since the company knows about the Legal Entity Registrar, they can automate this lookup to get more information about the school from the verifiable credential -- its legal name, when it was registered, contact information, etc.
* A verifiable credential issued by the "Association of Colleges and Universities" for the jurisdiction of the school.
  * Perhaps the company does not know about the Association for that jurisdiction. The company can repeat the `whois` resolution process for the issuer of _that_ credential. The company might (for example), resolve and verify the `did:webs` DID for the Association, and then resolve the `whois` DID URL to find a verifiable credential issued by the government of the jurisdiction. The company recognizes and trusts that government's authority, and so can decide to recognize and trust the Association.
* A verifiable credential issued by US News magazine about the school's placement on th [US News Rankings of Colleges and Universities].

Such checks can all be done with a handful of HTTPS requests and the processing of the DIDs and verifiable presentations. The result is an efficient, verifiable, credential-based, decentralized, multi-domain trust registry.

[US News Rankings of Colleges and Universities](https://www.usnews.com/education/best-global-universities)
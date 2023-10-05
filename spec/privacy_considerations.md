## Privacy Considerations
This section addresses the privacy considerations from [RFC6973](https://datatracker.ietf.org/doc/html/rfc6973) section 5.
For privacy considerations related to web infrastructure, see [`did:web` privacy considerations](https://w3c-ccg.github.io/did-method-web/#security-and-privacy-considerations).
Below we discuss privacy considerations related the KERI infrastructure.

### Surveillance
In KERI, A robust witness network along with consistent witness rotation provides protection from monitoring and association of
an individual's activity inside a KERI network.

### Stored Data Compromise

For resolvers that simply discover the Key State endorsed by another party in a discovery network, caching policies
of that network would guide stored data security considerations.  In the event that a resolver is also the endorsing party,
meaning they have their own KERI identifier and are verifying the KEL and signing the Key State themselves, leveraging the
facilities provided by the KERI protocol (key rotation, witness maintenance, multi-sig) should be used to protect the identities
used to sign the Key State.

### Unsolicited Traffic

DID Documents are not required to provide endpoints and thus not subject to unsolicited traffic.

### Misattribution

This DID Method relies on KERI's duplicity detection to determine when the non-repudiable controller of a DID
has been inconsistent and can no longer be trusted.  This establishment of non-repudiation enables consistent attribution.

### Correlation

The root of trust for KERI identifiers is entropy and therefore offers no direct means of correlation.  In addition, KERI provides
two modes of communication, direct mode and indirect mode.  Direct mode allows for pairwise (n-wise as well) relationships that
can be used to establish private relationships.

TODO: link to KERI docs for additional information about direct and indirect modes.

### Identification

The root of trust for KERI identifiers is entropy and therefore offers no direct means of identification.  In addition, KERI provides
two modes of communication, direct mode and indirect mode.  Direct mode allows for pairwise (n-wise as well) relationships that
can be used to establish private relationships.

TODO: link to KERI docs for additional information regarding prefix generation and for a comparison between Direct and Indirect modes.

### Secondary Use

The Key State made available in the metadata of this DID method is generally available and can be used by any party
to retrieve and verify the state of the KERL for the given identifier.

### Disclosure

No data beyond the Key State for the identifier is provided by this DID method.

### Exclusion

This DID method provides no opportunity for [correlation](#correlation), [identification](#identification) or
[disclosure](#disclosure) and therefore there is no opportunity to exclude the controller from knowing about data that others have
about them.
## Transformations

Some DIDs created with other DID methods can be deterministically transformed into a `did:webs`. This allows identifiers to function transparently in more than a pure `did:webs` ecosystem, and facilitates migration and upgrade. To a lesser extent, equivalency transformations may also be possible the other direction, although potential lossiness in security is a concern.

### `did:key`

A `did:key` can be transformed into a `did:webs` by using its public key as the sole input to an [[ref: inception event]] for a KERI [[ref: direct mode]] AID. Essentially this re-expresses the entropy from `did:key`'s SHA256 hash as the Blake-3 hash of the [[ref: CESR]] encoding of the same key. The result is an AID that has no [[ref: witnesses]] and that cannot rotate keys. Both methods are [[ref: self-certifying]], inception inputs are mappable, and semantics match.

The opposite transformation is also generally valid, with the caveat that KERI supports more key types than `did:key`. As long as the key types map, a KERI direct mode AID can be expressed as a `did:key` with zero information loss.

Theoretically, a [[ref: transferrable]] AID could also be transformed into a `did:key`. However, the conversion would be lossy, because the controller of the AID intends semantics (pre-rotation protections) that `did:key` cannot express. If an AID has witnesses (whether the AID is transferrable or not), there is a similar problem with lost protections. Therefore, this transformation is discouraged as an interop strategy, even if the AID has nothing but an inception event.

### `did:peer`

Since `did:peer` with `numalgo=0` exactly matches the format, semantics, and intent of `did:key`, such peer DIDs have exactly the same transformation potential, in both directions, as `did:key`.

Fancier peer DIDs have a numeric basis other than `numalgo=0`. Static peer DIDs in this category can store service endpoints and additional keys in a DID doc. A `did:webs` can express these same semantics via its [[ref: TEL]]. Thus, static peer DIDs may be transformable to [[ref: non-transferrable]] `did:webs` without witnesses. Dynamic peer DIDs cannot be transformed to a `did:webs` because they are [[ref: transferrable]] yet lack a _next_ key to satisfies KERI's pre-rotation feature.

### Other DIDs using KERI AIDs as MSI

Any DID method that uses uses a KERI [[ref: AID]] as its [[ref: MSI]] is trivially and losslessly transformable in both directions, since the `did:webs` method defines all DID docs with the same AID to be instances of metadata for the same identifier. This could be the basis of future work on a DID method for environments using extremely constrained hardware or exotic transport protocols, for example.

### Additional DID methods

A `did:webs` may also be transformable to or from other DID types as well (e.g., ones using a blockchain as a VDR). However, caveats apply:

| Direction          | Caveats                                                                                                                                                                                                                                                                                                                                            |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| other → `did:webs` | The other method MUST be [[ref: self-certifying]]. The resulting AID will either use [[ref: direct mode]] or be [[ref: non-transferrable]], without [[ref: witnesses]].                                                                                                                                                                            |
| `did:webs` → other | The KEL MUST contain only an inception event. The other method MUST NOT require an inception input that's unavailable to KERI (e.g., a payment address or user handle). The AID MUST be [[ref: non-transferrable]] (unless the other method supports pre-rotation). The AID MUST NOT use weighted multi-sig (unless the other method supports it). |


## Security Characteristics

There are several security characteristics necessary for `did:webs` to sufficiently address the common security threats related to DID methods and documents.

### Common security threats

`did:webs` strives to narrow the attack surface against these common threats:
- Broken Object Level Authorization ([[ref: BOLA]])
- Denial of service (DDoS) attack
- Deletion attack
- Duplicity detection
- Eclipse attack
- Forgery
- Impersonation attack
- Key Compromise attack
- Malleability attack
- Replay attack

### Concepts for securing `did:webs` information

The following security concepts are used to secure the data, files, signatures and other information in `did:webs`. We characterize each concept with high, medium and low security to orient readers to the situational relevance.
We use KEL-backed security for the highest possible security of on-disk storage, but also the most costly because it uses space in KELs. BADA-RUN is medium security and makes sure events are ordered in a consistent way, using a combination of date-time and a key state. Without having to negotiate security in did:webs we use a lower level of security when appropriate.

#### [[def: KEL backed]] data: High Security

KEL backed information in `did:webs` can either be found in the KEL or found anchored to the KEL. This means the signatures on the events in the KEL are strongly bound to the key state at the time the events are entered in the KEL. This provides the strongest guarantee of duplicity evidence so that any verifier is protected. The information is end-verifiable and any evidence of duplicity means do not trust.  
More on detection of various compromises on stale keys and current keys in [More on Security Characteristics](./security_characteristics_more.md) 

The ordering of events in the KEL is strictly verifiable because the KEL is a hash chain (blockchain). All events are end-verifiable. Any data anchored to these events is also end-verifiable. All of these properties are guaranteed when data is anchored to a KEL, i.e., [[ref: KEL backed]]. Any information that wants to be end-verifiablly authentic over time should be at this highest level of security. [[ref: ACDCs]] have this level of security, when anchored to a KEL directly or indirectly through a [[ref: TEL]] that itself is anchored to a KEL.

#### [[def: BADA-RUN]]: Medium Security

[[ref: BADA-RUN]] stands for Best available data acceptance - Read/Update/Nullify and is described in the ToIP KERI [[ref: OOBI specification]]. It makes sure events are ordered in a consistent way, using a combination of date-time and a key state.

The latest event is the one with the latest date-time for the latest key state. This level of security is sufficient for [[ref: discovery]] information because the worst-case attack on discovery information is a DDoS attack where nothing gets discovered. This is because what gets discovered in KERI must be end-verifiable (anchored to a KEL). So a malicious discovery (mal-discovery) is no different than a mis-discovery or a non-discovery.

 The mitigation for such a DDoS attack is to have redundant discovery sources. We use [[ref: BADA-RUN]] for service end-points as discovery mechanisms. Of course we could anchor service endpoints to KELs and make them more secure. All things considered, due to the dynamics of discovery mechanisms we decided to not bloat the KEL with discovery anchors. Because the worst case can be mitigated with redundant discovery, BADA-RUN is a defensible choice.

Monotonicity (or consistent ordering) protects against replay attacks and stale key compromise impersonation attacks. It does not provide strict ordering because there may be missed events and stale events but the *last seen* event always wins. So the only event that is end-verifiable is the last seen event but that event may be stale.

More on detection of various compromises on BADA policy, such as replay attacks and forgery, in [More on Security Characteristics](./security_characteristics_more.md).

Abeit weaker than KEL backing, BADA is a significant performance and security improvment over token based systems. It also has performance advantages over KEL backing. As a result BADA is approapriate for information that does not benefit from verifiable ordering of all data-states but only the latest data-state such as a distributed data-base.

In [[ref: BADA-RUN]], the RUN stands for *Read, Update, Nullify* and is a replacement for CRUD in an API. 
Read in [More on Security Characteristics](./security_characteristics_more.md) why this has proven necessary and adequate to keep up BADA security.

#### [[def: KRAM]]: Low Security

KERI Request Authentication Mechanism (KRAM) is the lowest security requirement and can only be used for ephemeral query/reply mechanisms that protect against replay attacks and key-compromise attacks at the moment, not over time. This is done with [[ref: KRAM]] which is a non-interactive replay attack protection algorithm that uses a sliding window of date-time stamps and key state (similar to the the tuple as in [[ref: BADA-RUN]]) but the date-time is the replier’s not the querier’s. **[[ref: KRAM]] is meant to protect a host** when providing access to information to a client from replay attacks by a malicious client. It is not meant to protect the information provided by the host. For that we must use [[ref: BADA-RUN]] or KEL backing. Thus, by itself [[ref: KRAM]] is not suitable to protect on-disk storage (see [[ref: On-Disk Storage]] section below).

The `did:webs` resolver should be using KRAM to access the service endpoints providing KERI event streams for verification of the DID document. This is part of what makes the local resolver trusted, it must control who has access and KRAM provides the necessary “non-interactive” basis for non-replay attackable access.

### [[def: On-Disk Storage]]

Both KEL-backed and [[ref: BADA-RUN]] are suitable for storing information on disk because both provide a link between the keystate and date-time on some data when a signature by the source of the data was created.
[More on Security Characteristics](./security_characteristics_more.md) elaborates on why [[ref: BADA-RUN]] and [[ref: KRAM]] are too weak for important information if an attacker has access to the database on disk.


In the hierarchy of attack surfaces. Exposure as on disk (unencrypted) is the weakest. Much stronger is exposure that is only in-memory. How various attacks work out in either situations see the matching section in [More on Security Characteristics](./security_characteristics_more.md) 


Often did methods have focused on features that erode security characteristics. The paper [Five DID Attacks](https://github.com/WebOfTrustInfo/rwot11-the-hague/blob/master/final-documents/taking-out-the-crud-five-fabulous-did-attacks.pdf) highlights some attacks to which `did:webs` should NOT be vulnerable. So when a pull request exposes `did:webs` to a known attack, it should not be accepted.

### Alignment of Information to Security Posture

As a general security principle each block of information should have the same security posture for all the sub-blocks. One should not attempt to secure a block of information that mixes security postures across is constituent sub-blocks. The reason is that the security of the block can be no stronger than the weakest security posture of any sub-block in the block. Mixing security postures forces all to have the lowest common denominator security. The only exception to this rule is if the block of information is purely informational for [[ref: discovery]] purposes and where it is expected that each constituent sub-block is meant to be verified independently.

This means that any recipient of such a block information with mixed security postures across its constituent sub-blocks must explode the block into sub-blocks and then independently verify the security of each sub-block. But this is only possible if the authentication factors for each sub-block are provided independently. Usually when information is provided in a block of sub-blocks, only one set of authentication factors are provided for the block as a whole and therefore there is no way to independently verify each sub-block of information.

Unfortunately what happens in practice is that users are led into a false sense of security because they assume that they don’t have to explode and re-verify but merely may accept the lowest common denominator verification on the whole block of information. This creates a harmful problem for down-stream use of the data. A down-stream use of a constituent sub-block doesn’t know that it was not independently verified to its higher level of security. This widens the attack surface to any point of down-stream usage. This is a root cause of the most common type of attack called a [[ref: BOLA]].

#### Applying the concepts

Lets explore the implications of applying these concepts to various `did:webs` elements.

[[ref: KEL backed]] elements in a DID doc simplifies the security concerns. But future discovery features related to endpoints might consider BADA-RUN. For instance, 'whois' data could be used with [[ref: BADA-RUN]] whereas did:web aliases should not because it could lead to an impersonation attack. We could have a DID document that uses [[ref: BADA-RUN]] if we modify the DID CRUD semantics to be RUN semantics without necessarily changing the verbs but by changing the semantics of the verbs. Then any data that fits the security policy of BADA (i.e. where BADA is secure enough) can be stored in a DID document as a database in the sky. For sure this includes service endpoints for discovery. One can sign with CESR or JWS signatures. The payloads are essentially KERI reply messages in terms of the fields (with modifications as needed to be more palatable) but semantically the same. The DID doc just relays those replies. Anyone reading from the DID document is essentially getting a KERI reply message and they then should apply the BADA rules to their local copy of the reply message.

To elaborate, these security concepts point us to modify the DID CRUD semantics to replicate RUN semantics. Create becomes synonymous with Update where Update uses the RUN update. Delete is modified to use the Nullify semantics. Read data is modified so that any recipient of the Read response can apply BADA to its data (Read is a GET). So we map the CRUD of DID docs to RUN for the `did:webs` method. Now you have reasonable security for things like signed data. If its [[ref: KEL backed]] data you could even use an ACDC as a data attestation for that data and the did resolver would become a caching store for ACDCs issued by the AID controller.

Architecturally, a Read (GET) from the did resolver acts like how KERI reply messages are handled for resolving service endpoint discovery from an [[ref: OOBI]]. The query is the read in RUN and so uses KRAM. The reply is the response to the READ request. The controller of the AID updates the DID resolvers cache with updates(unsolicited reply messages). A trustworthy DID resolver applies the BADA rules to any updates it receives. Optionally the DID resolver may apply [[ref: KRAM]] rules to any READ requests to protect it from replay attacks.

In addition, a DID doc can be a discovery mechanism for an ACDC caching server by including an index (label: said) of the SAIDs of the ACDCs held in the resolvers cache.

#### Narrowing the attack surface

The above considerations have lead us to focus on [[ref: KEL Backed]] DID document blocks and data (whois files, signatures, etc) so that the trusted (local) did:webs resolver is secure. Any future features that could leverage [[ref: BADA-RUN]] and [[ref: KRAM]] should be considered carefully according to the above considerations.


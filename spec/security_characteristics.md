## [[def: Security characteristics]]

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
More on detection of various compromises on stale keys and current keys in [[ref: More on security characteristics]]

The ordering of events in the KEL is strictly verifiable because the KEL is a hash chain (blockchain). All events are end-verifiable. Any data anchored to these events is also end-verifiable. All of these properties are guaranteed when data is anchored to a KEL, i.e., [[ref: KEL backed]]. Any information that wants to be end-verifiablly authentic over time should be at this highest level of security. [[ref: ACDCs]] have this level of security, when anchored to a KEL directly or indirectly through a [[ref: TEL]] that itself is anchored to a KEL.

#### [[def: BADA-RUN]]: Medium Security

[[ref: BADA-RUN]] stands for Best available data acceptance - Read/Update/Nullify and is described in the ToIP KERI [[ref: OOBI specification]]. It makes sure events are ordered in a consistent way, using a combination of date-time and a key state.

The latest event is the one with the latest date-time for the latest key state. This level of security is sufficient for [[ref: discovery]] information because the worst-case attack on discovery information is a DDoS attack where nothing gets discovered. This is because what gets discovered in KERI must be end-verifiable (anchored to a KEL). So a malicious discovery (mal-discovery) is no different than a mis-discovery or a non-discovery.

 The mitigation for such a DDoS attack is to have redundant discovery sources. We use [[ref: BADA-RUN]] for service end-points as discovery mechanisms. Of course we could anchor service endpoints to KELs and make them more secure. All things considered, due to the dynamics of discovery mechanisms we decided to not bloat the KEL with discovery anchors. Because the worst case can be mitigated with redundant discovery, BADA-RUN is a defensible choice.

Monotonicity (or consistent ordering) protects against replay attacks and stale key compromise impersonation attacks. It does not provide strict ordering because there may be missed events and stale events but the *last seen* event always wins. So the only event that is end-verifiable is the last seen event but that event may be stale.

More on detection of various compromises on BADA policy, such as replay attacks and forgery, in [[ref: More on security characteristics]].

Abeit weaker than KEL backing, BADA is a significant performance and security improvment over token based systems. It also has performance advantages over KEL backing. As a result BADA is approapriate for information that does not benefit from verifiable ordering of all data-states but only the latest data-state such as a distributed data-base.

In [[ref: BADA-RUN]], the RUN stands for *Read, Update, Nullify* and is a replacement for CRUD in an API. 
Read in [[ref: More on security characteristics]] why this has proven necessary and adequate to keep up BADA security.

#### [[def: KRAM]]: Low Security

KERI Request Authentication Mechanism (KRAM) is the lowest security requirement and can only be used for ephemeral query/reply mechanisms that protect against replay attacks and key-compromise attacks at the moment, not over time. This is done with [[ref: KRAM]] which is a non-interactive replay attack protection algorithm that uses a sliding window of date-time stamps and key state (similar to the the tuple as in [[ref: BADA-RUN]]) but the date-time is the replier’s not the querier’s. **[[ref: KRAM]] is meant to protect a host** when providing access to information to a client from replay attacks by a malicious client. It is not meant to protect the information provided by the host. For that we must use [[ref: BADA-RUN]] or KEL backing. Thus, by itself [[ref: KRAM]] is not suitable to protect on-disk storage (see [[ref: On-Disk Storage]] section below).

The `did:webs` resolver should be using KRAM to access the service endpoints providing KERI event streams for verification of the DID document. This is part of what makes the local resolver trusted, it must control who has access and KRAM provides the necessary “non-interactive” basis for non-replay attackable access.

### [[def: On-Disk Storage]]

Both KEL-backed and [[ref: BADA-RUN]] are suitable for storing information on disk because both provide a link between the keystate and date-time on some data when a signature by the source of the data was created.
[[ref: More on security characteristics]] elaborates on why [[ref: BADA-RUN]] and [[ref: KRAM]] are too weak for important information if an attacker has access to the database on disk.


In the hierarchy of attack surfaces. Exposure as on disk (unencrypted) is the weakest. Much stronger is exposure that is only in-memory. How various attacks work out in either situations see the matching section in [[ref: More on security characteristics]]. 


Often did methods have focused on features that erode security characteristics. The paper [Five DID Attacks](https://github.com/WebOfTrustInfo/rwot11-the-hague/blob/master/final-documents/taking-out-the-crud-five-fabulous-did-attacks.pdf) highlights some attacks to which `did:webs` should NOT be vulnerable. So when a pull request exposes `did:webs` to a known attack, it should not be accepted.

### Alignment of Information to Security Posture

As a general security principle each block of information should have the same security posture for all the sub-blocks. One should not attempt to secure a block of information that mixes security postures across is constituent sub-blocks. The reason is that the security of the block can be no stronger than the weakest security posture of any sub-block in the block. Mixing security postures forces all to have the lowest common denominator security. The only exception to this rule is if the block of information is purely informational for [[ref: discovery]] purposes and where it is expected that each constituent sub-block is meant to be verified independently.

See [[ref: More on security characteristics]] for what happens when mixing of security postures takes place and the most common associated attack: [[ref: BOLA]].

#### Applying the concepts

Lets briefly explore the implications of applying these security concepts to various `did:webs` elements.

[[ref: KEL backed]] elements in a DID doc simplifies the security concerns. However, future discovery features related to endpoints might consider BADA-RUN. In the latter case anyone reading from the DID document is essentially getting a KERI reply message and they then should apply the BADA rules to their local copy of the reply message. How it's done: we map the *CRUD* of DID docs to *RUN* for the `did:webs` method.  
See [[ref: More on security characteristics]] for an in-depth explanation of this mechanism.

#### Narrowing the attack surface

All considered has lead us to focus on [[ref: KEL Backed]] DID document blocks and data (whois files, signatures, etc) so that the trusted (local) did:webs resolver is secure. Any future features that could leverage [[ref: BADA-RUN]] and [[ref: KRAM]] should be considered carefully according to the above considerations.


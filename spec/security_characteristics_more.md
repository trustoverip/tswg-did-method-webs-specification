## Addendum: [[def: More on security characteristics]]

The elaboration below combines well with [[ref: Security characteristics]] above.

### KEL backed data: High Security

KEL backed information in `did:webs` can either be found in the KEL or found anchored to the KEL.

A key compromise of a stale key can not result in an exploit because that would require forging an alternate version of the KEL which would be exposed as duplicity. Key compromise of the current key state is recoverable with a rotation to the pre-rotated key(s) (single-sig or multi-sig).  
Although individual public-private key pairs are most probably not post-quantum proof, by design the pre-rotation mechanism in KERI is post-quantum proof; which means that in the projected future presence of quantum computers KERI will still be safe. Basically, this safety is established by rotating keys before a brute force quantum attack can be effective. As quantum computers might get faster or more effective over time, the rotation intervals simply become shorter in combination with an increase in entropy used for key generation.  
A compromise of a current key state is guaranteed to be detectable by the AID’s controller because the compromise requires publication of a new KEL event in infrastructure (i.e. witnesses) controlled by the AID controller. This limits the exposure of a successful compromise of the current key state to the time it takes for the AID controller to observe the compromised publication and execute a recovery rotation.

You rotate keys before a brute force quantum attack can be effective, so you shorten the time frame of rotation as quantum computers get faster. Shall I add such a description to the addendum text in one sentence? Btw: The rest of the text is Sam's.

Tip
Contributor
@swcurran swcurran 16 hours ago
If it were me :-) — I would add a simple description of how pre-rotation works (less about why), how it is post quantum proof, and point to the KERI spec. for more details. Let’s keep this spec. simple.

### BADA-RUN: Medium Security

BADA policy provides guarantees that the latest data-state cannot be compromised via a replay of an earlier data-state where early is determined by the monotonicity of the associated (date-time, key state) tuple. It also protects against forgery of new data-state given the compromise of any state key state. It does not protect against the forgery of new data-state, given a compromise of the _current_ key state. It does not provide ordering of all data-states but ensures that the data-state _last seen_ by a given verifier cannot be replaced with an earlier data-state without compromising either the latest key state of the source or by compromising the storage of the verifier.

To reiterate, because the monotonic (date-time, key state) tuple includes key state, then a verifier is protected from any compromise of an earlier key state relative to that which has been last seen by a verifier.

To elaborate, the only key-compromise that can succeed is that which corresponds to the latest key state seen by the verifier. The exposure to exploit of the source’s latest key state is then bounded by the time it takes for the source to detect key compromise and then perform a rotation recovery. An eco-system governance framework could impose liability on the source for any compromise of the latest data-state for a given latest key state since it is entirely under the control of the source to protect its key state from compromise. The difference between BADA and KEL backing is that with KEL backed update a compromise of the current key state is always detectable because the attacker must publish a new event to the KEL on infrastructure (such as witnesses) controlled by the AID’s legitimate controller. Whereas with BADA there is no mechanism that guarantees the AID’s legitimate controller can detect that its current key has been compromised.

One way to mitigate this exploit (non-detectability of current key state compromise) is to periodically KEL anchor a batch of BADA signed data. This then imposes a maximum time for exploit of the current signing key state. Any BADA verified data that is the latest seen data by a verifier but whose time stamp is older than the current batch time period window could then be reverified against the batch anchor for its appropriate time window. If that data is not included in its time window’s batch anchor then this could be flagged by the verifier as likely duplicitous data and the verifier would not trust and could re-request an update from the AID controller. This is a hybrid of KEL-backed and BADA-RUN security.

To elaborate, because BADA only protects that latest data-state it is only appropriate for data where only the latest data-state is important. Unlike token based systems, however, BADA does not invalidate all latest data-states every time the key state is updated (rotated) where such invalidation would thereby force a refresh of all latest data-states. This property of not forcing auto-invalidation upon key rotation makes BADA suitable for asynchronous broadcast or gossip of the latest data-state in support of an authenticatable distributed data base. Whereas the forced auto-invalidation of data-state with token based systems limit their usefulness to access control applications (e.g. not data-bases). With BADA, however, an update of data-state only automatically auto-invalidates prior data-states. But that means that it is not useful for verifiable credentials or similar applications that must have verifiable provenance of old data-states. For example when old data-states must still be valid such as a credential issued under a now stale key state that must still be valid unless explicitly revoked.

#### Why replacement of CRUD by RUN in BADA security?
In BADA-RUN, the RUN stands for *Read, Update, Nullify* and is a replacement for CRUD in an API. 

CRUD does not protect from replay attacks on the data-state because a delete erases any record of last seen which destroys the monotonicity of the (date-time, key state) tuple. Likewise *Create* makes no sense because the API host cannot create a record; only the remote client can. Moreover, the function of a secure BADA *Update* must account for both first seen and last seen so a *Create* verb would be entirely superflous. Nullify deactivates a record without losing the consistent ordering (monotonicy) of update guarantee. RUN provides the appropriate verbs for any API that applies the security gurantees of a BADA policy to the data-state of its records.

### On-Disk Storage


BADA-RUN is too weak for important information because an attacker who has access to the database on disk can overwrite data on disk without being detected by a verifier hosting the on-disk data either through a replay of stale data (data regression attack) or if in addition to disk access the attacker has compromised a given key state, then the attacker can forge new data with a new date-time stamp for a given compromised key and do a regression attack so that the last seen key state is the compromised key state.

With BADA, protection from a deletion (regression) attack requires redundant disk storage. At any point in time where there is a suspicion of loss of custody of the disk, a comparison to the redundant disks is made and if any disk has a later event given BADA-RUN rules then recovery from the deletion attack is possible.

KRAM on a query is not usable for on disk storage by itself. Because its just a bare signature (the datetime is not of the querier but of the host at the time of a query). But the reply to a query can be stored on disk if the querier applies BADA to the reply. To elaborate, Data obtained via a KRAMed query-reply may be protected on-disk by being using BADA on the reply. This is how KERI stores service endpoints. But KERI currently only uses BADA for discovery data not more important data. More important data should be wrapped (containerized) in an ACDC that is KEL backed and then stored on-disk.

In the hierarchy of attack surfaces. Exposure as on disk (unencrypted) is the weakest. Much stronger is exposure that is only in-memory.

To attack in-memory usually means compromising the code supply chain which is harder than merely gaining disk access. Encrypting data on disk does not necessarily solve attacks that require a key compromise (because decryption keys can be compromised) and it does not prevent a deletion attack. Encryption does not provide authentication protection. But encryption does protect the confidentiality of data.

The use of DH key exchange as a weak form of authentication is no more secure than an HMAC for authentication. Its sharing secrets and anyone with the secret can impersonate any other member of the group that has the shared secret.

### Alignment of Information to Security Posture

As a general security principle each block of information should have the same security posture for all the sub-blocks. 

This means that any recipient of such a block information with mixed security postures across its constituent sub-blocks must explode the block into sub-blocks and then independently verify the security of each sub-block. But this is only possible if the authentication factors for each sub-block are provided independently. Usually when information is provided in a block of sub-blocks, only one set of authentication factors are provided for the block as a whole and therefore there is no way to independently verify each sub-block of information.

Unfortunately what happens in practice is that users are led into a false sense of security because they assume that they don’t have to explode and re-verify but merely may accept the lowest common denominator verification on the whole block of information. This creates a harmful problem for down-stream use of the data. A down-stream use of a constituent sub-block doesn’t know that it was not independently verified to its higher level of security. This widens the attack surface to any point of down-stream usage. This is a root cause of the most common type of attack called a BOLA: broken object level authorization.

#### Applying the concepts

KEL backed elements in a DID doc simplifies the security concerns. But future discovery features related to endpoints might consider BADA-RUN. For instance, 'whois' data could be used with BADA-RUN whereas did:web aliases should not, because it could lead to an impersonation attack. We could have a DID document that uses BADA-RUN if we modify the DID CRUD semantics to be RUN semantics without necessarily changing the verbs but by changing the semantics of the verbs. Then any data that fits the security policy of BADA (i.e. where BADA is secure enough) can be stored in a DID document as a database in the sky. For sure this includes service endpoints for discovery. One can sign with CESR or JWS signatures. The payloads are essentially KERI reply messages in terms of the fields (with modifications as needed to be more palatable) but semantically the same. The DID doc just relays those replies. Anyone reading from the DID document is essentially getting a KERI reply message and they then should apply the BADA rules to their local copy of the reply message.

To elaborate, these security concepts point us to modify the DID CRUD semantics to replicate RUN semantics. *Create* becomes synonymous with *Update* where Update uses the RUN update. *Delete* is modified to use the *Nullify* semantics. *Read* data is modified so that any recipient of the *Read* response can apply BADA to its data (Read is a GET). So we map the CRUD of DID docs to RUN for the `did:webs` method. Now you have reasonable security for things like signed data. If its KEL backed data you could even use an ACDC as a data attestation for that data and the did resolver would become a caching store for ACDCs issued by the AID controller.

Architecturally, a Read (GET) from the did resolver acts like how KERI reply messages are handled for resolving service endpoint discovery from an OOBI. The query is the read in RUN and so uses KRAM. The reply is the response to the READ request. The controller of the AID updates the DID resolvers cache with updates(unsolicited reply messages). A trustworthy DID resolver applies the BADA rules to any updates it receives. Optionally the DID resolver may apply KRAM rules to any READ requests to protect it from replay attacks.

In addition, a DID doc can be a discovery mechanism for an ACDC caching server by including an index (label: said) of the SAIDs of the ACDCs held in the resolvers cache.

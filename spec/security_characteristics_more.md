## More on Security Characteristics

The elaboration below combine with [Security Characteristics](./security_characteristics.md)

### KEL backed data: High Security

KEL backed information in `did:webs` can either be found in the KEL or found anchored to the KEL.

A key compromise of a stale key can not result in an exploit because that would require forging an alternate version of the KEL which would be exposed as duplicity. Key compromise of the current key state is recoverable with a rotation to the pre-rotated key(s) (single-sig or multi-sig). By design pre-rotated keys are post-quantum proof. A compromise of a current key state is guaranteed to be detectable by the AID’s controller because the compromise requires publication of a new KEL event in infrastructure (i.e. witnesses) controlled by the AID controller. This limits the exposure of a successful compromise of the current key state to the time it takes for the AID controller to observe the compromised publication and execute a recovery rotation.

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
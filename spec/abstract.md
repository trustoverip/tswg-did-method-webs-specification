## Abstract

This document specifies a [DID
Method](https://w3c-ccg.github.io/did-spec/#specific-did-method-schemes),
`did:webs`, that is web-based but also highly and innovatively secure. Like its
predecessor, [`did:web`](https://w3c-ccg.github.io/did-method-web/), the
`did:webs` method uses websites and popular, mature tooling to publish DIDs and
make them discoverable. Unlike `did:web`, this method's trust is not rooted in
DNS, webmasters, X509, and certificate authorities. Instead, it derives from
meticulous usage of cryptographic keys by those who control identifiers.

The `did:webs` method does not need blockchains for trust. However, it can
reference arbitrary blockchains as an extra, optional publication mechanism.
This offers an interoperability bridge from (or between) blockchain ecosystems.
Also, without directly supporting environments where the web is not practical
(e.g., IOT, Lo-Ra, BlueTooth, NFC), the method builds on a foundation that fully
supports those environments, making future interop of identifiers between web
and non-web an easy step.

All DID methods make tradeoffs. The ones in `did:webs` result in a method that
is cheap, easy to implement, and scalable. No exotic or unproven cryptography is
required. Deployment is trivial. Cryptographic trust is strongly decentralized,
and governance is transparent. Regulatory quandaries vanish. Any tech community
or legal jurisdiction can use it. However, `did:webs` _does_ depend on the web
for publication and discovery. This may color its decentralization and privacy.
It adds a new component to the tech stack, imposing a modest learning curve as a
result. For users, the method also raises the bar of accountability,
thoughtfulness, and autonomy; this can be viewed as either a drawback or a
benefit (or both).

## Abstract

This document specifies a [DID
Method](https://www.w3.org/TR/did-1.0/#methods),
`did:webs`, that is web-based but innovatively secure. Like its
interoperable cousin, [`did:web`](https://w3c-ccg.github.io/did-method-web/), the
`did:webs` method uses traditional web infrastructure to publish DIDs and
make them discoverable. Unlike `did:web`, this method's trust is not rooted in
DNS, webmasters, X509, and certificate authorities. Instead, it uses [[ref:
KERI]] to provide a secure chain of cryptographic key events by those who
control the identifier.

The `did:webs` method does not need blockchains to establish trust. However, its use of
KERI allows for arbitrary blockchains to be referenced as an extra, optional
publication mechanism. This offers a potentital interoperability bridge from (or between)
blockchain ecosystems. Also, without directly supporting environments where the
web is not practical (e.g., IOT, Lo-Ra, Bluetooth, NFC), the method builds on a
foundation that can fully support those environments, making future interop of
identifiers between web and non-web a manageable step for users of `did:webs` identifiers.

All DID methods make tradeoffs. The ones in `did:webs` result in a method that
is cheap, easy to implement, and scalable. No exotic or unproven cryptography is
required. Deployment is straightforward. Cryptographic trust is strongly
decentralized and governance is transparent. Regulatory challenges around the issue of
blockchains vanish. Any tech community or legal jurisdiction can use it. However,
`did:webs` _does_ depend on the web for publication and discovery. This may
color its decentralization and privacy. For its security, it adds [[ref: KERI]],
imposing a modest - to significant learning curve as a result. For users, the method also raises
the bar of accountability, thoughtfulness, and autonomy; this can be viewed as
either a drawback or a benefit (or both).
## Introduction

DID methods answer many questions. Two noteworthy ones are:

*   How is information about DIDs (in the form of DID documents) published and discovered?
*   How is the trustworthiness of this information evaluated?

The previously released `did:web` method merges these two questions, giving one answer: _Information is published and secured using familiar web mechanisms_. This has wonderful adoption benefits, because the processes and tooling are familiar to millions of developers.

Unfortunately, that answer works better for the first question than the second. The current web is simply not very trustworthy. Websites get hacked. Sysadmins are sometimes malicious. DNS can be hijacked. X509 certs often prove less than clients wish. Browser validation checks are imperfect. Different certificate authorities have different quality standards. The processes that browser vendors use to pre-approve certificate authorities in browsers are opaque and centralized. TLS is susceptible to man-in-the-middle attacks on intranets with customized certificate chains. Governance is weak and inconsistent...

Furthermore, familiar web mechanisms are almost always operated by corporate IT staff. This makes them an awkward fit for the ideal of decentralized autonomy — even if individuals can publish a DID on IT's web servers, those individuals are at the mercy of IT for their security.

The `did:webs` method described in this spec separates these two questions, and gives them different answers. _Information about DIDs_ is still published on the web, but _its trustworthiness_ derives from mechanisms entirely governed by individual DID controllers. This preserves most of the delightful convenience of `did:web`, while drastically upgrading security and decentralized trust.
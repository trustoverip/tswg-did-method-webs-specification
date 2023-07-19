## DID docs

DID docs in this method are generated or derived from the key state of the
corresponding AID. If the AID in question is [[ref: non-transferrable]], then the
DID doc is generated algorithmically from the DID value itself, and nothing
else. If the AID is [[ref: transferrable]], then the [[ref: KEL]] and the [[ref: TEL]]
are also required inputs to the generation algorithm.

DID docs are processable as pure JSON. Parties who wish to process them as
JSON-LD can do so by referencing [this @context](https://example.com/context).

The algorithm for transforming an AID to a DID doc begins with the same
algorithm as the did:key method. TODO: add info from TEL for service endpoints
and other keys.

Hashes, cryptographic keys, and signatures are represented as CESR strings. This
is an approach similar to multibase, making them self-describing and terse.

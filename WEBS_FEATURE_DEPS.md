Here we detail the decision tree of the security related features that `did:webs` users should consider to determine what features they need to build their secure identity with `did:webs`:

```mermaid
%%{init: {'theme':'neutral'}}%%
graph
    CORESEC[Core did:webs security features];
    COREDISC[Core discovery features];
    OPSEC([Optional did:webs security features]);
    OPDISC([Optional discovery features]);

    DTREE{Graph of dependencies for did:webs feature choices} --> AROT;
    DTREE --> CROT;
    AROT{Administrative Root-Of-Trust} --> WID{Web Identifier};
    CROT{Cryptographic Root-Of-Trust} --> SCID{Self-Certifying Identifier};
    WID --> DIDWEB[did:web];
    DIDWEB --> X509[X.509, TLS, CA/Browser Forum];
    SCID --> AID[KERI AID];
    SCID --> DIDWS[did:webs];
    DIDWS --> AID;
    AID --> KEL[Key event log];
    AID --> END([Service Endpoints]);
    KEL --> KHIST[Key History];
    K -.-> ENCRYPT([Encryption]);
    KHIST --> K[Current Keys];
    K --> sK[Signature Key];
    sK --> mK([Additional Signature Keys]);
    KHIST --> nK([Next Keys]);
    nK --> sK;
    KEL --> BACK([Distributed Receipts]);
    BACK --> WIT([Witnesses]);
    mK --> sTHRESH([Thresholded]);
    mK --> sWEIGHT([Weighted]);
    KEL --> THIST([Transaction History]);
    THIST --> KOTHER([Other Keys]);
    THIST --> CRED([Credentials]);
    CRED([Credentials]) --> WHOIS([whois]);
    CRED --> DALIAS([Designated Aliases]);
    DALIAS --> EQUIVID([Equivalent Identifiers]);
    DALIAS --> AKA([Also Known As]);
    DALIAS --> REDIRECT([Redirects]);
    END --> DIDCOMM([DIDComm]);
    END --> ENDOTHER([Other Endpoints]);
    END --> AGENT([Agent]);
    END --> MAIL([Mailbox]);

    style AROT fill:#FF6;
    style X509 fill:#FF6;
    style DIDWEB fill:#FF6;
    style CROT fill:#080;
    style WID fill:#FF6;
    style SCID fill:#080;
    style DIDWS fill:#080;
    style KHIST fill:#080;
    style THIST fill:#44F;
    style AID fill:#080;
    style KEL fill:#080;
    style END fill:#FF6;
    style K fill:#080;
    style sK fill:#080;
    style mK fill:#44F;
    style nK fill:#44F;
    style BACK fill:#44F;
    style WIT fill:#44F;
    style sTHRESH fill:#44F;
    style sWEIGHT fill:#44F;
    style CRED fill:#44F;
    style DALIAS fill:#44F;
    style AKA fill:#44F;
    style EQUIVID fill:#44F;
    style REDIRECT fill:#44F;
    style WHOIS fill:#44F;
    style DIDCOMM fill:#FF6;
    style ENDOTHER fill:#FF6;
    style AGENT fill:#FF6;
    style MAIL fill:#FF6;
    style ENCRYPT fill:#44F;
    style KOTHER fill:#44F;

    style CORESEC fill:#080;
    style COREDISC fill:#ff6;
    style OPSEC fill:#44F;
    style OPDISC fill:#ff6;
```
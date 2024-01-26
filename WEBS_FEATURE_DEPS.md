Here we detail the decision tree of the security related features that `did:webs` users should consider to determine what features they need to build their secure identity with `did:webs`:

```mermaid
%%{init: {'theme':'neutral'}}%%
graph
    L1[Green - Core did:webs security features];
    L2[Yellow - Discovery only features];
    L3[Blue - Additonal did:webs security features];

    DTREE{Graph of dependencies for did:webs feature choices} --> AROT;
    DTREE --> CROT;
    AROT{Administrative Root-Of-Trust} --> WID[Web Identifier];
    CROT{Cryptographic Root-Of-Trust} --> SCID[Self-Certifying Identifier];
    WID --> X509;
    X509[X.509, TLS, CA/Browser Forum] --> DIDWEB[did:web];
    SCID --> AID[KERI AID];
    SCID --> DIDWS[did:webs];
    DIDWS --> AID;
    DIDWS -.-> DIDWEB;
    AID --> KEL[Key event log];
    AID --> END[Service Endpoints];
    KEL --> KHIST[Key History];
    K -.-> ENCRYPT[Encryption];
    KHIST --> K[Current Keys];
    K --> sK[Signature Key];
    sK --> mK[Additional Signature Keys];
    KHIST --> nK[Next Keys];
    nK --> sK;
    KEL --> BACK[Distributed Receipts];
    BACK --> WIT[Witnesses];
    mK --> sTHRESH[Thresholded];
    mK --> sWEIGHT[Weighted];
    KEL --> THIST[Transaction History];
    THIST --> KOTHER[Other Keys];
    THIST --> CRED[Credentials];
    CRED[Credentials] --> WHOIS[whois];
    CRED[Credentials] --> DALIAS[Designated Aliases];
    DALIAS[Designated Aliases] --> EQUIVID[Equivalent Identifiers];
    DALIAS[Designated Aliases] --> AKA[Also Known As];
    DALIAS[Designated Aliases] --> REDIRECT[Redirects];
    END --> DIDCOMM[DIDComm];
    END --> ENDOTHER[Other Endpoints];
    END --> AGENT[Agent];
    END --> MAIL[Mailbox];

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
    style sK fill:#44F;
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
    style DIDCOMM fill:#44F;
    style ENDOTHER fill:#44F;
    style AGENT fill:#44F;
    style MAIL fill:#44F;
    style ENCRYPT fill:#44F;
    style KOTHER fill:#44F;

    style L1 fill:#008000,stroke:#333,stroke-width:2px;
    style L2 fill:#ff6,stroke:#333,stroke-width:2px;
    style L3 fill:#44F,stroke:#333,stroke-width:2px;
```
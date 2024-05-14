---
keywords: [Heavymeta, motoko, internet identity, authentication]
---

# Heavymeta NFT Minter Template 

[This Template is based on this sample's code on GitHub](https://github.com/dfinity/examples/tree/master/motoko/internet_identity_integration)

## Overview

This template will be downloaded by the Heavymeta CLI, and Requires that Dfinity dfx is already installed on your system.  If it isn't please follow instructions [here:](https://internetcomputer.org/docs/current/developer-docs/setup/install/index.mdx) guide first.

This is a Motoko example that does not currently have a Rust variant. 


## Prerequisites
- [x] Install the [IC SDK](https://internetcomputer.org/docs/current/developer-docs/setup/install/index.mdx).
- [x] Install [Node.js](https://nodejs.org/en/download/).
- [x] Download and install the `@dfinity/auth-client` package with the command `npm install @dfinity/auth-client`. 
- [x] Download and Install the Heavymeta CLI: `TO BE SET`
 [step 4 below](#step-4-make-the-internet-identity-url-available-in-the-build-process))


Heavymeta cli will clone this template with the following file structure:

```bash
.
├── README.md
├── dfx.json
├── package.json
├── package.lock.json/
│   ├── src/
│   │   ├── proprium_minter_backend/
│   │   │   ├── Map/
│   │   │   │   ├── modules/
│   │   │   │   │   ├── clone.mo
│   │   │   │   │   ├── find.mo
│   │   │   │   │   ├── fromiter.mo
│   │   │   │   │   ├── get.mo
│   │   │   │   │   ├── init.mo
│   │   │   │   │   ├── iterate.mo
│   │   │   │   │   ├── put.mo
│   │   │   │   │   ├── queue.o
│   │   │   │   │   ├── rehash.o
│   │   │   │   │   ├── remove.mo
│   │   │   │   │   └── toArray.mo
│   │   │   │   ├── const.mo
│   │   │   │   ├── lib.mo
│   │   │   │   ├── types.mo
│   │   │   │   └── utils.mo
│   │   │   ├── Set/
│   │   │   │   ├── modules/
│   │   │   │   │   ├── clone.mo
│   │   │   │   │   ├── find.mo
│   │   │   │   │   ├── fromiter.mo
│   │   │   │   │   ├── get.mo
│   │   │   │   │   ├── init.mo
│   │   │   │   │   ├── iterate.mo
│   │   │   │   │   ├── put.mo
│   │   │   │   │   ├── queue.o
│   │   │   │   │   ├── rehash.o
│   │   │   │   │   ├── remove.mo
│   │   │   │   │   └── toArray.mo
│   │   │   │   ├── const.mo
│   │   │   │   ├── lib.mo
│   │   │   │   ├── types.mo
│   │   │   │   └── utils.mo
│   │   │   ├── main.mo
│   │   │   ├── Hex.mo
│   │   │   ├── SHA256.mo
│   │   │   ├── Types.mo
│   │   │   └── Uploader.mo
│   │   └── proprium_minter_frontend/
│   │       └── assets/
│   │           ├── favicon.ico
│   │           └── logo2.svg
│   └── src/
│       ├── index.html
│       └── index.js
└── webpack.config.js
```

### Step 2: Add Proprium data to model, and Test Minter Locally.
The minter can be run via Blender button Test Minter.

### Step 3: When Testing is complete, Deploy to the main net.
ADD INSTRUCTIONS HERE



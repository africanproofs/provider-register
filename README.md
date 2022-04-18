African Proofs proposes an on-chain mechanism to enable Flare and Songbird providers to self-manage data about their offerings. The mechanism involves a smart-contract deployed on-chain, allowing providers to publish a pointer to a self-hosted and standardized file containing information on the provider. 

*For this document, a provider is any entity that performs some service for the Flare ecosystem. Included under the 'provider' definition are price providers, attestation providers, validators, etc.*

## Provider Register Contract
In a permissionless manner, the contract facilitates a decentralized method to; 1.) Notify the ecosystem participants about chain infrastructure offerings, 2.) Allow for an exchange of meta-information amongst and about chain providers, developers, validators, etc.

### How it works.

**From the provider side:**
The contract exposes two state-altering functions, i.e., *register* and *unregister*. 
A call to the *register* function requires two parameters, namely 1) The name of the provider; 2) An HTTP/HTTPS URL pointer to information about the sender. The new record defaults to a status of 1, denoting that the provider is active. 

A call to the *unregister* function takes no parameters and sets the status to 0, which indicates to the consumer that the provider is inactive. No removal of data takes place. A subsequent call to *register* will set the status to 1.

An update to the provider record is triggered when the sender submits another *register* transaction/call with the new information.

The provider must sign the *register* and *unregister* functions. Its is the signers address that is used as the index key for the record.

**From the data consumer side:**   
Once registered, other stakeholders such as dapp developers can use the information as a reference and a starting point in sourcing data about the deployed chain infrastructure. Interaction with the contract happens through two data acquisition functions, namely *getAllProviders* and *getProvider*.

A call to *getAllProviders* takes no parameters and returns a list of ALL registered addresses, irrespective of the status.

A call to *getProvider* requires a registered address as a parameter. The call returns a tuple data structure with the following data (address, name_of_provider, pointer_url, status ).

The contract has no admin facility.


## Standardised Provider File.
**A Standardized JSON file for providers to publish as their info URL field when calling the register action on the ProviderRegister Contract.**

### THE PROVIDER DECIDES WHAT THEY PUBLISH. NO AUTHORITY.

- name: Name of validator or price provider
- chains: [Array]
    - chain_id: Chain ID where this data is applicable. Must match chain where contract is deployed.
    - address: EVM address associated to the provider. Must match signature used to register.
- organisation: {Object}
  - branding: {Object} - Logo images
      - logo_128: Entire url to image 128x128px
      - logo_256: Entire url to image 256x256px 
      - logo_1024: Entire url to image 1024x1024px
      - logo_svg: Entire url to image svg
   - location: {Object} - Organization location
      - name: Location in human-readable format [City, State]
      - country: Country code [XX] in accordance to [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
      - latitude: Latitude in decimal degrees
      - longitude: Longitude in decimal degrees
    },
  - contact: {Object} 
    - website: Valid website URL
    - email: Primary contact email address
    - discord: Full server
    - telegram: Username ONLY NOT URL
    - twitter: Username ONLY NOT URL
    - git: Organisation Github/Gitlab url
    - youtube: Organisation Channel address
    - wechat: Username
- services: [Array]
  - chain: Chain ID
  - price_provider: Yes or No
  - attestations_provider: Yes or No
  - validator: Yes or No
- infrastructure: [Array]
    - chain: Chain ID
    - location: {Object} - Physical location of the infrastructure
        - name: Location in human readable format [City, State]
        - country: Country code [XX] in accordance to [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
        - latitude: Latitude in decimal degrees
        - longitude: Longitude in decimal degrees
    - rpc_endpoint: Chain RPC endpoint - Omit if public point is not provided.
    - ws_endpoint: Chain WS endpoint - Omit if public point is not provided.

## Provider Instructions 
Copy the [template](https://github.com/africanproofs/provider-register/blob/main/assets/provider.template.json) provided on this repo. Name the file provider.json

Update the template with information specific to your organization. Ensure that you provide as much and as accurate data as possible.

Upload the file to a publicly accessible endpoint. It could be your website, online git service, dropbox, etc.

Ensure that the URL is downloadable by tools such as curl, wget, etc.

## Deployment

The Coston chain has a deployment of the contract at the following address **0xd5aae37eD04835cB5c7d9f8d41D0F872D5DC6802**. 
The easiest way to interact with the contract currently is to use the [Coston Explorer](https://coston-explorer.flare.network/address/0xd5aae37eD04835cB5c7d9f8d41D0F872D5DC6802/transactions). 

There will be a feedback period until 30 April 2022, should anyone be interested to provide any feedback.
After the feedback period the final contract will be deployed on the Songbird chain. The contract deployment on Songbird will be used for all targeted chains.

## Meta Info and Links
The current version number of the specification file is **v0.1.0**, and it is compliant with the JSON schema [Draft 2019-09](https://json-schema.org/specification-links.html#2019-09-formerly-known-as-draft-8).

One can check for data validity using the following [schema validator](https://www.jsonschemavalidator.net/).

Mechanism finds inspiration from work done by [EOSRIO](https://eosrio.io/).

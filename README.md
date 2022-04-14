African Proofs proposes an on-chain mechanism to enable Flare and Songbird providers to self-manage data about their offerings. The mechanism involves a smart contract deployed on-chain, allowing providers to publish a pointer to a self hosted and standardised file containing information on the provider. This is intended for use by price providers, attestation providers etc.

*For the purposes of this document, a provider is any entity that performs some sort of service for the Flare ecosystem. This typically includes price providers, attestation providers, validators ets.*

## Provider Register Contract
The contract is intended to facilitate a decentralised method to, in a permissionless manner; 1.) Notify the ecosystem participants of the existence of chain infrastructure offerings, 2.) Allow for an exchange of meta information amongst and about chain providers, developers, and validators etc.

### How it works.

**From the provider side:**
The contract exposes two state altering functions i.e. *register* and *unregister*. 
A call to the *register* function requires two parameters, namely 1) The name of the provider; 2) An http/https url pointer to information about the sender. The new record is given a status of 1, denoting that the record is active. 

A call to the *unregister* function takes no parameters and sets the status to 0. This indicates to the consumer that the record is inactive. The data is not removed. A subsequent call to *register*, will set the status to 1, once more.

In order to update the record, the sender is required to send another *register* transaction/call with the new information.

The *register* and *unregister* functions MUST be signed by the provider.

**From the data consumer side:**	
Once registered, other stakeholders such as dapp developers can use the information as a reference and a starting point in sourcing data about the deployed chain infrastructure. This can be done using the contract's two data acquisition functions, namely *getAllProviders* and *getProvider*.

A call to *getAllProviders* takes no parameters and returns a list of ALL registered addresses, irrespective of the status.

A call to *getProvider* requires a registered address as a parameter. The call returns a tuple data structure with the following data (address, name_of_provider, pointer_url, status ).

The contract has no admin facility.


## Standardised Provider File.
**A Standardized JSON file for providers to publish as their info URL field when calling the register action on the ProviderRegister Contract.**

### THE PROVIDER DECIDES WHAT THEY PUBLISH. NO AUTHORITY.

- name: Name of validator or price provider
- chains: {Object}
    - chain_id: Chain ID where this data is applicable,
    - address: EVM address associated to the provider
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
- services: {Object}
  - price: Yes or No
  - attestations: Yes or No
  - validator: Yes or No
- infrastructure: [Array]
    - chain: Flare, Songbird etc
    - location: {Object} - Physical location of the infrastructure
        - name: Location in human readable format [City, State]
        - country: Country code [XX]
        - latitude: Latitude in decimal degrees
        - longitude: Longitude in decimal degrees
    - rpc_endpoint: Chain RPC endpoint - Omit if private
    - ws_endpoint: Chain WS endpoint - Omit if private

## Provider Instructions 
Copy the [template](https://gitlab.com/proofs.africa/flare-provider-register/assets/provider.template.json) provided on this repo. Name the file provider.json

Update the template with information specific to your organisation. Ensure that you provide as much and as accurate data as possible.

Upload the file to a publicly accessable endpoint. Could be your website, online git service, dropbox etc.

Ensure that the URL is downloadable by tools such as curl, wget etc.

## Deployment

A TEST contract is deployed on Coston at the following address {address}. There will be a feedback period until {date}.

## Meta Info and Links
The current version number of the specification file is **v0.1.0** and it is compliant with the JSON schema [Draft 2019-09](https://json-schema.org/specification-links.html#2019-09-formerly-known-as-draft-8)

One can check for data validity using: https://www.jsonschemavalidator.net/

Mechanism finds inspiration from work done by [EOSRIO](https://eosrio.io/)

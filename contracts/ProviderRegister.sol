//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title An implementation of the Provider Register for the Flare Networks ecosystem.
 *
 * @author African Proofs
 */

contract ProviderRegister {

    // errors
    string internal constant ERR_NO_PROVIDERS = "No providers exist. ";
    string internal constant ERR_NAME_IN_USE =  "The provider name is already in use. ";
    string internal constant ERR_SIGNER_NOT_REGISTERED = "Signer is not a registered provider. ";
    string internal constant ERR_ADDRESS_NOT_REGISTERED = "Submitted address is not a registered provider. ";


    enum PROVIDER_STATUS {
        INACTIVE, // Denotes an de-registration.
        ACTIVE  // Default on successful registration.
    }

    struct Provider{
        address owner; // Signer address.
        string name; // An identifier for the provider.
        string url; // Pointer to provider publicly accessible file.
        PROVIDER_STATUS status;
        uint index;
    }

    mapping(address => Provider) private providers;
    address[] private providerIndex;

    event ProviderRegisteredEvent(address indexed owner, uint index, string name, string url, PROVIDER_STATUS status);
    event ProviderUnregisteredEvent(address indexed owner, uint index, PROVIDER_STATUS status);

    // A helper function that checks if sender or submitted address is in one of providers
    function _isProvider(address _address) internal view returns (bool _isCorrect) {
        if(providerIndex.length == 0) return false;
        return (providerIndex[providers[_address].index] == _address);
    }

    // A helper function that checks if the provider name is not unique and has a status of ACTIVE
    function _verifyProviderName(string memory _name) internal view returns (bool _exists) {
        if(providerIndex.length == 0) return false;
        uint providerLength = providerIndex.length;

        for (uint i=0; i<providerLength; i++){
            if(_compareName(_name, providers[providerIndex[i]].name)){
                if (providers[providerIndex[i]].status == PROVIDER_STATUS.ACTIVE)
                    return true;
            }
        }
        return false;
    }

    /**
     * @notice Registers a new provider. If sender address already exists, an update is perfomed.
     * @param _name             The name of the provider
     * @param _url              The absolute http/https URL pointing to the standardized json file.
     * @notice Emits ProviderRegisteredEvent event
     */
    function register(string memory _name, string memory _url) public returns(bool _registered) {
        if (_isProvider(msg.sender)){
            
            providers[msg.sender].name = _name;
            providers[msg.sender].url = _url;
            providers[msg.sender].status = PROVIDER_STATUS.ACTIVE;
        } else{

            require(!_verifyProviderName(_name), ERR_NAME_IN_USE);

            providerIndex.push(msg.sender);
            uint _index = providerIndex.length-1;
            providers[msg.sender] = Provider(msg.sender, _name, _url, PROVIDER_STATUS.ACTIVE, _index);
        }
        
        emit ProviderRegisteredEvent(
            msg.sender,
            providers[msg.sender].index,
            _name,
            _url,
            PROVIDER_STATUS.ACTIVE
        );

        return true;
    }

    /**
     * @notice Unregisters a registered provider. Sets the status field to zero. Does not remove the record.
     * @notice Emits ProviderUnregisteredEvent event
     */
    function unregister() public {
        require(providerIndex.length > 0, ERR_NO_PROVIDERS);
        require(_isProvider(msg.sender), ERR_SIGNER_NOT_REGISTERED);

        providers[msg.sender].status = PROVIDER_STATUS.INACTIVE;

        emit ProviderUnregisteredEvent(
            msg.sender,
            providers[msg.sender].index,
            providers[msg.sender].status
        );
    }

    /**
     * @notice Retrieves a single record based on submitted provider address.
     * @param _address          The address of the provider whose data is requested.
     * @return Returns a Tuple in format (address, name, url, status)
     */
    function getProvider(address _address) public view returns(address, string memory, string memory, PROVIDER_STATUS status){
        require(providerIndex.length > 0, ERR_NO_PROVIDERS);
        require(_isProvider(_address), ERR_ADDRESS_NOT_REGISTERED);

        return (providers[_address].owner, 
                providers[_address].name, 
                providers[_address].url,
                providers[_address].status);
    }

    /**
     * @notice Retrieves a list of all registered addresses.
     * @return Returns a list containing all provider irrespective of status.
     */
    function getAllProviders() public view returns(address[] memory) {
        return providerIndex;
    }

    function _compareName(string memory _first, string memory _second) internal pure returns (bool _matches) {
        if(bytes(_first).length != bytes(_second).length) {
            return false;
        } else {
            return keccak256(bytes(_first)) == keccak256(bytes(_second));
        }
    }
}
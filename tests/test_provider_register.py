import pytest
from brownie import ProviderRegister, network, accounts, config, exceptions


@pytest.fixture
def account():
    if network.show_active() == "development":
        yield accounts[0]
    else:
        yield accounts.add(config["wallets"]["from_key"])


@pytest.fixture
def contract(account):
    yield ProviderRegister.deploy({"from": account})


def test_deploy_provider_register_contract(account):
    register = ProviderRegister.deploy({"from": account})
    assert len(register.getAllProviders()) == 0


def test_register_a_provider(contract):
    contract.register("African Proofs", "https://proofs.africa/path_to_provider_json_file.json", {"from": accounts[1]})
    contract.register("African Proofs 2", "https://proofs.africa/path_to_provider_json_file.json",
                      {"from": accounts[2]})
    assert len(contract.getAllProviders()) == 2


def test_unregister_a_provider(contract):
    contract.register("African Proofs", "https://proofs.africa/path_to_provider_json_file.json", {"from": accounts[1]})
    contract.register("African Proofs 2", "https://proofs.africa/path_to_provider_json_file.json",
                      {"from": accounts[2]})
    contract.unregister({"from": accounts[1]})

    unregistered = contract.getProvider(accounts[1])
    assert unregistered[3] == 1

    registered = contract.getProvider(accounts[2])
    assert registered[3] == 0


def test_provider_name_resolution_failure(contract):
    contract.register("African Proofs", "https://proofs.africa/path_to_provider_json_file.json", {"from": accounts[1]})
    with pytest.raises(expected_exception=exceptions.VirtualMachineError):
        contract.register("African Proofs", "https://proofs.africa/path_to_provider_json_file.json",
                          {"from": accounts[2]})


def test_unregistered_provider_name_resolution_success(contract):
    contract.register("African Proofs", "https://proofs.africa/path_to_provider_json_file.json", {"from": accounts[1]})
    contract.unregister({"from": accounts[1]})
    contract.register("African Proofs", "https://proofs.africa/path_to_provider_json_file.json", {"from": accounts[2]})

    unregistered = contract.getProvider(accounts[1])
    assert unregistered[3] == 1

    registered = contract.getProvider(accounts[2])
    assert registered[3] == 0


def test_non_existing_provider_failure(contract):
    # Add one provider to avoid the ERR_NO_PROVIDERS exception
    contract.register("African Proofs", "https://proofs.africa/path_to_provider_json_file.json", {"from": accounts[1]})
    with pytest.raises(expected_exception=exceptions.VirtualMachineError):
        contract.getProvider(accounts[2])

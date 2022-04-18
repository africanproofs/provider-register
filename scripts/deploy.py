from brownie import accounts, ProviderRegister, network, config

from utilities import get_account


def deploy_provider_register():
    account = get_account()
    print(f"Deployment account is {account}")
    ProviderRegister.deploy({"from": account})


def main():
    deploy_provider_register()

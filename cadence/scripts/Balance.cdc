import "CasherToken"
import "FungibleToken"

pub fun main(address: Address): UFix64 {
    let vault = getAccount(address).getCapability(/public/Vault)
                .borrow<&CasherToken.Vault{FungibleToken.Balance}>()
                ?? panic("Could not borrow public vault")

    return vault.balance
}
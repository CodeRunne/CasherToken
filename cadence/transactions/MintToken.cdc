import "CasherToken"
import "FungibleToken"

transaction(receiver: Address, amount: UFix64) {
    prepare(signer: AuthAccount) {
        let minter = signer.borrow<&CasherToken.Minter>(from: /storage/Minter)
                    ?? panic("Minter resource could not be borrowed")
        
        let newVault <- minter.mintToken(amount: amount)
        let receiver = getAccount(receiver).getCapability(/public/Vault)
                            .borrow<&CasherToken.Vault{FungibleToken.Receiver}>()
                            ?? panic("Account does not have a vault")
        
        receiver.deposit(from: <- newVault)
    }

    execute {
        log("Successfully deposited in receiver vault")
    }
}
import "CasherToken"
import "FungibleToken"

transaction(receiver: Address, amount: UFix64) {
    prepare(signer: AuthAccount) {
        
        let sender = signer.borrow<&CasherToken.Vault>(from: /storage/Vault)
            ?? panic("Couldn't get sender's vault")

        let receiver = getAccount(receiver).getCapability(/public/Vault)
                            .borrow<&CasherToken.Vault{FungibleToken.Receiver}>()
                            ?? panic("Account does not have a vault")
        
        receiver.deposit(from: <- sender.withdraw(amount: amount))
    }

    execute {
        log("Successfully transfered FT")
    }
}
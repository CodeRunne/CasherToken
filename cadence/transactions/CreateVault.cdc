import "CasherToken"
import "FungibleToken"

transaction {
    prepare(signer: AuthAccount) {
        signer.save(<- CasherToken.createEmptyVault(), to: /storage/Vault)
        signer.link<&CasherToken.Vault{FungibleToken.Balance, FungibleToken.Receiver}>(/public/Vault, target: /storage/Vault)
    }
}
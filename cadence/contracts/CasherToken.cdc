import "FungibleToken"

pub contract CasherToken: FungibleToken {

    pub var totalSupply: UFix64

    pub event TokensInitialized(initialSupply: UFix64)
    pub event TokensWithdrawn(amount: UFix64, from: Address?)
    pub event TokensDeposited(amount: UFix64, to: Address?)

    pub resource Vault: FungibleToken.Provider, FungibleToken.Receiver, FungibleToken.Balance {

        pub var balance: UFix64

        pub fun deposit(from: @FungibleToken.Vault) {
            let vault <- from as! @CasherToken.Vault
            self.balance = self.balance + vault.balance
            emit TokensDeposited(amount: vault.balance, to: self.owner?.address)
            
            vault.balance = 0.0
            destroy vault
        }

        pub fun withdraw(amount: UFix64): @FungibleToken.Vault {
            pre {
                amount > 0.0: "Amount must be greater than zero"
            }
            
            self.balance = self.balance - amount
            emit TokensWithdrawn(amount: amount, from: self.owner?.address)
            return <- create Vault(balance: amount) 
        }

        init(balance: UFix64) {
            self.balance = balance
        }

        destroy() {
            CasherToken.totalSupply = CasherToken.totalSupply - self.balance
        }

    }

    pub fun createEmptyVault(): @FungibleToken.Vault {
        return <- create Vault(balance: 0.0)
    }

    pub resource Minter {
        pub fun mintToken(amount: UFix64): @FungibleToken.Vault {
            CasherToken.totalSupply = CasherToken.totalSupply + amount
            return <- create Vault(balance: amount)
        }

        init() {}
    }

    init() {
        self.totalSupply = 0.0
        emit TokensInitialized(initialSupply: self.totalSupply)
        self.account.save(<- create Minter(), to: /storage/Minter)
    }

}
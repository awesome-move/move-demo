// sources/Main.move
script {

    use MyCoinAddr::MyCoin;
    use std::signer;
    use std::debug;

    fun main(account: signer, mint_addr: signer) {
        //Initialize account
        MyCoin::init_account(&account);
        MyCoin::init_account(&mint_addr);
        // mint
        MyCoin::mint(&account, signer::address_of(&mint_addr), 100);
        // balance
        let mintBalance = MyCoin::balance_of(signer::address_of(&mint_addr));
        debug::print(&mintBalance);
        // transfer
        MyCoin::transfer(&mint_addr, signer::address_of(&account), 50);
        
        // balance
        let accountBalance = MyCoin::balance_of(signer::address_of(&account));
        debug::print(&accountBalance);
        let mintNewBalance = MyCoin::balance_of(signer::address_of(&mint_addr));
        debug::print(&mintNewBalance);
    }
}

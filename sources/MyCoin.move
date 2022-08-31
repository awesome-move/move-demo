/// sources/MyCoin.move
module MyCoinAddr::MyCoin{
    use std::signer;

    /// Address of the owner of this module
    const MODULE_OWNER: address = @MyCoinAddr;

    /// Error codes
    const ENOT_MODULE_OWNER: u64 = 0;
    const EINSUFFICIENT_BALANCE: u64 = 1;
    const EALREADY_HAS_BALANCE: u64 = 2;
    const ACCOUNT_INITIALIZED: u64 = 3;

    struct Coin has store {
        value: u64
    }

    ///  Struct representing the balance of each address.
    struct Balance has key {
        coin: Coin
    }


    public fun init_account(account: &signer) {
    let account_addr = signer::address_of(account);
    // TODO: add an assert to check that `account` doesn't already have a `Balance` resource.
    assert!(!exists<Balance>(account_addr), ACCOUNT_INITIALIZED);
    if(!exists<Balance>(account_addr)){
        move_to(account, Balance {coin: Coin {value: 0}});
    }
}


public fun mint(module_owner: &signer, mint_addr: address, amount: u64) acquires Balance {
    // Only the owner of the module can initialize this module
    assert!(signer::address_of(module_owner) == MODULE_OWNER, ENOT_MODULE_OWNER);

    // Deposit `amount` of tokens to `mint_addr`'s balance
    deposit(mint_addr, Coin { value: amount });
}




fun deposit(_addr: address, check: Coin) acquires Balance {
    let balance = balance_of(_addr);
    // borrow_global_mut
    let balance_ref = &mut borrow_global_mut<Balance>(_addr).coin.value;
    let Coin { value } = check;
    *balance_ref = balance + value;
}

public fun balance_of(owner: address): u64 acquires Balance {
    borrow_global<Balance>(owner).coin.value
}


public fun transfer(from: &signer, to: address, amount: u64) acquires Balance {
    // balance - amount
    let check = withdraw(signer::address_of(from), amount);
    // add amount
    deposit(to, check);
}

fun withdraw(addr: address, amount: u64):Coin acquires Balance {
    let balance = balance_of(addr);
    // balance must be greater than the withdraw amount
    assert!(balance >= amount, EINSUFFICIENT_BALANCE);
    let balance_ref = &mut borrow_global_mut<Balance>(addr).coin.value;
    *balance_ref = balance - amount;
    Coin { value: amount }
}


}

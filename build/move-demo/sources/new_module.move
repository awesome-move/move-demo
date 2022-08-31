script {
    use 0x2::NewModule;
    fun new_module(account: signer) { 
        NewModule::publish(&account);
    }
}
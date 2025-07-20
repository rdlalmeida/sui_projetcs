/*
/// Module: my_first_package
module my_first_package::my_first_package;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions
module my_first_package::example;

use std::debug;

// Part 1: These imports are provided by default
// use sui::object::{Self, UID};
// use sui::transfer;
// use sui::tx_context::{Self, TxContext};

// Part 2: struct definitions
public struct Sword has key, store {
    id: UID,
    magic: u64,
    strength: u64,
}

public struct Forge has key {
    id: UID,
    swords_created: u64,
}

// Part 3: Module initialiser to be executed when this module is published
fun init(ctx: &mut TxContext) {
    let admin: Forge = Forge {
        id: object::new(ctx),
        swords_created: 0,
    };

    // Transfer the forge object to the module/package publisher
    transfer::transfer(admin, ctx.sender());
}

// Part 4: Accessors required to read the struct fields
public fun magic(self: &Sword): u64 {
    return self.magic
}

public fun strength(self: &Sword): u64 {
    return self.strength
}

public fun swords_created(self: &Forge): u64 {
    return self.swords_created
}

public fun sword_create(magic: u64, strength: u64, ctx: &mut TxContext): Sword {
    let sword: Sword = Sword {
        id: object::new(ctx),
        magic: magic,
        strength: strength,
    };

    return sword
}

public fun new_sword(forge: &mut Forge, magic: u64, strength: u64, ctx: &mut TxContext): Sword {
    debug::print(forge);
    forge.swords_created = forge.swords_created + 1;
    debug::print(forge);
    debug::print_stack_trace();

    let new_sword: Sword = Sword {
        id: object::new(ctx),
        magic: magic,
        strength: strength,
    };

    return new_sword
}

// Part 5: Public/entry functions (introduced later in the tutorial)

// Part 6: Tests
#[test]
public fun test_sword_create() {
    // Create a dummy TxContext for testing
    let mut ctx = tx_context::dummy();

    // Create a Sword
    let sword: Sword = Sword {
        id: object::new(&mut ctx),
        magic: 43,
        strength: 7,
    };

    // Check if accessor functions return correct values
    assert!(sword.magic() == 43 && sword.strength() == 7, 1);

    let dummy_address = @0xCAFE;
    transfer::public_transfer(sword, dummy_address);
}

const MAGIC: u64 = 33;
const STRENGTH: u64 = 12;

#[test]
fun test_sword_transactions() {
    use sui::test_scenario;

    // Create test addresses representing users
    let initial_owner: address = @0xCAFE;
    let final_owner: address = @0xFACE;

    // First transaction executed by initial owner to create the sword
    let mut scenario: sui::test_scenario::Scenario = test_scenario::begin(initial_owner);
    {
        // Create the sword and transfer it to the initial owner
        let sword: Sword = sword_create(MAGIC, STRENGTH, scenario.ctx());
        transfer::public_transfer(sword, initial_owner);
    };

    // Second transaction executed by the initial sword owner
    scenario.next_tx(initial_owner);
    {
        // Extract the sword owned by the initial owner
        let sword: Sword = scenario.take_from_sender<Sword>();

        // Transfer the sword to the final owner
        transfer::public_transfer(sword, final_owner);
    };

    scenario.next_tx(final_owner);
    {
        // Extract the sword owned by the final owner
        let sword = scenario.take_from_sender<Sword>();

        // Verify that the sword has expected properties
        assert!(sword.magic() == MAGIC && sword.strength() == STRENGTH, 1);

        scenario.return_to_sender(sword)
    };
    scenario.end();
}

#[test]
fun test_module_init() {
    use sui::test_scenario;

    // Create test addresses to representing users
    let admin = @0xAD;
    let initial_owner = @0xCAFE;

    // First transaction to emulate module initialization
    let mut scenario = test_scenario::begin(admin);
    {
        init(scenario.ctx());
    };

    // Second transaction to check if the forge has been created
    // and has initial value of zero swords created
    scenario.next_tx(admin);
    {
        // Extract the Forge object
        let forge: Forge = scenario.take_from_sender<Forge>();

        // Verify the number of created swords
        assert!(forge.swords_created() == 0, 1);

        // Return the Forge to the object pool
        scenario.return_to_sender(forge);
    };

    scenario.next_tx(admin);
    {
        let mut forge = scenario.take_from_sender<Forge>();

        // Create the sword and transfer it to the initial owner

        let sword: Sword = forge.new_sword(MAGIC, STRENGTH, scenario.ctx());

        transfer::public_transfer(sword, initial_owner);
        scenario.return_to_sender(forge);
    };

    scenario.end();
}

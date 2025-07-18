/*
/// Module: my_first_package
module my_first_package::my_first_package;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions
module my_first_package::example;

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

// Part 5: Public/entry functions (introduced later in the tutorial)

// Part 6: Tests

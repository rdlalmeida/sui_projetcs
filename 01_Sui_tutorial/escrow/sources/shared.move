/*
    Copyright (c) Mysten Labs, Inc.
    SPDX-Licence-Identifier: Apache-2.0

    An escrow for atomic swap of objects using shared objects without a trusted third party

    The protocol consists of three phases:

    1. One party `locks` their object, getting a `Locked` object and its `Key`. This party can `unlock` their object to preserve liveness if the other party stalls before completing the second stage.

    2. The other party registers a publicly accessible, shared `Escrow` object. This effectively locks their object at a particular version as well, waiting for the first party to complete the swap. The second party is able to request their object is returned to them, to preserve liveness as well.

    3. The first party sends their locked object and its key to the shared `Escrow` object. This completes the swap, as long as all conditions are met:
        - The sender of the swap transaction is the recipient of the `Escrow`.
        - The key of the desired object (`exchange_key`) in the escrow matches the key supplied in the swap.
        - The key supplied in the swap unlocks the `Locked<U>`.
*/
module escrow::shared;

use escrow::lock::{Locked, Key};
use sui::dynamic_object_field as dof;
use sui::event;

/// The `name` of the DOF that holds the Escrowed object. Allows easy discoverability for the escrowed object.
public struct Escrow<phantom T: key + store> has key, store {
    id: UID,
    /// Owner of `escrowed`
    sender: address,
    /// Intended recipient
    recipient: address,
    /// ID of the key that opens the lock on the object sender wants from recipient
    exchange_key: ID,
}

// === Error codes ===

// === Events ===

// === Tests ===

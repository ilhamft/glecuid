# glecuid

[![Test](https://github.com/ilhamft/glecuid/actions/workflows/test.yml/badge.svg)](https://github.com/ilhamft/glecuid/actions/workflows/test.yml)
[![Package](https://img.shields.io/hexpm/v/glecuid)](https://hex.pm/packages/glecuid)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glecuid/)
[![MIT](https://img.shields.io/github/license/ilhamft/glecuid?color=brightgreen)](https://github.com/ilhamft/glecuid/blob/main/LICENSE)
[![Gleam Erlang](https://img.shields.io/badge/%20gleam%20%E2%9C%A8-Erlang-red)](https://gleam.run)
[![Gleam JS](https://img.shields.io/badge/%20gleam%20%E2%9C%A8-JS-yellow)](https://gleam.run/news/v0.16-gleam-compiles-to-javascript)

This is a port of [paralleldrive/cuid2@v3.0.0](https://github.com/paralleldrive/cuid2/tree/v3.0.0) in Gleam that works on all target.
For more detailed information about Cuid2, please refer to the [original documentation](https://github.com/paralleldrive/cuid2/blob/v3.0.0/README.md).

### Notes on JavaScript target

On server this package uses [node:crypto](https://nodejs.org/api/crypto.html#cryptohashalgorithm-data-options) for hashing.

On browser this package require [noble-hashes](https://github.com/paulmillr/noble-hashes) to be installed.
You can install it by using `npm install @noble/hashes`.

## Cuid2

Secure, collision-resistant ids optimized for horizontal scaling and performance. Next generation UUIDs.

Need unique ids in your app? Forget UUIDs and GUIDs which often collide in large apps. Use Cuid2, instead.

**Cuid2 is:**

- **Secure:** It's not feasible to guess the next id, existing valid ids, or learn anything about the referenced data from the id. Cuid2 uses multiple, independent entropy sources and hashes them with a security-audited, NIST-standard cryptographically secure hashing algorithm (Sha3).
- **Collision resistant:** It's extremely unlikely to generate the same id twice (by default, you'd need to generate roughly 4,000,000,000,000,000,000 ids ([`sqrt(36^(24-1) * 26) = 4.0268498e+18`](https://en.wikipedia.org/wiki/Birthday_problem#Square_approximation)) to reach 50% chance of collision.)
- **Horizontally scalable:** Generate ids on multiple machines without coordination.
- **Offline-compatible:** Generate ids without a network connection.
- **URL and name-friendly:** No special characters.
- **Fast and convenient:** No async operations. Won't introduce user-noticeable delays. Less than 5k, gzipped.
- **But not _too fast_:** If you can hash too quickly you can launch parallel attacks to find duplicates or break entropy-hiding. For unique ids, the fastest runner loses the security race.

**Cuid2 is not good for:**

- Sequential ids (see the [note on k-sortable ids](https://github.com/paralleldrive/cuid2#note-on-k-sortablesequentialmonotonically-increasing-ids))
- High performance tight loops, such as render loops (if you don't need cross-host unique ids or security, consider a simple counter for this use-case, or try [Ulid](https://github.com/ulid/javascript) or [NanoId](https://github.com/ai/nanoid)).

## Usage

Add to your Gleam project:

```
gleam add glecuid
```

Generate some ids:

```gleam
import glecuid/cuid2

pub fn main() {
  cuid2.create_id()
  // -> "avu4793cnw6ljhov1s7Oxidg"

  cuid2.new()
  |> cuid2.with_length(10)
  |> cuid2.generate()
  // -> "av77nekw5e"
}
```

### Configuration

```gleam
import glecuid/cuid2

pub fn main() {
  // The new function returns a default generator that can be modified.
  let generator = cuid2.new()
  // Customize the length of the id.
  |> cuid2.with_length(10)
  // A custom fingerprint for the host environtment.
  // This is used to help prevent collisions when generating ids in a
  // distributed system.
  |> cuid2.with_fingerprint("my_machine")
  // A custom counter.
  // This is used to help prevent collisions when generating ids in
  // the same millisecond.
  |> cuid2.with_counter(fn() { 67 })
  // A custom randomizer with the same API as float.random.
  |> cuid2.with_randomizer(fn() { 0.42 })

  cuid2.generate(generator)
  // -> "av77nekw5e"
}
```

### Validation

```gleam
import glecuid/cuid2

pub fn main() {
  cuid2.is_cuid(cuid2.create_id())
  // -> "TRUE"

  cuid2.is_cuid("not a cuid")
  // -> "FALSE"
}
```

View usage in the documentation at <https://hexdocs.pm/glecuid>.

## Implementation Detail

Cuid2 is made up of the following entropy sources:

- An initial letter to make the id a usable identifier in JavaScript and HTML/CSS
- The current system time
- Pseudorandom values
- A session counter
- A host fingerprint

### Pseudorandom value

Uses [`float.random`](https://hexdocs.pm/gleam_stdlib/gleam/float.html#random) by default.

### Session counter

In `erlang` target, this is implemented using [`counters`](https://www.erlang.org/doc/apps/erts/counters.html) with the reference stored in [`persistent_term`](https://www.erlang.org/doc/apps/erts/persistent_term.html).

If you don't wish to use the global counter, avoid using `create_id` and provide a custom counter when using `generate`. The global counter will not be created if you never use it.

```gleam
import glecuid/cuid2

pub fn main() {
  cuid2.new()
  |> cuid2.with_random_counter()
  |> cuid2.generate()
  // -> "avu4793cnw6ljhov1s7Oxidg"
}
```

### Host fingerprint

In `erlang` target this is the [Pid](https://hexdocs.pm/gleam_erlang/gleam/erlang/process.html#Pid) of the current process.

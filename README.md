# glecuid

[![Package Version](https://img.shields.io/hexpm/v/glecuid)](https://hex.pm/packages/glecuid)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glecuid/)

This is a port of [@paralleldrive/cuid2](https://github.com/paralleldrive/cuid2) in Gleam that works on all target.
For more detailed information about Cuid2, please refer to the [original documentation](https://github.com/paralleldrive/cuid2/blob/main/README.md).

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
  |> cuid2.with_fingerprint("my_machine")
  |> cuid2.generate()
  // -> "av77nekw5e"
}
```

View usage in the documentation at <https://hexdocs.pm/glecuid>.

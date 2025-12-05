import gleam/bit_array
import gleam/string
import glecuid/internals/util

/// Hashes the input.
///
pub fn hash(input: String) -> String {
  // https://github.com/paralleldrive/cuid2/blob/v3.0.0/src/index.js#L32
  // Drop the first character because it will bias the histogram
  // to the left.
  do_hash(input)
  |> util.bit_array_to_base36()
  |> string.drop_start(1)
}

@target(erlang)
fn do_hash(input: String) -> BitArray {
  bit_array.from_string(input) |> do_hash_()
}

@external(erlang, "glecuid_ffi", "hash")
fn do_hash_(input: BitArray) -> BitArray

@target(javascript)
@external(javascript, "../../glecuid_ffi.ts", "hash")
fn do_hash(input: String) -> BitArray

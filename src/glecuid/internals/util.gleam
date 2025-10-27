import gleam/bit_array
import gleam/bool
import gleam/crypto
import gleam/erlang/process
import gleam/float
import gleam/int
import gleam/string

pub const big_length = 32

/// Converts `BitArray` into a `String` using base-36.
/// 
@external(javascript, "../../glecuid_ffi.ts", "bit_array_to_base36")
pub fn bit_array_to_base36(bit_array: BitArray) -> String {
  bit_array
  |> bit_array_to_int()
  |> int.to_base36()
}

/// Converts `BitArray` into `Int`.
///
fn bit_array_to_int(bit_array: BitArray) -> Int {
  bit_array_to_int_loop(0, bit_array)
}

fn bit_array_to_int_loop(accumulator: Int, bit_array: BitArray) -> Int {
  case bit_array {
    <<>> -> accumulator

    <<x:size(1)>>
    | <<x:size(2)>>
    | <<x:size(3)>>
    | <<x:size(4)>>
    | <<x:size(5)>>
    | <<x:size(6)>>
    | <<x:size(7)>>
    | <<x:size(8)>> -> {
      accumulator
      |> int.bitwise_shift_left(8)
      |> int.add(x)
    }

    <<x, rest:bits>> -> {
      accumulator
      |> int.bitwise_shift_left(8)
      |> int.add(x)
      |> bit_array_to_int_loop(rest)
    }

    _ -> accumulator
  }
}

/// Bumps the global counter value by 1 and returns the new value. 
/// Will creates a new counter if none exist.
/// 
/// On `erlang` this is implemented using `persistent_term`.
/// On `javascript` this is implemented using global variable.
///
@external(erlang, "../../glecuid_ffi.erl", "bump_or_initialize_counter")
@external(javascript, "../../glecuid_ffi.ts", "bump_or_initialize_counter")
pub fn bump_or_initialize_counter(initial_count: Int) -> Int

/// Generates a random alphanumeric string with a specified length
/// using the provided randomizer.
/// 
pub fn create_entropy(randomizer: fn() -> Float, length: Int) -> String {
  create_entropy_loop("", 0, randomizer, length)
}

fn create_entropy_loop(
  accumulator: String,
  iteration: Int,
  randomizer: fn() -> Float,
  length: Int,
) -> String {
  use <- bool.guard(iteration >= length, accumulator)
  { accumulator <> random_int(randomizer, 36) |> int.to_base36() }
  |> create_entropy_loop(iteration + 1, randomizer, length)
}

/// Generates a fingerprint of the host environtment.
/// 
pub fn create_fingerprint(randomizer: fn() -> Float) -> String {
  get_global_object()
  <> create_entropy(randomizer, big_length)
  |> hash()
  |> string.slice(0, big_length)
}

@target(javascript)
/// Returns global object of the host environtment as a `String`.
/// 
/// In `javascript` target this is the [Global object](https://developer.mozilla.org/en-US/docs/Glossary/Global_object).
/// 
@external(javascript, "../../glecuid_ffi.ts", "get_global_object")
pub fn get_global_object() -> String

@target(erlang)
/// In `erlang` target this is the PID for the current process.
/// 
pub fn get_global_object() -> String {
  process.self() |> string.inspect()
}

/// Hashes the input.
/// 
pub fn hash(input: String) -> String {
  // https://github.com/paralleldrive/cuid2/blob/v3.0.0/src/index.js#L32
  // Drop the first character because it will bias the histogram
  // to the left.
  bit_array.from_string(input)
  |> crypto.hash(crypto.Sha512, _)
  |> bit_array_to_base36()
  |> string.drop_start(1)
}

/// Generates a random int between zero and the given maximum 
/// using the provided randomizer.
/// The lower number is inclusive, the upper number is exclusive.
/// 
pub fn random_int(randomizer: fn() -> Float, max: Int) -> Int {
  { randomizer() *. int.to_float(max) }
  |> float.floor()
  |> float.round()
}

/// Generates a random lowercase letter using the provided 
/// randomizer.
/// 
pub fn random_letter(randomizer: fn() -> Float) -> String {
  let assert Ok(c) =
    random_int(randomizer, 27)
    |> int.add(97)
    |> string.utf_codepoint()
  string.from_utf_codepoints([c])
}

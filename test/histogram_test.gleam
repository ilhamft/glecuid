import gleam/bool
import gleam/dict
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import test_util

pub fn collision_test() {
  let n = test_util.n
  let assert Ok(ids) = test_util.get_ids()

  // No collision
  assert ids |> list.length() == n
}

pub fn character_frequency_test() {
  let n = test_util.n
  let assert Ok(ids) = test_util.get_ids()

  let id_length = 23
  let total_letters = id_length * n
  let base = 36
  let tolerance = 0.1
  let expected_bin_size = {
    total_letters
    |> int.to_float()
    |> float.divide(base |> int.to_float())
    |> result.unwrap(0.0)
    |> float.ceiling()
  }
  let min_bin_size = {
    { 1.0 -. tolerance }
    |> float.multiply(expected_bin_size)
    |> float.round()
  }
  let max_bin_size = {
    { 1.0 +. tolerance }
    |> float.multiply(expected_bin_size)
    |> float.round()
  }

  let char_freq = {
    use char_freq, id <- list.fold(ids, dict.new())
    // Drop the first character because it will always be a letter, making
    // the letter frequency skewed.
    let chars = id |> string.drop_start(1) |> string.to_graphemes()
    use char_freq, char <- list.fold(chars, char_freq)
    let prev_val = char_freq |> dict.get(char)
    case prev_val {
      Error(_) -> char_freq |> dict.insert(char, 1)
      Ok(prev_val) -> char_freq |> dict.insert(char, prev_val + 1)
    }
  }
  assert char_freq |> dict.is_empty() == False

  // Produce even character frequency
  let char_with_unexpected_bin_size = {
    char_freq
    |> dict.filter(fn(_, freq) {
      { min_bin_size < freq && freq < max_bin_size } |> bool.negate()
    })
  }
  assert char_with_unexpected_bin_size |> dict.is_empty() == True

  // Represents all character values
  assert char_freq |> dict.size() == base
}

pub fn histogram_test() {
  let n = test_util.n
  let assert Ok(histogram) = test_util.get_histogram()
  assert histogram |> list.is_empty() == False

  let tolerance = 0.1
  let expected_bin_size = {
    n
    |> int.to_float()
    |> float.divide(histogram |> list.length() |> int.to_float())
    |> result.unwrap(0.0)
    |> float.ceiling()
  }
  let min_bin_size = {
    { 1.0 -. tolerance }
    |> float.multiply(expected_bin_size)
    |> float.round()
  }
  let max_bin_size = {
    { 1.0 +. tolerance }
    |> float.multiply(expected_bin_size)
    |> float.round()
  }

  // Produce a histogram within distribution tolerance
  let histogram_outside_tolerated_distribution = {
    histogram
    |> list.filter(fn(x) {
      { min_bin_size < x && x < max_bin_size } |> bool.negate()
    })
  }
  assert histogram_outside_tolerated_distribution |> list.is_empty() == True
}

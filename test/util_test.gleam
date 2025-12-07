import gleam/dict
import gleam/float
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import glecuid/internals/util

pub fn bit_array_to_base36_test() {
  assert util.bit_array_to_base36(<<>>) == "0"
  assert util.bit_array_to_base36(<<0xf0, 0xff, 0xff, 0xff>>) == "1UVA58F"

  let test_3 = <<0xf0, 0xff, 0xff, 0xff, 0xf0, 0xff, 0xff, 0xff>>
  assert util.bit_array_to_base36(test_3) == "3NXRER0DPEBR3"

  let test_4 = <<
    0xf0, 0xff, 0xff, 0xff, 0xf0, 0xff, 0xff, 0xff, 0xf0, 0xff, 0xff, 0xff, 0xf0,
    0xff, 0xff, 0xff, 0xf0, 0xff, 0xff, 0xff, 0xf0, 0xff, 0xff, 0xff, 0xf0, 0xff,
    0xff, 0xff, 0xf0, 0xff, 0xff, 0xff, 0xf0, 0xff, 0xff, 0xff, 0xf0, 0xff, 0xff,
    0xff, 0xf0, 0xff, 0xff, 0xff, 0xf0, 0xff, 0xff, 0xff, 0xf0, 0xff, 0xff, 0xff,
    0xf0, 0xff, 0xff, 0xff, 0xf0, 0xff, 0xff, 0xff, 0xf0, 0xff, 0xff, 0xff,
  >>
  assert util.bit_array_to_base36(test_4)
    == "12BQ2KFBY2XI6SJWCVG65NJXN11WZQ0ZQZQB09LIP0D9GB5ZX0PSDXUXL7RFGINQALNWGRU9NF8DONCNUVRP5A89A3L1B2RRI1OF"
}

pub fn create_entropy_test() {
  assert util.create_entropy(float.random, 67) |> string.length() == 67

  let random_float = float.random()

  assert util.create_entropy(fn() { random_float }, 67)
    == util.create_entropy(fn() { random_float }, 67)

  assert util.create_entropy(fn() { random_float }, 67)
    != util.create_entropy(fn() { random_float +. 0.1 }, 67)
}

pub fn create_fingerprint_test() {
  assert util.create_fingerprint(float.random) |> string.length() >= 32
}

pub fn get_global_object_test() {
  assert util.get_global_object() |> string.length() > 0
}

pub fn random_int_should_generate_random_int_test() {
  let sample_size = 100_000
  let bin_size = 100
  let expected_min = 0
  let expected_max = 100

  let list_of_int = {
    list.repeat(Nil, sample_size)
    |> list.map(fn(_) { util.random_int(float.random, expected_max) })
  }
  let actual_min = {
    list_of_int
    |> list.max(fn(a, b) { int.compare(b, a) })
    |> result.unwrap(expected_min - 1)
  }
  let actual_max = {
    list_of_int
    |> list.max(int.compare)
    |> result.unwrap(expected_max + 1)
  }

  let bins = {
    list_of_int
    |> list.fold(dict.new(), fn(acc, x) {
      let bin = x
      use rest <- dict.upsert(acc, bin)
      [x, ..rest |> option.unwrap([])]
    })
    |> dict.to_list()
  }
  let actual_bin_size = bins |> list.length()

  assert actual_bin_size == bin_size
  assert actual_min == expected_min
  assert actual_max == { expected_max - 1 }
}

pub fn random_int_should_generate_determined_int_when_given_non_random_randomizer_test() {
  assert util.random_int(fn() { 0.0 }, 67) == 0
  assert util.random_int(fn() { 0.5 }, 67) == 33
  assert util.random_int(fn() { 0.9999999999999999 }, 67) == 66
}

pub fn random_letter_should_generate_random_letter_test() {
  let sample_size = 100_000
  let bin_size = 26
  let expected_min = "a"
  let expected_max = "z"

  let list_of_letter = {
    list.repeat(Nil, sample_size)
    |> list.map(fn(_) { util.random_letter(float.random) })
  }
  let actual_min = {
    list_of_letter
    |> list.max(fn(a, b) { string.compare(b, a) })
    |> result.unwrap("?")
  }
  let actual_max = {
    list_of_letter
    |> list.max(string.compare)
    |> result.unwrap("?")
  }

  let bins = {
    list_of_letter
    |> list.fold(dict.new(), fn(acc, x) {
      let bin = x
      use rest <- dict.upsert(acc, bin)
      [x, ..rest |> option.unwrap([])]
    })
    |> dict.to_list()
  }
  let actual_bin_size = bins |> list.length()

  assert actual_bin_size == bin_size
  assert actual_min == expected_min
  assert actual_max == expected_max
}

pub fn random_letter_should_generate_determined_letter_when_given_non_random_randomizer_test() {
  assert util.random_letter(fn() { 0.0 }) == "a"
  assert util.random_letter(fn() { 0.5 }) == "n"
  assert util.random_letter(fn() { 0.9999999999999999 }) == "z"
}

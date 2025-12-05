import gleam/float
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

pub fn random_int_test() {
  assert util.random_int(fn() { 0.0 }, 67) == 0
  assert util.random_int(fn() { 1.0 }, 67) == 67
  assert util.random_int(float.random, 67) >= 0
  assert util.random_int(float.random, 67) <= 67
}

pub fn random_letter_test() {
  assert util.random_letter(fn() { 0.0 }) == "a"
  assert util.random_letter(fn() { 0.5 }) == "m"
  assert util.random_letter(fn() { 1.0 }) == "z"
  assert util.random_letter(float.random) |> string.length() == 1
}

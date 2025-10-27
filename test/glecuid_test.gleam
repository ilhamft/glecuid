import gleam/float
import gleam/string
import glecuid/cuid2
import glecuid/internals/util
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn generate_test() {
  assert cuid2.create_id() |> string.length() == cuid2.default_length

  assert cuid2.new()
    |> cuid2.with_length(10)
    |> cuid2.generate()
    |> string.length()
    == 10

  assert cuid2.new()
    |> cuid2.with_length(32)
    |> cuid2.generate()
    |> string.length()
    == 32
}

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

pub fn create_fingerprint_test() {
  assert util.create_fingerprint(float.random) |> string.length() >= 24
}

pub fn get_global_object_test() {
  assert util.get_global_object() |> string.length() > 0
}

pub fn is_cuid_test() {
  assert cuid2.is_cuid("") == False
  assert cuid2.is_cuid("67") == False
  assert cuid2.is_cuid("aaaaDLL") == False
  assert cuid2.is_cuid("yi7rqj1trke") == True
  assert cuid2.is_cuid("-x!ha") == False
  assert cuid2.is_cuid("ab*%@#x") == False
  assert cuid2.is_cuid(cuid2.create_id()) == True
  assert cuid2.is_cuid(
      cuid2.create_id() <> cuid2.create_id() <> cuid2.create_id(),
    )
    == False
}

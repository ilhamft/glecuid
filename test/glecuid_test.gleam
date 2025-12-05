import gleam/string
import glecuid/cuid2
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

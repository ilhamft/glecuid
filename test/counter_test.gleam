import glecuid/internals/util

pub fn counter_test() {
  assert [
      util.bump_or_initialize_counter(10),
      util.bump_or_initialize_counter(10),
      util.bump_or_initialize_counter(10),
      util.bump_or_initialize_counter(10),
    ]
    == [10, 11, 12, 13]
}

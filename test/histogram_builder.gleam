import bigi.{type BigInt}
import gleam/dict
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import glecuid/cuid2
import simplifile
import test_util

pub fn main() -> Nil {
  let #(ids, histogram) = create_id_pool(test_util.n)

  let r = simplifile.create_directory(test_util.dir_path)
  io.println(r |> string.inspect())

  let r = {
    ids
    |> json.array(json.string)
    |> json.to_string()
    |> simplifile.write(to: test_util.ids_path)
  }
  io.println(r |> string.inspect())

  let r = {
    histogram
    |> json.array(json.int)
    |> json.to_string()
    |> simplifile.write(to: test_util.histogram_path)
  }
  io.println(r |> string.inspect())

  Nil
}

fn bigi_from_base_36(x: String) -> BigInt {
  x
  |> bigi.from_base(36, using: fn(x) { x |> int.base_parse(36) })
  |> result.unwrap(bigi.from_int(0))
}

fn create_id_pool(n: Int) -> #(List(String), List(Int)) {
  let ids = create_id_set_loop(set.new(), 0, n) |> set.to_list()
  let histogram = build_histogram(ids)

  #(ids, histogram)
}

fn create_id_set_loop(set: Set(String), i: Int, max: Int) -> Set(String) {
  case i < max {
    False -> set
    True -> set.insert(set, cuid2.create_id()) |> create_id_set_loop(i + 1, max)
  }
}

fn build_histogram(ids: List(String)) -> List(Int) {
  let bucket_count = 20
  let bucket_length = {
    bigi.from_int(36)
    |> bigi.power(bigi.from_int(23))
    |> result.unwrap(bigi.from_int(0))
    |> bigi.divide(bigi.from_int(bucket_count))
  }

  ids
  |> list.fold(dict.new(), fn(buckets, id) {
    let bucket_id = {
      id
      |> string.drop_start(1)
      |> bigi_from_base_36()
      |> bigi.divide(bucket_length)
      |> bigi.to_int()
      |> result.unwrap(-1)
    }
    case buckets |> dict.get(bucket_id) {
      Error(_) -> buckets |> dict.insert(bucket_id, 1)
      Ok(prev_val) -> buckets |> dict.insert(bucket_id, prev_val + 1)
    }
  })
  |> dict.to_list()
  |> list.map(fn(x) { x.1 })
}

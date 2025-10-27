import gleam/dynamic/decode
import gleam/json
import gleam/result
import simplifile

pub const n = 100_000

pub const ids_path = "./test/artifacts/ids.json"

pub const histogram_path = "./test/artifacts/histogram.json"

pub fn get_ids() -> Result(List(String), Nil) {
  simplifile.read(ids_path)
  |> result.replace_error(Nil)
  |> result.try(fn(str) {
    json.parse(str, decode.list(decode.string))
    |> result.replace_error(Nil)
  })
}

pub fn get_histogram() -> Result(List(Int), Nil) {
  simplifile.read(histogram_path)
  |> result.replace_error(Nil)
  |> result.try(fn(str) {
    json.parse(str, decode.list(decode.int))
    |> result.replace_error(Nil)
  })
}

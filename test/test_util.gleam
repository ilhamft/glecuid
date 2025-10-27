import gleam/dynamic/decode
import gleam/json
import gleam/result
import simplifile

pub const n = 100_000

pub const ids_path = "./test/artifacts/ids.json"

pub const histogram_path = "./test/artifacts/histogram.json"

pub opaque type Error {
  ReadError(simplifile.FileError)
  ParseError(json.DecodeError)
}

pub fn get_ids() -> Result(List(String), Error) {
  simplifile.read(ids_path)
  |> result.map_error(ReadError)
  |> result.try(fn(str) {
    json.parse(str, decode.list(decode.string))
    |> result.map_error(ParseError)
  })
}

pub fn get_histogram() -> Result(List(Int), Error) {
  simplifile.read(histogram_path)
  |> result.map_error(ReadError)
  |> result.try(fn(str) {
    json.parse(str, decode.list(decode.int))
    |> result.map_error(ParseError)
  })
}

import glecuid/cuid2
import lustre
import lustre/effect
import lustre/element/html

pub fn main() {
  let app =
    lustre.application(
      fn(_) { #("", effect.from(fn(cb) { cb(cuid2.create_id()) })) },
      fn(_, new_id: String) { #(new_id, effect.none()) },
      fn(id) { html.text(id) },
    )

  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

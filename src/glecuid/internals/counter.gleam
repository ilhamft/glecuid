import atomic_array.{type AtomicArray}

/// Type to represent a counter.
/// 
pub opaque type Counter {
  Counter(AtomicArray)
  CustomCounter(fn() -> Int)
}

/// Raises the counter value by 1 and returns it.
/// 
pub fn bump(c: Counter) -> Int {
  case c {
    Counter(c) -> {
      let assert Ok(_) = c |> atomic_array.add(0, 1)
      let assert Ok(v) = c |> atomic_array.get(0)
      v
    }

    CustomCounter(c) -> c()
  }
}

/// Creates a counter from a function.
///
pub fn from_function(fun: fn() -> Int) -> Counter {
  CustomCounter(fun)
}

/// Creates a counter using the specified initial value.
///
pub fn new(initial_count: Int) -> Counter {
  let counter = atomic_array.new_unsigned(size: 1)
  let assert Ok(_) = counter |> atomic_array.set(0, initial_count)
  Counter(counter)
}

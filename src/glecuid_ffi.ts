/**
 * The global counter.
 */
let counter: (() => number) | null = null;

/**
 * Bumps the global counter value by one.
 * Creates a new counter if none exist.
 * @param initial_value - The initial value for initializing the global counter. Not used if the global counter is already exist.
 * @returns Counter value.
 */
export function bump_or_initialize_counter(initial_value: number): number {
  if (counter) return counter();
  initialize_counter(initial_value);
  return initial_value;
}

/**
 * Sets or resets the global counter with an initial value.
 * @param initial_value - Initial value.
 */
function initialize_counter(initial_value: number): void {
  counter = () => ++initial_value;
}

/**
 * Converts `BitArray` into a string using base-36.
 *
 * Adapted from https://github.com/juanelas/bigint-conversion
 * MIT License Copyright (c) 2018 Juan Hernández Serrano
 *
 * @returns `BitArray` value in base-36 `String`.
 */
export function bit_array_to_base36(bit_array: any): string {
  let bits = 8n;

  let value = 0n;
  for (let i = 0; i < bit_array.byteSize; i++) {
    let byte = bit_array.byteAt(i);
    const bi = BigInt(byte);
    value = (value << bits) + bi;
  }
  return value.toString(36).toUpperCase();
}

/**
 * Returns global object of the host environtment as a string.
 * @returns Global object keys as `String`.
 */
export function get_global_object(): string {
  const global_object =
    typeof global !== 'undefined'
      ? global
      : typeof window !== 'undefined'
      ? window
      : {};
  return Object.keys(global_object).toString();
}

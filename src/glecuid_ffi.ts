/*
 * Converts `BitArray` into a string using base-36.
 *
 * Adapted from https://github.com/juanelas/bigint-conversion
 * MIT License Copyright (c) 2018 Juan Hernández Serrano
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

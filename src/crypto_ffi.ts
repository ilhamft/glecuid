// @ts-ignore
import { BitArray$BitArray } from './gleam.mjs';

let hasher: ((data: Uint8Array<ArrayBuffer>) => Uint8Array) | null = null;

try {
  const crypto = await import('@noble/hashes/sha3.js');
  hasher = (data) => crypto.sha3_512(data);
} catch {
  const crypto = await import('node:crypto');
  hasher = (data) => crypto.hash('SHA3-512', data, 'buffer');
}

/**
 * Hashes the input using SHA3-512 algorithm.
 * @param input - Input string.
 * @returns Hash output as Gleam's `BitArray`.
 */
export function hash(input: string) {
  const encoder = new TextEncoder();
  const data = encoder.encode(input);
  if (!hasher) throw new Error('Hasher is not available.');
  const hash = hasher(data);
  return BitArray$BitArray(hash);
}

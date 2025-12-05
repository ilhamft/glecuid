// @ts-ignore
import { BitArray } from './gleam.mjs';
import { hash as nodeHash } from 'node:crypto';

/**
 * Hashes the input using SHA3-512 algorithm.
 * @param input - Input string.
 * @returns Hash output as Gleam's `BitArray`.
 */
export function hash(input: string): BitArray {
  const encoder = new TextEncoder();
  const data = encoder.encode(input);
  const hash = nodeHash('SHA3-512', data, 'buffer');
  return new BitArray(hash);
}

/*
  A stupid dumb bit-set prime sieve or trial divisor?
  Just to see how fast it is in C.
*/
#include <stdio.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#define byte_index(n) (n / 64)
#define bit_index(n) (n % 64)

#define get_bit_by(a, n) (a[byte_index(n)] & (1UL << bit_index(n)))
#define set_bit_by(a, n, v) (a[ byte_index(n) ] ^= ( ((-(uint64_t)v) ^ a[ byte_index(n) ]) & 1UL << bit_index(n)))

uint64_t* sieve_bits (const uint64_t n, /* out */ uint64_t* const used_bytes);
bool is_prime_sieve (const uint64_t* const sieve, const uint64_t val);
bool is_prime (const uint64_t val);
void print_binary(const uint64_t number);

void print_binary(const uint64_t number) {
  if (number) {
    print_binary(number >> 1);
    putc((number & 1) ? '1' : '0', stdout);
  }
}

uint64_t* sieve_bits (const uint64_t max_size, /* out */ uint64_t* const used_bytes) {
  if ( max_size < 3 || NULL == used_bytes ) { return NULL; }

  const size_t need_bytes = *used_bytes = byte_index(max_size) + (bit_index(max_size) > 0 ? 1 : 0);

  //printf("need: %" PRIu64 " bytes\n", need_bytes);

  uint64_t* const bits = malloc((sizeof (uint64_t)) * need_bytes);
  for (size_t i = 0; i < need_bytes; i++) {
    bits[i] = UINT64_MAX;
  }

  // undefined primality
  set_bit_by(bits, 0, false);
  set_bit_by(bits, 1, false);


  // i is each bit
  for (size_t i = 2; i < max_size; i++) {
    const bool curr_bit = get_bit_by(bits, i);
    if (curr_bit) {
      for (size_t j = i * i; j < max_size; j += i) { // note the step
        //printf("i: %zu j: %zu\n", i, j);
        set_bit_by(bits, j, false);
      }
    }
  }

  return bits;
}

bool is_prime_sieve (const uint64_t* const sieve, const uint64_t val) {
  return get_bit_by(sieve, val);
}

/*
  faster, no sieve
*/
bool is_prime (const uint64_t val) {
  if (val < 2) { return false; }
  if (val == 2 || val == 3 || val == 5 || val == 7 || val == 9) { return true; }
  if (!(val % 2) || !(val % 3) || !(val % 5) || !(val % 7) || !(val % 9)) { return true; }

  int64_t w = 2;
  int64_t i = 5;
  const uint64_t sqv = (uint64_t) sqrt((double) val);

  for (; ((uint64_t) i) <= sqv; i += w) {
    if (! (val % ((uint64_t) i)) ) { return false; }
    w = 6 - w;
  }

  return true;
}

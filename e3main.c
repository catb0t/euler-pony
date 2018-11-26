#include <stdio.h>
#include <inttypes.h>
#include <assert.h>

#include "e3.h"

int main(void) {
/*  size_t sz = 0;
  const size_t n = 22222223;
  uint64_t* const sieve = sieve_bits(n, &sz);
*/
/*
  for (size_t i = 0; i < sz; i++) {
    printf("%" PRIu64 ": 0b", sieve[i]);
    print_binary(sieve[i]);
    puts("");
  }
*/
  for (size_t i = 0; i < 10000000; i++) {
    is_prime(600851475143); //printf("%d", );
  }
/*
  for (size_t i = 0; i < n; i++) {
    if (is_prime(sieve, i)) {
      printf("%" PRIu64 "\n", i);
    }
  }
  free(sieve);
*/
  return 0;
}

#include <criterion/criterion.h>
#include "e3.h"

Test(primes, index) {
  cr_assert_eq(byte_index(0), 0);
  cr_assert_eq(byte_index(1), 0);
  cr_assert_eq(byte_index(63), 0);
  cr_assert_eq(byte_index(64), 1);
  cr_assert_eq(byte_index(120), 1);
  cr_assert_eq(byte_index(127), 1);
  cr_assert_eq(byte_index(128), 2);
  cr_assert_eq(byte_index(1200), 18);
  cr_assert_eq(byte_index(6857), 107);

  cr_assert_eq(bit_index(0), 0);
  cr_assert_eq(bit_index(1), 1);
  cr_assert_eq(bit_index(63), 63);
  cr_assert_eq(bit_index(64), 0);
  cr_assert_eq(bit_index(120), 56);
  cr_assert_eq(bit_index(127), 63);
  cr_assert_eq(bit_index(128), 0);
  cr_assert_eq(bit_index(1200), 48);
  cr_assert_eq(bit_index(6857), 9);
}

use "collections"
use "itertools"
//use "inspect"
//use "debug"

/*class iso E3 is MicroBenchmark
  let v: U64
  new iso create(v': U64) => this.v = v'
  fun name(): String => "e3(" + this.v.string() + ")"
  fun apply() => DoNotOptimise[U64](this.e3(this.v)); DoNotOptimise.observe()

  fun e3 (n: U64): U64 =>
    n
*/
actor E3Main // is BenchmarkList
  //let e3_i: U64 = 600851475143

  new create (env: Env) =>
/*    env.out.print(
      "#3: largest factor of 600851475143" +
      "\t" + this.e3(this.e3_i).string()
      // "\t" + this.e1_rec(this.e1_i).string() +
      // "\t" + this.e1_fun(this.e1_i).string() +
      // "\t" + this.e1_fun2(this.e1_i).string()
    )
*/
    for i in Range[U64](0, 10000000) do
      is_prime(22222222)
    end

/*    assert_t[USize, U128](env, "index 0", index_128(0), (0, 0))
    assert_t[USize, U128](env, "index 1", index_128(1), (0, 1))
    assert_t[USize, U128](env, "index 127", index_128(127), (0, 127))
    assert_t[USize, U128](env, "index 128", index_128(128), (1, 0))
    assert_t[USize, U128](env, "index 170", index_128(170), (1, 42))
    assert_t[USize, U128](env, "index 255", index_128(255), (1, 127))
    assert_t[USize, U128](env, "index 256", index_128(256), (2, 0))
    assert_t[USize, U128](env, "index 1200", index_128(1200), (9, 48))
    assert_t[USize, U128](env, "index 6857", index_128(6857), (53, 73))

    assert_bit(env, "bit 9", 512, 9)
    assert_bit(env, "bit 10", 1024, 10)
    assert_bit(env, "bit 128", F64(2.0).pow(127).u128(), 127)
    assert[Bool](env, "prime? 2", is_prime(2), true)
    assert[Bool](env, "prime? 3", is_prime(3), true)
    assert[Bool](env, "prime? 5", is_prime(5), true)
    assert[Bool](env, "prime? 17", is_prime(17), true)
    assert[Bool](env, "prime? 37", is_prime(37), true)
    assert[Bool](env, "prime? 47", is_prime(47), true)
    assert[Bool](env, "prime? 101", is_prime(101), true)
    assert[Bool](env, "prime? 1009", is_prime(1009), true)
    assert[Bool](env, "prime? 2003", is_prime(2003), true)
    assert[Bool](env, "prime? 4001", is_prime(4001), true)
    assert[Bool](env, "prime? 6007", is_prime(6007), true)
    assert[Bool](env, "prime? 6857", is_prime(6857), true)
    assert[Bool](env, "prime? 6863", is_prime(6863), true)
    assert[Bool](env, "prime? 22222222", is_prime(22222222), false)
*/    //assert[Bool](env, "prime? 600851475143", is_prime(600851475143), false)
    //assert[Bool](env, "prime? 11111111111411", is_prime(11111111111411), true)
    //PonyBench(env, this)
/*
  fun tag benchmarks(bench: PonyBench) =>
    let e3': U64 = 1000

    bench(E3(e3'))
*/
  fun assert[T: (Equatable[T] val & Stringable val)](env: Env, name: String, a: T, b: T): Bool =>
    let f = name + ":\t(" + a.string() + " == " + b.string() + ")"
    if a == b then
      /*Debug*/env.out.print("PASS: " + f)
      true
    else
      /*Debug*/env.out.print("FAIL: " + f + " failed!")
      false
    end

  fun assert_t[A: (Equatable[A] val & Stringable val), B: (Equatable[B] val & Stringable val)](env: Env, name: String, a: (A, B), b: (A, B)): Bool =>
    let f = name + ":\t( (" + a._1.string() + ", " + a._2.string() + ") == (" + b._1.string() + ", " + b._2.string() + ") )"
    if (a._1 == b._1) and (a._2 == b._2) then
      /*Debug*/env.out.print("PASS: " + f)
      true
    else
      /*Debug*/env.out.print("FAIL: " + f + " failed!")
      false
    end

  fun assert_bit(env: Env, name: String, x: U128, hasbit: U128): Bool =>
    assert[U128](env, name, x, (x and (1 << hasbit)))

  fun assert_set(env: Env, name: String, x: U128, hasbit: U128): Bool =>
    assert[U128](env, name, x, (x or (1 << hasbit)))

  fun sieve(n: U64): Array[Bool] =>
    let record: Array[Bool] = Array[Bool].init(true, n.usize())
    try
      record.update(0, false)?
      record.update(1, false)?
    end

    for i in Range[U64](0, n) do
      if try record(i.usize())? else false end == true then
        for j in Range[U64](i * i, n, i) do
          try record.update(j.usize(), false)? end
          if j > n then break end
        end
      end
    end

    record

  /* fits in a U8 because of 128 bits */
  fun index_128 (idx: U128): (USize, U128) =>
    ((idx / 128).usize(), (idx % 128))

  fun sieve_bits(n: U128): Array[U128] =>
    let sizes = index_128(n)
    let n_128s = sizes._1 + (if sizes._2 == 0 then 0 else 1 end)
    let bits: Array[U128] = Array[U128].init(U128.max_value(), n_128s) // all the bits are set, hopefully

    let z = index_128(0)
    try
      let c = bits(z._1)? // U128 index holding the wanted bit
      let newval: U128 = c xor (1 << z._2)
      bits.update(z._1, newval)?
    end
    let o = index_128(1)
    try
      let c = bits(o._1)?
      let newval: U128 = c xor (1 << o._2)
      bits.update(o._1, newval)?
    end

    for x in Range[U128](2, n) do
      let x_index = index_128(x)
      let c: U128 = try bits(x_index._1)? else 0 end
      let x_value: Bool = 0 != (c and (1 << x_index._2))
      if x_value then
        for y in Range[U128](x * x, n, x) do
          let y_index = index_128(y)
          try
            let c' = bits(y_index._1)?
            let y_value: U128 = c' xor (1 << y_index._2)
            bits.update(y_index._1, y_value)?
          end
          //Debug("set bit " + y_index._1.string() + " " + y_index._2.string())
          if y > n then break end
        end
      end
    end
    bits

  fun is_prime (n: U64): Bool =>
    if n == 2 then true
    elseif n < 18 then let f = [as U64: 3; 5; 7; 11; 17]; f.contains(n)
    elseif
      Iter[U64](
        [ (n and 1); n % 3; n % 5; n % 7; n % 11; n % 17 ].values()
      ).any({ (x) => x == 0 } )
      then false
    else
      // n is ODD and GREATER THAN 7
/*
      let record = sieve_bits((n+1).u128())
      let need_index = index_128(n.u128())
      let byte_at = try
         record(need_index._1)?
      else 0 end

      let is_set: Bool = 0 != (byte_at and (1 << need_index._2))
      //Debug(" " + need_index._1.string() + " " + need_index._2.string())
      is_set
*/

      let record = sieve(n+1)
      try
        record(n.usize())?
      else false end

    end

  // : next-odd' ( m -- n ) [ even? 1 2 ? ] keep + ;
  fun next_odd (n: U64): U64 =>
    n + if (n % 2) == 0 then 1 else 2 end

  // : next-prime ( n -- p ) dup 2 < [ drop 2 ] [ next-odd [ dup prime? ] [ 2 + ] until ] if ;
  fun next_prime_rec (n: U64): U64 =>
    let n' = next_odd(n)
    if is_prime(n') then n'
    else next_prime_rec(n') end

  fun next_prime (n: U64): U64 =>
    match n
    | 0 => 2
    | 1 => 2
    | 2 => 3
    | 3 => 5
    | 7 => 11
    else
      next_prime_rec(n)
    end

  fun factors (n: U64): Array[U64] =>
    if is_prime(n) then [1; n]
    else
      let fs: Array[U64] = Array[U64]
      var fac_cd = next_prime(0) // first prime: 2
      repeat
        if (n % fac_cd) == 0 then fs.push(fac_cd) end
        fac_cd = next_prime(fac_cd)
      until n < (fac_cd*fac_cd) end
      fs
    end

  fun e3 (n: U64): U64 =>
    try factors(n).pop()? else 0 end

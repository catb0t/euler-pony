use "collections"
use "itertools"
use "ponybench"

class iso E2 is MicroBenchmark
  let v: U64
  new iso create(v': U64) => this.v = v'
  fun name(): String => "e2(" + this.v.string() + ")"
  fun apply() => DoNotOptimise[U64](this.e2(this.v)); DoNotOptimise.observe()

  fun fib_tc (n: U64, l: U64 = 0, r: U64 = 1): U64 =>
    match n
      | 0 => 0
      | 1 => r
    else
      fib_tc(n - 1, r, l + r)
    end

  fun fltr (lt: U64, curr_fib: U64 = 2, arr: Array[U64] = []): Array[U64] =>
    let f = fib_tc(curr_fib) //fib(curr_fib-1) + fib(curr_fib-2)
    if f >= lt then arr
    else arr.push(f); fltr(lt, curr_fib + 1, arr) end

  fun fibs_lt_rec (lt: U64): Array[U64] =>
    fltr(lt)

  // END SIMPLE FIBGEN

  fun e2 (lt: U64): U64 =>
    var res: U64 = 0
    for i in Iter[U64](fibs_lt_rec(lt).values()) do
      if (i % 2) == 0 then res = res + i end
    end
    res

class iso E2r is MicroBenchmark
  let v: U64
  new iso create(v': U64) => this.v = v'
  fun name(): String => "e2_rec(" + this.v.string() + ")"
  fun apply() => DoNotOptimise[U64](this.e2_rec(this.v)); DoNotOptimise.observe()

  fun fib_tc (n: U64, l: U64 = 0, r: U64 = 1): U64 =>
    match n
      | 0 => 0
      | 1 => r
    else
      fib_tc(n - 1, r, l + r)
    end
  // END SIMPLE FIBGEN

  fun e2_rec (lt: U64, curr_fib: U64 = 1, s: U64 = 0): U64 =>
    let f = fib_tc(curr_fib)
    if f >= lt then s
    else e2_rec(lt, curr_fib + 1, s + if (f % 2) == 0 then f else 0 end) end

class iso E2f is MicroBenchmark
  let v: U64
  new iso create(v': U64) => this.v = v'
  fun name(): String => "e2_fun(" + this.v.string() + ")"
  fun apply() => DoNotOptimise[U64](this.e2_fun(this.v)); DoNotOptimise.observe()

  fun e2_fun (lt: U64): U64 =>
    Iter[U64](Range[U64](0, lt / 20000))
      .fold[U64](0, {
        (sum, x) =>
          let f = FibTC(x)
          sum + if (f < lt) and ((f % 2) == 0) then f else 0 end
      })


class FibTC
  new create () => None
  fun apply (n: U64, l: U64 = 0, r: U64 = 1): U64 =>
    match n
      | 0 => 0
      | 1 => r
    else
      apply(n - 1, r, l + r)
    end

actor E2Main is BenchmarkList
  let e2_i: U64 = 4_000_000

  new create (env: Env) =>
    env.out.print(
      "#2: even fibs < 4mil" +
      "\t" + e2(e2_i).string() +
      "\t" + e2_rec(e2_i).string() +
      "\t" + e2_fun(e2_i).string()
    )
    //for i in Range(0, 400000) do DoNotOptimise[U64](this.e2_fun(e2_i)); DoNotOptimise.observe() end
    //env.out.print("\t" + this.e2(this.e2_i).string())
    //env.out.print("\t" + this.e2_rec(this.e2_i).string())
    //env.out.print("\t" + this.e2_fun(this.e2_i).string())
    //env.out.print("\t" + this.e2_fun2(this.e2_i).string())

    PonyBench(env, this)

  fun tag benchmarks (bench: PonyBench) =>
    let e2': U64 = 4_000_000

    bench(E2(e2'))
    bench(E2r(e2'))
    bench(E2f(e2'))
    //bench(E2f2(e2'))

  // SIMPLE FIBGEN

  fun fib (n: U64): U64 =>
    match n
      | 0 => 0
      | 1 => 1
      | 2 => 1
      | 3 => 2
      | 4 => 3
      | 5 => 5
      | 6 => 8
    else
      fib(n-1) + fib(n-2)
    end

  fun fib_tc (n: U64, l: U64 = 0, r: U64 = 1): U64 =>
    match n
      | 0 => 0
      | 1 => r
    else
      fib_tc(n - 1, r, l + r)
    end

  fun fltr (lt: U64, curr_fib: U64 = 2, arr: Array[U64] = []): Array[U64] =>
    let f = fib_tc(curr_fib) //fib(curr_fib-1) + fib(curr_fib-2)
    if f >= lt then arr
    else arr.push(f); fltr(lt, curr_fib + 1, arr) end

  fun fibs_lt_rec (lt: U64): Array[U64] =>
    fltr(lt)

  // END SIMPLE FIBGEN

  fun e2 (lt: U64): U64 =>
    var res: U64 = 0
    for i in Iter[U64](fibs_lt_rec(lt).values()) do
      if (i % 2) == 0 then res = res + i end
    end
    res

  fun e2_rec (lt: U64, curr_fib: U64 = 1, s: U64 = 0): U64 =>
    let f = fib_tc(curr_fib)
    if f >= lt then s
    else e2_rec(lt, curr_fib + 1, s + if (f % 2) == 0 then f else 0 end) end

  fun e2_fun (lt: U64): U64 =>
    Iter[U64](Range[U64](0, lt / 20000))
      .fold[U64](0, {
        (sum, x) =>
          let f = FibTC(x)
          sum + if (f < lt) and ((f % 2) == 0) then f else 0 end
      })

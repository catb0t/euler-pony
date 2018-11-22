// use "inspect"
// use "assert"
// use "debug"
use "collections"
use "itertools"
use "ponybench"

class iso E1 is MicroBenchmark
  let v: U64
  new iso create(v': U64) => this.v = v'
  fun name(): String => "e1(" + this.v.string() + ")"
  fun apply() => DoNotOptimise[U64](this.e1(this.v)); DoNotOptimise.observe()

  fun e1 (n: U64): U64 =>
    var res: U64 = 0
    for i in Range[U64](0, n) do
      if (0 == (i % 3)) or (0 == (i % 5)) then res = res + i end
    end; res

class iso E1r is MicroBenchmark
  let v: U64
  new iso create(v': U64) => this.v = v'
  fun name(): String => "e1_rec(" + this.v.string() + ")"
  fun apply() => DoNotOptimise[U64](this.e1_rec(this.v)); DoNotOptimise.observe()

  fun e1_rec (n: U64, sum: U64 = 0, rec: Bool = false): U64 =>
    let n' = if (false == rec) and (0 != n) then n - 1 else n end
    if n' == 0 then sum
    else this.e1_rec(n', sum + if ((n' % 3) == 0) or ((n' % 5) == 0) then n' else 0 end) end

class iso E1f is MicroBenchmark
  let v: U64
  new iso create(v': U64) => this.v = v'
  fun name(): String => "e1_fun(" + this.v.string() + ")"
  fun apply() => DoNotOptimise[U64](this.e1_fun(this.v)); DoNotOptimise.observe()

  fun e1_fun (n: U64): U64 =>
    Iter[U64](Range[U64](0, n))
      .filter({(x) => ((x % 3) == 0) or ((x % 5) == 0) })
      .fold[U64](0, {(sum, x) => sum + x })

class iso E1f2 is MicroBenchmark
  let v: U64
  new iso create(v': U64) => this.v = v'
  fun name(): String => "e1_fun2(" + this.v.string() + ")"
  fun apply() => DoNotOptimise[U64](this.e1_fun2(this.v)); DoNotOptimise.observe()

  fun e1_fun2 (n: U64): U64 =>
    Iter[U64](Range[U64](0, n))
      .fold[U64](0, {
        (sum, x) => sum + if ((x % 3) == 0) or ((x % 5) == 0) then x else 0 end
    })

actor E1Main is BenchmarkList
  let e1_i: U64 = 1000

  new create (env: Env) =>
    env.out.print(
      "#1: mod 3,5 < 1000" +
      "\t" + this.e1(this.e1_i).string() +
      "\t" + this.e1_rec(this.e1_i).string() +
      "\t" + this.e1_fun(this.e1_i).string() +
      "\t" + this.e1_fun2(this.e1_i).string()
    )

    PonyBench(env, this)

  fun tag benchmarks(bench: PonyBench) =>
    let e1': U64 = 1000

    bench(E1(e1'))
    bench(E1r(e1'))
    bench(E1f(e1'))
    bench(E1f2(e1'))

  fun e1 (n: U64): U64 =>
    var res: U64 = 0
    for i in Range[U64](0, n) do
      if (0 == (i % 3)) or (0 == (i % 5)) then res = res + i end
    end; res

  fun e1_rec (n: U64, sum: U64 = 0, rec: Bool = false): U64 =>
    let n' = if (false == rec) and (0 != n) then n - 1 else n end
    if n' == 0 then sum
    else this.e1_rec(n', sum + if ((n' % 3) == 0) or ((n' % 5) == 0) then n' else 0 end) end

  fun e1_fun (n: U64): U64 =>
    Iter[U64](Range[U64](0, n))
      .filter({(x) => ((x % 3) == 0) or ((x % 5) == 0) })
      .fold[U64](0, {(sum, x) => sum + x })

  fun e1_fun2 (n: U64): U64 =>
    Iter[U64](Range[U64](0, n))
      .fold[U64](0, {
        (sum, x) => sum + if ((x % 3) == 0) or ((x % 5) == 0) then x else 0 end
    })

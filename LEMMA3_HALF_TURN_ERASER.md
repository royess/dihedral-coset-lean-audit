# A global half-turn primitive as a possible Lemma 3 repair

Reference: [IACR ePrint 2026/1591](https://eprint.iacr.org/2026/1591)

## Status

This note investigates a genuinely different replacement for the local
grouping and first-zero decoder used after Step 2.  The proposed primitive is
information-theoretically well defined, and an exact signed-frame formula
identifies its polar part.  No polynomial-time implementation is currently
known or supplied here.  Conversely, this note does **not** prove that a
polynomial implementation is impossible: a direct two-outcome half-turn test
may be weaker than coherent preparation of an entire subset-sum fibre.

The conclusion is therefore a research boundary, not a repaired theorem:

- the desired operation exists as a partial isometry on the occupied
  fibre-uniform subspace;
- random modular subset sum makes the frame normalization exponentially close
  to the identity on the occupied fibre-uniform support when `m = c*n` and
  `c > 2`, so fibre imbalance is not the computational obstruction;
- generic postselection, amplitude amplification, and polar-decomposition
  implementations cost about `sqrt(N) = 2^(n/2)`;
- the most explicit direct candidate is a signed sum of product-state frame
  projectors, but its natural implementation has the same cancellation and
  normalization barrier;
- obtaining polynomial time would require a new average-case subset-sum
  sampling or direct-measurement idea.

## Fibre formulation

Let

```text
N = 2^n,
H = N/2,
f_Y(x) = sum_i x_i * Y_i mod N,
F_t = {x : f_Y(x) = t},
eta_t = |F_t|.
```

For every nonempty fibre define its normalized state

```text
|F_t> = eta_t^(-1/2) * sum_(x in F_t) |x>.
```

The top bit of `t` distinguishes the pair `t` and `t+H`, while the residue
`t mod H` is common.  An ideal `HalfTurnEraser` would act on the occupied
fibre-uniform subspace as

```text
|F_t>     -> |t mod H> |0> |garbage_(t mod H)>,
|F_(t+H)> -> |t mod H> |1> |garbage_(t mod H)>.
```

The same garbage on both halves is essential.  If the input carries relative
phase `(-1)^d`, a final Hadamard on the half bit recovers `d`.  If the two
fibre weights are not exactly equal, the normalized two-branch state is

```text
(sqrt(eta_t) |0> + (-1)^d sqrt(eta_(t+H)) |1>)
/ sqrt(eta_t + eta_(t+H)),
```

and the wrong-bit probability is exactly

```text
(sqrt(eta_t) - sqrt(eta_(t+H)))^2
/ (2 * (eta_t + eta_(t+H))).
```

Thus concentration of random high-density subset-sum fibre sizes would make
the information-theoretic decoder accurate.  It does not by itself provide a
circuit for erasing the path index.

## Exact partial isometry

Define the incidence map

```text
J_Y |x> = |f_Y(x)>.
```

Then

```text
J_Y |F_t> = sqrt(eta_t) |t>.
```

The polar partial isometry of `J_Y` therefore maps `|F_t>` exactly to `|t>` on
the row space.  Relabelling `t` as `(t mod H, highBit(t))` gives an exact
information-theoretic `HalfTurnEraser`.  Equivalently, if clean controlled
preparation circuits

```text
U_(Y,t) |0> = |F_t>
```

were available, applying their inverses branchwise would erase the fibre and
leave the half bit coherent.

This construction is an existence statement.  Implementing the polar
partial isometry, or implementing the controlled uniform fibre sampler, is
the computational problem.

## A concrete signed-frame candidate

Let `omega` be a primitive `N`-th root of unity and let `m` be the number of
Boolean variables in the selected subset-sum instance.  For `q in ZMod N`,
define the efficiently describable product state

```text
|psi_q> = 2^(-m/2) * sum_x omega^(q * f_Y(x)) |x>
        = tensor_i (|0> + omega^(q * Y_i) |1>) / sqrt(2).
```

Consider the signed frame operator

```text
K_Y = sum_(q in ZMod N) (-1)^q |psi_q><psi_q|.
```

Fourier orthogonality gives the exact identity

```text
K_Y |F_t>
  = (N / 2^m) * sqrt(eta_t * eta_(t+H)) * |F_(t+H)>.
```

Hence the polar part of `K_Y` is precisely the half-turn swap

```text
|F_t> <-> |F_(t+H)>
```

on every paired nonempty fibre.  When all fibre sizes are close to
`2^m/N`, the singular values of `K_Y` on the fibre-uniform subspace are close
to one.  This is the clearest positive structural candidate found in this
investigation: the desired global operation is already encoded by a signed
sum of simple product-state projectors.

There is also an exact normalized formula that does not require balanced
fibres.  Let

```text
P_Y = sum_q |psi_q><psi_q|.
```

On the normalized fibre basis put `p_t = N*eta_t/2^m`.  Then

```text
P_Y = sum_t p_t |F_t><F_t|,
K_Y = sum_t sqrt(p_t*p_(t+H)) |F_(t+H)><F_t|.
```

Consequently, on the support where both paired fibres are nonempty,

```text
T_Y = P_Y^(-1/2) K_Y P_Y^(-1/2)
    = sum_t |F_(t+H)><F_t|
```

is the exact half-turn swap.  The ideal two-outcome test is the projective
measurement with effects `(Pi + T_Y)/2` and `(Pi - T_Y)/2`, where `Pi` is the
support projector.  Fibre balance is needed only to replace the normalized
operator `T_Y` by the raw signed frame `K_Y`; it is not needed for this exact
identity.

## What random fibres actually buy

Randomness gives a strong positive algebraic simplification.  Put

```text
W_Y = sum_q |psi_q><q|,
B_Y = W_Y / sqrt(N).
```

Then `W_Y * W_Y^dagger = P_Y`, and in the Fourier basis on its `q` input,

```text
W_Y^dagger * W_Y = F_N^dagger * diag(p_t) * F_N,
p_t = N*eta_t/2^m.
```

For uniform independent `Y_i`, two distinct nonzero Boolean masks have
independent uniform subset sums.  After separating the deterministic zero
mask, this gives

```text
E[eta_t] = 2^m/N + a zero-mask correction,
Var(eta_t) <= 2^m/N,
Pr[max_t |eta_t-2^m/N| > delta*2^m/N + 1]
  <= N^2 / (delta^2 * 2^m).
```

For example, choose any `0 < alpha < (c-2)/2` and put
`delta = 2^(-alpha*n)`.  The failure probability is at most
`2^(-(c-2-2*alpha)*n)`, while

```text
max_t |p_t-1| <= 2^(-alpha*n) + 2^(-(c-1)*n).
```

Thus for `m = c*n` and `c > 2`, every `p_t` is simultaneously exponentially
close to one with overwhelming probability.  If

```text
V_Y = W_Y * (W_Y^dagger * W_Y)^(-1/2)
```

is the polar isometry, then on this event

```text
||V_Y-W_Y|| <= max_t |sqrt(p_t)-1|.
```

So, on the occupied fibre-uniform support (equivalently, on the `q` input of
`W_Y^dagger*W_Y`), the random instance makes the whitening step essentially free: the raw
synthesis `W_Y` is already an approximate isometry, and the ideal parity
observable `V_Y D_parity V_Y^dagger` is close to the raw signed frame `K_Y`.
This resolves the *relative fibre-balance* issue.  It does not implement
`W_Y`: the efficient controlled preparation still carries the input label
`q`, and erasing or coherently decoding that label is the hard step.

The obstacle is implementation rather than algebra.  The signed sum contains
`N` terms and obtains its useful action through exponential cancellation.
The natural LCU or block-encoding normalization is of order `N`; merely
knowing that the final operator is almost unitary on a special subspace does
not supply a circuit that realizes those cancellations at unit scale.

## Generic implementation costs

Several standard constructions all expose the same `sqrt(N)` scale.

1. Preparing a uniform Boolean superposition and postselecting one value of
   `f_Y` succeeds with probability approximately `1/N`.  Generic amplitude
   amplification therefore takes `Theta(sqrt(N))` uses of the subset-sum
   oracle.
2. Preparing the pair `{t,t+H}` only doubles that probability and does not
   change the exponential scale.
3. A natural block encoding of the incidence or signed-frame operator has
   singular-value/normalization scale about `N^(-1/2)`.  Generic QSVT or polar
   transformation again needs degree of order `sqrt(N)`.
4. Coherent pretty-good-measurement implementations require the same
   inverse-square-root frame operation.  A clean uniform fibre sampler would
   solve it, but constructing that sampler is exactly the missing primitive.
5. Hashing a large fibre down to unique or polynomial-size buckets removes
   the multiplicity only by adding about `n` constraints.  The remaining
   inversion problem has density near one and generic search again costs
   `Theta(sqrt(N))`.

These are barriers for the standard oracle and block-encoding routes, not an
unconditional circuit lower bound for random arithmetic subset sum.

## A constructive reduction: free coordinates plus a correction kernel

There is a useful positive construction between full fibre rank/unrank and a
purely black-box search.  Split the Boolean coordinates into a free set `R`
and a correction set `C`, and write

```text
f_Y(g,c) = f_R(g) + f_C(c) mod N.
```

Assume that `|C| = n+s` and that there is a reversible polynomial-time
encoder

```text
e_C : ZMod N -> {0,1}^C,
f_C(e_C(r)) = r.
```

For every free string `g`, define

```text
x_0(g) = (g, e_C(t   - f_R(g))),
x_1(g) = (g, e_C(t+H - f_R(g))).
```

Then `f_Y(x_0(g))=t` and `f_Y(x_1(g))=t+H`, while both paths have the same
free label `g`.  Computing and then uncomputing the two correction words gives
the clean branchwise action

```text
|0>|x_0(g)> -> |0>|g>|0>,
|1>|x_1(g)> -> |1>|g>|0>.
```

Thus this interface is sufficient for an exact same-garbage half-turn
pairing.  In a balanced random fibre, the canonical graph contains `2^|R|`
paths out of approximately `2^(|R|+|C|)/N`, so its projected mass is

```text
N / 2^|C| = 2^(-s).
```

Taking `s=O(log n)` would therefore give inverse-polynomial success.  More
generally, if the encoder covers only a residue set of density `beta`, the
usable mass is approximately `beta*2^(-s)`; inverse-polynomial `beta` is still
enough.

This is a genuine constructive reduction, not an implementation.  For a
random correction set and a fixed target residue, the number `eta_r` of
Boolean representations has mean approximately `2^s` and variance at most
`2^s`, so a fixed target is missing with probability at most about `2^(-s)`.
That establishes information-theoretic abundance.  It does not give a
uniform, canonical, reversible way to find a representation for the many
targets that occur coherently as `g` varies.  Computing `e_C(r)` is a random
modular subset-sum problem at density

```text
(n+s)/n = 1 + O(log n/n),
```

which is precisely the critical regime rather than an easy high-density
regime.

The full paper pool `Q=poly(n)` does not remove this tradeoff.  Making `C`
much larger makes representations more abundant but shrinks the mass of one
canonical representative by `N/2^|C|`.  To exploit a large correction set one
would need many coherently and symmetrically selected representatives, which
returns to fibre sampling or rank/unrank.

## Why an input-dependent partner is not easier

Suppose a proposed pairer receives a path `x` and searches for
`x'=x xor a`.  Put `s_i=1-2*x_i`.  The half-turn equation is exactly

```text
sum_i a_i * (s_i*Y_i) = H mod N.
```

For uniform random `Y_i`, the signed coefficients `s_i*Y_i` remain independent
and uniform.  Hence a pairer with inverse-polynomial coverage immediately
gives an inverse-polynomial-success solver for random modular subset sum:
choose a random `x`, sign a fresh RMSS instance by `s_i`, run the pairer, and
output `a=x xor x'`.

Quantum coherence imposes a further condition.  A distribution `q_A(a)` over
valid moves must be invariant under reversal of the edge:

```text
q_A(a) = q_(D_a A)(a),
```

where `D_a` negates the coefficients on the support of `a`.  Otherwise the
forward and reverse branches retain different solver histories as garbage.
Uniform sampling of all valid moves has the required symmetry, but is exactly
the missing fibre/partner-sampling primitive.  Greedy, lexicographic-first,
and ordinary randomized find-one algorithms do not automatically have this
property.

This also explains why a direct 2-adic triangular encoder was not found.
Among polynomially many random coefficients, the largest valuation supplied
directly is only `O(log n)` with overwhelming probability.  Synthesizing the
higher-valuation pivots requires modular collisions.  In a disjoint-support
list-merging construction with polynomial list width `L`, one level can remove
only `O(log L)` bits while retaining polynomially many candidates, and there
are only `O(log |C|)` Boolean-compatible merge levels.  This family therefore
handles only `O(log^2 n)` modulus bits with polynomial resources, not `n`.
This is a barrier for that construction family, not a lower bound for all
arithmetic quantum circuits.

## A one-shot measurement barrier after hash isolation

Hash isolation narrows the possible direct-decoder opening, but does not make
the hidden relative phase freely observable.  Consider the idealized bucket
state

```text
|Psi_d^(x,y)> = (|0,x> + (-1)^d |1,y>)/sqrt(2),
```

where `x` and `y` are independent unknown singleton labels in a domain of size
`D`.  Averaging over those labels gives

```text
rho_d = (I_2 tensor I_D)/(2D)
      + (-1)^d (X tensor |s><s|)/(2D),
|s> = D^(-1/2) sum_x |x>.
```

Consequently

```text
||rho_0-rho_1||_1 = 2/D,
P_opt(no queries) = 1/2 + 1/(2D).
```

The best phase information visible without finding or aligning the two labels
is therefore only of order `1/D`.

There is a matching constructive search curve for coherent erasure.  With
`theta=arcsin(D^(-1/2))`, applying `T` inverse-Grover iterations on each
branch and projecting the data register onto the common state `|s>` succeeds
with probability

```text
p_T = sin^2((2T+1)*theta).
```

On success the label is erased and a Hadamard reads `d`, giving total success
`1/2+p_T/2`.  Thus small `T` gives advantage `Theta(T^2/D)`, while constant
advantage takes `Theta(sqrt(D))` queries.

This square-root barrier is not confined to circuits that explicitly announce
an erasure step.  Here the random-singleton oracle model gives the decoder the
standard branch-controlled phase or equality oracles marking `x` and `y`.
Purifying an arbitrary `T`-query joint POVM with distinguishing advantage
`epsilon` and reflecting about its accepting outcome gives a `2T`-query
conversion procedure whose average probability of reaching the independent
second singleton is at least `4*epsilon^2`.  Grover optimality therefore
implies

```text
4*epsilon^2 <= sin^2((4T+1)*theta),
epsilon = O(T/sqrt(D)).
```

In particular, even a completely general one-shot measurement needs
`Omega(sqrt(D))` oracle queries for constant advantage.  The argument does not
prove the tighter small-query `O(T^2/D)` bound for every POVM.  More
importantly, it is an oracle-model lower bound: an explicit arithmetic circuit
could evade it only by exploiting structure beyond random preimage labels.
See [Zalka's optimality theorem](https://arxiv.org/abs/quant-ph/9711070) and
the related phase-distinguishing-to-preimage-conversion argument in
[From the Hardness of Detecting Superpositions to Cryptography](https://eprint.iacr.org/2022/1375.pdf).

The hash tradeoff can also be seen without query lower bounds.  If a bucket
has full-domain size `D`, its expected number of opposite-half partners is
`D/N`, so sparse-bucket paired mass is about `D/N`.  Frequencies that are safe
without learning the partner XOR occupy only a `1/D` fraction.  Their product
is `1/N`, independent of the bucket size.  A reusable public predictor for the
missing inner product would, through Goldreich--Levin list decoding and one
retained pair state, recover a short list of candidate partner moves and hence
reconstruct the eraser.  The only genuinely weaker opening is therefore a
distribution-specific, consume-once collective measurement; the singleton
oracle calculation above shows that black-box access is insufficient.

## Explicit non-polynomial realizations

The correction-kernel interface is implementable with exponential resources.
A deterministic meet-in-the-middle or dynamic-programming solver can be made
reversible and canonical, yielding a clean encoder at exponential cost.
Recent generic quantum subset-sum search improves the search exponent to
`O*(2^(2k/7))` for `k` variables, but a search algorithm that returns an
arbitrary solution is not by itself a clean coherent encoder; canonical
selection and garbage removal remain additional obligations:

- [Improved Quantum Algorithms for Subset Sum and k-SUM](https://arxiv.org/abs/2608.07309)

For random high-density modular subset sum, the known Wagner-style route is
subexponential in its applicable parameterization and finds one solution
rather than supplying the edge-symmetric encoder needed here:

- [On Random High Density Subset Sums](https://eccc.weizmann.ac.il/report/2005/007/download/)

These algorithms make the positive interface concrete, but do not turn it
into a polynomial repair.  In particular, the polynomial number of samples in
the paper does not enter the proven polynomial regime for an exact `n`-bit
modulus.

The block-encoding statement can be made precise in the natural
product-preparation oracle model.  Controlled preparation of
`|q>|psi_q>` followed by projection of `q` onto the uniform state encodes the
analysis/synthesis map divided by `sqrt(N)`.  More explicitly, projecting the
efficient state

```text
sum_q alpha_q |q>|psi_q>
```

onto a uniform `q` register produces `W_Y sum_q alpha_q|q> / sqrt(N)`.
Even when `W_Y` is exponentially close to an isometry, this branch has
probability `(1+o(1))/N`.  Generic singular-value amplification or polar QSVT
therefore uses `Theta(sqrt(N))` oracle calls.  The good condition number of
`W_Y` does not remove the common physical `1/sqrt(N)` access scale.  This is a
lower bound for that PREP/block-encoding implementation model, not for
circuits allowed to exploit the explicit modular arithmetic of the `Y_i` in
some new way.

## A weaker target: `HalfTurnTest`

Full coherent erasure is stronger than necessary.  It would suffice to
implement the two-outcome measurement whose relevant vectors are

```text
(|F_t> + |F_(t+H)>) / sqrt(2),
(|F_t> - |F_(t+H)>) / sqrt(2).
```

This is the one-bit version of the subset-sum pretty-good measurement studied
by Bacon, Childs, and van Dam.  Their analysis shows that the information-
theoretic one-bit measurement has the same density threshold as the full
optimal DCP measurement, and connects restricted efficient implementation to
quantum sampling of subset-sum solutions.  In particular, a uniform fibre
sampler implements the test.  The reverse implication is not established in
the unrestricted circuit model, so a direct `HalfTurnTest` leaves a genuine
logical opening.

The signed-frame operator `K_Y` is currently the most concrete direct route to
such a test.  No implementation that exploits its tensor-product summands
while avoiding the `sqrt(N)` cancellation cost has been found.

An equivalent direct formulation isolates the precise missing operation.
Define the normalized synthesis map

```text
B_Y = (1/sqrt(N)) * sum_q |psi_q><q|.
```

If `B_Y = V_Y |B_Y|` is its polar decomposition, then on nonempty fibres
`V_Y` maps Fourier labels to the corresponding normalized fibre states.
Consequently the circuit

```text
apply V_Y^dagger; measure the parity of q
```

implements the ideal `HalfTurnTest` exactly.  This `ParityPGM` description is
strictly more direct than constructing and outputting a full classical fibre
sample.  It also shows why unequal fibre sizes are not the main problem: the
polar normalization removes them automatically.

In the balanced benchmark, the relevant singular values of `B_Y` are about
`1/sqrt(N)`.  Therefore a PREP/block-encoding/QSVT implementation of its polar
factor requires `Theta(sqrt(N))` calls, up to approximation logarithms.  This
same scale appears in a simple sampling lower bound for a narrower family of
algorithms.  On an ideal `+/-` fibre-pair input, a single rank-one projector
test against a sampled `|psi_q>` succeeds with probability at most `2/N`.
Even optimally importance-sampling the correct parity leaves second moment at
least `N/2`; a parity-symmetric sampler has second moment `N`.  Independent
classical trials thus need order `N`, while coherent amplification recovers
the order-`sqrt(N)` cost.  This rules out single-`q` projector sampling as a
polynomial implementation, not arbitrary collective arithmetic circuits.

There is an important distinction between two meanings of “weaker.”  A
distribution-specific procedure that consumes the natural DCP state and emits
one classical parity bit need not expose a reusable coherent fibre-pair
projector; no reduction from such a decoder to uniform fibre sampling is known
here.  That remains the genuine direct-decoder opening.  Even a clean reusable
`+/-` projective test supplies only the spectral projections of the half-turn
involution.  By itself it preserves all information within each paired-fibre
sector and does not construct `|F_t>` from a target label `t`.  Consequently
this investigation does **not** claim that the two-outcome test implies a
uniform fibre sampler.  The sampler-to-test direction is clear; the converse
is open and BCD's converse result concerns a more restricted implementation of
the complete measurement, not this bare two-outcome oracle.

## Structured implementation routes checked

The random arithmetic structure was examined directly, rather than treating
`W_Y` only as a black-box matrix.  It simplifies its spectrum but has not yet
produced a polynomial circuit.

1. A Fourier or circulant transform diagonalizes `W_Y^dagger*W_Y`.  This is
   exactly why the whitening estimate above is easy; it does not synthesize
   `W_Y` or erase the `q` index.
2. Abelian Schur/Fourier decomposition extracts the character label `t`, but
   its multiplicity space is precisely the subset-sum fibre.  Selecting the
   canonical vector `|F_t>` in that space is the original erasure problem.
3. Across a balanced split of the Boolean variables, the exact signed operator
   has the form

   ```text
   K_Y = (N/2^m) * sum_(a in ZMod N) A_a tensor B_(H-a).
   ```

   For random high-density instances these `N` Schmidt components have
   comparable size.  An exact tensor-network representation therefore has
   bond dimension `N`, and a rank-`r` Frobenius approximation has relative
   error of order `sqrt(1-r/N)`.  This blocks polynomial-bond-dimension MPO
   contraction, not arbitrary circuits.
4. A 2-adic recursion can compute `f_Y(x) mod N/2`, but inside each residue it
   still has to erase the multiplicity and coherently distinguish the two
   half-turn fibres.  The same problem reappears at the first recursive layer.
5. Leftover-hash and decoupling estimates prove that the *forward* subset-sum
   value is statistically close to uniform.  They do not invert the map or
   clean the preimage index.  Sequentially choosing Boolean variables leaves
   a final critical-density core; hash isolation makes a fibre small but still
   requires finding and coherently cleaning its element.
6. Lattice, meet-in-the-middle, Wagner, and local-relation approaches do not
   become polynomial at the paper's parameters.  In particular, with only
   polynomially many random coefficients, the expected number of signed
   half-turn relations supported on `O(log n)` coordinates is
   `2^(-n+O(log^2 n))`.  The identified high-density RMSS algorithms remain
   subexponential here and find a solution rather than prepare a clean uniform
   fibre state.

The sample/time tradeoff tells the same story.  The ideal collective PGM needs
only `Theta(n)` original DCP states above density one; the obstacle is its
circuit implementation.  A single sampled rank-one frame test is heralded
with probability `Theta(1/N)`, so independent repetition costs `Theta(N)`
blocks.  Coherent amplitude amplification improves that family to
`Theta(sqrt(N))`, but requires a re-preparable state and reflection; merely
possessing independent copies does not provide the Grover interface.
Polynomially increasing the block size only balances the fibres more sharply
and does not alter the common `1/sqrt(N)` synthesis scale.  Variable-time QSVT
also has no favourable tail to exploit because almost all relevant singular
values lie at the same scale.

## Why high density is not already a polynomial solution

For one selected group the paper uses `m = c*n` Boolean variables modulo an
`n`-bit modulus, so the subset-sum density is the constant `c`, not a growing
high-density regime.  Known results that solve certain medium-density random
instances in expected polynomial time require a much smaller modulus
bitlength, on the order of the square of the logarithm of the variable count;
that condition fails here.

More quantitatively, entering that proven polynomial regime for an `n`-bit
modulus would require at least `2^(Omega(sqrt(n)))` variables.  The paper has
only polynomially many samples, so increasing its fixed constant `c` does not
meet this condition.

Using all `Q = k*n^(c+1)` paper samples raises the density to about `n^c`, but
does not produce a known polynomial-time exact solver or coherent uniform
fibre sampler for an `n`-bit modulus.  Known high-density random modular
subset-sum methods instantiate here at subexponential, rather than
polynomial, cost.  Dynamic programming still has a state space of size `N`.

Moreover, finding one classical solution is insufficient.  A coherent eraser
needs nearly uniform amplitudes over a fibre, branch-independent clean
garbage, and a controlled inverse.  Reversible execution of a randomized
finder generally leaves the random seed and search path as which-path
garbage.

## Local-relation and fault-model cautions

A local signed toggle that changes the subset sum by `H` would satisfy

```text
sum_i sigma_i * Y_i = H mod N
```

on a small support.  For polynomially many random `Y_i`, the expected number
of such relations of support at most `C*log n` is bounded by

```text
sum_(r <= C*log n) binom(Q,r) * 2^r / N
  = 2^(-n + O(log^2 n)).
```

Thus a local quantum walk based on polynomially enumerable half-turn moves is
typically edgeless.  Relations begin only at support about
`n/log Q = Theta(n/log n)`; one fixed relation then applies to only a
`2^(-Theta(n/log n))` fraction of Boolean paths, so polynomially many such
moves do not cover a constant fraction of a fibre.

There is also a separate fault-support issue.  In a fixed classical fault
environment the faulty selection bits are fixed, so two paths that both lie in
the actual Step-2 affine-subcube support differ only on correct coordinates.
For such a supported pair, a half-turn of the full measured sum is also a
half-turn of the phase-relevant correct-coordinate sum because the common
faulty offset cancels.  The unresolved issue is implementation: a sampler or
pairing designed on the full Boolean cube may flip fixed faulty coordinates
and leave the actual affine-subcube support.  A valid primitive must preserve,
or coherently learn and respect, that unknown support decomposition; the
fault-free construction alone does not discharge this obligation.

## Relation to known DCP algorithms

The subset-sum connection is not accidental.  Bacon--Childs--van Dam identify
the pretty-good measurement and relate its restricted efficient
implementation to coherent sampling of subset-sum solution fibres:

- [Optimal measurements for the dihedral hidden subgroup problem](https://arxiv.org/abs/quant-ph/0501044)

Related work also supports treating exact coset/fibre unitaries as a
substantive algorithmic primitive rather than bookkeeping:

- [How Hard Is Deciding Trivial Versus Nontrivial in the Dihedral Coset Problem?](https://doi.org/10.4230/LIPIcs.TQC.2016.6)
- [Solving Medium-Density Subset Sum Problems in Expected Polynomial Time](https://crypto.ethz.ch/publications/FlaPrz05.html)
- [Random Modular Subset Sum](https://eccc.weizmann.ac.il/eccc-reports/2005/TR05-007/index.html)
- [Fast algorithm for quantum polar decomposition, pretty-good measurements, and the Procrustes problem](https://arxiv.org/abs/2106.07634)

There is a complete subexponential fallback for DCP: the Kuperberg/Regev
family of sieves runs in subexponential time, with variants trading time and
space.  These algorithms demonstrate that global phase collimation is
possible, but they do not give the polynomial-time repair sought here:

- [A Subexponential Time Algorithm for the Dihedral Hidden Subgroup Problem with Polynomial Space](https://arxiv.org/abs/quant-ph/0406151)
- [Another subexponential-time quantum algorithm for the dihedral hidden subgroup problem](https://arxiv.org/abs/1112.3333)

## Current verdict and next research question

The ideal `HalfTurnEraser` is mathematically coherent, and `K_Y` gives an exact
operator formula whose polar part is the desired swap.  Random subset-sum
fibres make the associated whitening matrix exponentially close to the
identity on the occupied fibre-uniform support, so unequal fibre sizes are not
the blocker.  The missing step is a
polynomial implementation of the synthesis/parity action itself.  The
investigation has not found one: PREP/QSVT, signed-projector sampling,
FFT/Schur decomposition, tensor-network contraction, 2-adic recursion,
hashing, lattice, and local-relation routes all retain an exponential cost in
the parameter regime at issue.  The best generic coherent scale identified is
`Theta(sqrt(N)) = 2^(n/2)`.

This is not a no-go theorem.  A distribution-specific collective circuit
could conceivably decode only the parity without exposing a reusable fibre
eraser.  But such a circuit is not a small completion of Lemma 3: usable at
successive dyadic moduli with fresh states, a polynomial one-bit decoder would
give a polynomial DCP algorithm by bit recursion.  It would therefore be a new
algorithmic breakthrough in exactly the problem the paper claims to solve.

The narrowest remaining positive question can now be stated through two
distinct sufficient interfaces:

> Can one either (a) use the product-state representation of `K_Y` to implement
> its sign/polar action on the random fibre-uniform input ensemble without the
> natural `sqrt(N)` normalization, or (b) extract `n+O(log n)` random
> correction coordinates with a reversible, inverse-polynomial-coverage
> modular subset-sum encoder?

A positive answer to either version would be a new DCP/subset-sum algorithmic
ingredient.  No such polynomial construction is supplied by the paper or
found in this investigation.  The random-singleton oracle model now has a
rigorous `Omega(sqrt(D))` constant-advantage barrier, but a negative answer for
the explicit arithmetic problem would require a stronger circuit-model or
average-case lower bound that is not presently available.

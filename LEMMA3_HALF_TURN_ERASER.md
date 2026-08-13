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
- a two-pool cross-filter with a large common label pool reduces the
  fault-free task to an ordinary exact-density random-target RMSS finder, but
  no polynomial finder is known;
- an independent or fixed-size random fault law permitted by the paper's
  marginal bounds causes a `2^(-Theta(n/log n))` common-label loss in this
  particular construction;
- that single-matching loss is not information-theoretic: a collective PGM on
  a fixed block of `12*n` raw samples separates the complete secret-labelled
  subspaces with error `O(1/log n) + 2^(-Omega(n))` under the repository's
  marginal fault assumptions, even for correlated fault locations and
  arbitrary fixed faulty bits.  The PGM is an existence theorem, not a
  polynomial circuit, so a positive efficient result still needs a new
  collective fault-aware decoder.

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
generally, let `T` be the residue set on which the encoder succeeds and define

```text
beta_pair = |T intersect (T-H)| / N.
```

The usable mass is approximately `beta_pair*2^(-s)`.  The density of `T`
alone is insufficient: `T` and `T-H` can be disjoint even when `T` has
positive density.  An inverse-polynomial `beta_pair` is sufficient.

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

This multiplicity tradeoff can be stated quantitatively.  For a correction
pool of `k` free bits, let

```text
mu = 2^k/N
```

be its typical number of solutions per target.  If a clean target-dependent
correction state is

```text
|phi_r> = sum_(x in F_r) alpha_x |x>,
sum_x |alpha_x|^2 = 1,
```

then the amount of the raw uniform fibre that it can capture is controlled by

```text
m_eff(r) = |sum_x alpha_x|^2 <= |support(phi_r)|.
```

The corresponding projection fraction is of order `m_eff/mu`.  Therefore an
inverse-polynomial fraction requires coherent support on at least
`mu/poly(n)` solutions.  When `k-n=omega(log n)`, a polynomial-size list of
solutions cannot remove the canonical-projection loss.  Retaining many
independent classical solver seeds does not supply this factor: after
normalization, each seed still selects one representative.  Gaining the full
multiplicity requires coherently erasing the seed or recovering a canonical
seed/rank from the physical solution, which is again the missing large-fibre
sampling or rank/unrank operation.  This is why each active correction pool in
the two-pool construction must stay near critical density even when a separate
large common label pool is available.

### A stronger reduction: two correction pools

Canonical rank/unrank is sufficient, but it is not necessary.  A two-pool
symmetrization reduces the same-garbage problem to an ordinary, bounded-time,
verifiable random-target modular subset-sum finder.

Let `C_0` and `C_1` be independent sets of

```text
k = n+s,        D = 2^k
```

random modular weights, with subset-sum maps `f_0` and `f_1`.  Suppose a
solver `S(C,r;z)` uses a retained random seed `z`, either returns a Boolean
preimage of `r` under `f_C`, or raises a verifiable failure flag.  It need not
return a canonical or uniformly random preimage.  Assume only the
random-instance, random-target success bound

```text
p = Pr_(C,r,z)[S(C,r;z) succeeds] >= 1/poly(n).
```

Choose a public random invertible affine map `pi` on `{0,1}^k`.  For a common
label `g` and two common solver seeds, compute

```text
a = S(C_0, t   - f_1(g);       z_0),
b = S(C_1, t+H - f_0(pi(g));   z_1).
```

Retain the label only when both calls succeed.  The two physical paths are

```text
x_0(g) = (a,       g),
x_1(g) = (pi(g),   b).
```

They satisfy `f(x_0(g))=t` and `f(x_1(g))=t+H` exactly.  Both solver circuits
are run on both half-turn branches.  On branch zero, compare and clear the
physical `C_0` block using `a`; on branch one, compare and clear the physical
`C_1` block using `b`.  A controlled swap and `pi^(-1)` put `g` in the same
register on both branches.  The seeds, solver outputs, and bounded solver
workspaces were computed from identical common inputs, so they are identical
garbage and can be retained.  For a deterministic computation conditional on
a classical retained seed, they can also be uncomputed after the matched
physical block is cleared.  A postselected coherent quantum solver need not be
uncomputable by simply applying its inverse, but its identical success
workspace can remain as common garbage.  Thus the accepted state has the
exact form

```text
(|0> + (-1)^d |1>) tensor |common garbage>.
```

This is the key improvement over the one-pool encoder.  The finder does not
need to be canonical, reversible as a mathematical function, uniform over a
fibre, or edge-reversal symmetric.  A classical randomized solver can be
made reversible by retaining its seed and bounded computation history.  The
same construction also accepts a cleanly success-flagged coherent solver:
the two solver-output amplitudes multiply in the same way on both branches,
and its common success workspace need not be erased.

The success calculation is explicit.  Write

```text
a_g = Pr_z[S(C_0, t   - f_1(g); z) succeeds],
b_h = Pr_z[S(C_1, t+H - f_0(h); z) succeeds],
Z_pi = E_g[a_g * b_(pi(g))].
```

For the equal-amplitude raw state on `F_t union F_(t+H)`, with uniform retained
classical seeds, let `eta_t` and `eta_(t+H)` be the two full `2k`-variable
fibre sizes.  The exact projected mass is then

```text
2*D*Z_pi / (eta_t + eta_(t+H)).
```

For balanced random fibres this is

```text
(N/D)*Z_pi * (1+negligible) = 2^(-s)*Z_pi*(1+negligible).
```

The affine permutation prevents the two solvers' good target sets from being
disjoint.  Two-transitivity gives the exact identities

```text
E_pi[Z_pi]   = mean(a)*mean(b),
Var_pi[Z_pi] = Var(a)*Var(b)/(D-1).
```

There is also a direct random-target bridge.  For a random `k`-weight pool,
the distinct-input collision identity gives

```text
E_C[TV(f_C(U_k), U_(ZMod N))]
  <= (1/2)*sqrt(N/D)
   = 2^(-s/2-1).
```

Equivalently, pairwise independence applies to distinct nonzero Boolean
words, while the deterministic zero word is handled separately; one obtains
`E[||P_C-U||_2^2] <= 1/D`.  Consequently the averages of `a_g` and `b_g`
differ from the solver's uniform random-target success probabilities by at
most the corresponding total variation errors.  Averaging over the two pools
yields

```text
E[mean(a)*mean(b)] >= p^2 - 2^(-s/2).
```

Taking

```text
s >= 4*log2(1/p) + O(1) = O(log n)
```

makes `Z_pi=Omega(p^2)` for a nonnegligible set of public choices, while the
additional factor `2^(-s)` remains inverse-polynomial.  The total heralded
success is therefore inverse-polynomial.

This sharpens the positive boundary considerably: in the fault-free model,
an inverse-polynomial-success average-case RMSS **find-one** algorithm at
density `1+O(log n/n)` is sufficient.  Clean uniform fibre sampling and
canonical rank/unrank are not separate requirements.  The construction does
not supply that finder.  No polynomial algorithm for this near-critical
random-target inversion problem was identified, so the computational blocker
remains, but it is now narrower than the one-pool formulation suggested.
The target is not made easier by being induced from a measured path; the
planted-path reduction below turns it exactly into a fresh fixed-half-turn
RMSS instance.

Unknown fixed faulty coordinates are a separate unresolved issue.  The
public-`Y` solver and its canonical predicate can still be run without knowing
the occupied affine subcube: candidate words outside the subcube simply have
zero input amplitude.  Thus hidden support membership is not an operational
prerequisite.  The missing statement is a lower bound on the overlap of the
two branchwise good-label sets under the actual fault distribution.

### Removing the `2^(-s)` loss with a large common label pool

The preceding reduction can be strengthened in the fault-free model.  Split
the physical selection register into `C_0 | C_1 | R`, with sizes `k`, `k`, and
`ell`.  Let

```text
Omega = {0,1}^(k+ell),
M     = |Omega|,
u     = (g,r),
sigma(u) = (h,s),
```

where `sigma` is a public efficiently reversible affine permutation.  Define

```text
a(u)       = S(C_0, t   - f_1(g) - f_R(r)),
b(sigma u) = S(C_1, t+H - f_0(h) - f_R(s)).
```

On joint success, use the paths

```text
x_0(u) = (a(u), g, r),
x_1(u) = (h, b(sigma u), s).
```

They lie in `F_t` and `F_(t+H)` respectively.  Both maps are injective because
the non-correction coordinates retain `u` or `sigma(u)`.  Run both bounded
solver computations on both branches and retain their seeds and workspaces.
After verifying and clearing the matched correction block, apply `sigma^(-1)`
on branch one and then use a branch-controlled swap of the `C_0` and `C_1`
label registers.  Both branches now place `(g,r)` in the same physical
registers.  The surviving label and all solver garbage are therefore
identical, so the half-turn phase is exact.

For deterministic seeds, let `G_sigma` be the labels on which both solvers
succeed.  In the equal-amplitude two-fibre state the exact accepted mass is

```text
2*|G_sigma| / (eta_t + eta_(t+H)).
```

For seed-averaged success functions `A(u)` and `B(v)`, put

```text
Z_sigma = (1/M) * sum_u A(u)*B(sigma(u)).
```

The exact mass is `2*M*Z_sigma/(eta_t+eta_(t+H))`.  Since the full register has
`2k+ell` bits, balanced random fibres give

```text
eta_t + eta_(t+H) = (2+o(1))*M*2^k/N,
P_accept           = (1+o(1))*(N/2^k)*Z_sigma.
```

Thus `k=n` removes the earlier `2^(-s)` projection loss.  A random affine
`sigma` is two-transitive, so

```text
E_sigma[Z_sigma]   = mean(A)*mean(B),
Var_sigma[Z_sigma] = Var(A)*Var(B)/(M-1).
```

Taking `ell=n+O(log n)` makes `f_R(U_ell)` inverse-polynomially close to
uniform in expected total variation; a larger linear `ell` gives exponential
error.  Consequently the residual targets reduce to ordinary uniform random
targets for independent, exactly `n`-variable RMSS instances.  The sufficient
primitive is therefore narrower still: a bounded, verifiable coherent
implementation of an inverse-polynomial-success random-target RMSS finder at
exact density one.  No polynomial implementation was found.

This refinement does not cure unknown faults.  If the occupied affine
subcubes in `C_0`, `C_1`, and `R` fix `f_0`, `f_1`, and `f_R` coordinates, put
`F=f_0+f_1+f_R`.  In the uniform benchmark a fully mixing `sigma` leaves one
uncancelled common-label overlap factor `2^(-F)` after normalization by the
smaller physical fibre.  At the paper's marginal scale `1/(c'*log n)`, every
such construction uses `Omega(n)` coordinates, and an allowed independent or
fixed-size random fault model has `F=Theta(n/log n)` typically.  The overlap
is then `2^(-Theta(n/log n))`.  Using all polynomially many paper coordinates
as `R` makes this worse.  A split-preserving permutation avoids part of the
raw intersection loss but no longer decorrelates the conditional per-slice
good-target sets.  A fault-aware eraser or flagged free coordinates would be
a genuinely new required interface.

The entropy boundary explains the potential loss.  If a correction pool has
`k=n+s` physical coordinates but only `u=k-f` of them are free in a fixed
fault environment, its occupied subcube contains at most `2^u` strings and can
cover at most

```text
min(1, 2^u/N) = min(1, 2^(s-f))
```

of uniformly random targets.  Inverse-polynomial target coverage therefore
requires `f <= s+O(log n)` unless the solver has a stronger support-aware
interface.

On arbitrary fixed environments there is nevertheless a sign-safe version.
Map every accepted branch path to a public common label `lambda`; retain every
rejected path as orthogonal garbage explicitly tagged by its branch.  In the
deterministic unit-amplitude special case, if each label contains the full
injective retained seed, solver output/history, and surviving path garbage,
and the accepted branch-label sets are `G_0` and `G_1`, the final readout is
exactly

```text
Pr[correct | retained state]
  = 1/2 + |G_0 intersect G_1| / (|G_0|+|G_1|).
```

For weighted solver outputs, the cardinality in the numerator is replaced by
the real inner product of the two common-label amplitude vectors.  The
cross-filter construction makes those common amplitudes nonnegative, so the
overlap is nonnegative: faults can erase the bias but cannot reverse it.  This
makes safe repetition possible once an inverse-polynomial overlap mass is
proved; it does not prove such a mass for an arbitrary fixed environment.
More precisely, rejected inputs must remain as orthogonal branch-tagged data,
not be many-to-one erased to a single marker; a `good` flag and the retained
original path/work registers make this map unitary.

Under an additional model in which faulty fixed bits are uniform relative to
the public solver, the expected common-label overlap loses the factor
`2^(-(f_0+f_1))`, while each branch's individual canonical projection retains
the same `2^(-s)` scale after normalization by its smaller physical fibre.
Thus `f_0+f_1=O(log n)` is sufficient for inverse-polynomial bias.  In the
paper's fault parameterization the marginal scale is `1/(c'*log n)`, so two
pools of size `n+O(log n)` contain `Theta(n/log n)` faults in expectation for
the standard independent fixed-rate model with constant `c'`.  More exactly,
that model gives

```text
E[2^(-(f_0+f_1))]
  = (1-1/(2*c'*log n))^(2k)
  = exp(-Theta(n/log n)).
```

The raw overlap is therefore subexponential rather than inverse-polynomial.
Marginal upper bounds alone do not force this many faults, but they permit
this independent model, so no theorem uniform over the permitted noise laws
can obtain a polynomial overlap from the present construction.  Choosing the pools
independently of `Y` and of the hidden fault pattern prevents adaptive
concentration, but it does not change this expectation.  What is not
established is a mechanism that exposes enough free coordinates or otherwise
removes this overlap loss.  The current
`RandomFixedBitsMixture` module is an abstract pushforward under an assumed
uniform fixed assignment and does not by itself supply that quantum
fault-mixture premise.  Consequently the two-pool construction is a genuine
fault-free reduction, but it does not yet meet the paper's noisy parameter
regime.

## Why an input-dependent partner is not easier

Suppose a proposed pairer receives a path `x` and searches for
`x'=x xor a`.  Put `s_i=1-2*x_i`.  The half-turn equation is exactly

```text
sum_i a_i * (s_i*Y_i) = H mod N.
```

There is an exact joint-distribution reduction.  Sample a fresh uniform RMSS
instance `A`, sample an independent uniform `x`, and set

```text
Y_i = (1-2*x_i)*A_i,
t   = f_Y(x) = -sum_i x_i*A_i mod N.
```

The map `(A,x) <-> (Y,x)` is a bijection, so this reproduces the joint
experiment in which a uniform path lies in its measured fibre.  Any
opposite-half partner returned by the pairer yields

```text
sum_i a_i*A_i = H mod N.
```

Thus a path-local pairer with inverse-polynomial coverage gives an
inverse-polynomial-success fixed-target RMSS solver.  This is a statement
about the joint distribution, not independence after conditioning on a
prescribed measured value of `t`: for fixed `t`, the relation
`sum_i x_i*A_i=-t` correlates `A` and `x`.  The planted path provides a known
relation at target `-t`, but it does not simplify the independent half-turn
equation at target `H` in the joint reduction.

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
reversible and canonical, yielding the one-pool encoder at exponential cost.
The two-pool construction above can instead consume any bounded, verifiable
find-one solver, but it does not improve that solver's running time.  Recent
generic quantum subset-sum search improves the search exponent to
`O*(2^(2k/7))` for `k` variables and can therefore feed this reduction only at
exponential cost:

- [Improved Quantum Algorithms for Subset Sum and k-SUM](https://arxiv.org/abs/2608.07309)

For random high-density modular subset sum, the known Wagner-style route is
subexponential in its applicable parameterization rather than polynomial in
the critical correction-pool regime required here:

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

For the global selected `A`-side instance considered by the half-turn repair,
the paper has `a=n/log2(n)` selected local blocks of width
`m_0=c*log2(n)`, hence `m_A=a*m_0=c*n` Boolean variables modulo an `n`-bit
modulus.  Its subset-sum density is the constant `c`, not a growing
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

For the direct one-pool polar/PGM construction, finding one classical solution
is insufficient: that route needs nearly uniform amplitudes over a fibre,
branch-independent clean garbage, and a controlled inverse.  The two-pool
cross-filter is an important exception.  It runs both bounded solver circuits
on both branches, so retained seeds and search histories are common garbage;
there an ordinary verifiable find-one solver would suffice.  No polynomial
finder is known at the required exact-density random-target interface.

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

This limitation can be quantified for fault-oblivious sparse or list-based
repairs.  Consider the permitted model that chooses exactly
`f=floor(delta*q_used)` faulty positions uniformly among the coordinates used
by the construction, with `delta=1/(c'*log n)`.  A proposed half-turn move of
Hamming weight `w`, chosen without fault flags, avoids all faulty coordinates
with probability

```text
binom(q_used-w,f) / binom(q_used,f)
  <= exp(-f*w/q_used)
  = exp(-delta*w+O(w/q_used)).
```

For fault-independent candidate moves whose weights satisfy the stated lower
bound, polynomially many candidates only multiply this estimate by a
polynomial.
On the other hand, for random modular weights the signed-weight reduction and
a union bound give

```text
Pr[there is a half-turn relation of weight at most w]
  <= N^(-1) * sum_(j <= w) binom(q_used,j)
  <= N^(-1) * (e*q_used/w)^w.
```

For polynomial `q_used`, inverse-polynomial fault avoidance would require
`w=O(log^2 n)`, but such a relation exists with probability at most
`2^(-n+O(log^3 n))`.  Typical available relations have weight
`Omega(n/log n)` and avoid the permitted random fault set with only
`exp(-Omega(n/log^2 n))` probability.  Oversampling gives the same entropy
tradeoff: a pool of `n+s` bits with `f` hidden fixed coordinates covers at
most `min(1,2^(s-f))` of random targets, while a one-output canonical filter
costs `2^(-s)`.  Recovering inverse-polynomial mass therefore requires about
`2^f/poly(n)` coherently aligned solutions, not a polynomial list whose index
remains as orthogonal garbage.

This is a barrier for fault-oblivious single-match, sparse-move, and
polynomial-list families, not a lower bound for arbitrary collective quantum
channels.  The precise escape hatch is a collective fault-aware eraser that
implicitly aligns exponentially many compatible relations, or explicit fault
flags.  No polynomial implementation of such a decoder is known; the original
first-zero construction was a candidate collective mechanism, but the
spectral analysis shows that its retained mass is dominated by
secret-independent diagonal modes.

## A robust collective PGM for fixed fault environments

The preceding `2^(-F)` loss belongs to the explicit common-label matching
construction.  It is not a loss of distinguishability of the full quantum
state.  A direct random-code argument shows that an optimal collective
measurement can aggregate exponentially many fault-compatible relations.

Fix a block of `q` raw Fourier-labelled samples and condition on their public
labels

```text
Y = (Y_1,...,Y_q),       Y_i uniform in Z_N.
```

The ideal phase codeword for secret `d` is

```text
|psi_d^Y>
  = 2^(-q/2) * sum_(x in {0,1}^q) omega^(d*f_Y(x)) |x>
  = tensor_i (|0> + omega^(d*Y_i)|1>) / sqrt(2).
```

For an error word `e in {0,1}^q`, put

```text
|phi_(d,e)^Y> = Z^e |psi_d^Y>.
```

Two overlap identities are exact.  For one fixed `d`, states indexed by
different `e` are orthogonal.  For `d != d'`, independence and uniformity of
the public labels give

```text
E_Y |<phi_(d,e)^Y | phi_(d',e')^Y>|^2 = 2^(-q).
```

Indeed, if `a=e xor e'`, the overlap factors as

```text
product_i (1 + (-1)^(a_i) * omega^((d'-d)*Y_i)) / 2,
```

and the expected squared magnitude of each factor is exactly `1/2` for every
nonzero `d'-d in Z_N`.

Let

```text
E_r = {e : HammingWeight(e) <= r},
L_r = |E_r|,
U_d(Y) = span {|phi_(d,e)^Y> : e in E_r}.
```

Form the synthesis matrix `V_Y` whose columns are all `N*L_r` codewords, and
write `G_Y=V_Y^dagger*V_Y`.  Its diagonal `d`-blocks are identity, so

```text
E_Y ||G_Y-I||_F^2
  = N*(N-1)*L_r^2*2^(-q)
  <= B_r,

B_r = N^2*L_r^2/2^q.
```

For any `0 < alpha < 1`, Markov's inequality and
`||.||_op <= ||.||_F` imply

```text
Pr_Y[||G_Y-I||_op > alpha] <= B_r/alpha^2.
```

On the complementary event, the polar/pretty-good-measurement isometry

```text
W_Y = V_Y * G_Y^(-1/2)
```

has orthonormal columns, and

```text
||G_Y^(1/2)-I||_op
  <= alpha/(1+sqrt(1-alpha))
  <= alpha.
```

It follows that, for every secret `d` and every normalized coherent state in
the whole subspace `U_d(Y)`, the probability that this PGM outputs a different
secret is at most `alpha^2`.  This is a uniform subspace guarantee, not an
average over a classical error word.

The repository's computational-basis fault model fits these subspaces
exactly.  If `F` is a fixed set of `f<=r` faulty coordinates and `b` is an
arbitrary fixed Boolean assignment on `F`, then, up to a unit global phase,

```text
tensor_(i notin F) |+_(d*Y_i)> * tensor_(i in F) |b_i>
  = 2^(-f/2)
      * sum_(e subseteq F) (-1)^(b dot e) Z^e |psi_d^Y>.
```

Thus every such fixed-environment state lies in `U_d(Y)`, without revealing
the fault locations to the measurement.  The same conclusion holds for
arbitrary classical mixtures and correlations of these fault environments.

Now assume only the repository's marginal bound

```text
Pr[i is faulty] <= delta.
```

For a preselected block of `q` coordinates, `E[|F|] <= delta*q`.  Choose a
fixed `tau in (delta,1/2)` and `r=floor(tau*q)`.  Markov gives

```text
Pr[|F|>r] <= delta/tau.
```

Since `L_r <= 2^(q*h_2(tau))`, taking `q=c*n` yields

```text
B_r <= 2^([2-c+2*c*h_2(tau)]*n).
```

Assuming `B_r<1`, set `alpha=B_r^(1/4)`.  Combining excessive faults,
atypical public labels, and the conditional PGM error gives

```text
P_error <= delta/tau + 2*sqrt(B_r).
```

For `c=12`, once `delta<1/32`, one may take `tau=1/32`.  Since
`h_2(1/32) approximately 0.2006`, this specializes to

```text
P_error <= 32*delta + 2^(-2.59*n+O(1)).
```

At `delta=1/(c'*log n)`, the error tends to zero.  The measurement actually
decodes the complete secret `d`, so its parity error is no larger.  The bound
is averaged over the iid-uniform public-`Y` marginal.  Correlations among
fault locations and fixed faulty values are allowed; what is essential is
that the public labels retain that iid-uniform marginal.  The result uses a
fixed raw sample block before the paper's adaptive choice of `A(D)`; it is an
alternative collective decoder, not a validation of the first-zero circuit.

### Exact group-covariant normal form

The cyclic symmetry of the code can be used completely, but it does not remove
the computational bottleneck.  Define

```text
U_Y|x> = omega^(f_Y(x))|x>,
|phi_(d,e)> = U_Y^d H^(tensor q)|e>,
E_r = {e : HammingWeight(e)<=r}.
```

Let `V` be the synthesis map `V|d,e>=|phi_(d,e)>`, let `J_E` embed the
`E_r` label space into the `q`-qubit computational basis, and let `Pi_t`
project onto the subset-sum fibre `f_Y(x)=t`.  Fourier transforming only the
secret label gives the exact identity

```text
V(F_N^dagger tensor I)|t,e>
  = sqrt(N) * Pi_t H^(tensor q) J_E|e>.
```

Consequently the Gram matrix and the PGM polar factor split into `N`
independent residue blocks.  If

```text
D_t := Pi_t H^(tensor q) J_E,
```

then the `t`-block of the Gram matrix is `N*D_t^dagger*D_t`, with entries

```text
(N/2^q) * sum_(x : f_Y(x)=t) (-1)^((e xor e') dot x),
```

and the corresponding PGM block is the polar partial isometry of `D_t`.
Thus the ordinary cyclic QFT removes the orbit label `d`, but leaves a
fibre-restricted Walsh polar transform in the multiplicity space.  For
`E_r={0}`, this remaining map is already uniform subset-sum fibre synthesis
and index erasure.  Low-weight errors strengthen it to the simultaneous
orthogonalization of many restricted Walsh characters.

This also explains why phase estimation of `U_Y` is insufficient.  It can
compute `t=f_Y(x)` efficiently, but it leaves the original system in `|x>`.
For fixed `t`, the vectors with `f_Y(x)=t` form an orthogonal basis of the
multiplicity space `H_t`; phase estimation does not separately extract a
canonical within-fibre index.  Measuring `t` has distribution `|F_t|/2^q`,
independent of `d`, and destroys the relative phases between different fibres.
The irrep label is easy; selecting the particular normalized vector `|F_t>`
inside `H_t` is the missing operation.

On the Gram-good event, the singular values of the Fourier blocks
`sqrt(N)*D_t` are close to one.  The directly implementable contraction
`D_t`, however, has singular values of order `N^(-1/2)`: apply the Boolean
Hadamard, compute `f_Y`, and project onto one prescribed `t`.  Amplitude
amplification therefore costs `Theta(sqrt(N))`.  In this particular
projected-unitary/QSVT access model, the same scale is necessary for constant
accuracy, up to approximation logarithms: an odd polynomial bounded by one on
`[-1,1]` that maps a value of order `N^(-1/2)` to a constant has degree
`Omega(sqrt(N))` by Bernstein's inequality.  This is a route-specific lower
bound, not a lower bound against arbitrary arithmetic quantum circuits.

There is a smaller parity-only block decomposition, which remains the main
logical opening.  For a seed density matrix `R`, put
`rho_d=U_Y^d R U_Y^(-d)` and average separately over even and odd `d`.  Exact
Fourier orthogonality gives

```text
rho_b = sum_t Pi_t R Pi_t
      + (-1)^b * sum_t Pi_t R Pi_(t+H).
```

On an unordered pair `{t,t+H}`, put
`A_t=Pi_t R Pi_(t+H)` and write its polar decomposition as
`A_t=W_t|A_t|`.  In the ordered decomposition
`H_t direct-sum H_(t+H)`, the parity Helstrom sign observable is

```text
[[0, W_t], [W_t^dagger, 0]],
```

with an arbitrary fixed convention on the kernel.  For the clean rank-one
seed, `W_t=|F_t><F_(t+H)|`, and the Hermitian half-turn swap/test observable is
`W_t+W_t^dagger`.  For an averaged low-weight-error or dephasing ensemble,
`W_t` is a generally high-rank weighted cross-fibre transport.  This parity
formula concerns the stated averaged ensemble; the full robust PGM above is
what gives the uniform subspace guarantee for arbitrary coherent low-weight
error states.  A direct arithmetic implementation of only these parity polars
could conceivably be weaker than the full decoder, but no such implementation
is presently known.

### An exact dyadic recursion, and why it does not close on parity

The power-of-two modulus admits an exact Cooley--Tukey-style recursion.  It is
useful because it identifies precisely what a bit-by-bit implementation would
have to provide.  Put `M_k=2^k`, let `f_k` denote the subset sum modulo `M_k`,
and define

```text
U_k|x> = exp(2*pi*i*f_k(x)/M_k)|x>,
|psi_j^(k)> = U_k^j |+>^(tensor q),
W_k = sum_(j in Z_(M_k)) |psi_j^(k)><j|,
B_k = W_k/sqrt(M_k).
```

Under the reversible relabelling `j=2*a+b`, `b in {0,1}`, and after grouping
the columns by `b`, one has exactly

```text
W_k = [W_(k-1), U_k W_(k-1)],
B_k = (1/sqrt(2))*[B_(k-1), U_k B_(k-1)].
```

Consequently, for the unnormalized frame and signed frame

```text
P_k = W_k W_k^dagger,
K_k = W_k Z_b W_k^dagger,
```

the recurrences are

```text
P_k = P_(k-1) + U_k P_(k-1) U_k^dagger,
K_k = P_(k-1) - U_k P_(k-1) U_k^dagger.
```

The normalization matters.  `P_k` is not generally a projector.  If
`eta_t^(k)` is the size of the residue-`t` fibre modulo `M_k`, then

```text
P_k = sum_t (M_k*eta_t^(k)/2^q) |F_t^(k)><F_t^(k)|.
```

Its support projector is instead

```text
Q_k = sum_(t : eta_t^(k)>0) |F_t^(k)><F_t^(k)|.
```

High density can make `P_k` close to `Q_k` on the occupied support, but does
not make either operator free to implement.  To see the exact half-turn
content, fix one coarse residue `r mod M_(k-1)`.  Write

```text
a = eta_r^(k),
b = eta_(r+M_(k-1))^(k),
|C_r> = sqrt(a/(a+b))|F_r> + sqrt(b/(a+b))|F_(r+M_(k-1))>.
```

Up to a common phase, `U_k` changes the plus sign in `|C_r>` to a minus sign.
Therefore the restriction of

```text
Q_(k-1) - U_k Q_(k-1) U_k^dagger
```

to this two-fibre plane is exactly

```text
(2*sqrt(a*b)/(a+b))
  * (|F_r><F_(r+M_(k-1))| + h.c.).
```

Its sign is the desired half-turn swap whenever both child fibres are
nonempty.  This is a genuine positive structural identity: the final parity
operator can be obtained from the preceding **full support projector**.

It is not, however, a recursion using only a bare preceding parity
measurement.  With the canonical partial-sign convention `sign(0)=0`, the
square of a fully specified coherent `sign(K_(k-1))` can recover its paired
support.  A two-outcome measurement, however, does not specify a coherent
canonical action on the kernel and does not by itself furnish the required
`Q_(k-1)` oracle.  In the direct recursive-frame or support-reflection
realization, forming the next support uses both `Q_(k-1)` and its
`U_k`-conjugate, so the number of branches
doubles at every level.  Expanding the recursion produces `M_k=2^k` orbit
terms.  Keeping them as the normalized synthesis `B_k` instead exposes the
target with amplitude `M_k^(-1/2)`, and amplitude amplification costs
`sqrt(M_k)`.  Thus this natural dyadic realization reproduces either linear
orbit expansion or the existing square-root amplification scale; it does not
give a polynomial recursion.  This conclusion is restricted to these
frame/support-projector access models and is not a lower bound for an
unrelated arithmetic parity circuit.

### Why this does not yet give an efficient decoder

The codebook has

```text
N*L_r = 2^(n+q*h_2(tau)+o(q))
```

columns.  The proof constructs its PGM through a dense polar factor and does
not supply a succinct implementation.  The apparent conflict with the
single-relation fault bound is resolved as follows: a one-edge decoder pays
for one relation avoiding all faults, whereas the PGM coherently aggregates
exponentially many relations.

In the simpler iid averaged-fault model with uniformly averaged faulty basis
bits (equivalently, local replacement by `I/2`), write
`lambda=1-delta` and let `rho_d^Y` be the resulting product density matrix.
If `rho_even` and `rho_odd` are the uniform even- and odd-secret mixtures,
their difference has the exact matrix elements

```text
<x|rho_even-rho_odd|x'>
  = 2^(1-q) * lambda^HammingDistance(x,x')
```

when `f_Y(x)-f_Y(x')=H`, and zero otherwise.  The optimal observable is
therefore the sign of a weighted all-relations half-turn matrix, rather than
a sparse matching.

Its Hilbert--Schmidt norm obeys

```text
E_Y Tr((rho_even-rho_odd)^2)
  = (4/N) * (((1+lambda^2)/2)^q - 2^(-q)).
```

In the successful regime its trace norm can be close to `2` while its
Hilbert--Schmidt norm is exponentially small.  Markov's inequality makes the
latter statement pointwise for all but a controlled fraction of public-label
vectors, simultaneously with the Gram-good event.  For any cutoff `zeta>0`,
the trace carried by singular values at least `zeta` is at most

```text
||rho_even-rho_odd||_2^2 / zeta.
```

Consequently, for an `O(1)`-normalized block encoding of this parity operator,
the standard QSVT sign-polynomial route misses essentially all useful trace if
it resolves only inverse-polynomial singular values.  More explicitly, for an
odd degree-`D` polynomial `p` bounded by one on `[-1,1]`, Markov's polynomial
inequality gives `|p(s)|<=D^2*|s|`, and hence

```text
|Tr(Delta_Y * p(Delta_Y))| <= D^2 * ||Delta_Y||_2^2.
```

For typical public labels the right-hand side is negligible for polynomial
`D`.  Constant Helstrom bias through this direct polynomial functional
calculus therefore needs exponential degree.  This is a scoped statement
about that normalized block-encoding/QSVT route, not a lower bound against
every block encoding or arithmetic collective circuit.

Independent small-pool parity extraction also cannot replace the dense PGM.
For one clean block of `m` public labels, the even/odd mixtures have matrix
difference

```text
<x|sigma_even-sigma_odd|x'> = 2^(1-m)
```

exactly on half-turn pairs and zero elsewhere.  If the block contains no such
pair, the two ensembles are identical.  Random labels contain any half-turn
pair with probability at most `2^(2*m)/N`.  Hence pools of
`m=O(log^2 n)` coordinates carry exactly zero local parity information with
probability `1-2^(-n+O(log^2 n))`, even though such pools would contain few
faults.  This rules out decoding each small pool independently and taking a
majority.  It does not rule out an adaptive or product measurement whose
outcomes first narrow the full-secret posterior and are then correlated
globally; such a construction would be another genuinely global decoder.

There is nevertheless a simple positive result for passive single-qubit
measurements.  In the iid uniformly averaged/dephasing model, measure every
phase qubit in the `X` basis and write the outcome as `S_i in {+1,-1}`.  Then

```text
Pr[S_i=s | Y_i=y,d]
  = (1+s*lambda*cos(2*pi*d*y/N))/2.
```

For every candidate frequency `k`, define the correlation score

```text
T_k = sum_i S_i*cos(2*pi*k*Y_i/N).
```

Character orthogonality gives the exact expectations

```text
E[T_k]/q = (lambda/2)
  * (1_(k=d) + 1_(k=-d)),
```

with the coincident cases `d=0,N/2` having mean `lambda`.  Hoeffding's
inequality followed by a union bound shows that

```text
q >= (32/lambda^2)*ln(2*N/eta)
```

samples suffice to identify the unordered pair `{d,-d}` with error at most
`eta`.  Because `N` is even, `d` and `-d mod N` have the same parity.  Thus
only `O((n+log(1/eta))/lambda^2)` passive samples are information-theoretically
enough for the target bit.

The evident decoder is still exponential-time: evaluating all `T_k` by a
length-`N` FFT costs `O(N*log N)` time and `O(N)` memory.  This is not an
ordinary sparse-Fourier algorithm with a standard sublinear implementation.
The chosen-query sparse-FFT procedures examined here choose or randomly
access structured time-domain locations used by their filters; here the
algorithm receives a one-pass set of uncontrollable random locations and one
Bernoulli observation at each.
Almost all locations are distinct when `q=poly(n)`, and a prescribed spacing
or repeated location occurs with probability only `O(q^2/N)`.  One-bit hidden
number algorithms likewise assume oracle access to chosen multipliers (and,
in the relevant advice-based result, a prescribed universal query schedule),
not these passive cosine samples.  Loading the observed examples into a
natural normalized quantum sparse vector and Fourier transforming gives
target probability only of order `q/N` when label collisions are negligible,
returning to exponential repetition or square-root amplification.  No
polynomial passive decoder was found.  The exact result is therefore an
`O(n)` sample upper bound together with an open computational heavy-character
problem, not a hardness theorem.

A related exact barrier applies to bounded-degree processing of passive
single-qubit `X` measurements.  In the iid uniformly averaged/dephasing model,
write the outcome as `S_i in {+1,-1}`.  For `T` of size `j`,

```text
E[product_(i in T) S_i | d,Y]
  = lambda^j * 2^(-j)
    * sum_(epsilon in {+1,-1}^T)
        omega^(d * sum_i epsilon_i Y_i).
```

Averaging `d` over its two parities shows that the even-minus-odd expectation
is exactly

```text
lambda^j * 2^(1-j)
  * #{epsilon : sum_i epsilon_i Y_i = H mod N}.
```

Therefore, if the public labels contain no signed half-turn relation of support
at most `r`, every real multilinear statistic of degree at most `r` has exactly
the same expectation under the two parity mixtures.  For iid-uniform labels,

```text
Pr[there is such a relation]
  <= N^(-1) * sum_(j=1)^r 2^j * choose(q,j).
```

For polynomial `q` and `r=O(log n)`, this is
`2^(-n+O(log^2 n))`.  This rules out bounded-locality statistics or syndromes
formed from these passive `X`-measurement outcomes, as well as bounded-degree
moment methods.  It does not apply to unrestricted majority, arbitrary
classical postprocessing, or a general quantum circuit, whose effective
multilinear degree can be large.  Higher-degree processing must implicitly
aggregate dense signed subset-sum relations, which is precisely what the
collective PGM does.

Pairwise Kuperberg-style collimation does aggregate relations, but the usual
resource law remains subexponential and the hidden faults make explicit
relations less robust.  In a clean binary sieve, combining two length-`L`
lists while eliminating `m` low multiplier bits leaves expected length about

```text
L' = L^2/2^m.
```

Keeping `L'` comparable to `L` requires `L` of order `2^m`.  Each level gains
about `m` bits and doubles the number of leaves, so a height-`n` label costs
about `2^(n/m)` leaves while the table costs `2^m`.  Balancing the two at
`m` of order `sqrt(n)` recovers the familiar `2^(Theta(sqrt(n)))` scale rather
than a polynomial algorithm.

For a fixed-size uniformly random fault set of density
`delta=Theta(1/log n)`, which is permitted by the marginal model, an explicit
coherence between paths whose difference has Hamming weight `w` survives only
when the difference avoids every faulty coordinate.  Its exact probability is

```text
choose(q-w,f)/choose(q,f)
  <= (1-delta)^w
  <= exp(-delta*w).
```

For `q=c*n` iid-uniform modular labels, a union bound gives

```text
Pr[there is a signed half-turn relation of support at most w]
  <= N^(-1) * sum_(j<=w) 2^j*choose(q,j).
```

At `c=12`, this is exponentially small for every fixed support fraction below
the root `alpha approximately 0.10838` of
`alpha+12*h_2(alpha/12)=1`.  Thus a standard no-reuse two-state or
polynomial-list sieve operating on this `q=c*n` block must use linear-support
terminal relations with overwhelming probability.  For a fixed relation, or
a polynomial family chosen independently of the hidden fault set, each such
explicit coherence incurs `exp(-Omega(n/log n))` survival in this allowed
fault model, and polynomial repetition cannot compensate.  This is a barrier
for those pairwise/list collimation and explicit path-reindexing models, not
for fault-adaptive algorithms or arbitrary collective measurements.  It does
not contradict the robust-PGM guarantee, which aggregates the full relation
space rather than requiring one preselected surviving edge.

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

The passive-measurement comparison uses a different access model from the
chosen-query sparse-Fourier and hidden-number results below:

- [Sparse Fourier Transform in Any Constant Dimension with Nearly-Optimal Sample Complexity in Sublinear Time](https://arxiv.org/abs/1604.00845)
- [A Sublinear Algorithm of Sparse Fourier Transform for Nonequispaced Data](https://arxiv.org/abs/math/0502357)
- [Solving Hidden Number Problem with One Bit Oracle and Advice](https://doi.org/10.1007/978-3-642-03356-8_20)

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
> natural `sqrt(N)` normalization, or (b) build a bounded, verifiable,
> inverse-polynomial-success random-target RMSS find-one algorithm on exactly
> `n` random correction coordinates and make the large-label two-pool
> construction respect the occupied fault subcube?

A positive answer to either version would be a new DCP/subset-sum algorithmic
ingredient.  No such polynomial construction is supplied by the paper or
found in this investigation.  The random-singleton oracle model now has a
rigorous `Omega(sqrt(D))` constant-advantage barrier, but a negative answer for
the explicit arithmetic problem would require a stronger circuit-model or
average-case lower bound that is not presently available.

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
- a random binary-syndrome preprocessor preserves the half-turn phase exactly
  and, when its rank is tightly matched to the hidden fault count, compresses
  the full cube to a critical-density code-constrained RMSS core; otherwise
  the core is mis-tuned--larger under a conservative cap, or smaller and
  potentially underdense once excess faults consume the slack--and its
  label-averaged nonzero-target fraction is still about `1/N`, with the
  zero-mask correction shown below;
- arbitrary overlapping CNOT/syndrome branches admit an exact algebraic
  normal form: removing `m` modulus bits requires simultaneous carry
  congruences through degree `m`.  More strongly, for `q=12*n` and reduction
  modulo `H`, with high probability no affine coset of dimension `91` or more
  is contained in one `f_Y mod H` fibre, including cosets selected after
  seeing `Y`.  This does not apply
  after additionally measuring `f_Y mod H`, whose surviving intersection is
  generally non-affine;
- on a clean cube, an exact triangular checksum factorization removes
  `log q-O(log log n)` low modulus bits without rejecting any checksum
  outcome, but its
  quotient phase is nonlinear.  Any all-outcome fixed-garbage continuation
  beyond the raw contiguous valuation chain would contradict exact fibre
  uniformity, so this no-rejection route peels only `O(log q)` bits;
- every classical reversible basis preprocessor followed by one Hadamard
  reduces to explicit half-turn basis pairing and hence to RMSS when it has
  inverse-polynomial mass-weighted advantage.  On the clean cube, full exact
  pairing exists only when a live raw label equals `H`, although abstract
  partial matchings cover all but exponentially small expected mass at
  `q=12*n`;
- even with arbitrary fast orbit translations and the efficient reflection
  about the low-weight reference subspace, parity requires
  `Omega(sqrt(N))` reference queries in that translation-covariant
  orbit-access model for bounded error;
- within the clean orbit-projector dictionary, the raw signed-frame LCU
  coefficients are unique and every constant-error parity approximation retains `Omega(N)`
  normalization.  Directly taking the sign of the purified parity-density
  block encoding costs `Omega(N)` in QSVT degree, while factorizing through
  the frame improves this route only to `Theta(sqrt(N))`;
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
- passive `X` outcomes do possess an exact pair-product recursion.  On every
  nondegenerate reduced-frequency level--in particular for an odd secret
  before the final two-point modulus--the passive visibility `lambda` changes
  by `lambda -> lambda^2/2`; polynomial resources permit only
  `O(log log n)` useful no-reuse levels and remove `o(n)` modulus bits.
  Direct importance sampling of the exact Bayesian coefficient ratio has
  relative variance `Theta(N)` once its posterior is sharp.  At `q=12*n`,
  for a nondegenerate secret, a Hellinger bound shows that the posterior is in
  fact concentrated on `{d,-d}` with a polynomially tunable exponentially
  small tail, while uniform sampling inside the correct parity class has
  `N/4-o(N)` relative variance.
  At the same parameters,
  in the matched passive model with a nondegenerate secret, ordinary
  absolute-weight sign reweighting has average-sign magnitude at most
  `N^(-4.06843+epsilon)` with high probability for every fixed
  `epsilon>0`;
- a fermionic-Gaussian/matchgate circuit that reads too few occupation bits is
  exactly parity-blind on typical clean labels: nonadaptive `k`-bit output
  needs a signed half-turn relation of weight at most `2*k`, and adaptive
  Gaussian feedforward needs one of weight at most `4*k-2`.  This threshold is
  qualitatively tight: a disjoint-pair matchgate reading `12*n` occupation
  bits produces `6*n` visibility-one passive cosine observations with exponentially reliable
  maximum-likelihood parity, but efficient decoding still reduces to the same
  weighted `A_0/A_H` coefficient problem.

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

   For random high-density instances these `N` Schmidt components are
   exponentially close to flat.  The quantitative operator-Schmidt theorem
   below shows that an operator-Schmidt-rank-`R` approximation captures at
   most essentially `R/N` of the squared Frobenius mass.  This blocks
   relative-Frobenius compression of this kernel by polynomial-bond MPOs, not
   arbitrary circuits.
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

The same blocks give an explicit robust **parity-only** observable, without
requiring the measurement to output `d` or the error word.  Write

```text
D_t = U_t S_t
```

for the polar decomposition.  Exact Fourier block diagonalization gives

```text
||G_Y-I||_op
  = max_t ||N*D_t^dagger*D_t-I||_op.
```

Thus the one Gram-good event above simultaneously makes each polar `U_t` a
full-rank isometry from the error-label space onto `ran(D_t)`.  On the direct
sum of those images define

```text
T_tilde = sum_t U_(t+H) U_t^dagger,
```

with any fixed Hermitian involutive extension on the orthogonal complement.
Pairing `t` with `t+H` makes `T_tilde` Hermitian and involutive on its intended
support.  If `||G_Y-I||_op<=alpha<1` and

```text
a = 1-sqrt(1-alpha),
```

then, for every secret `d` and every unit vector `v` in the coherent
low-weight-error label space,

```text
||T_tilde U_Y^d H^(tensor q) J_E v
    - (-1)^d U_Y^d H^(tensor q) J_E v||^2
  <= 4*a^2.
```

This follows fibre by fibre from
`||S_t-I/sqrt(N)||_op<=a/sqrt(N)` and orthogonality of the residue sectors.
Measuring `T_tilde` therefore has wrong-parity probability at most `a^2`,
uniformly over the whole coherent error subspace.  This closes the algebraic
existence side for a robust one-bit measurement more directly than decoding
the complete `(d,e)` label.

It does not improve the known implementation cost.  A multiplexed projected
unitary implements all `D_t` blocks, but their singular values are still
`Theta(N^(-1/2))`; polarizing it and sandwiching the shift `t -> t+H` costs
`Theta(sqrt(N))` at constant accuracy in the standard QSVT realization.  The
same Bernstein argument gives the matching degree lower bound in that access
model.  This remains a route-specific statement, not an unrestricted lower
bound for the parity observable.

For comparison, the averaged-ensemble parity Helstrom operator has a closely
related block decomposition.  For a seed density matrix `R`, put
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
`W_t` is a generally high-rank weighted cross-fibre transport.  This exact
Helstrom formula concerns the stated averaged ensemble; the `T_tilde`
construction immediately above, as well as the full robust PGM, gives a
uniform subspace guarantee for arbitrary coherent low-weight error states on
Gram-good labels.  A direct arithmetic implementation of only these parity
polars could conceivably be weaker than the full decoder, but no such
implementation is presently known.

### A flat operator-Schmidt spectrum across balanced cuts

The clean parity kernel also rules out a different tempting implementation:
compressing the Helstrom operator as a polynomial-bond-dimension matrix
product operator.  Split the `q` Boolean variables into left and right parts
of sizes `ell` and `r=q-ell`, and write `f_Y=f_L+f_R`.  Define matrices

```text
A_a^L[u,u'] = 1_(f_L(u)-f_L(u')=a),
B_b^R[v,v'] = 1_(f_R(v)-f_R(v')=b).
```

For the normalized clean parity mixtures,

```text
Delta_Y = rho_even-rho_odd
        = 2^(1-q) * sum_(a in Z_N) A_a^L tensor B_(H-a)^R.
```

Distinct `A_a^L` have disjoint matrix-entry supports, and so do the right
factors.  After Frobenius normalization, this is already an exact
operator-Schmidt decomposition.  If

```text
eta_t^L = #f_L^(-1)(t),
C_L(a) = ||A_a^L||_F^2 = sum_t eta_t^L eta_(t-a)^L,
```

and similarly on the right, its exact Schmidt coefficients are

```text
s_a = 2^(1-q) * sqrt(C_L(a)*C_R(H-a)).
```

Suppose every fibre on side `j` is within relative error `epsilon_j<1` of
`mu_L=2^ell/N` or `mu_R=2^r/N`.  Then every coefficient obeys

```text
(2/N)(1-epsilon_L)(1-epsilon_R)
  <= s_a <=
(2/N)(1+epsilon_L)(1+epsilon_R).
```

The operator-Schmidt rank is therefore exactly `N`.  By the Eckart--Young
theorem, every operator-Schmidt-rank-at-most-`R` approximation `X` satisfies

```text
||Delta_Y-X||_F^2 / ||Delta_Y||_F^2
  >= 1 - min(1, (R/N)*kappa_epsilon^2),

kappa_epsilon =
  ((1+epsilon_L)(1+epsilon_R))
  / ((1-epsilon_L)(1-epsilon_R)).
```

For random labels and a `6*n | 6*n` split of the `q=12*n` clean block, the
standard simultaneous fibre estimate permits
`epsilon_L,epsilon_R<=2^(-n)+2^(-5*n)` except with probability at most
`2^(1-2*n)`.  A polynomial-bond-rank approximation then captures only
`poly(n)/N` of the squared Frobenius mass.

This is an exact low-bond tensor-network barrier, not a quantum-circuit lower
bound.  Only `O(n)` gates crossing the cut can already create Schmidt rank
`N`, and approximating `Delta_Y` in Frobenius norm is not the same task as
implementing `sign(Delta_Y)` on the promised input ensemble.

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

There is, however, a rigorous barrier for the broad subclass of algorithms
that access these examples only through statistical queries.  Let
`P_d` denote the passive distribution above, and let `P_star` have uniform
`Y` and an independent uniform sign `S`.  For an arbitrary query
`Phi(Y,S) in [-1,1]`, put

```text
a(y) = (Phi(y,+1)+Phi(y,-1))/2,
b(y) = (Phi(y,+1)-Phi(y,-1))/2.
```

Then the difference between its expectations is exactly one Fourier
coefficient:

```text
Delta_Phi(d)
  = E_(P_d)[Phi] - E_(P_star)[Phi]
  = lambda * Re(hat(b)(-d)).
```

With the normalized Fourier transform, Parseval gives

```text
sum_(d in Z_N) Delta_Phi(d)^2
  <= lambda^2 * E_y[b(y)^2]
  <= lambda^2.
```

Consequently a query of absolute tolerance `tau` can disagree with the null
answer by more than `tau` for fewer than `lambda^2/tau^2` secrets.  For each
secret, consider the adversarial oracle strategy that returns the null
expectation whenever it lies within tolerance, and otherwise returns any
valid answer.  For a fixed random tape, follow the exact-null transcript of
an adaptive deterministic `Q`-query algorithm and take the union of the
exceptional secret sets encountered along that path.  Outside a set of size
at most `Q*lambda^2/tau^2`, this strategy follows the entire null transcript.
Its final parity guess is fixed and is correct for at most `N/2` secrets in
the full group; granting arbitrary success on the exceptional set gives

```text
P_success <= 1/2 + Q*lambda^2/(N*tau^2)
```

for a uniform secret.  Averaging over the random tape yields the same bound
for randomized adaptive algorithms.  Thus their uniform-secret average
parity advantage against the conventional adversarial `STAT` oracle is
exponentially small when both the query count and inverse tolerance are
polynomial.

This theorem covers approximate-expectation, moment, gradient, and other
algorithms that genuinely factor through the conventional adversarial
absolute-tolerance `STAT` interface.  It does **not** lower-bound algorithms
that inspect the individual samples combinatorially, exact-expectation or
stronger query oracles, or collective quantum measurements.  Random-example
access can use rare exact relations among the observed labels and is strictly
outside this argument.

The access distinction is also why the positive hidden-number algorithms
examined here do not settle the passive decoder.  The chosen-multiplier
Fourier methods require a prescribed or actively queried multiplier set;
their own analysis explicitly does not extend that theorem to the uniform
distribution model.  Akavia's random-sample learning-of-noisy-characters
framework is closer to the present setting, but its positive Hamming result
returns a noisy complex character value rather than this one-bit stochastic
cosine observation.  The Boolean or `l_2` random-sample variants are treated
there as the difficult regime.  This is a placement of the access model, not
an asserted formal equivalence or a hardness assumption used by this audit.

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

Several cheaper-looking public-label transformations can also be audited
exactly.  For one untouched phase qubit with label `y`, average the secret
uniformly over either parity and call the two states `rho_b^y`.  Twice their
off-diagonal entry (the Bloch coherence coefficient) is

```text
(2/N) * sum_(j=0)^(H-1) omega^((b+2*j)*y).
```

This geometric sum equals `1` for `y=0`, equals `(-1)^b` for `y=H`, and is
zero otherwise.  Hence `rho_0^y=rho_1^y` for every `y!=H`: label zero is
uninformative, while `H` reveals parity perfectly.  For an acceptance weight
`A(y) in [0,1]`, let `HelstromAdvantage` mean the conditional optimal success
probability minus `1/2`.  Then the exact identity is

```text
P_accept * HelstromAdvantage
  = A(H)/(2*N) <= 1/(2*N).
```

Selecting a label merely near `H` gives no one-qubit parity information.  The
identity does not apply to joint processing, where several labels may satisfy
an exact signed relation with total `H`.

The 2-adic valuation does not change this conclusion.  A uniform label obeys
`Pr[2^r divides Y]=2^(-r)`, and among `Q` labels

```text
Pr[there exists i with 2^r dividing Y_i] <= Q*2^(-r).
```

Conditioning one label on `2^r` dividing it, then dividing that label and the
modulus by `2^r`, costs `2^r` raw samples and saves only `r=O(log n)` bits at
polynomial cost.
Repeating multiplies these rejection costs: removing `r_1+...+r_k` bits is
just the original condition `2^(r_1+...+r_k) divides Y`.  Constant-probability
single-qubit parity still requires the original label `Y=H`.

If a fixed designated label `Y_0` is conditioned on being odd, globally
multiplying **all** labels by `Y_0^(-1)` is legitimate: it anchors `Y_0` at
one and replaces the common secret by `d*Y_0`, which has the same parity.
Conditional on that designated label, the remaining labels stay iid uniform,
so this supplies no chosen-query schedule.  This statement would need a
different conditioning analysis if `Y_0` were selected adaptively as the
first odd sample.  Normalizing each sample separately instead creates
sample-dependent higher secret bits; it does not rewrite the observations
using one common secret, and the physical states are unchanged.  Nor can a
deterministic one-copy channel simply manufacture a chosen multiplier:
fidelity monotonicity forbids a map taking every
`|psi_1(d)>` to `|psi_a(d)>` unless `a=0,+1,-1 mod N`.  Multiplication by a
larger public `a` would make adjacent outputs more distinguishable than the
adjacent inputs.  Collective or probabilistic transformations are not covered
by this one-copy statement.

Pairing labels has a population tradeoff.  A standard two-state parity merge
outputs `y+z` or `y-z`, each with probability `1/2`.  If `Q` labels are
bucketed modulo `B=2^m`, then for iid-uniform labels the expected number of
useful difference-branch outputs from disjoint equal-bucket pairs is at most

```text
Q*(Q-1)/(4*B).
```

Finding one collision uses the birthday scale `Q=Omega(sqrt(B))`, but
preserving a constant fraction of the population forces `B=O(Q)` and gains
only `m<=log2(Q)+O(1)` bits per layer.  An exact half-turn pair already needs
`Q=Omega(sqrt(N))`.  Sorting does not improve this: every wrong label,
including the nearest possible one `H+1`, has exactly zero one-qubit parity
information.  Exact subsets of cyclic gaps that total `H` are the same
modular-relation problem again.

More generally, for every fixed integer coefficient vector having an odd
entry, `sum_i a_iY_i` is uniform modulo `N`.  A fixed candidate combination
hits `H` with probability `1/N` and is divisible by `2^m` with probability
`2^(-m)`.  Polynomially many data-independent candidates only gain the
corresponding union-bound factor.  Choosing coefficients after seeing the
labels is precisely random modular relation/subset-sum search; these facts are
not a lower bound against that adaptive problem or a collective POVM.

There is an exact positive group-hashing step behind the collimation idea.
Tensor `k` raw phase states, reversibly compute

```text
f_Y(x) mod B,       B=2^m,
```

and measure the residue `r`.  Writing each compatible full sum as
`f_Y(x)=r+B*a_x`, and writing `eta_r` for the size of that measured fibre, the
normalized conditional state is, up to a global phase,

```text
eta_r^(-1/2) * sum_(x : f_Y(x)=r mod B)
  exp(2*pi*i*d*a_x/(N/B)) |x>.
```

It is therefore an exact phase vector whose height has fallen by `m` bits.
Its expectation over random labels and the Born-distributed measurement
outcome `r` is exactly

```text
E_(Y,r)[eta_r] = 1 + (2^k-1)/B.
```

Taking `k=m+O(1)` gives constant expected length.  The forward hash is an
efficient circuit; the unresolved operation is compression.  A standard
explicit-table realization enumerates the `2^k` paths, while retaining `x`
implicitly also retains the child/path indices.  Converting the implicit
fibre into a short clean phase-vector basis is again coherent fibre-index
erasure.  This explains why the positive hashing identity leads to a
collimation sieve rather than a polynomial decoder.

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

## A syndrome-isolated critical core

There is a genuine polynomial-time preprocessor that preserves the desired
phase and sharply reduces the number of unresolved paths.  It does not by
itself decode that phase.  Let the selection register have `q` coordinates,
let `F` be a fixed set of `e` faulty coordinates with fixed computational
values `b_F`, and start from the normalized supported state

```text
2^(-(q-e)/2) * sum_(x : x_F=b_F) omega^(d*f_Y(x)) |x>.
```

Choose an `r by q` binary matrix `M`, independently of the public labels and
the fault environment.  Reversibly compute and measure

```text
(M*x, f_Y(x) mod H) = (u,t).
```

For `j in {0,1}` put

```text
S_j = {x : x_F=b_F, M*x=u, f_Y(x)=t+j*H mod N},
eta_j = |S_j|.
```

The outcome probability and normalized residual state are exactly

```text
P[u,t] = 2^(-(q-e)) * (eta_0+eta_1),

omega^(d*t)/sqrt(eta_0+eta_1)
  * (sum_(x in S_0)|x> + (-1)^d sum_(x in S_1)|x>).
```

Thus this CSS-like hashing step is efficient and preserves the parity phase
even for deterministic fixed-basis faults.  What it retains, rather than
erases, are the two path sets `S_0,S_1`.

The residual relation count can be analyzed exactly.  Let `G=[q] minus F`,
assume `M_G` has row rank `r`, and define the difference code

```text
D = {a in F_2^q : a_F=0, M*a=0},
kappa = dim(D) = q-e-r.
```

Use the exact Born/planted coupling for this calculation: first draw `x`
uniformly from the supported affine cube, independently of `Y`, and then set
`(u,t)=(M*x,f_Y(x) mod H)`.  This reproduces the joint measured experiment,
including its size bias.  It does not condition on an externally prescribed
pair `(u,t)`.

For a supported path `x`, a partner difference `a` must obey

```text
g_x(a) = f_Y(x xor a)-f_Y(x)
       = sum_(i : a_i=1) (1-2*x_i)*Y_i
       = H mod N.
```

For iid-uniform `Y`, every nonzero `g_x(a)` is uniform in `Z_N`, and the
values for two distinct nonzero binary words are pairwise independent.  The
latter follows by selecting a `2 by 2` coefficient minor of determinant
`+1` or `-1`.  Hence, for

```text
Z_H = #{a in D minus {0} : g_x(a)=H},
Z_0 = #{a in D minus {0} : g_x(a)=0},
mu = (2^kappa-1)/N,
```

one has exactly

```text
E[Z_H] = mu,
Var(Z_H) = mu*(1-1/N),
mu/(mu+1-1/N) <= Pr[Z_H>0] <= min(1,mu).
```

This is an average paired-path statement for a computational path drawn with
its Born weight before the two deterministic labels are measured; it is not
a simultaneous guarantee for every syndrome/residue outcome.

The half containing the selected path has size `1+Z_0`, while the opposite
half has size `Z_H`; the same variance bound controls both centered random
parts.  They are asymptotically balanced when `mu` grows.  For a Bernoulli
random matrix, if `k=q-r>e`, then

```text
Pr[rank(M_G)=r]
  = product_(j=0)^(r-1) (1-2^(j-(q-e)))
  >= 1-2^(e-k).
```

Choosing `k=e+n+s` therefore leaves effective dimension
`kappa=n+s` and about `2^s` paths per half.  Taking
`s=Theta(log n)` makes the residual fibres polynomial-size and usually
paired in the preceding averaged sense.  This is a conditional parameter
statement, not a way to learn the hidden value `e`.  A public fault cap
`e_max` could instead be used with `k=e_max+n+s`, giving
`kappa>=n+s` whenever `e<=e_max`, at the cost of a larger residual core.  If
instead `k=n+s` is
fixed independently of faults, an allowed
environment with `e=Theta(n/log n)` reduces the mean partner count to about
`2^(s-e)`.

This compression does not make the residual inversion easy.  Uniformly
prepare `a in D` and test `g_x(a)=H`.  Averaged over the random public labels,
the marked fraction is still exactly

```text
E[Z_H/2^kappa] = (1-2^(-kappa))/N.
```

The projected-PREP/polar route therefore retains `Theta(sqrt(N))`
amplification cost.  Gaussian elimination only parameterizes the core; it
does not enumerate the polynomially many actual target solutions.  In the
singleton case, applying a logical Boolean Hadamard to

```text
(|z_0> + (-1)^d |z_1>)/sqrt(2)
```

returns a uniform `w` satisfying

```text
w dot (z_0 xor z_1) = d mod 2.
```

Interpreting that outcome requires the unknown half-turn move
`z_0 xor z_1`.  For larger fibres the corresponding likelihood is a Walsh
correlation of two code-constrained subset-sum fibres.  Thus an ordinary CSS
or logical-`X` measurement moves the relation into the classical
interpretation problem rather than removing it.

A sharp sufficient CSS condition illustrates the circularity.  If one could
find an affine code `x_0+C` and a known nonzero linear form `l` such that

```text
f_Y(x) = t+H*l(x) mod N
```

throughout the code, one Boolean Hadamard readout would reveal parity.  But a
nonzero direction of this code already supplies a half-turn relation.  For a
fixed, `Y`-independent `k`-dimensional candidate, the required basis
increments land in `{0,H}` with probability `2^k/N^k`; choosing the code from
`Y` must solve the modular constraints.

This positive preprocessor therefore narrows the open primitive to a
density-one, code-constrained random modular subset-sum decoder.  The
triangular-label/Gaussian-elimination interpolation of
[Remaud--Schrottenloher--Tillich](https://arxiv.org/abs/2206.14408) reaches the
same qualitative boundary in the clean setting: making its preparation
polynomial leaves a non-polynomial residual subset-sum problem, while making
the residual problem polynomial leaves subexponential preparation.  The
syndrome theorem above is not a polynomial HalfTurnTest.

### A concrete residue-pair syndrome shaves logarithmically many bits

The general syndrome construction has an explicit `Y`-dependent instance
that makes a real, but limited, algorithmic gain.  For one clean phase qubit

```text
|psi_y(d)> = (|0>+omega_N^(d*y)|1>)/sqrt(2),
```

take two labels `y,z` and measure the Boolean parity `p=x_1 xor x_2`.  Up to a
global phase and a Clifford relabelling, the two equiprobable outcomes are

```text
p=0 : |psi_(y+z)(d)>,
p=1 : |psi_(y-z)(d)>.
```

Fix `B=2^m` dividing `N`.  Partition residues modulo `B` into the orbits of
`r -> -r` and pair labels within each orbit by a deterministic index rule that
uses only their residues modulo `B`.  There are exactly

```text
c_B = B/2+1
```

orbits, so among `q` labels there are at least

```text
L >= (q-c_B)/2
```

disjoint pairs.  If the two residues agree, retain `p=1`; if they are
negatives, retain `p=0`.  The resulting logical label is divisible by `B`.
In the self-inverse residue classes `0` and `B/2`, both outcomes are usable.
For disjoint clean pairs, the number `G` of usable logical qubits therefore
stochastically dominates `Binomial(L,1/2)`.

Take `q=12*n`, let `k=n+s` with `s=O(log n)`, and choose the largest power of
two satisfying

```text
B/2+1 <= 6*n-6*s.
```

Then `B=Theta(n)`, `L>=3*k`, and a Chernoff bound gives

```text
Pr[G<k] <= exp(-k/12).
```

After retaining any `k` pairs chosen using only the residues and parity
outcomes, divide their labels by `B`.  The clean output is exactly

```text
tensor_(j=1)^k
  (|0>+omega_(N/B)^(d*A_j)|1>)/sqrt(2),
```

where the `A_j` are independent uniform elements of `Z_(N/B)`.  To see the
uniformity, write paired labels as `r+B*Q_y` and `+r+B*Q_z` or
`-r+B*Q_z`; the retained quotient is an affine sum or difference of two
independent high quotients.  Pairing and outcome selection use no high-
quotient information.

This removes `log_2 n+O(1)` modulus bits in polynomial time and lands on an
ordinary random modular subset-sum core.  Conditional on a fixed fault
environment with `e=O(n/log n)`, at most `e` disjoint pairs are contaminated.
The clean usable count dominates `Binomial(L-e,1/2)`, while the retained
block contains at most `e`
faulty logical outputs.  Its realized logical fault rate is therefore
`O(1/log n)`, although those outputs are not flagged.  Marginal fault bounds
alone do not force every realized environment to satisfy this count.

The gain cannot simply be iterated to a polynomial decoder.  At the reduced
modulus `N'=N/B`, a fixed nonzero prescribed target has label-averaged marked
fraction `(1-2^(-k))/N'`, including the zero-mask correction.  Thus generic
amplification still costs

```text
Theta(sqrt(N/B)) = 2^(n/2)/poly(n).
```

For `B=Theta(n)`, only one parity outcome is usable except for `O(1)` expected
self-inverse-residue samples.  One no-reuse layer retains
at most `q/4+O(1)` logical qubits in expectation and no more than
`q/4+o(q)` with
overwhelming probability.  Starting from `12*n`, two such layers therefore
leave at most `0.75*n+o(n)` qubits with overwhelming probability, while the
modulus still has `n-O(log n)` bits.  The next core is underdense.  Taking
`B=2` retains both
outcomes but removes only one modulus bit while halving the population; the
initial constant factor permits only three full layers before the output
falls below density one.

More generally, two random labels satisfy `y=+z or -z mod B` with probability
at most `2/B`.  A polynomial-size input can support a linear number of
disjoint candidate pairs with non-negligible probability only for `B=O(q)`.
For the present `q=12*n` block this is `B=O(n)`, so a no-reuse residue-pair
layer can remove only `O(log n)` bits while retaining `Theta(n)` variables.
For a general `q=poly(n)` block the same statement gives only
`B=poly(n)`, still just `O(log n)` bits.  This is a route-specific population
law, not a lower bound against overlapping or collective arithmetic circuits.

### Exact dyadic checksum factorization without outcome rejection

There is a population-preserving clean-core counterpart to residue pairing.
It is stronger in retained path dimension but weaker in output form.  For
`q>=m`, it
removes logarithmically many low modulus bits without rejecting any checksum
outcome, although the quotient phase becomes nonlinear.  Fix `B=2^m`, write

```text
a_i = Y_i mod B,
f_B(x) = sum_i a_i*x_i mod B,
```

and assume all participating coordinates are live selection qubits.  The
following statements are equivalent:

1. every fibre of `f_B` has exactly `2^(q-m)` elements;
2. there is a reversible classical bijection

   ```text
   x <-> (f_B(x),g(x)),  g(x) in {0,1}^(q-m);
   ```

3. for every `j=0,...,m-1`, at least one raw coefficient has
   `v_2(a_i)=j`.

For necessity, the Fourier transform of the subset-sum distribution is

```text
p_hat(k) = product_i (1+exp(2*pi*i*k*a_i/B))/2.
```

Uniform fibres require `p_hat(k)=0` for every nonzero `k`.  Taking
`k=2^(m-j-1)` forces a factor with valuation exactly `j`.  Conversely, one
coefficient of every valuation makes each nontrivial Fourier coefficient
vanish.

The converse is constructive.  Choose pivots `p_j` with
`a_(p_j)=2^j*u_j`, `u_j` odd, and retain all nonpivot bits as `z`.  For a
desired residue `r`, put

```text
c = r-sum_(i notin P) a_i*z_i mod 2^m.
```

The least bit of `c` uniquely fixes the valuation-zero pivot.  Subtract its
contribution, divide by two, and continue.  At step `j` the least bit of the
divided residual uniquely fixes `x_(p_j)`.  This triangular algorithm and its
inverse have polynomial-size reversible circuits.

Every `r` occurs with probability exactly `1/B`.  Conditioned on `r`, the
normalized state is, up to the global phase `omega_N^(d*r)`,

```text
2^(-(q-m)/2) * sum_z omega_(N/B)^(d*Q_r(z)) |z>.
```

The quotient is explicit but is not generally a fresh linear subset sum.
Write `Y_i=a_i+B*b_i`, let `u_r(z)` be the pivot solution, and define the
ordinary integer carry

```text
kappa_r(z)
  = [sum_(i notin P) a_i*z_i
     +sum_j a_(p_j)*u_(r,j)(z)-r]/B.
```

Then the conditional phase after measuring `r` is, up to a global phase,

```text
omega_(N/B)^(d*Q_r(z)),

Q_r(z)
  = sum_(i notin P) b_i*z_i
    +sum_j b_(p_j)*u_(r,j)(z)
    +kappa_r(z) mod N/B.
```

Thus the preprocessing is exact and efficient, but the pivot selectors and
carry make `Q_r` nonlinear.

For iid-uniform labels, the probability of missing valuation `j` is at most
`exp(-q/2^(j+1))`.  Hence

```text
m = floor(log_2(q/(C*log n)))
```

works with high probability for a sufficiently large constant `C`.  This
peels `log_2 q-O(log log n)` bits while accepting every checksum outcome and
removing only the `m` measured checksum coordinates.  It does not
iterate to a polynomial decoder.  If **every** first-stage residue `r` admits
a second no-rejection fixed-garbage factorization of `Q_r mod 2^s`, composing
the bijections gives

```text
x <-> (f_Y(x) mod 2^(m+s),g(x)).
```

The equivalence above then forces raw coefficients of every valuation through
`m+s-1`.  In particular, an all-outcome clean recursion cannot extend beyond
the largest contiguous raw valuation chain.  The probability that this chain
reaches `M` is at most `q/2^M`, so its total length is `O(log q)` with high
probability.

A selected residue can evade this statement.  For example, two unit weights
modulo four give a balanced quotient bit on the residue-zero branch but not on
the residue-one branch.  For fixed `r`, a reversible nonlinear pivot exposing
the next bit exists exactly when the even and odd `Q_r` subfibres have equal
size; constructing it is a bijection between those two conditional fibres.
That is the same fibre-matching primitive under investigation, rather than an
automatic continuation of triangular elimination.  Fixed-basis faults on a
pivot also invalidate the cube bijection, so this paragraph is a clean-core
structural construction, not a repair of the unflagged fault model.

### Overlapping linear syndromes expose carry constraints, not free reuse

The preceding population bound leaves open a circuit that overlaps many
CNOT parity checks rather than consuming disjoint pairs.  Such a circuit has
an exact normal form.  Fix `B=2^m` dividing `N`.  On any one computational-
syndrome branch its surviving support is an affine binary code

```text
x = x_0+G*z,  z in F_2^k,
```

where `G` has column rank `k`.  Let `v_i` be row `i` of `G`, put
`sigma_i=(-1)^(x_0_i)`, and group the public labels by row pattern:

```text
A_v = sum_(i:v_i=v) sigma_i*Y_i mod B.
```

The restricted modular phase is exactly

```text
f_Y(x_0+G*z)
  = f_Y(x_0)+sum_(v != 0) A_v*(v dot z mod 2) mod B.
```

Using the integer algebraic normal form

```text
v dot z mod 2
  = sum_(nonempty T subset supp(v))
      (-2)^(|T|-1)*product_(j in T) z_j,
```

this phase is constant modulo `B` if and only if, for every nonempty
`T subset [k]` with `|T|<=m`,

```text
sum_(v:T subset supp(v)) A_v = 0 mod 2^(m-|T|+1).
```

The converse follows from Boolean Mobius inversion; terms of degree greater
than `m` already contain a factor `2^m`.  Thus overlap replaces disjoint
pairing by simultaneous higher-order carry congruences.  It does not let one
physical phase label serve several independent logical variables for free.

For a fixed full-rank affine embedding chosen independently of iid-uniform
`Y`, the degree-one congruences alone are a surjective map onto `Z_B^k`: the
row patterns spanning `F_2^k` contain an odd-determinant `k` by `k` minor.
They therefore hold with probability exactly `B^(-k)`, and full constancy has
probability at most `B^(-k)`.

In fact, at the full half-turn modulus one can union-bound **all** affine
embeddings, including ones selected after seeing `Y`.  Fix a `k`-dimensional
affine coset `C=x_0+D`, choose a full-rank `q` by `k` generator `G` for `D`,
and let `s` be the number of distinct nonzero row patterns of `G`.  The signs
from `x_0` are already included in the independent uniform aggregates `A_v`
above.  The coset is contained in one `f_Y mod B` fibre only if

```text
sum_(v != 0) A_v*(v dot z mod 2) = 0 mod B
```

for every `z`.  For distinct nonzero patterns `v`, the Boolean parity
functions

```text
p_v(z) = v dot z mod 2 = (1-chi_v(z))/2
```

are linearly independent over the rationals.  Their evaluation matrix
therefore contains a nonsingular `s` by `s` zero-one minor `Q`.  If the Smith
invariants of `Q` are `d_1,...,d_s`, then for `B=2^m`

```text
Pr[Q*A = 0 mod 2^m]
  = 2^(-m*s+sum_j min(m,v_2(d_j)))
  <= 2^(-m*s+v_2(det Q))
  <= 2^(-m*s+(s/2)*log_2 s).
```

The last step is Hadamard's determinant bound.  Row-pattern count is
basis-invariant.  The number of full-rank generators using `s` patterns is at
most

```text
choose(2^k-1,s)*(s+1)^q <= 2^(k*s)*(s+1)^q.
```

Every `k`-subspace has exactly `|GL(k,2)|` generators, where
`|GL(k,2)|>=c_0*2^(k^2)` for the absolute constant
`c_0=product_(j>=1)(1-2^(-j))`, and each subspace has `2^(q-k)` affine
cosets.  Consequently

```text
Pr[there exists a k-dimensional affine C
   on which f_Y mod 2^m is constant]
 <= c_0^(-1) * sum_(s=k)^min(q,2^k-1)
      2^(s*(k-m)+(s/2)*log_2 s-k^2
         +q*log_2(s+1)+q-k).
```

This is a union over every subspace and every coset, so it already includes
arbitrary `Y`-dependent selection.  For `q=12*n`, `m=n-1`, and `k=91`, the
largest summand is the `s=91` term for all sufficiently large `n`, with
exponent

```text
(-91+12*log_2(92)+12)*n+O(1)
  = -0.717256...*n+O(1).
```

Summing the at most `12*n` terms changes this only by `O(log n)`.  Thus, with
probability `1-2^(-0.71725*n+O(log n))`, no affine coset of dimension at least
`91` is contained in one `f_Y mod H` fibre.  In particular, the desired
dimension `n+o(n)` affine branch does not merely lack a known solver: it is
absent with overwhelming probability.

This does not contradict the syndrome-isolated core above.  That construction
also measures `f_Y mod H`, and its support is the generally non-affine
intersection of an affine syndrome coset with a modular subset-sum fibre.
The theorem does not cover such intersections, unions of branches,
nonuniform or approximate support, nonlinear encodings, or a direct
cross-fibre polar.

There is also a sharp accept-all corollary.  If one fixed syndrome map must
make `f_Y mod B` constant on every coset of `D=ker M`, then comparison of
`f_Y(x xor a)-f_Y(x)` at `x=0` and at `x=e_i` gives, for every `a in D`,

```text
sum_(i:a_i=1) Y_i = 0 mod B,
2*Y_i = 0 mod B for every i in supp(a).
```

These conditions are also sufficient.  Hence `D` may touch only coordinates
with `Y_i mod B` in `{0,B/2}`.  If `X` counts those coordinates for random
labels, then `X` is `Binomial(q,2/B)`, `dim D<=X`, and
`E[dim D]<=2*q/B`; for example `dim D=O(q/B+log n)` with high probability.
The residue-pair construction escapes by routing or rejecting branches; it
pays the population loss above.

Coherent reuse of many random hashes has an equally exact bookkeeping law.
For a uniform `ell` by `q` binary hash `L`, measuring `Lx` preserves the
off-diagonal `|x><x'|` precisely when

```text
L*(x xor x') = 0,
```

For fixed `L` the multiplier is the indicator of this event; averaging over a
fresh uniform `L` gives exactly `2^(-ell)`.  Measuring and forgetting the hash
record applies that dephasing irreversibly.  If the hash is only computed
coherently, retaining `(L,Lx)` keeps orthogonal which-hash garbage, while
reversing the computation before any measurement merely restores the original
uncompressed state.  Erasing the hash while coherently summing every
compatible pair is again an incidence-polar/fibre-erasure operation.

These identities also explain why standard coding substitutions do not yet
finish the decoder.  A trellis or BCJR message must retain the running
residue in `Z_N`, hence has `N` states.  Binary polar or CNOT transforms retain
the higher-degree terms above.  A conventional code-graph quantum walk still
has label-averaged marked fraction
`(1-2^(-kappa))/N`, so the usual marked-fraction term is `Theta(sqrt(N))`
even if the graph gap is constant.  This does not rule out a new succinct
`Y`-dependent arithmetic message or transition rule.  It identifies the
positive interface precisely: construct a useful non-affine residue
intersection or union with coherently erasable labels, or implement the
corresponding cross-fibre polar directly.  No such polynomial construction
was found.

### Exact basis pairing is an RMSS solver

The remaining non-affine opening is not supplied by an arbitrary classical
reversible preprocessor followed by one final Hadamard.  On any fixed
computational transcript, such a circuit is an injective basis encoding

```text
x -> (b(x),g(x)).
```

Every garbage label `g` for which both values of `b` occur defines a disjoint
pair `x_0(g),x_1(g)`.  The difference between the even- and odd-secret
averaged interference terms of this pair is zero unless

```text
f_Y(x_1(g))-f_Y(x_0(g)) = H mod N.
```

Every valid pair contributes half of its two-path probability mass,
equivalently one path's mass, to the parity advantage.  For an equal-amplitude
`q`-bit cube, if `M_tau` is the
number of valid unordered pairs on transcript `tau`, then

```text
conditional advantage = M_tau/|S_tau|,
mass-weighted total advantage = sum_tau M_tau/2^q.
```

Moreover, flipping `b` and reversing the classical circuit computes the
partner path.  Under the planted change of variables

```text
A_i = (-1)^(x_i)*Y_i,
```

a partner difference `a=x xor x'` satisfies exactly

```text
sum_(i:a_i=1) A_i = H mod N.
```

The `A_i` are fresh iid-uniform labels when `Y` is uniform and the planted
path is sampled first.  Therefore any uniform polynomial reversible
preprocessor of this form with inverse-polynomial mass advantage gives an
inverse-polynomial-success polynomial RMSS solver.  This is a reduction, not
an RMSS hardness theorem, but it closes the idea that a complicated
Toffoli/CNOT basis permutation plus one Hadamard could avoid relation search
merely by using non-affine garbage labels.

There is an exact full-coverage boundary on the clean equal-amplitude cube.
An arbitrary, even unbounded and `Y`-dependent, permutation can pair
**every** basis path with a half-turn partner if and only if some live raw
label equals `H`.  Necessity follows because
full pairing gives `p_t=p_(t+H)` for every subset-sum probability `p_t`.
Hence `p_hat(1)=0`, while

```text
p_hat(1) = product_i (1+omega^(Y_i))/2,
```

so some factor forces `Y_i=H`.  Sufficiency is just flipping that coordinate.
Thus full exact basis pairing has probability at most `q/N` for random labels.

This does not obstruct near-complete abstract matching.  Its maximum coverage
is

```text
gamma = 1-sum_(t=0)^(H-1) |p_t-p_(t+H)|.
```

For iid labels,

```text
E sum_(t in Z_N) (p_t-p_(t+H))^2 = 2^(1-q),
E[1-gamma] <= 2^((n-q-1)/2).
```

At `q=12*n`, the expected unmatched mass is therefore exponentially small,
with the corresponding Markov tail bounds.  The computational problem is to
rank or align those enormous, nearly balanced fibres coherently.  Exact full
matching is rare, while information-theoretic partial matching is plentiful;
neither observation constructs the missing efficient unitary.

## A signed harmonic and an orbit-access query barrier

The robust parity observable also has a particularly simple Fourier-harmonic
form.  Let `E` be the low-weight error-label space and put

```text
A = H^(tensor q) J_E,
P_0 = A*A^dagger,
C|d,e> = U_Y^d A|e>,
G = C^dagger*C,
Z_par|d> = (-1)^d |d>.
```

Then the alternating conjugation orbit is exactly

```text
K_E = sum_(j in Z_N) (-1)^j U_Y^j P_0 U_Y^(-j)
    = C (Z_par tensor I_E) C^dagger.
```

If `C=V*sqrt(G)` is its polar decomposition, the zero-extended ideal parity
observable is

```text
T_par = V (Z_par tensor I_E) V^dagger.
```

On `||G-I||_op<=epsilon<1`, define

```text
beta = ||sqrt(G)-I||_op <= 1-sqrt(1-epsilon).
```

Then, on the occupied code range, or globally when `T_par` is extended by
zero,

```text
||K_E-T_par||_op <= 2*beta+beta^2.
```

This is just the expansion of
`sqrt(G)*Z_par*sqrt(G)-Z_par`.  Fibrewise, if
`D_t=Pi_t*A`, the same operator is

```text
K_E = N * sum_t D_(t+H) D_t^dagger.
```

Writing `D_t=U_t*S_t` gives

```text
K_E = N * sum_t U_(t+H) S_(t+H) S_t U_t^dagger.
```

Its Gram-flat limit is the cross-fibre transport `T_tilde` above, and the
occupied-range distance is controlled by the displayed
`2*beta+beta^2` bound.
Equivalently, for the efficient translated reference reflections

```text
R_j = 2*U_Y^j P_0 U_Y^(-j)-I,
```

one has `K_E=(1/2)*sum_j(-1)^j R_j`.  This is an exact direct construction,
but its natural LCU normalization is `N/2`.

### The clean orbit dictionary cannot reduce this normalization

In the clean case the normalization is intrinsic to this particular LCU
dictionary, rather than an artifact of choosing equal weights.  Write

```text
W = sum_(j in Z_N) |psi_j><j|,
G = W^dagger*W,
D = diag_j((-1)^j),
P_j = |psi_j><psi_j|.
```

Assume `||G-I||_op<=delta<1`, and let `V=W*G^(-1/2)` be the polar isometry.
The ideal zero-extended parity observable is `T=V*D*V^dagger`.  For diagonal
`C=diag(c_j)`,

```text
sum_j c_j*P_j = W*C*W^dagger
              = V*sqrt(G)*C*sqrt(G)*V^dagger.
```

If this operator approximates `T` on `ran(V)` with error `epsilon`, then

```text
||C-D||_op <= (epsilon+delta)/(1-delta),
sum_j |c_j|
  >= N*(1-(epsilon+delta)/(1-delta)).
```

The first inequality follows by conjugating through `sqrt(G)` and using

```text
||G^(-1/2)-I||*(||G^(-1/2)||+1) <= delta/(1-delta).
```

Separately, for the raw signed frame `K=W*D*W^dagger`, a left inverse of the
full-column-rank map `W` shows that

```text
sum_j c_j*P_j = K
```

forces `C=D`.  Its signed projector coefficients are unique and their `l_1`
norm is exactly `N`.  The same exact conclusion holds for the reflection
dictionary.  Put

```text
R_j = 2*P_j-I,
L_tilde = sum_j a_j*R_j+b*I.
```

Because the physical Hilbert space has dimension greater than `N`, the
orthogonal complement of `ran(V)` fixes the identity offset.  An
`epsilon`-approximation to the zero-extended `T` obeys

```text
sum_j |a_j|
  >= (N/2)*(1-(2*epsilon+delta)/(1-delta)).
```

The exact reflection representation of `K` therefore has the unique
normalization `N/2`.  Nonuniform coefficients and cancellation do not improve
it.  The preceding inequality separately says that any constant-error
diagonal-projector or reflection approximation to `T`, if one exists, still
has linear normalization.  This is a dictionary theorem: it does not cover
higher-rank grouped preparations, a different arithmetic block encoding, or
an unrelated circuit for `T`.

Directly block-encoding the parity density matrix is even less favorable.
The efficient purifications

```text
|Phi_b>
  = sqrt(2/N)*sum_(j mod 2=b) |j>|psi_j>
```

give a constant-normalized block encoding of

```text
rho_b = (2/N)*sum_(j mod 2=b) P_j,
Delta = rho_0-rho_1 = (2/N)*W*D*W^dagger.
```

If `p_t=N*eta_t/2^q`, the two eigenvalues on the fibre pair
`{t,t+H}` are

```text
+/-(2/N)*sqrt(p_t*p_(t+H)).
```

On the Gram-flat event they have magnitude `Theta(1/N)`.  If a degree-`r`
polynomial bounded by one on `[-1,1]` approximates the sign at `+/-s`, where
`s=Theta(1/N)`, with fixed error below one, the mean-value theorem and
Bernstein's inequality give

```text
r = Omega(1/s) = Omega(N).
```

Equivalently, direct qubitization must resolve an eigenphase gap
`Theta(1/N)`.  Factoring through `B=W/sqrt(N)` exposes singular values only
at scale `Theta(N^(-1/2))`; its projected-unitary/QSVT polar route therefore
costs `Theta(sqrt(N))` at constant accuracy, up to approximation logarithms.
The square-root frame construction is genuinely better than taking the sign
of `Delta`, but it is still exponential.  These statements concern the
standard purified-density and projected-unitary encodings, not a hypothetical
arithmetic block encoding with exponentially better normalization.  See the
primary [QSVT](https://arxiv.org/abs/1806.01838) and
[qubitization](https://arxiv.org/abs/1610.06546) references.

More strongly, square-root cost is necessary in the entire idealized
**orbit/reference** access model.  Let `S|z>=|z+1>` be an `N`-position clock.
Give an algorithm arbitrary controlled powers `S^a`, translation-covariant
ancilla gates, and `T` uses of the reference reflection

```text
R_ref = I-2*|0><0| tensor I_E.
```

Every free operation, including the coupling to the output ancilla, must
commute with global clock translation, and the final bit is read only from
that ancilla.  Direct clock-position measurement is not part of this model;
with such a measurement the promised basis input would reveal `d` trivially.
The success criterion is bounded error, equivalently constant worst-case
advantage over guessing.

On input `|d>|v>`, conjugating the computation by `S^(-d)` moves the input to
`|0>|v>` and changes `R_ref` into the phase oracle marking the unique position
`-d`.  Since `N` is even, `parity(-d)=parity(d)`.  The task is therefore to
decide whether one uniquely marked item lies in the even or odd parity class
of the clock.

The adversary matrix between even and odd marked positions is the all-ones
matrix of `K_(N/2,N/2)`.  Its norm is `N/2`, while masking by any one query
position gives a star of norm `sqrt(N/2)`.  The adversary ratio is therefore
`sqrt(N/2)`, proving

```text
T = Omega(sqrt(N)).
```

This agrees with optimal unstructured search; see
[Ambainis's adversary method](https://arxiv.org/abs/quant-ph/0002066) and
[Zalka's optimal search bound](https://arxiv.org/abs/quant-ph/9711070).  The
reference reflection is itself efficient, because it is a Boolean-Hadamard
conjugate of a reversible Hamming-weight test.

The physical Gram-good frame inherits the bound.  The polar isometry
intertwines `U_Y` with the clock shift.  If `P'_0` denotes the ideal reference
projector transported into the physical range, put
`R_phys=I-2*P_0` and `R'_0=I-2*P'_0`.  Then

```text
||P_0-P'_0||_op <= 2*beta,
||R_phys-R'_0||_op <= 4*beta,
```

and the physical input differs from its ideal-clock image by at most `beta`.
A `T`-query hybrid changes the final state by at most `(4*T+1)*beta`.  Under
the `q=12*n`, `tau=1/32` Gram parameters above,
`beta*sqrt(N)` is exponentially small, so the `Omega(sqrt(N))` lower bound
survives on the promised robust code states.

This theorem permits fast-forwarding every orbit translation; it is stronger
than the polynomial-functional-calculus/QSVT barrier.  It still does not
cover arbitrary gates exploiting the internal Boolean subset-sum arithmetic,
so it is not a general circuit lower bound.

One fixed-walk attempt makes the distinction concrete.  In the ideal clock,
put `W=R_ref*S^2`.  For `H=N/2`,

```text
W^H = I-2*Pi_even = -Z_par.
```

Fast-forwarding this particular walk would solve the problem, but its odd
sector has phases `2*pi*k/H` while its even sector has the interlaced phases
`2*pi*(k+1/2)/H`.  Ordinary phase estimation must resolve separation
`pi/H` and costs `Theta(H)` walk uses.  Adaptive Grover-style use improves
this to `Theta(sqrt(N))`, and the orbit theorem prevents a further gain in
this model.

There is also no exact bounded-local anticommuting observable on a typical
random block.  If an `r`-local operator `O` obeys
`U_Y O U_Y^dagger=-O`, every nonzero computational-basis entry connects paths
at distance at most `r` whose subset sums differ by `H`.  Therefore

```text
Pr_Y[there is a nonzero such O]
  <= N^(-1) * sum_(j=1)^r 2^j*choose(q,j).
```

At `q=12*n`, this is exponentially small for
`r<0.10838*n`.  This excludes direct exact bounded-support half-turn
Hamiltonians or walk generators; it does not exclude deep circuits or
long-time evolution under a generic local Hamiltonian.

### A bounded-output matchgate circuit is parity-blind

Another structured route can be excluded exactly below a linear output
threshold.  On the clean input

```text
|psi_d^Y>
  = tensor_(i=1)^q (|0>+omega^(d*Y_i)|1>)/sqrt(2),
```

allow a parity-preserving fermionic-Gaussian unitary that depends arbitrarily
on the public `Y`, and nonadaptive measurement of `k` output occupations.
The initial joint state is required to be

```text
|psi_d^Y><psi_d^Y| tensor sigma_A(Y),
```

where the ancilla state is arbitrary but independent of `d`.  If there is no
signed relation

```text
sum_(i in S) sigma_i*Y_i = H mod N,
1 <= |S| <= 2*k,  sigma_i in {+1,-1},
```

then the complete `k`-bit output distribution is exactly the same under the
uniform even-secret and odd-secret ensembles.

Indeed, Gaussian evolution maps each Majorana operator linearly to other
Majoranas.  Every product of a subset of the `k` measured occupation signs
therefore pulls back to a sum of Majorana monomials of degree at most `2*k`.
After the Jordan--Wigner map, a term containing a data `Z` has zero expectation
on the equatorial input.  Every surviving term has secret-frequency support
among signed sums of at most `2*k` public labels.  Parity averaging keeps only
the half-turn character,

```text
(1/N)*sum_(d in Z_N) (-1)^d*omega^(d*r) = 1_(r=H).
```

Thus all output sign moments agree, and Walsh inversion makes the whole
classical output law agree.  For iid-uniform labels,

```text
Pr[there is such a relation of weight at most 2*k]
  <= N^(-1)*sum_(w=1)^(2*k) 2^w*choose(q,w).
```

At `q=12*n`, this is exponentially small whenever, for some fixed
`epsilon>0`,

```text
k <= (0.0541889-epsilon)*n.
```

There is a similarly scoped adaptive statement.  For a fixed transcript of
`k` sequential occupation measurements with only
Gaussian feedforward between them, the POVM effect contains `2*k-1`
occupation projectors in `K^dagger*K` and hence has Majorana degree at most
`4*k-2`.  Its transcript distribution is parity-identical when no relation
of that support exists, giving the typical-instance threshold

```text
k <= (0.0270944-epsilon)*n
```

for `q=12*n` and any fixed `epsilon>0`.

This excludes low-output matchgate/free-fermion summaries, not all Gaussian
circuits.  It does not cover ordinary qubit operations that break fermionic
Gaussianity, non-Gaussian gates or injections, arbitrary-basis measurement
patterns, a prior preprocessing that entangles data and ancillas outside the
Gaussian model, or circuits reading linearly many outputs beyond the stated
threshold.  The formalism follows
[Jozsa--Miyake](https://arxiv.org/abs/0804.4050); adaptive
noninteracting-fermion circuits are treated by
[Terhal--DiVincenzo](https://arxiv.org/abs/quant-ph/0108010).

### Linear-output matchgates expose the passive decoding problem

The output threshold above is qualitatively near-tight.  Pair the clean data
qubits and apply the nearest-neighbour matchgate

```text
G(H_2,H_2)
  = 2^(-1/2) *
    [ 1  0  0  1
      0  1  1  0
      0  1 -1  0
      1  0  0 -1 ],

H_2 = 2^(-1/2) * [1 1; 1 -1].
```

The even- and odd-parity blocks have the same determinant, so this is a legal
matchgate.  For one input pair with labels `Y_i,Y_j`, its four occupation
probabilities are

```text
Pr[00] = [1+cos(2*pi*d*(Y_i+Y_j)/N)]/4,
Pr[11] = [1-cos(2*pi*d*(Y_i+Y_j)/N)]/4,
Pr[01] = [1+cos(2*pi*d*(Y_i-Y_j)/N)]/4,
Pr[10] = [1-cos(2*pi*d*(Y_i-Y_j)/N)]/4.
```

The parity sector is uniform and secret-independent.  Set `Z=Y_i+Y_j` in
the even sector, `Z=Y_i-Y_j` in the odd sector, and set `S=+1` for outcomes
`00,01` and `S=-1` for `11,10`.  Then

```text
Pr[S=s | Z,d] = [1+s*cos(2*pi*d*Z/N)]/2,
```

and disjoint pairs give iid-uniform `Z`.  Thus `q=12*n` clean phase qubits
produce `6*n` independent visibility-one passive cosine observations using
only a Gaussian circuit and occupation measurements.

These observations determine parity exponentially reliably.  For opposite-
parity candidates `d,k`, one of them is odd and invertible.  Rescaling the
uniform label makes the other frequency an even multiplier `r`.  The
one-sample Hellinger affinity is at most `sqrt(3)/2`: the squared conditional
affinity has mean at most `3/4`, by character orthogonality and
Cauchy--Schwarz.  The likelihood-ratio/Hellinger bound and a union bound give

```text
Pr[maximum-likelihood parity is wrong]
  <= (N/2)*(sqrt(3)/2)^(6*n)
  = 2^(-0.245112...*n-1).
```

This is averaged over iid labels and outcomes for every fixed secret.  It is
an information and measurement theorem, not an efficient decoder: the direct
maximum-likelihood implementation scans `N` candidates, and no polynomial
optimization is known.

Indeed, for the effective transcript `D=((Z_i,S_i))`, put

```text
P_D(X)
  = product_i [1+(S_i/2)*(X^(Z_i)+X^(-Z_i))]
  = sum_t A_t X^t mod (X^N-1).
```

The two parity evidences are exactly

```text
E_b = 2^(-6*n) * [A_0+(-1)^b*A_H].
```

So full-output Gaussian decoding lands on the same weighted ternary
coefficient problem as passive `X` measurement.  Pointwise Pfaffian
evaluation does not sum it over the `N` roots of unity.  In fact

```text
P_D(X)
  = Pf(direct_sum_i [0 p_i(X); -p_i(X) 0]),

p_i(X)=1+(S_i/2)*(X^(Z_i)+X^(-Z_i)).
```

Even this block-diagonal sparse-exponent Pfaffian still requires extracting
the cyclic coefficients `A_0,A_H`.  The generic sparse-exponent Pfaffian
coefficient problem contains ordinary subset-sum counting through block
factors `1+X^(w_i)`; this does not prove hardness for the restricted random
physical factors above.  For this clean product input, full and adaptive
occupation-transcript probabilities remain efficiently evaluable for each
fixed candidate by covariance/Pfaffian methods, but no polynomial procedure
for summing or optimizing them over secret parity was found.  See
[Bravyi](https://arxiv.org/abs/quant-ph/0404180) and
[Brod](https://arxiv.org/abs/1602.03539) for the relevant Gaussian
measurement and simulation formalisms.

## Candidate verification and posterior filtering

A different direct construction starts from a uniform superposition over
candidate secrets.  For `m` clean phase samples, set

```text
|Psi_d^Y> = 2^(-m/2) * sum_x omega^(d*f_Y(x)) |x>.
```

Controlled phase correction by a candidate `k`, followed by Boolean
Hadamards and postselection on `0^m`, produces hypothesis amplitude

```text
A_Y(d-k)
  = 2^(-m) * sum_x omega^((d-k)*f_Y(x))
  = product_i (1+omega^((d-k)*Y_i))/2.
```

If `eta_t` denotes the full-sum fibre size, the exact herald probability is

```text
p_0 = (1/N)*sum_k |A_Y(d-k)|^2
    = 2^(-2*m) * sum_t eta_t^2.
```

For iid-uniform labels,

```text
E_Y[p_0] = 2^(-m) + (1-2^(-m))/N.
```

The joint probability of heralding and holding the true candidate is exactly
`1/N`, because `A_Y(0)=1`.  More explicitly,

```text
Pr[k=d and herald] = 1/N,
Pr[k=d | herald] = 1/(N*p_0),
Pr[k | herald] = |A_Y(d-k)|^2/(N*p_0).
```

In the balanced random-label regime, the averaged formula displays the
tradeoff: when `m<n`, heralding is easier but the true-candidate mass is of
order `2^m/N`, corresponding to effective candidate count `N/2^m`; literal
support need not shrink.  When `m>=n+O(1)`, the conditional
candidate can be useful, but on the corresponding balanced-fibre event the
herald itself has probability
`Theta(1/N)`.  This is a valid postselected decoder whose natural coherent
amplification scale is again `sqrt(N)`; for one-shot unknown input states,
even the reflection needed for that amplification may require extra copies.

The same normalization appears after passive `X` measurements.  For data
`D=((Y_i,S_i))`, define

```text
ell_i(k) = (1+lambda*S_i*cos(2*pi*k*Y_i/N))/2,
L_D(k) = product_i ell_i(k),
pi_D(k) = L_D(k)/sum_j L_D(j).
```

The most direct square-root likelihood filter, normalized by
`ell_max=(1+lambda)/2`, prepares the coherent posterior after successful
postselection, but succeeds with

```text
p_filter = (sum_k L_D(k))/(N*ell_max^q)
         = (L_max/ell_max^q)/(N*pi_max)
         <= 1/(N*pi_max),
L_max = max_k L_D(k),
pi_max = max_k pi_D(k).
```

Once the posterior has constant mass on `d` or `{d,-d}`, the filter therefore
has probability `O(1/N)`.  Amplitude amplification costs `Omega(sqrt(N))` in
this state-conversion model.  Sequential filtering does not automatically
remove the cost: a failed filter maps the preceding posterior to a different
failure-conditioned state, so a naive retry cannot resume it.  Retaining all
failure flags leaves unconditioned hypothesis populations.  An annealing
version would need independent efficient
reflections about its intermediate posteriors or a proven rapidly mixing
posterior chain.  This is the setting captured by
[quantum rejection sampling](https://arxiv.org/abs/1103.2774), not a lower
bound against a new arithmetic decoder.

There is an exact classical expression for what such an arithmetic decoder
would have to compute.  Put `a_i=lambda*S_i/2` and form the cyclic generating
function

```text
P_D(X) = product_i (1+a_i*X^(Y_i)+a_i*X^(-Y_i))
       = sum_(t in Z_N) A_t X^t mod (X^N-1).
```

Then `L_D(k)=2^(-q)*P_D(omega^k)`.  Under the uniform prior on `d`, the two
parity evidences are exactly

```text
E_b = (2/N) * sum_(k mod 2=b) L_D(k)
    = 2^(-q) * (A_0+(-1)^b*A_H).
```

Since `A_0>0`, the Bayesian parity success is

```text
P_Bayes = 1/2 + |A_H|/(2*A_0).
```

Thus optimal passive parity decoding reduces to two coefficients of a
weighted ternary subset-sum polynomial.  The cyclic dynamic program costs
`O(q*N)` and an FFT costs `O(N*log N)`; no polynomial-in-`n` way to obtain the
ratio `A_H/A_0` was found.  An absolute-weight proposal for its ternary
expansion hits residue `H` with random-label probability about `1/N`.  Because
the coefficients are signed, this is only a hit-rate obstruction, not a tight
estimator complexity bound; cancellation can make coefficient estimation
harder.

The normalization barrier can be stated exactly for ordinary importance
sampling.  Write

```text
W(k) = P_D(omega^k),
pi(k) = W(k)/sum_j W(j).
```

Sampling `k` uniformly to estimate `A_0=N^(-1)*sum_k W(k)` has squared
coefficient of variation

```text
CV^2 = N*sum_k pi(k)^2-1.
```

The tight-envelope rejection sampler succeeds with probability

```text
A_0/max_k W(k) = 1/(N*pi_max).
```

Consequently, once the posterior has constant effective support, the direct
Monte Carlo estimator needs `Theta(N)` samples and coherent rejection has
the familiar `Theta(sqrt(N))` scale.  For a general proposal `Q`, the second-
moment factor is

```text
sum_k pi(k)^2/Q(k) = 1+chi^2(pi || Q).
```

A useful proposal must therefore already place polynomial mass on the hidden
posterior modes.  These are statements about importance/rejection methods,
not lower bounds against arithmetic circuits.

The posterior concentration behind this variance barrier can be proved
directly.  In the matched passive model, let

```text
W_D(k) = product_i [1+lambda*S_i*cos(2*pi*k*Y_i/N)],
```

assume `d` is not `0,H`, and let `C` be the parity class containing the two
indistinguishable candidates `{d,-d}`.  For one labelled sign observation,
the Hellinger affinity between candidates `d` and `k notin {d,-d}` obeys

```text
E_Y Affinity(P_d(.|Y),P_k(.|Y)) <= 1-lambda^2/8.
```

Indeed, squared Hellinger distance is at least half squared total variation,
and character orthogonality gives

```text
E_Y [cos(2*pi*d*Y/N)-cos(2*pi*k*Y/N)]^2 >= 1.
```

For independent samples, put

```text
T_D = sum_(k notin {d,-d}) sqrt(W_D(k)/W_D(d)).
```

Then

```text
E_D[T_D] <= (N-2)*(1-lambda^2/8)^q.
```

At `q=12*n`, define

```text
beta(lambda) = -1-12*log_2(1-lambda^2/8).
```

For every `0<alpha<beta(lambda)`, Markov's inequality and
`sum r_k <= (sum sqrt(r_k))^2` give

```text
Pr[sum_(k notin {d,-d}) W_D(k)
     > N^(-2*alpha)*W_D(d)]
  <= N^(-(beta(lambda)-alpha)+o(1)).
```

At visibility one,

```text
beta(1) = 12*log_2(8/7)-1 = 1.3117409...,
```

and the paper-scale `lambda=1-O(1/log n)` changes this only by `o(1)`.
Thus the correct-parity posterior has
`1-O(N^(-2*alpha))` mass on `{d,-d}`, while the wrong-to-correct evidence
ratio is `O(N^(-2*alpha))`, with the displayed high probability.

Sharp posterior concentration does not make uniform candidate sampling
efficient.  Within the correct parity class of size `N/2`, on the same event,

```text
CV^2
  = (N/2)*sum_(k in C) pi_C(k)^2-1
  >= N/(2+N^(-2*alpha))^2-1
  = N/4-o(N).
```

More generally, if a proposal assigns total mass `r` to `{d,-d}`, its
importance second-moment factor is at least `(1-o(1))/r`.  Polynomial relative
variance therefore requires a proposal that has already placed
inverse-polynomial mass on the hidden pair.  The square-root posterior has
squared overlap `4/N*(1+o(1))` with the uniform state on the correct parity
class, reproducing `Theta(sqrt(N))` state conversion in this candidate
dictionary.  These are candidate-sampling and state-conversion barriers, not
an arithmetic lower bound.

There is no linear cross-parity control-variate shortcut in the matched
ensemble.  With `p=(-1)^d`, set

```text
R=A_0+p*A_H,
Q=A_0-p*A_H,
g_1=(1+lambda^2/2)^q-1.
```

The exact moments satisfy

```text
E[R] = 1+4*g_1/N,
E[Q] = 1,
E[R*Q] = E[A_0^2-A_H^2] = 1+4*g_1/N.
```

Hence `Cov(R,Q)=0` exactly.  Equivalently, every fixed even/odd candidate
pair has zero likelihood covariance after averaging the matched data.  This
rules out only a linear control variate under this ensemble, not nonlinear
arithmetic, annealing, or a data-dependent proposal that locates the hidden
pair by another method.

There is also a quantitative sign-cancellation diagnostic in the matched
observation model.  Assume `d` is neither `0` nor `H`, the labels are iid
uniform, and

```text
Pr[S_i=s | Y_i,d]
  = (1+s*lambda*cos(2*pi*d*Y_i/N))/2.
```

Character orthogonality gives the exact first moments

```text
E[W(k)]
  = [1+(lambda^2/2)*(1_(k=d)+1_(k=-d))]^q,
E[A_0]
  = 1+(2/N)*[(1+lambda^2/2)^q-1],
E[A_H]
  = (-1)^d*(2/N)*[(1+lambda^2/2)^q-1].
```

For comparison, put `C=(1+lambda)^q` and replace every ternary coefficient by
its absolute value.  Every nonzero ternary word contains a unit coefficient,
so its random modular sum is uniform and

```text
E[U_H] = (C-1)/N,
E[U_0] = 1+(C-1)/N.
```

At `lambda=1` and `q=12*n`, the mean signed signal has scale
`N^(12*log_2(3/2)-1)=N^6.01955...`, while the mean unsigned half-turn mass has
scale `N^11`.  Their ratio is about `2*N^(-4.98045)`.  This compares first
moments, not the mean of a ratio.  Exact second moments nevertheless turn the
associated sign-reweighting obstruction into a typical-instance statement.
Write the signed and absolute endpoint coefficients as

```text
A_t = sum_(z in {-1,0,1}^q : sum_i z_i*Y_i=t)
        (lambda/2)^|z| * product_(i:z_i!=0) S_i,
U_t = sum_(z in {-1,0,1}^q : sum_i z_i*Y_i=t)
        (lambda/2)^|z|.
```

Thus `A_t/U_t` is exactly the average sign under the absolute-weight
distribution on ternary paths ending at `t`.  In the matched observation
model above, put

```text
g_j = (1+j*lambda^2/2)^q-1.
```

For `N>=8` and `d` different from `0,H`, direct enumeration of the six
frequency-coincidence lines gives

```text
E[A_0^2]
  = 1+(4*g_3+2*g_2+(6*N-16)*g_1)/N^2,
E[A_H^2]
  = (4*g_3+2*g_2+(2*N-16)*g_1)/N^2.
```

The absolute coefficients satisfy

```text
Var(U_t) <= ((1+lambda^2)^q-1)/N,
t in {0,H}.
```

One way to see the variance bound is to group pairs of ternary words by
their activity supports.  Apart from the zero word, which is handled
separately, different supports expose a two-by-two unit minor and hence
independent uniform endpoint sums; the total squared absolute weight of
equal-support pairs is `(1+lambda^2)^q`.

At `lambda=1` and `q=12*n`, the second moments of `A_0,A_H` are
`Theta((5/2)^q/N^2)`, whereas
`E[U_t]=Theta(2^q/N)`.  Chebyshev for `U_t`, followed by second-moment Markov
for `A_t`, yields, for every fixed `epsilon>0`,

```text
Pr[max_(t in {0,H}) |A_t|/U_t
     >= N^(-4.06843+epsilon)]
  <= O(N^(-2*epsilon))+O(N^(-11)).
```

Therefore an ordinary iid absolute-weight sampler followed by the sample
mean of the signs needs exponentially many endpoint-conditioned samples for
constant relative precision: for `M` samples its variance is
`(1-(A_t/U_t)^2)/M`, so constant relative mean-square error requires
`M=Omega((U_t/A_t)^2)`.  This is a barrier for that sign-reweighting
estimator, not a generic FPRAS impossibility or a lower bound on a direct
arithmetic computation of `A_H/A_0`.  The large exact second moments also
make their relative second moments grow, so replacing the random signed
coefficients by their first moments has no second-moment concentration
justification.

A least-significant-bit Bayes recursion does not evade the coefficient
problem.  For `r in Z_(2^j)`, define the evidence of one congruence class by

```text
Z_(j,r) = (2^j/N)*sum_(k=r mod 2^j) L_D(k).
```

Fourier orthogonality gives exactly

```text
Z_(j,r)
  = 2^(-q)*sum_(ell=0)^(2^j-1)
      A_(ell*N/2^j)*exp(2*pi*i*r*ell/2^j).
```

The first step `j=1` already needs `A_H`; later steps require the other
high-valuation coefficients.  Thus this recursion does not begin with an
easy low-modulus instance.

A simple passive 2-adic recursion is exactly blind at the first step.  For a
nonzero secret, conditioning on one observed sign gives

```text
Pr[Y=y | S=s]
  = (1/N) * (1+s*lambda*cos(2*pi*d*y/N)).
```

Reduce `Y` modulo `B=2^m`.  The reduced distribution is exactly uniform
unless `N/B` divides `d`; when divisibility holds it is a cosine with frequency
`d/(N/B)` modulo `B`.  Consequently every proper power-of-two residue hash is
exactly blind for an odd secret.  Guessing the parity and folding
`Y=z+h*H` instead produces an integer-versus-half-integer frequency test, not
a smaller instance of the same ordinary problem.  This closes the direct
residue-Bayes recursion, while leaving more global recursions open.

There is nevertheless an exact correlation self-reduction.  From two
independent passive examples put

```text
Z = Y_1-Y_2,
T = S_1*S_2.
```

When `2*d != 0 mod N`, `Z` is uniform and

```text
E[T | Z=z,d] = (lambda^2/2)*cos(2*pi*d*z/N).
```

More generally, for `j` examples, fixed signs `epsilon_i in {+1,-1}`,
`Z=sum_i epsilon_i*Y_i`, and `T=product_i S_i`, expansion into `2^j`
characters leaves only the two characters `+epsilon` and `-epsilon`:

```text
E[T | Z=z,d] = lambda^j*2^(1-j)*cos(2*pi*d*z/N).
```

Thus correlations really do manufacture new passive samples, but with
attenuated visibility.  Bucket `Q` labels modulo `B=2^m` and disjointly pair
equal residues.  The exact expected number of pairs is

```text
E[P]
  = Q/2-(B/4)*[1-(1-2/B)^Q].
```

Discard the common bucket residue and divide the difference by `B`.  Each
pair is then a sample over `Z_(N/B)` with visibility `lambda^2/2`, provided
`2*d != 0` in the current input modulus.  At a degenerate current frequency
an extra character survives and must be handled separately.  Retaining a
constant fraction forces `B=O(Q)`, hence removes only `O(log Q)` modulus bits
per level.  Along nondegenerate levels, after `ell` pair levels the visibility
is

```text
lambda_ell = 2*(lambda/2)^(2^ell).
```

For constant initial visibility, polynomial sample complexity permits only
`ell=O(log log n)` levels, even optimistically removing just
`O(log n*log log n)=o(n)` bits.  This is a genuine positive recursive
construction and a matching no-reuse resource law, not a lower bound against
dense processing.

The same calculation diagnoses the closest Goldreich--Levin bucket test.
For a frequency set `K`, its pair kernel estimates
`sum_(k in K)|hat f(k)|^2`, but the kernel separating even from odd
frequencies is exactly supported on `Y'-Y=H`.  A quadratic test therefore
waits for a half-turn collision, with expected ordered-pair count
`Q*(Q-1)/N`.  Higher-
order prefix tests are the signed modular relations above.  The chosen-query
sparse-Fourier and hidden-number theorems cited below do not supply these
consume-once offsets; this access-model mismatch does not prove passive
decoding hard.

Directly Fourier transforming a polynomial-size classical sample table has
the same limitation.  Any normalized amplitude state supported on `M` known
labels obeys

```text
Pr[QFT output = k] <= M/N.
```

For uniformly random distinct passive labels and outcomes, and generic
`2*d != 0 mod N`, put
`|v_D>=q^(-1/2)*sum_i S_i|Y_i>`.  The expected probability at each of the two
frequencies `+d,-d` is

```text
[1+(q-1)*lambda^2*(N-2)/(4*(N-1))]/N
  = (1+(q-1)*lambda^2/4)/N + O(q/N^2).
```

Implicitly generating exponentially many combination labels helps only if
their path indices are erased, returning to the original fibre-erasure
primitive.  These calculations leave a narrow positive opening: compute the
weighted coefficient ratio through a new data-dependent arithmetic method,
or prove a polynomial-gap posterior walk.  Neither is supplied here.

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
- [The Multivariate Hidden Number Problem](https://eprint.iacr.org/2015/111)
- [Learning Noisy Characters](https://people.csail.mit.edu/akavia/AkaviaPhDThesis.pdf)
- [Efficient noise-tolerant learning from statistical queries](https://doi.org/10.1145/293347.293351)

There is a complete subexponential fallback for DCP: the Kuperberg/Regev
family of sieves runs in subexponential time, with variants trading time and
space.  These algorithms demonstrate that global phase collimation is
possible, but they do not give the polynomial-time repair sought here:

- [A Subexponential Time Algorithm for the Dihedral Hidden Subgroup Problem with Polynomial Space](https://arxiv.org/abs/quant-ph/0406151)
- [Another subexponential-time quantum algorithm for the dihedral hidden subgroup problem](https://arxiv.org/abs/1112.3333)

## Current verdict and next research question

The ideal `HalfTurnEraser` is mathematically coherent, and `K_Y` gives an exact
operator formula whose polar part is the desired swap.  The multiplexed
fibre polars also give the explicit robust `T_tilde` parity observable above,
uniformly on every coherent low-weight-error subspace for Gram-good public
labels.  Random subset-sum
fibres make the associated whitening matrix exponentially close to the
identity on the occupied fibre-uniform support, so unequal fibre sizes are not
the blocker.  The missing step is a
polynomial implementation of the synthesis/parity action itself.  The
investigation has not found one: PREP/QSVT, signed-projector sampling,
FFT/Schur decomposition, tensor-network contraction, 2-adic recursion,
hashing, lattice, statistical-query decoding, posterior filtering, and
local-relation routes all retain an exponential cost or exponentially small
advantage in the precise models analyzed.  Random syndrome isolation is a
real polynomial preprocessor, but it terminates at a density-one
code-constrained RMSS core only when its rank is tightly matched to the hidden
fault count; otherwise the core is mis-tuned--larger under a conservative cap
or smaller when faults exceed the cap, becoming underdense once that excess
consumes the slack--and the label-averaged target fraction remains about
`1/N`.  A concrete residue-pair syndrome uses the public
labels to remove `Theta(log n)` modulus bits in polynomial time, but its
no-reuse population loss prevents enough iterations to reach a small modulus.
The clean triangular checksum factorization improves retention: it removes
`log q-O(log log n)` bits with no rejected residue and keeps `q-m` free
coordinates.  Its quotient phase contains nonlinear carry selectors, however,
and an all-outcome fixed-garbage continuation beyond the contiguous raw
valuation chain is impossible; selective continuation is precisely a new
conditional fibre matching.  More generally, a reversible basis
preprocessor plus one Hadamard yields an RMSS partner finder whenever it has
inverse-polynomial mass advantage.  Exact full basis pairing is almost surely
absent on the clean full cube, even though a nonconstructive partial matching
covers nearly every path in expectation.
Allowing arbitrary overlapping binary syndromes does not make this reuse
free: the exact affine-code normal form replaces disjoint pairing by a system
of higher-order modular carry congruences.  The all-embedding SNF/counting
bound is stronger: for `q=12*n`, with high probability no affine coset of
dimension at least `91` is contained in one `f_Y mod H` fibre, even if that
coset is chosen after seeing `Y`.  The syndrome-isolated core remains possible
precisely
because its additional modular measurement leaves a non-affine intersection.
The best generic coherent scale identified is
`Theta(sqrt(N)) = 2^(n/2)`.  The operator-Schmidt theorem and the
statistical-query theorem make two of these route boundaries rigorous without turning
them into unrestricted circuit or sample-access lower bounds.

The signed-harmonic formula sharpens this boundary.  In the complete
translation-covariant orbit/reference model, even free fast powers of the
secret orbit and an
efficient reference-subspace reflection still require `Omega(sqrt(N))`
reflection queries for bounded-error parity.  Candidate verification has
true-candidate joint mass exactly `1/N`; once its conditional candidate is
useful, its total herald is `Theta(1/N)` on the balanced event.  The direct
normalized likelihood filter has at most `O(1/N)` heralding once its posterior
has constant useful mass.  Its uniform importance-sampling relative variance
is exactly `N*sum_k pi(k)^2-1`, so it becomes linear in `N` when the posterior
is concentrated.  For a nondegenerate secret, a Hellinger calculation proves
this concentration rather than assuming it: at `q=12*n` and high visibility,
all likelihood outside `{d,-d}` is `N^(-Omega(1))` relative to the planted likelihood with high
probability, yet uniform sampling in the correct parity class has
`N/4-o(N)` relative variance.  At the same parameters, a stronger
typical-instance calculation in
the matched nondegenerate passive model shows that the average-sign magnitude
seen by ordinary absolute-weight reweighting is at most
`N^(-4.06843+epsilon)` with high probability for every fixed `epsilon>0`;
this does not lower-bound a direct arithmetic coefficient algorithm.  Within
the clean orbit-projector dictionary, the raw signed-frame coefficients are
unique and constant-error parity approximations still have `Omega(N)` LCU
normalization.  Direct purified-density sign transformation costs
`Omega(N)`, while the factorized frame polar improves this standard access
route only to `Theta(sqrt(N))`.  Low-output fermionic-Gaussian circuits form
another exact but scoped barrier: below the stated linear output thresholds,
their full classical output distribution is parity-independent on typical
labels.  Linear output is enough to escape: a disjoint-pair matchgate produces
`6*n` visibility-one passive observations whose maximum-likelihood parity
error is exponentially small.  Evaluating that decision efficiently still
reduces exactly to the weighted coefficients `A_0,A_H`; Pfaffian
simulatability only evaluates one proposed candidate and does not perform the
cyclic coefficient extraction.  Pair products of passive samples do give an exact smaller-
modulus recursion.  Along nondegenerate levels, including the odd-secret
case before the final modulus, the visibility follows
`lambda_ell=2*(lambda/2)^(2^ell)`; polynomial no-reuse recursion removes only
`o(n)` bits.  These
theorems leave open only circuits that exploit the internal Boolean modular
arithmetic beyond the orbit algebra or compute the weighted ternary
coefficient ratio by a new method.

This is not a no-go theorem.  A distribution-specific collective circuit
could conceivably decode only the parity without exposing a reusable fibre
eraser.  But such a circuit is not a small completion of Lemma 3: usable at
successive dyadic moduli with fresh states, a polynomial one-bit decoder would
give a polynomial DCP algorithm by bit recursion.  It would therefore be a new
algorithmic breakthrough in exactly the problem the paper claims to solve.

The narrowest remaining positive question can now be stated through three
distinct sufficient interfaces:

> Can one either (a) use the product-state representation of `K_Y` to implement
> its sign/polar action on the random fibre-uniform input ensemble without the
> natural `sqrt(N)` normalization, or (b) build a bounded, verifiable,
> inverse-polynomial-success random-target RMSS find-one algorithm on exactly
> `n` random correction coordinates and make the large-label two-pool
> construction respect the occupied fault subcube, or (c) decode the
> syndrome-isolated density-one core or the weighted coefficient ratio
> `A_H/A_0` without enumerating `N` residues?

A positive answer to any version would be a new DCP/subset-sum algorithmic
ingredient.  No such polynomial construction is supplied by the paper or
found in this investigation.  The random-singleton oracle model now has a
rigorous `Omega(sqrt(D))` constant-advantage barrier, but a negative answer for
the explicit arithmetic problem would require a stronger circuit-model or
average-case lower bound that is not presently available.

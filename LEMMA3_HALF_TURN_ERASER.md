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
- on a clean cube, coarse subset-sum fibres modulo `R=poly(n)` are not an unresolved indexing
  problem: residue dynamic programming gives exact reversible rank/unrank in
  `O(poly(q)*R)` circuit size.  An ordinary-integer checksum gives an even
  cleaner linear quotient on a small-knapsack support.  Their displayed
  DP/trellis implementations scale exponentially in the total number of
  peeled modulus bits, however, and therefore expose only `O(log n)` bits at
  polynomial cost;
- controlled phase-calibrated fixed-point amplification approximately
  prepares or erases a specified
  balanced fibre modulo `R` in `O(sqrt(R)*log(1/epsilon))` arithmetic-oracle
  calls.  Combining a coarse DP chart modulo `B` with residual amplification
  still costs `O*(sqrt(N*B))` ordinary gates; only an ideal preloaded QRAM
  changes this to a nonstandard `O*(N^(1/3))` preprocessing/online
  time--memory tradeoff, which remains exponential;
- the ordinary-checksum branch is a polynomial-bond MPS for each fixed
  secret, but this does not make its parity measurement a polynomial-bond
  MPO.  After averaging even against odd secrets, the residual half-turn
  kernel has `M=N/T` asymptotically flat operator-Schmidt sectors across a
  balanced cut.  Constant-relative-Frobenius MPO approximation therefore
  needs `Omega(M)` bond dimension on typical high-density branches;
- after the triangular checksum chart, a final-half-turn matching whose logical moves
  have Hamming radius `w` covers at most `D_w/M` expected mass, where
  `D_w=sum_(j=1)^w choose(K,j)` and `M` is the residual modulus.  In particular,
  coordinate-greedy and `O(log n)`-local matchings remain exponentially sparse;
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
  At paper-scale visibility below one, the complete log likelihood nevertheless
  has a uniformly accurate `poly(n)`-sparse trigonometric representation.
  Thus passive decoding reduces constructively to a sparse high-frequency
  optimizer or partition algorithm.  The exact grouped triangle envelope is
  identical on `H/poly(n)` prefixes with high probability, while one exact
  high-bit elimination can turn one Fourier mode into a dense spectrum.
  These analyzed radix routes do not certify polynomial pruning.  Every
  scalar polynomial in `G_J` below the displayed `Theta(n/log n)`
  threshold has exactly zero half-turn Fourier coefficient with high
  probability.  A stronger natural group-moment/SOS relaxation also has a
  rank-one pseudo-solution that coherently aligns each sample likelihood
  factor in both parity classes until the moment matrix is already
  exponential; the same point blocks bounded-word SOHS certificates below
  the displayed gap.  A sparse
  circulant/QSVT filter can mark the two high-correlation modes efficiently,
  but obtaining constant conditional mass there has postselection probability
  only `O(q/N)` for the natural sparse-data state.  At the same parameters,
  in the matched passive model with a nondegenerate secret, ordinary
  absolute-weight sign reweighting has average-sign magnitude at most
  `N^(-4.06843+epsilon)` with high probability for every fixed
  `epsilon>0`;
- the same circulant gives an exact parity-constrained SDP with sparse,
  block-encodable data, but its Fourier form is still optimization over
  `N/2` candidate atoms; PSD separation is exactly the parity-restricted
  sparse-score maximization, and any positivity-reflecting group-algebra
  representation has dimension at least `N/2`.  In fact the normalized
  quotient state space is an `(N/2-1)`-simplex whose universal exact PSD lift
  also needs size `N/2`; at the displayed hierarchy depth, truncated
  character sketches are already exponential, and the sparse circulant has
  exponential stable rank.
  Standard sparse-input
  quantum SDP solvers retain
  square-root dependence on that dimension; polylogarithmic-dimension and
  Gibbs/implicit variants require stronger low-rank input, preparation, or
  oracle assumptions not supplied here.  A separate repeated-squaring
  construction does give an exact
  polynomial-size nonconvex unit-modulus QCQP; finding a planted polynomial-
  time solver for that compact arithmetic lift remains a concrete positive
  opening.  Its strengthened first-order Shor relaxation is nevertheless
  parity-blind and has value `Theta(q*ln ln n)` above the true `O(q)` range.
  Order two is polynomial size and can propagate a saturated root to a
  frontier of at most four factors.  More importantly, its Hankel identities
  exactly reassociate compatible overlapping product-tree gates and lift
  aligned harmonic relations such as `w_(i,2m)=w_(i,m)^2`; in that aligned-
  tree formulation, the first-order independent-harmonic witness therefore
  cannot extend.  A finite Laurent phase-closure
  test gives an explicit conditional order-two pseudo-moment certificate.
  On a typical no-short-relation event, every public-label-adaptive single
  cycle has exponentially small planted correlation, and any nonlinear
  syndrome whose odd-support span has rank below `(1/10-epsilon)*n` remains
  exponentially parity-blind.  Saturated `tau_(i,m)=S_i^m` phase-certificate
  feasibility therefore has no high-probability planted gap, although the
  unsaturated SDP value gap remains open.  For those coherent pins, every
  expanded closure proof below the displayed `Theta(n/log n)` net root-pin-
  width threshold is phase-consistent for both parities with high probability
  in every standard phase-one multiplication-tree layout.  Separately, with
  objective-coefficient phases as the reference pins, an exposed sign-
  conflicting loop forces the exact one-sided separable-ceiling deficit
  `D>=2/R_C`.  Neither statement controls a long compressed proof or the
  difference of the two SDP optima.
  A randomized sixteen-bucket reassociation has an exponentially likely
  degree-four cut-dissociation event, but an exact balanced-depth-four
  counterexample proves that this event alone does not control repeated
  Hankel interpolation.  A random condition controlling every completed-
  closure conflict remains open.  An exact
  expander identity buffer does prove lift non-invariance for a redundant
  quadratic formulation.  Neither result proves parity blindness, or a
  planted gap, for the fixed aligned arithmetic lift.  With
  high probability, the natural local factor graph has `Omega(n)` treewidth,
  exact coefficient BP develops
  exponentially many residues, and uniform bitwise BP has no inverse-
  polynomial first-round seed; these are structured-relaxation/message-
  passing barriers only;
- the top-mode projector has the perfect signed trace ratio `(-1)^d`, but both
  normalized traces have scale `2/N`.  Polynomial spectral traces are exactly
  signed half-turn relation sums; constant-error QSVT marking does not estimate
  their sign, and trace sampling, determinant, resolvent, and the direct
  evolve-then-measure construction retain either `1/N` precision or top-space
  postselection;
- passive maximum likelihood is also an exact rank-one cyclic nearest-codeword
  problem.  Its Euclidean two-coset CVP surrogate has a certified typical
  gap: at visibility one, `q=12*n`, and secret phase order
  `M_d=2^(Omega(n))`, any algorithm
  achieving approximation factor below `1.3448` on these instances would
  recover parity with
  exponentially small error.  LLL/Babai, standard BKZ, BDD, embedding, and
  phase-unwrapping routes checked here do not supply that constant factor in
  polynomial time; this is a conditional positive interface, not a hardness
  theorem;
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
partial isometry, or implementing the controlled full-modulus uniform fibre
sampler, is the computational problem.

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
   inverse-square-root frame operation.  A clean full-modulus uniform fibre
   sampler would solve it, but constructing that sampler is exactly the
   missing primitive.
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
seed/rank from the physical solution, which is again the missing
half-turn-resolving large-fibre sampling or rank/unrank operation.  This is
why each active correction pool in
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
   value is statistically close to uniform.  They do not by themselves invert
   the map or clean the preimage index.  For a polynomial modulus `R`, the
   residue-DP chart below does clean the coarse fibre in `O(poly(q)*R)` size;
   its cost becomes exponential as `R` approaches the half-turn scale.
   Sequentially choosing Boolean variables leaves a final critical-density
   core; hash isolation makes a fibre small but still requires finding and
   coherently cleaning its element.
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
efficient circuit.  If one insists on a short explicit list, a standard table
still enumerates its paths.  Exact indexing of a **large** coarse fibre is
easier than that sentence suggests, however, and deserves to be separated
from full-modulus fibre erasure.

### Small-modulus fibres have exact dynamic-programming charts

Fix any `R=2^h` dividing `N` and a measured residue `t`.  Define suffix counts

```text
C_i(s) = number of x_i,...,x_(k-1) such that
         sum_(j>=i) x_j*Y_j = s mod R.
```

They obey

```text
C_k(0)=1,
C_k(s)=0 for s!=0,
C_i(s)=C_(i+1)(s)+C_(i+1)(s-Y_i).
```

The table has `k*R` entries of at most `k+1` bits.  For a path in the fibre,
lexicographic rank scans the coordinates from left to right.  When `x_i=1`,
it adds the number `C_(i+1)(s)` of preceding completions with `x_i=0`, then
updates the remaining residue to `s-Y_i`.  Unranking performs the inverse
comparison.  Reversible arithmetic and coherent table lookup therefore give
an exact clean rank/unrank circuit of size

```text
O(poly(k)*R)
```

without QRAM; invalid ranks retain a validity flag.  The variable fibre size
is harmless: valid ranks occupy the interval `[0,eta_t)`, padded by
zero-amplitude computational states.  Operationally, compute the rank, unrank
it into scratch, XOR that reconstructed path into the original path register,
and reverse the scratch computation; every valid input path is thereby
cleared without touching its phase.  On the measured phase state this gives

```text
eta_t^(-1/2) * sum_(j<eta_t)
  omega_(N/R)^(d*q_t(j)) |j>,

x_t(j) = unrank(t,j),
q_t(j) = [f_Y(x_t(j))-t]/R mod N/R.
```

Both `x_t(j)` and `q_t(j)` are computable coherently.  Thus, for
`R=poly(n)`, canonical indexing of the exponentially large **coarse** fibre
is polynomial.  What remains hard is that `q_t(j)` is generally an
unstructured function of the rank, and the interval has exponentially many
valid indices.  This chart is not a short explicit phase-vector list and does
not align the two full half-turn fibres.

There is a related one-shot variant that keeps the quotient linear.  Write

```text
Y_i = A_i+T*B_i,
0<=A_i<T,             T=2^L,
C_T(x)=sum_i A_i*x_i as an ordinary integer.
```

Measure the ordinary checksum `C=C_T(x)`, rather than only its residue.  On a
clean cube put `eta_C=|{x:C_T(x)=C}|`.  The normalized branch is, up to the
global phase `omega_N^(d*C)`,

```text
eta_C^(-1/2) * sum_(C_T(x)=C)
  omega_(N/T)^(d*sum_i B_i*x_i) |x>.
```

The remaining multiplier is a fresh linear subset sum over `Z_(N/T)`;
conditioning on all `A_i` and the Born outcome leaves the `B_i` iid uniform.
The support, however, is a small-integer knapsack fibre rather than a cube.
Ordinary-sum counts

```text
D_i(s)=D_(i+1)(s)+D_(i+1)(s-A_i),
0<=s<=sum_i A_i,
```

give exact reversible rank/unrank in `poly(k,T)` size.  If
`R_C=sum_i A_i+1<=k*T`, and `H_Shannon` denotes entropy in bits, then

```text
E_(C~Born)[log_2 eta_C] = k-H_Shannon(C) >= k-log_2 R_C,
Pr[eta_C < delta*2^k/R_C] <= delta.
```

So a polynomial `T` removes `O(log n)` phase bits while losing only
`O(log n)` branch entropy with high Born probability.  The branch also has an
exact knapsack-MPS representation of bond dimension at most `R_C`:

```text
sum_(C_T(x)=C) omega_(N/T)^(d*B dot x)|x>
 = (1/R_C) * sum_(u=0)^(R_C-1) zeta^(-u*C)
     tensor_i (|0>+zeta^(u*A_i)*omega_(N/T)^(d*B_i)|1>),
```

where `zeta` is an `R_C`-th root.  This is a coherent sum of product vectors,
not a classical mixture or a single product state.

### A polynomial-bond checksum state still has an exponential-bond parity kernel

The preceding MPS is small for each fixed secret, but the even-versus-odd
mixture restores the residual modular constraint.  Put `M=N/T`, assume `M`
is even, and write

```text
S_C = {x : A dot x=C},
eta = |S_C|,
h(x) = B dot x mod M,
|psi_d> = eta^(-1/2) * sum_(x in S_C) omega_M^(d*h(x)) |x>.
```

The original secret average reduces to the uniform even or odd average modulo
`M`.  If

```text
|u_s> = sum_(x in S_C : h(x)=s) |x>,
```

then the exact parity-difference operator is

```text
K_C = rho_0-rho_1
    = (2/eta) * sum_(s<M/2)
        (|u_s><u_(s+M/2)| + |u_(s+M/2)><u_s|).
```

Thus its sign swaps the normalized residual half-turn fibres, and

```text
||K_C||_1 = (4/eta) * sum_(s<M/2)
  sqrt(eta_s*eta_(s+M/2)).
```

This is exactly the original missing operation inside the checksum branch.
The small bond of each `|psi_d>` has not removed it.

There is also an exact cut decomposition.  Split the coordinates into left
and right parts.  For left ordinary sums `p,q` and residual difference `r`,
define

```text
L_(p,q,r) = sum_(u,v : A_L dot u=p, A_L dot v=q,
                        B_L dot (u-v)=r) |u><v|,
```

and define `R_(p,q,r)` analogously.  Then

```text
K_C = (2/eta) * sum_(p,q,r)
  L_(p,q,r) tensor R_(C-p,C-q,M/2-r).
```

Different triples have disjoint matrix-entry supports on both sides, so after
normalizing nonzero factors this is already an operator-Schmidt
decomposition.  If `ell_(p,q,r)=||L_(p,q,r)||_F^2` and `rr` is the analogous
right count, its exact Schmidt coefficients are

```text
sigma_(p,q,r) = (2/eta) *
  sqrt(ell_(p,q,r)*rr_(C-p,C-q,M/2-r)).
```

The random high quotients make these coefficients flat in `r`.  A useful
estimate behind that statement is the following.  For fixed Boolean sets
`X,Y`, iid-uniform coefficients in `Z_M`, and

```text
Z_r = |{(x,y) in X cross Y : B dot (x-y)=r}|,
```

character Parseval and a fourth-moment count give

```text
E_B sum_r |Z_r-|X|*|Y|/M|^2
  <= |X|*|Y|*min(|X|,|Y|).
```

Hence, when both sets have size at least `S`, simultaneous relative
`epsilon`-flatness fails with probability at most

```text
M^2/(epsilon^2*S).
```

For a balanced split of `q=12*n`, `T=poly(n)`, and a Born-typical ordinary
checksum, all but negligible branch weight lies on half-checksum slices of
size `2^(6*n)/poly(n)`.  The last bound can therefore be unioned over the
`poly(n)` bulk low-checksum pairs while `M^2<=2^(2*n)`.  Applying the same
threshold estimate and Markov to the exceptional slice pairs shows that their
total squared-Schmidt mass is `o(1/M)`.  On the resulting event,

```text
||K_C||_F^2 = (4/M)*(1+o(1)),

inf_(operator-Schmidt-rank(X)<=D)
  ||K_C-X||_F^2/||K_C||_F^2
    >= 1-D/M-o(1).
```

Thus constant-relative-Frobenius approximation needs
`D=Omega(M)=2^(n-O(log n))`; the displayed squared-residual statement is used
for `D<=M`.  This is a tensor-network obstruction, not a circuit lower bound:
the residue needs only `log M` qubits, and a different arithmetic circuit
could in principle manipulate it without approximating `K_C` in Frobenius
norm.

### Coarse fibre synthesis gives a square-root and time--memory tradeoff

Dynamic programming is not the fastest way to prepare one specified coarse
fibre.  Starting from the uniform cube, compute `f_Y(x) mod R`, mark a target
`t`, and use fixed-point amplitude amplification.  On the simultaneous
fibre-flatness event the marked fraction is `(1+o(1))/R`, so controlled
preparation, and its controlled inverse, use

```text
O(sqrt(R)*log(1/epsilon))
```

arithmetic-oracle calls.  Applying the same schedule to `t` and `t+R/2`
aligns both branches with common uniform-cube garbage up to `epsilon` for a
standalone modulus-`R` half-turn problem.  In the original modulus-`N`
problem, the two full half-turn fibres have the same coarse residue modulo
`B<N` and differ by `M/2` in the quotient, as in the hybrid below.  At `R=N`
the direct construction recovers the existing `Theta(sqrt(N))` route rather
than a polynomial decoder.  A heralded unknown-count sampler can be exact
conditionally, but it is not a fixed reusable unitary with a clean inverse.
The fixed-point response can be chosen real and nonnegative on the marked
subspace, with the same phase schedule on both controls, so its inverse does
not insert an uncontrolled relative branch phase.

There is a more explicit hybrid.  Rank a common low-residue fibre modulo
`B`, put `M=N/B`, and mark inside its rank interval the indices whose full
quotient equals `u` or `u+M/2`.  Each set has fraction about `1/M`.  Inverting
the corresponding fixed-point sampler maps both full fibres to the same
uniform rank interval.  Without QRAM, however, every residual membership
query in this hardwired-table realization uses the known coherent unrank and
rerank circuit of size `O(poly(q)*B)`.  Its ordinary gate count is therefore

```text
O*(B*sqrt(N/B)) = O*(sqrt(N*B)),
```

Here `O*` suppresses factors polynomial in `q` and logarithmic in the target
precision.  The expression is minimized at `B=1`.  With an ideal preloaded
QRAM of `O*(B)` words, online lookup can be polylogarithmic and the online cost
is `O*(sqrt(N/B))`.  Charging both preprocessing and online time gives the
nonstandard optimum

```text
B=N^(1/3),       preprocessing + online time = O*(N^(1/3)).
```

This is a real exponential time--memory tradeoff, not a polynomial circuit.
In a clean membership-oracle model without instance-dependent preprocessing
or advice, the square-root dependence is tight even when all fibre sizes are
exactly known: encode an unknown permutation by `f_pi(a,b)=pi(a)`.  A clean
fibre synthesizer reveals `pi^(-1)(t)`, so it would invert a permutation and
needs `Omega(sqrt(R))` oracle queries.  The argument does not lower-bound
circuits that exploit the explicit modular arithmetic of the public labels,
nor a bare two-outcome test with unspecified garbage.

Neither chart iterates to a polynomial full decoder.  Refining the modular
chart to total modulus `2^L` costs `O(poly(k)*2^L)` by the same residue DP.
Successive ordinary digit sums accumulate a product trellis, while the
one-shot checksum at `T=2^L` already costs `poly(k)*2^L` and dominates that
plan.  Hence this explicit route is polynomial only for `L=O(log n)`.  At
`R=N`, exact rank/unrank has size `O(poly(k)*N)`.  Ranking the two residues
separately and matching equal ranks then implements an explicit clean
half-turn eraser with accepted fraction

```text
2*min(eta_t,eta_(t+H))/(eta_t+eta_(t+H)).
```

This is `1-o(1)` on the simultaneous random-fibre flatness event.  Preparing a controlled
uniform fibre from zero additionally uses uniform-interval rotations and is
accurate to `epsilon` with polynomial overhead in `log(1/epsilon)`.  This is
a valid exponential upper bound, but it is slower than the existing
`Theta(sqrt(N))` constant-accuracy frame/postselection route.  The scaling is
a property of this DP/trellis realization, not a lower bound against a new
arithmetic circuit.

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

### Local matching after the checksum is still exponentially sparse

The nonlinear quotient does not make a coordinate-greedy final matching
effective.  Let `B=2^m` with `m<n`, put `M=N/B`, `K=q-m`, and condition on low residues for
which the triangular chart exists and on its measured residue `r`.  Write
`Y_i=a_i+B*b_i`.  Because the pivot choice and `r` use only the `a_i`, the
high quotients `b_i` remain iid uniform in `Z_M`.  For two distinct logical
paths `z,z'`,

```text
Q_r(z')-Q_r(z)
 = sum_(i notin P) (z'_i-z_i)*b_i
   +sum_(p in P) [u_p(z')-u_p(z)]*b_p
   +kappa_r(z')-kappa_r(z) mod M.
```

Some nonpivot coordinate differs, and its coefficient is `+1` or `-1`.
Conditioning on every other high quotient therefore gives the exact identity

```text
Pr_b[Q_r(z')-Q_r(z)=M/2] = 1/M.
```

Put

```text
D_w = sum_(j=1)^w choose(K,j).
```

Let `Gamma_w` be the largest vertex fraction covered by any matching whose
pairs have logical Hamming distance at most `w` and quotient difference
`M/2`.  The matching may be selected after seeing all public high labels.
Every covered vertex must have at least one of its `D_w` possible local
partners, so

```text
E_b[Gamma_w | a,r] <= D_w/M,
Pr_b[Gamma_w>=epsilon | a,r] <= D_w/(epsilon*M).
```

For `w=1`, the expected number of valid undirected coordinate edges is
exactly `K*2^(K-1)/M`; a greedy coordinate sweep therefore covers at most
`K/M` expected mass.

This statement survives the final checksum's Born-size bias.  If `S_t` is
the selected fibre of `Q_r mod M/2` and `Gamma_(w,t)` is its maximum local
matching coverage, every valid half-turn edge lies inside one `S_t`, hence

```text
sum_t (|S_t|/2^K)*Gamma_(w,t) <= Gamma_w.
```

Thus the same expectation and Markov bounds hold when `t` is the actually
measured Born outcome.  For `K=poly(n)`, `B=poly(n)`, and `w=O(log n)`,

```text
D_w/M = 2^(-n+O(log^2 n)).
```

This rules out even label-adaptive bounded-displacement involutions, not only
a fixed catalogue.  It also covers a conjugated bit flip whose reversible
light cone changes at most `w` logical input coordinates.  It does not cover
nonlocal arithmetic pairers or polynomial-depth circuits with block-wide
light cones; those return to the RMSS/fibre-alignment opening.

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

### A sparse log-likelihood reduction, but no sparse optimizer

At visibility strictly below one, the likelihood itself has a useful sparse
representation.  Define

```text
rho = lambda/(1+sqrt(1-lambda^2)).
```

For `s` in `{+1,-1}` one has the exact uniformly convergent series

```text
ln(1+s*lambda*cos(theta))
 = -ln(1+rho^2)
   +2*sum_(j>=1) (-1)^(j+1)*s^j*rho^j*cos(j*theta)/j.
```

Let `G_J(k)` be the sum of these series over the `q` observations, truncated
after harmonic `J`.  Then

```text
||G_J-ln W_D||_infinity
 <= 2*q*rho^(J+1)/[(J+1)*(1-rho)].
```

For the paper-scale visibility `1-lambda=Theta(1/log n)`, one has
`1-rho=Theta(1/sqrt(log n))`.  Taking `J=c_trunc*sqrt(log n)` with a sufficiently
large constant `c_trunc` makes the error an arbitrarily small constant times `n`, and
`J=c_1*log^(3/2) n` for a sufficiently large constant `c_1` makes it `O(1)`.
The truncated score has only
`q*J=poly(n)` public frequencies `j*Y_i`.

Combined with the Hellinger event above, this is a genuine constructive
reduction.  There the planted log likelihood exceeds every candidate outside
`{d,-d}` by `2*alpha*ln N`.  Consequently, an additive-`o(n)` global
optimizer for the sparse trigonometric polynomial `G_J` would recover
`{d,-d}`, and a sufficiently accurate partition algorithm for `exp(G_J)`
would decide parity.  No such polynomial optimizer or partition-function
evaluator was found.  At `lambda=1`, likelihood factors can vanish and no
uniform finite log truncation exists, so this uniformly controlled reduction
uses the noisy high-visibility regime rather than the clean endpoint.

The power-of-two domain does not itself provide a smaller exact quotient.
Fix a parity and write its `H=N/2` candidates as `k=k_0+2*x`, with
`x in Z_H`.  Let `T=2*q*J` count all signed harmonic occurrences.  Except
with probability

```text
2^(-q)+J*T^2/H,
```

all signed occurrences are nonzero and pairwise distinct modulo `H`, and at
least one first-harmonic `Y_i` is odd.  Its coefficient cannot cancel.
Consequently the Fourier support has gcd one with `H`, so the score has full
period `H`.  HNF/SNF normalization therefore leaves one large cyclic
`2`-primary factor rather than splitting the search into smaller CRT
components.  This only blocks exact convolution-preserving quotients; it
does not exclude a nonhomomorphic or instance-specific compression.

The elementary radix triangle envelope can be analyzed exactly.  Remove the
constant from the fixed-parity score and write

```text
g(x) = sum_(s in Z_H) c_s*exp(2*pi*i*s*x/H).
```

For a prefix `x=b+2^t*y`, put `M=H/2^t`.  The residual coefficients are

```text
C_(b,r) = sum_(s=r mod M) c_s*exp(2*pi*i*b*s/H),
g_b(y) = sum_(r in Z_M) C_(b,r)*exp(2*pi*i*r*y/M).
```

If the `T` signed frequencies are distinct and nonzero modulo `M`, their
grouped triangle envelope is independent of the prefix:

```text
U_b = sum_r |C_(b,r)|
    = sum_s |c_s|
    = U_J,
U_J = 2*q*sum_(m<=J) rho^m/m.
```

For any two signed frequencies, a nontrivial collision modulo `M` has
probability at most `O(J/M)`.  Choose a dyadic
`M_0 in [n^6,2*n^6]`.  Then

```text
Pr[an alias or zero frequency modulo M_0]
 = O(J*T^2/M_0) = o(1).
```

Injectivity modulo `M_0` implies injectivity at every larger dyadic residual
modulus.  Thus, with high probability, all `H/M_0` prefixes reached before
the final `O(log n)` bits have exactly the same triangle certificate `U_J`.
At the paper-scale visibility, `U_J=Theta(q*ln ln n)`, whereas the maximum
truncated score is `O(q)`.  A branch-and-bound method using this certificate
therefore cannot prune any of those exponentially many prefixes.  The
factorwise envelope analyzed earlier also retains linear slack.  These are
lower bounds only for the two displayed envelopes, not for a stronger joint
prefix certificate.

Exact high-bit elimination fails to preserve Fourier sparsity.  Split `g`
into its even- and odd-frequency parts `E` and `O`.  Pairing `x` with
`x+H/2` gives

```text
max{g(x),g(x+H/2)} = E(x)+|O(x)|.
```

Eliminating the absolute value explicitly introduces `O(x)^2`.  With high
probability `Theta(q)` first-harmonic frequency residues are odd.  Outside a signed
four-term collision event of probability `O(q^4/H)`, their pair sums and
differences give `Omega(q^2)` distinct modes in `O^2`.

There is an exact one-mode version of the same nonclosure.  For dyadic
`M>=2`, eliminating one bit from `cos(pi*u/M)` on `Z_(2*M)` produces
`f(u)=|cos(pi*u/M)|` on `Z_M`.  With the unnormalized DFT convention,

```text
f_hat(r)
 = (-1)^r*sin(pi/M)
   /[cos(2*pi*r/M)-cos(pi/M)],    r in Z_M,
```

and every one of these `M` coefficients is nonzero.  Thus explicit exact
elimination can become dense in one step.  An arithmetic circuit may keep
`|O|` implicit, but the next radix message is then no longer a sparse
trigonometric polynomial.  This is not a lower bound on a different implicit
optimizer.

There is a sharper parity-only limitation for low-order processing.  Let

```text
F_J = {+/- j*Y_i : 1<=i<=q, 1<=j<=J}.
```

If a scalar polynomial of degree at most `pdeg` in `G_J` has a nonzero
half-turn Fourier coefficient, some word of length at most `pdeg` in `F_J` must
sum to `H`.  For a fixed nonzero coefficient vector the probability of this
event is at most `J*pdeg/N`, and a union bound gives

```text
Pr[H occurs in the Fourier support]
 <= (pdeg+1)*J*pdeg*(2*q*J)^pdeg/N.
```

Hence, with high probability, every

```text
pdeg <= (1-epsilon)*log_(2*q*J)(N) = Omega(n/log n)
```

degree scalar polynomial in `G_J` has **exactly zero** half-turn coefficient,
even if its scalar coefficients are chosen after seeing the public labels.
Since the parity partition difference is the `H` coefficient of
`exp(G_J)`, low-order Taylor, Chebyshev, low-total-order Bessel, and cluster
truncations return equal parity sums until they implicitly aggregate dense
modular relations.
This is a scoped algebraic barrier.  It does not exclude branching,
nonpolynomial arithmetic, or a new implicit optimizer for the sparse
high-frequency score.

The natural parity-constrained group-moment hierarchy has a stronger
integrality gap.  Let

```text
Word_L = {sum_(nu<=ell) sign_nu*m_nu*e_(i_nu) :
          ell<=L, sign_nu in {+1,-1}, 1<=m_nu<=J}.
```

Consider the event that no nonzero `a` in `Word_(4*L)` satisfies

```text
a dot Y = 0 or H mod N.
```

For parity sign `p` in `{+1,-1}`, put `phi_i=0` when `S_i=+1` and
`phi_i=pi` when `S_i=-1`.  On this event the truncated moments

```text
y_(a dot Y+h*H) = exp(i*a dot phi)*p^h,
a in Word_(2*L), h in {0,1},
```

are well defined.  The order-`L` group-moment matrix indexed by `Word_L` is
the rank-one matrix `v*v^dagger`, it satisfies `y_H=p`, and it obeys all
visible equal-frequency, conjugacy, and unit-character identities.  Thus both
parity-constrained relaxations have a feasible pseudo-moment point that
coherently aligns every sample likelihood factor.  Its value per factor is

```text
-ln(1+rho^2)
 +2*sum_(m<=J) (-1)^(m+1)*rho^m/m
 = ln(1+lambda) + truncation remainder.
```

For a fixed nonzero coefficient vector, the probability of either forbidden
residue is at most `8*L*J/N`.  A multiset count therefore gives

```text
Pr[pseudo-moment construction fails]
 <= (8*L*J/N) * choose(2*q*J+4*L,4*L).
```

If `J=(ln n)^kappa` and `L=c*n/ln ln n`, the logarithmic exponent is

```text
(4*c*kappa-ln 2)*n+o(n).
```

Hence the pseudo-solution exists with high probability for
`c<ln(2)/(4*kappa)`.  At the `kappa=3/2` truncation used above, any fixed
`c<ln(2)/6` works, while the explicit moment index set already has size at
least

```text
choose(q,L)*(2*J)^L = exp(kappa*c*n+o(n)).
```

In the high-visibility limit, for a nondegenerate secret whose phase order
tends to infinity, score concentration and the Hellinger event make the true
planted maximum `q*(1-ln 2)+o(q)`.  The pseudo-value is
`q*ln 2+o(q)`, leaving the natural-log gap

```text
(2*ln 2-1)*q+o(q).
```

The same pseudo-point also blocks a bounded-word sum-of-Hermitian-squares
certificate.  Suppose an identity

```text
t-G_J = sum_j h_j^dagger*h_j
```

uses factors supported inside the admissible `Word_L` range, with the
pseudo-functional defined on all displayed products.  Applying the positive
pseudo-functional forces

```text
t >= B_J,
B_J = q*[-ln(1+rho^2)
          +2*sum_(m<=J) (-1)^(m+1)*rho^m/m].
```

The alternating-series remainder gives

```text
B_J = q*ln(1+lambda)+R_J,
|R_J| <= 2*q*rho^(J+1)/(J+1).
```

Thus at high visibility this bounded-word certificate cannot beat
`q*ln 2+o(q)`, while the typical true maximum is
`q*(1-ln 2)+o(q)`.  This is a lower bound witnessed by one pseudo-point, not
an equality for the hierarchy optimum.  In particular, the much larger
absolute-coefficient value `U_J` belongs to the private-occurrence
first-order lift and, in the present `J>=2`, `rho>0` regime, is not a
feasible value of this natural word quotient.

This rules out only the explicit natural word/frequency-sum moment hierarchy
before it reaches exponential size.  It does not exclude an implicit
compression, an SDP supplied with long arithmetic relations, or a different
lift.

For the displayed coherent rank-one test family, the missing separator is
exactly a bounded modular-relation test.  Give sample `i` a unit phase
`eta_i`, set `eta_(i,m)=eta_i^m`, and extend this assignment multiplicatively
to words.  The rank-one matrix

```text
M_(u,v) = eta(u)*conj(eta(v))
```

descends to the parity-p Hankel quotient if and only if every
`c in Word_(4*L)` satisfying `c dot Y=h*H mod N` also satisfies
`eta(c)=p^h`.  Necessity is a Hankel/parity identity.  Conversely, any two
representatives of one moment entry differ by such a word, so the condition
makes every entry well defined.  Any violating relation can be split among
four `Word_L` indices and is therefore exposed by the moment matrix.

This also gives a one-sided randomized reduction.  Choose a prime
`P>8*L*J` and independent phases `eta_i=exp(2*pi*i*r_i/P)`.  A fixed nonzero
aggregate vector `c` has every coefficient smaller than `P` in magnitude, so
it remains nonzero modulo `P` and is phase-consistent with probability at most
`1/P`.
Consequently a membership or separation routine for this succinct rank-one
family detects whether a bounded `0/H` modular relation exists, with the
usual one-sided repetition.  This does not prove that every possible
instance-specific SDP separator has the same form; it identifies the exact
task for the natural word-Hankel pseudo-point.

There is an exact sparse SDP formulation, but generic implicit SDP machinery
does not by itself perform the missing optimization.  Remove the constant term
from `G_J`, let `Shift` be cyclic translation on `Z_N`, and define

```text
C_J
  = (1/2)*sum_(i,m<=J) a_(i,m)
      *(Shift^(m*Y_i)+Shift^(-m*Y_i)),
R = Shift^H,
a_(i,m) = 2*(-1)^(m+1)*S_i^m*rho^m/m.
```

The Fourier vector `|khat>` is a simultaneous eigenvector of `C_J` and `R`,
with eigenvalues `G_J(k)` up to the removed constant and `(-1)^k`,
respectively.  Therefore, for `p` in `{+1,-1}`, the SDP

```text
beta_p = max Tr(C_J*X)
subject to X >= 0,
           Tr(X) = 1,
           Tr(R*X) = p
```

is exactly

```text
beta_p = max_(k : (-1)^k=p) G_J(k) - constant.
```

Indeed, saturation of the expectation of the involution `R` forces every
feasible `X` to be supported on its `p` eigenspace.  This is a favorable input
description: `C_J` has row sparsity `O(q*J)`, its norm is at most
`O(q*log log n)` in the paper-scale regime, and it has a standard efficient
sparse block encoding.  The feasible set, however, is still the simplex over
`N/2` Fourier atoms.  Fourier diagonalization therefore turns the SDP back
into the original sparse-score maximization rather than solving it.

The usual generic quantum-SDP access models do not remove this atom count.
Sparse-input solvers retain square-root dependence on matrix dimension.
Polylogarithmic-dimension variants instead assume stronger low-rank state
input and rank/trace parameters for which this high-rank circulant instance
has no efficient promise.  Alternative Gibbs/implicit formulations would
require efficient posterior Gibbs preparation, which is not supplied here.
Separately, the explicit word hierarchy would need a nontrivial Toeplitz
separator; such a separator is precisely a bounded modular relation once
the no-short-relation event stops holding.  These are access-model barriers,
not lower bounds on every quantum SDP algorithm.  Representative primary
references are [Quantum Speed-ups for Semidefinite
Programming](https://arxiv.org/abs/1609.05537) and [Quantum SDP Solvers:
Large Speed-ups, Optimality, and Applications to Quantum
Learning](https://arxiv.org/abs/1710.02581).

The separation problem for this sparse SDP is exactly the missing decoder,
not an easier black box hidden by the notation.  Put

```text
Pi_p = (I+p*R)/2,
K_(p,t) = Pi_p*(t*I-C_J)*Pi_p + Pi_(-p).
```

Because `C_J` commutes with `R`, Fourier diagonalization gives the exact
equivalence

```text
K_(p,t) >= 0
iff
t >= max_(k:(-1)^k=p) [G_J(k)+q*ln(1+rho^2)].
```

Thus even weak PSD separation at the normalized accuracy needed to preserve
the established planted score gap decides which parity sector contains the
maximum.  The matrix remains sparse--it uses only the shifts in `I`, `R`,
`C_J`, and `R*C_J`--but sparsity does not supply the separator.

There is also an exact representation-theoretic limit on a common proposed
compression.  The cyclic group algebra satisfies

```text
C[Z_N] is isomorphic to C^N.
```

Its `N` minimal Fourier idempotents are nonzero mutually orthogonal
projections.  Any star-homomorphic representation that reflects positivity
on the whole algebra must map every one of them nontrivially: otherwise the
negative of an omitted idempotent maps to the zero PSD matrix.  Its matrix
dimension is therefore at least `N`, or at least `N/2` after fixing parity.
Character subsampling merely selects candidate frequencies; it is not a
positivity-reflecting compression.  This is a barrier only for faithful
group-algebra or character-subsampling representations, not for a nonlinear
instance-specific separator.

After fixing one parity and normalizing all deterministic binomial
relations, the full normalized positive-functional space is exactly the
simplex `Delta_(H-1)` on the `H=N/2` surviving characters.  This gives a
stronger universal exact-lift statement.  The vertex/facet slack matrix of
that simplex is `I_H`, whose PSD rank is exactly `H`.  Indeed, in any
factorization

```text
delta_(i,j) = Tr(A_i*B_j),    A_i,B_j >= 0 in R^(r by r),
```

zero off-diagonal traces make `A_i` annihilate `range(B_j)` for `i!=j`.
Choose `v_j in range(B_j)` with `A_j*v_j!=0`; applying every `A_i` to a
linear relation among the `v_j` shows that these `H` vectors are independent.
Thus `r>=H`, while the diagonal lift attains `H`.  The cone-factorization
theorem of
[Gouveia--Parrilo--Thomas](https://arxiv.org/abs/1111.3164) then implies that
every universal exact spectrahedral lift of this full quotient state space
therefore has PSD size at least `H`.  This does not exclude an approximate
lift or an instance-specific separator for the one sparse objective `G_J`.

Character subsampling is already exponentially large before full group
closure.  Let `V_L` be the real Hermitian Fourier span generated by the
residues `a dot Y` for `a in Word_(2*L)`.  A test using `d` character
evaluations can reflect pointwise positivity on all of `V_L` only if its
evaluation map is injective: otherwise a nonzero real `h` in its kernel and
`-h` both sketch to zero, although they cannot both be nonnegative on every
character.  Hence `d>=dim_R(V_L)`.  On the preceding no-`Word_(4*L)`-relation
event, the residue map is injective and

```text
dim_R(V_L) = |Word_(2*L)|
            >= choose(q,L)*(2*J)^L,
```

which is already exponential at the displayed hierarchy depth.  This lower
bound is only for scalar character-evaluation sketches, not arbitrary PSD
lifts.

The usual low-rank and Gibbs-input promises also fail in their direct forms.
On one parity sector, collect equal shifts and write

```text
C_p = sum_(s in Z_H) c_s*U^s,
T = #{s:c_s!=0} <= 2*q*J+1.
```

Shift orthogonality and the triangle inequality give

```text
||C_p||_F^2 = H*sum_s |c_s|^2,
||C_p|| <= sum_s |c_s|,
stable-rank(C_p) >= H/T,    C_p != 0.
```

Eckart--Young therefore implies, for every rank-`b` approximation `B`,

```text
||C_p-B||_F^2/||C_p||_F^2 >= 1-b*T/H.
```

Constant-relative-Frobenius compression needs exponential rank.  At the
optimum `beta_p`, the dual slack `beta_p*I-C_p` has rank `H-r_max`, where
`r_max` is the number of maximizing characters.  A rank-one primal optimum
exists, but constructing its Fourier projector is exactly finding the hidden
optimizer, so this existential low rank is not an input promise.

Similarly, apply any trace-nonincreasing functional-calculus contraction to
the maximally mixed spectral state `I_H/H`.  If the accepted state has
conditional mass at least `c` on an `r`-dimensional maximizing space, then
its success probability `s` satisfies

```text
c*s <= r/H.
```

Thus a constant-dimensional target still costs `Omega(sqrt(H/r))` coherent
amplification from that input, even if sparse arithmetic implements the
filter efficiently.  This includes the direct Gibbs/QSVT postselection
architecture, but not a structured nonuniform input or a circuit that avoids
top-space preparation.

Even a classical exact chordal conversion is generically large here.  The
first-harmonic Cayley graph has normalized nontrivial eigenvalues

```text
lambda_k = (1/q)*sum_i cos(2*pi*k*Y_i/N).
```

Hoeffding and a union bound give

```text
Pr[max_(k!=0) |lambda_k|>1/2]
 <= 2*(N-1)*exp(-q/8).
```

At `q=12*n` this tends to zero exponentially.  On the additional
overwhelmingly likely no-loop/no-generator-collision event, the associated
simple graph is a constant expander and has linear treewidth; an exact chordal
cover has an `Omega(N)` clique.  This only excludes the evident
Cayley/chordal SDP conversion.

There is nevertheless a genuine polynomial-size arithmetic lift.  Put
`z=omega_N^k` and introduce unit-modulus variables

```text
u_0 = z,
u_(r+1) = u_r^2,        0<=r<n-1,
u_(n-1) = p.
```

The last equation is exactly the parity constraint because
`z^(N/2)=(-1)^k`.  For every public frequency `f=m*Y_i mod N`, write the
binary expansion `f=sum_r f_r*2^r` and form

```text
w_f = product_(r:f_r=1) u_r
```

with a balanced tree of quadratic multiplication constraints; negative
frequencies use conjugates.  The objective `G_J(k)` is linear in
`Re(w_f)`.  The result is an exact nonconvex unit-modulus QCQP with
`O(n*q*J)` variables and quadratic constraints.  Its feasible points--or,
equivalently, the rank-one points of the standard SDP lift--are exactly the
candidate phases, so merely enforcing rank one is the original search
problem.  A complete quotient-moment representation has `N/2` characters,
while no polynomial-size tight relaxation is known for the planted instances.
Still, this compact repeated-squaring lift is a more concrete
positive target than the `N`-atom SDP: a distribution-specific phase-
synchronization, message-passing, or low-level relaxation that provably
recovers its planted parity would be a new polynomial decoder.  The preceding
word-hierarchy pseudo-solution does not automatically rule out every
relaxation of this different lift.

The first-order Shor relaxation of this lift is not that decoder.  Give every
occurrence `f_(i,m)=m*Y_i mod N` its own exact multiplication tree; separate
trees remain equivalent at rank one because they use the same shared powers.
Strengthen the ordinary first-order complex Shor constraints for every gate
`v=a*b` to include

```text
L(v) = L(a*b),
L(v*conj(a)) = L(b),
L(v*conj(b)) = L(a),
```

together with conjugates, unit diagonals, the analogous squaring identities,
and `u_(n-1)=p`.  A feasible witness for either `p` can be realized by actual
unit-circle random variables at the level of these moments.  Choose
`alpha_p^2=p` and put

```text
u_(n-1) = p,
u_(n-2) = alpha_p*epsilon,   epsilon uniform in {+1,-1},
u_0,...,u_(n-3) independent Haar phases.
```

Then `E[u_(r+1)]=E[u_r^2]`, every nonfixed shared power has mean zero, and
the displayed first-order consequences hold.  For an occurrence coefficient
`a_(i,m)`, let `s_(i,m)=sign(a_(i,m))`.  When its binary frequency has at
least four set bits below `n-1`, choose a balanced tree whose root children
are private.  With an independent Haar phase `R_(i,m)`, set

```text
w_(i,m) = s_(i,m),
A_(i,m) = R_(i,m),
B_(i,m) = s_(i,m)*conj(R_(i,m)).
```

Here `A,B` are the root children.  Give every lower private node an
independent Haar phase, except that a gate incident to the fixed leaf
`u_(n-1)` is made pointwise correct.  The root and fixed-leaf gates then hold
pointwise; every other displayed Shor identity is `0=0`.  The moment matrix is
positive because these are genuine jointly distributed random variables,
although the deliberately decoupled lower gates do not hold pointwise.

This construction applies with high probability.  For fixed `m`, put
`t=v_2(m)`.  The frequency `m*Y_i` is uniform on `2^t*Z_N`, and

```text
Pr[wt_(0,...,n-2)(m*Y_i)<=3]
 = 2*sum_(j=0)^3 choose(n-1-t,j)/2^(n-t)
 = O(n^3*2^t/N).
```

Since `2^t<=m<=J`, the union failure probability over all `q*J`
occurrences is

```text
O(q*J^2*n^3/N) = o(1).
```

Both parity relaxations therefore attain the same separable upper bound

```text
U_J = sum_(i,m) |a_(i,m)|
    = 2*q*sum_(m<=J) rho^m/m.
```

Including the removed constant, their value is

```text
-q*ln(1+rho^2)+U_J.
```

At `1-rho=Theta(1/sqrt(ln n))` this is `Theta(q*ln ln n)`.  In contrast,
uniform truncation control at `J=Theta(ln^(3/2) n)` gives

```text
max_k G_J(k)
 <= q*ln(1+lambda)
    +2*q*rho^(J+1)/[(J+1)*(1-rho)]
 = O(q).
```

Thus even the strengthened first-order Shor lift has a growing integrality
gap and no planted parity gap.

Order two is a real boundary rather than an already refuted algorithm.  For a
degree-four pseudoexpectation and every quadratic gate `g=v-a*b`, the order-
two localizers imply

```text
L(|g|^2) = 0.
```

Hence `g` is null against every admissible degree-two multiplier, and the
first-order random-variable witness fails because its broken gates have
`E[|v-a*b|^2]=2`.  If a saturated root obeys

```text
w=A*B,
A=A_1*A_2,
B=B_1*B_2,
L(w)=s,
```

then one balanced sequence of legal substitutions forces

```text
L(A_1*A_2*B_1*B_2) = s.
```

The substitutions need not be balanced.  For example, substituting
`A=A_1*A_2` and then `A_1=C_1*C_2`, with multiplier `A_2*B`, also forces

```text
L(C_1*C_2*A_2*B) = s.
```

What is exact is the direct frontier-size limit: a gate substitution adds one
factor, and expanding a frontier of four would require a degree-three
multiplier and a degree-five moment.  Thus no single substitution sequence
directly exposes more than four factors, although it may follow one branch
asymmetrically.  A balanced tree of depth at least four keeps that direct
frontier on private internal nodes instead of the shared `u_r` leaves.
Requiring every frequency to have at least sixteen set bits below the top bit
makes the crude failure probability only

```text
O(q*J^2*n^15/N).
```

The direct frontier bound is not a buffer theorem.  Hankel transport can
reassociate compatible overlapping product-tree gates without expanding the
whole trees to all of their leaves.  It also lifts squaring through a product
gate.  Suppose

```text
v=a*b,       v'=a'*b',
[a']=[a^2],  [b']=[b^2].
```

Here brackets denote columns in the order-two moment Gram matrix.  Gate
rotations and Hankel transport give

```text
[a'*b]=[v*a],   [a*b']=[v*b],
[a'*conj(v)]=[a*conj(b)]=[v*conj(b')],
```

and a final transport gives `[a'*b']=[v^2]`.  Since `[v']=[a'*b']`, aligned
trees for `m*Y_i` and `2*m*Y_i`, with identity padding for the dropped top bit
under modular wrap, therefore obey exactly

```text
[w_(i,2m)] = [w_(i,m)^2].
```

This matters for the first-order witness.  Its independently saturated root
signs are

```text
s_(i,m) = sign(a_(i,m)) = (-1)^(m+1)*S_i^m.
```

But `s_(i,2m)=-1` whereas `s_(i,m)^2=1`, so that witness is inconsistent at
order two whenever the two occurrence trees are aligned.  The isolated first-
two-harmonic block of one sample has the following exact optimum, hence this
is an upper bound on its contribution in every global feasible point:

```text
max_(|z|=1) [2*rho*Re(z)-rho^2*Re(z^2)]
 = rho^2+1/2,    rho>=1/2,
 = 2*rho-rho^2,  rho<1/2.
```

Thus order two removes a real part of the artificial first-order gap.  It
does not by itself supply a parity decoder: harmonic consistency is local to
one sample, while the wanted bit is carried by an exact public-label half-
turn relation.

There is an exact finite certificate for the remaining completion question.
Let `R_2` be the reduced Laurent monomials of degree at most two in all QCQP
variables.  Start with the labelled column identities `[v]=[a*b]` for every
gate, `[u_(n-1)]=p*[1]`, and any proposed unit-phase root pins.  Repeatedly
close these identities under inversion, transitivity, and Hankel transport:
whenever one admissible column pair with Laurent difference `gamma` has phase
`xi`, every other admissible pair with the same difference receives phase
`xi`.  If no pair receives conflicting phases, put one orthogonal unit vector
on each connected component and use the accumulated phases inside that
component.  The resulting block-rank-one Gram matrix is PSD, has unit
diagonal, is Hankel, and satisfies every order-two gate and fixed-variable
localizer.  Since `|R_2|=O(V^2)`, this sufficient certificate is checkable in
polynomial time for `V=O(n*q*J)`.  Conversely, every feasible order-two
matrix with saturated targets must respect the same generated identities, so
a phase-conflicting loop proves that those particular targets are impossible.

A useful coherent proposal pins

```text
tau_(i,m) = S_i^m.
```

It respects every deterministic same-sample harmonic identity and gives the
feasible objective value

```text
B_J = q*[-ln(1+rho^2)
          +2*sum_(m<=J) (-1)^(m+1)*rho^m/m]
    = q*ln(1+lambda)+O(q*rho^(J+1)/J)
```

whenever the phase closure accepts the pins for the chosen parity.  If both
parity closures accept, this value is common to them.  If one
enforces only the rigorously derived aligned doublings, there is a stronger
conditional candidate.  Write `m=2^t*l` with `l` odd and put

```text
tau_(i,l) = S_i*exp(i*pi/3),
tau_(i,2^t*l) = tau_(i,l)^(2^t).
```

The odd term has cosine `1/2`, while every doubled term has cosine `-1/2`;
after multiplying by the alternating coefficient sign, every harmonic
contributes `rho^m/m`.  If both Laurent closures accept these pins, the two
parities have the common feasible value

```text
D_J = q*[-ln(1+rho^2)+sum_(m<=J) rho^m/m]
    = Theta(q*ln ln n)
```

at the paper-scale visibility.  Extra addition, cross-odd-chain, or public-
label arrows are precisely what can obstruct this candidate.

If one also sets `w_(i,0)=1` and adds the valid root identities
`w_(i,a+b)=w_(i,a)*w_(i,b)` for `a,b>=0` and `a+b<=J`, and the
closure accepts coherent maximizing pins for both parities, the root moment
block is Toeplitz.  The trigonometric moment theorem then bounds every sample
by `max_theta g_J(theta)`, where

```text
g_J(theta) = -ln(1+rho^2)
 +2*sum_(m<=J) (-1)^(m+1)*rho^m*cos(m*theta)/m.
```

Choose `theta_*` in `argmax_theta g_J(theta)` and pin
`tau_(i,m)=(S_i*exp(i*theta_*))^m`.  These coherent pins attain the ceiling,
so the two strengthened relaxations have exactly the same optimum
`q*max_theta g_J(theta)`.  Uniformly,

```text
|max_theta g_J(theta)-ln(1+lambda)|
 <= 2*rho^(J+1)/[(J+1)*(1-rho)].
```

For the pins `tau_(i,m)=S_i^m`, a labelled closure loop that uses root pins
with signed multiplicities `c_(i,m)` has logical exponent

```text
a_i = sum_m m*c_(i,m),
sum_i a_i*Y_i = h*H mod N,   h in Z.
```

Its loop phase is `product_i S_i^(a_i)*p^h`.  When every `a_i=0`, all
deterministic harmonic, carry, and reassociation aliases are therefore phase-
consistent.  A conflict must contain a nonzero public-label relation.  What
remains unproved for an arbitrary preselected compiler is that every possible
low-width Laurent loop has a sparse enough coefficient vector for the
existing no-short-relation bound to exclude it.  Independently regrouping or
buffering occurrence trees can change which loops the order-two closure sees,
so this is also formulation-dependent.

A compiler-independent theorem is available when width is measured in the
expanded root-pin provenance rather than in the completed closure graph.  Let

```text
A_R = {a != 0 : a=sum_(nu<=ell) epsilon_nu*m_nu*e_(i_nu),
       1<=ell<=R, epsilon_nu in {+1,-1}, 1<=m_nu<=J},
```

and let `E_R^pin` be the event that

```text
a dot Y is not 0 or H mod N    for every a in A_R.
```

Expand two competing derivations of one Laurent column identity into their
primitive seeds and cancel inverse uses.  If `c_(i,m)` is the resulting net
signed multiplicity, call `sum_(i,m)|c_(i,m)|` the root-pin width.  Tag a use
of root pin `(i,m)` by
`+/-m*e_i`, tag a parity pin by `+/-1` in a separate integer `h`, and tag
every standard phase-one gate or unit identity by zero.  Inversion negates
the tag, transitivity adds tags, and every Hankel transport copies the whole
provenance.  A conflicting closed proof of root-pin width at most `R` would
therefore satisfy

```text
a dot Y = h*H mod N,
loop phase = product_i S_i^(a_i)*p^h,
a in A_R or a=0.
```

On `E_R^pin`, a nonzero `a` is impossible.  If `a=0`, then
`h*H=0 mod 2*H`, so `h` is even and the loop phase is one.  Hence, for the
coherent pins `tau_(i,m)=S_i^m`, every conflict of root-pin width at most
`R` is excluded for both parities, for every multiplication-tree layout or
coloring built from those standard identities.  This includes arbitrarily
many repeated Hankel transports; the bound concerns their expanded net pin
provenance, not the number of edges in the saturated closure graph.

The event holds through a nearly linear proof width.  For fixed nonzero `a`,
put `g=gcd(a_1,...,a_q,N)`.  Since `||a||_infinity<=R*J`,

```text
Pr_Y[a dot Y in {0,H}] <= 2*g/N <= 2*R*J/N.
```

The crude word count gives

```text
|A_R| <= (R+1)*(2*q*J)^R,
Pr[not E_R^pin]
 <= [2*R*J*(R+1)/N]*(2*q*J)^R.
```

Thus for every fixed `epsilon>0`, taking

```text
R <= (1-epsilon)*n*ln(2)/ln(2*q*J)
```

makes the failure probability `2^(-epsilon*n+O(log n))` in the stated
`q=12*n`, polylogarithmic-`J` regime.  This is
`R=Theta(n/log n)`.  No theorem here bounds the root-pin provenance of every
completed-closure conflict, so a long proof compressed by transport remains
outside the result.

The same provenance gives a quantitative statement without saturating the
root moments.  Let a feasible order-two Gram have unit columns, let
`y_j=<1,w_j>`, and fix hypothetical unit pins `tau_j`.  For a formal closure
loop `C`, let `n_j` count all primitive pin-edge occurrences of pin `j`, with
multiplicity in an explicit telescoping derivation before net cancellation,
and let `sigma_C` be its formal loop phase.  Put

```text
d_j = 1-Re(conj(tau_j)*y_j).
```

Hankel transport preserves the pin residual norm:

```text
||[M]-tau_j*[N]||^2 = 2*d_j
```

whenever the transported quotient `M/N` is `w_j`.  Telescoping around the
loop and applying weighted Cauchy--Schwarz gives, for arbitrary `a_j>0`,

```text
D = sum_j a_j*d_j,
R_C = sum_j n_j^2/a_j,
D >= |1-sigma_C|^2/(2*R_C).
```

When the `tau_j` are the objective coefficient phases and the `a_j` are
their magnitudes, `D` is the deficit from the separable objective ceiling.
A sign-conflicting loop therefore forces `D>=2/R_C`.  For an isolated
`t`-cycle with first-harmonic weight `a_j=2*rho` and `n_j=1`, this gives
`D>=4*rho/t`, consistent with the exact cycle penalty below.  This theorem
identifies a one-sided loss from a chosen reference ceiling.  It does not
bound `|Opt_+-Opt_-|`: parity-even harmonic conflicts may lower both sectors,
and the other parity need not attain the reference ceiling.

An odd closure cycle is not automatically a planted decoder.  Let

```text
T = {i : a_i is odd},    t=|T|.
```

Under the matched passive-sign model and a uniform secret, its prescribed
sign has the exact correlation

```text
E_[d,S|Y] [(-1)^d * product_(i in T) S_i]
 = lambda^t*2^(-t)
   * #{epsilon in {+1,-1}^T : sum_i epsilon_i*Y_i=H mod N}.
```

Consequently any single parity-selecting algebraic cycle has zero linear
population correlation unless its odd support already contains a signed
half-turn relation.  A uniform packing argument makes this exponentially
small for every adaptively selected cycle on a typical public instance.  Put

```text
s = floor(n/10)
```

and let `E_short` be the event that no nonempty signed subset of at most `s`
public labels sums to `0` or `H`.  For iid-uniform labels at `q=12*n`,

```text
Pr[not E_short]
 <= (2/N)*sum_(1<=t<=s) choose(12*n,t)*2^t
 <= exp[-(ln 2-(1/10)*ln(240*e))*n+O(ln n)]
 = exp(-Omega(n)).
```

For any `T`, let

```text
R_T(r) = #{epsilon in {+1,-1}^T :
           sum_(i in T) epsilon_i*Y_i=r mod N}.
```

On `E_short`, the sign words counted by `R_T(H)` form a binary code of
minimum distance greater than `s`: two distinct representations differ on a
signed subset summing to `0` or `H` after dividing their even coefficient
difference by two.  Hamming-ball packing gives, uniformly in
every `T`,

```text
R_T(H)/2^|T| <= delta_n,
delta_n = 2^(-floor(s/2)).
```

The parity-conditioned Walsh coefficient is exact.  With `B=(-1)^d` and
`b in {+1,-1}`,

```text
E[product_(i in T) S_i | B=b,Y]
 = lambda^|T|*2^(-|T|)*[R_T(0)+b*R_T(H)].
```

Hence every `Y`-measurable cycle predictor
`kappa(Y)*product_(i in T)S_i`, with `kappa(Y) in {+1,-1}`, has correlation
at most `delta_n` with `B`,
even when `T` is chosen after seeing all public labels.

There is also a joint nonlinear version.  Let

```text
X_j = kappa_j(Y)*product_(i in T_j) S_i,    1<=j<=m,
kappa_j(Y) in {+1,-1},
```

and let `r` be the binary rank of the odd-support vectors `T_j`.  Redundant
cycle characters are deterministic products of `r` basis characters.  Every
nonconstant Walsh coefficient of the difference between the `B=+1` and
`B=-1` laws has magnitude at most `2*delta_n`.  Parseval and Cauchy--Schwarz
therefore give

```text
TV(Law(X|B=+1,Y), Law(X|B=-1,Y))
 < 2^(r/2)*delta_n.
```

Thus any nonlinear postprocessing of cycle characters whose odd-support span
has rank at most `(1/10-epsilon)*n` has exponentially small distinguishing
advantage on `E_short`.  No bound on that rank is currently proved for the
entire aligned closure.

For the pins `tau_(i,m)=S_i^m`, this also sharpens the saturated phase-
certificate interpretation.  Choose a canonical odd closure relation using
only the public compiler and `Y`.  If no odd relation exists, phase-closure
acceptance is identical for `p=+1` and `p=-1`.  If one exists and either
parity is accepted, that relation forces

```text
p = kappa(Y)*product_(i in T) S_i.
```

The selected parity is therefore correct with probability at most
`1/2+2^(-Omega(n))` on `E_short`; multiple inconsistent relations may instead
reject both parities.  This rules out a high-probability planted feasibility
gap for the saturated `tau_(i,m)=S_i^m` phase certificate.  It does not bound
the unsaturated order-two SDP value gap, nor a closure whose odd-support rank
exceeds the displayed threshold.  Rare short relations explain the scope:
for example,
`Y_i=H` gives the one-cycle predictor `S_i` with accuracy
`(1+lambda)/2`, while the event that some label equals `H` has probability at
most `q/N`.

An isolated directly enforced cycle can have a visible algebraic value gap
without having the planted direction.  For `t` first-harmonic roots with
equal coefficient `2*rho`, impose

```text
product_i w_i^(epsilon_i) = p
```

and put `x_i=S_i*w_i`.  The constraint becomes
`product_i x_i^(epsilon_i)=r`, where `r=p*product_i S_i`.  The exact rank-one
maximum of `sum_i Re(x_i)` is `t` for `r=+1` and `t*cos(pi/t)` for `r=-1`.
Thus the isolated value split is

```text
2*rho*t*[1-cos(pi/t)] = Theta(rho/t),
```

but its preferred parity is `p=product_i S_i`, whose planted correlation is
the exponentially small coefficient bounded above.  For a long relation
visible only after derived Laurent closure, this is a direct-root rank-one
model, not a formula for the full order-two SDP optimum.

A randomized regrouping gives a precise cut-dissociation event, but not yet a
typical-acceptance theorem.  It changes the multiplication-tree layout but not
the rank-one function being computed.  Index the `Q=q*J` frequency
occurrences by `o`, and write

```text
f_o = b_o*H + F_o,    b_o in {0,1},    0<=F_o<H.
```

Independently color every set bit of each lower mask `F_o` into `K=16`
buckets.  Let `F_(o,c)` be the sum of the powers of two in bucket `c`.
Compute each bucket product in a bottom tree, then combine the sixteen cut
ports with a balanced depth-four top tree.  Define the event `D4` by

```text
sum_(o,c) gamma_(o,c)*F_(o,c) != 0 mod H
```

for every nonzero integer vector `gamma` with `l_1` norm at most four.
On `D4`, every bucket is nonempty.  If its sizes are `w_c`, the number of
multiplication nodes is still exactly

```text
sum_c (w_c-1) + (K-1) = wt(F_o)-1.
```

Thus this is only an occurrence-specific reassociation of the original exact
product.

The event holds with exponentially high probability.  Put

```text
L=n-1,
P=16*Q,
w_*=(L-ceil(log_2 J))/3.
```

The lower mask of `m*Y_i`, after its at most `ceil(log_2 J)` forced zero
bits, has independent fair remaining bits.  A Chernoff bound makes all `Q`
masks have weight at least `w_*` except with probability

```text
Q*exp(-(L-ceil(log_2 J))/36).
```

For a fixed nonzero `gamma` of `l_1` norm at most four, some occurrence has a
nonconstant coefficient across its sixteen colors.  Revealing its colored
set bits from low to high, choose a baseline color and divide the largest
common power `2^s` from its nonzero coefficient differences.  The norm bound
gives `s<=2`.  Every support bit below the final `s` positions then imposes a
nontrivial parity condition on its color, whose conditional mass is at most
`15/16`; the low-to-high exposure absorbs carries exactly.
Counting such coefficient vectors by signed words of length at most four
gives

```text
Pr[not D4]
 <= Q*exp(-(L-ceil(log_2 J))/36)
    +(2*P+1)^4*(15/16)^(w_*-2).
```

Jointly over the labels and compiler colors, for `q=12*n` and
`J=Theta((ln n)^(3/2))`, this is `exp(-Omega(n))`.

The primitive gate identities explain why `D4` looked tempting.  For a
quadratic gate `v=a*b`, its immediate order-two rotations include

```text
v <-> a*b,
v*conj(a) <-> b,
v*conj(b) <-> a,
```

together with conjugates.  Repeated Hankel transport of already derived
identities is stronger, however, and `D4` alone is not sufficient.  There is
an exact balanced-depth-four counterexample.

Take `H=2^192` and eight disjoint two-by-four grids of atom frequencies

```text
y_(g,r,c) = 2^(3*(8*g+4*r+c)),
0<=g<8, 0<=r<2, 0<=c<4.
```

Use three frequency occurrences.  Occurrence `S` has the sixteen row ports

```text
A_(g,r) = sum_c y_(g,r,c).
```

Occurrences `T_0,T_1` use four grids each and have the sixteen column ports

```text
B_(g,c) = sum_r y_(g,r,c).
```

All three top trees are balanced of depth four.  In the phase-product trees,
the order-two closure has two elementary transport identities.  First, if

```text
p=a*b, r=e*f, i=a*e, j=b*f, C=i*j,
```

gate rotations and three transports give `[p*r]=[i*j]=[C]`; call this the
half-transpose identity.  Second, for

```text
P=p*q, Q=r*s, R=p*r, S=q*s, W=P*Q, Y=R*S,
```

the transported chain

```text
[q*conj(Y)]
 = [conj(s)*conj(R)]
 = [conj(p)*conj(Q)]
 = [q*conj(W)]
```

gives `[W]=[Y]`; this is the medial identity.  Apply half-transpose to the
left and right two-column halves of each grid, then medial to combine them.
The two-row subroot of every grid equals its four-column subroot.  Propagating
these equalities through the compatible balanced tops yields

```text
[w_S] = [w_(T_0)*w_(T_1)].
```

Thus the pins `w_S=-1`, `w_(T_0)=w_(T_1)=+1` conflict.

Nevertheless `D4` holds.  The total atom mass is `(H-1)/7`, so every port
relation of `l_1` norm at most four has absolute integer value below `H`; a
congruence is therefore an ordinary equality.  Reducing at the least nonzero
base-eight digit forces, in each grid,

```text
alpha_(g,r)+beta_(g,c)=0.
```

Every nonzero solution has the two row coefficients equal to `a`, all four
column coefficients equal to `-a`, and `l_1` cost `6*|a|>4`.  Hence no
nonzero `D4` relation exists even though the completed closure conflicts.

This counterexample refutes the deterministic implication
`D4 => no conflicting loop`.  It does not refute a high-probability theorem
with stronger public-label dissociation: the construction has the sparse
occurrence-level identity `F_S=F_(T_0)+F_(T_1)`.  Proving that an augmented
random event controls every completed-closure conflict, without a root-pin-
width bound, remains open.  The
example also does not show that a uniformly random compiler coloring fails
with nonnegligible probability.

There is a rigorous way to make the formulation dependence itself explicit.
It does not strengthen the natural lift; instead it shows why a fixed-order
claim cannot be invariant under exact redundant quadratic reformulations.
Let `G=(V,E)` be a simple connected `4`-regular edge expander satisfying
`|delta_G(S)|>=h*|S|` for `|S|<=|V|/2`, with an Eulerian orientation having
two incoming and two outgoing edges at every vertex.
Delete one directed non-loop edge and replace its two occurrences by terminals `x`
and `w`.  At every vertex impose the direct quadratic binomial

```text
product_(incoming edges) z_e = product_(outgoing edges) z_e.
```

Multiplying all vertex equations cancels every internal edge and gives
`x=w`.  Conversely, when `x=w`, additive phases can be routed along any path
between the terminals, so the internal unit variables extend the boundary
assignment.  The buffer is therefore an exact rank-one identity gadget.

Choose an expansion constant `h>0`, put `C=ceil(8/h)`, and take
`|V|>3*C`.  Track a generated buffer identity by the integer vector
`c in Z^V` of vertex binomials used in it.  Primitive buffer identities have
`c=e_v`; identities outside the buffer have `c=0`; inversion negates `c`,
Hankel transport preserves it, and transitivity adds two such vectors.  On an
internal edge `(u,v)`, the exponent is `c_u-c_v`.

Every visible closure identity is the ratio of two degree-at-most-two
monomials.  Since internal buffer edges occur nowhere else, at most four of
their exponent differences are nonzero.  The conservative constant `8`
covers restoring the deleted edge and terminal cancellations.  For any
integer vector with at most eight disagreement edges, expansion implies that
it equals one integer constant away from at most `C` vertices.  Indeed, if no
level set had a strict majority, summing the expansion bound over all level
sets would give more than `16` boundary incidences, whereas each disagreement
edge is counted twice.  For the majority level, its complement has boundary
at most eight and therefore size at most `C`.

This yields a closure-round induction.  Every primitive `c` is zero outside
one vertex.  If two previously generated vectors are zero outside at most
`C` vertices, their sum is zero outside at most `2*C` vertices.  The preceding
lemma says that the sum is constant away from at most `C` vertices.  That
constant cannot be nonzero when `|V|>3*C`, because the sum was nonzero on at
most `2*C` vertices.  Thus the new vector is again zero outside at most `C`
vertices.  Consequently no nonzero constant vector
`r*1_V` is ever generated, and no terminal identity `w^r=x^r` with `r!=0`
enters the order-two closure.
Insert a disjoint copy of this buffer between every canonical frequency root
`x_(i,m)` and the exposed objective root `w_(i,m)`.  In any closed phase loop,
all private internal-edge exponents vanish.  The graph `G-e` is connected--a
connected even-regular graph has no bridge--so the buffer coefficient vector
is constant on `V`.  The induction forces that constant to be zero; hence
every exposed pin has zero net use and contributes phase one.  After deleting
the buffers, an actual parity-sector assignment makes the remaining
arithmetic loop consistent.

The finite no-conflict phase-groupoid construction therefore accepts
arbitrary sign pins together with either parity pin.  Seed it with the direct
degree-two column identities `[a*b]=[c*d]`; the resulting block-rank-one
Hankel Gram satisfies their full order-two equality localizers.  In
particular, choosing

```text
w_(i,m) = sign(a_(i,m))
```

makes both order-two relaxations attain the full separable ceiling `U_J`.
This theorem assumes the vertex relations are included directly as quadratic
binomials.  Compiling each one through extra ternary gate variables changes
the truncated closure and needs a separate width audit.  It also assumes
that harmonic/addition identities are attached below the buffers: adding
them directly among the exposed roots restores the corresponding low-order
relations.  The result is therefore an exact lift-noninvariance example, not
a claim that the original aligned arithmetic QCQP is parity-blind.  A
symbolic row-lattice normal-form presolver can also combine all buffer
binomials, recover `w=x` by integer linear algebra, and add that equality
before solving.
The gap is for the raw fixed-order moment/localizer formulation and its finite
Hankel closure, not for an implicit solver allowed to normalize the full row
lattice first.

In fact, for the exactly encoded root-of-unity phases used here, this equality
preprocessing is polynomial for every deterministic unit-modulus binomial
system.  Store each relation `z^a=xi` as an integer exponent row.  Smith or
Hermite normal form checks phase consistency, computes the row-lattice
quotient while retaining torsion and phase data, and reduces every auxiliary
monomial to a normal-form class in that quotient; feasible assignments are
characters, or the corresponding phase-twisted character coset.  For the
repeated-squaring arithmetic lift, it reduces the variables to one cyclic
phase satisfying
`z^H=p`; its candidate roots are exactly the `N/2` roots in parity class `p`.
The reduced objective is again `G_J(k)` on those characters.  Row-lattice
normalization removes artificial long equality derivations, including the
expander buffer, but leaves positivity and optimization as the original
sparse-score problem.  It also does not solve the bounded-word question in
the explicit hierarchy: a Smith-normal-form basis need not exhibit the
shortest modular relation.

The order-two SDP is polynomial size--its degree-two monomial matrix has
`O(V^2)` rows--but the exact results now point in both directions: aligned
harmonics rule out the first-order witness, while acceptance of coherent pins
for both parity hypotheses constructs explicit common pseudo-moments.  The
randomized sixteen-bucket compiler has a rigorous exponentially likely
cut-dissociation event, but the exact counterexample above shows that the
event alone is insufficient under repeated Hankel interpolation.  A random
dissociation condition controlling every completed-closure conflict without
a root-pin-width bound remains open.  The
expander buffer independently proves lift non-invariance for a redundant
formulation.  Proving a planted parity gap, or parity blindness for the fixed
aligned arithmetic compiler, remains the first specific low-level relaxation
opening.

Natural exact message passing encounters a different sharp barrier.  Keep
only the `m=1` product tree for each sample and contract its private nodes to
one term vertex.  The resulting graph minor is

```text
B = ({u_0,...,u_(n-2)}, {1,...,q}, E),
(r,i) in E iff bit r of Y_i is 1.
```

For uniform labels and `q=12*n`, this is
`G_bip(n-1,12*n,1/2)`.  A balanced-separator union bound gives

```text
tw(B) = Omega(n)
```

with failure `exp(-Omega(n^2))`: after deleting fewer than `n/4` vertices,
two large anticomplete sides would expose `Omega(n^2)` independent possible
crossing edges, while there are only `3^(13*n)` candidate partitions.
Therefore generic exact variable elimination or tabular tensor contraction
of the natural local factor graph has exponential width.  Algebraically
substituting every `u_r=u_0^(2^r)` collapses the graph, but leaves one variable
with `N/2` feasible roots.  This is a contraction/domain tradeoff, not a
lower bound against structured arithmetic compression.

Exact coefficient-table sum--product also becomes exponential before a
linear fraction of the samples.  After `j` likelihood factors, two distinct
ternary exponent words collide only if some nonzero

```text
c in {-2,-1,0,1,2}^j
```

satisfies `c dot Y=0 mod N`.  Each fixed relation has probability at most
`2/N`, so

```text
Pr[any collision after j factors] <= 2*(5^j-1)/N.
```

For every fixed `epsilon>0`, at

```text
j = floor((1/log_2(5)-epsilon)*n)
```

the exact sparse message has, with high probability,

```text
3^j
 = 2^((log_2(3)/log_2(5)-epsilon*log_2(3))*n+O(1))
```

nonzero residues.  Switching to a dense residue table uses `N` states.  This
rules out only exact coefficient-table or character-basis BP.

The exact radix message already shows why a scalar recursion is insufficient.
If

```text
W(k) = sum_(r in Z_N) A_r*omega^(k*r),
k = a+2^t*s,
M = 2^(n-t),
```

then character orthogonality gives

```text
Z_t(a)
 := sum_(s=0)^(M-1) W(a+2^t*s)
  = M*sum_(ell=0)^(2^t-1)
      A_(ell*M)*exp(2*pi*i*a*ell/2^t).
```

In particular,

```text
Z_1(0) = H*(A_0+A_H),
Z_1(1) = H*(A_0-A_H).
```

Thus the first parity split already needs the two subgroup coefficients;
deeper bit messages need the corresponding growing coefficient family rather
than one Markovian scalar.

Nor does the uniform bitwise BP initialization supply an inverse-polynomial
seed.  Write `k=sum_j b_j*2^j`, fix the parity bit `b_0`, and for one sample
write

```text
Y=2^v*y,   y odd,
m=n-v,
r_star=m-1.
```

With all free-bit incoming messages uniform, and apart from its known
likelihood coefficient of magnitude at most one, the phase part of the
factor-to-bit harmonic is

```text
C_r
 = exp(i*phi_0*b_0)
   *product_(j=1,j!=r)^(n-1) (1+exp(i*phi_j))/2,
phi_j = 2*pi*Y*2^j/N.
```

It is exactly zero for `r!=r_star`, because the product retains the factor
with `exp(i*phi_(r_star))=-1`.  For `r=r_star` and `m>=2`,

```text
|C_(r_star)|
 = 2^(2-m)/|sin(2*pi*y/2^m)|,
Pr[|C_(r_star)|>=eta] = O(n/(N*eta)).
```

Here the displayed probability is unconditional over uniform `Y`; conditional
on `m` the corresponding bound is `O(1/(2^m*eta))`.  The union bound over
polynomially many samples makes every first-round bias smaller than any
inverse polynomial with high probability.  This blocks the uniform or
linearized BP start, not seeded or strongly nonlinear BP.

Finally, exact memoization does not identify many repeated residual
subproblems.  At a middle prefix `k=a+2^t*s`, `t=floor(n/2)`, the functions
`F_a(s)=G_J(a+2^t*s)` are pairwise distinct even up to additive constants when
the signed public frequencies modulo `M=2^(n-t)` are nonzero, distinct, and
include an odd frequency.  Their Fourier coefficients carry the phases
`omega_N^(a*f)`, so equality forces `a=a'`.  The alias-free event fails with
probability only

```text
O(q^2*J^3/M)+2^(-q).
```

Thus an ordered exact decision diagram or memoized backward-square-root
search has width `2^floor(n/2)` at the middle cut.  The residual functions
still have polynomial sparse-Fourier descriptions, so a new algebraic
optimizer remains outside this result.

There is also an efficient spectral filter that makes the normalization
obstruction especially transparent.  Let `Shift` denote cyclic translation
on `Z_N` and define the known sparse circulant

```text
Corr = (1/2) * sum_i S_i*(Shift^(Y_i)+Shift^(-Y_i)).
```

Its Fourier eigenvalue at `k` is the correlation score

```text
T_k = sum_i S_i*cos(2*pi*k*Y_i/N).
```

For a nondegenerate secret, `lambda>=0.9`, and `q=12*n`, one has
`E[T_d]=q*lambda/2` and `T_(-d)=T_d`.  For every generic false candidate the
mean is zero and the one-sample variance is `1/2`.  Bernstein at `0.3*q`
gives

```text
Pr[|T_k|>0.3*q] <= 2*exp(-0.075*q),
```

so a union bound over `N` candidates succeeds with probability
`1-exp(-Omega(n))`; the fixed exceptional candidates `0,H` have the same
conclusion from a separate tail bound.  Meanwhile `T_d>=0.4*q` with
probability `1-exp(-Omega(n))`.  A standard block encoding of `Corr/q` and a
bounded QSVT threshold polynomial can therefore mark the two top modes using
`poly(n,log(1/epsilon))` gates.

Marking is not decoding.  If an input spectral state is
`|v>=sum_k alpha_k|k>` and a bounded postselected filter has conditional mass
at least `c` on `{d,-d}`, then its success probability `s` obeys exactly

```text
c*s <= |alpha_d|^2+|alpha_(-d)|^2.
```

A cycle-position state has right-hand side `2/N`.  For the natural sparse
data state `v_y=sum_(i:Y_i=y)S_i`, collision-free public labels and standard
concentration give target mass `Theta(q/N)`; the exact formula without the
collision simplification is

```text
(|vhat(d)|^2+|vhat(-d)|^2)/(N*||v||^2).
```

Thus even a perfect QSVT correlation filter needs
`Omega(sqrt(N/q))` amplification from that state.  This is a limitation of
spectral filtering, power iteration, and Lanczos-style state conversion, not
of a parity circuit that avoids preparing the top eigenspace.

Taking a signed spectral trace does not avoid the same normalization.  Put

```text
A = Corr/q,
P = Shift^H,
Pi_top = |dhat><dhat|+|-dhat><-dhat|.
```

In the Fourier basis, `P|khat>=(-1)^k|khat>`, so the ideal trace ratio looks
perfect:

```text
Tr(P*Pi_top) = 2*(-1)^d,
Tr(P*Pi_top)/Tr(Pi_top) = (-1)^d.
```

Operationally, however, both normalized traces have scale `2/N`.  Estimating
the ratio to constant relative error therefore still requires `Theta(N)`
projection attempts to obtain `O(1)` successful top-space events, or
`Theta(sqrt(N))` coherent
amplification.

The relation obstruction can be seen exactly for every polynomial.  If
`g(x)=sum_(m=0)^L c_m*x^m`, then

```text
(1/N)*Tr(P*g(A))
 = sum_m c_m/(2*q)^m
     *sum_(i_1,...,i_m; sigma_1,...,sigma_m in {+1,-1}
            : sum_j sigma_j*Y_(i_j)=H mod N)
        product_j S_(i_j).
```

Thus a polynomial spectral trace is precisely a signed half-turn relation
sum, now allowing repeated public labels.  After combining repetitions, a
fixed nonzero length-`m` word hits `H` with probability at most `m/N`.
Consequently

```text
Pr[any half-turn word of length at most L]
 <= L*(L+1)*(2*q)^L/N.
```

On the complementary event, `Tr(P*g(A))=0` for every degree-`L` polynomial.
This proves exact blindness for `L=o(n/log n)`, but it does not cover the
degree-`Theta(n)` polynomial needed for exponentially accurate marking.

The constant spectral gap does allow a bounded Chebyshev/QSVT polynomial to
approximate `Pi_top` in operator norm `epsilon` with degree
`O(log(1/epsilon))`.  Constant `epsilon` is insufficient for the trace sign:

```text
|(1/N)*Tr(P*(g(A)-Pi_top))| <= epsilon,
```

whereas the target is `2/N`.  Taking `epsilon=O(1/N)` raises the degree only
to `O(n)`, but it does not raise the normalized signal.  Ordinary DQC1 or
Hadamard trace sampling then needs `O(N^2)` repetitions for additive
`Theta(1/N)` precision, coherent mean estimation needs `O(N)` filter uses,
and top-mode postselection remains the sharper `Theta(sqrt(N))` route.  For
amplitude filtering from a uniform spectral probe, even constant conditional
top mass already needs leakage `epsilon=O(N^(-1/2))` because there are `N-2`
false modes.

An equivalent outlier formulation is sometimes tempting.  Put `a_k=T_k/q`.
Since `[A,P]=0`, the operator `B=P*A` has two positive isolated outliers when `d` is even and
two negative isolated outliers when `d` is odd.  On the good event,

```text
Tr(B^m)
 = 2*(-1)^d*a_d^m+R_m,
|R_m| <= (N-2)*0.3^m
```

for odd `m`, while `a_d>=0.4`.  Its sign becomes correct for

```text
m > ln((N-2)/2)/ln(4/3) = 2.409...*n,
```

and ordinary target-score concentration also gives `a_d<=0.6` with high
probability.  The resulting normalized moment is then exponentially smaller
than `1/N`; rescaling the polynomial enlarges the block-encoding normalization
by the same factor.  Bare evolution under `A` followed by measurement of `P`
cannot help, because commutation gives

```text
exp(i*t*A)*P*exp(-i*t*A) = P.
```

Determinants and resolvents package the same signed moments.  If `D_+(z)` and
`D_-(z)` are the determinants of `z*I-A` on the two parity sectors, then for
`|z|>1`,

```text
ln(D_+(z)/D_-(z))
 = -sum_(m>=1) Tr(P*A^m)/(m*z^m),
d/dz ln(D_+(z)/D_-(z))
 = Tr(P*(z*I-A)^(-1)).
```

At a threshold between `0.3` and `0.4`, the correct sector contains both
`+d` and `-d`, so a naive determinant-sign test sees two sign changes and
loses the bit.  Passing to the reflection-even cosine subspace removes that
degeneracy but leaves one exceptional eigenvalue among `Theta(N)` dimensions.
The determinant of a full QSP signal-unitary dilation is also fixed within
each two-dimensional signal block and is not the determinant of the projected
polynomial block.  These statements exclude the direct trace, moment,
determinant, resolvent, evolve-then-measure, and full-dilation-determinant
routes analyzed here; they do not
exclude a new arithmetic circuit that extracts parity without estimating a
normalized rank-two spectral statistic.

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

### A rank-one two-coset CVP interface

The passive signs also admit an exact lattice/nearest-codeword formulation.
This gives a useful conditional positive construction, but the resulting
decoding radius lies outside the standard polynomial lattice regimes.  Put

```text
b_i = (1-S_i)/2,
t_i = (N/2)*b_i,
Y = (Y_1,...,Y_q),
Lambda       = N*Z^q + Z*Y,
Lambda_even  = N*Z^q + 2*Z*Y,
Lambda_odd   = Y + Lambda_even.
```

When at least one `Y_i` is odd,

```text
det(Lambda) = N^(q-1),
det(Lambda_even) = 2*N^(q-1),
```

and an integer basis is computable in polynomial time by Hermite normal form.
For a candidate `k`, define its wrapped angular residual

```text
Delta_i(k)
 = wrap_[-pi,pi)(2*pi*k*Y_i/N-pi*b_i).
```

Maximum likelihood is exactly nearest-codeword decoding of the cyclic
rank-one code `{k*Y mod N:k in Z_N}` in the separable periodic metric

```text
Phi_lambda(k)
 = -sum_i ln(1+lambda*cos(Delta_i(k))).
```

Ordinary Euclidean CVP is a surrogate rather than the exact likelihood:

```text
Lambda_0 = Lambda_even,
Lambda_1 = Lambda_odd,
dist(t,Lambda_b)^2
 = (N/(2*pi))^2
     *min_(k=b mod 2) sum_i Delta_i(k)^2,
b in {0,1}.
```

For a planted secret of phase order `M_d=N/gcd(d,N)>=4`, one planted
residual has the exact finite-grid distribution below.  In this subsection,
"high order" means `M_d=2^(Omega(n))`.

```text
Pr[Delta=2*pi*r/M_d]
 = [1+lambda*cos(2*pi*r/M_d)]/M_d,
r in {-M_d/2,...,M_d/2-1}.
```

Consequently

```text
E[Delta^2]
 = pi^2/3+2*pi^2/(3*M_d^2)
   -2*lambda*pi^2*csc^2(pi/M_d)/M_d^2
 = mu_lambda+O(M_d^(-2)),
mu_lambda = pi^2/3-2*lambda.
```

At visibility one, `mu_1=1.2898681337...`.  Thus every high-order planted
secret, of either parity, has the same continuum distance law; a uniformly
random secret has `M_d=2^(Omega(n))` with overwhelming probability.  An opposite-
parity maximal-order wrong candidate has a uniform residual on its relevant
dyadic phase grid.  More exactly, for every wrong-parity `k`, the integer
residual `k*Y-H*b` is uniform on the subgroup generated by `{k,H}`.  If `d`
is even, every wrong `k` is odd and this subgroup has size `N`.  If `d` is
odd, the wrong candidates are even; a dyadic subgroup of size `R` contains at
most `R/2` candidates of the corresponding order, apart from the single
zero candidate.

This exact stratification supplies the union bound used below.  On a grid of
size `R`, let `I_R(x)` be the Chernoff lower-tail rate for the squared wrapped
uniform residual.  For every `R` tending to infinity, `I_R(x)` converges to the
continuum rate `I(x)` below.  Subexponential `R` contributes only
`exp(o(n))` candidates, and every fixed small grid, including the zero-
candidate two-point law, has a positive lower-tail rate at the displayed
`x`.  Thus the large grids are governed by the full-order exponent and all
smaller strata are harmless.  Let `U` be uniform on `[-pi,pi]` and
define the lower-tail rate function

```text
I(x)
 = sup_(s>=0) {-s*x-ln(E[exp(-s*U^2)])},
E[exp(-s*U^2)]
 = erf(pi*sqrt(s))/(2*sqrt(pi*s)).
```

For `q=12*n`, the wrong-coset first-moment edge is the solution of

```text
I(x_star) = ln(2)/12,
x_star = 2.3328459863....
```

A Chernoff bound followed by a union bound over the opposite parity class,
with the stated 2-adic stratification, proves for every fixed `x<x_star`

```text
Pr[min_(k of wrong parity) (1/q)*sum_i Delta_i(k)^2 <= x]
 <= exp(-Omega(n)).
```

The planted distance concentrates at `q*mu_lambda`.  Therefore, at visibility
one,

```text
sqrt(mu_1/x_star) = 0.7435832922...,
alpha_star = sqrt(x_star/mu_1) = 1.3448392540....
```

If a polynomial algorithm achieved CVP approximation factor
`alpha<1.3448` on these two typical high-order rank-one coset instances,
running it on the even and odd cosets and comparing the returned distances
would decide parity with exponentially small error.  This is a genuine
conditional positive interface: choose fixed `x` with
`alpha^2*mu_1<x<x_star`; the returned correct-coset angular squared residual
is below `q*x`, while every wrong-coset vector is above `q*x`, except on the stated
exponentially small tails.  The value `x_star` is deliberately called a first-
moment edge: the union bound rigorously excludes wrong-parity codewords below
it, while showing that the correlated minimum is actually attained near
`x_star` would require a separate second-moment or random-code argument.

The Euclidean objective is not a new hidden primitive; it has the exact
Fourier expansion

```text
D(k) := sum_i Delta_i(k)^2
 = q*pi^2/3
   +4*sum_(m>=1) (-1)^m*C_m(k)/m^2,

C_m(k)
 = sum_i S_i^m*cos(2*pi*m*k*Y_i/N).
```

This follows from

```text
wrap(theta)^2
 = pi^2/3+4*sum_(m>=1) (-1)^m*cos(m*theta)/m^2.
```

Its first nonconstant term is exactly `-4*T_k`, where `T_k` is the sparse-
circulant correlation score above.  Under the planted density,

```text
E[D(d)]/q
 = pi^2/3-2*lambda+O(M_d^(-2))
 = mu_lambda+O(M_d^(-2)),
```

so the leading constant mean advantage comes from that first harmonic; all
higher finite-grid aliases contribute only `O(M_d^(-2))`.  Higher odd aliases
do not invalidate the opposite-parity certificate.  A relation
`m*k=+/-d mod N` with odd `m` preserves parity.  More directly, if `d` is
even, every opposite-parity `k` is odd and `k*Y-H*b` is uniform on `Z_N`; if
`d` is odd, every nonzero opposite-parity `k` is even and the planted cosine
cancels over the preimages of `gcd(k,N)`, leaving the uniform law on
`gcd(k,N)*Z_N=<k,H>`.  The zero candidate has the uniform two-point law on
`{0,H}`.  This is the exact alias justification behind the stratified union
bound.

There is a useful exponential-time dimension tradeoff.  Retain only
`m=c*n` independent observations and let `x_c` solve

```text
I(x_c) = ln(2)/c.
```

The same proof certifies parity recovery whenever `x_c>mu_1`, equivalently

```text
c > c_0
  := ln(2)/I(mu_1)
   = 2.3253827537....
```

An `alpha`-approximate solver suffices whenever
`alpha^2*mu_1<x_c`.  Thus an exact exponential lattice experiment can use
only slightly more than `2.326*n` observations instead of `12*n`, but its
dimension remains linear in `n`; this is not a polynomial or subexponential
decoder.

The dual lattice makes the half-turn relation reappear explicitly.  For any
periodic `F` on `Z_N^q`, Fourier expansion gives

```text
sum_(k in Z_N) (-1)^k*F(k*Y-t)
 = N*sum_(z:z dot Y=H mod N)
       hat(F)(z)*exp(-2*pi*i*z dot t/N).
```

For `t=H*b`, the final phase is `(-1)^(z dot b)`.  Equivalently, subtracting
the two parity-coset theta series cancels the zero relations and retains the
half-turn relations.  A dual or Poisson decoder must therefore find or
coherently aggregate those relations; bounded total Fourier word order
reduces to the earlier low-word barrier.

The standard lattice routes checked here do not realize that interface in
polynomial time:

- exact cyclic scanning costs `O(q*N)`;
  [Durr--Hoyer minimum finding](https://arxiv.org/abs/quant-ph/9607014)
  reduces this to `O(q*sqrt(N))` arithmetic work only in the black-box
  objective model, while generic exact CVP is exponential in `q=Theta(n)`;
- LLL followed by Babai nearest-plane has an exponential worst-case
  approximation factor, far above `1.3448`; see [On Lovasz' lattice reduction
  and the nearest lattice point problem](https://doi.org/10.1007/BF02579403);
- standard BKZ guarantees with sublinear block size do not reach this constant
  gap, while the usual constant-factor heuristic estimates require block size
  linear in `q` and hence exponential work;
- this is not BDD: `N*e_i` lies in the lattice, whereas the planted Euclidean
  error is `(N/(2*pi))*sqrt(q*mu_1)=Theta(N*sqrt(n))`, already much larger
  than `N/2`;
- naive Kannan embedding retains the shorter vectors `(N*e_i,0)` and therefore
  does not turn the planted vector into unique SVP;
- phase unwrapping has no narrow-error promise, because the planted residual
  density `(1+lambda*cos(theta))/(2*pi)` has support on the entire circle;
- a proper dyadic reduction of one observation is exactly sign-independent
  for an odd secret, so 2-adic lifting has no single-sample base case;
- the one-bit hidden-number algorithms cited below use chosen
  multiplier queries and, in the closest advice-based form, modulus-dependent
  advice rather than one passive random sample block.

Modulo `N*Z^q`, the lattice has only the `N` cyclic torus codewords; the
infinite lattice also contains every vector `N*e_i`.  It is not a generic
random lattice.  Random-lattice heuristics,
sieving, and ordinary embedding therefore do not establish a polynomial
decoder.  Comparing the two parity cosets saves only a factor two in the
candidate count and does not change the asymptotic edge.  This route audit is
not a hardness theorem for the structured rank-one CVP family.

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
On a clean cube, coarse-fibre indexing itself is now explicit: residue DP gives exact
reversible rank/unrank modulo `R` in `O(poly(q)*R)` size, and an ordinary
small-integer checksum leaves a fresh linear high-label phase on a
polynomial-bond knapsack support.  These are real polynomial preprocessors
for `R=poly(n)`.  Their known refinement cost is exponential in the total
peeled modulus bits, reaching `O(poly(q)*N)` at full fibre resolution.
Fixed-point amplification gives the sharper `O*(sqrt(R))` approximate
controlled coarse-fibre sampler at constant error, but coarse DP plus residual
amplification does not beat `sqrt(N)` in ordinary gate count; the
`O*(N^(1/3))` hybrid needs ideal
exponential QRAM/advice.  Although each ordinary-checksum state has polynomial
MPS bond, parity averaging produces `M=N/T` flat residual-difference sectors,
so constant-relative-Frobenius MPO approximation needs `Omega(M)` bond on
typical branches.  Over
iid public high labels, the final-half-turn graph of every `O(log n)`-local
logical matching still has only exponentially small expected Born-weighted
coverage.
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
coefficient ratio by a new method.  In the noisy high-visibility regime, the
log likelihood itself now has a uniformly accurate polynomial-size sparse
trigonometric representation, so one especially concrete opening is an
implicit global optimizer for that random high-frequency polynomial.  The
grouped triangle envelope stays identical on `H/poly(n)` prefixes with high
probability, and exact high-bit elimination can become Fourier-dense in one
step.  These radix routes do not certify polynomial pruning, while scalar
polynomials in `G_J` below the
displayed `Theta(n/log n)` threshold have no half-turn harmonic at all with
high probability.  The natural parity-constrained group-moment/SOS hierarchy
also has a coherent sample-aligning rank-one pseudo-solution until its
explicit moment matrix is exponential, and the same point blocks the
displayed bounded-word SOHS certificates.  Conversely, a sparse
circulant/QSVT circuit can mark
the two correlation peaks efficiently, but the natural sparse-data input has
only `Theta(q/N)` weight there, so this route still pays
`Omega(sqrt(N/q))` amplification.  Signed spectral traces, moments,
determinants, and resolvents merely repackage the half-turn relation
coefficient at normalized scale `1/N`.  Generic SDP solvers do not optimize
the exact `N/2`-atom parity SDP in polynomial time under their stated input
parameters.  Its full quotient state simplex has exact PSD extension size
`N/2`, truncated character evaluation remains exponential at the displayed
hierarchy depth, and direct low-rank or Gibbs filtering retains exponential
rank or normalization.
The two most compact new positive interfaces are instead the
polynomial-size repeated-squaring unit-modulus QCQP and the typical rank-one
high-order two-coset CVP gap `alpha<1.3448`; no polynomial planted solver is
known for either.  The QCQP's strengthened first-order Shor relaxation has an
explicit parity-blind gap, and natural exact BP has exponential width or
support.  At order two, aligned harmonic identities invalidate the first-
order witness in the aligned-tree formulation, while a finite Laurent closure
supplies an exact conditional pseudo-moment certificate.  Typical instances
make every single closure-cycle predictor exponentially unbiased; even a
nonlinear cycle syndrome remains blind while its odd-support rank is below
`(1/10-epsilon)*n`.  This rules out a high-probability planted saturated-
feasibility gap for the `tau_(i,m)=S_i^m` phase certificate, not an
unsaturated SDP value gap.  For those coherent pins, every expanded proof
below the displayed `Theta(n/log n)` net root-pin-width threshold is
nevertheless phase-consistent for both parities with high probability in
every standard phase-one multiplication-tree layout.  Separately, using
objective-coefficient phases as the reference pins, a sign-conflicting loop
forces the one-sided separable-ceiling deficit `D>=2/R_C`.  Long compressed
proofs and the two-sector optimum difference remain open.  A randomized
sixteen-bucket reassociation has an exponentially likely cut-dissociation
event, but an exact depth-four counterexample shows that the event alone is
insufficient; a random condition controlling every completed-closure
conflict remains open.  An
exact expander identity buffer does show explicit lift non-invariance.  The
fixed aligned compiler and any planted parity gap remain concrete polynomial-
size openings.

This is not a no-go theorem.  A distribution-specific collective circuit
could conceivably decode only the parity without exposing a reusable fibre
eraser.  But such a circuit is not a small completion of Lemma 3: usable at
successive dyadic moduli with fresh states, a polynomial one-bit decoder would
give a polynomial DCP algorithm by bit recursion.  It would therefore be a new
algorithmic breakthrough in exactly the problem the paper claims to solve.

The narrowest remaining positive question can now be stated through four
distinct sufficient interfaces:

> Can one either (a) use the product-state representation of `K_Y` to implement
> its sign/polar action on the random fibre-uniform input ensemble without the
> natural `sqrt(N)` normalization, or (b) build a bounded, verifiable,
> inverse-polynomial-success random-target RMSS find-one algorithm on exactly
> `n` random correction coordinates and make the large-label two-pool
> construction respect the occupied fault subcube, or (c) decode the
> syndrome-isolated density-one core or the weighted coefficient ratio
> `A_H/A_0` without enumerating `N` residues, or (d) solve the compact
> repeated-squaring QCQP or approximate the associated typical two-coset CVP
> below `1.3448` without exponential lattice reduction?

A positive answer to any version would be a new DCP/subset-sum algorithmic
ingredient.  No such polynomial construction is supplied by the paper or
found in this investigation.  The random-singleton oracle model now has a
rigorous `Omega(sqrt(D))` constant-advantage barrier, but a negative answer for
the explicit arithmetic problem would require a stronger circuit-model or
average-case lower bound that is not presently available.

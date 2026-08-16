# Simon DCP Formalization and Audit

**Reference:** Daniel R. Simon,
[*A Polynomial-Time Quantum Algorithm for the Dihedral Coset Problem*](https://eprint.iacr.org/2026/1591),
IACR Cryptology ePrint Archive, Report 2026/1591 (2026).

## Table of contents

- [Status of Lemmas 1, 3, and 4](#status-of-lemmas-1-3-and-4)
  - [Lemma 1](#lemma-1)
  - [Lemma 3](#lemma-3)
  - [Lemma 3 spectral obstruction](LEMMA3_SPECTRAL_OBSTRUCTION.md)
  - [Global half-turn repair investigation](LEMMA3_HALF_TURN_ERASER.md)
  - [Lemma 4](#lemma-4)
- [Project scope](#project-scope)
- [Formalization map](#formalization-map)
- [Toolchain](#toolchain)
- [Verification policy](#verification-policy)

## Status of Lemmas 1, 3, and 4

**Bottom line:** the published proof of Lemma 1 is invalid, but its core
constant-probability claim now has a corrected proof formalized in Lean.  The
repair follows the draft's textual faulty-sample definition where its Step-1
display is inconsistent, and supplies an explicit rounding convention where
the schedule is underspecified; the goal is to prove the core mathematical
claim, not to reproduce the draft line by line.
The paper-shaped finite analytic replacement for the first probability bound
of Lemma 3 and the correct energy-budgeted form of its second bound are now
formalized.  A new natural-language two-copy Fourier calculation finds a
stronger obstruction: on a fault-free oracle, almost every Fourier mode of the
actual first-`a`-zero schedule is diagonal, so both the proposed `keep-u`
repair and, subject to one explicit guard estimate, the original Step-6
postselection give asymptotically unbiased output.  This negative calculation
is not yet formalized in Lean.  A global half-turn/ParityPGM replacement exists
as an exact information-theoretic measurement, and random fibres make its
whitening exponentially close to trivial on the occupied fibre-uniform
support.  None of the analyzed realizations yields polynomial cost; the
generic PREP/QSVT route has coherent scale `2^(n/2)`.  Lemma 4 and the paper's
headline algorithm theorem therefore remain unproved.

| Lemma | Status of the core claim | Published proof and repair status |
| --- | --- | --- |
| Lemma 1 | **Repaired and formalized** | The proposed low-part swap is invalid, so the repair replaces it rather than completing that argument. Restricted Parseval gives an unconditional inverse-polynomial bound, while the stronger route connects the corrected mixed correct/fault amplitudes, Step-2 joint law, complete Step-4 label, exact Born moments, collision-plus-Chebyshev bound, classical fault-environment averaging, and rounded parameters. For the padded repaired schedule with `k = 24`, `c = 12`, and every `n >= 1024`, the explicitly summed success event has mass at least `1/2`. This is the formalized constant-probability core needed from Lemma 1. |
| Lemma 3 | **Not repaired as support for the polynomial algorithm; standalone finite inequalities retained** | The published pairwise-independence argument fails after the adaptive choice of `A`. Lean proves an explicit paper-shaped signed-path identity and a joint `2^(-n)` finite-model bound under stated Step-2 energy and model-identification premises, plus the correct budgeted second-clause tail `C_n/L^2`; neither is yet an actual-circuit theorem with all paper premises discharged. Separately, a natural-language all-frequency two-copy calculation shows that the no-guard `keep-u` decoder has correct and wrong masses `1/2+o(1)` each. For the paper's zero-low-Hadamard step it predicts masses `1/(2L)+o(1/n)` each and acceptance `1/L+o(1/n)`; the concrete guard conclusion still needs its explicit Parseval perturbation estimate. The global ParityPGM candidate is information-theoretically sound but has no polynomial implementation. |
| Lemma 4 | **Decoder-facing conditional repair formalized; paper premises open and spectrally challenged** | The exponent, `mu`, and `n^(3/2)` bookkeeping errors are repaired. A finite corrected theorem gives high-probability additive control from explicit per-bin tails and relative control under an anti-cancellation lower bound. More directly, new Hadamard theorems convert squared additive mismatch into wrong-bit probability without any amplitude denominator, both for one qubit and for a distinguished bit entangled with arbitrary finite residual labels. Cauchy--Schwarz gives both finite high-probability and stronger expectation-level decoder repairs. The latter avoids a union bound over residual pairs and bins, composes with the explicit Step-7 double path sums, and reduces the probabilistic gap to selected-pair collision and diagonal path-energy bounds. Identifying the actual circuit coordinates with those sums remains open, while the clean-oracle calculation challenges the required branch closeness once its remaining guard estimate is completed. |

**Verdict on Lemma 3.**  Lemma 3 is **not repaired in the sense needed by the
paper's polynomial-time algorithm**.  What is complete is narrower: sound
finite-energy inequalities replace parts of its probability algebra.  The
original experiment still lacks the model-to-circuit/Step-2 energy bridge; the
second clause still lacks its adaptive energy budget; and the decoder has a
separate spectral obstruction.  The strongest positive replacement found is
a distributional ParityPGM whose ideal action is exact and whose random-fibre
normalization is benign.  Implementing it in polynomial time would itself
constitute a new one-bit DCP algorithm, and no such implementation is supplied
here.  This verdict does not claim that either isolated sentence of Lemma 3 is
false in every interpretation, or that a polynomial DCP algorithm is
impossible.

### Lemma 1

The Lean development proves that the change caused by the paper's simultaneous
swap of selection bits and low sample parts is

```text
B * (phi_j - phi_i) * (H_i - H_j).
```

This expression need not vanish modulo the measured subset-sum modulus.  A
locally valid `n = 8` instance changes the relevant contribution from `1` to
`5` modulo `128`.  Thus the proposed map does not preserve a measured fibre;
see [`SwapFiber.lean`](SimonDCP/Arithmetic/SwapFiber.lean).

The concrete `n = 8` witness is not a full member of the paper's event `D_Y`,
because that event imposes additional global distinctness conditions.  More
importantly, failure of this particular injection does not logically imply
that Lemma 1's constant-probability conclusion is false.  The injection
argument is refuted; the independent restricted-Parseval and
collision-plus-Chebyshev route below proves a repaired version of the core
conclusion.

[`SwapFiberRepair.lean`](SimonDCP/Arithmetic/SwapFiberRepair.lean) proves the
exact repair criterion: for a zero/one swap with measured modulus
`B * stride`, the original low-part operation is valid exactly when
`stride` divides `H_i - H_j`.  It also proves that permuting each complete
Fourier sample together with its selection and Hadamard-output coordinates is
a bijection preserving the subset sum, every measured residue fibre, the phase
exponent, and sample distinctness.

This repairs the algebraic map, but not the original Lemma 1 injection route;
that route is not needed by the completed replacement proof.  After Step 4,
terms with equal `(h, s_1, ..., s_g)` labels interfere.  A termwise
weight-preserving permutation proof must choose its map only from the measured
outcome and carry every such interference class through one fixed label
equivalence.  A weaker class map can still be useful if its target coherent
weight is proved directly to be at least the source weight.  The Lean module
formalizes the resulting group-level
tension: a complete-record permutation that stays within every Step-3 group
preserves the full group subset sums (and hence their high-bit `s_j` labels),
but provably leaves the number of all-zero Hadamard-output groups unchanged.
It therefore cannot implement the required `D_Y^bad`-to-`D_Y^good` step, which
must move outputs across groups.  Moving whole groups does not escape the
obstruction: Lean proves that it coherently relabels the group-sum vector but
only bijects the all-zero groups, leaving their cardinality fixed.  A successful
map must therefore mix coordinates between groups and prove a nontrivial fixed
relabeling theorem for the resulting `s_j` values.  The module packages the
remaining requirements as an explicit
`LemmaOneRepairCertificate`; this is only a structural interface.  Lean now
proves that every such certificate descends through the erased hidden selection
string to an injective map on measured outcomes.  It does not prove that their
probability weights do not decrease.  The separate
`MeasuredOutcomeWeightInjectionCertificate` states exactly that remaining
finite weighted-injection obligation, and Lean proves that any such certificate
implies total bad-event weight at most total good-event weight; no instance of
either certificate is assumed.

For the stronger label containing each *full* group subset sum, Lean proves a
rigidity theorem: outcome coherence permits one-coordinate hidden-selection
probes, and when every Fourier sample is nonzero these force any fixed
group-relabeling certificate to move whole groups.  Its all-zero-group count is
therefore unchanged.  This does not yet settle the paper's weaker label, which
stores only the most significant `log n` bits `s_j`; truncation can erase the
one-coordinate distinctions used by the rigidity proof.

The truncation escape is not automatic.  A concrete two-group, six-coordinate
witness uses samples `17, 34, 51, 68, 85, 153`, whose residues modulo `16` are
pairwise distinct.  On the measured fibre `z = 76 (mod 128)`, however, there
are four supported selections rather than only the two originally displayed.
All four have the complete local label `(h, s_a, s_b) = (1, 3, 9)`, and their
Hadamard signs are `+1, -1, -1, +1`.  The source outcome therefore has zero
coherent weight.  Swapping one coordinate across the groups splits this class
four ways and changes the normalized local weight from `0` to `1/64`.

[`LemmaOneFiniteSupportPrototype.lean`](SimonDCP/Arithmetic/LemmaOneFiniteSupportPrototype.lean)
checks the whole finite experiment.  Of all `720` coordinate permutations,
`288` create an all-zero group and `72` let the target full label factor through
the occupied source label; these are exactly the `72 = 2(3!)^2` permutations
that move the two groups as whole blocks.  None creates an all-zero group.  The
remaining `648` permutations all change the raw coherent weight from `0` to
`4`.  Moreover, all `27` six-bit outputs with at most three ones and no
all-zero group have raw source weight zero.  Thus the witness rules out an exact
interference-class repair by a useful coordinate permutation, but it does not
rule out a direct weight-nondecreasing repair: every local bad output is null.
The `/16` summary is a local truncation surrogate, not a complete instantiation
of the paper's relations among `n`, group size, and truncation width.

A different route avoids the swap entirely.  Restricted Parseval on the
Boolean cube gives, for every coordinate set `A`,

```text
Pr[D_A = 0 | Y, z'] >= 2^(-|A|).
```

Consequently the expected number of all-zero groups is at least
`(k/c) * n/log n`.  Boundedness alone yields probability
`(k-c)/(k*n^c-c) = Omega(n^(-c))` of reaching `n/log n` groups, which is already
amplifiable in polynomial time.  Requiring Boolean subset sums to be injective
on every union of two groups makes the group-zero indicators pairwise
independent; Chebyshev then gives failure probability
`O(log n/n)`.  The natural-language derivation, the fixed-environment theorem,
the rounded-parameter repair, optional circuit-level refinements, and the later
algorithmic obligations are recorded in
[`LEMMA1_REPAIR.md`](LEMMA1_REPAIR.md).

Lean now proves the restricted character identity, the collision-count form
of Parseval, and the diagonal lower bound after summing every occupied complete
Step-4 label.  It normalizes that bound to the exact rational baseline
`2^(-|A|)`, proves the finite weighted tail inequality, and simplifies the
paper's parameter ratio to `(k-c)/(k*n^c-c)`.  For the high-probability route,
Lean now also proves the uniform ternary collision bound `(3^a-1)/M`, transports
it to local Boolean subset-sum injectivity, and unions it over the complete
family of one- and two-group sets.  It aggregates the one-time-pad residue
fibres over an arbitrary finite selection support, derives the exact joint and
marginal count formulas with distinct `delta` and `epsilon` exceptional sets,
and specializes the normalized Bayes bound to an actual coordinate subcube.
The faulty fixed bits contribute only a selection-independent phase, and the
Boolean coordinate-subcube residue fibre is identified exactly with the mask
support used by restricted Parseval.  On that support Lean constructs the full
normalized Born weight, proves the exact one- and two-group moments under the
corresponding local subset-sum injectivity hypotheses, and derives the displayed
`O(log n/n)` Chebyshev bound after charging failures of those hypotheses to the
ternary-collision event.  It also bounds excessive faults by Markov from
per-coordinate fault marginals, without assuming fault independence.

The analytic fixed-environment composition is now also formalized.  The paper
describes a faulty sample as `|b,x>`, but its displayed Step-1 product formula
uses `x_i + b_i d` at every coordinate, including faulty ones.  The development
follows the stated faulty sampler: a correct coordinate uses `x_i + b_i d`,
whereas a faulty coordinate uses `x_i` and has no secret shift.
`MixedFaultPatternFourierProduct.lean` proves that this mixed analytic product
amplitude is the earlier coordinate-subcube amplitude times an explicit unit
secret phase.  `StepTwoMeasurementBridge.lean` identifies measurement of the
low `n-1` bits with the canonical quotient map, and
`StepTwoJointKernel.lean` proves the normalized joint law of the full Fourier
vector and that residue, pointwise equal after casting to the mixed-amplitude
Born mass summed over the measured fibre.  `FaultyHighBitCarry.lean` proves
that the fixed faulty offset contributes only a residue- and
environment-dependent unit phase; the remaining selection-dependent factor is
captured by the paper-style high bit `h`.  `ActualStepFourBorn.lean` then
factors the raw projected Hadamard amplitudes, computes their total mass, proves
that raw output mass divided by total mass is the normalized conditional
Step-4 Born weight, and identifies that weight pointwise with the labelled
Walsh law on every reachable Step-2 fibre.  Under the corresponding local
subset-sum injectivity hypotheses, it also obtains the exact one- and two-group
masses.

`LemmaOneFiniteModel.lean` combines the ternary collision bound, local
injectivity, Chebyshev, and outer averaging.  `LemmaOneFixedEnvironment.lean`
instantiates it with the Step-2 joint kernel and the analytic Step-4 Born law,
giving the collision-plus-tail bound, and a failure bound of `1/2` when each
summand is budgeted by `1/4`.  This closes the fixed-fault-environment analytic
model.  `LemmaOneFaultEnvironmentAveraging.lean` then proves that the same bound
survives every nonnegative normalized finite classical mixture of such
environments, even when positions, free coordinates, fixed bits, and group
summaries vary with the environment.  This is probability-level averaging,
not a QuantumAlg gate/tensor-circuit equality or a quantum density-mixture
construction.  The older exact arithmetic theorem
`LemmaOneExactParameters.lean` assumes a power-of-two security parameter and
exact divisibility.  For a padded repaired sample schedule,
`LemmaOneRoundedParameters.lean` removes both restrictions by taking
`ell = floor(log_2 n)`, rounding the number of complete groups upward, and
collecting fewer than one extra group of samples.  It proves the required
mean lower bound and explicit collision/tail budgets.  The end-to-end module
`LemmaOneRoundedFixedEnvironment.lean` gives failure mass at most `1/2` for
`k = 24`, `c = 12`, and every `n >= 1024`, including arbitrary normalized
finite classical fault-environment mixtures.  `LemmaOneRepaired.lean` defines
the complementary success event explicitly, proves that success and failure
masses sum to one, and exposes the direct success-mass-at-least-`1/2` theorem.
A density-matrix/channel
realization of the random fault process is an optional semantic refinement, not
an obligation for the analytic Lemma 1 repair.  The later algorithmic steps
remain open.

### Lemma 3

Step 4 selects `A` from blocks on which the measured mask `D` is zero.  Hence
`D_A = 0`, and

```text
(-1)^(phi dot D) = (-1)^(phi_B dot D_B).
```

States with the same `B` component and different `A` components therefore have
identical phases.  They are perfectly correlated rather than pairwise
independent, contrary to the variance argument in the proof sketch; see
[`PhaseCorrelation.lean`](SimonDCP/Quantum/PhaseCorrelation.lean).

This directly refutes the claimed phase-independence step.  It does not by
itself refute either isolated probability statement in Lemma 3.

A subsequent natural-language two-copy Fourier analysis reaches a stronger,
decoder-level conclusion in the fault-free model.  If `p_xi` is the exact
zero-group kernel in Fourier mode `xi`, then the first-`a`-zero rule has the
exact transfer

```text
A_xi = Pr[Binomial(G, p_xi) >= a].
```

All but polynomially many of the `N = 2^n` modes satisfy
`p_xi = (1+o(1))/q`, and the paper chooses `G/q > a`; hence almost every
diagonal mode is accepted.  In the proposed no-guard `keep-u` repair, the
exact terminal correct/wrong kernels are `p_xi-1/(2*q)` and `1/(2*q)`, so
their total masses are both `1/2+o(1)`.  For the original zero-low-Hadamard
postselection, the corresponding working asymptotics are

```text
P_correct = 1/(2*L) + o(1/n),
P_wrong   = 1/(2*L) + o(1/n),
P_accept  = 1/L + o(1/n),
```

where `L=n/2`.  The latter conclusion still needs the concrete guard's
Parseval perturbation estimate written out and formalized.  This does not
directly refute the weak first clause or isolated `alpha_z` bound, but it does
challenge the branch closeness required by Lemma 4 and the claimed
inverse-polynomial decoding bias.  The exact formulas, rigor boundary, and
local-repair tradeoff are recorded in
[`LEMMA3_SPECTRAL_OBSTRUCTION.md`](LEMMA3_SPECTRAL_OBSTRUCTION.md).

A different finite-model route bypasses only the earlier
pairwise-independence obstruction for the standalone first-clause inequality;
it does not bypass the decoder-level spectral obstruction.  For each
complete transcript and final branch, keep the original computational path in
the signed path expansion.  If every signed branch count is below the squared
well-behaved threshold `2^(-n) * t`, its model Born mass is pointwise bounded
by `2^(-n)` times its incoherent path energy.  The paper-shaped model now
proves that every compatible path injects into `(hidden,D)` and that the two
Hadamard factors turn normalized Step-2 diagonal energy into total common-path
energy at most `1/|Low| <= 1`.  This yields a joint bad mass at most `2^(-n)`
with no restriction on how the transcript or `A(D)` depends on `D`.  The
paper-shaped interface defines the record `(Y,D,W',S,h')`, its
compatibility relation, `h*` branch label, raw Hadamard factor, and model
`tPlus-tMinus` factorization.  It also defines the explicit finite coherent
sum over a transcript/branch fibre and proves that sum equals the signed-count
formula.  Equality of this finite analytic Born model with the concrete
circuit amplitude and circuit-level orthogonality of the residual branches,
together with the concrete Step-2 diagonal-energy premise, remain required
model-identification obligations.  Inserting the paper's outcome-dependent
conditional normalization `nu4` at this stage would be incorrect.

If the displayed probability is conditioned on an acceptance event of
inverse-polynomial mass, the literal exponent changes.  The formalized slack
theorem shows, for example, that a joint `2^(-n)` bound becomes a conditional
`2^(-floor(n/2))` bound once the explicit polynomial-versus-dyadic inequality
is supplied.  This paper-shaped conditional theorem is also formalized
directly.  Thus exponential negligibility survives even though the exact
`2^(-n)` scale need not.  A sharper budgeted theorem retains the common
`1/|Low|` factor: if the accepted mass is at least `kappa/|Low|`, then the
conditional bad mass is at most `2^(-n)/kappa`.  A constant lower bound on
`kappa` preserves the `n`-bit exponent up to a constant factor; an
inverse-polynomial `kappa` instead gives `poly(n) * 2^(-n)`, equivalently an
`n - O(log n)` exponent.  Proving a concrete Step-6 acceptance lower bound
needs a new hypothesis or repair: normalized input
mass alone does not imply it.  Lean proves that the normalized two-term low
state `(1,-1)/sqrt(2)` has zero all-zero Hadamard mass, and that an
environment-dependent retained event can turn an unconditional average
`1/2` into retained joint mass `0`.  In the formalized one-bit/two-outcome
case, retaining both Hadamard outcomes preserves total mass by Parseval.  That
fact repairs acceptance bookkeeping but does not repair decoding: the new
exact no-guard two-copy calculation shows that the multi-bit `keep-u` decoder
retains the diagonal modes and has conditional error `1/2+o(1)`.

For the second claim, let `C_n` be the total squared magnitude of the paper's
unnormalized adaptive `z*` contributions.  Born size bias gives the exact tail
`C_n / L^2` as a joint bound; hence the claimed joint scale at
`L = 2^(3n/2)` follows from the still unproved estimate
`C_n = O(2^(2*n))`.  Conditioning on acceptance mass `rho` adds a factor
`1/rho`.  Measurement completeness does not give
`C_n <= 1`: the paper restricts the pre-Hadamard paths using `A(D)` before
coherently forming outcome `D`, whereas measuring `D` first gives the opposite
operator order and a different sector.  An equal-amplitude four-bit
Walsh toy model inspired by the Step-2 fibre has normalized coarse mass `1`
but adaptive sector energy `4/3`.  It refutes the generic normalization
inference, not the paper-specific asymptotic bound.  The general finite
inequalities and arbitrary adaptive transcript
partition are machine-checked in
[`LemmaThreeBornBounds.lean`](SimonDCP/Probability/LemmaThreeBornBounds.lean)
and
[`LemmaThreePathRefinement.lean`](SimonDCP/Probability/LemmaThreePathRefinement.lean).

The high-bit bucket version has the same normalization issue: at squared
threshold `n^3`, a conditional `O(1/n)` tail needs conditional bucket energy
`O(n^2)`, or a joint budget `O(rho * n^2)` before conditioning on acceptance
mass `rho`.

There is now also a conservative abstract theorem that requires no
independence or orthogonality of the adaptive labels.  Complex
Cauchy--Schwarz bounds their total coherent energy by the largest
outcome-dependent fibre times an explicitly normalized fine-amplitude energy.
Thus, once that normalization is supplied, a fine space of size at most
`2^(c*n)` is safe at squared threshold `2^((c+1)*n)`, giving a joint `2^(-n)`
tail.  The paper-facing bridge must still identify its actual `u(M,z)` with
such a Boolean fine-amplitude model and prove the fine-energy premise.  For
`c = 12` the machine-checked abstract specialization uses squared threshold
`2^(13*n)`, far larger than the paper's `2^(3*n)`.  Substituting
the conservative amplitude exponent into the corrected Lemma 4 calculation
is also machine-checked: all `c*n` terms cancel and the aggregate exponent is
`7*n/2 + faultLoss/2 + c*logN/2`, so this conservative repair cannot establish
the downstream algorithm.

An abstract route that avoids the incompatible pointwise threshold is
formalized at the analytic core.  A complex Cauchy--Schwarz theorem bounds
the squared error of `sum_z (count_z-mean) * C_z` by the product of the total
count `L2` error and the total coefficient energy.  A restricted-Parseval
specialization rewrites that coefficient energy as a Walsh
projection-collision energy, so no `max_z |alpha_z|` premise is needed.  The
next algebraic bridge is now also proved: the explicit A-side/B-side double
path sum regroups exactly as `sum_z count_z * C_z`, and its raw-scale error has
the expected L2 product bound.  The coefficient energy is expanded exactly as
a within-residue ordered-collision sum.  The paper application still must
instantiate the concrete Step-5--7 path/residue maps and prove the conditioned
count-energy and collision-energy bounds.  For the count side, Lean now proves
the exact selection-aware theorem: if every distinct pair's weighted
selected-and-colliding moment is `1/m` times its weighted selected-pair moment,
then the weighted actual-mean count energy is `(1-1/m) E[T]`.  A probability
interpretation additionally needs nonnegative normalized transcript weights.
It also proves a two-bit example
where unconditioned hashes are jointly uniform but conditioning them to be
equal raises the count energy from the independent baseline `1` to `2`.
Therefore bare pairwise independence before fixing the transcript is not
enough.  The application also needs an ideal-amplitude
lower bound for the paper's multiplicative conclusion, or a global
state-distance replacement.  The new spectral calculation shows that these
premises are not satisfied by the present decoder merely by retaining `u` or
all low Walsh outcomes; the general L2 lemmas remain valid, but they are not a
repair of the current circuit.

Further frame analysis localizes the obstruction.  The adaptive first-zero
choice is controllable in a diagonal complete-label surrogate, whose
combinatorial weight is at most `choose(G,a) / q^a`, hence
`2^(O(n/log n))` at the paper's parameters.  The exact finite incidence and
cleared-denominator surrogate bound are machine-checked; identifying it with
the actual circuit frame operator remains open.  Coherently merging that
string into `(z,W)` is
the expensive step.  A machine-checked Cauchy bound shows that a domain of
size `2^(c*n)` compressed into at most `2^(2*n)` equal-phase labels must have
large squared fibre mass; this isolates the coherent `A`-fibre factor without
claiming that later `B`-side signs and filters preserve it.  An exact random-`Y`
calculation in the reduced model
before the later `S/W` filters gives energy
`Theta(P_accept * 2^((c-1)*n))`; accounting heuristically for the available
`A`-side Step-6 labels leaves `2^((c-2)*n)/poly(n)`.  At `c = 12` this makes the
required `O(2^(2*n))` budget strongly implausible.  It is not yet a full
counterexample because the complete `S/W` correlations and postselection have
not been included in a rigorous lower bound.

The remaining work now splits in two.  The standalone finite inequalities
still need the stated model-identification, Step-2 energy, adaptive-sector
budget, and normalization bridges.  The core algorithm needs more than those
bridges: the new spectral calculation shows that retaining all low outcomes
does not create decoding bias, and strongly indicates that the original
postselection does not either.  The next negative formalization target is the
exact two-copy kernel and guard estimate.  A positive algorithmic repair would
need a genuinely global half-turn fibre-erasure primitive, not another local
acceptance or collision lemma.  The information-theoretic primitive, an exact
signed-frame operator whose polar part is the required half-turn swap, and the
currently known implementation barriers are analyzed in
[`LEMMA3_HALF_TURN_ERASER.md`](LEMMA3_HALF_TURN_ERASER.md).  Generic
postselection, amplitude amplification, block encoding, and coherent fibre
sampling all expose a `sqrt(2^n)` cost.  The follow-up random-instance analysis
shows that fibre balance makes the PGM whitening nearly the identity; the
remaining hard operation is coherent synthesis/index erasure, not matrix
conditioning.  FFT/Schur, tensor-network, 2-adic recursion, hashing, lattice,
local-relation, sampling, and ordinary or variable-time QSVT routes did not
remove that cost.  A direct two-outcome half-turn test may be strictly weaker
than full fibre erasure, so this is an open algorithmic direction rather than
an impossibility theorem.  A polynomial implementation would already be a new
one-bit DCP decoder.  Only the deterministic
Step-6 carry/top-bit bridge is closed: for a power-of-two word width and the concrete
schedule `a = floor(2^ell/ell)`, which is machine-checked to satisfy
`a*ell <= 2^ell`, under the convention
`tau = floor(log_2 ell)`: the paper's `l_(s*) = 0` test excludes both exact
carry windows, so the computed top bit equals the complete subset-sum top bit.
Upward rounding is not interchangeable; a machine-checked `n = 32`
counterexample passes the narrower test while a legal carry flips the top bit.
Conditional versus joint probability after Step-6 postselection is now stated
explicitly in the finite API, but the acceptance lower bound is open and does
not follow from normalization alone.  The full
argument and boundary are recorded in
[`LEMMA3_REPAIR.md`](LEMMA3_REPAIR.md).

### Lemma 4

The development gives finite counterexamples to three inference patterns used
in or around the proof:

- independent Boolean coordinates can become perfectly correlated after
  conditioning;
- adding a correlated overflow bit can turn a balanced bit into a constant;
- nearly equal counts of signed terms give no multiplicative control of an
  amplitude when cancellation is possible.

See [`Conditioning.lean`](SimonDCP/Probability/Conditioning.lean) and
[`AmplitudeCancellation.lean`](SimonDCP/Quantum/AmplitudeCancellation.lean).

The page-14 exponent does admit a local repair.  The standard-deviation
exponent already contains `-n`, so multiplication by `kappa' = 2^n` must cancel
that term.  The printed calculation instead retains an extra `+n`.  Correcting
it changes the total exponent at `c = 12` from

```text
-n/2 + 6n/(c' log n) + 6 log n,
```

to

```text
-3n/2 + 6n/(c' log n) + 6 log n.
```

Consequently the desired exponent is at most `-n` under the explicit budget
`12n/(c' log n) + 12 log n <= n`.  The same module proves that the amplitude
sum factors out the mean bin multiplicity `mu`, not the total `|A_(g_a)|`, and
that retaining the actual `n^(3/2)` bound gives polynomial exponent `-2` at
`c = 12`.  These repairs are in
[`Lemma4Parameters.lean`](SimonDCP/Probability/Lemma4Parameters.lean).

[`Lemma4Repair.lean`](SimonDCP/Probability/Lemma4Repair.lean) now packages the
valid deterministic conclusion of the proposed balls-in-bins step. If the two
high-bit branches have bin counts within `error` of one common mean and every
signed coefficient has magnitude at most `coefficientBound`, their amplitudes
differ additively by at most

```text
2 * numberOfBins * error * coefficientBound.
```

The same file proves that this becomes a relative, multiplicative estimate
only after assuming an explicit positive lower bound on one reference
amplitude. That anti-cancellation lower bound, or a replacement such as phase
alignment, is the precise additional obligation missing from the sketch.

The literal multiplicative comparison is not needed by the final decoder.
[`ApproximateReadout.lean`](SimonDCP/Quantum/ApproximateReadout.lean) proves
against the concrete Hadamard gate that, for any normalized surviving qubit,
the wrong-bit probability is exactly one half of the squared additive mismatch
between its two signed branch amplitudes.  Thus mismatch norm at most
`epsilon` gives correct-bit probability at least

```text
1 - epsilon^2 / 2.
```

The paper has not actually eliminated every other label before applying the
Hadamard to `h*`.  The same module therefore proves the correct labelled
version against the concrete QuantumAlg gate `H ⊗ I`.  For normalized paired
amplitudes `a_x, b_x` over any finite residual register and target sign
`s = (-1)^d`,

```text
Pr[wrong bit] = (sum_x normSq(b_x - s*a_x)) / 2.
```

It also proves the precise inference used in the paper's last paragraph: if
`sum_x norm(b_x - s*a_x) <= epsilon`, then the correct-bit mass is at least
`1 - epsilon^2/2`.  Thus no pure-qubit factorization assumption is hidden in
the repaired decoder.

[`Lemma4Decoder.lean`](SimonDCP/Probability/Lemma4Decoder.lean) composes this
identity with the existing complex Cauchy--Schwarz route.  If
`countBudget` bounds the squared L2 distance between the two branch-count
functions and `coefficientBudget` bounds the total squared coefficient energy,
then the final readout succeeds with probability at least

```text
1 - normSq(scale) * countBudget * coefficientBudget / 2.
```

For uniform pointwise count error `error`, Lean supplies
`countBudget = 4 * numberOfBins * error^2`.  This is a decoder-facing repaired
Lemma 4 with no anti-cancellation assumption.  Applying it to the paper still
requires a proof that the actual conditioned Step-7 amplitude pairs have the
stated weighted-amplitude coordinates and that their count and coefficient
energy budgets hold.  The labelled theorem sums the Cauchy--Schwarz budget
over every residual amplitude pair, so this remaining premise is no longer
artificially phrased as a single pure qubit.  Its strongest form starts from
an actual normalized `1+n` qubit state and bounds the first-qubit marginal Born
probability after applying `H ⊗ I`.

The decoder theorem is also lifted through the finite union bound: if every
bin in both branches has deviation-event mass at most `tail`, then records
whose final qubit satisfies the displayed readout guarantee have total mass at
least

```text
1 - 2 * numberOfBins * tail.
```

This is an end-to-end conditional probability statement within the finite
model, not merely a deterministic estimate.

The labelled actual-state theorem now has its own finite probabilistic lift.
If every residual amplitude pair and every low-part bin in both branches has
deviation-event mass at most `tail`, then the records whose concrete `H ⊗ I`
first-qubit marginal satisfies the labelled decoder bound have mass at least

```text
1 - 2 * numberOfPairs * numberOfBins * tail.
```

This union bound assumes no independence between pairs, bins, or branches.  It
does not prove the required conditional tail premises for the paper's adaptive
experiment.

[`Lemma4AverageDecoder.lean`](SimonDCP/Probability/Lemma4AverageDecoder.lean)
proves a stronger repair targeted at the algorithm's actual objective.  The
algorithm needs the decoded bit to be correct on average over its classical
measurement records; it does not need every record and every bin to be good
simultaneously.  If the expected scaled Cauchy--Schwarz mismatch budget is at
most `epsilon`, Lean proves directly for the concrete `H ⊗ I` gate that the
overall correct-bit probability is at least

```text
1 - epsilon / 2.
```

The same module bounds paired count distance by twice the two branches'
count-error energies about a common centre.  Its paper-facing theorem then
uses the exact adaptive balls-in-bins second moment already formalized in
`LemmaThreeCountEnergy.lean`.  The required hypothesis is selected-pair
collision uniformity: selection belongs inside the collision moment.  Bare
pairwise independence before the paper's adaptive conditioning does not imply
this premise.  This expectation route removes the exponential two-layer union
bound and pointwise maximum deviations; the remaining Step-7 coordinate,
selected-collision, equal-population, and scale/coefficient-energy premises
are explicit.  The module also instantiates the earlier equal-bit conditioning
example and proves that its selected process violates
`WeightedPairCollisionUniform`, despite the two underlying bucket labels being
jointly uniform before conditioning.

[`Lemma4StepSevenAverage.lean`](SimonDCP/Probability/Lemma4StepSevenAverage.lean)
then plugs the explicit Step-7 double path sums into this average decoder.
The existing regrouping identity discharges the abstract weighted-amplitude
coordinates inside the finite path model.  A new universal estimate gives

```text
coefficient energy
  <= number of compatible B-paths * total diagonal B-path energy.
```

More sharply, a second theorem replaces the total number of B paths by the
largest cardinality of any B-residue fibre.  This estimate is propagated all
the way through the selected-pair collision decoder, and has factor one when
the B-residue map is injective.

There is a matching obstruction: Lean proves
`#BPaths <= #Residues * maximum fibre size`.  When all B terms are the same
complex number, it also proves that coefficient energy is exactly that term's
squared magnitude times the sum of squared fibre sizes, and hence is at least
`normSq(common) * #BPaths^2 / #Residues`.  The sharper upper bound therefore
helps only when the concrete conditioned B-side construction has genuinely
small fibres; otherwise cancellation or orthogonality is essential.

[`Lemma4PaperDecoder.lean`](SimonDCP/Probability/Lemma4PaperDecoder.lean)
specializes the additive decoder to the paper-facing complete transcript
`M = (Y,D,W',S,h')`.  The existing finite path bridge gives the two `hStar`
branches one common raw amplitude, so Lean computes their total decoder
mismatch exactly.  Using `h xor hStar = h'`, it then factors out both the
secret-bit phase and the measured-`h'` phase.  The exact remaining quantity is

```text
sum_M normSq(normalization(M) * commonAmplitude(M)) *
  (WalshSignedCount(M,1) - WalshSignedCount(M,0))^2.
```

This removes the separately postulated coefficient family inside the
paper-path model and avoids any amplitude denominator.  It does not assume
that the paper's pre-conditioning pairwise independence controls this
quantity: the remaining mathematical task is precisely to bound this
Walsh-signed L2 branch mismatch after the full adaptive transcript has been
fixed, and to identify the finite path amplitudes with the circuit state.

[`Lemma4AdaptiveWalshEnergy.lean`](SimonDCP/Probability/Lemma4AdaptiveWalshEnergy.lean)
expands that exact mismatch over ordered pairs of fixed hidden states.  The
complete transcript selection—including `D`, acceptance, `W'`, `S`, and
`h'`—and the transcript-dependent normalization remain inside every pair
correlation.  Lean proves the exact decomposition

```text
Walsh mismatch energy
  = compatible common-path diagonal energy
    + adaptive off-diagonal hidden-pair correlation.
```

The diagonal term is bounded by
`normalizationBound / card(Low)` using the existing Step-2 path-energy theorem.
Consequently an off-diagonal upper bound `delta` gives decoder success at
least `1 - (normalizationBound / card(Low) + delta)/2`; exact adaptive pair
orthogonality is the case `delta = 0`.  This identifies rather than assumes
away the remaining probabilistic premise.  Fixed-support Parseval or bare
pairwise independence before adaptive transcript selection does not by itself
establish it.

[`Lemma4AdaptiveWalshFibre.lean`](SimonDCP/Probability/Lemma4AdaptiveWalshFibre.lean)
gives a cancellation-free sufficient condition for that remaining term.  Let
`K` bound the number of hidden states compatible with any one complete
transcript after all filters.  Each survivor contributes only a sign, so
Cauchy--Schwarz and the exact diagonal identity give

```text
Walsh mismatch energy
  <= K * compatible common-path diagonal energy
  <= K * normalizationBound / card(Low).
```

The corresponding concrete decoder succeeds with probability at least
`1 - K * normalizationBound / card(Low) / 2`.  If the complete transcript
separates compatible hidden states, `K = 1`; unconditionally Lean can only use
`K = card(Hidden)`, which may be exponential.  Thus this route replaces the
adaptive cancellation premise by a precise conditioned-fibre bound, but does
not claim that the paper proves that bound.

[`Lemma4AdaptiveWalshFibreObstruction.lean`](SimonDCP/Probability/Lemma4AdaptiveWalshFibreObstruction.lean)
records the matching pigeonhole constraint.  Compatible hidden states over
all complete transcripts are exactly the compatible fine paths, so any
uniform fibre bound must satisfy

```text
#compatible paths <= #complete transcripts * K.
```

Lean also proves the corresponding lower bound on the sum of squared fibre
sizes.  Thus transcript separation or polynomial `K` must be derived from the
actual surviving-path and transcript cardinalities; it cannot be assumed from
the existence of the complete record.  Connecting the paper's displayed
exponential mean `mu` for A-state portions to this exact compatible-path count
would require the still-missing concrete experiment bridge.

The same module now gives the exact conditional bridge for that comparison.
Any paper bin whose state portions are all compatible with one complete
transcript is a subfibre, so deviation at most `error` from the displayed mean
forces `mu <= K + error`.  At `c = 12`, under the paper's parameter budget and
half-relative bin error, Lean derives

```text
2^(9*n) / 2 <= K.
```

Thus the paper's own near-uniform, exponentially populated bins would rule
out a polynomial complete-transcript fibre bound once the concrete bin-to-path
identification is supplied.  A useful Lemma 4 repair would then have to retain
the transcript normalization quantitatively or exploit actual Walsh-sign
cancellation rather than cardinality alone.

[`Lemma4AdaptiveWalshNormalizedFibre.lean`](SimonDCP/Probability/Lemma4AdaptiveWalshNormalizedFibre.lean)
formalizes the first of those two routes.  It never separates normalization
from fibre multiplicity: if every complete transcript satisfies

```text
normSq(normalization(M)) * compatibleHiddenCount(M) <= B,
```

then Lean proves Walsh mismatch at most `B / card(Low)` and concrete decoder
success at least `1 - B / (2 * card(Low))`.  In particular, `B = 1` recovers
the ideal exponentially small mismatch even for exponentially large raw
fibres, provided the actual postmeasurement normalization supplies their
reciprocal scale.  This is a genuine normalization-aware repair, not a
consequence of average state normalization; deriving the pointwise product
bound from the paper's concrete circuit remains the next obligation.

Consequently the fully composed finite theorem needs no separately postulated
coefficient family or per-bin concentration event.  Its remaining hypotheses
are that the actual state coordinates equal the direct path sums with a common
B-side path/residue/term family in both branches, the selected A-side pairs
have the required collision moment and equal branch populations, and the
displayed diagonal B-side budget is uniformly small.  The universal
cardinality factor can be exponential; the sharper route instead requires a
small conditioned B-residue fibre bound.  If neither is available, the need
for a Parseval or orthogonality estimate in the concrete experiment remains.

The repair is also lifted to a normalized finite probability space. If every
bin in each of the two branches has deviation-event mass at most `tail`, Lean
proves additive success mass at least

```text
1 - 2 * numberOfBins * tail.
```

With a uniform positive reference-amplitude lower bound, the relative success
event has the same mass. The existing finite pairwise-Bernoulli Chebyshev
theorem can supply each per-bin tail when the required conditional moment
identities are available; the repair deliberately does not infer them from the
paper's unconditioned distribution.

Even without correcting the extra `+n`, the printed exponent at `c = 12` is
`-n/2 + o(n)`.  If this were first established as a simultaneous absolute
error bound on normalized amplitudes, it would absorb every downstream
polynomial factor.  Thus the exponent typo is repairable and is not the
decisive obstruction to Lemma 4.

The repaired finite theorems do not establish conditional concentration,
coefficient energy, or the Step-7 amplitude-family identification for the
paper's actual experiment. The original multiplicative-amplitude claim of Lemma 4
therefore remains unproved, but the final decoder no longer needs that claim:
the new additive route isolates strictly weaker premises. The detailed audit
is in [`AUDIT.md`](AUDIT.md).

## Project scope

This Lean 4 project formalizes and audits Daniel R. Simon's preliminary draft
[*A Polynomial-Time Quantum Algorithm for the Dihedral Coset Problem*](https://eprint.iacr.org/2026/1591)
(IACR ePrint 2026/1591).

The draft's headline theorem is not currently represented as a proved Lean
theorem. Its proof relies on several false or unproved intermediate claims. The
development therefore starts with the sound algebraic kernel and kernel-checkable
obstructions to the invalid proof steps. It does not use `sorry` or hide gaps as
axioms.  Within that larger open program, the repaired core claim of Lemma 1 is
now a proved Lean result; the remaining headline-theorem gaps occur later.

## Formalization map

- `Quantum/IdealCosetSample.lean` defines the normalized ideal DCP sample in
  QuantumAlg and proves its exact two-point Born distribution.
- `Quantum/FourierShift.lean` proves the corresponding `ZMod` DFT translation
  and relative-phase identities using Mathlib's exact sign convention.
- `Quantum/Step2Phase.lean` proves the root-of-unity factorization that exposes
  the least significant bit of the hidden shift.
- `Arithmetic/TranslationFiber.lean` proves the valid high-bit translation
  argument underlying Lemma 2.
- `Quantum/PhaseTransfer.lean` proves the measured-XOR phase transfer used at
  the end of the proposed algorithm.
- `Quantum/BitReadout.lean` proves that one Hadamard gate reads an exact
  `(-1)^bit` relative phase with probability one.
- `Quantum/ConditionalReadout.lean` packages the final result under the exact
  balanced-amplitude premise that the paper would still need to prove.
- `Quantum/PhaseCorrelation.lean`, `Probability/Conditioning.lean`, and
  `Quantum/AmplitudeCancellation.lean` isolate the failures in Lemmas 3 and 4.
- `Probability/LinearPhaseIndependence.lean` proves the correct unconditioned
  joint-uniformity theorem for distinct nonzero binary linear forms.
- `Probability/ConditionalLinearForms.lean` proves the exact fixed-affine
  replacement criterion: conditional joint uniformity is equivalent, on a
  reachable fibre, to rank-two surjectivity on the condition kernel.  This is
  an audit interface rather than the main adaptive Lemma 3 repair.
- `Probability/LemmaThreeBornBounds.lean`,
  `Probability/LemmaThreePathRefinement.lean`, and
  `Probability/LemmaThreeUniformWalshPaths.lean` prove the independence-free
  `2^(-n)` joint small-branch bound, including equal-amplitude Step-2/Walsh
  path normalization for later filters encoded as compatibility subsets.
  Additional coherent transforms must be represented by additional fine-path
  coordinates in the paper-facing instantiation.
  `Probability/LemmaThreeTranscriptModel.lean` expresses fine paths as
  compatible `(transcript, hidden selection)` pairs.
  `Probability/LemmaThreePaperPathBridge.lean` instantiates the paper-shaped
  Step-3--7 records, signs, raw common factor, and an explicit finite-fibre
  sum with a proved `tPlus-tMinus` factorization.
  `Probability/LemmaThreePaperPathEnergy.lean` proves compatible-path
  injectivity, the exact Hadamard energy factor, total common-path energy at
  most `1/|Low|`, and the direct joint `2^(-n)` theorem.  Actual
  circuit-amplitude/Born identification and residual-branch orthogonality
  remain required application obligations, along with the concrete Step-2
  diagonal-energy theorem.
  `Probability/LemmaThreeToFourL2.lean` gives the Cauchy/Parseval `L2` route
  from count errors to additive amplitude error without any pointwise
  implicit-amplitude maximum.
  `Probability/LemmaThreeStepSevenRegrouping.lean` proves the exact finite
  A/B double-sum regrouping into `sum_z count_z*C_z`, its raw-scale L2 error
  bound, and the coefficient-energy collision identity.
  `Probability/LemmaThreeCountEnergy.lean` proves the exact centering and
  collision identities for the A-side counts, the correct selection-aware
  weighted second-moment theorem, and a conditioning counterexample to using
  unconditioned pairwise independence.
  `Probability/LemmaThreeSectorRefinement.lean` proves the correct `C/L^2`
  adaptive-sector tail, while
  `Probability/LemmaThreeAdaptiveFibreUpperBound.lean` proves the conditional
  maximum-fibre upper bound from normalized fine energy and the conservative squared threshold
  `2^((c+1)*n)`.  `Probability/LemmaThreeConservativeThresholdImpact.lean`
  proves that this larger threshold is incompatible with the existing
  Lemma-4 exponent calculation.
  `Probability/LemmaThreeBooleanFinePathUpperBound.lean` instantiates the
  bound for `Fin (c*n) -> Bool`, including the explicit `c = 12` threshold.
  `Probability/LemmaThreeAdaptiveSectorCounterexample.lean` proves exact
  coarse mass `1` versus adaptive energy `4/3` in a four-bit
  Walsh toy/operator-order model.  `Probability/LemmaThreeCoherentFibreObstruction.lean`
  proves the deterministic Cauchy lower bound on equal-phase fibre energy.
  `Probability/LemmaThreeFirstZeroFrame.lean` proves the exact incidence and
  `choose(G,a)/q^a` diagonal-surrogate bound for the first-zero rule.
  `Probability/LemmaThreePostselection.lean`,
  `Probability/LemmaThreePostselectionSlack.lean`, and
  `Probability/LemmaThreePaperFirstClause.lean` package the exact acceptance
  loss, its exponent-slack absorption, and the direct conditional
  paper-shaped first-clause theorem.  `Probability/LemmaThreeFiniteRepair.lean`
  packages the more general combined conditional finite theorem.
  `Probability/LemmaThreeBudgetedFirstClause.lean` retains the sharper
  `1/|Low|` energy and proves its cancellation against an acceptance lower
  bound of the same scale.
  `Probability/LemmaThreeStepSixAcceptance.lean` gives the exact all-zero
  Hadamard formula, normalized destructive-interference and conditioning
  counterexamples, and the two-outcome Parseval identity.  The identity fixes
  acceptance accounting, but the natural-language two-copy calculation in
  `LEMMA3_SPECTRAL_OBSTRUCTION.md` shows that keeping all low outcomes does
  not fix the decoder bias.
  `LEMMA3_REPAIR.md` records the
  natural-language proof and the remaining adaptive energy/Step-3--7 bridge.
- `Arithmetic/LemmaThreeStepSixCarry.lean` proves the exact omitted-low-part
  carry, its two vulnerable boundary windows, and top-bit correctness outside
  them.  `Arithmetic/LemmaThreeStepSixBitBridge.lean` proves that the
  floor-rounded paper bit test excludes those windows for `n = 2^ell`; its
  end-to-end corollary instantiates `a = floor(2^ell/ell)`.  It also gives a
  finite counterexample to using upward rounding instead.
- `Arithmetic/SampleRecursion.lean` proves the arithmetic of deleting a known
  low bit and halving an ideal DCP sample.
- `Arithmetic/SwapFiber.lean` gives an `n = 8` locally valid two-coordinate
  counterexample to the fibre-preserving algebra used in Lemma 1, together
  with the general error formula.
- `Arithmetic/SwapFiberRepair.lean` proves the exact matching condition, the
  complete-coordinate permutation identity, and partial certificate interfaces
  for the still-missing Step-4 interference and measured-weight arguments.
- `Arithmetic/LemmaOneFiniteSupportPrototype.lean` models the complete local
  `(h, s_a, s_b)` label, exhausts the six-coordinate support and all `720`
  coordinate permutations, and computes exact coherent weights for all `64`
  measured output masks.
- `Probability/RestrictedParseval.lean` proves restricted Walsh orthogonality
  and the finite signed-amplitude Parseval identity used by the swap-free
  repair.
- `Probability/LabelledParseval.lean` sums that identity across arbitrary
  occupied coherent labels and proves the exact `2^(Q-|A|) * |Z_Y|` diagonal
  lower bound.
- `Probability/LabelledBornProbability.lean` divides by the exact
  `2^Q * |Z_Y|` denominator and proves the normalized lower bound
  `2^(-|A|)` for every nonempty finite support.
- `Probability/BoundedTail.lean` proves the finite weighted first-moment bound
  that turns a lower expectation bound into an explicit upper-tail mass.
- `Probability/ResidueConditioningBound.lean` proves the exact rational Bayes
  loss and its dyadic affine-dimension specialization, conditional on the
  finite experiment's joint- and marginal-mass premises.
- `Probability/OneTimePadCounting.lean` constructs the translation equivalence
  showing that one selected free coordinate outside a local event makes all
  residue fibres equicardinal after the local samples are fixed.
- `Probability/AffineResidueCounting.lean` aggregates those fibres over an
  arbitrary finite selection support, proves the bad-inside joint-count bound,
  and separately computes the full-sample marginal with only the zero mask as
  an exceptional selection.
- `Probability/FiniteConditioningMass.lean` normalizes the natural-number joint
  bound and marginal identity into exact rational masses.
- `Probability/ResidueConditioningAssembly.lean` identifies the inside/outside
  sample split and assembles the count lemmas with the rational Bayes theorem.
- `Probability/TernarySubsetSumBound.lean` proves the exact `3^a-1` relation
  count, the one-relation `|G|^(a-1)` bound, and the normalized collision bound
  `(3^a-1)/|G|` under uniform sampling.
- `Probability/TernaryProjectionBridge.lean` transports ternary collision
  freeness to Boolean subset-sum injectivity on a prescribed local coordinate
  set, with exponent equal to the local cardinality rather than the ambient one.
- `Probability/SimultaneousLocalInjectivity.lean` and
  `Probability/GroupUnionFamily.lean` union these local failures over every
  one- and two-group set, giving the explicit `N^2` family-size bound without
  assuming independence between local events.
  `Probability/RectangularGroupPartition.lean` supplies exact-size,
  pairwise-disjoint groups and their Born/union-bound interfaces when the
  coordinate count is exactly `N*m`.
- `Probability/CoordinateSubcubeSupport.lean` proves the exact cardinality and
  the two branches of the exceptional `delta` count for fixed faulty bits;
  `Probability/CoordinateSubcubeParameters.lean` turns these counts into the
  dyadic conditional Bayes estimate, and
  `Probability/CoordinateSubcubeConditionalInjectivity.lean` supplies its
  explicit local ternary prior factor after integrating out irrelevant inside
  coordinates.  `Probability/CoordinateSubcubeConditionalFamily.lean` places
  all local events on one residue-conditioned space and proves sum and uniform
  family-cardinality bounds.
- `Probability/FaultySamplePhase.lean` and
  `Probability/BooleanMaskBridge.lean` show that fixed faulty selections add
  only a common group-character factor and identify the Boolean residue fibre
  exactly with the mask support used by Parseval.
- `Quantum/FaultyBasisSample.lean` proves the missing one-coordinate quantum
  facts: a faulty basis sample has a uniform Fourier-position outcome, its
  fixed branch bit has uniform Hadamard readout, and that bit contributes only
  the expected unit phase.  `Quantum/FaultPatternProductAmplitude.lean`
  constructs the normalized product selection state for an arbitrary fault
  pattern and proves that its Born support is exactly the coordinate subcube.
  `Quantum/FaultPatternFourierProduct.lean` extends an explicit phase-free
  product amplitude through every position DFT and proves that its joint
  Fourier sample `Y` is exactly uniform, independently of the fault pattern
  and fixed bits.  `Quantum/MixedFaultPatternFourierProduct.lean` replaces the
  phase-free formula by the analytic mixed correct/fault amplitude for one
  fixed environment and proves exact equality up to an explicit unit secret
  phase, preserving pointwise support and squared norms.  The paper's Step-1
  display shifts faulty coordinates despite describing the faulty sampler as
  `|b,x>`; this module follows the latter and applies no secret shift at a
  faulty coordinate.  It remains an analytic amplitude identity, not a
  gate/tensor-circuit construction.
- `Probability/StepTwoMeasurementBridge.lean` models the measured low
  `n-1` bits by the canonical quotient from `ZMod (2^n)` to
  `ZMod (2^(n-1))` and identifies its Boolean fibre exactly with the
  coordinate-subcube mask fibre.  `Probability/StepTwoJointKernel.lean`
  normalizes the joint Fourier-vector/residue counting law, proves its exact
  total mass and local uniformity, and identifies its real cast pointwise with
  the analytic mixed Born mass on the measured fibre.
- `Probability/FaultyHighBitCarry.lean` computes the affine borrow/carry from
  the fixed faulty offset.  After conditioning on the Step-2 residue, that
  contribution is a common unit phase and no extra carry label is needed beyond
  the paper-style high bit `h`.  Together with
  `Probability/StepFourLabelPhaseBridge.lean`,
  `Probability/ActualStepFourBorn.lean` identifies the analytic conditional
  Step-4 output law pointwise with the labelled Walsh law on each nonempty
  measured fibre, derives its normalization directly from the raw projected
  amplitudes, and proves exact one- and two-group zero-event masses under local
  injectivity.
- `Probability/CoordinateSubcubeProjection.lean` and
  `Probability/CoordinateSubcubeBorn.lean` prove exact diagonal Parseval and
  exact one- and two-group zero-event masses using injectivity only on the free
  local coordinates.
- `Probability/LabelledBornPairwiseTail.lean` constructs the complete normalized
  output weight, supplies the Bernoulli mean and pair-moment hypotheses, and
  derives the paper-facing `O(log n/n)` lower-tail estimate together with
  `Probability/LemmaOneChebyshevParameters.lean`.
- `Probability/FaultCountMarkov.lean` and
  `Probability/FaultPatternSupportBridge.lean` identify the actual free-set
  cardinality and control the loss of half the free coordinates;
  `Probability/RandomFixedBitsMixture.lean` proves that uniformly random free
  bits together with uniformly random fixed-fault bits push forward to the
  uniform full Boolean mask, independently of the fault partition;
  `Probability/LemmaOneGoodEnvironment.lean` combines excessive faults with
  local-collision failure on the prior environment space.  None of these steps
  assumes independence of the fault coordinates or exceptional events; this
  theorem is not itself a posterior bound after fixing a measured residue.
- `Probability/LemmaOneOuterAveraging.lean` proves injectivity monotonicity and
  the shorter total-probability assembly: prior bad-environment mass `p` plus a
  uniform good-environment conditional tail `q` gives total failure at most
  `p+q`.
- `Probability/LemmaOneFiniteModel.lean` assembles the rectangular-group
  collision and conditional Chebyshev terms and supplies explicit `1/4 + 1/4`
  budgets.  `Probability/LemmaOneFixedEnvironment.lean` instantiates that
  theorem with the analytic Step-2 joint kernel and Step-4 Born law for any one
  fixed classical fault environment.
  `Probability/LemmaOneFaultEnvironmentAveraging.lean` preserves the resulting
  bound under arbitrary normalized finite classical mixtures of environments;
  it deliberately does not claim a density-matrix construction.
  `Probability/LemmaOneExactParameters.lean` records the stronger exact
  power-of-two/divisibility special case.
  `Probability/LemmaOneRoundedParameters.lean` instead proves floor-logarithmic
  group widths, ceiling group division, a mean lower bound, and checkable
  collision/tail budgets without either restriction.  It verifies those
  budgets uniformly for `k = 24`, `c = 12`, and `n >= 1024`.
  `Probability/LemmaOneRoundedFixedEnvironment.lean` plugs these facts into the
  actual analytic and classical-environment chains and proves the resulting
  failure mass is at most `1/2`.
- `Probability/LemmaOneRepaired.lean` is the public repaired Lemma 1 interface.
  It explicitly sums the event with at least `n / floor(log_2 n)` all-zero
  groups, proves its mass plus the strict lower-tail mass is exactly one, and
  concludes success mass at least `1/2` for both fixed and arbitrary normalized
  finite classical fault-environment mixtures.
- `Probability/ProjectionInjectivity.lean` proves that local Boolean
  subset-sum injectivity removes every off-diagonal residue-fibre collision,
  giving exact one- and two-group Parseval masses.
- `Probability/PairwiseBernoulliTail.lean` proves the corresponding finite
  pairwise-Bernoulli mean, second moment, variance, and Chebyshev bound.
- `LEMMA1_REPAIR.md` derives the restricted-Parseval replacement for Lemma 1
  and separates its unconditional inverse-polynomial conclusion from the
  stronger two-group-injectivity route.
- `Probability/Lemma4Parameters.lean` repairs the page-14 exponent arithmetic,
  distinguishes `mu` from total cardinality, and propagates the stated
  `n^(3/2)` amplitude bound.
- `Probability/Lemma4Repair.lean` derives the valid pairwise additive-amplitude
  estimate from two near-uniform bin-count bounds, lifts it through a finite
  union bound to success mass `1 - 2 * numberOfBins * tail`, and proves the
  relative form under an explicit positive anti-cancellation lower bound.
- `Quantum/ApproximateReadout.lean` proves that the Hadamard wrong-bit
  probability is exactly half the squared additive branch mismatch, and gives
  the corresponding sum-of-squares theorem when arbitrary finite residual
  labels remain entangled with the distinguished bit.
- `Probability/Lemma4Decoder.lean` combines that identity with L2 count and
  coefficient-energy budgets, giving direct single-pair and labelled
  decoder-success theorems, including a gate-level `H ⊗ I` theorem for an
  actual normalized multi-qubit state, and uniform balls-in-bins
  specializations without anti-cancellation.  Its finite lifts give good-record
  mass `1 - 2 * numberOfBins * tail` for one pair and
  `1 - 2 * numberOfPairs * numberOfBins * tail` for the labelled actual-state
  decoder.
- `Probability/Lemma4AverageDecoder.lean` averages the actual gate-level
  decoder directly over finite classical records.  Expected mismatch budget
  `epsilon` gives overall success at least `1 - epsilon/2`; a stronger
  paper-facing composition replaces simultaneous per-bin tails by the exact
  selected-pair collision-uniformity moment for the two branch count energies.
- `Probability/Lemma4StepSevenAverage.lean` specializes that theorem to the
  explicit Step-7 double path sums, derives their weighted-amplitude
  coordinates by regrouping, and replaces an abstract coefficient budget by
  both the universal `#BPaths * diagonal path energy` estimate and the sharper
  `maximum residue-fibre size * diagonal path energy` estimate.  Its fully
  composed forms isolate the remaining circuit-to-path, selected-collision,
  fibre-multiplicity, and uniform diagonal-budget obligations.

The project deliberately separates the formalized and classically averaged
analytic experiment from a gate/tensor-circuit implementation, a quantum
density-mixture construction over random fault environments and the later adaptive-measurement,
postselection, amplification, and lattice-reduction arguments needed for the
headline result.

## Toolchain

- Lean 4.31.0
- Mathlib 4.31.0
- CSLib 4.31.0
- `QudeLeap/Lean-QuantumAlg` at commit
  `7e80846034b9e76fdeded711775a513a7d5ba917`

The project is intended to be built in Arch Linux under WSL:

```bash
cd /mnt/c/Users/yanyx/Documents/Simon
bash scripts/setup-wsl-arch.sh
bash scripts/build-wsl.sh
```

The same build can be launched from PowerShell with:

```powershell
wsl.exe -d archlinux -- bash -lc 'cd /mnt/c/Users/yanyx/Documents/Simon && bash scripts/build-wsl.sh'
```

The checked environment uses Elan 4.2.3 and Lean 4.31.0.  For faster builds on
Windows-mounted drives, copy the repository to a WSL-native directory before
running `scripts/build-wsl.sh`; the source tree remains authoritative.

The full project, including the Lemma 1 repair, current Lemma 3 repair, and
decoder-facing conditional and expectation-level Lemma 4 repair modules, was
verified on August 16, 2026. The command `lake build` completed all 8674 jobs
successfully.

## Verification policy

Every theorem in the project must compile without `sorry`. Missing arguments
from the paper are recorded as named obligations or refuted by explicit
counterexamples; they are never silently promoted to assumptions. Final claims
are checked with `#print axioms`.  The analytic repair theorems report only the
standard Lean dependencies `propext`, `Classical.choice`, and `Quot.sound`.
The explicitly executable finite searches, including the six-coordinate
prototypes and four-bit adaptive-sector toy model, additionally report the
generated certificates named `*.native_decide.ax_*`, which record reliance on
Lean's native evaluator.  The audit reports no `sorryAx` and the source
declares no project-specific mathematical axiom.

See [AUDIT.md](AUDIT.md) for the proof-status map and
[LIBRARIES.md](LIBRARIES.md) for the TCS/quantum-library survey.

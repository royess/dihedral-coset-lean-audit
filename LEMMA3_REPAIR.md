# Repairing Lemma 3 by Born energy

Reference: [ePrint 2026/1591](https://eprint.iacr.org/2026/1591)

## Scope

The objective is to prove and formalize the mathematical core of Lemma 3, not
to preserve its proof sketch word for word.  In particular, the repaired proof
does not try to recover pairwise independence after the adaptive choice of
`A`.  Its first replacement estimate is stable under arbitrary classical
dependence of `A` on the measured mask `D`.  Its second estimate exposes the
resulting adaptive coherent-sector energy as an explicit budget rather than
silently treating it as a normalized measurement.

This document separates the proved first-clause bound, the conditional
second-clause inequality, and the remaining analytic energy estimate.  It also
records a newer decoder-level obstruction: the sound finite inequalities do
not imply that the paper's Steps 2--7 have a useful output bias.

## The original obstruction

After Step 4, `A` is the first prescribed number of blocks on which the
measured Hadamard string `D` is zero.  Consequently `A = A(D)` and `D_A = 0`.
The proof of Lemma 3 nevertheless fixes the other entries of the transcript
and varies `D` as though:

1. the `A/B` partition and the compatible path sets did not change; and
2. the signs of all distinct paths were pairwise independent.

Neither assertion follows.  Paths with the same `B` part and different `A`
parts have exactly the same sign because

```text
(-1)^(phi dot D) = (-1)^(phi_B dot D_B).
```

Moreover, `D` is sampled with its Born weight, not uniformly.  A Chebyshev
bound under a hypothetical uniform mask distribution therefore cannot be
read directly as a probability over measured transcripts.

These points invalidate the proof sketch.  They do not by themselves refute
the first final probability bound.  The second bound requires an additional
adaptive-sector energy estimate that the published argument does not prove.

## Exact finite repair of the well-behaved bound

Let `M` be a complete accepted transcript and let `h` range over the two final
branches.  Write

```text
Delta(M,h) = tPlus(M,h) - tMinus(M,h),
t(M,h)     = tPlus(M,h) + tMinus(M,h).
```

Suppose the paths in one `(M,h)` fibre have one common *unnormalized joint*
complex amplitude up to their displayed Boolean sign, and let its squared
magnitude be `scale(M,h)`.  This amplitude includes transform and projection
factors but not the transcript-dependent conditional normalization `nu4`.
Suppose also that the two residual `h` labels are orthogonal output sectors.
The coherent Born contribution and the corresponding incoherent path energy
are then

```text
coherent(M,h)   = scale(M,h) * Delta(M,h)^2,
incoherent(M,h) = scale(M,h) * t(M,h).
```

If both branches fail the explicit squared well-behaved threshold

```text
Delta(M,h)^2 >= 2^(-n) * t(M,h),
```

then, pointwise in `M`,

```text
BornMass(M) <= 2^(-n) * sum_h incoherent(M,h).
```

For the equal-amplitude Step-2 fibre followed by the normalized Walsh
transform, the fine pairs `(hidden selection, D)` have total diagonal energy
one.  Arbitrary later postselection retains a subset, so

```text
sum_(M,h) incoherent(M,h) <= 1.
```

Once the actual Step-3--7 amplitude is identified with this signed path model,
summing the pointwise inequality proves that the joint Born mass of accepted
transcripts for which both branches are below threshold is at most `2^(-n)`.
The finite theorem uses no independence or uniformity of `D`, and `A` may be
an arbitrary function of the already measured part of the transcript.

The finite inequality and its exact `2^(-n)` specialization are formalized in
`SimonDCP/Probability/LemmaThreeBornBounds.lean` and
`SimonDCP/Probability/LemmaThreePathRefinement.lean`.
`SimonDCP/Probability/LemmaThreeUniformWalshPaths.lean` additionally proves
the total path-energy bound for an equal-amplitude Step-2 fibre, normalized
Walsh outcomes, and any later filter represented as a compatibility subset.
Additional coherent transforms must be added as fine-path coordinates in the
paper-facing instantiation rather than treated as deletion.
`SimonDCP/Probability/LemmaThreeTranscriptModel.lean` records the correct
relational fine path `(complete transcript, compatible hidden selection)`.
`SimonDCP/Probability/LemmaThreePaperPathBridge.lean` further supplies the
paper-shaped record `(Y,D,W',S,h')`, adaptive compatibility, `h*` branch
label, Boolean sign, and raw Hadamard/common factor.  It explicitly sums the
signed raw contributions over a transcript/branch `Finset` fibre and proves
the non-definitional identity `commonAmplitude * (tPlus-tMinus)`.
`SimonDCP/Probability/LemmaThreePaperPathEnergy.lean` proves that compatible
paths inject into `(hidden,D)`, computes the exact squared Hadamard factor,
and derives total common-path energy at most `1/|Low| <= 1` from normalized
Step-2 diagonal energy.  It then gives the direct paper-shaped joint
`2^(-n)` bound.  Equality between this finite analytic Born model and the
actual circuit amplitude, and circuit-level orthogonality of its residual
branches, remain required model-identification obligations.  The concrete
Step-2 state must also discharge the diagonal-energy premise used above.

## Conditional finite bound for the implicit-component tail

For a transcript `M`, let `p(M)` be its unnormalized Born mass, let `u(M,z)`
be the paper's unnormalized path-restricted contribution for the adaptive
value `z = z*(A(D))`, and define

```text
alpha(M,z) = u(M,z) / sqrt(p(M)).
```

Set

```text
C = sum_(M,z) |u(M,z)|^2.
```

For any positive squared threshold `R2`, if some component satisfies

```text
R2 * p(M) < |u(M,z)|^2,
```

then the mass of that transcript is at most the sum of its labelled component
energies divided by `R2`.  Summing over transcripts gives

```text
Pr[exists z, |alpha(M,z)|^2 > R2] <= C / R2.
```

Taking `R2 = 2^(3*n)` yields a joint `O(2^(-n))` scale if one additionally
proves `C = O(2^(2*n))`.  If the probability is instead conditioned on an
acceptance event of mass `rho`, the bound is `C / (R2 * rho)`; retaining the
literal `O(2^(-n))` scale then requires `C = O(rho * 2^(2*n))`.  This is now
the precise missing mathematical estimate and normalization choice.

The tempting stronger premise `C <= 1` does not follow from measurement
completeness.  The paper's component has operator order `Q_D P_z^(A(D))`:
the original path is first restricted using an outcome-dependent projector,
and its contributions are then coherently combined into the measured `D`
outcome.  The normalized reverse order `P_z^(A(D)) Q_D` instead measures `D`
first and produces a different sector.  A finite equal-amplitude four-bit
Walsh toy model, inspired by the Step-2 support shape but not instantiating the
paper's schedule, has normalized coarse Born mass `1` but adaptive sector
energy `4/3`.  This refutes `coarse normalization => C <= 1`, not by itself
the paper-specific asymptotic `C_n` bound.

For a high-bit bucket the same general inequality holds with its own coherent
bucket energy budget.  A bound at threshold `n^(3/2)` therefore also requires
a proved budget; it is not obtained by merely storing the bucket label.  At
squared threshold `n^3`, a conditional `O(1/n)` tail requires conditional
bucket energy `O(n^2)`, or equivalently a pre-acceptance joint budget
`O(rho * n^2)` when acceptance has mass `rho`.

The budgeted finite inequality is formalized in
`SimonDCP/Probability/LemmaThreeBornBounds.lean` and
`SimonDCP/Probability/LemmaThreeSectorRefinement.lean`.  The exact `4/3`
adaptive counterexample is formalized in
`SimonDCP/Probability/LemmaThreeAdaptiveSectorCounterexample.lean`.

A conservative replacement is formalized in
`SimonDCP/Probability/LemmaThreeAdaptiveFibreUpperBound.lean`.  For an
arbitrary outcome-dependent label map, complex Cauchy--Schwarz proves

```text
total adaptive energy <= (maximum fibre size) * total fine-path energy.
```

Consequently, an explicitly normalized fine-amplitude model with fine-space
cardinality at most `2^(c*n)` gives a joint `2^(-n)` tail at squared threshold
`2^((c+1)*n)`.  This closes the abstract Cauchy implication, but the paper
application still has to identify its `u(M,z)` with that fine model and prove
the fine-energy normalization; it also does not recover the paper's
`2^(3*n)` threshold when `c = 12`.  The Boolean
specialization in `LemmaThreeBooleanFinePathUpperBound.lean` proves the exact
fine-space cardinality and gives squared threshold `2^(13*n)` at `c = 12`.
Moreover,
`SimonDCP/Probability/LemmaThreeConservativeThresholdImpact.lean` proves that
substituting the corresponding amplitude exponent `(c+1)*n/2` into the
corrected Lemma 4 calculation gives

```text
7*n/2 + faultLoss/2 + c*logN/2.
```

The `c*n` terms cancel, so increasing `c` cannot make this conservative route
support the existing downstream argument.

An alternative that avoids pointwise `alpha_z` control is machine-checked in
`SimonDCP/Probability/LemmaThreeToFourL2.lean`.  For finite low-bit labels it
proves

```text
normSq(sum_z (count_z - mean) * C_z)
  <= (sum_z (count_z - mean)^2) * (sum_z normSq(C_z)).
```

It also uses `restricted_parseval` to express the coefficient-energy factor as
a Walsh projection-collision energy.

`SimonDCP/Probability/LemmaThreeStepSevenRegrouping.lean` supplies the next
exact algebraic bridge.  It defines the direct A-side/B-side double path sum,
proves that regrouping by the low residue is exactly

```text
sum_z count_z * C_z,
```

and propagates a raw common amplitude through the L2 error theorem.  It also
expands `sum_z |C_z|^2` as the ordered collision sum of B-side terms sharing a
residue.  This is a sound abstract structural alternative, but the paper
application must still instantiate these
finite sets/maps with the actual Step-5--7 fibres, prove an `L2` count-error
estimate in the conditioned adaptive experiment, and bound the resulting
coefficient-collision energy.  An additive `L2` bound alone also does not give
a multiplicative ratio when the reference amplitude can cancel to zero.

The A-side second moment is now isolated precisely in
`SimonDCP/Probability/LemmaThreeCountEnergy.lean`.  For bucket counts `N_z`,
total selected population `T`, bucket count `m`, and any external mean `mu`,
it proves the exact centering identity

```text
sum_z (N_z-mu)^2
  = sum_z (N_z-T/m)^2 + m*(T/m-mu)^2.
```

It also proves that *selection-aware* weighted pair-collision moment
factorization gives actual-mean energy `(1-1/m) E[T]`.  Selection must be
inside the pair-collision premise; interpreting the weights probabilistically
additionally requires nonnegativity and normalization.  A machine-checked two-bit example starts
with jointly uniform bucket labels, conditions on their equality, and changes
the count energy from the independent baseline `1` to `2`.  Thus the paper
cannot apply an unconditioned balls-in-bins variance after the complete
transcript has fixed `Y`; it must prove the weighted selected-pair identity
and separately control fluctuations of `T` when using a global mean.

## Evidence about the missing energy budget

The remaining estimate is not merely routine normalization.  An analytic
frame-operator calculation separates two effects.  If each candidate block has `m` bits,
`q = 2^m`, there are `G` blocks, and `A(D)` is the first `a` all-zero blocks,
then the complete-label frame/surrogate admits the upper bound

```text
q^(-a) * choose(G,a) <= (e*G/(a*q))^a.
```

The exact incidence count and the corresponding diagonal-surrogate bound
`choose(G,a)/q^a`, in cleared-denominator form, are machine-checked in
`SimonDCP/Probability/LemmaThreeFirstZeroFrame.lean`.
With the paper's parameters it is only `2^(O(n/log n))`.  This is consistent
with controllability of the first-zero rule at the complete-label level.
Connecting that diagonal weight to the concrete circuit frame remains a
required model-identification bridge.
The dangerous operation is the later
coherent coarsening of the complete selected string into `(z,W)`: a fibre of
size `r` can multiply the frame bound by `r`.

The deterministic part of this obstruction is now machine-checked in
`SimonDCP/Probability/LemmaThreeCoherentFibreObstruction.lean`.  For any map
from a finite domain into a finite label set it proves

```text
|Domain|^2 <= |Label| * sum_label |fibre(label)|^2.
```

It also gives the corresponding equal-amplitude real-energy bound and a
cleared-denominator specialization for a `2^(c*n)` domain and at most
`2^(2*n)` labels.  This theorem does not assert a lower bound for the complete
paper quantity: `B`-side signs and later filters can still cancel or remove the
coherent contribution.

In a simplified equal-Step-2-fibre model before the later `S/W` filters, an
exact random-`Y` second-moment calculation gives expected sector energy

```text
Theta(P_accept * 2^((c-1)*n)).
```

The `B`-side dimension cancels against Step-2 normalization; the coherent
`A`-fibre remains.  Counting the available `A`-side labels in Step 6 suggests
that the complete experiment has natural scale
`2^((c-2)*n) / poly(n)`.  For `c = 12` this is far above `2^(2*n)`.

The first frame identity and the simplified second-moment calculation are
mathematical statements about reduced models.  The last scale estimate is not
yet a counterexample to the full paper experiment: a rigorous lower bound must
still control the correlations introduced by `S`, `W`, the `l_(s*)`
postselection, and `Y`.  The accurate status is therefore that the required
budget remains open but is now strongly implausible.

If this scale survives the remaining filters, the pointwise threshold needed
for a `2^(-n)` joint tail is roughly
`L >= 2^((c-1)*n/2)` (`2^(5.5*n)` at `c = 12`), rather than `2^(1.5*n)`.
Possible repairs would have to retain roughly `(c-4)*n` additional independent
`A`-side label bits, change incompatible parameters, or bypass the pointwise
`alpha_z` bound and prove the final Lemma-4 comparison directly in `L2`.

## Spectral obstruction to the decoder

The energy-budget discussion above concerns the two standalone probability
claims.  A newer two-copy Fourier calculation tests the downstream decoder
directly on fault-free samples.  Work along a divisible subsequence with

```text
N = 2^n,
q = n^c,
a = n/log_2(n),
G = lambda*a*q,
lambda > 1.
```

For a Fourier mode `xi`, the exact zero-group kernel `p_xi` has interval
Parseval budget `sum_xi a_xi = 1`.  Hence all but polynomially many of the
`N` modes satisfy `p_xi = (1+o(1))/q`.  The adaptive first-`a`-zero rule has
the exact transfer

```text
A_xi = Pr[Binomial(G,p_xi) >= a].
```

Since `G/q = lambda*a`, almost every typical diagonal mode is accepted with
probability `1-exp(-Omega(a))`.

For the no-guard modification that retains the low summary `u`, the exact
all-frequency terminal kernels are

```text
w_wrong(xi)   = 1/(2*q),
w_correct(xi) = p_xi - 1/(2*q).
```

After the first-zero transfer, both output masses equal `1/2+o(1)`.  Thus the
`keep-u` proposal fixes the acceptance loss but not decoding: its conditional
error tends to `1/2`.

Before imposing the paper's safe-residue guard, the zero-low-Hadamard terminal
wrong kernel is exactly `1/(2*q*L)`, with `L=n/2`.  A guard-restricted Parseval
estimate is expected to give

```text
P_wrong   = g/(2*L) + o(1/n),
P_correct = g/(2*L) + o(1/n),
P_accept  = g/L + o(1/n),
```

where `g = 1-O(1/log n)` is the safe-set density.  The remaining estimate must
control the preterminal failure factors, binomial-tail sensitivity, terminal
coarsening, exceptional modes, and zero/nonzero cross terms.  It has not yet
been formalized.  Consequently, the rigorous status is:

- the no-guard `keep-u` decoder is refuted by the exact kernel calculation;
- the guarded paper decoder has the same spectral obstruction conditional on
  the explicit perturbation estimate;
- neither isolated clause of Lemma 3 is directly refuted;
- the intended Lemma-4-based decoding consequence cannot be obtained from the
  presently analyzed architecture.

The full calculation, including the exact `h*`-sector formula and the boundary
between exact and pending estimates, is in
[`LEMMA3_SPECTRAL_OBSTRUCTION.md`](LEMMA3_SPECTRAL_OBSTRUCTION.md).

This changes the positive-repair priority.  The abstract L2 and budgeted tail
lemmas remain sound, but another local collision, guard, or keep-all-outcomes
lemma is not enough.  A genuinely different positive route would need a global
half-turn fibre-erasure operation pairing subset sums `z` and `z+N/2` while
erasing their which-path information with inverse-polynomial success.  No such
polynomial construction is identified or supplied in this project.

## Conditioning convention

The bounds above are joint masses in the experiment in which the displayed
transcripts are retained.  If the statement is instead interpreted as a
conditional probability given an earlier acceptance event of mass `rho`, the
right-hand side must be divided by `rho` unless the refined experiment is
normalized directly inside that accepted branch.

For example, a joint exact-sector bound `2^(-3*n)` remains exponentially small
after inverse-polynomial postselection, while a joint `n^(-3)` bound and
acceptance at least `n^(-1)` give a conditional `n^(-2)` bound.  These
conversions apply only after the corresponding joint bound, including its
sector-energy budget, has been established.  The paper's phrase "over choices
of M" does not specify this convention precisely.

`SimonDCP/Probability/LemmaThreePostselection.lean` formalizes the exact
joint-to-conditional ratio and these two parameter conversions.
`SimonDCP/Probability/LemmaThreePostselectionSlack.lean` proves the general
exponent-slack rule and, in particular, converts a joint `2^(-n)` bound into a
conditional `2^(-floor(n/2))` bound whenever the explicit inverse-polynomial
acceptance lower bound fits in the complementary exponent.
`SimonDCP/Probability/LemmaThreePaperFirstClause.lean` applies this conversion
directly to the paper-shaped transcript weight and small-branch event.
`SimonDCP/Probability/LemmaThreeBudgetedFirstClause.lean` retains the stronger
joint factor `1/|Low|` and proves that an acceptance lower bound
`kappa/|Low|` yields conditional bad mass at most `2^(-n)/kappa`.  A constant
`kappa` preserves the `n`-bit exponent up to a constant factor.  An
inverse-polynomial `kappa` costs `O(log n)` exponent bits, while still leaving
an exponentially small bound.

That lower bound does not follow from normalization.  The exact formula for a
coherent low-register amplitude `a_x` is

```text
Pr[Hadamard output 0] = |Low|^(-1) * normSq(sum_x a_x).
```

`SimonDCP/Probability/LemmaThreeStepSixAcceptance.lean` proves this formula,
a normalized `(1,-1)/sqrt(2)` input with zero all-zero mass, and a two-point
environment example where the unconditional average is `1/2` but retaining
one environment makes the joint all-zero mass zero.  Thus the paper's stated
average `2/n` requires a conditional Walsh-twirl/independence theorem that is
not presently available.  The same module proves the keep-all identity only
for a one-bit/two-outcome Hadamard transform.  Keeping all outcomes preserves
mass, but it is not a decoder repair: the exact no-guard spectral calculation
above shows that the corresponding retained-`u` output is asymptotically
unbiased.
`SimonDCP/Probability/LemmaThreeFiniteRepair.lean` combines it with the
compatible-path and explicit-sector-budget theorems.

## Fixed affine conditioning criterion

`SimonDCP/Probability/ConditionalLinearForms.lean` records a separate exact
criterion.  On a reachable fixed affine fibre `condition x = c`, a pair of
binary linear observations is jointly uniform if and only if its restriction
to `ker condition` is surjective.  Equivalently, two condition-preserving dual
masks realize the outputs `(1,0)` and `(0,1)`.

This criterion is useful for auditing conditional-independence claims, but it
is not the main repair route for Lemma 3.  The actual selection rule `A(D)` is
adaptive and need not define one fixed affine fibre.

## Remaining mathematical and formal bridge

The finite-model first-clause joint inequality and the general budgeted sector
tail algebra are complete.  To instantiate those standalone inequalities for
the paper's analytic experiment, the following obligations remain:

1. instantiate the concrete arithmetic types and functions inside the
   existing paper-shaped finite transcript for Steps 3--7;
2. identify the actual circuit finite coherent sum with the already
   normalized model's `tPlus`, `tMinus`, common unnormalized joint path
   amplitude, and orthogonal residual branches, and connect it to the actual
   Born weight; the finite model's path injectivity and energy inequality are
   now proved;
3. identify the concrete Step-2 amplitude with the model input and discharge
   its diagonal-energy premise from the actual analytic state;
4. identify the paper's outcome-dependent path-restricted contribution
   `u(M,z)` and prove an adaptive sector-energy budget
   `C_n = O(2^(2*n))` for the joint statement, or the correspondingly stronger
   acceptance-scaled budget for a conditional statement (and prove the
   analogous high-bucket budget);
   alternatively, use the already proved conservative maximum-fibre theorem,
   accepting its larger `2^((c+1)*n)` squared threshold;
   as an abstract alternative, the L2 bypass requires one to
   instantiate the now-proved Step-7 double-sum regrouping, prove its
   selection-aware conditioned count-error and coefficient-collision energy
   bounds (including the extra total-population term for a global mean), and either
   prove a noncancellation lower bound or state the conclusion in
   additive/state-distance form;
5. identify the paper's implicit `alpha_z` with `u(M,z) / sqrt(p(M))`;
6. use the now-proved deterministic Step-6 carry/top-bit bridge for
   `n = 2^ell`, the concrete group count
   `a = floor(2^ell/ell)` (whose safety inequality is also proved), and
   `tau = floor(log_2 ell)`:
   `l_(s*) = 0` excludes both exact carry windows and gives the correct
   complete-sum top bit.  The paper should state both rounding conventions
   explicitly; upward `tau` rounding has a finite counterexample;
7. state explicitly whether the final probability is joint or conditioned on
   reaching Step 7, and normalize accordingly.  For the strongest first-clause
   form, prove the Step-6 accepted mass lower bound at the matching
   `kappa/|Low|` scale.  Retaining every low Hadamard outcome preserves mass but
   is no longer a candidate decoding repair because its exact no-guard
   two-copy kernel is asymptotically unbiased;
8. formalize the spectral kernel and safe-guard perturbation estimate from
   `LEMMA3_SPECTRAL_OBSTRUCTION.md`, then either record the resulting guarded
   countertheorem or replace Steps 3--6 with a genuinely global half-turn
   fibre-erasure primitive.

The latter alternative has now been investigated at the natural-language
level in [`LEMMA3_HALF_TURN_ERASER.md`](LEMMA3_HALF_TURN_ERASER.md).  An exact
signed-frame operator has the desired half-turn swap as its polar part, so the
primitive exists information-theoretically.  All generic implementations
examined incur a `sqrt(2^n)` normalization or search cost.  The follow-up
random-instance calculation sharpens the diagnosis: with `m=c*n`, `c>2`, all
normalized fibre sizes are simultaneously close to one with overwhelming
probability, so the PGM's inverse-square-root whitening is essentially the
identity on the occupied fibre-uniform support.  The hard step is instead
coherent synthesis/index erasure.  The
efficient controlled product-state preparation exposes that synthesis only
with amplitude `1/sqrt(2^n)`.  FFT/Schur, tensor-network, 2-adic recursion,
hashing, lattice, local-relation, projector-sampling, and ordinary or variable-
time QSVT implementations did not remove this scale.

A direct two-outcome test remains logically weaker than full fibre sampling,
and no polynomial construction or impossibility theorem is claimed.  The only
remaining opening found is a distribution-specific collective parity decoder.
A polynomial implementation would already give a new polynomial one-bit DCP
algorithm, not a small completion of the published proof.

## Verdict

The correct status is therefore: **Lemma 3 is not repaired in the sense needed
by the claimed polynomial-time algorithm.**  The original proof is invalid;
the first clause has a sound replacement in a paper-shaped finite analytic
model but still needs the model-to-circuit Born and concrete Step-2 energy
identification; the second clause has a sharp budgeted tail theorem but its
required adaptive energy budget is open; and the current decoder has an exact
no-guard spectral obstruction plus a pending guarded extension.  The ideal
global ParityPGM replacement exists algebraically, but no polynomial circuit
is supplied or found.  Closing the standalone inequalities would therefore
not repair the core algorithm.

The global replacement investigation now has a sharper conditional positive
result.  A single set of `n+O(log n)` correction coordinates with a reversible
preimage map is sufficient, but canonical rank/unrank is not necessary.  With
two independent correction pools of exactly `n` bits, a large common label
pool, a public random affine permutation, and cross-filtering, any bounded and
verifiable random-target RMSS find-one solver with inverse-polynomial average
success erases the two half-turn branches to identical garbage without the
earlier projection loss.  Both solver calls run on both branches, so arbitrary
solver outputs, seeds, and bounded workspaces are common garbage.  Random
correction fibres contain enough preimages information-theoretically, but no
polynomial find-one algorithm is known here at exact density one.  Adapting
the explicit two-pool/common-label construction to unknown fixed faulty
coordinates remains open; its direct common-label overlap in the paper's
noisy regime can lose
`2^(-Theta(n/log n))`.  Hash isolation does not remove the underlying inversion
issue: in the corresponding
random-singleton oracle model, constant one-shot phase advantage requires
`Omega(sqrt(D))` queries even for an arbitrary joint POVM.  This is an
oracle-model barrier rather than an unconditional arithmetic lower bound; see
[`LEMMA3_HALF_TURN_ERASER.md`](LEMMA3_HALF_TURN_ERASER.md).

The fault-overlap loss above is specific to the explicit one-match/two-pool
construction.  It is not a limit on the trace distance of the complete raw
state.  A separate random-code Gram calculation on a fixed block of `q=c*n`
raw samples introduces the ideal phase codewords

```text
|psi_d^Y> = 2^(-q/2) * sum_x omega^(d*f_Y(x)) |x>
```

and every low-weight error `Z^e|psi_d^Y>`.  Error words are exactly orthogonal
for one fixed `d`, while codewords belonging to different secrets have
expected squared overlap `2^(-q)`.  The resulting PGM separates the whole
coherent low-weight-error subspaces.  In the repository's fixed-basis fault
model, an arbitrary pattern of at most `r` faulty coordinates with arbitrary
fixed bits lies entirely in the corresponding weight-`r` error subspace.
Combining the Gram bound with the marginal fault estimate gives, for `c=12`
and `r=floor(q/32)`,

```text
P_error <= 32/(c'*log n) + 2^(-2.59*n+O(1)).
```

This decodes the complete secret information-theoretically, without fault
flags and without assuming independent fault locations, averaged over the
iid-uniform public-`Y` marginal.  It acts on a fixed raw block before the
adaptive `A(D)` selection and therefore bypasses rather than proves the
paper's Lemma 3.  Its synthesis matrix has exponentially many columns, and the
current proof supplies no polynomial circuit for the polar measurement.  The
new result removes an information-theoretic concern but does not change the
polynomial-algorithm verdict.  Exploiting cyclic covariance exactly
block-diagonalizes the synthesis map, but each residue block is still the
polar transform of a fibre-restricted Walsh matrix.  The direct
projected-unitary/QSVT implementation exposes those blocks at singular-value
scale `N^(-1/2)` and therefore retains `Theta(sqrt(N))` constant-accuracy cost,
up to approximation logarithms, in that access model.  This is not an
unrestricted circuit lower bound; a direct parity-only arithmetic transform
remains logically open.

A random binary-syndrome construction is a genuine polynomial-time
preprocessor.  Measuring the syndrome together with `f_Y(x) mod (N/2)`
preserves the exact relative phase and compresses the supported affine cube to
a code-constrained core of effective dimension
`kappa=k-e`; this is `n+O(log n)` under a conditional tight choice for the
hidden fault count.  A conservative public cap can make it larger, while
faults exceeding the cap make it smaller and can make it underdense after
consuming the slack.  Pairwise independence gives precise partner-count
moments, but over iid public labels in the Born-planted coupling, a uniformly
prepared code difference still reaches the half-turn target with expected
fraction `(1-o(1))/N`.  Logical-`X` measurement produces a
linear equation involving the unknown half-turn difference rather than the
secret alone.  Thus the construction isolates, but does not solve, a
density-one RMSS core.  An explicit `Y`-dependent residue-pair syndrome can
remove `Theta(log n)` modulus bits in polynomial time, but its no-reuse
population drops by at least a factor of four asymptotically with high
probability per large-`B` layer, so it cannot be iterated to a small modulus
while retaining density one.  More
general overlapping CNOT/syndrome branches admit an exact affine-code normal
form: removing `m` modulus bits requires simultaneous higher-order carry
congruences.  In fact, an all-embedding SNF/counting argument shows that for
`q=12*n`, with high probability no affine coset of dimension at least `91` is
contained in one `f_Y mod H` fibre, even if selected after seeing `Y`.  The
syndrome-isolated core is
not contradicted because its additional modular measurement leaves a
generally non-affine intersection.
On a clean cube, a triangular checksum factorization gives a second exact
preprocessor: it removes `log q-O(log log n)` low bits without rejecting any
checksum outcome, but leaves a nonlinear quotient phase.  Any all-outcome fixed-garbage
continuation is limited by the raw `O(log q)` valuation chain.  On the clean cube, coarse modular
fibres do admit exact canonical charts: residue-DP rank/unrank has size
`O(poly(q)*R)` modulo `R`, and an ordinary checksum keeps a fresh linear
quotient on a small-knapsack support.  These are polynomial for `R=poly(n)`,
but the known trellis cost is exponential in the total peeled modulus bits.
Phase-calibrated fixed-point amplification approximately prepares a balanced
fibre in `O*(sqrt(R))` queries at constant error, where `O*` suppresses
polynomial factors in `n` and logarithmic factors in precision.  Coarse DP
plus residual amplification costs `O*(sqrt(N*B))` ordinary gates.  Ideal
preloaded QRAM changes this only to an exponential `O*(N^(1/3))`
preprocessing/online time--memory tradeoff.
The ordinary-checksum pure state has polynomial MPS bond, but its parity
difference has `M=N/T` asymptotically flat operator-Schmidt sectors and needs
`Omega(M)` bond for constant-relative-Frobenius MPO approximation on typical
branches; this is not a general circuit lower bound.
Every `O(log n)`-local final-half-turn matching after the triangular checksum
chart also has exponentially small expected Born-weighted coverage over the
iid public high labels at the stated parameters.  A classical
reversible basis preprocessor followed by one Hadamard also has an exact
normal form: inverse-polynomial mass-weighted advantage yields an RMSS partner
finder, and on the clean cube full exact basis pairing requires a live raw
label equal to `H`, despite the
existence of an almost-complete abstract partial matching in expectation.

The robust observable's signed conjugation harmonic also yields a stronger
scoped lower bound.  In the translation-covariant orbit/reference model, an
algorithm may use
arbitrary fast powers of the secret orbit and the efficient reflection about
the low-weight reference subspace.  Conjugation reduces parity decoding to
deciding whether one uniquely marked clock position is even or odd; the
adversary ratio is `sqrt(N/2)`.  Hence `Omega(sqrt(N))` reflection queries are
necessary for bounded-error parity in that model, including on the Gram-good
physical frame.  This
extends the QSVT barrier but still excludes circuits that use other gates to
exploit the internal Boolean modular arithmetic.

Three further realizations make that opening narrower without closing it.
First, the exact power-of-two frame recursion writes the next signed frame as
the difference of the preceding full frame and its phase conjugate.  Its sign
needs the preceding fibre-support projector, which a bare preceding parity
measurement does not provide; direct recursion doubles the orbit branches at
every bit.  Second, measuring each raw phase qubit in `X` in the iid
averaged/dephasing model produces passive noisy cosine samples.  A correlation
test identifies `{d,-d}` with `O(n)` samples, but evaluating it by FFT costs
`O(N log N)` and no polynomial-time decoder for the passive one-bit sample
model was found.  At `q=12*n` and `lambda=1-O(1/log n)`, an exact unbalanced
split turns the score into logarithmic-dimensional bichromatic nearest
neighbor.  Ideal coherent QRAM
for a data-dependent ANN table then gives a conditional
`N^(23/49+o(1))` time--space algorithm, approaching
`N^(7/15+epsilon+o(1))` for fixed `epsilon>0`; ordinary-gate QROM does not
preserve this exponent.  Without a stored bucket index or algebraic bucket
inverter, table-free rejection and a direct-predicate Cartesian Johnson walk
return to `sqrt(N)`.  Fixed-relative-error rare-cap polynomial surrogates need
degree `Omega(log M)`, while the displayed `o(log M)` one-sided local moment
certificate leaves `M^(1-o(1))` expected blocks alive.  A certified
factor-`C` interval log-sum-exp oracle would instead enumerate the rare row in
`O(C*u*log M)` expected calls; this is an implicit Gaussian-KDE block-sum
problem.  Black-box point-query implementations require `Omega(s)` classical
or `Omega(sqrt(s))` quantum queries on a size-`s` block.  Even
residue-aggregated cancellation-blind Bessel certification must retain
`(1-o(1))*N` residues.  On a low block, optimal iid unbiased single-
multi-index importance sampling still needs `N^(4.303...-o(1))` or
`N^(4.472...-o(1))` samples to reach additive RMSE `O(exp(u^2))` at the two
splits.  The unweighted, untruncated full-spectrum Fourier `L_2` bound cannot
prune.  The phase-averaged zero residue is amplified by `N^(0.78...+o(1))` to
`N^(0.80...+o(1))` over a uniform energy share.  Even after adaptive exact
Fourier retention, positive-diagonal global-Fourier tails leave the whole
interval tree unprunable below retained-set exponents `0.3774...` or
`0.3661...`.  More
generally, an adaptive `N^r`-dimensional subspace of orthonormal-family
coherence `N^eta` and a non-diagonal ellipsoid of condition `N^chi` cannot
prune an `N^sigma` interval when `r+sigma+2*eta+chi<R_*`, where
`R_*=4*sqrt((1-rho)*gamma)-4*gamma`; the incoherent, well-conditioned whole-tree
budgets are `0.4795...` and `0.4772...` at the two splits.  Random-orbit KDE
blocks are `(1+o(1))*I`, and every feature span fixed before the Gaussian
query needs `s/N^o(1)` dimensions for a factor-`poly(n)` certificate.
Row-adaptive scalar or ill-conditioned constructions remain open.
Rejection-based quantum tilting returns to `sqrt(M/k)`.  Kac--Rice gives
only
`M^o(1)` expected crossings and accepted indices, so the implicit
partition-sum or sparse output-sensitive root locator remains open.  The
exact Bayesian parity rule is the ratio of the half-turn and zero coefficients
of a weighted ternary subset-sum generating function under a uniform secret
prior.  Coherent likelihood filtering
prepares a useful posterior only
with at most `O(1/N)` heralding probability in its direct normalized
state-conversion model.  Uniform importance sampling has exact squared
coefficient of variation `N*sum_k pi(k)^2-1`, so it costs linear in `N` after
the posterior concentrates.  For a nondegenerate secret, a Hellinger
calculation proves that at `q=12*n` and high visibility this posterior
concentrates on `{d,-d}` with high probability, while uniform correct-parity
candidate sampling has
`N/4-o(N)` relative variance.  At the same parameters, in the matched passive model with a
nondegenerate secret, ordinary absolute-weight sign reweighting has
average-sign magnitude at most `N^(-4.06843+epsilon)` with high probability
for every fixed `epsilon>0`; this does not lower-bound a direct arithmetic
computation of the coefficient ratio.  For visibility `1-Theta(1/log n)`, the
log likelihood has a uniformly accurate polynomial-size sparse trigonometric
expansion.  Optimizing it would decode `{d,-d}`, but the grouped triangle
envelope is identical on `H/poly(n)` prefixes with high probability, while
exact high-bit elimination can become Fourier-dense.  These radix routes do
not certify polynomial pruning.  Scalar polynomials in `G_J` below the displayed
`Theta(n/log n)` threshold have no half-turn Fourier component with high
probability.  The natural parity-constrained group-moment/SOS hierarchy also
has a coherent sample-aligning rank-one pseudo-solution until its explicit
matrix is exponential; the same point blocks the displayed bounded-word
SOHS certificates.  A sparse-circulant/QSVT correlation filter can mark the two
correct modes in polynomial time, but their input mass is only `Theta(q/N)`
for the natural sparse-data state, so this filter still needs
`Omega(sqrt(N/q))` amplification.
The same score defines an exact sparse parity-constrained SDP, but its Fourier
form remains optimization over `N/2` atoms; PSD separation is the same
parity-restricted optimizer, and faithful group-algebra representations need
`N/2` dimensions.  The quotient state simplex itself has exact PSD extension
size `N/2`; at the displayed hierarchy depth, truncated character sketches
and direct low-rank approximations remain exponential.  With high probability,
the standard Cayley/chordal Fourier-SOS construction also needs a frequency
set and PSD block of size at least `21*N/116`.  The generic quantum
SDP
interfaces checked here retain square-root dimension dependence or require
stronger input, preparation, or oracle assumptions.  A compact repeated-
squaring construction instead gives an exact polynomial-size nonconvex unit-
modulus QCQP; a proved planted solver for that lift would be a new positive
decoder.  Its strengthened first-order Shor relaxation is parity-blind with a
growing integrality gap.  At polynomial-size order two, harmonic squaring is
enforced for aligned occurrence trees and that witness fails in the aligned-
tree formulation; a finite Laurent phase closure
gives a conditional pseudo-moment certificate.  On typical labels, every
single cycle is exponentially uncorrelated with the planted parity, and any
nonlinear cycle syndrome below the displayed linear odd-support-rank threshold
remains parity-blind.  This rules out a high-probability planted saturated-
feasibility gap for the `tau_(i,m)=S_i^m` phase certificate but not an
unsaturated SDP value gap.  For those coherent pins, with high probability,
every expanded proof below the displayed `Theta(n/log n)` net root-pin-width
threshold is phase-consistent for both parities in every standard phase-one
multiplication-tree layout.  Separately, using objective-coefficient phases
as the reference pins, a sign-conflicting loop forces the one-sided
separable-ceiling deficit `D>=2/R_C`.  Long compressed proofs and the
two-sector optimum difference remain open.  A randomized sixteen-
bucket reassociation has an exponentially likely cut-dissociation event, but
an exact balanced-depth-four counterexample shows that the event alone does
not control repeated Hankel interpolation.  The completed closure's formal
provenance lattice is exactly computable for each fixed compiler, although its
random odd-support rank remains open.  Full semantic row normalization can be
strictly stronger: its typical parity-even odd-support rank is `q-1` and it
contains a parity loop of root-pin width at most `2*q`; under the matched-sign
law coherent pins usually fail in both sectors.  An exact expander identity buffer
shows that the gap is not invariant under exact redundant lifts.  Neither
result settles the fixed aligned arithmetic lift or supplies a planted gap.
With high probability, natural exact factor-graph elimination has `Omega(n)` treewidth,
coefficient BP develops exponential support, and uniform bitwise BP has no
inverse-polynomial first-round seed.  Signed spectral traces do not already
provide one: their ideal
ratio is `(-1)^d`, but their normalized signal is `2/N`, and moment,
determinant, and resolvent variants reduce to the same half-turn relation
coefficients.  Passive decoding also has an exact rank-one two-coset CVP
surrogate with a certified conditional threshold: at visibility one and
`q=12*n`, for secret phase order `M_d=2^(Omega(n))`, approximation factor below
`1.3448` would
recover parity.  None of
the standard LLL/Babai, BKZ, BDD, embedding, or phase-unwrapping routes checked
here reaches that factor in polynomial time.
Pair products give an exact passive
recursion to smaller 2-adic moduli.  Writing their initial visibility as `lambda_pass`,
along nondegenerate levels, including an odd secret before the final modulus,
their visibility after `ell` levels is
`2*(lambda_pass/2)^(2^ell)`; polynomial no-reuse recursion removes only
`o(n)` modulus bits.  At visibility one, a four-list Wagner aggregate has a formal
`N^0.499463` runtime, but shared-support zero relations make its parity-signal-
normalized second moment at least `N^(0.0073173+o(1))`; optimistic
independent-replica raw-second-moment accounting has exponent `0.5026116`.
On this fixed support-weight/filter orbit, uniform weighting minimizes the
ensemble ratio among all data-independent real linear weights, so thinning,
signed reweighting, codes, and designs do not repair it.  With high probability
the exponent survives every public-label-adaptive nonnegative fixed-degree
weighting.  Every asymmetric exact-degree four-list pair--pair raw-moment route
in the two-orientation model has exponent at least `1/2`; balanced standard
trees in the same model with at least eight lists exceed `0.6856`.  At the
near-miss point, the explicit per-block-nonempty leading-Gram cutoff whitener
has diagonal-ratio
exponent `1.5095`.  The regularized degree-symmetric leading surrogate has an
exact polynomial-size spectral optimizer.  Its diagonal confines the only
possible sub-square-root interval to `0.02073134<p<0.02079354`.  An explicit
hypergeometric-tail rank-two certificate gives `delta>0.000205` uniformly
there and puts that entire window above `0.50020`, closing the named surrogate
at the square-root scale.  The exact `{z,-z}` block makes direct PSD promotion
fail before orientation quotienting.  After the quotient, exact filter
classification gives `C_+>=(2-o(1))*S_+`, and extra half-turn signal is dual-
norm negligible.  The bound therefore holds for the complete ensemble raw-
second-moment problem with fixed data-independent orbit-constant weights;
whole-radial conditional Loewner promotion fails on empty low-degree blocks.
Every nonzero-signal `Y`-adaptive signed weighting supported on at most
`N^(1/20-epsilon)` distinct supports nevertheless has Rayleigh ratio at least
`N^(1/20+epsilon-o(1))` on `E_short`; the full optimizer and nonlinear
performance remain open.
Bucket-sum-only random rehash medians contain
only the original path-sum information, while a fixed positive pair-overlap
law can give either sign of prediction correlation.  A second-moment theorem
gives `N^(0.280916...-o(1))` distinct span-clean local anti-majority marginals
with high probability.  Their entire certified Fourier spectrum contributes
only `N^(-0.108737...+o(1))` to any bounded predictor.  At visibility one, the
typical full path layer has Wick fourth moment and contributes at least
`(2/sqrt(3)-o(1))*2^(-t)*sqrt(M_path/2)=N^(-o(1))` before its outside
spectrum.  Yet the
actual modular instance `N=16,Y=(1,2,3,5,6,7)` has Wagner correlation
`lambda^2*(7*lambda^2-8)/32<0`.  The actual residual has uniform `L_1` norm
`1+o(1)` at visibility one, while asymptotic nonnegative-coefficient
completions with the exact Rademacher-sum `Z` law and `o(M)` local reversals
realize either sign.  These are
information-sufficiency obstructions and do not settle the random modular
sign.
A
normalized-Fourier/Parseval argument now proves that,
against the conventional adversarial `STAT` oracle, every adaptive
polynomial-query `STAT(1/poly(n))` decoder has uniform-secret average parity
advantage only `poly(n)/N`; this statement is deliberately limited to
statistical queries and does not include individual-example or collective
quantum algorithms.
The Gram-good blocks also define an explicit parity-only involution that is
uniformly correct on every coherent low-weight-error vector, without
outputting the complete secret or error label.  Its known projected-unitary
polar implementation nevertheless costs `Theta(sqrt(N))` at constant accuracy
in that access model.  In the clean orbit dictionary, the raw signed-frame
LCU is coefficient-unique and constant-error parity approximations retain
`Omega(N)` normalization, while directly signing the purified density block
costs `Omega(N)` rather than the frame route's
`Theta(sqrt(N))`.  Low-output fermionic-Gaussian circuits are also exactly
parity-blind below the signed-relation threshold.  A linear-output
disjoint-pair matchgate is an exact escape from that theorem: it yields
`6*n` visibility-one passive observations with exponentially reliable
maximum-likelihood parity, but efficient postprocessing remains the same
weighted `A_0/A_H` coefficient problem and is not supplied by pointwise
Pfaffian evaluation.  These are scoped
circuit/access-model statements, and exact operator-Schmidt flatness rules
out only polynomial-bond Frobenius/MPO compression, not arbitrary circuits.
Third, pairwise Kuperberg-style collimation retains the usual
`2^(Theta(sqrt(n)))` clean resource balance, while explicit linear-support
relations, when fixed or drawn from a polynomial family independently of the
hidden fault set, survive permitted hidden-fault models only with
superpolynomially small probability.  These are family-specific barriers;
they do not rule out a new collective arithmetic parity circuit.

This verdict is deliberately narrower than a countertheorem to every possible
reading of the two sentences called Lemma 3, and it is not a lower bound for
all DCP algorithms.  It says that the repository currently contains neither a
valid derivation of the paper's Lemma-3-to-decoder use nor a polynomial-time
replacement for that use.

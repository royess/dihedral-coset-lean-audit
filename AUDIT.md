# Proof audit for IACR ePrint 2026/1591

Source reviewed: the 16-page preliminary draft dated July 31, 2026, received by
IACR on August 3 and approved on August 6, 2026.

## Result

The paper's polynomial-time DCP theorem is not established by the published
proof. Three central arguments fail before the claimed lattice and LWE
corollaries can be reached.  A new natural-language two-copy Fourier analysis
also finds a clean-oracle obstruction to the Steps 2--7 decoder: its exact
no-guard `keep-u` variant is asymptotically unbiased, and the paper's guarded
variant has the same predicted limit subject to one explicit Parseval
perturbation estimate.  This negative calculation is not yet a Lean theorem.
The strongest global replacement found is an exact half-turn/ParityPGM
measurement.  Random subset-sum fibres make its whitening exponentially close
to trivial on the occupied fibre-uniform support, but no polynomial
implementation was found.  The standard routes examined either retain an
exponential cost in their stated models or fail to supply the missing
operation.  Thus the obstacle is now both a proof gap and an algorithmic
implementation gap, not merely a missing concentration estimate.
A precise constructive interface has nevertheless been isolated.  A one-pool
version uses `n+O(log n)` correction coordinates and a reversible modular
subset-sum encoder.  More strongly, a two-pool cross-filter plus a large common
label pool needs only a bounded, verifiable random-target find-one solver on
exactly `n` correction bits with inverse-polynomial average success: running
both solver calls on both branches makes their outputs and workspaces common
garbage, so canonical rank/unrank is not an additional requirement.  The large
label pool removes the earlier projection loss.  No such polynomial
density-one RMSS finder is known here, and compatibility with unknown fixed
faulty coordinates remains open: under the paper's marginal fault scale the
naive common-label overlap can lose `2^(-Theta(n/log n))`.  Separately, a
random-singleton oracle calculation proves
that hash isolation plus an arbitrary one-shot joint POVM still needs
`Omega(sqrt(D))` queries for constant phase advantage.  That lower bound is
restricted to the oracle model and leaves explicit arithmetic circuits open.
The common-label loss is construction-specific, not an information-theoretic
limit.  A fixed-block random-code calculation proves that a collective PGM on
`12*n` raw samples decodes the complete secret with error
`O(1/log n)+2^(-Omega(n))` under the repository's marginal fault bounds.  The
statement is averaged over the iid-uniform public labels and uniform over
every low-weight fixed fault pattern and arbitrary fixed faulty bits;
excessive patterns are charged by Markov.  The PGM is a dense polar measurement
with exponentially many error-labelled columns, and no polynomial
implementation is supplied.  Fourier transformation of the cyclic secret
label gives an exact direct sum of fibre-restricted Walsh polar transforms;
the irrep label is easy, while the exponentially large subset-sum multiplicity
space remains.  In the natural projected-unitary/QSVT realization the block
singular values are `Theta(N^(-1/2))`, giving a route-specific
`Theta(sqrt(N))` constant-accuracy cost, up to approximation logarithms.  Thus
the new result strengthens the existence
side while leaving the algorithmic verdict unchanged.
A random binary-syndrome measurement gives a further exact positive
preprocessor: jointly measuring the syndrome and the subset sum modulo
`N/2` preserves the parity phase, including on a fixed faulty affine subcube,
and reduces the path space to a critical-density code-constrained RMSS core
when its rank is tightly matched to the hidden fault count; otherwise the core
is mis-tuned--larger under a conservative cap, or smaller and potentially
underdense once excess faults consume the slack.  Its label-averaged residual
target fraction remains about `1/N`, so
Gaussian elimination does not finish the decoder.  The strongest explicit
`Y`-dependent syndrome pairs labels by their residues
modulo `B=Theta(n)` and removes `Theta(log n)` modulus bits, but a no-reuse
layer retains at most one quarter of its input population asymptotically with
high probability and cannot be iterated to a small modulus while maintaining
density one.  Arbitrary
overlapping CNOT/syndrome branches have an exact affine-code normal form:
removing `m` modulus bits requires simultaneous carry congruences through
degree `m`.  An all-embedding SNF/counting bound goes further: for `q=12*n`,
with high probability no affine coset of dimension at least `91` is contained
in one `f_Y mod H` fibre, even under selection after seeing `Y`.  The
syndrome-isolated core
escapes because the additional modular measurement leaves a generally
non-affine intersection.  A clean triangular checksum factorization removes
`log q-O(log log n)` low bits without rejecting any checksum outcome, but its
quotient is nonlinear and any all-outcome fixed-garbage continuation remains
limited by the `O(log q)` raw valuation chain.  On the clean cube, coarse-fibre indexing is
easier but still insufficient: exact residue-DP rank/unrank costs
`O(poly(q)*R)` modulo `R`, and an ordinary checksum preserves a fresh linear
quotient on a small-knapsack fibre.  Polynomial `R` removes only `O(log n)`
bits; refinement to the half-turn scale is exponential in this trellis
realization.  Phase-calibrated fixed-point amplification approximately
synthesizes a balanced fibre in `O*(sqrt(R))` queries at constant error, where
`O*` suppresses polynomial factors in `n` and logarithmic factors in
precision.  Coarse DP plus residual search costs `O*(sqrt(N*B))` ordinary
gates; ideal preloaded QRAM yields only an exponential `O*(N^(1/3))`
time--memory tradeoff.  The ordinary-checksum
state itself has polynomial MPS bond, while the parity-difference kernel has
`M=N/T` flat operator-Schmidt sectors and needs `Omega(M)` bond for
constant-relative-Frobenius MPO approximation on typical branches.  This is
not a general circuit lower bound.  Every `O(log n)`-local final matching after the triangular
checksum chart has exponentially small expected Born-weighted coverage over
the iid public high labels at the stated parameters.  A reversible basis
preprocessor plus one Hadamard yields an RMSS finder whenever it has
inverse-polynomial mass-weighted advantage; on the clean cube, exact full
basis pairing needs a live raw `H` label, although abstract partial matching
is nearly complete in expectation.
Separately, a query adversary strengthens the scoped
implementation barrier: even with free arbitrary powers of the orbit shift
and the efficient low-weight reference-subspace reflection, parity needs
`Omega(sqrt(N))` reflection queries in that translation-covariant
orbit/reference model for bounded error.  General arithmetic circuits remain
outside the theorem.
The exact dyadic frame recurrence reaches the same boundary: its direct
realization needs coherent access to the preceding full fibre-support
projector, which a bare two-outcome parity measurement does not supply, and
direct expansion doubles the orbit branches per modulus bit.  In the iid
averaged/dephasing model, passive `X`
measurements give a complementary positive result--`O(n)` samples identify
`{d,-d}`, hence the target parity--but the direct FFT decoder costs
`O(N log N)`.  The exact Bayesian answer is the ratio of two coefficients of
a weighted ternary subset-sum polynomial under a uniform secret prior; direct
likelihood filtering exposes
an at-most-`O(1/N)` useful-posterior heralding probability in that normalized
state-conversion model.  Uniform importance sampling has exact squared
coefficient of variation `N*sum_k pi(k)^2-1`; it takes linear-in-`N` samples
when the posterior has constant effective support.  For a nondegenerate
secret, a Hellinger bound proves that high-visibility `q=12*n` data
concentrate on `{d,-d}` with high probability, while uniform correct-parity
candidate sampling still has
`N/4-o(N)` relative variance.  At `q=12*n`, in the
matched passive model with a nondegenerate secret, ordinary absolute-weight
sign reweighting has average-sign magnitude at most
`N^(-4.06843+epsilon)` with high
probability for every fixed `epsilon>0`; this does not lower-bound a direct
arithmetic coefficient algorithm.  At visibility `1-Theta(1/log n)`, a
uniformly accurate `poly(n)`-sparse trigonometric expansion of the log
likelihood gives a precise constructive optimizer interface.  The radix
envelopes analyzed here remain too loose to certify polynomial pruning, and
scalar polynomials in `G_J` below the
displayed `Theta(n/log n)` threshold cannot create its half-turn harmonic with
high probability.  The natural parity-constrained group-moment/SOS hierarchy
also admits a factor-aligning rank-one pseudo-solution until its explicit
matrix is exponential.  A polynomial sparse-circulant/QSVT correlation filter
can mark `{d,-d}`, but its target input mass is only `Theta(q/N)` on the
natural sparse-data state, retaining an `Omega(sqrt(N/q))` state-conversion
cost.
The sparse score also gives an exact parity-constrained circulant SDP, but
Fourier diagonalization leaves `N/2` candidate atoms and the generic quantum
SDP interfaces examined here retain square-root dimension dependence or
assume stronger low-rank input, Gibbs preparation, or implicit oracles.  A
repeated-squaring construction gives a genuinely polynomial-
size exact unit-modulus QCQP, but its strengthened first-order Shor
relaxation is parity-blind with a growing gap.  The polynomial-size order-two
relaxation remains unresolved.  With high probability, the natural exact
factor graph has `Omega(n)` treewidth, coefficient BP has exponential support,
and uniform bitwise BP has no inverse-polynomial first-round seed; these
statements do not cover a different arithmetic compression.
The formally perfect signed top-projector trace ratio still has normalized
signal `2/N`; polynomial spectral traces, determinant ratios, and resolvents
are exactly the same half-turn relation sums.  A separate Euclidean
formulation reduces passive parity to rank-one two-coset CVP: at visibility
one, `q=12*n`, and secret phase order `M_d=2^(Omega(n))`, approximation factor below
`1.3448` would suffice on these typical instances, while the standard
LLL/Babai, BKZ, BDD, embedding, and
phase-unwrapping routes audited here do not provide it in polynomial time.
An exact pair-product
recursion creates passive samples over smaller 2-adic moduli.  Writing its
initial visibility as `lambda_pass`, the visibility is
`2*(lambda_pass/2)^(2^ell)` along nondegenerate levels, including an odd
secret before the final modulus, limiting polynomial no-reuse recursion to
`o(n)` removed bits.  Parseval now gives a sharp
statistical-query boundary: against
the conventional adversarial `STAT` oracle, polynomially many adaptive
`STAT(1/poly(n))` queries have uniform-secret average parity advantage at most
`poly(n)/N`, although individual-example and collective quantum algorithms
remain outside that model.  The chosen-query sparse-Fourier and
hidden-number methods examined here do not directly instantiate on this
one-pass random sample set.  An explicit robust parity-only observable exists
uniformly on the coherent low-weight-error subspaces on the Gram-good event,
but its known multiplexed-polar implementation remains `Theta(sqrt(N))` at
constant accuracy in the standard projected-unitary/QSVT access model.  In
the clean orbit dictionary, the raw signed-frame LCU is coefficient-unique
and constant-error parity approximations retain `Omega(N)` normalization;
directly signing the purified density block
costs `Omega(N)` rather than the frame route's `Theta(sqrt(N))`.  A
bounded-output fermionic-Gaussian circuit is also exactly parity-blind below
the signed-relation threshold.  A linear-output disjoint-pair matchgate
escapes this theorem and gives exponentially reliable maximum-likelihood
parity, but its efficient postprocessing is exactly the unresolved weighted
`A_0/A_H` coefficient problem; Pfaffian evaluation is only pointwise.
These statements are explicitly scoped to their circuit/access models.  A
separate exact operator-Schmidt theorem rules
out low-bond Frobenius/MPO compression only.
Ordinary pairwise/list collimation retains its subexponential resource law and
suffers an additional explicit-relation survival loss in permitted
hidden-fault models.  None of these statements is an unrestricted circuit
lower bound.

## Lean formalization targets

The source contains no `sorry`, `admit`, or handwritten project-local axioms.
A clean Arch WSL build, including the Lemma 1 repair and current Lemma 3 repair
modules, completed all 8665 jobs successfully on August 11, 2026.
`SimonDCP/AxiomAudit.lean` prints the axiom dependencies of the principal
results.  Analytic theorems contain only `propext`, `Classical.choice`, and
`Quot.sound`.  The finite exhaustive searches, including the six-coordinate
prototypes and four-bit adaptive-sector toy model, also expose their generated
`native_decide` evaluation certificates.  No result depends on `sorryAx` or on
a user-declared mathematical axiom.

### Ideal sample and Step 2 phase extraction

The ideal input is represented as the normalized QuantumAlg pure state

```text
(|false, x> + |true, x + d>) / sqrt(2).
```

Its only nonzero Born probabilities are the two displayed labels, each with
probability `1/2`. The phase factorization in Step 2 is proved from the explicit
root condition `omega^(2^(n-1)) = -1`; the relative high-bit phase is
`(-1)^(d mod 2)`.

At the classical Fourier layer, Mathlib's unnormalized `ZMod.dft` is used with
its negative-kernel convention to prove the exact point-mass translation law
and the two-label factorization into a global phase and the relative DCP phase.

### Lemma 1 swap obstruction

The proof swaps two subset-selection bits and the low parts of the corresponding
sample values. Write

```text
y_i = B * H_i + L_i
y_j = B * H_j + L_j.
```

The new pair contribution minus the old contribution is

```text
B * (phi_j - phi_i) * (H_i - H_j),
```

which need not vanish modulo the measured modulus. For locally valid values
using the paper's `n = 8` bit split,

```text
n = 8, B = 4, H_i = 1, H_j = 0,
L_i = 0, L_j = 1, phi_i = 0, phi_j = 1,
```

the contribution changes from `1` to `5` modulo `128`. Thus the proposed local
swap does not preserve a measured subset-sum fibre.

This concrete `n = 8` witness checks the two-coordinate bit and range
constraints, but it is not itself a member of the paper's full event `D_Y`:
at `n = 8` there are only four possible low parts, while `D_Y` demands that
all `Q` low parts be distinct. The parameterized Lean identity for the error
term is the reusable obstruction. Embedding it into a complete `D_Y` instance
requires a separate sufficiently-large-`n` construction and is not claimed as
machine-checked here.

Accordingly, the current result invalidates the proposed injection argument;
it does not by itself prove that Lemma 1's probability conclusion is false.

The repair module proves two valid algebraic alternatives.  First, the low-part-only
swap is fibre-preserving exactly when the measured modulus divides
`B * (phi_j - phi_i) * (H_i - H_j)`; for a zero/one swap with modulus
`B * stride`, this reduces to `stride | (H_i - H_j)`.  Second, permuting the
complete samples together with the selection and Hadamard-output coordinates
preserves the subset sum and phase exactly and is bijective.

This does not complete the paper's original swap-based proof.  Since `phi` is
summed out after the Hadamard transform, a state-dependent permutation must be
chosen only from the
measured outcome.  A termwise weight-preserving proof must map the
`(h, s_1, ..., s_g)` interference classes by one fixed label equivalence; a
weaker map instead needs a direct proof that coherent target weight does not
decrease.  `SwapFiberRepair.lean` exposes the first route as a
`LemmaOneRepairCertificate`; no such certificate is currently constructed.
It also proves a concrete obstruction to the simplest full-sample repair:
permuting complete coordinate records only within their Step-3 groups preserves
the full group subset-sum labels, but cannot change the all-zero status of any
group or the total number of all-zero groups.  Such a plan therefore cannot map
`D_Y^bad` to `D_Y^good`; any useful plan must cross groups and separately prove
compatibility with the stored `s_j` interference labels.
The same obstruction holds for permutations that move each entire group by a
fixed group relabeling: Lean proves that the group-contribution vector transforms
by that relabeling, but also constructs an equivalence between the all-zero
groups before and after the move and proves their cardinalities equal.  Thus a
plan capable of increasing the number of all-zero groups must genuinely mix
coordinates across group boundaries.
For interference labels containing the full group subset sums, an additional
rigidity theorem uses outcome coherence to vary the erased selection string one
coordinate at a time.  If all Fourier samples are nonzero and the certificate's
fixed label equivalence is induced by a group relabeling, these probes force its
coordinate permutation to move whole groups, so the all-zero-group cardinality
is again unchanged.  The paper retains only the most significant `log n` bits
`s_j`, not the full sums, so this rigidity theorem is a precisely scoped
obstruction rather than a proof that every possible truncated-label repair is
impossible.
Lean also checks that truncation does not make arbitrary mixed-group swaps
valid.  In a two-group, six-coordinate witness, the samples
`17, 34, 51, 68, 85, 153` have pairwise-distinct residues modulo `16`.  The full
measured fibre `z = 76 (mod 128)` contains four selections.  They all have the
local complete label `(h, s_a, s_b) = (1, 3, 9)`, while their Hadamard signs are
`+1, -1, -1, +1`; the displayed bad outcome therefore has zero coherent
probability.  A partial cross-group complete-sample swap creates an all-zero
group, splits the one source class into four target labels, and changes the
normalized local weight from `0` to `1/64`.

The finite search in `LemmaOneFiniteSupportPrototype.lean` exhausts all `64`
hidden selections and `720` coordinate permutations.  Exactly `288`
permutations create an all-zero group, exactly `72` allow the target label to
factor through the occupied source label, and these are exactly the whole-group
movers.  No permutation does both.  The other `648` permutations all have raw
target weight `4`, compared with raw source weight `0`.  An exhaustive second
search covers every measured output mask: all `27` masks with at most three
ones and no all-zero group have raw source weight zero.  Thus this is a valid
obstruction to the exact interference-class route, but not to every weighted
injection: every local bad outcome has no mass.  Moreover, division by `16` is
only a local truncation surrogate and is not asserted to instantiate all of
the paper's parameter relations.

There is a separate swap-free repair program.  Restricted Parseval gives
`Pr[D_A = 0 | Y, z'] >= 2^(-|A|)` for every coordinate set `A`.  It immediately
proves an inverse-polynomial `Omega(n^(-c))` version of Lemma 1, which can be
amplified by polynomially many fresh repetitions.  If Boolean subset sums are
injective modulo `2^(n-1)` on every union of two groups, restricted Parseval
makes the group-zero indicators pairwise independent and Chebyshev gives
failure probability `O(log n/n)`.  `LEMMA1_REPAIR.md` records the derivation and
the exact scope of the resulting fixed-environment theorem.
`RestrictedParseval.lean` and `LabelledParseval.lean` machine-check the
character identity, its collision-count expansion, and the diagonal bound over
all occupied complete labels.  `LabelledBornProbability.lean` normalizes the
finite mass by `2^Q * |Z_Y|` and proves the rational `2^(-|A|)` bound.
`BoundedTail.lean` machine-checks the weighted tail inequality and the exact
ratio `(k-c)/(k*n^c-c)`.  The rational Bayes step and dyadic affine-dimension
simplification are formalized in
`ResidueConditioningBound.lean`.  `OneTimePadCounting.lean` proves the key
fibre-equicardinality translation for one selected free outside coordinate.
`AffineResidueCounting.lean` now sums this result over any finite selection
support, proves the bad-inside joint-count bound, and computes the independent
full-sample marginal while distinguishing the `delta` and `epsilon`
exceptional sets.  `FiniteConditioningMass.lean` normalizes those counts, and
`ResidueConditioningAssembly.lean` assembles the complete finite conditional
bound.  `TernarySubsetSumBound.lean` proves the normalized
`(3^a-1)/|G|` collision estimate.  `TernaryProjectionBridge.lean` transports
this estimate to the concrete local Boolean injectivity predicate, while
`SimultaneousLocalInjectivity.lean` and `GroupUnionFamily.lean` union it over
the at-most-`N^2` one- and two-group family.  The coordinate-subcube support,
its exact exceptional branches, and its dyadic dimension estimates are proved
in `CoordinateSubcubeSupport.lean` and `CoordinateSubcubeParameters.lean`;
`CoordinateSubcubeConditionalInjectivity.lean` integrates out the irrelevant
inside coordinates and gives the explicit one-set conditioned ternary bound.
`FaultySamplePhase.lean` and `BooleanMaskBridge.lean` account for fixed faulty
selection bits and identify the resulting support with the mask model.

The paper's Step-1 formulas require an explicit correction at this point.  Its
text defines a correct sample as `2^(-1/2) sum_b |b,x+bd>` and a faulty sample
as `|b,x>`, but the displayed combined product shifts every coordinate by
`b_i d`, including faulty coordinates.  These descriptions are inconsistent.
The formalization follows the stated faulty sampler: only correct coordinates
receive the secret shift.

`FaultyBasisSample.lean` proves that a single faulty basis sample has uniform
Fourier-position and Hadamard outcomes and only the expected unit phase.
`FaultPatternProductAmplitude.lean` constructs the normalized product
selection state, proves that its support is exactly the coordinate subcube,
and computes its exact Born law.
`FaultPatternFourierProduct.lean` supplies the phase-free product amplitude.
`MixedFaultPatternFourierProduct.lean` then defines the corrected analytic
mixed correct/fault amplitude and proves that it is the phase-free amplitude
times an explicit unit secret phase.  Its pointwise support, squared norm, and
uniform Fourier-vector marginal are therefore exact for every fixed fault
environment.

`StepTwoMeasurementBridge.lean` models the measured low `n-1` bits by the
canonical quotient `ZMod (2^n) -> ZMod (2^(n-1))` and identifies the resulting
Boolean selection fibre with the coordinate-subcube mask fibre.
`StepTwoJointKernel.lean` normalizes the exact joint law of the full Fourier
vector and measured residue, proves total mass one and the required local
uniformity, and identifies its real cast pointwise with the mixed-amplitude
Born mass summed over that measured fibre.

The actual secret exponent omits the fixed faulty coordinates, while the
classically computed Step-2 sum includes their fixed offset.
`FaultyHighBitCarry.lean` proves that, after conditioning on the measured
residue, the resulting borrow/carry contributes only a common unit phase.  The
remaining selection-dependent factor is captured by the paper-style high bit
`h`, so no extra carry label is required.  `StepFourLabelPhaseBridge.lean` and
`ActualStepFourBorn.lean` then factor and normalize the raw projected Hadamard
amplitudes and prove pointwise equality between the analytic conditional
Step-4 Born law and the labelled Walsh law for the complete
`(h,s_1,...,s_g)` label on every reachable Step-2 fibre.  Under the corresponding
local subset-sum injectivity hypotheses, they also give exact one- and two-group
zero-event masses.

`CoordinateSubcubeProjection.lean`, `CoordinateSubcubeBorn.lean`, and
`LabelledBornPairwiseTail.lean` then prove the corresponding exact one- and
two-group Born moments under those injectivity hypotheses, normalize the full
output weight, and derive the paper-facing Chebyshev bound.
`FaultCountMarkov.lean` controls excessive faults from their marginal rates,
`FaultPatternSupportBridge.lean` identifies the resulting free-coordinate
cardinality, and `LemmaOneGoodEnvironment.lean` combines that event with local
collision failure without assuming independence.  This last theorem concerns
the prior environment law and must not be read as a residue-conditioned
posterior estimate.
`RandomFixedBitsMixture.lean` separately proves that uniform free and
fixed-fault assignments combine into a uniform full mask, with point and event
masses independent of the chosen fault partition.
`RectangularGroupPartition.lean` additionally closes the exact-divisibility
group-partition kernel (equal sizes, disjointness, and full coverage).  That
module itself does not choose a floor/ceiling convention; the rounded complete-
group schedule is handled by the rounded-parameter modules below.
`CoordinateSubcubeConditionalFamily.lean` closes the refined common-weight
family union under residue conditioning.  Independently,
`LemmaOneOuterAveraging.lean` proves injectivity monotonicity and the shorter
prior-bad-event plus uniform conditional-tail total-probability route.

`LemmaOneFiniteModel.lean` assembles the rectangular-group ternary-collision
term and the conditional Chebyshev term without assuming independence between
the layers.  It also proves a failure bound of `1/2` under explicit hypotheses
budgeting each term by `1/4`.  `LemmaOneFixedEnvironment.lean` instantiates this
finite theorem with `StepTwoJointKernel` and the analytic Step-4 Born law.  This
is an end-to-end lower-tail estimate for any one fixed classical fault
environment and the corrected analytic product-amplitude experiment.

`LemmaOneFaultEnvironmentAveraging.lean` additionally proves that this bound is
preserved by every nonnegative normalized finite classical mixture, with
environment-dependent positions, free coordinates, fixed bits, and summaries.
No independence assumption is used at this averaging layer.

This result is not a QuantumAlg gate/tensor-circuit equality and does not
construct a quantum density mixture over the paper's random
fault environments.  `RandomFixedBitsMixture.lean` proves a classical
uniform-mask pushforward only.  For a padded repaired sample schedule,
`LemmaOneRoundedParameters.lean` removes the power-of-two and exact-divisibility
restrictions by using a floor logarithm and fewer than one extra complete group
of samples.  It proves the mean lower
bound and verifies both explicit budgets for `k = 24`, `c = 12`, and every
`n >= 1024`.  `LemmaOneRoundedFixedEnvironment.lean` carries these parameters
through the fixed and classically averaged analytic chains to a failure bound
of `1/2`.  This completes and formalizes the repaired core
constant-probability statement of Lemma 1.  `LemmaOneRepaired.lean` defines the
complementary success event by an explicit event sum, proves exact
success-plus-failure normalization, and gives the direct success-mass-at-least-
`1/2` theorem for both fixed and classically averaged environments.  The
corrected faulty sampler and
the padding by fewer than one complete group are legitimate repairs rather
than blockers: this development targets the core mathematical claim, not a
verbatim formalization of the paper.  A quantum density/channel realization
would provide stronger implementation semantics but is not required for this
probability theorem.  Lemmas 3 and 4 and the later algorithm-level steps remain
open, so the paper's overall polynomial-time theorem is not established.
Lean proves that the outcome-coherence field makes the hidden-state map descend
through the erased selection string to an involutive map on measured outcomes,
and that every structural certificate therefore induces an injective
bad-to-good measured-outcome map.  This still does not prove a weighted
injection on projected `(Y, D)` outcomes.  Completing this original injection
route--as opposed to the swap-free theorem above--would also require a
pointwise proof that the target outcome's probability weight is at least the
source weight.  The separate
`MeasuredOutcomeWeightInjectionCertificate` formalizes the last step and proves
that an injective, pointwise weight-nondecreasing outcome map bounds total bad
weight by total good weight.  No instance is currently constructed.

### Lemma 3 phase-correlation obstruction

Step 4 chooses the set `A` only from groups whose measured Hadamard string is
zero. Consequently `D_A = 0`, and the phase

```text
(-1)^(phi dot D)
```

depends only on `phi_B`. States with the same `B` part and different `A` parts
therefore have identical phases. They are perfectly correlated, not pairwise
independent as required by the variance argument in Lemma 3.

This invalidates the published proof route.  `LemmaThreeBornBounds.lean`
proves an independence-free replacement for the first clause: outcomes for
which both signed branch counts are below the squared threshold
`2^(-n) * t` have joint Born mass at most `2^(-n)`, provided the refined
incoherent path energy is normalized.  For an implicit exact-residue
component it proves the correct general estimate `C_n / L^2`, where `C_n` is
the total unnormalized component energy.

`LemmaThreePathRefinement.lean` proves the first normalization identity for an
arbitrary map from paths to complete transcripts and residual branches.  Thus
the transcript may include `D` and the adaptive value `A(D)`; no independence
of that map is assumed.  `ConditionalLinearForms.lean` separately proves the
necessary-and-sufficient rank-two kernel criterion for joint uniformity on a
fixed reachable affine conditioning fibre, but the Born-energy repair does not
need to establish that criterion for the adaptive experiment.

`LemmaThreePaperPathBridge.lean` now records the paper-shaped transcript
`(Y,D,W',S,h')`, adaptive compatibility, `h*` branch label, Boolean sign, raw
Hadamard/common factor, and an explicit finite coherent sum over each
transcript/branch fibre.  It proves that sum equals the `tPlus-tMinus` formula,
rather than merely defining the factorized expression.
`LemmaThreePaperPathEnergy.lean` proves compatible-path injectivity into
`(hidden,D)`, the exact squared Hadamard factor, total common-path energy at
most `1/|Low|`, and the resulting paper-shaped joint `2^(-n)` theorem.
Equality with the actual circuit Born amplitude and circuit-level
orthogonality of the `h*` branches remain required model-identification
obligations.  The concrete Step-2 state must also discharge the diagonal-energy
premise used by the finite-model normalization theorem.

The exact `z*` decomposition is not a normalized reversible refinement.  Its
projector depends on the later Hadamard outcome `D`, and the operator order
needed for the paper's path-restricted amplitude is opposite to “measure `D`,
then measure `z*`.”  A finite equal-amplitude four-bit Walsh toy model has
coarse Born mass `1` but adaptive sector energy `4/3`.  It refutes the generic
inference from coarse normalization to adaptive energy normalization; it is
not a paper-schedule counterexample.  The paper's second clause still needs
`C_n = O(2^(2*n))` for a joint `O(2^(-n))` tail; a probability conditioned on
acceptance mass `rho` instead incurs `1/rho` and needs the corresponding
acceptance-scaled budget.  It also needs
the Step-3--7 common-path identification and an explicit
joint-versus-postselected convention.  `LemmaThreeStepSixCarry.lean` proves
top-bit correctness outside the exact two carry windows, and
`LemmaThreeStepSixBitBridge.lean` now proves that the floor-rounded
`l_(s*) = 0` test excludes them for width `n = 2^ell` and a safely rounded
group count.  Its end-to-end theorem instantiates the paper schedule
`a = floor(2^ell/ell)` and proves the safety inequality automatically.  A
finite `n = 32` theorem shows that
upward rounding of the tested prefix is not a sound replacement.  The
natural-language repair and this boundary are recorded in `LEMMA3_REPAIR.md`.
`LemmaThreePostselectionSlack.lean` additionally proves that an
inverse-polynomial acceptance loss can be absorbed into an explicit dyadic
exponent reserve; its half-exponent specialization turns joint `2^(-n)` into
conditional `2^(-floor(n/2))`, preserving exponential negligibility.
`LemmaThreePaperFirstClause.lean` instantiates that result with the explicit
paper-shaped transcript weight and retained-model acceptance mass.
`LemmaThreeBudgetedFirstClause.lean` proves the sharper joint
`2^(-n)/|Low|` estimate and shows that an acceptance lower bound
`kappa/|Low|` cancels the same factor, leaving conditional `2^(-n)/kappa`.
The concrete Step-6 value of `kappa` remains to be established and is not a
formal consequence of normalization.  `LemmaThreeStepSixAcceptance.lean`
proves the exact all-zero Hadamard formula, a normalized destructive input
with zero all-zero mass, and a conditioning example where an unconditional
average `1/2` becomes retained joint mass `0`.  It also proves two-point
Parseval, showing that retaining both outcomes preserves mass in the one-bit
model.  The spectral calculation below shows that this acceptance repair does
not create a decoding bias in the corresponding clean multi-bit kernel.

Likewise, the corollary's bucket threshold has square `n^3`: a conditional
`O(1/n)` tail requires conditional bucket energy `O(n^2)`, or joint bucket
energy `O(rho * n^2)` before conditioning on acceptance mass `rho`.

`LemmaThreeAdaptiveFibreUpperBound.lean` gives a conditional conservative
bound: complex Cauchy--Schwarz controls coherent energy by the maximum fibre
size times explicitly normalized fine-amplitude energy.  Thus a fine space of
size `2^(c*n)` is safe at squared threshold `2^((c+1)*n)` once that
normalization is proved.  The actual `u(M,z)` identification and fine-energy
bridge remain open, and this is not the paper's `2^(3*n)` threshold at
`c = 12`.
`LemmaThreeBooleanFinePathUpperBound.lean` machine-checks the Boolean fine
space cardinality and the resulting explicit `2^(13*n)` threshold for
`c = 12`.
`LemmaThreeConservativeThresholdImpact.lean` further proves that using this
larger amplitude threshold in the corrected Lemma 4 calculation leaves the
nonnegative exponent `7*n/2 + faultLoss/2 + c*logN/2`; the `c*n` terms cancel.

`LemmaThreeToFourL2.lean` formalizes the main alternative: complex
Cauchy--Schwarz bounds the weighted amplitude error by total count `L2` error
times total coefficient energy, and a restricted-Parseval specialization
rewrites the latter as projection-collision energy.  This removes the need for
a pointwise `max_z |alpha_z|` bound.
`LemmaThreeStepSevenRegrouping.lean` proves that an explicit finite A/B double
path sum regroups exactly as `sum_z count_z*C_z`, gives its raw-scale L2 error
bound, and expands the coefficient energy as a within-residue ordered
collision sum.  The actual conditioned count moment, concrete Step-5--7 fibre
instantiation/collision budget, and the passage from an additive `L2` estimate
to the paper's multiplicative claim remain open.

`LemmaThreeCountEnergy.lean` makes the count-moment premise exact.  It proves
the centering identity, the collision expansion, and that selection-aware
weighted pair-collision moment factorization yields actual-mean energy
`(1-1/m)E[T]`.  A probability reading separately requires nonnegative
normalized weights.  It also gives a finite counterexample: two unconditioned
jointly uniform Boolean hashes have count-energy baseline `1`, but conditioning
the labels to be equal makes the energy identically `2`.  Fixing the complete
transcript therefore cannot preserve the paper's balls-in-bins variance merely
from unconditioned pairwise independence; fluctuations in the selected total
population add a separate exact term when the proof uses a global mean.

An analytic frame calculation further indicates that the first-`a`-zero
adaptivity is not the dominant loss.  In the machine-checked combinatorial
surrogate, retaining the complete selected string has diagonal weight at most
`choose(G,a)/q^a = 2^(O(n/log n))` at the paper's parameters.
`LemmaThreeFirstZeroFrame.lean` proves the exact finite incidence and
cleared-denominator surrogate bound; identifying it with the concrete circuit
frame operator remains open.  Coherent coarsening into `(z,W)`
is the obstruction.  `LemmaThreeCoherentFibreObstruction.lean` machine-checks
the deterministic Cauchy lower bound on squared fibre mass, including the
`2^(c*n)`-domain/`2^(2*n)`-label specialization.  It deliberately does not
claim that `B`-side signs or later filters preserve this lower bound.  In the
reduced equal-Step-2-fibre model before the later
`S/W` filters, an exact random-`Y` second moment is
`Theta(P_accept * 2^((c-1)*n))`; the available `A`-side labels appear to reduce
this only to `2^((c-2)*n)/poly(n)`.  For `c = 12`, the desired `O(2^(2*n))`
budget is therefore strongly implausible.  This is not yet a full
paper-experiment counterexample because a rigorous lower bound must still
include the nonlinear `S/W/l_(s*)` correlations and postselection.

The later two-copy calculation incorporates those records through their exact
Fourier kernels rather than trying to lower-bound the adaptive sector energy.
For each frequency `xi`, let `p_xi` be the exact nonterminal zero-group kernel.
Interval Parseval implies that all but polynomially many of the `2^n` modes
have `p_xi=(1+o(1))/q`.  The first-`a`-zero rule has exact transfer

```text
Pr[Binomial(G,p_xi) >= a],
```

which tends to one on those modes because `G/q=(k/c)*a` and `k/c>1`.  In the
no-guard retained-`u` variant, the exact terminal kernels are
`1/(2*q)` for the wrong output and `p_xi-1/(2*q)` for the correct output.
Consequently both joint masses are `1/2+o(1)`.  For the paper's original
zero-low-Hadamard branch, the corresponding pre-guard diagonal wrong kernel is
`1/(2*q*L)`, `L=n/2`.  Completing the guard-restricted Parseval perturbation
estimate is expected to give correct and wrong mass `g/(2*L)+o(1/n)` and
acceptance `g/L+o(1/n)`, with safe density `g=1-O(1/log n)`.

This does not directly refute either isolated Lemma 3 clause.  It exactly
refutes the unguarded keep-`u` decoder and, conditional on the stated guard
estimate, contradicts the branch-closeness consequence needed by Lemma 4 and
the claimed inverse-polynomial decoding bias.  The full all-frequency formula,
which retains the necessary `h*` sector indicators, is recorded in
`LEMMA3_SPECTRAL_OBSTRUCTION.md`.

The proposed global alternative has also been investigated rather than merely
named.  For subset-sum fibre states `|F_t>`, the polar part of an explicit
signed sum of product-state projectors maps `|F_t>` to `|F_(t+N/2)>` exactly.
This proves information-theoretic existence of the required half-turn action.
For random `m=c*n`, `c>2`, instances, an exact second-moment/union-bound
calculation shows that all normalized fibre sizes are simultaneously close to
one with overwhelming probability.  Consequently the frame whitening is
close to the identity on the occupied fibre-uniform support (equivalently, on
the input space of `W_Y^dagger*W_Y`).  This is a real positive simplification, but not an
efficient circuit: the natural controlled product-state preparation exposes
the synthesis map only with amplitude `1/sqrt(N)`.  LCU, PREP/QSVT,
postselection, sampled projectors, FFT/Schur decomposition, tensor-network
contraction, 2-adic recursion, hashing, lattice, and local-relation approaches
all retain exponential cost in the analyzed models.  The best generic
coherent scale found is `sqrt(N)=2^(n/2)`.

The weaker two-outcome half-turn test need not be equivalent to full fibre
sampling in an unrestricted circuit model, so this is not a general lower
bound.  The remaining opening is a distribution-specific collective circuit
that decodes only one parity bit.  Such a circuit would already constitute a
new polynomial one-bit DCP algorithm, rather than a routine repair of the
paper.  The operator formula, random-fibre estimate, implementation audit,
high-density boundary, local-relation bound, and fault-model caveat are in
`LEMMA3_HALF_TURN_ERASER.md`.

The audit verdict on Lemma 3 is therefore negative at the level relevant to
the headline theorem.  Sound finite inequalities have been recovered and are
valuable independently, but Lemma 3 has not been repaired as a component of a
polynomial-time DCP algorithm: its paper experiment is not fully identified
with the finite model, the adaptive second-clause energy budget is open, the
decoder is spectrally obstructed, and the only global replacement found lacks
a polynomial implementation.  This does not prove that every interpretation
of either isolated clause is false, nor that polynomial-time DCP is
impossible.

### Lemma 2 algebraic kernel

Translation by `2^(n-1)` modulo `2^n` is an involution. This is the sound
order-two translation underlying the paper's Lemma 2 and is formalized
separately from the invalid probabilistic arguments.

### Measured-XOR transfer and recursion

For fixed `h' = h XOR hStar`, the compatible value of `h` is unique and

```text
(-1)^(h * dBit) = (-1)^(h' * dBit) * (-1)^(hStar * dBit).
```

The first factor is a global phase. Separately, subtracting a known low bit
from the branch-one position and removing the common base parity makes both
branches exactly divisible by two, with reduced hidden shift `(d - dBit) / 2`.
Neither result supplies the missing reversible implementation or distribution-
preservation proof.

If the remaining qubit really is the exact normalized state
`(|0> + (-1)^dBit |1>) / sqrt(2)`, the QuantumAlg model proves that a Hadamard
gate followed by a computational-basis measurement returns `dBit` with
probability one. The disputed lemmas are precisely what fail to establish that
premise for the paper's conditioned state.

### Conditioning, overflow, and cancellation obstructions

Finite-count examples prove all three of the following:

- independent Boolean coordinates can become perfectly correlated after
  conditioning;
- adding a correlated overflow bit can collapse a balanced bit to a constant;
- equal numbers of signed contributions do not control amplitudes when terms
  cancel.

These are direct obstructions to the inference pattern used in Lemmas 3 and 4,
unless the paper supplies stronger conditional-independence and anti-
cancellation hypotheses.

For comparison, the development also proves the valid unconditioned theorem:
under a uniform mask in the full space `F_2^n`, a nonzero linear form is
balanced, and two distinct nonzero forms have four equal-cardinality joint
fibres. The proof constructs dual masks explicitly. Its hypotheses fail after
the paper selects `A` from the zero coordinates of that same mask and
conditions on the resulting measurement record.

### Lemma 4 quantitative repairs

The page-14 calculation retains an extra `+n`.  Its standard-deviation exponent
already includes `-n`, which is cancelled when multiplying by
`kappa' = 2^n`.  Removing the extra term changes the total exponent from

```text
E_print(c) = ((11 - c)/2) * n + faultLoss/2 + (c/2) * log n
```

to

```text
E_corrected(c) = ((9 - c)/2) * n + faultLoss/2 + (c/2) * log n.
```

At `c = 12`, the corrected exponent is at most `-n` whenever
`faultLoss + 12 * log n <= n`.  If the printed expression is retained instead,
the same type of bound is recovered at `c = 14` under
`faultLoss + 14 * log n <= n`.  `Lemma4Parameters.lean` proves both statements
and the corresponding base-two real-power inequality.

If the extra `+n` is left in place, the `c = 12` expression is still
`-n/2 + o(n)`.  Conditional on it being a simultaneous absolute error bound for
normalized amplitudes, it is exponentially smaller than every downstream
polynomial loss and would suffice for the final inverse-polynomial error goal.
It does not prove the literal `< 2^(-n)` line or any multiplicative ratio near a
zero amplitude.

The same module proves that uniform bin multiplicity factors out as `mu`, while
the total cardinality is the number of bins times `mu`; substituting
`|A_(g_a)|` therefore inserts an extra bin-count factor.  It also propagates the
corollary's stated `n^(3/2)` amplitude bound: at `c = 12` the resulting aggregate
polynomial exponent is `-2`, so replacing it by the unsupported bound `n` is
unnecessary.  Only additive signed-sum error control follows without a
non-cancellation hypothesis.

## Remaining invalid or missing obligations

- The original proof of Lemma 1 assumes an unproved sign symmetry and
  lacks a concrete reversible bad-to-good plan preserving all Step-4
  interference classes.  The swap-free finite-model route avoids that premise,
  and completes the repaired core Lemma 1 theorem through the Step-2 joint law,
  concrete Step-4 label, final constant-probability bound, rounded complete-
  group schedule, and finite classical environment averaging.  A
  gate/tensor-circuit equality or quantum density-mixture construction would be
  a semantic strengthening, not a missing premise of this repaired probability
  theorem.  Later algorithmic steps remain open.
- Lemma 3 varies `D` as if it changed only signs, although changing `D` can
  change the adaptive `A/B` partition and later measurement records.  The new
  path-energy argument repairs the paper-shaped finite analytic bound in the
  first clause, including its compatible-path normalization; its actual
  Step-3--7 circuit Born-sum and branch-orthogonality identification remain.
  The second clause
  reduces, for the joint convention, to an adaptive sector-energy budget
  `C_n = O(2^(2*n))`; after conditioning on acceptance mass `rho`, the same
  literal tail scale requires `C_n = O(rho * 2^(2*n))`.  Normalized coarse Born
  mass does not imply either budget, and the required estimate is open.
  Moreover, even proving these standalone bounds would not establish the
  decoder: the new clean-oracle spectral calculation makes the no-guard
  keep-`u` output asymptotically unbiased and gives the same conclusion for the
  guarded paper output pending an explicit Fourier perturbation lemma.
- Lemma 4 reuses pairwise independence after conditioning on
  `z'`, `D`, `A`, `W'`, `S`, and `h'`; no preservation theorem is supplied.
- The claim that the sets indexed by `q_(g_a)` have equal size ignores that
  `W'`, including the postselected `l_(s*)`, depends on `s_a` and hence on
  `q_(g_a)`.
- Correlated overflow terms do not necessarily increase uniformity.
- The all-zero `q_(g_a)` makes `s_a = 0`, contradicting literal pairwise
  independence over all `q_(g_a)` values (although this isolated exception may
  be asymptotically removable).
- The repaired Lemma 4 parameter arithmetic still relies on unproved
  conditional balls-in-bins, variance, and union-bound premises, and additive
  count control still does not imply a multiplicative amplitude ratio under
  cancellation.
- Only the deterministic Step-6 carry/top-bit arithmetic is closed.  Its
  postselection probability and decoding bias are not proved; keeping all low
  outcomes preserves mass but is spectrally unbiased in the analyzed clean
  model.  Recursive recovery of all bits, fault-rate preservation,
  amplification, and uniform circuit cost are also not proved.
- The lattice corollary relies on external Regev/BKSW reductions that are not
  formalized here. Its transitions among unique-SVP, approximate search-SVP,
  and LWE parameter conventions therefore remain source-qualified obligations;
  the exact conventions in the cited references have not yet been independently
  verified in this development.

## Formalization boundary

The current development proves kernel-checkable algebraic identities,
counterexamples, finite probability bounds, the repaired core Lemma 1
constant-probability theorem for both fixed analytic fault environments and
their arbitrary normalized finite classical mixtures, and the
  independence-free finite Born/path bounds for the first part of the proposed
  Lemma 3 repair and a budgeted tail theorem for its second part.  It now has a
  paper-shaped Step-3--7 analytic transcript interface and its common-path
  normalization, but does not yet prove equality with the actual circuit Born
  sum or the adaptive sector-energy budget.  The separate natural-language
  spectral note identifies a decoder-level obstruction but is explicitly not
  counted among the machine-checked results.  The global half-turn note proves
  its operator identities and random-fibre estimates only in natural language;
  it finds no polynomial implementation and makes no general circuit lower-
  bound claim.  It does not claim a
gate/tensor-circuit equality or a density-matrix model; those are optional
semantic strengthening for Lemma 1 rather than blockers to its core result.
The paper's overall theorem still needs the unresolved conditional phase and
amplitude claims in Lemmas 3 and 4, later adaptive measurement and
postselection semantics, error amplification, a suitable polynomial-cost
implementation argument, and the external lattice reductions.  Until those
obligations are supplied, the paper's overall polynomial-time theorem and its
SVP/LWE corollaries remain unproved.

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
generic PREP/QSVT route has coherent scale `2^(n/2)`.  A newly isolated
two-pool interface would suffice: with a large common label pool, two
independent correction pools of exactly `n` bits and any bounded, verifiable
random-target modular subset-sum finder with inverse-polynomial average success
give exact same-garbage half-turn pairing without the earlier projection loss.
The finder need not be canonical or sample a fibre uniformly, but no
polynomial density-one finder was found.  Moreover, in a
hash-isolated random-singleton oracle model, even an arbitrary one-shot joint
measurement needs `Omega(sqrt(D))` queries for constant phase advantage.  This
is an oracle-model barrier, not a lower bound for explicit arithmetic
circuits.  A new random-syndrome construction is an exact polynomial
phase-preserving preprocessor, but it stops at a density-one code-constrained
RMSS core only when its rank is tightly matched to the hidden fault count;
otherwise the core is mis-tuned--larger under a conservative cap, or smaller
and potentially underdense once excess faults consume the slack--and its
label-averaged marked fraction remains about `1/N`.  A separate adversary
reduction
shows that even free fast orbit translations plus the efficient reference-
subspace reflection require `Omega(sqrt(N))` queries in that
translation-covariant orbit-access model for bounded-error parity.  Lemma 4
and the paper's headline algorithm theorem therefore remain
unproved.

| Lemma | Status of the core claim | Published proof and repair status |
| --- | --- | --- |
| Lemma 1 | **Repaired and formalized** | The proposed low-part swap is invalid, so the repair replaces it rather than completing that argument. Restricted Parseval gives an unconditional inverse-polynomial bound, while the stronger route connects the corrected mixed correct/fault amplitudes, Step-2 joint law, complete Step-4 label, exact Born moments, collision-plus-Chebyshev bound, classical fault-environment averaging, and rounded parameters. For the padded repaired schedule with `k = 24`, `c = 12`, and every `n >= 1024`, the explicitly summed success event has mass at least `1/2`. This is the formalized constant-probability core needed from Lemma 1. |
| Lemma 3 | **Not repaired as support for the polynomial algorithm; standalone finite inequalities retained** | The published pairwise-independence argument fails after the adaptive choice of `A`. Lean proves an explicit paper-shaped signed-path identity and a joint `2^(-n)` finite-model bound under stated Step-2 energy and model-identification premises, plus the correct budgeted second-clause tail `C_n/L^2`; neither is yet an actual-circuit theorem with all paper premises discharged. Separately, a natural-language all-frequency two-copy calculation shows that the no-guard `keep-u` decoder has correct and wrong masses `1/2+o(1)` each. For the paper's zero-low-Hadamard step it predicts masses `1/(2L)+o(1/n)` each and acceptance `1/L+o(1/n)`; the concrete guard conclusion still needs its explicit Parseval perturbation estimate. The global ParityPGM candidate is information-theoretically sound but has no polynomial implementation. |
| Lemma 4 | **Unproved; required decoder premise is spectrally challenged** | The exponent, `mu`, and `n^(3/2)` bookkeeping errors are repaired. The new clean-oracle calculation contradicts the branch-amplitude closeness needed by the proposed decoder, once the remaining guard estimate is completed. The calculation is currently natural language, not a Lean countertheorem. |

**Verdict on Lemma 3.**  Lemma 3 is **not repaired in the sense needed by the
paper's polynomial-time algorithm**.  What is complete is narrower: sound
finite-energy inequalities replace parts of its probability algebra.  The
original experiment still lacks the model-to-circuit/Step-2 energy bridge; the
second clause still lacks its adaptive energy budget; and the decoder has a
separate spectral obstruction.  The strongest positive replacement found is
a distributional ParityPGM whose ideal action is exact and whose random-fibre
normalization is benign.  Implementing it in polynomial time would itself
constitute a new one-bit DCP algorithm, and no such implementation is supplied
here.  The free-plus-correction constructions in
[`LEMMA3_HALF_TURN_ERASER.md`](LEMMA3_HALF_TURN_ERASER.md) make the remaining
algorithmic target exact.  A one-pool reversible encoder is sufficient, and a
stronger two-pool symmetrization first reduces the task to an ordinary bounded,
verifiable random-target find-one algorithm near density one.  A large common
label pool removes the residual `2^(-s)` projection loss, so correction pools
of exactly `n` bits suffice; solver success is squared but remains
inverse-polynomial.  Random fibres contain enough representations
information-theoretically, but no polynomial finder is known here.  In the
paper's noisy regime, unknown fixed faulty coordinates can further reduce the
two branch-label overlap of this explicit construction by
`2^(-Theta(n/log n))`.  That loss is not information-theoretic: a collective
PGM on `12*n` preselected raw samples decodes the complete secret with error
`O(1/log n)+2^(-Omega(n))` under the repository's marginal fault assumptions,
averaged over the iid-uniform public labels and uniformly over all low-weight
fixed fault patterns and arbitrary fixed faulty bits.  No polynomial
implementation of this dense PGM is known.  An exact covariance reduction
shows why the obvious QFT does not finish the job: it removes the cyclic secret
label but leaves, in each residue block, the polar transform of a
fibre-restricted Walsh matrix.  At constant accuracy, the natural
projected-unitary/QSVT realization of that remaining transform still has
`Theta(sqrt(N))` cost, up to approximation logarithms.
Random binary-syndrome isolation preserves the half-turn phase exactly and
compresses a raw block to a density-one code-constrained core (of dimension
`n+O(log n)` only when the hidden fault count is tightly matched), but
Gaussian elimination only parameterizes that core: testing a uniformly
prepared difference still hits the required residue with probability about
`1/N` on average over the iid public labels in the Born-planted coupling.  A
concrete residue-pair implementation can remove
`Theta(log n)` modulus bits in polynomial time, but loses too much population
to iterate to a small modulus.  General overlapping CNOT/syndrome branches
admit an exact carry-congruence normal form.  More strongly, for `q=12*n`,
with high probability no affine coset of dimension at least `91` is contained
in one `f_Y mod H` fibre, even if selected after seeing `Y`.  The
syndrome-isolated core is
not contradicted because its additional modular measurement leaves a
generally non-affine intersection.
On a clean cube, a separate triangular checksum factorization removes
`log q-O(log log n)` low bits without rejecting any checksum outcome, but
leaves a nonlinear carry phase.  An all-outcome fixed-garbage recursion cannot pass the largest
contiguous raw valuation chain, so it still removes only `O(log q)` bits.
On the clean cube, coarse modular fibres are nevertheless exactly rankable: residue DP gives a
reversible chart modulo `R` in `O(poly(q)*R)` size, and an ordinary-integer
checksum leaves a fresh linear quotient on a small-knapsack support.  These
are polynomial preprocessors for `R=poly(n)`, but their known refinement cost
is exponential in the total number of peeled bits.  Phase-calibrated
fixed-point amplification improves approximate controlled fibre synthesis to
`O*(sqrt(R))` arithmetic queries, where `O*` suppresses polynomial factors in
`n` and logarithmic factors in the target precision.
Coarse DP modulo `B` followed by residual amplification still costs
`O*(sqrt(N*B))` ordinary gates; an ideal preloaded QRAM gives only an
exponential `O*(N^(1/3))` preprocessing/online time--memory tradeoff.
Moreover, the ordinary-checksum pure state has polynomial MPS bond while its
even-minus-odd kernel has `M=N/T` asymptotically flat operator-Schmidt
sectors.  Constant-relative-Frobenius MPO compression therefore needs
`Omega(M)` bond on typical branches, without implying a general circuit lower
bound.  After the triangular
checksum chart, every `O(log n)`-local final-half-turn matching has
exponentially small expected Born-weighted coverage over the iid public high
labels at the stated parameters.
Any classical reversible basis preprocessor followed by one Hadamard reduces
to an RMSS partner finder when it has inverse-polynomial mass-weighted
advantage; on the clean cube, full exact basis pairing exists only if some
live raw label equals `H`, although abstract partial matching is almost
complete in expectation.
Moreover, an exact translation-covariant
orbit/reference adversary theorem extends the square-root barrier beyond
QSVT: arbitrary fast orbit
powers and an efficient reflection about the low-weight reference space still
need `Omega(sqrt(N))` reflection queries for bounded-error parity.  This
remains an access-model result and
leaves circuits exploiting the internal Boolean modular arithmetic open.
An exact dyadic recursion reaches the same boundary in the natural frame
model: its direct realization needs coherent access to the preceding full
fibre-support projector, which a bare two-outcome parity measurement does not
supply, and expanding that projector doubles the orbit branches at each bit.
In the iid averaged/dephasing model, a complementary route measures
every raw qubit in `X`; `O(n)` passive samples then identify `{d,-d}`
statistically, but the evident correlation/FFT decoder scans all `N=2^n`
frequencies and no polynomial passive decoder was found.  At `q=12*n` and
`lambda=1-O(1/log n)`, an exact unbalanced split maps the score to
logarithmic-dimensional bichromatic nearest neighbor.  With ideal coherent-
QRAM access to a data-dependent ANN table,
this gives a conditional `N^(23/49+o(1))` time--space algorithm and approaches
`N^(7/15+epsilon+o(1))` for every fixed `epsilon>0`.  Direct ordinary-gate
QROM compilation loses the exponent, so this is not an ordinary-circuit
decoder.  Without a stored or algebraically invertible bucket index,
table-free rejection and a direct-predicate Cartesian Johnson walk return to
`sqrt(N)`.  A fixed-relative-error rare-cap polynomial surrogate needs degree
`Omega(log M)`, and the displayed `o(log M)` one-sided local even-moment
certificate leaves `M^(1-o(1))` expected blocks alive.  Conversely, a
certified factor-`C` interval log-sum-exp oracle would enumerate the rare row
in `O(C*u*log M)` expected calls.  It is exactly an implicit Gaussian-KDE
block-sum problem.  Black-box point-query implementations require `Omega(s)`
classical or `Omega(sqrt(s))` quantum queries per size-`s` block.  Even after
residue aggregation, cancellation-blind Bessel certification must retain
`(1-o(1))*N` residues.  On a low block, optimal iid unbiased single-
multi-index importance sampling still needs `N^(4.303...-o(1))` or
`N^(4.472...-o(1))` samples to reach additive RMSE `O(exp(u^2))` at the two
splits.  The unweighted, untruncated full-spectrum Fourier `L_2` certificate
cannot prune.  The phase-averaged zero residue is amplified by
`N^(0.78...+o(1))` to `N^(0.80...+o(1))` over a uniform energy share.  Even
after adaptive exact Fourier retention, positive-diagonal global-Fourier
tails leave the whole interval tree unprunable below retained-set exponents
`0.3774...` or
`0.3661...`.  More generally, an adaptive `N^r`-dimensional subspace of
orthonormal-family coherence `N^eta` and a non-diagonal ellipsoid of condition
`N^chi` cannot prune an `N^sigma` interval when
`r+sigma+2*eta+chi<R_*`, where
`R_*=4*sqrt((1-rho)*gamma)-4*gamma`; the incoherent,
well-conditioned whole-tree budgets are `0.4795...` and `0.4772...` at the two
splits.  Random-orbit KDE blocks are `(1+o(1))*I`, and every feature span
fixed before the Gaussian query needs `s/N^o(1)` dimensions for a factor-
`poly(n)` certificate.  Full-row adaptive rank is vacuous because one vector
represents the row but has overlap `Z_I`; on a generic orbit, `2*q` exact
consecutive point queries recover the row.  Yet the exponentiated row has all
`N` cyclic Fourier modes and maximal rank across every index-bit cut almost
surely.  Exact open-boundary TT/MPS needs bond at least `sqrt(N/2)`, and its
scalar block moment recurrence has full order.  Shared factor-`poly(n)` scalar
features for all blocks need rank `N^(1-gamma-o(1))` at source queries and
`N^(1/49-o(1))` or `N^(1/45-o(1))` at Gaussian root blocks.  Every one-block
subtraction-free positive formula fixed before the query needs at least
`|I|` exponential leaves for any global finite-factor approximation.
Conversely, a typical rare-cap row has an `N^o(1)` near-cap support whose
sparse prefix sums approximate every interval additively within
`exp(u^2)*n^(-A-5/2+o(1))` for every fixed `A>0`.  Even the sum of exact
discrete per-frequency maxima exceeds `u` on every nonsingleton cell with high
probability, forcing a frequency-separable tree to expose all `Theta(M)`
singletons.  Enumerating all critical points costs `Omega(M)` with high
probability.  A cancellation-aware thick-strip argument count gives
`2*rho_freq*ell+O(q)` complex zeros over width `ell`, where
`rho_freq=max_i|nu_i|`, so thick-strip complex-zero-free pruning
needs `Omega(M/q)` cells; every data-adaptive continuous ultra-thin graph
contour still has `Omega(M)` explicit denominator crossings with high
probability.  These facts do not block direct real root counting.  For
aggregate winding, the sparse curve `Psi_w=F+i*N^-10*F'` stays `N^-11` from
zero with high probability; its straight-chord closure has winding `-R_v/2`
and total phase variation `pi*R_v+o(1)`, while retaining at most `2*q+1`
exponential slots.
A predetermined dyadic endpoint grid gives an output-sensitive locator
conditional on a polynomial-cost winding evaluator specialized to this
iid-Gaussian family; constructing that distribution-specific evaluator remains
open.  Unless `NP subseteq RP`, no exact or one-sided-certified evaluator with
the same guarantee exists uniformly for general adversarial sparse inputs: an
exact-power-of-two
centered-band Unique-SAT construction preserves an `N^-11` gap,
`|Wind|<=1`, and `TV(arg)=2*pi*|Wind|+o(1)`.  Root conditioning needs only
polynomially many bits.  Standard coefficient-explicit Cayley-transform/Sturm
and
Markov--Lukacs/SOS conversions have `Omega(N)` size, while the threshold
sequence along every dyadic stride `s<=M` has exact minimal recurrence order
`2*q+1` with high probability.  An adversarial short-arc reduction from
Plaisted makes coefficient-uniform exact counting NP-hard already for
`M=N^(1/9)` and at most `q=12*log_2(N)` rational Laurent terms.  Predetermined
windows whose component count plus total length is `N^o(1)` hit the random
near-cap only with probability `N^(-gamma+o(1))`; constant success needs
`N^(gamma-o(1))` coverage.  In the size-biased cap experiment, with high
probability over the labels, a fixed rank-`r` linear sketch with a vanishing-
error candidate list needs list size `m^(1-r/(2*q)-o(1))`, so an `m^o(1)`
list retains almost all `2*q` coordinates.  With high probability over the
iid labels, `E_G[(H_v)_2|Y]/(m*p_cap)^2=N^(kappa_2(gamma)+o(1))`, where
`kappa_2(1/9)=0.00070412602694...`; the label-conditional size-biased row sees
the same exponential expected number of additional caps.  This rejects the
naive matching-factorial-moment Poisson heuristic but remains a conditional-
moment statement, not typical-`G` or ordinary-hit clustering.  Under the
ordinary hit law, even nonlinear Gaussian-adaptive windows chosen through a
summary `S_info` obey an information bound.  If their pointwise component
count plus total length is `N^(eta+o(1))`, success probability `alpha` costs
at least `[alpha*(gamma-eta-r_gamma)-o(1)]*ln(N)-h_nat(alpha)` nats.  At
`gamma=1/9`, `gamma-r_gamma=.111021964613784...`; a finite `B`-bit transcript
obeys the corresponding range bound.  This is an information or description
obstruction, not a time lower bound.  Yet, for every fixed
`0<gamma<=1/9`, with high probability over the labels the size-biased cap row
and the ordinary Gaussian row conditioned on a nonempty cap are
asymptotically singular: their squared
radii are separated at `s_cut=(s_0+1+a_gamma)/2`, where
`a_gamma=gamma*ln(2)/12` and `s_0=a_gamma/(1-exp(-a_gamma))`.  Thus the sketch
theorem does not transfer by a Poisson or contiguity argument.  These results
do not cover unrestricted full-amplitude global processing.  The
adversarial
reduction leaves the iid-Gaussian simple-root promise open.  Custom
sparse/circuit and random approximate
real-root locators remain open.
Rejection-based quantum
tilting returns to `sqrt(M/k)`.
Yet Kac--Rice gives
only `M^o(1)` expected crossings and accepted indices, so the implicit
partition-sum or sparse output-sensitive root locator remains the precise
opening.
Its exact Bayesian
decision under a uniform secret prior is the ratio of the zero and half-turn
coefficients of a weighted
ternary subset-sum polynomial; the direct dynamic program is exponential,
while the direct normalized likelihood filter reaches useful posterior mass
with at most `O(1/N)` heralding probability in its state-conversion model.  A
uniform importance estimator has exact squared coefficient of variation
`N*sum_k pi(k)^2-1`, hence needs linear-in-`N` sampling once the posterior is
sharp.  For a nondegenerate secret, a Hellinger bound makes the sharpness
quantitative: at `q=12*n` and high visibility the posterior is concentrated
on `{d,-d}` with high probability, while uniform sampling in the correct
parity class has
`N/4-o(N)` relative variance.  At the same parameters, in the matched passive
model with a nondegenerate secret,
ordinary absolute-weight sign reweighting has average-sign magnitude at most
`N^(-4.06843+epsilon)` with high probability for every fixed `epsilon>0`,
although this does not lower-bound a direct arithmetic coefficient algorithm.
For visibility `1-Theta(1/log n)`, the whole log likelihood also has a
uniformly accurate polynomial-size sparse trigonometric expansion.  A
polynomial global optimizer for that expansion would decode `{d,-d}`, but
the exact grouped triangle envelope is identical on `H/poly(n)` prefixes
with high probability, while one exact high-bit elimination can become
Fourier-dense.  These radix routes do not certify polynomial pruning.  Every
scalar polynomial in `G_J` below the
displayed `Theta(n/log n)` threshold has zero half-turn Fourier coefficient
with high probability.  The natural parity-constrained group-moment/SOS
hierarchy has a rank-one pseudo-solution coherently aligning each sample
likelihood factor in both parity classes until its explicit moment matrix is
already exponential, with high-visibility gap
`(2*ln 2-1)*q+o(q)`.  The same pseudo-point blocks bounded-word SOHS
certificates below that gap.  A sparse circulant/QSVT filter can
mark the two correlation modes in polynomial time, but from the natural
sparse-data state its target spectral mass is only `Theta(q/N)`, so this
state-conversion route still needs `Omega(sqrt(N/q))` amplification.
The same sparse score has an exact parity-constrained circulant SDP, but its
Fourier form is still maximization over `N/2` atoms; sparse PSD separation is
the original parity-restricted optimizer, and faithful group-algebra
representations still need `N/2` dimensions.  The full quotient state
simplex also has exact PSD extension size `N/2`; at the displayed hierarchy
depth, truncated character sketches and constant-relative-Frobenius low-rank
approximations remain exponential.  With high probability, the standard
Cayley/chordal Fourier-SOS construction also needs a frequency set and PSD
block of size at least `21*N/116`.
The standard quantum
SDP interfaces either retain square-root dimension dependence or require
stronger low-rank input, Gibbs preparation, or implicit-oracle assumptions.
An exact repeated-squaring lift does compress the
search to a polynomial-size nonconvex unit-modulus QCQP, which is now a
concrete positive arithmetic target rather than a decoder.  Its strengthened
first-order Shor relaxation is parity-blind with a growing integrality gap.
At order two, Hankel transport enforces harmonic squaring for aligned
occurrence trees, so that witness fails in the aligned-tree formulation; a
polynomial Laurent phase-closure test gives a conditional
pseudo-moment certificate.  On a typical no-short-relation event, every
single cycle has exponentially small planted correlation, and any nonlinear
cycle syndrome of odd-support rank below `(1/10-epsilon)*n` remains
exponentially parity-blind.  Saturated `tau_(i,m)=S_i^m` phase-certificate
feasibility therefore has no high-probability planted gap; the unsaturated
SDP value gap remains open.  For those coherent pins, with high probability,
every expanded proof below the displayed `Theta(n/log n)` net root-pin-width
threshold is phase-consistent for both parities in every standard phase-one
multiplication-tree layout.  Separately, using objective-coefficient phases
as the reference pins, a sign-conflicting loop forces the one-sided
separable-ceiling deficit `D>=2/R_C`.  Long compressed proofs and the
two-sector optimum difference remain open.  A randomized sixteen-bucket
reassociation makes
an exact cut-dissociation event exponentially likely, but an exact balanced-
depth-four counterexample proves that this event alone does not control
repeated Hankel interpolation.  The completed closure's formal provenance
lattice is exactly HNF/SNF-computable for each fixed compiler, while a random
bound on its odd-support rank remains open.  Full semantic row normalization
can be strictly stronger: it has typical parity-even odd-support rank `q-1`
and contains a parity loop of root-pin width at most `2*q`; under the matched-
sign law it usually rejects the coherent pins in both sectors.
An exact expander
identity buffer separately proves lift non-invariance for a redundant
quadratic formulation.  Neither construction settles the fixed aligned
arithmetic lift or produces a planted gap.  With high probability, natural
exact factor-
graph elimination has `Omega(n)` treewidth, coefficient BP develops
exponentially many residues, and uniform bitwise BP has no inverse-polynomial
first-round seed.  Taking a signed
spectral trace does not bypass normalization: the ideal trace ratio is
`(-1)^d`, while both normalized traces are only `2/N`; polynomial traces,
determinants, and resolvents reduce to the same signed half-turn relation
coefficients.  Independently, Euclidean passive decoding is a rank-one
two-coset CVP with a certified typical gap: at visibility one and `q=12*n`,
for secret phase order `M_d=2^(Omega(n))`, an approximation factor below
`1.3448` would recover
parity.  The standard
LLL/Babai, BKZ, BDD, embedding, and phase-unwrapping routes checked here do
not reach that conditional interface in polynomial time.
Pair products
provide an exact passive smaller-modulus recursion, but
if `lambda_pass` is the initial visibility, then along nondegenerate levels--
including an odd secret before the final modulus--their visibility becomes
`2*(lambda_pass/2)^(2^ell)` after `ell` levels, so a polynomial no-reuse
recursion removes only `o(n)` modulus bits.  At visibility one, a four-list
Wagner aggregate
formally reaches runtime `N^0.499463`, but shared supports create automatic
zero relations and make its parity-signal-normalized second moment at least
`N^(0.0073173+o(1))`.  Even optimistic independent-replica averaging has
formal raw-second-moment exponent `0.5026116`; this is a barrier for that SNR
analysis.  On this fixed support-weight/filter orbit, uniform weighting
minimizes the ensemble ratio among all data-independent real linear weights,
so thinning, signed reweighting, codes, and designs do not fix it.  With high
probability the same covariance exponent survives every public-label-adaptive
nonnegative fixed-degree weighting.  Every asymmetric exact-degree four-list
pair--pair route in the two-orientation raw-moment model has exponent at least
`1/2`; balanced standard trees in the same model with at least eight lists
exceed `0.6856`.
At the near-miss point, the explicit per-block-nonempty leading-Gram cutoff
whitener has diagonal-ratio exponent `1.5095`.  The regularized
degree-symmetric leading surrogate has an exact polynomial-size spectral
optimizer.  Its diagonal confines the only possible sub-square-root interval
to `0.02073134<p<0.02079354`.  An explicit hypergeometric-tail rank-two
certificate gives `delta>0.000205` uniformly there and puts that entire window
above `0.50020`, closing the named surrogate at the square-root scale.  The
exact `{z,-z}` block makes direct PSD promotion fail before orientation
quotienting.  After the quotient, exact filter classification gives
`C_+>=(2-o(1))*S_+`, and extra half-turn signal is dual-norm negligible.  The
bound therefore holds for the complete ensemble raw-second-moment problem
with fixed data-independent orbit-constant weights.  Whole-radial conditional
Loewner promotion fails on empty low-degree blocks, but every nonzero-signal
`Y`-adaptive signed weighting supported on at most `N^(1/20-epsilon)` distinct
supports has Rayleigh ratio at least `N^(1/20+epsilon-o(1))` on `E_short`.
The same bound holds when the effective `l_1` size is at most
`N^(1/20-epsilon)`, even with larger support; a signed-mass refinement gives
a quantitative bound for dense, predominantly one-sided vectors.  At
visibility one and the dangerous center, the exact resolvent equation
proves pair diffuseness
and leading-signal concentration.  A 49-column four-template certificate puts
quadratic relative variance at most `N^(-0.310083...+o(1))`.  Extra half-turn
signal is `o_p(q_0)`.  Thus that fixed deterministic resolvent has conditional
Rayleigh ratio `(2+o_p(1))*R_(sur,min)` with high probability.  On the
deterministic reference-mass bulk `p_r^(0)>=N^(-1/10)`, uniform matrix and
signal concentration gives the same ratio for the fully `Y`-adaptive signed
radial optimizer.  A square-correlation bound
`E[Xi]<=N^(-0.011538...+o(1))` supplies the missing Schur floor, so the same
ratio holds on the entire occupied-cell quotient.  Empty cells still defeat
whole-space inverse and coefficient-norm stability.  An augmented-PSD
same-cell algebraic witness with `Xi=0` shows that these inputs do not imply
an unrestricted nonradial theorem; it is not a modular counterexample.
A multiplicity-corrected centered-Schur interface shows that the full linear
extension would follow from a centered spectral floor with exponent below
`0.044828...` and normalized within-cell row regularity.  At visibility one,
inside one fixed balanced-cusp `Good` exact-degree cell, the PSD orbit-feature
Gram `K_orb` has
exact level weights `4^(-t)*choose(t,j)*(3^j+(-1)^j)`.  A finite joint
trace-four certificate proves central automatic occupancy `(MO1)`, with
operator error at most `N^(-0.0430009...+o(1))`.  A centered-row ledger gives
automatic normalized row energy with any exponent below `.239292...`; a
nonautomatic joint-rank certificate proves
`E[1_Good*Tr(E_rem^4)]<=N^(-.0032192935...+o(1))`, implying `(MO2)` and the
remaining part of `(MO3)`.  Thus the centered-Schur/equitability interface
closes for that cell.  More generally, every deterministic cell layer with
fixed expected-occupancy exponent `s<1/20` can, with high probability, be
adjoined to any core with spectral-loss exponent below `.009` and dual mass
at least
`N^(-.0073173282...-o(1))`, without changing that value.
At visibility one, the strict common-band certificate at `s_*=1/20` permits
one fixed `epsilon_H>0`, chosen by finite-witness continuity before the labels
are sampled, such that every deterministic cell with
`m_occ(r)>=s_H:=1/20-epsilon_H` belongs to a single global feature band and
has conditional-Gram floor `1-o(1)` and radial-centered norm `o(1)`, even for
asymmetric block degrees in `[0,p]`.  The replayed MT, AM, and NAT ledgers
have bottleneck margins `.002698120754...`, `.164603786261...`, and
`.0032192935...`; AM is normalized by the actual source-cell occupancy and
averaged unconditionally before intersecting `Good`, while NAT includes all
48 mixed-newborn planes and every row-active edge-incomplete graph map.
Choosing `s_L in (s_H,1/20)` and `tau<1/20-s_L` makes the high core overlap
the LCO layer.  The resulting Schur sandwich proves
`Gamma_all>=[1-o(1)]I` and
`Q_(full,all)=[1+o(1)]Q_(rad,all)` on the entire realized occupied
distinct-support quotient.  The eight-cell swap cube still shows that
automatic one-cell floors cannot be summed by themselves, but it is not an
actual-random obstruction because the global nonautomatic trace-four
certificate controls the repairing cross-cell remainder.  This theorem is
restricted to visibility one, the original deterministic cutoff and
retention rule, and fully `Y`-adaptive real linear weights on the occupied
quotient; empty-cell inverse/coefficient stability, changed or unbalanced
list cutoffs, visibility bounded away from one, changed retention, and
nonlinear statistics remain open.  The finite certificates are
machine-replayable rather than Lean-formalized.
Bucket-sum-only random rehash medians contain no information beyond the
original path sum;
a fixed positive pair-overlap law can still give either sign of prediction
correlation.  A second-moment theorem gives `N^(0.280916...-o(1))` distinct
span-clean local anti-majority marginals with high probability for every
`0<lambda<=1`.  Their entire certified Fourier spectrum contributes only
`N^(-0.108737...+o(1))` to any bounded predictor.  At visibility one, the
typical full path layer has Wick fourth moment and contributes at least
`(2/sqrt(3)-o(1))*2^(-t)*sqrt(M_path/2)=N^(-o(1))` before the outside
spectrum is added.
Nevertheless, the actual modular instance `N=16,Y=(1,2,3,5,6,7)` has Wagner
correlation `lambda^2*(7*lambda^2-8)/32<0`.  The actual residual has uniform
`L_1` norm `1+o(1)` at visibility one, while asymptotic nonnegative-coefficient
completions with the exact Rademacher-sum `Z` law and `o(M)` local reversals
realize either sign.  The exact remaining Wagner projection depends only on
`r(z)=E[R|Z=z]`.  Nonpositive signed-margin covariance would imply positive
correlation but remains unproved; the sixth-moment result refutes the small-
regression sufficient condition.
The certified clean-cluster residual sector is exponentially negligible at
that scale.  A separate automatic order-three family gives
`<R,(Z/sigma)^3> >= N^(0.021392...+o(1))` with high probability.  A new
sixth-Wick theorem, `E_U[Z^6]=(15+o(1))*sigma^6`, converts this into the same
exponential lower bound for `||E[R|Z]||_2` and for at least one available
degree-two-or-three orthogonal coefficient.  Small regression is therefore
false.  For the actual modular law at visibility one, the exact alternating
closure expansion makes the cubic formal-level contribution at most
`-N^(0.021392...+o(1))`; bounded total correlation forces the net formal
closure levels at least five to contribute at least
`N^(0.021392...+o(1))`.  With high probability, the actual automatic
contributions from quintic through level twenty-five have signed magnitudes
at least `N^(0.0679559...+o(1))`, `N^(0.1365318...+o(1))`,
`N^(0.2246470...+o(1))`, `N^(0.3303074...+o(1))`,
`N^(0.4518674...+o(1))`, `N^(0.5879439...+o(1))`,
`N^(0.7373572...+o(1))`, `N^(0.8990879...+o(1))`,
`N^(1.0722463...+o(1))`, `N^(1.2560485...+o(1))`, and
`N^(1.4497986...+o(1))`, with signs `+,-,+,-,+,-,+,-,+,-,+`.
Those terms already give absolute formal mass and triangle-inequality
condition number `N^(1.4497986...+o(1))`.  A directed finite-convolution
certificate further closes every displayed odd level through 51; the negative
level-51 term raises both lower bounds to `N^(4.6555...+o(1))`.  An effective
collision certificate then exhausts `53<=j<2401` and supplies an explicit
Fourier--Legendre tail, removing the former finite gap: every preselected fixed
odd formal level `j>=27` closes.  The signed exponent is greater than
`4.9431600...` on the new finite block and remains positive by an explicit
tail bound.  There is no claim for `j=j(n)`.  These are visibility-one
formal-level results, not an algorithm lower bound; they determine neither a
fixed-cutoff tail nor the final Wagner sign.
More
sharply, two valid
nonnegative-Walsh likelihood
completions have
the same exact symmetric base law, positive linear signal, and every residual
projection against polynomials of degree at most `M-1`.  Their conditional
laws also agree on every proper coordinate subset, but their full and residual
Wagner correlations have opposite signs.  These abstract completions are not
random modular laws; the all-degree signed projection remains open.
These are information-sufficiency obstructions and do not settle the random
modular sign.  A
new Parseval
argument makes one part rigorous: against the conventional adversarial
`STAT` oracle, the uniform-secret average parity advantage of any adaptive
algorithm using only polynomially many inverse-polynomial-tolerance queries
is at most `poly(n)/N`.  This does not cover algorithms that inspect individual
samples or collective quantum measurements.  The robust
parity-only observable can also be written explicitly without outputting the
complete secret/error label, but its known multiplexed-polar realization
still costs `Theta(sqrt(N))` at constant accuracy in the standard
projected-unitary/QSVT access model.  Within the clean orbit dictionary, the
raw signed-frame LCU coefficients are unique and constant-error parity
approximations retain `Omega(N)` normalization; directly taking
the sign of the purified density-matrix block encoding costs `Omega(N)`,
whereas frame polarization gives the sharper `Theta(sqrt(N))` route.  A
bounded-output fermionic-Gaussian circuit is also exactly parity-blind below
the signed-relation threshold.  This is qualitatively tight in output scaling:
a linear-output
disjoint-pair matchgate produces `6*n` passive visibility-one observations
with exponentially reliable maximum-likelihood parity, but efficient
postprocessing reduces to the same weighted `A_0/A_H` coefficient problem;
Pfaffian evaluation does not perform the cyclic coefficient extraction.
These are scoped access/circuit-class results.
Exact operator-Schmidt analysis further rules out polynomial-bond
MPO/Frobenius compression, not general circuits.  Pairwise
Kuperberg-style collimation remains subexponential and its
explicit terminal relations are further suppressed by allowed hidden-fault
models.  These are scoped route failures, not a general lower bound.
This verdict does not claim that either isolated sentence of Lemma 3 is false
in every interpretation, or that a polynomial DCP algorithm is impossible.

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

Even without correcting the extra `+n`, the printed exponent at `c = 12` is
`-n/2 + o(n)`.  If this were first established as a simultaneous absolute
error bound on normalized amplitudes, it would absorb every downstream
polynomial factor.  Thus the exponent typo is repairable and is not the
decisive obstruction to Lemma 4.

The repaired arithmetic does not establish the conditional balls-in-bins
premises or overcome signed-amplitude cancellation.  The final
multiplicative-amplitude conclusion of Lemma 4 therefore remains unproved, not
refuted.  The detailed audit is in [`AUDIT.md`](AUDIT.md).

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

The full project, including the Lemma 1 repair and current Lemma 3 repair
modules, was verified in Arch Linux under WSL on August 11, 2026.  The command
`lake build` completed all 8665 jobs successfully.

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

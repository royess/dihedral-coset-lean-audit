import SimonDCP.Probability.Lemma4Decoder
import SimonDCP.Probability.LemmaThreeCountEnergy

/-!
# An expectation-level decoder repair for Lemma 4

The algorithm only needs its final decoded bit to be correct with noticeable
overall probability.  It does not need every low-part bin, or even every
classical measurement record, to satisfy a simultaneous pointwise estimate.

This file therefore averages the gate-level `H ⊗ I` theorem from
`Lemma4Decoder` directly over a finite classical record space.  The resulting
bound consumes the expected product of

* the squared scale of a residual amplitude pair,
* the L2 distance between its two branch-count vectors, and
* the coefficient energy.

There is no multiplicative amplitude ratio, no anti-cancellation premise, and
no union bound over exponentially many residual pairs.  A second theorem
reduces the paired count distance to the two branches' count energies about a
common centre.  This makes an expected selected-pair collision identity, such
as `LemmaThreeCountEnergy.expected_selectedCountErrorEnergy_actualMean_eq`, a
natural remaining probabilistic premise.
-/

namespace SimonDCP.Probability.Lemma4AverageDecoder

open scoped BigOperators
open QuantumAlg
open SimonDCP.Probability.LemmaThreeCountEnergy
open SimonDCP.Probability.LemmaThreeToFourL2
open SimonDCP.Probability.Lemma4Decoder
open SimonDCP.Quantum.ApproximateReadout

noncomputable section

/-- Overall correct-bit probability after averaging over a finite classical
record space. -/
def averageCorrectProbability
    {Ω : Type*} [Fintype Ω] {n : ℕ}
    (weight : Ω → ℝ) (state : Ω → PureState (Qubits (1 + n)))
    (dBit : Bool) : ℝ :=
  ∑ ω, weight ω *
    PureState.probQubit0
      ((Gate.tensor Gate.H (1 : Gate (Qubits n))).apply (state ω))
      (SimonDCP.Quantum.BitReadout.bitIndex dBit)

/-- The exact Cauchy--Schwarz budget attached to one classical record. -/
def recordMismatchBudget
    {n : ℕ} {Label : Type*} [Fintype Label]
    (scale : Fin (2 ^ n) → ℂ)
    (leftCount rightCount : Fin (2 ^ n) → Label → ℝ)
    (coefficient : Fin (2 ^ n) → Label → ℂ) : ℝ :=
  ∑ outer, Complex.normSq (scale outer) *
    pairCountErrorEnergy (leftCount outer) (rightCount outer) *
    coefficientEnergy (coefficient outer)

/-- Expected exact mismatch budget on a finite real-weighted record space. -/
def expectedMismatchBudget
    {Ω : Type*} [Fintype Ω] {n : ℕ}
    {Label : Type*} [Fintype Label]
    (weight : Ω → ℝ)
    (scale : Ω → Fin (2 ^ n) → ℂ)
    (leftCount rightCount : Ω → Fin (2 ^ n) → Label → ℝ)
    (coefficient : Ω → Fin (2 ^ n) → Label → ℂ) : ℝ :=
  ∑ ω, weight ω *
    recordMismatchBudget (scale ω) (leftCount ω) (rightCount ω)
      (coefficient ω)

/-- The two branches' count energies around a common centre, weighted by an
upper bound for their scale-times-coefficient energy. -/
def recordBranchCountBudget
    {n : ℕ} {Label : Type*} [Fintype Label]
    (multiplier : Fin (2 ^ n) → ℝ)
    (leftCount rightCount : Fin (2 ^ n) → Label → ℝ)
    (mean : Fin (2 ^ n) → ℝ) : ℝ :=
  ∑ outer, multiplier outer *
    (countErrorEnergy (leftCount outer) (mean outer) +
      countErrorEnergy (rightCount outer) (mean outer))

/-- Expected two-branch count-energy budget. -/
def expectedBranchCountBudget
    {Ω : Type*} [Fintype Ω] {n : ℕ}
    {Label : Type*} [Fintype Label]
    (weight : Ω → ℝ) (multiplier : Ω → Fin (2 ^ n) → ℝ)
    (leftCount rightCount : Ω → Fin (2 ^ n) → Label → ℝ)
    (mean : Ω → Fin (2 ^ n) → ℝ) : ℝ :=
  ∑ ω, weight ω *
    recordBranchCountBudget (multiplier ω) (leftCount ω) (rightCount ω)
      (mean ω)

/-- The explicit count-energy budget delivered by selected-pair collision
uniformity for two branches. -/
def selectedPairCollisionBranchBudget
    {Ω Ball : Type*} [Fintype Ω] [Fintype Ball]
    {n : ℕ} (Label : Type*) [Fintype Label]
    (weight : Ω → ℝ) (multiplier : Fin (2 ^ n) → ℝ)
    (leftSelected rightSelected :
      Fin (2 ^ n) → Ω → Ball → Bool) : ℝ :=
  ∑ outer, multiplier outer *
    (1 - (Fintype.card Label : ℝ)⁻¹) *
      (weightedMeanReal weight (selectedTotal (leftSelected outer)) +
        weightedMeanReal weight (selectedTotal (rightSelected outer)))

/-- Re-index the expected branch-count budget as a sum of per-residual-pair
weighted means. -/
theorem expectedBranchCountBudget_eq_sum_weightedMean
    {Ω : Type*} [Fintype Ω] {n : ℕ}
    {Label : Type*} [Fintype Label]
    (weight : Ω → ℝ) (multiplier : Fin (2 ^ n) → ℝ)
    (leftCount rightCount : Ω → Fin (2 ^ n) → Label → ℝ)
    (mean : Ω → Fin (2 ^ n) → ℝ) :
    expectedBranchCountBudget weight (fun _ => multiplier)
        leftCount rightCount mean =
      ∑ outer, multiplier outer *
        (weightedMeanReal weight (fun ω =>
            countErrorEnergy (leftCount ω outer) (mean ω outer)) +
          weightedMeanReal weight (fun ω =>
            countErrorEnergy (rightCount ω outer) (mean ω outer))) := by
  classical
  unfold expectedBranchCountBudget recordBranchCountBudget weightedMeanReal
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro outer _
  rw [mul_add, Finset.mul_sum, Finset.mul_sum,
    ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro ω _
  ring

/--
The exact adaptive balls-in-bins second moment, simultaneously for both
distinguished-bit branches and every residual amplitude pair.  Selection is
inside `WeightedPairCollisionUniform`; bare pairwise independence before
conditioning is not enough to satisfy these hypotheses.
-/
theorem expectedBranchCountBudget_selected_eq
    {Ω Ball : Type*} [Fintype Ω] [Fintype Ball]
    {n : ℕ} {Label : Type*} [Fintype Label]
    [DecidableEq Label] [Nonempty Label]
    (weight : Ω → ℝ) (multiplier : Fin (2 ^ n) → ℝ)
    (leftSelected rightSelected :
      Fin (2 ^ n) → Ω → Ball → Bool)
    (leftBucket rightBucket :
      Fin (2 ^ n) → Ω → Ball → Label)
    (hSameTotal : ∀ ω outer,
      selectedTotal (leftSelected outer) ω =
        selectedTotal (rightSelected outer) ω)
    (hLeftPair : ∀ outer,
      WeightedPairCollisionUniform weight
        (leftSelected outer) (leftBucket outer))
    (hRightPair : ∀ outer,
      WeightedPairCollisionUniform weight
        (rightSelected outer) (rightBucket outer)) :
    expectedBranchCountBudget weight (fun _ => multiplier)
        (fun ω outer =>
          selectedBucketCount (leftSelected outer) (leftBucket outer) ω)
        (fun ω outer =>
          selectedBucketCount (rightSelected outer) (rightBucket outer) ω)
        (fun ω outer =>
          selectedTotal (leftSelected outer) ω /
            (Fintype.card Label : ℝ)) =
      selectedPairCollisionBranchBudget Label weight multiplier
        leftSelected rightSelected := by
  classical
  rw [expectedBranchCountBudget_eq_sum_weightedMean]
  unfold selectedPairCollisionBranchBudget
  apply Finset.sum_congr rfl
  intro outer _
  have hRightCentre :
      (fun ω =>
        countErrorEnergy
          (selectedBucketCount (rightSelected outer) (rightBucket outer) ω)
          (selectedTotal (leftSelected outer) ω /
            (Fintype.card Label : ℝ))) =
      (fun ω =>
        countErrorEnergy
          (selectedBucketCount (rightSelected outer) (rightBucket outer) ω)
          (selectedTotal (rightSelected outer) ω /
            (Fintype.card Label : ℝ))) := by
    funext ω
    rw [hSameTotal ω outer]
  rw [hRightCentre]
  rw [expected_selectedCountErrorEnergy_actualMean_eq
    weight (leftSelected outer) (leftBucket outer) (hLeftPair outer)]
  rw [expected_selectedCountErrorEnergy_actualMean_eq
    weight (rightSelected outer) (rightBucket outer) (hRightPair outer)]
  ring

/-- The exact paired count distance is nonnegative. -/
theorem pairCountErrorEnergy_nonneg
    {Label : Type*} [Fintype Label]
    (leftCount rightCount : Label → ℝ) :
    0 ≤ pairCountErrorEnergy leftCount rightCount := by
  exact Finset.sum_nonneg fun label _ => sq_nonneg _

/--
The L2 distance between two count vectors is bounded by twice the sum of their
two squared deviations from any common centre.  Unlike a pointwise
balls-in-bins estimate, this loses no factor equal to the number of bins.
-/
theorem pairCountErrorEnergy_le_two_countErrorEnergy
    {Label : Type*} [Fintype Label]
    (leftCount rightCount : Label → ℝ) (mean : ℝ) :
    pairCountErrorEnergy leftCount rightCount ≤
      2 * (countErrorEnergy leftCount mean +
        countErrorEnergy rightCount mean) := by
  classical
  unfold pairCountErrorEnergy countErrorEnergy
  rw [mul_add, Finset.mul_sum, Finset.mul_sum,
    ← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro label _
  nlinarith [sq_nonneg
    ((leftCount label - mean) + (rightCount label - mean))]

/-- The exact mismatch budget is controlled by the two branches' centred count
energies whenever `multiplier` bounds scale-times-coefficient energy. -/
theorem recordMismatchBudget_le_two_recordBranchCountBudget
    {n : ℕ} {Label : Type*} [Fintype Label]
    (scale : Fin (2 ^ n) → ℂ)
    (leftCount rightCount : Fin (2 ^ n) → Label → ℝ)
    (coefficient : Fin (2 ^ n) → Label → ℂ)
    (mean multiplier : Fin (2 ^ n) → ℝ)
    (hMultiplier : ∀ outer, 0 ≤ multiplier outer)
    (hScaleCoefficient : ∀ outer,
      Complex.normSq (scale outer) *
          coefficientEnergy (coefficient outer) ≤ multiplier outer) :
    recordMismatchBudget scale leftCount rightCount coefficient ≤
      2 * recordBranchCountBudget multiplier leftCount rightCount mean := by
  classical
  unfold recordMismatchBudget recordBranchCountBudget
  rw [Finset.mul_sum]
  apply Finset.sum_le_sum
  intro outer _
  have hPairNonneg := pairCountErrorEnergy_nonneg
    (leftCount outer) (rightCount outer)
  have hPair := pairCountErrorEnergy_le_two_countErrorEnergy
    (leftCount outer) (rightCount outer) (mean outer)
  calc
    Complex.normSq (scale outer) *
          pairCountErrorEnergy (leftCount outer) (rightCount outer) *
          coefficientEnergy (coefficient outer) =
        (Complex.normSq (scale outer) *
          coefficientEnergy (coefficient outer)) *
            pairCountErrorEnergy (leftCount outer) (rightCount outer) := by
      ring
    _ ≤ multiplier outer *
          pairCountErrorEnergy (leftCount outer) (rightCount outer) :=
      mul_le_mul_of_nonneg_right (hScaleCoefficient outer) hPairNonneg
    _ ≤ multiplier outer *
          (2 * (countErrorEnergy (leftCount outer) (mean outer) +
            countErrorEnergy (rightCount outer) (mean outer))) :=
      mul_le_mul_of_nonneg_left hPair (hMultiplier outer)
    _ = 2 * (multiplier outer *
          (countErrorEnergy (leftCount outer) (mean outer) +
            countErrorEnergy (rightCount outer) (mean outer))) := by
      ring

/--
Expectation-level gate theorem.  If the exact Cauchy--Schwarz mismatch budget
has expectation at most `budget`, then the overall probability of decoding the
distinguished bit after the actual QuantumAlg gate `H ⊗ I` is at least
`1 - budget / 2`.

This is the quantity needed by repetition of the algorithm.  No event-level
concentration or independence assumption occurs in this averaging step.
-/
theorem average_state_labelled_decoder_success_ge
    {Ω : Type*} [Fintype Ω] {n : ℕ}
    {Label : Type*} [Fintype Label]
    (weight : Ω → ℝ) (state : Ω → PureState (Qubits (1 + n)))
    (dBit : Bool) (scale : Ω → Fin (2 ^ n) → ℂ)
    (leftCount rightCount : Ω → Fin (2 ^ n) → Label → ℝ)
    (coefficient : Ω → Fin (2 ^ n) → Label → ℂ)
    (budget : ℝ)
    (hWeight : ∀ ω, 0 ≤ weight ω)
    (hNormalized : (∑ ω, weight ω) = 1)
    (hZero : ∀ ω outer,
      state ω (prodEquiv ((0 : Fin (2 ^ 1)), outer)) =
        scale ω outer *
          weightedAmplitude (leftCount ω outer) (coefficient ω outer))
    (hOne : ∀ ω outer,
      state ω (prodEquiv ((1 : Fin (2 ^ 1)), outer)) =
        targetSign dBit * scale ω outer *
          weightedAmplitude (rightCount ω outer) (coefficient ω outer))
    (hExpected :
      expectedMismatchBudget weight scale leftCount rightCount coefficient ≤
        budget) :
    1 - budget / 2 ≤
      averageCorrectProbability weight state dBit := by
  have hPointwise : ∀ ω,
      1 - recordMismatchBudget (scale ω) (leftCount ω) (rightCount ω)
            (coefficient ω) / 2 ≤
        PureState.probQubit0
          ((Gate.tensor Gate.H (1 : Gate (Qubits n))).apply (state ω))
          (SimonDCP.Quantum.BitReadout.bitIndex dBit) := by
    intro ω
    exact lemmaFour_state_labelled_additive_readout
      (state ω) dBit (scale ω) (leftCount ω) (rightCount ω)
      (coefficient ω)
      (fun outer =>
        pairCountErrorEnergy (leftCount ω outer) (rightCount ω outer))
      (fun outer => coefficientEnergy (coefficient ω outer))
      (hZero ω) (hOne ω) (fun _ => le_rfl) (fun _ => le_rfl)
      (fun outer => pairCountErrorEnergy_nonneg
        (leftCount ω outer) (rightCount ω outer))
  have hAverageExpand :
      (∑ ω, weight ω *
        (1 - recordMismatchBudget (scale ω) (leftCount ω) (rightCount ω)
          (coefficient ω) / 2)) =
        1 - expectedMismatchBudget weight scale leftCount rightCount
          coefficient / 2 := by
    unfold expectedMismatchBudget
    calc
      (∑ ω, weight ω *
          (1 - recordMismatchBudget (scale ω) (leftCount ω) (rightCount ω)
            (coefficient ω) / 2)) =
          (∑ ω, weight ω) -
            ∑ ω, weight ω *
              (recordMismatchBudget (scale ω) (leftCount ω) (rightCount ω)
                (coefficient ω) / 2) := by
        simp_rw [mul_sub, mul_one]
        rw [Finset.sum_sub_distrib]
      _ = 1 - (∑ ω, weight ω *
            recordMismatchBudget (scale ω) (leftCount ω) (rightCount ω)
              (coefficient ω)) / 2 := by
        rw [hNormalized, Finset.sum_div]
        congr 1
        apply Finset.sum_congr rfl
        intro ω _
        ring
  unfold averageCorrectProbability
  calc
    1 - budget / 2 ≤
        1 - expectedMismatchBudget weight scale leftCount rightCount
          coefficient / 2 := by linarith
    _ = ∑ ω, weight ω *
          (1 - recordMismatchBudget (scale ω) (leftCount ω) (rightCount ω)
            (coefficient ω) / 2) := by
      exact hAverageExpand.symm
    _ ≤ ∑ ω, weight ω *
        PureState.probQubit0
          ((Gate.tensor Gate.H (1 : Gate (Qubits n))).apply (state ω))
          (SimonDCP.Quantum.BitReadout.bitIndex dBit) := by
      exact Finset.sum_le_sum fun ω _ =>
        mul_le_mul_of_nonneg_left (hPointwise ω) (hWeight ω)

/--
Paper-facing expectation-level repair.  A bound on the expected L2 count
energy of the two branches gives the overall decoder-success bound directly.
Compared with the simultaneous per-bin theorem, this route needs neither a
maximum count deviation nor a union bound over residual pairs and bins.
-/
theorem average_state_labelled_decoder_success_ge_of_branch_count_energy
    {Ω : Type*} [Fintype Ω] {n : ℕ}
    {Label : Type*} [Fintype Label]
    (weight : Ω → ℝ) (state : Ω → PureState (Qubits (1 + n)))
    (dBit : Bool) (scale : Ω → Fin (2 ^ n) → ℂ)
    (leftCount rightCount : Ω → Fin (2 ^ n) → Label → ℝ)
    (coefficient : Ω → Fin (2 ^ n) → Label → ℂ)
    (mean multiplier : Ω → Fin (2 ^ n) → ℝ)
    (budget : ℝ)
    (hWeight : ∀ ω, 0 ≤ weight ω)
    (hNormalized : (∑ ω, weight ω) = 1)
    (hZero : ∀ ω outer,
      state ω (prodEquiv ((0 : Fin (2 ^ 1)), outer)) =
        scale ω outer *
          weightedAmplitude (leftCount ω outer) (coefficient ω outer))
    (hOne : ∀ ω outer,
      state ω (prodEquiv ((1 : Fin (2 ^ 1)), outer)) =
        targetSign dBit * scale ω outer *
          weightedAmplitude (rightCount ω outer) (coefficient ω outer))
    (hMultiplier : ∀ ω outer, 0 ≤ multiplier ω outer)
    (hScaleCoefficient : ∀ ω outer,
      Complex.normSq (scale ω outer) *
          coefficientEnergy (coefficient ω outer) ≤ multiplier ω outer)
    (hExpected :
      expectedBranchCountBudget weight multiplier leftCount rightCount mean ≤
        budget) :
    1 - budget ≤ averageCorrectProbability weight state dBit := by
  have hMismatch :
      expectedMismatchBudget weight scale leftCount rightCount coefficient ≤
        2 * budget := by
    calc
      expectedMismatchBudget weight scale leftCount rightCount coefficient ≤
          ∑ ω, weight ω *
            (2 * recordBranchCountBudget (multiplier ω)
              (leftCount ω) (rightCount ω) (mean ω)) := by
        unfold expectedMismatchBudget
        exact Finset.sum_le_sum fun ω _ =>
          mul_le_mul_of_nonneg_left
            (recordMismatchBudget_le_two_recordBranchCountBudget
              (scale ω) (leftCount ω) (rightCount ω) (coefficient ω)
              (mean ω) (multiplier ω) (hMultiplier ω)
              (hScaleCoefficient ω))
            (hWeight ω)
      _ = 2 * expectedBranchCountBudget weight multiplier leftCount
          rightCount mean := by
        unfold expectedBranchCountBudget
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro ω _
        ring
      _ ≤ 2 * budget := mul_le_mul_of_nonneg_left hExpected (by norm_num)
  have hAverage := average_state_labelled_decoder_success_ge
    weight state dBit scale leftCount rightCount coefficient (2 * budget)
    hWeight hNormalized hZero hOne hMismatch
  nlinarith [hAverage]

/--
End-to-end finite expectation repair under the exact adaptive collision
premise.  Each branch may select its balls as a function of the classical
record.  What is required is that, after this selection has been included in
the moment, every distinct selected pair collides with the uniform bucket
factor.  This is precisely the premise that the paper's pre-conditioning
pairwise-independence assertion does not establish.

Under that premise, equal branch populations, the Step-7 coordinate
identities, and the scale/coefficient-energy bound, the concrete averaged
`H ⊗ I` decoder succeeds with the displayed explicit probability.
-/
theorem
    average_state_labelled_decoder_success_ge_of_selected_pair_collision
    {Ω Ball : Type*} [Fintype Ω] [Fintype Ball]
    {n : ℕ} {Label : Type*} [Fintype Label]
    [DecidableEq Label] [Nonempty Label]
    (weight : Ω → ℝ) (state : Ω → PureState (Qubits (1 + n)))
    (dBit : Bool) (scale : Ω → Fin (2 ^ n) → ℂ)
    (coefficient : Ω → Fin (2 ^ n) → Label → ℂ)
    (multiplier : Fin (2 ^ n) → ℝ)
    (leftSelected rightSelected :
      Fin (2 ^ n) → Ω → Ball → Bool)
    (leftBucket rightBucket :
      Fin (2 ^ n) → Ω → Ball → Label)
    (hWeight : ∀ ω, 0 ≤ weight ω)
    (hNormalized : (∑ ω, weight ω) = 1)
    (hZero : ∀ ω outer,
      state ω (prodEquiv ((0 : Fin (2 ^ 1)), outer)) =
        scale ω outer * weightedAmplitude
          (selectedBucketCount (leftSelected outer) (leftBucket outer) ω)
          (coefficient ω outer))
    (hOne : ∀ ω outer,
      state ω (prodEquiv ((1 : Fin (2 ^ 1)), outer)) =
        targetSign dBit * scale ω outer * weightedAmplitude
          (selectedBucketCount (rightSelected outer) (rightBucket outer) ω)
          (coefficient ω outer))
    (hMultiplier : ∀ outer, 0 ≤ multiplier outer)
    (hScaleCoefficient : ∀ ω outer,
      Complex.normSq (scale ω outer) *
          coefficientEnergy (coefficient ω outer) ≤ multiplier outer)
    (hSameTotal : ∀ ω outer,
      selectedTotal (leftSelected outer) ω =
        selectedTotal (rightSelected outer) ω)
    (hLeftPair : ∀ outer,
      WeightedPairCollisionUniform weight
        (leftSelected outer) (leftBucket outer))
    (hRightPair : ∀ outer,
      WeightedPairCollisionUniform weight
        (rightSelected outer) (rightBucket outer)) :
    1 - selectedPairCollisionBranchBudget Label weight multiplier
          leftSelected rightSelected ≤
      averageCorrectProbability weight state dBit := by
  apply average_state_labelled_decoder_success_ge_of_branch_count_energy
    weight state dBit scale
    (fun ω outer =>
      selectedBucketCount (leftSelected outer) (leftBucket outer) ω)
    (fun ω outer =>
      selectedBucketCount (rightSelected outer) (rightBucket outer) ω)
    coefficient
    (fun ω outer => selectedTotal (leftSelected outer) ω /
      (Fintype.card Label : ℝ))
    (fun _ => multiplier)
    (selectedPairCollisionBranchBudget Label weight multiplier
      leftSelected rightSelected)
    hWeight hNormalized hZero hOne
  · exact fun _ => hMultiplier
  · exact hScaleCoefficient
  · rw [expectedBranchCountBudget_selected_eq weight multiplier
      leftSelected rightSelected leftBucket rightBucket hSameTotal
      hLeftPair hRightPair]

/-! ## The selected collision premise is not inherited through conditioning -/

/-- Select both candidate balls on every postselected equal-bit record. -/
def equalBitSelectAll (_seed : EqualBitSeed) (_ball : Bool) : Bool := true

/-- The two-bit hash restricted to the postselected equal-bit seed space. -/
def equalBitConditionBucket (seed : EqualBitSeed) (ball : Bool) : Bool :=
  twoBitHash seed.1 ball

theorem equalBitConditionBucket_false_eq_true (seed : EqualBitSeed) :
    equalBitConditionBucket seed false =
      equalBitConditionBucket seed true := by
  rcases seed with ⟨⟨left, right⟩, hEqual⟩
  change left = right at hEqual
  subst right
  cases left <;> rfl

/--
The exact selected-pair collision premise used by the expectation-level repair
fails after conditioning the two formerly independent Boolean labels to be
equal.  This turns the paper's qualitative warning into the same formal
predicate required by the repaired theorem.
-/
theorem equalBitCondition_not_weightedPairCollisionUniform
    (weight : EqualBitSeed → ℝ)
    (hNormalized : (∑ seed, weight seed) = 1) :
    ¬ WeightedPairCollisionUniform weight equalBitSelectAll
      equalBitConditionBucket := by
  intro hUniform
  have hPair := hUniform false true (by decide)
  unfold weightedMeanReal selectedPairCollisionIndicator
    selectedPairIndicator equalBitSelectAll at hPair
  simp only [and_self, if_true] at hPair
  simp_rw [equalBitConditionBucket_false_eq_true] at hPair
  simp only [and_self, if_true, mul_one] at hPair
  rw [hNormalized] at hPair
  norm_num at hPair

end

end SimonDCP.Probability.Lemma4AverageDecoder

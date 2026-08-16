import SimonDCP.Probability.Lemma4Repair
import SimonDCP.Probability.LemmaThreeToFourL2
import SimonDCP.Quantum.ApproximateReadout

/-!
# A decoder-facing additive repair of Lemma 4

The paper states Lemma 4 as a multiplicative comparison of two amplitudes.
That formulation is unnecessarily fragile: signed coefficients may cancel,
so division by a reference amplitude requires an anti-cancellation lower
bound.  The final Hadamard decoder does not need such a ratio.

This file proves the stronger useful replacement.  The difference between the
two weighted branch amplitudes is controlled by Cauchy--Schwarz using

* the squared L2 distance between the two count functions; and
* the squared energy of the complex coefficient family.

The first form treats two coordinates of a surviving qubit.  The stronger
labelled form keeps every residual amplitude pair, sums their mismatch
energies, and connects the result to the actual QuantumAlg operation `H ⊗ I`
and first-qubit marginal.  Pointwise balls-in-bins specializations are supplied
for both forms.

An application to the paper must still identify its concrete Step-7 amplitude
pairs with the families below and prove the conditioned count and coefficient
energy bounds.  The theorem removes anti-cancellation and pure-qubit
factorization from the final readout step; it does not manufacture those
probabilistic or semantic premises.  A two-layer finite union bound propagates
explicit per-pair/per-bin tails to the labelled gate-level decoder event.
-/

namespace SimonDCP.Probability.Lemma4Decoder

open scoped BigOperators
open QuantumAlg
open SimonDCP.Probability.LemmaThreeToFourL2
open SimonDCP.Quantum.ApproximateReadout

noncomputable section

variable {Label : Type*}

/-- Squared L2 distance between the two branch-count functions. -/
def pairCountErrorEnergy [Fintype Label]
    (leftCount rightCount : Label → ℝ) : ℝ :=
  ∑ label, (rightCount label - leftCount label) ^ 2

/-- The difference of two weighted amplitudes is the count-difference inner product. -/
theorem weightedAmplitude_sub_weightedAmplitude
    [Fintype Label]
    (leftCount rightCount : Label → ℝ)
    (coefficient : Label → ℂ) :
    weightedAmplitude rightCount coefficient -
        weightedAmplitude leftCount coefficient =
      ∑ label, ((rightCount label - leftCount label : ℝ) : ℂ) *
        coefficient label := by
  classical
  simp only [weightedAmplitude, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro label _
  push_cast
  ring

/-- Cauchy--Schwarz controls the squared branch mismatch without a pointwise coefficient bound. -/
theorem weightedAmplitude_pair_error_normSq_le
    [Fintype Label]
    (leftCount rightCount : Label → ℝ)
    (coefficient : Label → ℂ) :
    Complex.normSq
        (weightedAmplitude rightCount coefficient -
          weightedAmplitude leftCount coefficient) ≤
      pairCountErrorEnergy leftCount rightCount *
        coefficientEnergy coefficient := by
  classical
  rw [weightedAmplitude_sub_weightedAmplitude]
  simpa [pairCountErrorEnergy, coefficientEnergy] using
    normSq_sum_real_mul_le (Finset.univ : Finset Label)
      (fun label => rightCount label - leftCount label) coefficient

/-- Budgeted form of the two-branch Cauchy--Schwarz estimate. -/
theorem weightedAmplitude_pair_error_normSq_le_budget
    [Fintype Label]
    (leftCount rightCount : Label → ℝ)
    (coefficient : Label → ℂ)
    (countBudget coefficientBudget : ℝ)
    (hCountBudget :
      pairCountErrorEnergy leftCount rightCount ≤ countBudget)
    (hCoefficientBudget :
      coefficientEnergy coefficient ≤ coefficientBudget)
    (hCountBudgetNonneg : 0 ≤ countBudget) :
    Complex.normSq
        (weightedAmplitude rightCount coefficient -
          weightedAmplitude leftCount coefficient) ≤
      countBudget * coefficientBudget := by
  calc
    Complex.normSq
        (weightedAmplitude rightCount coefficient -
          weightedAmplitude leftCount coefficient) ≤
        pairCountErrorEnergy leftCount rightCount *
          coefficientEnergy coefficient :=
      weightedAmplitude_pair_error_normSq_le leftCount rightCount coefficient
    _ ≤ countBudget * coefficientBudget := by
      exact mul_le_mul hCountBudget hCoefficientBudget
        (by exact Finset.sum_nonneg fun label _ =>
          Complex.normSq_nonneg (coefficient label))
        hCountBudgetNonneg

/-- Uniform closeness to one mean gives an explicit L2 distance budget. -/
theorem pairCountErrorEnergy_le_of_uniform
    [Fintype Label]
    (leftCount rightCount : Label → ℝ) (mean error : ℝ)
    (hError : 0 ≤ error)
    (hLeft : ∀ label, |leftCount label - mean| ≤ error)
    (hRight : ∀ label, |rightCount label - mean| ≤ error) :
    pairCountErrorEnergy leftCount rightCount ≤
      4 * (Fintype.card Label : ℝ) * error ^ 2 := by
  classical
  unfold pairCountErrorEnergy
  calc
    (∑ label, (rightCount label - leftCount label) ^ 2) ≤
        ∑ _label : Label, (2 * error) ^ 2 := by
      apply Finset.sum_le_sum
      intro label _
      apply (sq_le_sq).2
      have hAbs :
          |rightCount label - leftCount label| ≤ 2 * error := by
        calc
          |rightCount label - leftCount label| ≤
              |rightCount label - mean| + |mean - leftCount label| :=
            abs_sub_le _ _ _
          _ = |rightCount label - mean| + |leftCount label - mean| := by
            rw [abs_sub_comm mean]
          _ ≤ error + error := add_le_add (hRight label) (hLeft label)
          _ = 2 * error := by ring
      simpa [abs_of_nonneg hError] using hAbs
    _ = 4 * (Fintype.card Label : ℝ) * error ^ 2 := by
      simp
      ring

/-- The Boolean target sign has unit squared norm. -/
theorem targetSign_normSq (dBit : Bool) :
    Complex.normSq (targetSign dBit) = 1 := by
  cases dBit <;> norm_num [targetSign]

/-- Identify the final-qubit mismatch with the scaled weighted-amplitude difference. -/
theorem branchMismatch_eq_scaled_pair_error
    [Fintype Label]
    (state : PureState (Qubits 1)) (dBit : Bool) (scale : ℂ)
    (leftCount rightCount : Label → ℝ)
    (coefficient : Label → ℂ)
    (hZero : state 0 = scale * weightedAmplitude leftCount coefficient)
    (hOne : state 1 = targetSign dBit * scale *
      weightedAmplitude rightCount coefficient) :
    branchMismatch state dBit =
      targetSign dBit * scale *
        (weightedAmplitude rightCount coefficient -
          weightedAmplitude leftCount coefficient) := by
  rw [branchMismatch, hZero, hOne]
  cases dBit <;> norm_num [targetSign] <;> ring

/--
The same coordinate identity without collapsing the residual label register to
one pure qubit.  This is the pointwise form needed for the pairs of high-part
amplitudes in the paper's final paragraph.
-/
theorem amplitudeMismatch_eq_scaled_pair_error
    [Fintype Label]
    (zeroAmplitude oneAmplitude : ℂ) (dBit : Bool) (scale : ℂ)
    (leftCount rightCount : Label → ℝ)
    (coefficient : Label → ℂ)
    (hZero : zeroAmplitude =
      scale * weightedAmplitude leftCount coefficient)
    (hOne : oneAmplitude = targetSign dBit * scale *
      weightedAmplitude rightCount coefficient) :
    oneAmplitude - targetSign dBit * zeroAmplitude =
      targetSign dBit * scale *
        (weightedAmplitude rightCount coefficient -
          weightedAmplitude leftCount coefficient) := by
  rw [hZero, hOne]
  cases dBit <;> norm_num [targetSign] <;> ring

/--
Sum the two-branch Cauchy--Schwarz estimate over every unmeasured residual
label.  This avoids the unjustified assumption that the state has already
factorized as one pure qubit.
-/
theorem pairedWeightedAmplitudeMismatchEnergy_le_budget
    {Outer : Type*} [Fintype Outer] [Fintype Label]
    (zeroBranch oneBranch : Outer → ℂ) (dBit : Bool)
    (scale : Outer → ℂ)
    (leftCount rightCount : Outer → Label → ℝ)
    (coefficient : Outer → Label → ℂ)
    (countBudget coefficientBudget : Outer → ℝ)
    (hZero : ∀ outer, zeroBranch outer =
      scale outer * weightedAmplitude (leftCount outer) (coefficient outer))
    (hOne : ∀ outer, oneBranch outer = targetSign dBit * scale outer *
      weightedAmplitude (rightCount outer) (coefficient outer))
    (hCountBudget : ∀ outer,
      pairCountErrorEnergy (leftCount outer) (rightCount outer) ≤
        countBudget outer)
    (hCoefficientBudget : ∀ outer,
      coefficientEnergy (coefficient outer) ≤ coefficientBudget outer)
    (hCountBudgetNonneg : ∀ outer, 0 ≤ countBudget outer) :
    pairedMismatchEnergy zeroBranch oneBranch dBit ≤
      ∑ outer, Complex.normSq (scale outer) * countBudget outer *
        coefficientBudget outer := by
  classical
  unfold pairedMismatchEnergy
  apply Finset.sum_le_sum
  intro outer _
  rw [amplitudeMismatch_eq_scaled_pair_error
    (zeroBranch outer) (oneBranch outer) dBit (scale outer)
    (leftCount outer) (rightCount outer) (coefficient outer)
    (hZero outer) (hOne outer)]
  rw [Complex.normSq_mul, Complex.normSq_mul, targetSign_normSq, one_mul]
  simpa only [mul_assoc] using
    mul_le_mul_of_nonneg_left
      (weightedAmplitude_pair_error_normSq_le_budget
        (leftCount outer) (rightCount outer) (coefficient outer)
        (countBudget outer) (coefficientBudget outer)
        (hCountBudget outer) (hCoefficientBudget outer)
        (hCountBudgetNonneg outer))
      (Complex.normSq_nonneg (scale outer))

/--
Labelled decoder-facing Lemma 4.  The distinguished bit may remain entangled
with an arbitrary finite residual register: only the summed mismatch energy
matters for the Hadamard readout.
-/
theorem lemmaFour_labelled_additive_readout
    {Outer : Type*} [Fintype Outer] [Fintype Label]
    (zeroBranch oneBranch : Outer → ℂ) (dBit : Bool)
    (scale : Outer → ℂ)
    (leftCount rightCount : Outer → Label → ℝ)
    (coefficient : Outer → Label → ℂ)
    (countBudget coefficientBudget : Outer → ℝ)
    (hNormalized : pairedBranchMass zeroBranch oneBranch = 1)
    (hZero : ∀ outer, zeroBranch outer =
      scale outer * weightedAmplitude (leftCount outer) (coefficient outer))
    (hOne : ∀ outer, oneBranch outer = targetSign dBit * scale outer *
      weightedAmplitude (rightCount outer) (coefficient outer))
    (hCountBudget : ∀ outer,
      pairCountErrorEnergy (leftCount outer) (rightCount outer) ≤
        countBudget outer)
    (hCoefficientBudget : ∀ outer,
      coefficientEnergy (coefficient outer) ≤ coefficientBudget outer)
    (hCountBudgetNonneg : ∀ outer, 0 ≤ countBudget outer) :
    1 - (∑ outer, Complex.normSq (scale outer) * countBudget outer *
          coefficientBudget outer) / 2 ≤
      pairedCorrectMass zeroBranch oneBranch dBit := by
  apply pairedCorrectMass_ge_of_mismatchEnergy_le
    zeroBranch oneBranch dBit _ hNormalized
  exact pairedWeightedAmplitudeMismatchEnergy_le_budget
    zeroBranch oneBranch dBit scale leftCount rightCount coefficient
    countBudget coefficientBudget hZero hOne hCountBudget
    hCoefficientBudget hCountBudgetNonneg

/--
Pointwise balls-in-bins specialization of the labelled decoder theorem.  It
matches the paper's collection of high-part amplitude pairs while keeping all
unmeasured labels explicit.
-/
theorem lemmaFour_labelled_uniform_counts_readout
    {Outer : Type*} [Fintype Outer] [Fintype Label]
    (zeroBranch oneBranch : Outer → ℂ) (dBit : Bool)
    (scale : Outer → ℂ)
    (leftCount rightCount : Outer → Label → ℝ)
    (coefficient : Outer → Label → ℂ)
    (mean error coefficientBudget : Outer → ℝ)
    (hNormalized : pairedBranchMass zeroBranch oneBranch = 1)
    (hZero : ∀ outer, zeroBranch outer =
      scale outer * weightedAmplitude (leftCount outer) (coefficient outer))
    (hOne : ∀ outer, oneBranch outer = targetSign dBit * scale outer *
      weightedAmplitude (rightCount outer) (coefficient outer))
    (hError : ∀ outer, 0 ≤ error outer)
    (hLeft : ∀ outer label,
      |leftCount outer label - mean outer| ≤ error outer)
    (hRight : ∀ outer label,
      |rightCount outer label - mean outer| ≤ error outer)
    (hCoefficientBudget : ∀ outer,
      coefficientEnergy (coefficient outer) ≤ coefficientBudget outer) :
    1 - (∑ outer, Complex.normSq (scale outer) *
          (4 * (Fintype.card Label : ℝ) * error outer ^ 2) *
          coefficientBudget outer) / 2 ≤
      pairedCorrectMass zeroBranch oneBranch dBit := by
  apply lemmaFour_labelled_additive_readout zeroBranch oneBranch dBit scale
    leftCount rightCount coefficient
    (fun outer => 4 * (Fintype.card Label : ℝ) * error outer ^ 2)
    coefficientBudget hNormalized hZero hOne
  · intro outer
    exact pairCountErrorEnergy_le_of_uniform
      (leftCount outer) (rightCount outer) (mean outer) (error outer)
      (hError outer) (hLeft outer) (hRight outer)
  · exact hCoefficientBudget
  · intro outer
    positivity

/--
Gate-level labelled decoder repair for an actual normalized `1+n` qubit
state.  This composes the count/coefficient estimate with the concrete
QuantumAlg operation `H ⊗ I` and its first-qubit marginal Born probability.
-/
theorem lemmaFour_state_labelled_additive_readout
    {n : ℕ} [Fintype Label]
    (state : PureState (Qubits (1 + n))) (dBit : Bool)
    (scale : Fin (2 ^ n) → ℂ)
    (leftCount rightCount : Fin (2 ^ n) → Label → ℝ)
    (coefficient : Fin (2 ^ n) → Label → ℂ)
    (countBudget coefficientBudget : Fin (2 ^ n) → ℝ)
    (hZero : ∀ outer,
      state (prodEquiv ((0 : Fin (2 ^ 1)), outer)) =
        scale outer * weightedAmplitude (leftCount outer) (coefficient outer))
    (hOne : ∀ outer,
      state (prodEquiv ((1 : Fin (2 ^ 1)), outer)) =
        targetSign dBit * scale outer *
          weightedAmplitude (rightCount outer) (coefficient outer))
    (hCountBudget : ∀ outer,
      pairCountErrorEnergy (leftCount outer) (rightCount outer) ≤
        countBudget outer)
    (hCoefficientBudget : ∀ outer,
      coefficientEnergy (coefficient outer) ≤ coefficientBudget outer)
    (hCountBudgetNonneg : ∀ outer, 0 ≤ countBudget outer) :
    1 - (∑ outer, Complex.normSq (scale outer) * countBudget outer *
          coefficientBudget outer) / 2 ≤
      PureState.probQubit0
        ((Gate.tensor Gate.H (1 : Gate (Qubits n))).apply state)
        (SimonDCP.Quantum.BitReadout.bitIndex dBit) := by
  rw [probQubit0_hadamardFirst_correct_eq]
  exact lemmaFour_labelled_additive_readout
    (fun outer : Fin (2 ^ n) =>
      state (prodEquiv ((0 : Fin (2 ^ 1)), outer)))
    (fun outer : Fin (2 ^ n) =>
      state (prodEquiv ((1 : Fin (2 ^ 1)), outer)))
    dBit scale leftCount rightCount coefficient countBudget coefficientBudget
    (pairedBranchMass_state_eq_one state) hZero hOne hCountBudget
    hCoefficientBudget hCountBudgetNonneg

/-- Pointwise balls-in-bins specialization of the gate-level labelled repair. -/
theorem lemmaFour_state_labelled_uniform_counts_readout
    {n : ℕ} [Fintype Label]
    (state : PureState (Qubits (1 + n))) (dBit : Bool)
    (scale : Fin (2 ^ n) → ℂ)
    (leftCount rightCount : Fin (2 ^ n) → Label → ℝ)
    (coefficient : Fin (2 ^ n) → Label → ℂ)
    (mean error coefficientBudget : Fin (2 ^ n) → ℝ)
    (hZero : ∀ outer,
      state (prodEquiv ((0 : Fin (2 ^ 1)), outer)) =
        scale outer * weightedAmplitude (leftCount outer) (coefficient outer))
    (hOne : ∀ outer,
      state (prodEquiv ((1 : Fin (2 ^ 1)), outer)) =
        targetSign dBit * scale outer *
          weightedAmplitude (rightCount outer) (coefficient outer))
    (hError : ∀ outer, 0 ≤ error outer)
    (hLeft : ∀ outer label,
      |leftCount outer label - mean outer| ≤ error outer)
    (hRight : ∀ outer label,
      |rightCount outer label - mean outer| ≤ error outer)
    (hCoefficientBudget : ∀ outer,
      coefficientEnergy (coefficient outer) ≤ coefficientBudget outer) :
    1 - (∑ outer, Complex.normSq (scale outer) *
          (4 * (Fintype.card Label : ℝ) * error outer ^ 2) *
          coefficientBudget outer) / 2 ≤
      PureState.probQubit0
        ((Gate.tensor Gate.H (1 : Gate (Qubits n))).apply state)
        (SimonDCP.Quantum.BitReadout.bitIndex dBit) := by
  rw [probQubit0_hadamardFirst_correct_eq]
  exact lemmaFour_labelled_uniform_counts_readout
    (fun outer : Fin (2 ^ n) =>
      state (prodEquiv ((0 : Fin (2 ^ 1)), outer)))
    (fun outer : Fin (2 ^ n) =>
      state (prodEquiv ((1 : Fin (2 ^ 1)), outer)))
    dBit scale leftCount rightCount coefficient mean error coefficientBudget
    (pairedBranchMass_state_eq_one state) hZero hOne hError hLeft hRight
    hCoefficientBudget

/--
Decoder-facing repaired Lemma 4.  Count-error and coefficient-energy budgets
give a direct lower bound on the probability of reading the encoded bit.
There is no reference-amplitude denominator.
-/
theorem lemmaFour_additive_readout
    [Fintype Label]
    (state : PureState (Qubits 1)) (dBit : Bool) (scale : ℂ)
    (leftCount rightCount : Label → ℝ)
    (coefficient : Label → ℂ)
    (countBudget coefficientBudget : ℝ)
    (hZero : state 0 = scale * weightedAmplitude leftCount coefficient)
    (hOne : state 1 = targetSign dBit * scale *
      weightedAmplitude rightCount coefficient)
    (hCountBudget :
      pairCountErrorEnergy leftCount rightCount ≤ countBudget)
    (hCoefficientBudget :
      coefficientEnergy coefficient ≤ coefficientBudget)
    (hCountBudgetNonneg : 0 ≤ countBudget) :
    1 - Complex.normSq scale * countBudget * coefficientBudget / 2 ≤
      PureState.probOutcome (Gate.H.apply state)
        (SimonDCP.Quantum.BitReadout.bitIndex dBit) := by
  apply correct_probability_ge_of_mismatch_normSq_le
  rw [branchMismatch_eq_scaled_pair_error state dBit scale leftCount
    rightCount coefficient hZero hOne]
  rw [Complex.normSq_mul, Complex.normSq_mul, targetSign_normSq, one_mul]
  simpa only [mul_assoc] using
    mul_le_mul_of_nonneg_left
      (weightedAmplitude_pair_error_normSq_le_budget leftCount rightCount
        coefficient countBudget coefficientBudget hCountBudget
        hCoefficientBudget hCountBudgetNonneg)
      (Complex.normSq_nonneg scale)

/--
Balls-in-bins specialization: if both count functions are uniformly within
`error` of a common mean, the final readout error is bounded using the
coefficient L2 energy alone.
-/
theorem lemmaFour_uniform_counts_readout
    [Fintype Label]
    (state : PureState (Qubits 1)) (dBit : Bool) (scale : ℂ)
    (leftCount rightCount : Label → ℝ)
    (coefficient : Label → ℂ)
    (mean error coefficientBudget : ℝ)
    (hZero : state 0 = scale * weightedAmplitude leftCount coefficient)
    (hOne : state 1 = targetSign dBit * scale *
      weightedAmplitude rightCount coefficient)
    (hError : 0 ≤ error)
    (hLeft : ∀ label, |leftCount label - mean| ≤ error)
    (hRight : ∀ label, |rightCount label - mean| ≤ error)
    (hCoefficientBudget :
      coefficientEnergy coefficient ≤ coefficientBudget) :
    1 - Complex.normSq scale *
          (4 * (Fintype.card Label : ℝ) * error ^ 2) *
          coefficientBudget / 2 ≤
      PureState.probOutcome (Gate.H.apply state)
        (SimonDCP.Quantum.BitReadout.bitIndex dBit) := by
  apply lemmaFour_additive_readout state dBit scale leftCount rightCount
    coefficient (4 * (Fintype.card Label : ℝ) * error ^ 2)
      coefficientBudget hZero hOne
  · exact pairCountErrorEnergy_le_of_uniform leftCount rightCount mean error
      hError hLeft hRight
  · exact hCoefficientBudget
  · positivity

/-! ## Finite probabilistic decoder repair -/

/--
The quantitative readout guarantee attached to one classical measurement
record.  It is kept as a named event so that the per-bin concentration bounds
can be lifted through the same finite union bound as `Lemma4Repair`.
-/
def decoderReadoutGood
    (numberOfLabels : ℕ) (state : PureState (Qubits 1))
    (dBit : Bool) (scale : ℂ) (error coefficientBudget : ℝ) : Prop :=
  1 - Complex.normSq scale *
        (4 * (numberOfLabels : ℝ) * error ^ 2) *
        coefficientBudget / 2 ≤
    PureState.probOutcome (Gate.H.apply state)
      (SimonDCP.Quantum.BitReadout.bitIndex dBit)

/--
Conditional finite repaired Lemma 4, in decoder form.  If every count bin has
tail mass at most `tail`, then the measurement records on which the explicit
Hadamard readout guarantee fails have mass at most
`2 * numberOfLabels * tail`.

The coordinate and coefficient-energy hypotheses remain pointwise premises;
this theorem does not infer them from the paper's adaptive experiment.
-/
theorem lemmaFour_decoder_failure_mass_le
    {Ω : Type*} [Fintype Ω] [Fintype Label]
    (weight : Ω → ℚ) (state : Ω → PureState (Qubits 1))
    (dBit : Bool) (scale : Ω → ℂ)
    (leftCount rightCount : Ω → Label → ℝ)
    (coefficient : Ω → Label → ℂ)
    (mean error coefficientBudget : ℝ) (tail : ℚ)
    (hWeight : ∀ ω, 0 ≤ weight ω)
    (hError : 0 ≤ error)
    (hZero : ∀ ω, state ω 0 =
      scale ω * weightedAmplitude (leftCount ω) (coefficient ω))
    (hOne : ∀ ω, state ω 1 = targetSign dBit * scale ω *
      weightedAmplitude (rightCount ω) (coefficient ω))
    (hCoefficientBudget : ∀ ω,
      coefficientEnergy (coefficient ω) ≤ coefficientBudget)
    (hLeftTail : ∀ label,
      Lemma4Repair.eventMass weight
        (fun ω => error < |leftCount ω label - mean|) ≤ tail)
    (hRightTail : ∀ label,
      Lemma4Repair.eventMass weight
        (fun ω => error < |rightCount ω label - mean|) ≤ tail) :
    Lemma4Repair.eventMass weight (fun ω => ¬ decoderReadoutGood
        (Fintype.card Label) (state ω) dBit (scale ω) error coefficientBudget) ≤
      2 * (Fintype.card Label : ℚ) * tail := by
  let bins : Finset Label := Finset.univ
  have hBadMass :
      Lemma4Repair.eventMass weight
          (Lemma4Repair.pairedCountDeviationBad bins leftCount rightCount mean error) ≤
        2 * (bins.card : ℚ) * tail := by
    apply Lemma4Repair.pairedCountDeviationBad_mass_le bins weight leftCount rightCount
      mean error tail hWeight
    · intro label _
      exact hLeftTail label
    · intro label _
      exact hRightTail label
  calc
    Lemma4Repair.eventMass weight (fun ω => ¬ decoderReadoutGood
        (Fintype.card Label) (state ω) dBit (scale ω) error coefficientBudget) ≤
        Lemma4Repair.eventMass weight
          (Lemma4Repair.pairedCountDeviationBad bins leftCount rightCount mean error) := by
      apply Lemma4Repair.eventMass_mono weight _ _ hWeight
      intro ω hFailure
      by_contra hGoodCounts
      apply hFailure
      unfold decoderReadoutGood
      apply lemmaFour_uniform_counts_readout
        (state ω) dBit (scale ω) (leftCount ω) (rightCount ω)
          (coefficient ω) mean error coefficientBudget
      · exact hZero ω
      · exact hOne ω
      · exact hError
      · intro label
        exact le_of_not_gt fun hDeviation =>
          hGoodCounts (Or.inl ⟨label, Finset.mem_univ label, hDeviation⟩)
      · intro label
        exact le_of_not_gt fun hDeviation =>
          hGoodCounts (Or.inr ⟨label, Finset.mem_univ label, hDeviation⟩)
      · exact hCoefficientBudget ω
    _ ≤ 2 * (bins.card : ℚ) * tail := hBadMass
    _ = 2 * (Fintype.card Label : ℚ) * tail := by simp [bins]

/--
Probability-at-least form of the decoder-facing repair on a normalized finite
space.  With mass at least `1 - 2 * numberOfLabels * tail`, the conditioned
record yields the explicit lower bound recorded by `decoderReadoutGood`.
-/
theorem lemmaFour_decoder_success_mass_ge
    {Ω : Type*} [Fintype Ω] [Fintype Label]
    (weight : Ω → ℚ) (state : Ω → PureState (Qubits 1))
    (dBit : Bool) (scale : Ω → ℂ)
    (leftCount rightCount : Ω → Label → ℝ)
    (coefficient : Ω → Label → ℂ)
    (mean error coefficientBudget : ℝ) (tail : ℚ)
    (hWeight : ∀ ω, 0 ≤ weight ω)
    (hNormalized : (∑ ω, weight ω) = 1)
    (hError : 0 ≤ error)
    (hZero : ∀ ω, state ω 0 =
      scale ω * weightedAmplitude (leftCount ω) (coefficient ω))
    (hOne : ∀ ω, state ω 1 = targetSign dBit * scale ω *
      weightedAmplitude (rightCount ω) (coefficient ω))
    (hCoefficientBudget : ∀ ω,
      coefficientEnergy (coefficient ω) ≤ coefficientBudget)
    (hLeftTail : ∀ label,
      Lemma4Repair.eventMass weight
        (fun ω => error < |leftCount ω label - mean|) ≤ tail)
    (hRightTail : ∀ label,
      Lemma4Repair.eventMass weight
        (fun ω => error < |rightCount ω label - mean|) ≤ tail) :
    1 - 2 * (Fintype.card Label : ℚ) * tail ≤
      Lemma4Repair.eventMass weight (fun ω => decoderReadoutGood
        (Fintype.card Label) (state ω) dBit (scale ω) error coefficientBudget) := by
  have hFailure := lemmaFour_decoder_failure_mass_le weight state dBit scale
    leftCount rightCount coefficient mean error coefficientBudget tail
      hWeight hError hZero hOne hCoefficientBudget hLeftTail hRightTail
  have hPartition := Lemma4Repair.eventMass_complement_add weight (fun ω =>
    decoderReadoutGood (Fintype.card Label) (state ω) dBit (scale ω)
      error coefficientBudget)
  rw [hNormalized] at hPartition
  linarith

/-! ## Labelled finite probabilistic decoder repair -/

/--
At least one residual amplitude pair has a low-part count outside its allowed
radius in either distinguished-bit branch.
-/
def labelledPairedCountDeviationBad
    {Ω Outer Bin : Type*} [Fintype Outer] [Fintype Bin]
    (leftCount rightCount : Ω → Outer → Bin → ℝ)
    (mean error : Outer → ℝ) (ω : Ω) : Prop :=
  ∃ outer ∈ (Finset.univ : Finset Outer),
    Lemma4Repair.pairedCountDeviationBad
      (Finset.univ : Finset Bin)
      (fun record label => leftCount record outer label)
      (fun record label => rightCount record outer label)
      (mean outer) (error outer) ω

/--
Union bound simultaneously over residual amplitude pairs, low-part bins, and
the two distinguished-bit branches.  No independence between these events is
assumed.
-/
theorem labelledPairedCountDeviationBad_mass_le
    {Ω Outer Bin : Type*} [Fintype Ω] [Fintype Outer] [Fintype Bin]
    (weight : Ω → ℚ)
    (leftCount rightCount : Ω → Outer → Bin → ℝ)
    (mean error : Outer → ℝ) (tail : ℚ)
    (hWeight : ∀ ω, 0 ≤ weight ω)
    (hLeftTail : ∀ outer label,
      Lemma4Repair.eventMass weight
        (fun ω => error outer <
          |leftCount ω outer label - mean outer|) ≤ tail)
    (hRightTail : ∀ outer label,
      Lemma4Repair.eventMass weight
        (fun ω => error outer <
          |rightCount ω outer label - mean outer|) ≤ tail) :
    Lemma4Repair.eventMass weight
        (labelledPairedCountDeviationBad leftCount rightCount mean error) ≤
      2 * (Fintype.card Outer : ℚ) * (Fintype.card Bin : ℚ) * tail := by
  classical
  let outers : Finset Outer := Finset.univ
  have hPerOuter : ∀ outer ∈ outers,
      Lemma4Repair.eventMass weight
          (Lemma4Repair.pairedCountDeviationBad
            (Finset.univ : Finset Bin)
            (fun record label => leftCount record outer label)
            (fun record label => rightCount record outer label)
            (mean outer) (error outer)) ≤
        2 * (Fintype.card Bin : ℚ) * tail := by
    intro outer _
    simpa using Lemma4Repair.pairedCountDeviationBad_mass_le
      (Finset.univ : Finset Bin) weight
      (fun record label => leftCount record outer label)
      (fun record label => rightCount record outer label)
      (mean outer) (error outer) tail hWeight
      (fun label _ => hLeftTail outer label)
      (fun label _ => hRightTail outer label)
  calc
    Lemma4Repair.eventMass weight
        (labelledPairedCountDeviationBad leftCount rightCount mean error) ≤
        ∑ outer ∈ outers,
          Lemma4Repair.eventMass weight
            (Lemma4Repair.pairedCountDeviationBad
              (Finset.univ : Finset Bin)
              (fun record label => leftCount record outer label)
              (fun record label => rightCount record outer label)
              (mean outer) (error outer)) := by
      change Lemma4Repair.eventMass weight (fun ω =>
        ∃ outer ∈ (Finset.univ : Finset Outer),
          Lemma4Repair.pairedCountDeviationBad
            (Finset.univ : Finset Bin)
            (fun record label => leftCount record outer label)
            (fun record label => rightCount record outer label)
            (mean outer) (error outer) ω) ≤ _
      simpa only [outers] using
        Lemma4Repair.eventMass_finset_exists_le weight
          (Finset.univ : Finset Outer)
          (fun outer => Lemma4Repair.pairedCountDeviationBad
            (Finset.univ : Finset Bin)
            (fun record label => leftCount record outer label)
            (fun record label => rightCount record outer label)
            (mean outer) (error outer)) hWeight
    _ ≤ ∑ _outer ∈ outers,
          (2 * (Fintype.card Bin : ℚ) * tail) :=
      Finset.sum_le_sum fun outer hOuter => hPerOuter outer hOuter
    _ = 2 * (Fintype.card Outer : ℚ) *
          (Fintype.card Bin : ℚ) * tail := by
      simp [outers]
      ring

/--
The gate-level labelled readout guarantee attached to one classical
measurement record.
-/
def stateLabelledDecoderReadoutGood {n : ℕ}
    (numberOfBins : ℕ) (state : PureState (Qubits (1 + n)))
    (dBit : Bool) (scale : Fin (2 ^ n) → ℂ)
    (error coefficientBudget : Fin (2 ^ n) → ℝ) : Prop :=
  1 - (∑ outer, Complex.normSq (scale outer) *
        (4 * (numberOfBins : ℝ) * error outer ^ 2) *
        coefficientBudget outer) / 2 ≤
    PureState.probQubit0
      ((Gate.tensor Gate.H (1 : Gate (Qubits n))).apply state)
      (SimonDCP.Quantum.BitReadout.bitIndex dBit)

/--
Finite probabilistic labelled Lemma 4 in actual-gate form.  Per-pair, per-bin
tail bounds imply that records violating the concrete `H ⊗ I` readout
guarantee have mass at most
`2 * numberOfPairs * numberOfBins * tail`.
-/
theorem lemmaFour_state_labelled_decoder_failure_mass_le
    {Ω : Type*} [Fintype Ω] {n : ℕ} [Fintype Label]
    (weight : Ω → ℚ) (state : Ω → PureState (Qubits (1 + n)))
    (dBit : Bool) (scale : Ω → Fin (2 ^ n) → ℂ)
    (leftCount rightCount : Ω → Fin (2 ^ n) → Label → ℝ)
    (coefficient : Ω → Fin (2 ^ n) → Label → ℂ)
    (mean error coefficientBudget : Fin (2 ^ n) → ℝ) (tail : ℚ)
    (hWeight : ∀ ω, 0 ≤ weight ω)
    (hError : ∀ outer, 0 ≤ error outer)
    (hZero : ∀ ω outer,
      state ω (prodEquiv ((0 : Fin (2 ^ 1)), outer)) =
        scale ω outer *
          weightedAmplitude (leftCount ω outer) (coefficient ω outer))
    (hOne : ∀ ω outer,
      state ω (prodEquiv ((1 : Fin (2 ^ 1)), outer)) =
        targetSign dBit * scale ω outer *
          weightedAmplitude (rightCount ω outer) (coefficient ω outer))
    (hCoefficientBudget : ∀ ω outer,
      coefficientEnergy (coefficient ω outer) ≤ coefficientBudget outer)
    (hLeftTail : ∀ outer label,
      Lemma4Repair.eventMass weight
        (fun ω => error outer <
          |leftCount ω outer label - mean outer|) ≤ tail)
    (hRightTail : ∀ outer label,
      Lemma4Repair.eventMass weight
        (fun ω => error outer <
          |rightCount ω outer label - mean outer|) ≤ tail) :
    Lemma4Repair.eventMass weight (fun ω =>
        ¬ stateLabelledDecoderReadoutGood (Fintype.card Label)
          (state ω) dBit (scale ω) error coefficientBudget) ≤
      2 * (Fintype.card (Fin (2 ^ n)) : ℚ) *
        (Fintype.card Label : ℚ) * tail := by
  have hBadMass := labelledPairedCountDeviationBad_mass_le weight
    leftCount rightCount mean error tail hWeight hLeftTail hRightTail
  calc
    Lemma4Repair.eventMass weight (fun ω =>
        ¬ stateLabelledDecoderReadoutGood (Fintype.card Label)
          (state ω) dBit (scale ω) error coefficientBudget) ≤
        Lemma4Repair.eventMass weight
          (labelledPairedCountDeviationBad
            leftCount rightCount mean error) := by
      apply Lemma4Repair.eventMass_mono weight _ _ hWeight
      intro ω hFailure
      by_contra hGoodCounts
      apply hFailure
      unfold stateLabelledDecoderReadoutGood
      apply lemmaFour_state_labelled_uniform_counts_readout
        (state ω) dBit (scale ω) (leftCount ω) (rightCount ω)
        (coefficient ω) mean error coefficientBudget
      · exact hZero ω
      · exact hOne ω
      · exact hError
      · intro outer label
        exact le_of_not_gt fun hDeviation =>
          hGoodCounts ⟨outer, Finset.mem_univ outer,
            Or.inl ⟨label, Finset.mem_univ label, hDeviation⟩⟩
      · intro outer label
        exact le_of_not_gt fun hDeviation =>
          hGoodCounts ⟨outer, Finset.mem_univ outer,
            Or.inr ⟨label, Finset.mem_univ label, hDeviation⟩⟩
      · exact hCoefficientBudget ω
    _ ≤ 2 * (Fintype.card (Fin (2 ^ n)) : ℚ) *
        (Fintype.card Label : ℚ) * tail := hBadMass

/--
Probability-at-least form of the gate-level labelled repair on a normalized
finite classical record space.
-/
theorem lemmaFour_state_labelled_decoder_success_mass_ge
    {Ω : Type*} [Fintype Ω] {n : ℕ} [Fintype Label]
    (weight : Ω → ℚ) (state : Ω → PureState (Qubits (1 + n)))
    (dBit : Bool) (scale : Ω → Fin (2 ^ n) → ℂ)
    (leftCount rightCount : Ω → Fin (2 ^ n) → Label → ℝ)
    (coefficient : Ω → Fin (2 ^ n) → Label → ℂ)
    (mean error coefficientBudget : Fin (2 ^ n) → ℝ) (tail : ℚ)
    (hWeight : ∀ ω, 0 ≤ weight ω)
    (hNormalized : (∑ ω, weight ω) = 1)
    (hError : ∀ outer, 0 ≤ error outer)
    (hZero : ∀ ω outer,
      state ω (prodEquiv ((0 : Fin (2 ^ 1)), outer)) =
        scale ω outer *
          weightedAmplitude (leftCount ω outer) (coefficient ω outer))
    (hOne : ∀ ω outer,
      state ω (prodEquiv ((1 : Fin (2 ^ 1)), outer)) =
        targetSign dBit * scale ω outer *
          weightedAmplitude (rightCount ω outer) (coefficient ω outer))
    (hCoefficientBudget : ∀ ω outer,
      coefficientEnergy (coefficient ω outer) ≤ coefficientBudget outer)
    (hLeftTail : ∀ outer label,
      Lemma4Repair.eventMass weight
        (fun ω => error outer <
          |leftCount ω outer label - mean outer|) ≤ tail)
    (hRightTail : ∀ outer label,
      Lemma4Repair.eventMass weight
        (fun ω => error outer <
          |rightCount ω outer label - mean outer|) ≤ tail) :
    1 - 2 * (Fintype.card (Fin (2 ^ n)) : ℚ) *
          (Fintype.card Label : ℚ) * tail ≤
      Lemma4Repair.eventMass weight (fun ω =>
        stateLabelledDecoderReadoutGood (Fintype.card Label)
          (state ω) dBit (scale ω) error coefficientBudget) := by
  have hFailure := lemmaFour_state_labelled_decoder_failure_mass_le
    weight state dBit scale leftCount rightCount coefficient
    mean error coefficientBudget tail hWeight hError hZero hOne
    hCoefficientBudget hLeftTail hRightTail
  have hPartition := Lemma4Repair.eventMass_complement_add weight (fun ω =>
    stateLabelledDecoderReadoutGood (Fintype.card Label)
      (state ω) dBit (scale ω) error coefficientBudget)
  rw [hNormalized] at hPartition
  linarith

end


end SimonDCP.Probability.Lemma4Decoder

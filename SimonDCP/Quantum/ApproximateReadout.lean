import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import SimonDCP.Quantum.BitReadout
import SimonDCP.Quantum.PhaseTransfer

/-!
# Approximate phase readout

The exact readout theorem in `BitReadout` starts from perfectly balanced
amplitudes.  Lemma 4 only needs a robust version: after the target phase has
been transferred to the surviving bit, an additive mismatch between its two
branch amplitudes should give a quantitative bound on the wrong Hadamard
outcome.

For a normalized state with amplitudes `a` and `b`, let

```text
mismatch = b - (-1)^d * a.
```

The wrong-bit Born probability after a Hadamard gate is exactly
`normSq mismatch / 2`.  Consequently an additive amplitude error `epsilon`
gives success probability at least `1 - epsilon^2 / 2`.  No division by either
branch amplitude, and hence no anti-cancellation premise, is needed.

The second half treats the distinguished bit without discarding an unmeasured
label register.  For paired amplitude families `a_x, b_x`, the total wrong
Born mass is `sum_x normSq (b_x - (-1)^d a_x) / 2`.  In particular, the
paper's claimed L1 bound on the sum of pairwise amplitude differences would
imply the required readout bound without assuming that the residual state
factorizes as a pure one-qubit state.
-/

namespace SimonDCP.Quantum.ApproximateReadout

open scoped BigOperators
open QuantumAlg

noncomputable section

/-- The sign that should relate the two branches when they encode `dBit`. -/
def targetSign (dBit : Bool) : ℂ :=
  (-1 : ℂ) ^ dBit.toNat

/-- Additive deviation from the ideal relative-phase relation. -/
def branchMismatch (state : PureState (Qubits 1)) (dBit : Bool) : ℂ :=
  state 1 - targetSign dBit * state 0

/--
Exact robust Hadamard identity: wrong-outcome probability is one half of the
squared additive branch mismatch.
-/
theorem wrong_probability_eq_mismatch
    (state : PureState (Qubits 1)) (dBit : Bool) :
    PureState.probOutcome (Gate.H.apply state)
        (BitReadout.bitIndex (!dBit)) =
      Complex.normSq (branchMismatch state dBit) / 2 := by
  have hInvSqrt2 : Complex.normSq PureState.invSqrt2 = (1 : ℝ) / 2 := by
    rw [Complex.normSq_eq_norm_sq, PureState.norm_sq_invSqrt2]
    norm_num
  cases dBit
  · simp only [PureState.probOutcome, StateVector.probOutcome, branchMismatch,
      targetSign, BitReadout.bitIndex, Bool.not_false, Bool.toNat_false,
      pow_zero, one_mul]
    simp [Gate.H, Gate.HOp, Complex.sq_norm]
    rw [show PureState.invSqrt2 * state 0 +
          -(PureState.invSqrt2 * state 1) =
        PureState.invSqrt2 * (state 0 - state 1) by ring,
      Complex.normSq_mul, hInvSqrt2]
    rw [show state 1 - state 0 = -(state 0 - state 1) by ring,
      Complex.normSq_neg]
    ring
  · simp only [PureState.probOutcome, StateVector.probOutcome, branchMismatch,
      targetSign, BitReadout.bitIndex, Bool.not_true, Bool.toNat_true,
      pow_one, neg_one_mul, sub_neg_eq_add]
    simp [Gate.H, Gate.HOp, Complex.sq_norm]
    rw [← mul_add, Complex.normSq_mul, hInvSqrt2]
    rw [add_comm (state 1) (state 0)]
    ring

/-- The two one-qubit outcome probabilities are complementary. -/
theorem correct_probability_eq_one_sub_wrong
    (state : PureState (Qubits 1)) (dBit : Bool) :
    PureState.probOutcome (Gate.H.apply state)
        (BitReadout.bitIndex dBit) =
      1 - PureState.probOutcome (Gate.H.apply state)
        (BitReadout.bitIndex (!dBit)) := by
  have hTotal := PureState.sum_probOutcome (Gate.H.apply state)
  change (∑ x : Fin 2, PureState.probOutcome (Gate.H.apply state) x) = 1 at hTotal
  rw [Fin.sum_univ_two] at hTotal
  cases dBit <;> simp [BitReadout.bitIndex] <;> linarith

/-- Correct-outcome probability written directly in terms of branch mismatch. -/
theorem correct_probability_eq_one_sub_mismatch
    (state : PureState (Qubits 1)) (dBit : Bool) :
    PureState.probOutcome (Gate.H.apply state)
        (BitReadout.bitIndex dBit) =
      1 - Complex.normSq (branchMismatch state dBit) / 2 := by
  rw [correct_probability_eq_one_sub_wrong,
    wrong_probability_eq_mismatch]

/-- A squared mismatch-energy budget gives a direct readout guarantee. -/
theorem correct_probability_ge_of_mismatch_normSq_le
    (state : PureState (Qubits 1)) (dBit : Bool) (errorEnergy : ℝ)
    (hMismatch : Complex.normSq (branchMismatch state dBit) ≤ errorEnergy) :
    1 - errorEnergy / 2 ≤
      PureState.probOutcome (Gate.H.apply state)
        (BitReadout.bitIndex dBit) := by
  rw [correct_probability_eq_one_sub_mismatch]
  linarith

/-- An additive norm error `error` gives failure probability at most `error^2 / 2`. -/
theorem correct_probability_ge_of_mismatch_norm_le
    (state : PureState (Qubits 1)) (dBit : Bool) (error : ℝ)
    (hError : 0 ≤ error)
    (hMismatch : ‖branchMismatch state dBit‖ ≤ error) :
    1 - error ^ 2 / 2 ≤
      PureState.probOutcome (Gate.H.apply state)
        (BitReadout.bitIndex dBit) := by
  apply correct_probability_ge_of_mismatch_normSq_le
  rw [Complex.normSq_eq_norm_sq]
  nlinarith [norm_nonneg (branchMismatch state dBit)]

/-- Exact branch balance recovers the existing probability-one readout. -/
theorem correct_probability_eq_one_of_mismatch_eq_zero
    (state : PureState (Qubits 1)) (dBit : Bool)
    (hMismatch : branchMismatch state dBit = 0) :
    PureState.probOutcome (Gate.H.apply state)
        (BitReadout.bitIndex dBit) = 1 := by
  rw [correct_probability_eq_one_sub_mismatch, hMismatch,
    Complex.normSq_zero]
  norm_num

/-! ## Readout with an unmeasured label register -/

/--
Total pre-Hadamard Born mass of a state written as paired amplitudes indexed
by an arbitrary finite residual label.  For an actual normalized state this
quantity is one.
-/
def pairedBranchMass {Label : Type*} [Fintype Label]
    (zeroBranch oneBranch : Label → ℂ) : ℝ :=
  ∑ label, (Complex.normSq (zeroBranch label) +
    Complex.normSq (oneBranch label))

/-- Squared L2 mismatch from the target relative phase, summed over labels. -/
def pairedMismatchEnergy {Label : Type*} [Fintype Label]
    (zeroBranch oneBranch : Label → ℂ) (dBit : Bool) : ℝ :=
  ∑ label, Complex.normSq
    (oneBranch label - targetSign dBit * zeroBranch label)

/--
Born mass of the wrong result after applying a Hadamard to the distinguished
bit and leaving the residual label register untouched.
-/
def pairedWrongMass {Label : Type*} [Fintype Label]
    (zeroBranch oneBranch : Label → ℂ) (dBit : Bool) : ℝ :=
  pairedMismatchEnergy zeroBranch oneBranch dBit / 2

/--
Born mass of the correct result after applying a Hadamard to the distinguished
bit and leaving the residual label register untouched.
-/
def pairedCorrectMass {Label : Type*} [Fintype Label]
    (zeroBranch oneBranch : Label → ℂ) (dBit : Bool) : ℝ :=
  (∑ label, Complex.normSq
    (zeroBranch label + targetSign dBit * oneBranch label)) / 2

/-- Pointwise parallelogram identity underlying the labelled readout theorem. -/
theorem correct_add_wrong_normSq
    (zeroAmplitude oneAmplitude : ℂ) (dBit : Bool) :
    Complex.normSq
          (zeroAmplitude + targetSign dBit * oneAmplitude) +
        Complex.normSq
          (oneAmplitude - targetSign dBit * zeroAmplitude) =
      2 * (Complex.normSq zeroAmplitude +
        Complex.normSq oneAmplitude) := by
  cases dBit
  · simp only [targetSign, Bool.toNat_false, pow_zero, one_mul]
    rw [show oneAmplitude - zeroAmplitude =
      -(zeroAmplitude - oneAmplitude) by ring, Complex.normSq_neg,
      Complex.normSq_add, Complex.normSq_sub]
    ring
  · simp only [targetSign, Bool.toNat_true, pow_one, neg_one_mul,
      sub_neg_eq_add]
    rw [show zeroAmplitude + -oneAmplitude =
      zeroAmplitude - oneAmplitude by ring, Complex.normSq_sub,
      Complex.normSq_add]
    have hCross :
        (oneAmplitude * starRingEnd ℂ zeroAmplitude).re =
          (zeroAmplitude * starRingEnd ℂ oneAmplitude).re := by
      simp [Complex.mul_re]
      ring
    rw [hCross]
    ring

/-- Correct and wrong labelled masses add up to the original branch mass. -/
theorem pairedCorrectMass_add_pairedWrongMass
    {Label : Type*} [Fintype Label]
    (zeroBranch oneBranch : Label → ℂ) (dBit : Bool) :
    pairedCorrectMass zeroBranch oneBranch dBit +
        pairedWrongMass zeroBranch oneBranch dBit =
      pairedBranchMass zeroBranch oneBranch := by
  classical
  rw [pairedCorrectMass, pairedWrongMass, pairedMismatchEnergy,
    pairedBranchMass]
  calc
    (∑ label,
          Complex.normSq
              (zeroBranch label + targetSign dBit * oneBranch label)) / 2 +
        (∑ label,
          Complex.normSq
              (oneBranch label - targetSign dBit * zeroBranch label)) / 2 =
        (∑ label,
          (Complex.normSq
              (zeroBranch label + targetSign dBit * oneBranch label) +
            Complex.normSq
              (oneBranch label - targetSign dBit * zeroBranch label))) / 2 := by
      rw [Finset.sum_add_distrib]
      ring
    _ = (∑ label,
          2 * (Complex.normSq (zeroBranch label) +
            Complex.normSq (oneBranch label))) / 2 := by
      congr 1
      apply Finset.sum_congr rfl
      intro label _
      exact correct_add_wrong_normSq
        (zeroBranch label) (oneBranch label) dBit
    _ = ∑ label,
        (Complex.normSq (zeroBranch label) +
          Complex.normSq (oneBranch label)) := by
      rw [← Finset.mul_sum]
      ring

/-- On a normalized paired state, correct mass is one minus wrong mass. -/
theorem pairedCorrectMass_eq_one_sub_pairedWrongMass
    {Label : Type*} [Fintype Label]
    (zeroBranch oneBranch : Label → ℂ) (dBit : Bool)
    (hNormalized : pairedBranchMass zeroBranch oneBranch = 1) :
    pairedCorrectMass zeroBranch oneBranch dBit =
      1 - pairedWrongMass zeroBranch oneBranch dBit := by
  have hTotal := pairedCorrectMass_add_pairedWrongMass
    zeroBranch oneBranch dBit
  rw [hNormalized] at hTotal
  linarith

/-- An L2 mismatch budget gives the labelled Hadamard readout guarantee. -/
theorem pairedCorrectMass_ge_of_mismatchEnergy_le
    {Label : Type*} [Fintype Label]
    (zeroBranch oneBranch : Label → ℂ) (dBit : Bool)
    (errorEnergy : ℝ)
    (hNormalized : pairedBranchMass zeroBranch oneBranch = 1)
    (hMismatch :
      pairedMismatchEnergy zeroBranch oneBranch dBit ≤ errorEnergy) :
    1 - errorEnergy / 2 ≤
      pairedCorrectMass zeroBranch oneBranch dBit := by
  rw [pairedCorrectMass_eq_one_sub_pairedWrongMass
    zeroBranch oneBranch dBit hNormalized, pairedWrongMass]
  linarith

/--
The exact inference used in the paper's final paragraph: an L1 bound on the
sum of pairwise amplitude differences implies a squared failure bound.  This
remains valid with an arbitrary residual label register and needs no
factorization into a pure one-qubit state.
-/
theorem pairedCorrectMass_ge_of_sum_mismatch_norm_le
    {Label : Type*} [Fintype Label]
    (zeroBranch oneBranch : Label → ℂ) (dBit : Bool) (error : ℝ)
    (hNormalized : pairedBranchMass zeroBranch oneBranch = 1)
    (hError : 0 ≤ error)
    (hMismatch :
      (∑ label, ‖oneBranch label -
        targetSign dBit * zeroBranch label‖) ≤ error) :
    1 - error ^ 2 / 2 ≤
      pairedCorrectMass zeroBranch oneBranch dBit := by
  apply pairedCorrectMass_ge_of_mismatchEnergy_le
    zeroBranch oneBranch dBit (error ^ 2) hNormalized
  rw [pairedMismatchEnergy]
  simp_rw [Complex.normSq_eq_norm_sq]
  calc
    (∑ label, ‖oneBranch label -
        targetSign dBit * zeroBranch label‖ ^ 2) ≤
        (∑ label, ‖oneBranch label -
          targetSign dBit * zeroBranch label‖) ^ 2 :=
      Finset.sum_sq_le_sq_sum_of_nonneg
        (fun label _ ↦ norm_nonneg
          (oneBranch label - targetSign dBit * zeroBranch label))
    _ ≤ error ^ 2 := by
      have hSumNonneg : 0 ≤
          ∑ label, ‖oneBranch label -
            targetSign dBit * zeroBranch label‖ :=
        Finset.sum_nonneg fun label _ ↦ norm_nonneg
          (oneBranch label - targetSign dBit * zeroBranch label)
      nlinarith

/-! ## Gate-level labelled readout -/

/-- Applying `H ⊗ I` gives the expected sum of the two branch amplitudes. -/
theorem hadamardFirst_apply_zero {n : ℕ}
    (state : PureState (Qubits (1 + n))) (label : Fin (2 ^ n)) :
    (Gate.tensor Gate.H (1 : Gate (Qubits n))).apply state
        (prodEquiv ((0 : Fin (2 ^ 1)), label)) =
      PureState.invSqrt2 *
        (state (prodEquiv ((0 : Fin (2 ^ 1)), label)) +
          state (prodEquiv ((1 : Fin (2 ^ 1)), label))) := by
  rw [Gate.apply_apply]
  rw [← Equiv.sum_comp (prodEquiv (m := 1) (n := n))
    (fun j => (Gate.tensor Gate.H (1 : Gate (Qubits n)))
      (prodEquiv ((0 : Fin (2 ^ 1)), label)) j * state j)]
  rw [Fintype.sum_prod_type]
  simp_rw [Gate.tensor_apply, Equiv.symm_apply_apply]
  change (∑ x : Fin (2 ^ 1), ∑ y : Fin (2 ^ n),
      (Gate.H : HilbertOperator (Qubits 1)) 0 x *
      (1 : HilbertOperator (Qubits n)) label y *
        state (prodEquiv (x, y))) = _
  simp [Gate.H, Gate.HOp, Matrix.one_apply]
  ring

/-- Applying `H ⊗ I` gives the expected difference of the two branch amplitudes. -/
theorem hadamardFirst_apply_one {n : ℕ}
    (state : PureState (Qubits (1 + n))) (label : Fin (2 ^ n)) :
    (Gate.tensor Gate.H (1 : Gate (Qubits n))).apply state
        (prodEquiv ((1 : Fin (2 ^ 1)), label)) =
      PureState.invSqrt2 *
        (state (prodEquiv ((0 : Fin (2 ^ 1)), label)) -
          state (prodEquiv ((1 : Fin (2 ^ 1)), label))) := by
  rw [Gate.apply_apply]
  rw [← Equiv.sum_comp (prodEquiv (m := 1) (n := n))
    (fun j => (Gate.tensor Gate.H (1 : Gate (Qubits n)))
      (prodEquiv ((1 : Fin (2 ^ 1)), label)) j * state j)]
  rw [Fintype.sum_prod_type]
  simp_rw [Gate.tensor_apply, Equiv.symm_apply_apply]
  change (∑ x : Fin (2 ^ 1), ∑ y : Fin (2 ^ n),
      (Gate.H : HilbertOperator (Qubits 1)) 1 x *
      (1 : HilbertOperator (Qubits n)) label y *
        state (prodEquiv (x, y))) = _
  simp [Gate.H, Gate.HOp, Matrix.one_apply]
  ring

/-- The paired branch amplitudes extracted from a pure state have total mass one. -/
theorem pairedBranchMass_state_eq_one {n : ℕ}
    (state : PureState (Qubits (1 + n))) :
    pairedBranchMass
        (fun label : Fin (2 ^ n) =>
          state (prodEquiv ((0 : Fin (2 ^ 1)), label)))
        (fun label : Fin (2 ^ n) =>
          state (prodEquiv ((1 : Fin (2 ^ 1)), label))) = 1 := by
  have hTotal := PureState.sum_probOutcome state
  change (∑ i, ‖state i‖ ^ 2) = 1 at hTotal
  rw [← Equiv.sum_comp (prodEquiv (m := 1) (n := n))
    (fun i => ‖state i‖ ^ 2), Fintype.sum_prod_type] at hTotal
  change (∑ x : Fin 2, ∑ y : Fin (2 ^ n),
    ‖state (prodEquiv (x, y))‖ ^ 2) = 1 at hTotal
  rw [Fin.sum_univ_two] at hTotal
  rw [pairedBranchMass]
  simp_rw [Complex.normSq_eq_norm_sq]
  rw [Finset.sum_add_distrib]
  exact hTotal

/--
Gate-level labelled identity: the wrong marginal probability after `H ⊗ I`
is exactly one half of the summed branch-mismatch energy.
-/
theorem probQubit0_hadamardFirst_wrong_eq {n : ℕ}
    (state : PureState (Qubits (1 + n))) (dBit : Bool) :
    PureState.probQubit0
        ((Gate.tensor Gate.H (1 : Gate (Qubits n))).apply state)
        (BitReadout.bitIndex (!dBit)) =
      pairedMismatchEnergy
        (fun label : Fin (2 ^ n) =>
          state (prodEquiv ((0 : Fin (2 ^ 1)), label)))
        (fun label : Fin (2 ^ n) =>
          state (prodEquiv ((1 : Fin (2 ^ 1)), label))) dBit / 2 := by
  have hInvSqrt2 : Complex.normSq PureState.invSqrt2 = (1 : ℝ) / 2 := by
    rw [Complex.normSq_eq_norm_sq, PureState.norm_sq_invSqrt2]
    norm_num
  cases dBit
  · rw [PureState.probQubit0]
    simp only [BitReadout.bitIndex, Bool.not_false, pairedMismatchEnergy,
      targetSign, Bool.toNat_false, pow_zero, one_mul]
    change (∑ label : Fin (2 ^ n),
      ‖(Gate.tensor Gate.H (1 : Gate (Qubits n))).apply state
        (prodEquiv ((1 : Fin (2 ^ 1)), label))‖ ^ 2) = _
    simp_rw [hadamardFirst_apply_one, Complex.sq_norm, Complex.normSq_mul,
      hInvSqrt2]
    calc
      (∑ label, (1 : ℝ) / 2 * Complex.normSq
          (state (prodEquiv ((0 : Fin (2 ^ 1)), label)) -
            state (prodEquiv ((1 : Fin (2 ^ 1)), label)))) =
          (1 : ℝ) / 2 * ∑ label, Complex.normSq
            (state (prodEquiv ((0 : Fin (2 ^ 1)), label)) -
              state (prodEquiv ((1 : Fin (2 ^ 1)), label))) := by
        rw [Finset.mul_sum]
      _ = (1 : ℝ) / 2 * ∑ label, Complex.normSq
          (state (prodEquiv ((1 : Fin (2 ^ 1)), label)) -
            state (prodEquiv ((0 : Fin (2 ^ 1)), label))) := by
        congr 1
        apply Finset.sum_congr rfl
        intro label _
        rw [show state (prodEquiv ((1 : Fin (2 ^ 1)), label)) -
            state (prodEquiv ((0 : Fin (2 ^ 1)), label)) =
          -(state (prodEquiv ((0 : Fin (2 ^ 1)), label)) -
            state (prodEquiv ((1 : Fin (2 ^ 1)), label))) by ring,
          Complex.normSq_neg]
      _ = (∑ label, Complex.normSq
          (state (prodEquiv ((1 : Fin (2 ^ 1)), label)) -
            state (prodEquiv ((0 : Fin (2 ^ 1)), label)))) / 2 := by
        ring
  · rw [PureState.probQubit0]
    simp only [BitReadout.bitIndex, Bool.not_true, pairedMismatchEnergy,
      targetSign, Bool.toNat_true, pow_one, neg_one_mul, sub_neg_eq_add]
    change (∑ label : Fin (2 ^ n),
      ‖(Gate.tensor Gate.H (1 : Gate (Qubits n))).apply state
        (prodEquiv ((0 : Fin (2 ^ 1)), label))‖ ^ 2) = _
    simp_rw [hadamardFirst_apply_zero, Complex.sq_norm, Complex.normSq_mul,
      hInvSqrt2]
    calc
      (∑ label, (1 : ℝ) / 2 * Complex.normSq
          (state (prodEquiv ((0 : Fin (2 ^ 1)), label)) +
            state (prodEquiv ((1 : Fin (2 ^ 1)), label)))) =
          (1 : ℝ) / 2 * ∑ label, Complex.normSq
            (state (prodEquiv ((0 : Fin (2 ^ 1)), label)) +
              state (prodEquiv ((1 : Fin (2 ^ 1)), label))) := by
        rw [Finset.mul_sum]
      _ = (1 : ℝ) / 2 * ∑ label, Complex.normSq
          (state (prodEquiv ((1 : Fin (2 ^ 1)), label)) +
            state (prodEquiv ((0 : Fin (2 ^ 1)), label))) := by
        congr 1
        apply Finset.sum_congr rfl
        intro label _
        rw [add_comm]
      _ = (∑ label, Complex.normSq
          (state (prodEquiv ((1 : Fin (2 ^ 1)), label)) +
            state (prodEquiv ((0 : Fin (2 ^ 1)), label)))) / 2 := by
        ring

/-- The two marginal outcomes of the first qubit have total mass one. -/
theorem probQubit0_zero_add_one_eq_one {n : ℕ}
    (state : PureState (Qubits (1 + n))) :
    PureState.probQubit0 state 0 + PureState.probQubit0 state 1 = 1 := by
  have hTotal := PureState.sum_probOutcome state
  change (∑ i, ‖state i‖ ^ 2) = 1 at hTotal
  rw [← Equiv.sum_comp (prodEquiv (m := 1) (n := n))
    (fun i => ‖state i‖ ^ 2), Fintype.sum_prod_type] at hTotal
  change (∑ x : Fin 2, ∑ y : Fin (2 ^ n),
    ‖state (prodEquiv (x, y))‖ ^ 2) = 1 at hTotal
  rw [Fin.sum_univ_two] at hTotal
  exact hTotal

/-- The abstract labelled correct mass is the actual `H ⊗ I` marginal. -/
theorem probQubit0_hadamardFirst_correct_eq {n : ℕ}
    (state : PureState (Qubits (1 + n))) (dBit : Bool) :
    PureState.probQubit0
        ((Gate.tensor Gate.H (1 : Gate (Qubits n))).apply state)
        (BitReadout.bitIndex dBit) =
      pairedCorrectMass
        (fun label : Fin (2 ^ n) =>
          state (prodEquiv ((0 : Fin (2 ^ 1)), label)))
        (fun label : Fin (2 ^ n) =>
          state (prodEquiv ((1 : Fin (2 ^ 1)), label))) dBit := by
  let evolved := (Gate.tensor Gate.H (1 : Gate (Qubits n))).apply state
  have hMarginal := probQubit0_zero_add_one_eq_one evolved
  have hWrong := probQubit0_hadamardFirst_wrong_eq state dBit
  have hPaired := pairedCorrectMass_add_pairedWrongMass
    (fun label : Fin (2 ^ n) =>
      state (prodEquiv ((0 : Fin (2 ^ 1)), label)))
    (fun label : Fin (2 ^ n) =>
      state (prodEquiv ((1 : Fin (2 ^ 1)), label))) dBit
  rw [pairedBranchMass_state_eq_one state] at hPaired
  change PureState.probQubit0 evolved (BitReadout.bitIndex (!dBit)) =
    pairedWrongMass
      (fun label : Fin (2 ^ n) =>
        state (prodEquiv ((0 : Fin (2 ^ 1)), label)))
      (fun label : Fin (2 ^ n) =>
        state (prodEquiv ((1 : Fin (2 ^ 1)), label))) dBit at hWrong
  change PureState.probQubit0 evolved (BitReadout.bitIndex dBit) = _
  cases dBit <;> simp [BitReadout.bitIndex] at hWrong ⊢ <;> linarith

/--
Paper-facing gate theorem: an L1 bound on all signed amplitude-pair
differences gives a direct lower bound on the actual first-qubit readout after
`H ⊗ I`.
-/
theorem probQubit0_hadamardFirst_correct_ge_of_sum_mismatch_norm_le {n : ℕ}
    (state : PureState (Qubits (1 + n))) (dBit : Bool) (error : ℝ)
    (hError : 0 ≤ error)
    (hMismatch :
      (∑ label : Fin (2 ^ n),
        ‖state (prodEquiv ((1 : Fin (2 ^ 1)), label)) -
          targetSign dBit *
            state (prodEquiv ((0 : Fin (2 ^ 1)), label))‖) ≤ error) :
    1 - error ^ 2 / 2 ≤
      PureState.probQubit0
        ((Gate.tensor Gate.H (1 : Gate (Qubits n))).apply state)
        (BitReadout.bitIndex dBit) := by
  rw [probQubit0_hadamardFirst_correct_eq]
  exact pairedCorrectMass_ge_of_sum_mismatch_norm_le
    (fun label : Fin (2 ^ n) =>
      state (prodEquiv ((0 : Fin (2 ^ 1)), label)))
    (fun label : Fin (2 ^ n) =>
      state (prodEquiv ((1 : Fin (2 ^ 1)), label)))
    dBit error (pairedBranchMass_state_eq_one state) hError hMismatch

end


end SimonDCP.Quantum.ApproximateReadout

import SimonDCP.Probability.LemmaThreeToFourL2
import Mathlib.Algebra.Order.Chebyshev

/-!
# Finite Step-7 regrouping by the low residue

This module isolates the smallest algebraic bridge needed by the L2 route
from Lemma 3 to Lemma 4.  Let `APath` be a finite set of left-side paths and
let `BPath` be a finite set of right-side paths.  Both sides carry a low
residue `z`.  The left side contributes only the number of paths in each
residue bucket, while the right side contributes the complex coefficient

```text
C_z = sum_{b in B_z} term(b).
```

The explicit double path sum is proved to be exactly `weightedAmplitude`
applied to these counts and coefficients.  A raw common path amplitude
`scale : Complex` can then be pulled outside the regrouping, and the additive
error made by replacing every left count by a common mean is controlled by
the count and coefficient L2 budgets from `LemmaThreeToFourL2`.

For the paper, `APath` is intended to retain the accepted Step-3--4 data,
`BPath` the compatible Step-5--7 continuation data, `Residue` the low value
called `z`, and `term` the signed right-side contribution to `C_z`.  The
`scale` parameter is the raw common amplitude, before outcome-dependent
postmeasurement normalization.

This file does not instantiate the actual circuit.  That application still
has to identify the concrete path types and residue maps, prove that the
circuit amplitude is the scaled double sum below, and supply the conditioned
count-error and coefficient-energy budgets (for example through a suitable
Parseval or collision calculation).

The collision section also records the limitation of a purely coherent
estimate.  Any uniform B-residue fibre bound `K` must satisfy
`#BPaths <= #Residues * K`.  If all B-path contributions are the same complex
number, the coefficient energy is exactly its squared magnitude times the sum
of squared fibre sizes, hence at least the pigeonhole scale
`normSq(common) * #BPaths^2 / #Residues`.  Beating this scale requires actual
cancellation or orthogonality, not just regrouping.
-/

namespace SimonDCP.Probability.LemmaThreeStepSevenRegrouping

open scoped BigOperators
open SimonDCP.Probability.LemmaThreeToFourL2

variable {APath BPath Residue : Type*}

/-- The real cardinality of the left-side bucket with low residue `z`.
It is written as a sum of indicators so that finite regrouping is
definitionally transparent. -/
def aResidueCount [DecidableEq Residue]
    (aPaths : Finset APath) (aResidue : APath -> Residue)
    (z : Residue) : Real :=
  ∑ a ∈ aPaths, if aResidue a = z then 1 else 0

/-- The indicator definition of `aResidueCount` is exactly the cardinality
of the corresponding finite fibre. -/
theorem aResidueCount_eq_card [DecidableEq Residue]
    (aPaths : Finset APath) (aResidue : APath -> Residue)
    (z : Residue) :
    aResidueCount aPaths aResidue z =
      ((aPaths.filter fun a => aResidue a = z).card : Real) := by
  classical
  unfold aResidueCount
  rw [← Finset.sum_filter]
  simp

/-- The right-side coefficient `C_z`, obtained by coherently summing all
right paths in the low-residue bucket `z`. -/
def bResidueCoefficient [DecidableEq Residue]
    (bPaths : Finset BPath) (bResidue : BPath -> Residue)
    (term : BPath -> Complex) (z : Residue) : Complex :=
  ∑ b ∈ bPaths.filter (fun b => bResidue b = z), term b

/-- The direct finite double sum before regrouping by the low residue. -/
def directDoubleSum [DecidableEq Residue]
    (aPaths : Finset APath) (bPaths : Finset BPath)
    (aResidue : APath -> Residue) (bResidue : BPath -> Residue)
    (term : BPath -> Complex) : Complex :=
  ∑ a ∈ aPaths,
    ∑ b ∈ bPaths.filter (fun b => bResidue b = aResidue a), term b

/-- Regrouping the direct double path sum by `z` gives exactly the
count-weighted coefficient amplitude used by the L2 comparison. -/
theorem directDoubleSum_eq_weightedAmplitude
    [Fintype Residue] [DecidableEq Residue]
    (aPaths : Finset APath) (bPaths : Finset BPath)
    (aResidue : APath -> Residue) (bResidue : BPath -> Residue)
    (term : BPath -> Complex) :
    directDoubleSum aPaths bPaths aResidue bResidue term =
      weightedAmplitude (aResidueCount aPaths aResidue)
        (bResidueCoefficient bPaths bResidue term) := by
  classical
  unfold directDoubleSum weightedAmplitude aResidueCount bResidueCoefficient
  push_cast
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  rw [Finset.sum_eq_single (aResidue a)]
  · simp
  · intro z _ hz
    simp [Ne.symm hz]
  · simp

/-- The direct amplitude after restoring one raw common path amplitude. -/
def scaledDirectAmplitude [DecidableEq Residue]
    (scale : Complex)
    (aPaths : Finset APath) (bPaths : Finset BPath)
    (aResidue : APath -> Residue) (bResidue : BPath -> Residue)
    (term : BPath -> Complex) : Complex :=
  scale * directDoubleSum aPaths bPaths aResidue bResidue term

/-- The ideal amplitude obtained by replacing every left bucket count by the
same mean, with the raw common amplitude restored. -/
def scaledMeanAmplitude [Fintype Residue] [DecidableEq Residue]
    (scale : Complex) (mean : Real)
    (bPaths : Finset BPath) (bResidue : BPath -> Residue)
    (term : BPath -> Complex) : Complex :=
  scale * meanAmplitude mean (bResidueCoefficient bPaths bResidue term)

/--
Budgeted Step-7 L2 bridge.  No pointwise upper bound on `C_z` is used: only
the total squared count error and total squared coefficient energy enter.
-/
theorem scaledDirect_sub_scaledMean_normSq_le_budget
    [Fintype Residue] [DecidableEq Residue]
    (scale : Complex)
    (aPaths : Finset APath) (bPaths : Finset BPath)
    (aResidue : APath -> Residue) (bResidue : BPath -> Residue)
    (term : BPath -> Complex)
    (mean countBudget coefficientBudget : Real)
    (hCountBudget :
      countErrorEnergy (aResidueCount aPaths aResidue) mean <= countBudget)
    (hCoefficientBudget :
      coefficientEnergy (bResidueCoefficient bPaths bResidue term) <=
        coefficientBudget)
    (hCountBudgetNonneg : 0 <= countBudget) :
    Complex.normSq
        (scaledDirectAmplitude scale aPaths bPaths aResidue bResidue term -
          scaledMeanAmplitude scale mean bPaths bResidue term) <=
      Complex.normSq scale * countBudget * coefficientBudget := by
  have hL2 := weightedAmplitude_error_normSq_le_budget
    (aResidueCount aPaths aResidue) mean
    (bResidueCoefficient bPaths bResidue term)
    countBudget coefficientBudget hCountBudget hCoefficientBudget
    hCountBudgetNonneg
  rw [scaledDirectAmplitude, scaledMeanAmplitude,
    directDoubleSum_eq_weightedAmplitude]
  rw [show
    scale * weightedAmplitude (aResidueCount aPaths aResidue)
          (bResidueCoefficient bPaths bResidue term) -
        scale * meanAmplitude mean
          (bResidueCoefficient bPaths bResidue term) =
      scale *
        (weightedAmplitude (aResidueCount aPaths aResidue)
            (bResidueCoefficient bPaths bResidue term) -
          meanAmplitude mean
            (bResidueCoefficient bPaths bResidue term)) by ring]
  rw [Complex.normSq_mul]
  calc
    Complex.normSq scale *
        Complex.normSq
          (weightedAmplitude (aResidueCount aPaths aResidue)
              (bResidueCoefficient bPaths bResidue term) -
            meanAmplitude mean
              (bResidueCoefficient bPaths bResidue term)) <=
        Complex.normSq scale * (countBudget * coefficientBudget) :=
      mul_le_mul_of_nonneg_left hL2 (Complex.normSq_nonneg scale)
    _ = Complex.normSq scale * countBudget * coefficientBudget := by ring

/-! ## Optional collision expansion of the coefficient energy -/

/-- Squared norm of a finite complex sum, expanded as a sum over ordered
collisions. -/
theorem normSq_finsetSum_eq_collisionSum
    (paths : Finset BPath) (term : BPath -> Complex) :
    Complex.normSq (∑ b ∈ paths, term b) =
      ∑ left ∈ paths, ∑ right ∈ paths,
        ((starRingEnd Complex) (term left) * term right).re := by
  classical
  have hComplex :
      ((Complex.normSq (∑ b ∈ paths, term b) : Real) : Complex) =
        ∑ left ∈ paths, ∑ right ∈ paths,
          (starRingEnd Complex) (term left) * term right := by
    rw [Complex.normSq_eq_conj_mul_self]
    simp only [map_sum]
    rw [Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro left _
    rw [Finset.mul_sum]
  have hReal := congrArg Complex.re hComplex
  simpa using hReal

/-- The coefficient energy is exactly the sum of all within-residue ordered
collisions of right-side path terms. -/
theorem coefficientEnergy_bResidueCoefficient_eq_collisionSum
    [Fintype Residue] [DecidableEq Residue]
    (bPaths : Finset BPath) (bResidue : BPath -> Residue)
    (term : BPath -> Complex) :
    coefficientEnergy (bResidueCoefficient bPaths bResidue term) =
      ∑ z, ∑ left ∈ bPaths.filter (fun b => bResidue b = z),
        ∑ right ∈ bPaths.filter (fun b => bResidue b = z),
          ((starRingEnd Complex) (term left) * term right).re := by
  classical
  unfold coefficientEnergy bResidueCoefficient
  apply Finset.sum_congr rfl
  intro z _
  exact normSq_finsetSum_eq_collisionSum
    (bPaths.filter fun b => bResidue b = z) term

/-! ## Coherent-fibre obstruction and upper bounds -/

/-- The B-residue fibres partition the finite B-path set. -/
theorem sum_bResidueFiberCard
    [Fintype Residue] [DecidableEq Residue]
    (bPaths : Finset BPath) (bResidue : BPath -> Residue) :
    (∑ z, (bPaths.filter fun b => bResidue b = z).card) = bPaths.card := by
  classical
  simpa using
    (Finset.sum_card_fiberwise_eq_card_filter
      (s := bPaths) (t := (Finset.univ : Finset Residue)) bResidue)

/-- Any uniform B-residue fibre bound must account for all B paths. -/
theorem card_bPaths_le_card_residue_mul_fiberCardBound
    [Fintype Residue] [DecidableEq Residue]
    (bPaths : Finset BPath) (bResidue : BPath -> Residue)
    (fiberCardBound : Nat)
    (hFiberCard : ∀ z,
      (bPaths.filter fun b => bResidue b = z).card ≤ fiberCardBound) :
    bPaths.card ≤ Fintype.card Residue * fiberCardBound := by
  rw [← sum_bResidueFiberCard bPaths bResidue]
  calc
    (∑ z, (bPaths.filter fun b => bResidue b = z).card) ≤
        ∑ _z : Residue, fiberCardBound :=
      Finset.sum_le_sum fun z _ => hFiberCard z
    _ = Fintype.card Residue * fiberCardBound := by simp

/--
Pigeonhole lower bound for the squared B-residue fibre sizes.  Thus a small
maximum fibre requires enough residue labels relative to the number of paths.
-/
theorem card_sq_div_le_sum_sq_bResidueFiberCard
    [Fintype Residue] [DecidableEq Residue] [Nonempty Residue]
    (bPaths : Finset BPath) (bResidue : BPath -> Residue) :
    (bPaths.card : Real) ^ 2 / Fintype.card Residue ≤
      ∑ z, ((bPaths.filter fun b => bResidue b = z).card : Real) ^ 2 := by
  classical
  have hSum :
      (∑ z, ((bPaths.filter fun b => bResidue b = z).card : Real)) =
        bPaths.card := by
    exact_mod_cast sum_bResidueFiberCard bPaths bResidue
  have hCauchy := sq_sum_le_card_mul_sum_sq
    (s := (Finset.univ : Finset Residue))
    (f := fun z =>
      ((bPaths.filter fun b => bResidue b = z).card : Real))
  rw [hSum] at hCauchy
  apply (div_le_iff₀ (by positivity : (0 : Real) < Fintype.card Residue)).2
  simpa [mul_comm] using hCauchy

/--
If every B path has the same complex contribution, the coefficient energy is
exactly its squared magnitude times the squared-fibre collision sum.
-/
theorem coefficientEnergy_bResidueCoefficient_const
    [Fintype Residue] [DecidableEq Residue]
    (bPaths : Finset BPath) (bResidue : BPath -> Residue)
    (common : Complex) :
    coefficientEnergy
        (bResidueCoefficient bPaths bResidue fun _ => common) =
      Complex.normSq common *
        ∑ z, ((bPaths.filter fun b => bResidue b = z).card : Real) ^ 2 := by
  classical
  unfold coefficientEnergy bResidueCoefficient
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro z _
  simp only [Finset.sum_const, nsmul_eq_mul, Complex.normSq_mul,
    Complex.normSq_natCast]
  ring

/--
Identical B-path contributions therefore inherit the unavoidable
fibre-collision lower
bound.  Any smaller coefficient estimate must exploit cancellation or extra
orthogonality not present in this purely coherent constant-contribution model.
-/
theorem coefficientEnergy_bResidueCoefficient_const_lower_bound
    [Fintype Residue] [DecidableEq Residue] [Nonempty Residue]
    (bPaths : Finset BPath) (bResidue : BPath -> Residue)
    (common : Complex) :
    Complex.normSq common *
        ((bPaths.card : Real) ^ 2 / Fintype.card Residue) ≤
      coefficientEnergy
        (bResidueCoefficient bPaths bResidue fun _ => common) := by
  rw [coefficientEnergy_bResidueCoefficient_const]
  exact mul_le_mul_of_nonneg_left
    (card_sq_div_le_sum_sq_bResidueFiberCard bPaths bResidue)
    (Complex.normSq_nonneg common)

/--
A coefficient-energy bound in terms of the largest right-path residue fibre.
No cancellation or independence is required.  In particular, an injective
residue map has `fiberCardBound = 1` and loses no factor beyond the diagonal
path energy.
-/
theorem coefficientEnergy_bResidueCoefficient_le_fiberCard_mul_sum_normSq
    [Fintype Residue] [DecidableEq Residue]
    (bPaths : Finset BPath) (bResidue : BPath -> Residue)
    (term : BPath -> Complex) (fiberCardBound : Nat)
    (hFiberCard : ∀ z,
      (bPaths.filter fun b => bResidue b = z).card ≤ fiberCardBound) :
    coefficientEnergy (bResidueCoefficient bPaths bResidue term) ≤
      (fiberCardBound : Real) *
        ∑ b ∈ bPaths, Complex.normSq (term b) := by
  classical
  unfold coefficientEnergy bResidueCoefficient
  calc
    (∑ z, Complex.normSq
        (∑ b ∈ bPaths.filter (fun b => bResidue b = z), term b)) ≤
      ∑ z, ((bPaths.filter fun b => bResidue b = z).card : Real) *
        ∑ b ∈ bPaths.filter (fun b => bResidue b = z),
          Complex.normSq (term b) := by
      apply Finset.sum_le_sum
      intro z _
      simpa using normSq_sum_real_mul_le
        (bPaths.filter fun b => bResidue b = z)
        (fun _ => (1 : Real)) term
    _ ≤ ∑ z, (fiberCardBound : Real) *
        ∑ b ∈ bPaths.filter (fun b => bResidue b = z),
          Complex.normSq (term b) := by
      apply Finset.sum_le_sum
      intro z _
      apply mul_le_mul_of_nonneg_right
      · exact_mod_cast hFiberCard z
      · exact Finset.sum_nonneg fun b _ => Complex.normSq_nonneg (term b)
    _ = (fiberCardBound : Real) *
        ∑ b ∈ bPaths, Complex.normSq (term b) := by
      rw [← Finset.mul_sum]
      simp_rw [Finset.sum_filter]
      rw [Finset.sum_comm]
      congr 1
      apply Finset.sum_congr rfl
      intro b _
      rw [Finset.sum_eq_single (bResidue b)]
      · simp
      · intro z _ hz
        simp [Ne.symm hz]
      · simp

/--
A universal specialization of the fibre-cardinality estimate: coherently
grouping the right paths by residue costs at most the total number of right
paths times their diagonal energy.  A sharper fibre bound, Parseval identity,
or orthogonality argument can improve this factor.
-/
theorem coefficientEnergy_bResidueCoefficient_le_card_mul_sum_normSq
    [Fintype Residue] [DecidableEq Residue]
    (bPaths : Finset BPath) (bResidue : BPath -> Residue)
    (term : BPath -> Complex) :
    coefficientEnergy (bResidueCoefficient bPaths bResidue term) ≤
      (bPaths.card : Real) *
        ∑ b ∈ bPaths, Complex.normSq (term b) := by
  apply coefficientEnergy_bResidueCoefficient_le_fiberCard_mul_sum_normSq
    bPaths bResidue term bPaths.card
  intro z
  exact Finset.card_filter_le bPaths (fun b => bResidue b = z)

end SimonDCP.Probability.LemmaThreeStepSevenRegrouping

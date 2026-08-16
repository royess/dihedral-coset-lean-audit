import SimonDCP.Probability.Lemma4Parameters
import SimonDCP.Probability.PairwiseBernoulliTail

/-!
# A conditional repair interface for Lemma 4

The paper's balls-in-bins argument, if its conditional probability premises are
supplied, controls the number of state portions contributing to each low-part
bin. Such count control gives an additive comparison between the two high-bit
amplitudes. It does not by itself give the claimed multiplicative comparison,
because the common signed reference sum can cancel.

This file records the valid deterministic conclusion. The first theorem
compares two weighted amplitudes additively when both count functions are close
to the same mean. The second elementary theorem identifies the extra
anti-cancellation input needed to convert an additive estimate to a relative
one. The final theorem combines them into a repaired Lemma 4 interface.

All amplitudes here are real. This already captures the signed sums in the
proof sketch; a later complex-amplitude model can replace absolute values by
norms without changing the missing lower-bound obligation.
-/

namespace SimonDCP.Probability.Lemma4Repair

open scoped BigOperators

noncomputable section

/-- A finite weighted amplitude with one multiplicity for each low-part bin. -/
def weightedAmplitude
    {β : Type*} (bins : Finset β) (count coefficient : β → ℝ) : ℝ :=
  ∑ b ∈ bins, count b * coefficient b

/--
If the multiplicities for both high-bit branches are uniformly close to the
same mean, their signed weighted amplitudes are additively close. This is the
unconditional deterministic conclusion of the proposed balls-in-bins step.
-/
theorem weightedAmplitude_pair_additive
    {β : Type*} (bins : Finset β)
    (leftCount rightCount coefficient : β → ℝ)
    (mean error coefficientBound : ℝ)
    (herror : 0 ≤ error)
    (hleft : ∀ b ∈ bins, |leftCount b - mean| ≤ error)
    (hright : ∀ b ∈ bins, |rightCount b - mean| ≤ error)
    (hcoefficient : ∀ b ∈ bins, |coefficient b| ≤ coefficientBound) :
    |weightedAmplitude bins leftCount coefficient -
        weightedAmplitude bins rightCount coefficient| ≤
      2 * (bins.card : ℝ) * error * coefficientBound := by
  let reference := mean * ∑ b ∈ bins, coefficient b
  have hleftError :
      |weightedAmplitude bins leftCount coefficient - reference| ≤
        (bins.card : ℝ) * error * coefficientBound := by
    simpa only [weightedAmplitude, reference] using
      Lemma4Parameters.weightedSumErrorBound bins leftCount coefficient
        mean error coefficientBound herror hleft hcoefficient
  have hrightError :
      |reference - weightedAmplitude bins rightCount coefficient| ≤
        (bins.card : ℝ) * error * coefficientBound := by
    rw [abs_sub_comm]
    simpa only [weightedAmplitude, reference] using
      Lemma4Parameters.weightedSumErrorBound bins rightCount coefficient
        mean error coefficientBound herror hright hcoefficient
  calc
    |weightedAmplitude bins leftCount coefficient -
        weightedAmplitude bins rightCount coefficient| ≤
        |weightedAmplitude bins leftCount coefficient - reference| +
          |reference - weightedAmplitude bins rightCount coefficient| :=
      abs_sub_le _ _ _
    _ ≤ (bins.card : ℝ) * error * coefficientBound +
          (bins.card : ℝ) * error * coefficientBound :=
      add_le_add hleftError hrightError
    _ = 2 * (bins.card : ℝ) * error * coefficientBound := by ring

/--
An additive comparison becomes a relative comparison once the reference
amplitude is bounded away from zero. This is the anti-cancellation premise
missing from the multiplicative conclusion in the paper's Lemma 4 sketch.
-/
theorem relative_error_of_additive_error
    {reference comparison additiveError lowerBound : ℝ}
    (hlowerBound : 0 < lowerBound)
    (hreference : lowerBound ≤ |reference|)
    (hadditiveError : 0 ≤ additiveError)
    (hcomparison : |comparison - reference| ≤ additiveError) :
    |comparison / reference - 1| ≤ additiveError / lowerBound := by
  have habsReference : 0 < |reference| :=
    lt_of_lt_of_le hlowerBound hreference
  have hreferenceNe : reference ≠ 0 := abs_pos.mp habsReference
  calc
    |comparison / reference - 1| =
        |(comparison - reference) / reference| := by
      congr 1
      field_simp
    _ = |comparison - reference| / |reference| := abs_div _ _
    _ ≤ additiveError / |reference| :=
      (div_le_div_iff_of_pos_right habsReference).2 hcomparison
    _ ≤ additiveError / lowerBound :=
      div_le_div_of_nonneg_left hadditiveError hlowerBound hreference

/--
Conditional repaired form of the multiplicative step: near-uniform bin counts
give a relative amplitude estimate provided one high-bit branch also has a
positive amplitude lower bound. The paper supplies neither this lower bound
nor an equivalent phase-alignment argument.
-/
theorem weightedAmplitude_pair_relative
    {β : Type*} (bins : Finset β)
    (leftCount rightCount coefficient : β → ℝ)
    (mean error coefficientBound lowerBound : ℝ)
    (herror : 0 ≤ error)
    (hcoefficientBound : 0 ≤ coefficientBound)
    (hleft : ∀ b ∈ bins, |leftCount b - mean| ≤ error)
    (hright : ∀ b ∈ bins, |rightCount b - mean| ≤ error)
    (hcoefficient : ∀ b ∈ bins, |coefficient b| ≤ coefficientBound)
    (hlowerBound : 0 < lowerBound)
    (hantiCancellation :
      lowerBound ≤ |weightedAmplitude bins leftCount coefficient|) :
    |weightedAmplitude bins rightCount coefficient /
          weightedAmplitude bins leftCount coefficient - 1| ≤
      (2 * (bins.card : ℝ) * error * coefficientBound) / lowerBound := by
  apply relative_error_of_additive_error hlowerBound hantiCancellation
  · positivity
  · rw [abs_sub_comm]
    exact weightedAmplitude_pair_additive bins leftCount rightCount coefficient
      mean error coefficientBound herror hleft hright hcoefficient

/-! ## A finite probabilistic repaired Lemma 4 -/

open PairwiseBernoulliTail

/-- Event mass with classical decidability internalized in the definition. -/
noncomputable def eventMass
    {Ω : Type*} [Fintype Ω] (weight : Ω → ℚ) (event : Ω → Prop) : ℚ := by
  classical
  exact ∑ ω, if event ω then weight ω else 0

/-- The local classical event mass agrees with the reusable Bernoulli module. -/
theorem eventMass_eq_pairwiseEventMass
    {Ω : Type*} [Fintype Ω] (weight : Ω → ℚ) (event : Ω → Prop)
    [DecidablePred event] :
    eventMass weight event = PairwiseBernoulliTail.eventMass weight event := by
  classical
  unfold eventMass PairwiseBernoulliTail.eventMass
  apply Finset.sum_congr rfl
  intro ω _
  by_cases hevent : event ω <;> simp [hevent]

/-- Event mass is monotone under pointwise event inclusion. -/
theorem eventMass_mono
    {Ω : Type*} [Fintype Ω] (weight : Ω → ℚ)
    (first second : Ω → Prop)
    (hweight : ∀ ω, 0 ≤ weight ω)
    (hsubset : ∀ ω, first ω → second ω) :
    eventMass weight first ≤ eventMass weight second := by
  classical
  unfold eventMass
  apply Finset.sum_le_sum
  intro ω _
  by_cases hfirst : first ω <;> by_cases hsecond : second ω
  · simp [hfirst, hsecond]
  · exact (hsecond (hsubset ω hfirst)).elim
  · simp [hfirst, hsecond, hweight ω]
  · simp [hfirst, hsecond]

/-- Union bound for two events on a finite nonnegative weighted space. -/
theorem eventMass_or_le
    {Ω : Type*} [Fintype Ω] (weight : Ω → ℚ)
    (first second : Ω → Prop) (hweight : ∀ ω, 0 ≤ weight ω) :
    eventMass weight (fun ω => first ω ∨ second ω) ≤
      eventMass weight first + eventMass weight second := by
  classical
  unfold eventMass
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro ω _
  by_cases hfirst : first ω <;> by_cases hsecond : second ω <;>
    simp [hfirst, hsecond, hweight ω]

/-- Finite union bound for a family of events indexed by a `Finset`. -/
theorem eventMass_finset_exists_le
    {Ω ι : Type*} [Fintype Ω] (weight : Ω → ℚ)
    (indices : Finset ι) (event : ι → Ω → Prop)
    (hweight : ∀ ω, 0 ≤ weight ω) :
    eventMass weight (fun ω => ∃ i ∈ indices, event i ω) ≤
      ∑ i ∈ indices, eventMass weight (event i) := by
  classical
  calc
    eventMass weight (fun ω => ∃ i ∈ indices, event i ω) ≤
        ∑ ω, ∑ i ∈ indices, if event i ω then weight ω else 0 := by
      unfold eventMass
      apply Finset.sum_le_sum
      intro ω _
      by_cases hexists : ∃ i ∈ indices, event i ω
      · obtain ⟨i, hi, hevent⟩ := hexists
        have hexists' : ∃ j ∈ indices, event j ω := ⟨i, hi, hevent⟩
        have hsingle :
            (if event i ω then weight ω else 0) ≤
              ∑ j ∈ indices, if event j ω then weight ω else 0 :=
          Finset.single_le_sum (s := indices) (f := fun j =>
            if event j ω then weight ω else 0) (fun j _ => by
              by_cases hj : event j ω <;> simp [hj, hweight ω]) hi
        simpa [hexists', hevent] using hsingle
      · simp only [hexists, if_false]
        exact Finset.sum_nonneg fun i _ => by
          by_cases hi : event i ω <;> simp [hi, hweight ω]
    _ = ∑ i ∈ indices, eventMass weight (event i) := by
      unfold eventMass
      rw [Finset.sum_comm]

/-- An event and its complement partition the total finite mass. -/
theorem eventMass_complement_add
    {Ω : Type*} [Fintype Ω] (weight : Ω → ℚ) (event : Ω → Prop) :
    eventMass weight (fun ω => ¬ event ω) + eventMass weight event =
      ∑ ω, weight ω := by
  classical
  unfold eventMass
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro ω _
  by_cases hevent : event ω <;> simp [hevent]

/-- At least one low-part bin has a count error larger than the stated radius. -/
def countDeviationBad
    {Ω β : Type*} (bins : Finset β) (count : Ω → β → ℝ)
    (mean error : ℝ) (ω : Ω) : Prop :=
  ∃ b ∈ bins, error < |count ω b - mean|

/-- Either high-bit branch has a low-part bin outside the stated radius. -/
def pairedCountDeviationBad
    {Ω β : Type*} (bins : Finset β)
    (leftCount rightCount : Ω → β → ℝ)
    (mean error : ℝ) (ω : Ω) : Prop :=
  countDeviationBad bins leftCount mean error ω ∨
    countDeviationBad bins rightCount mean error ω

/--
If every bin in each branch has tail mass at most `tail`, the probability that
any count estimate needed by the deterministic repair fails is at most twice
the number of bins times `tail`.
-/
theorem pairedCountDeviationBad_mass_le
    {Ω β : Type*} [Fintype Ω] (bins : Finset β)
    (weight : Ω → ℚ) (leftCount rightCount : Ω → β → ℝ)
    (mean error : ℝ) (tail : ℚ)
    (hweight : ∀ ω, 0 ≤ weight ω)
    (hleftTail : ∀ b ∈ bins,
      eventMass weight (fun ω => error < |leftCount ω b - mean|) ≤ tail)
    (hrightTail : ∀ b ∈ bins,
      eventMass weight (fun ω => error < |rightCount ω b - mean|) ≤ tail) :
    eventMass weight
        (pairedCountDeviationBad bins leftCount rightCount mean error) ≤
      2 * (bins.card : ℚ) * tail := by
  classical
  have hleft :
      eventMass weight (countDeviationBad bins leftCount mean error) ≤
        (bins.card : ℚ) * tail := by
    calc
      eventMass weight (countDeviationBad bins leftCount mean error) ≤
          ∑ b ∈ bins,
            eventMass weight (fun ω => error < |leftCount ω b - mean|) := by
        change eventMass weight
          (fun ω => ∃ b ∈ bins, error < |leftCount ω b - mean|) ≤ _
        exact eventMass_finset_exists_le weight bins
          (fun b ω => error < |leftCount ω b - mean|) hweight
      _ ≤ ∑ _b ∈ bins, tail :=
        Finset.sum_le_sum fun b hb => hleftTail b hb
      _ = (bins.card : ℚ) * tail := by simp
  have hright :
      eventMass weight (countDeviationBad bins rightCount mean error) ≤
        (bins.card : ℚ) * tail := by
    calc
      eventMass weight (countDeviationBad bins rightCount mean error) ≤
          ∑ b ∈ bins,
            eventMass weight (fun ω => error < |rightCount ω b - mean|) := by
        change eventMass weight
          (fun ω => ∃ b ∈ bins, error < |rightCount ω b - mean|) ≤ _
        exact eventMass_finset_exists_le weight bins
          (fun b ω => error < |rightCount ω b - mean|) hweight
      _ ≤ ∑ _b ∈ bins, tail :=
        Finset.sum_le_sum fun b hb => hrightTail b hb
      _ = (bins.card : ℚ) * tail := by simp
  calc
    eventMass weight
        (pairedCountDeviationBad bins leftCount rightCount mean error) ≤
        eventMass weight (countDeviationBad bins leftCount mean error) +
          eventMass weight (countDeviationBad bins rightCount mean error) := by
      change eventMass weight (fun ω =>
        countDeviationBad bins leftCount mean error ω ∨
          countDeviationBad bins rightCount mean error ω) ≤ _
      exact eventMass_or_le weight
        (countDeviationBad bins leftCount mean error)
        (countDeviationBad bins rightCount mean error) hweight
    _ ≤ (bins.card : ℚ) * tail + (bins.card : ℚ) * tail :=
      add_le_add hleft hright
    _ = 2 * (bins.card : ℚ) * tail := by ring

/--
Repaired additive Lemma 4 on a finite conditioned space. Per-bin concentration
for both branches implies that violation of the additive amplitude comparison
has mass at most `2 * numberOfBins * tail`.

The per-bin hypotheses can be discharged by `chebyshev_indicatorSum_le_mean`
when the required conditional pairwise-independence moments are actually
available. Unlike the paper, this theorem does not infer those moments after
conditioning.
-/
theorem repairedLemmaFour_additive_failure_mass_le
    {Ω β : Type*} [Fintype Ω] (bins : Finset β)
    (weight : Ω → ℚ)
    (leftCount rightCount coefficient : Ω → β → ℝ)
    (mean error coefficientBound : ℝ) (tail : ℚ)
    (hweight : ∀ ω, 0 ≤ weight ω)
    (herror : 0 ≤ error)
    (hleftTail : ∀ b ∈ bins,
      eventMass weight (fun ω => error < |leftCount ω b - mean|) ≤ tail)
    (hrightTail : ∀ b ∈ bins,
      eventMass weight (fun ω => error < |rightCount ω b - mean|) ≤ tail)
    (hcoefficient : ∀ ω b, b ∈ bins →
      |coefficient ω b| ≤ coefficientBound) :
    eventMass weight (fun ω =>
        2 * (bins.card : ℝ) * error * coefficientBound <
          |weightedAmplitude bins (leftCount ω) (coefficient ω) -
            weightedAmplitude bins (rightCount ω) (coefficient ω)|) ≤
      2 * (bins.card : ℚ) * tail := by
  classical
  calc
    eventMass weight (fun ω =>
        2 * (bins.card : ℝ) * error * coefficientBound <
          |weightedAmplitude bins (leftCount ω) (coefficient ω) -
            weightedAmplitude bins (rightCount ω) (coefficient ω)|) ≤
        eventMass weight
          (pairedCountDeviationBad bins leftCount rightCount mean error) := by
      apply eventMass_mono weight _ _ hweight
      intro ω hamplitude
      by_contra hbad
      have hleftGood :
          ∀ b ∈ bins, |leftCount ω b - mean| ≤ error := by
        intro b hb
        by_contra hle
        exact hbad (Or.inl ⟨b, hb, lt_of_not_ge hle⟩)
      have hrightGood :
          ∀ b ∈ bins, |rightCount ω b - mean| ≤ error := by
        intro b hb
        by_contra hle
        exact hbad (Or.inr ⟨b, hb, lt_of_not_ge hle⟩)
      exact (not_lt_of_ge <|
        weightedAmplitude_pair_additive bins (leftCount ω) (rightCount ω)
          (coefficient ω) mean error coefficientBound herror hleftGood
          hrightGood (hcoefficient ω)) hamplitude
    _ ≤ 2 * (bins.card : ℚ) * tail :=
      pairedCountDeviationBad_mass_le bins weight leftCount rightCount
        mean error tail hweight hleftTail hrightTail

/-- Probability-at-least form of the repaired additive Lemma 4. -/
theorem repairedLemmaFour_additive_success_mass_ge
    {Ω β : Type*} [Fintype Ω] (bins : Finset β)
    (weight : Ω → ℚ)
    (leftCount rightCount coefficient : Ω → β → ℝ)
    (mean error coefficientBound : ℝ) (tail : ℚ)
    (hweight : ∀ ω, 0 ≤ weight ω)
    (hnormalized : (∑ ω, weight ω) = 1)
    (herror : 0 ≤ error)
    (hleftTail : ∀ b ∈ bins,
      eventMass weight (fun ω => error < |leftCount ω b - mean|) ≤ tail)
    (hrightTail : ∀ b ∈ bins,
      eventMass weight (fun ω => error < |rightCount ω b - mean|) ≤ tail)
    (hcoefficient : ∀ ω b, b ∈ bins →
      |coefficient ω b| ≤ coefficientBound) :
    1 - 2 * (bins.card : ℚ) * tail ≤
      eventMass weight (fun ω =>
        |weightedAmplitude bins (leftCount ω) (coefficient ω) -
            weightedAmplitude bins (rightCount ω) (coefficient ω)| ≤
          2 * (bins.card : ℝ) * error * coefficientBound) := by
  let success : Ω → Prop := fun ω =>
    |weightedAmplitude bins (leftCount ω) (coefficient ω) -
        weightedAmplitude bins (rightCount ω) (coefficient ω)| ≤
      2 * (bins.card : ℝ) * error * coefficientBound
  have hfailure :
      eventMass weight (fun ω => ¬ success ω) ≤
        2 * (bins.card : ℚ) * tail := by
    simpa only [success, not_le] using
      repairedLemmaFour_additive_failure_mass_le bins weight leftCount
        rightCount coefficient mean error coefficientBound tail hweight herror
        hleftTail hrightTail hcoefficient
  have hpartition := eventMass_complement_add weight success
  rw [hnormalized] at hpartition
  change 1 - 2 * (bins.card : ℚ) * tail ≤ eventMass weight success
  linarith

/--
Full relative repaired Lemma 4. It has the same finite union-bound probability
as the additive theorem, but explicitly assumes a uniform positive lower bound
on the left-branch amplitude. This is the anti-cancellation premise absent from
the paper's sketch.
-/
theorem repairedLemmaFour_relative_failure_mass_le
    {Ω β : Type*} [Fintype Ω] (bins : Finset β)
    (weight : Ω → ℚ)
    (leftCount rightCount coefficient : Ω → β → ℝ)
    (mean error coefficientBound lowerBound : ℝ) (tail : ℚ)
    (hweight : ∀ ω, 0 ≤ weight ω)
    (herror : 0 ≤ error)
    (hcoefficientBound : 0 ≤ coefficientBound)
    (hleftTail : ∀ b ∈ bins,
      eventMass weight (fun ω => error < |leftCount ω b - mean|) ≤ tail)
    (hrightTail : ∀ b ∈ bins,
      eventMass weight (fun ω => error < |rightCount ω b - mean|) ≤ tail)
    (hcoefficient : ∀ ω b, b ∈ bins →
      |coefficient ω b| ≤ coefficientBound)
    (hlowerBound : 0 < lowerBound)
    (hantiCancellation : ∀ ω,
      lowerBound ≤ |weightedAmplitude bins (leftCount ω) (coefficient ω)|) :
    eventMass weight (fun ω =>
        (2 * (bins.card : ℝ) * error * coefficientBound) / lowerBound <
          |weightedAmplitude bins (rightCount ω) (coefficient ω) /
              weightedAmplitude bins (leftCount ω) (coefficient ω) - 1|) ≤
      2 * (bins.card : ℚ) * tail := by
  classical
  calc
    eventMass weight (fun ω =>
        (2 * (bins.card : ℝ) * error * coefficientBound) / lowerBound <
          |weightedAmplitude bins (rightCount ω) (coefficient ω) /
              weightedAmplitude bins (leftCount ω) (coefficient ω) - 1|) ≤
        eventMass weight
          (pairedCountDeviationBad bins leftCount rightCount mean error) := by
      apply eventMass_mono weight _ _ hweight
      intro ω hamplitude
      by_contra hbad
      have hleftGood :
          ∀ b ∈ bins, |leftCount ω b - mean| ≤ error := by
        intro b hb
        by_contra hle
        exact hbad (Or.inl ⟨b, hb, lt_of_not_ge hle⟩)
      have hrightGood :
          ∀ b ∈ bins, |rightCount ω b - mean| ≤ error := by
        intro b hb
        by_contra hle
        exact hbad (Or.inr ⟨b, hb, lt_of_not_ge hle⟩)
      exact (not_lt_of_ge <|
        weightedAmplitude_pair_relative bins (leftCount ω) (rightCount ω)
          (coefficient ω) mean error coefficientBound lowerBound herror
          hcoefficientBound hleftGood hrightGood (hcoefficient ω) hlowerBound
          (hantiCancellation ω)) hamplitude
    _ ≤ 2 * (bins.card : ℚ) * tail :=
      pairedCountDeviationBad_mass_le bins weight leftCount rightCount
        mean error tail hweight hleftTail hrightTail

/-- Probability-at-least form of the full relative repaired Lemma 4. -/
theorem repairedLemmaFour_relative_success_mass_ge
    {Ω β : Type*} [Fintype Ω] (bins : Finset β)
    (weight : Ω → ℚ)
    (leftCount rightCount coefficient : Ω → β → ℝ)
    (mean error coefficientBound lowerBound : ℝ) (tail : ℚ)
    (hweight : ∀ ω, 0 ≤ weight ω)
    (hnormalized : (∑ ω, weight ω) = 1)
    (herror : 0 ≤ error)
    (hcoefficientBound : 0 ≤ coefficientBound)
    (hleftTail : ∀ b ∈ bins,
      eventMass weight (fun ω => error < |leftCount ω b - mean|) ≤ tail)
    (hrightTail : ∀ b ∈ bins,
      eventMass weight (fun ω => error < |rightCount ω b - mean|) ≤ tail)
    (hcoefficient : ∀ ω b, b ∈ bins →
      |coefficient ω b| ≤ coefficientBound)
    (hlowerBound : 0 < lowerBound)
    (hantiCancellation : ∀ ω,
      lowerBound ≤ |weightedAmplitude bins (leftCount ω) (coefficient ω)|) :
    1 - 2 * (bins.card : ℚ) * tail ≤
      eventMass weight (fun ω =>
        |weightedAmplitude bins (rightCount ω) (coefficient ω) /
              weightedAmplitude bins (leftCount ω) (coefficient ω) - 1| ≤
          (2 * (bins.card : ℝ) * error * coefficientBound) / lowerBound) := by
  let success : Ω → Prop := fun ω =>
    |weightedAmplitude bins (rightCount ω) (coefficient ω) /
          weightedAmplitude bins (leftCount ω) (coefficient ω) - 1| ≤
      (2 * (bins.card : ℝ) * error * coefficientBound) / lowerBound
  have hfailure :
      eventMass weight (fun ω => ¬ success ω) ≤
        2 * (bins.card : ℚ) * tail := by
    simpa only [success, not_le] using
      repairedLemmaFour_relative_failure_mass_le bins weight leftCount
        rightCount coefficient mean error coefficientBound lowerBound tail
        hweight herror hcoefficientBound hleftTail hrightTail hcoefficient
        hlowerBound hantiCancellation
  have hpartition := eventMass_complement_add weight success
  rw [hnormalized] at hpartition
  change 1 - 2 * (bins.card : ℚ) * tail ≤ eventMass weight success
  linarith

end

end SimonDCP.Probability.Lemma4Repair

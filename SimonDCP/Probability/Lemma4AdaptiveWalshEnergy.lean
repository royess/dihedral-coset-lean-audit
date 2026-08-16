import SimonDCP.Probability.Lemma4PaperDecoder
import SimonDCP.Probability.LemmaThreePaperPathEnergy

/-!
# Adaptive Walsh energy for the paper-facing Lemma 4 decoder

`Lemma4PaperDecoder` reduces the final decoding error to the squared
difference of two Walsh-signed path counts after the complete measured
transcript has been fixed.  This file expands that energy over ordered path
pairs, reindexed as ordered pairs of fixed ambient hidden states.

The expansion keeps transcript selection inside every pair correlation.  It
therefore identifies the exact replacement for applying fixed-support
Parseval after the fact: all off-diagonal correlations of fixed hidden-state
contributions must vanish (or be quantitatively bounded) after the adaptive
transcript selection and normalization have been included.
Under that premise, only diagonal path energy remains.
-/

namespace SimonDCP.Probability.Lemma4AdaptiveWalshEnergy

open scoped BigOperators

open SimonDCP.Probability.LemmaThreePaperPathBridge
open SimonDCP.Probability.LemmaThreePaperPathEnergy
open SimonDCP.Probability.LemmaThreePathRefinement
open SimonDCP.Probability.LemmaThreeTranscriptModel
open SimonDCP.Probability.Lemma4PaperDecoder

noncomputable section

variable {Seed Ball Path Transcript : Type*}

/-- A Boolean phase written as the real sign `+1` or `-1`. -/
def realPhaseSign (positive : Bool) : Real :=
  if positive then 1 else -1

private theorem card_filter_true_sub_card_filter_false_eq_sum_realPhaseSign
    (paths : Finset Path) (positive : Path -> Bool) :
    ((paths.filter fun path => positive path = true).card : Real) -
        ((paths.filter fun path => positive path = false).card : Real) =
      ∑ path ∈ paths, realPhaseSign (positive path) := by
  classical
  calc
    ((paths.filter fun path => positive path = true).card : Real) -
          ((paths.filter fun path => positive path = false).card : Real) =
        (∑ path ∈ paths,
          if positive path = true then (1 : Real) else 0) -
        (∑ path ∈ paths,
          if positive path = false then (1 : Real) else 0) := by simp
    _ = ∑ path ∈ paths,
          ((if positive path = true then (1 : Real) else 0) -
            if positive path = false then (1 : Real) else 0) := by
      rw [Finset.sum_sub_distrib]
    _ = ∑ path ∈ paths, realPhaseSign (positive path) := by
      apply Finset.sum_congr rfl
      intro path _
      cases hPositive : positive path <;>
        simp [realPhaseSign]

/-- A signed path count is the sum of its `+1` or `-1` phase values over the
corresponding transcript/branch fibre. -/
theorem signedPathCountReal_eq_sum_realPhaseSign
    [Fintype Path] [DecidableEq Transcript]
    (transcriptOf : Path -> Transcript) (branchOf : Path -> Bool)
    (positive : Path -> Bool) (transcript : Transcript) (branch : Bool) :
    signedPathCountReal transcriptOf branchOf positive transcript branch =
      ∑ path ∈ transcriptBranchFibre transcriptOf branchOf transcript branch,
        realPhaseSign (positive path) := by
  unfold signedPathCountReal positivePathCount negativePathCount
  exact card_filter_true_sub_card_filter_false_eq_sum_realPhaseSign
    (transcriptBranchFibre transcriptOf branchOf transcript branch) positive

/-- Contribution of one path to `branch=true` minus `branch=false` for one
complete transcript.  The transcript selection is part of the contribution. -/
def branchDifferenceContribution
    [DecidableEq Transcript]
    (transcriptOf : Path -> Transcript) (branchOf : Path -> Bool)
    (positive : Path -> Bool) (transcript : Transcript) (path : Path) : Real :=
  if transcriptOf path = transcript then
    if branchOf path then
      realPhaseSign (positive path)
    else
      -realPhaseSign (positive path)
  else 0

private theorem sum_trueBranch_sub_falseBranch_eq_sum_differenceContribution
    [DecidableEq Transcript]
    (paths : Finset Path)
    (transcriptOf : Path -> Transcript) (branchOf : Path -> Bool)
    (positive : Path -> Bool) (transcript : Transcript) :
    (∑ path ∈ paths.filter (fun path =>
          transcriptOf path = transcript ∧ branchOf path = true),
        realPhaseSign (positive path)) -
      (∑ path ∈ paths.filter (fun path =>
          transcriptOf path = transcript ∧ branchOf path = false),
        realPhaseSign (positive path)) =
      ∑ path ∈ paths,
        branchDifferenceContribution transcriptOf branchOf positive
          transcript path := by
  classical
  calc
    (∑ path ∈ paths.filter (fun path =>
          transcriptOf path = transcript ∧ branchOf path = true),
        realPhaseSign (positive path)) -
        (∑ path ∈ paths.filter (fun path =>
          transcriptOf path = transcript ∧ branchOf path = false),
        realPhaseSign (positive path)) =
      (∑ path ∈ paths,
        if transcriptOf path = transcript ∧ branchOf path = true then
          realPhaseSign (positive path)
        else 0) -
      (∑ path ∈ paths,
        if transcriptOf path = transcript ∧ branchOf path = false then
          realPhaseSign (positive path)
        else 0) := by
      rw [Finset.sum_filter, Finset.sum_filter]
    _ = ∑ path ∈ paths,
        ((if transcriptOf path = transcript ∧ branchOf path = true then
            realPhaseSign (positive path)
          else 0) -
          if transcriptOf path = transcript ∧ branchOf path = false then
            realPhaseSign (positive path)
          else 0) := by
      rw [Finset.sum_sub_distrib]
    _ = ∑ path ∈ paths,
        branchDifferenceContribution transcriptOf branchOf positive
          transcript path := by
      apply Finset.sum_congr rfl
      intro path _
      by_cases hTranscript : transcriptOf path = transcript
      · cases hBranch : branchOf path <;>
          simp [hTranscript, hBranch, branchDifferenceContribution]
      · simp [hTranscript, branchDifferenceContribution]

/-- The two-branch signed-count difference is one adaptive signed sum over
the ambient finite path type. -/
theorem signedPathCountReal_true_sub_false_eq_sum_differenceContribution
    [Fintype Path] [DecidableEq Transcript]
    (transcriptOf : Path -> Transcript) (branchOf : Path -> Bool)
    (positive : Path -> Bool) (transcript : Transcript) :
    signedPathCountReal transcriptOf branchOf positive transcript true -
        signedPathCountReal transcriptOf branchOf positive transcript false =
      ∑ path,
        branchDifferenceContribution transcriptOf branchOf positive
          transcript path := by
  rw [signedPathCountReal_eq_sum_realPhaseSign,
    signedPathCountReal_eq_sum_realPhaseSign]
  simpa [transcriptBranchFibre] using
    sum_trueBranch_sub_falseBranch_eq_sum_differenceContribution
      (Finset.univ : Finset Path) transcriptOf branchOf positive transcript

/-- Weighted squared energy of an adaptive signed sum. -/
def weightedAdaptiveSignedEnergy
    [Fintype Seed] [Fintype Ball]
    (weight : Seed -> Real) (contribution : Seed -> Ball -> Real) : Real :=
  ∑ seed, weight seed * (∑ ball, contribution seed ball) ^ 2

/-- Weighted correlation of two candidate contributions, with all adaptive
selection retained inside the seed average. -/
def weightedAdaptivePairCorrelation
    [Fintype Seed]
    (weight : Seed -> Real) (contribution : Seed -> Ball -> Real)
    (left right : Ball) : Real :=
  ∑ seed, weight seed * contribution seed left * contribution seed right

/-- Exact pair-correlation expansion of an adaptive signed energy. -/
theorem weightedAdaptiveSignedEnergy_eq_sum_pairCorrelation
    [Fintype Seed] [Fintype Ball]
    (weight : Seed -> Real) (contribution : Seed -> Ball -> Real) :
    weightedAdaptiveSignedEnergy weight contribution =
      ∑ left, ∑ right,
        weightedAdaptivePairCorrelation weight contribution left right := by
  classical
  unfold weightedAdaptiveSignedEnergy weightedAdaptivePairCorrelation
  simp_rw [pow_two, Finset.sum_mul, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro left _
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro right _
  apply Finset.sum_congr rfl
  intro seed _
  ring

/-- Total signed off-diagonal correlation.  Keeping the signs permits genuine
cancellation; an absolute-value majorant can be supplied separately when
needed. -/
noncomputable def weightedAdaptiveOffDiagonalCorrelation
    [Fintype Seed] [Fintype Ball]
    (weight : Seed -> Real) (contribution : Seed -> Ball -> Real) : Real := by
  classical
  exact ∑ left, ∑ right,
    if left = right then 0
    else weightedAdaptivePairCorrelation weight contribution left right

/-- Exact diagonal-plus-off-diagonal decomposition of adaptive signed energy. -/
theorem weightedAdaptiveSignedEnergy_eq_diagonal_add_offDiagonal
    [Fintype Seed] [Fintype Ball]
    (weight : Seed -> Real) (contribution : Seed -> Ball -> Real) :
    weightedAdaptiveSignedEnergy weight contribution =
      (∑ ball,
        weightedAdaptivePairCorrelation weight contribution ball ball) +
      weightedAdaptiveOffDiagonalCorrelation weight contribution := by
  classical
  rw [weightedAdaptiveSignedEnergy_eq_sum_pairCorrelation]
  unfold weightedAdaptiveOffDiagonalCorrelation
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro left _
  calc
    (∑ right,
      weightedAdaptivePairCorrelation weight contribution left right) =
      ∑ right,
        ((if left = right then
            weightedAdaptivePairCorrelation weight contribution left left
          else 0) +
        if left = right then 0
        else weightedAdaptivePairCorrelation weight contribution left right) := by
      apply Finset.sum_congr rfl
      intro right _
      by_cases hEqual : left = right
      · subst right
        simp
      · simp [hEqual]
    _ = (∑ right,
          if left = right then
            weightedAdaptivePairCorrelation weight contribution left left
          else 0) +
        ∑ right,
          if left = right then 0
          else weightedAdaptivePairCorrelation weight contribution left right := by
      rw [Finset.sum_add_distrib]
    _ = weightedAdaptivePairCorrelation weight contribution left left +
        ∑ right,
          if left = right then 0
          else weightedAdaptivePairCorrelation weight contribution left right := by
      simp

/-- Every off-diagonal pair correlation vanishes after adaptive selection is
included.  This is stronger and more precise than independence of the phase
variables before conditioning. -/
def WeightedAdaptivePairOrthogonal
    [Fintype Seed]
    (weight : Seed -> Real) (contribution : Seed -> Ball -> Real) : Prop :=
  ∀ left right, left ≠ right ->
    weightedAdaptivePairCorrelation weight contribution left right = 0

/-- Under adaptive pair orthogonality, signed energy is exactly its diagonal
part. -/
theorem weightedAdaptiveSignedEnergy_eq_diagonal_of_pairOrthogonal
    [Fintype Seed] [Fintype Ball]
    (weight : Seed -> Real) (contribution : Seed -> Ball -> Real)
    (hOrthogonal : WeightedAdaptivePairOrthogonal weight contribution) :
    weightedAdaptiveSignedEnergy weight contribution =
      ∑ ball,
        weightedAdaptivePairCorrelation weight contribution ball ball := by
  rw [weightedAdaptiveSignedEnergy_eq_sum_pairCorrelation]
  apply Finset.sum_congr rfl
  intro left _
  classical
  calc
    (∑ right,
        weightedAdaptivePairCorrelation weight contribution left right) =
      ∑ right,
        if left = right then
          weightedAdaptivePairCorrelation weight contribution left left
        else 0 := by
      apply Finset.sum_congr rfl
      intro right _
      by_cases hEqual : left = right
      · subst right
        simp
      · rw [if_neg hEqual]
        exact hOrthogonal left right hEqual
    _ = weightedAdaptivePairCorrelation weight contribution left left := by
      simp

/-! ## Specialization to the complete paper transcript -/

variable {Hidden Y D W S Low : Type*}

variable [Fintype Hidden] [Fintype Y] [Fintype D] [Fintype W] [Fintype S]
  [Fintype Low]
  [DecidableEq Y] [DecidableEq D] [DecidableEq W] [DecidableEq S]

/-- Weight of one complete transcript in the paper-facing Walsh mismatch. -/
def paperWalshEnergyWeight
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (stepTwoAmplitude : Y -> Complex)
    (transcript : PaperMeasuredTranscript Y D W S) : Real :=
  Complex.normSq
    (normalization transcript *
      paperCommonPathAmplitude (Low := Low) stepTwoAmplitude transcript)

/-- One already refined paper path's contribution for a fixed transcript.
This is an internal bridge to the hidden-state formulation below. -/
private def paperPathWalshDifferenceContribution
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S)
    (path : PaperStepSevenPath model) : Real :=
  branchDifferenceContribution
    (fun path : PaperStepSevenPath model => path.transcript)
    (paperBranch model) (paperWalshPositive model) transcript path

/-- One hidden state's adaptively selected contribution to the two-branch
Walsh difference.  The same hidden state is retained while the complete
transcript—and hence `D`, acceptance, `W'`, and `S`—varies. -/
noncomputable def paperWalshDifferenceContribution
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S)
    (hidden : Hidden) : Real := by
  classical
  exact
    if paperCompatible model transcript hidden then
      if model.hStarOf hidden transcript.d then
        realPhaseSign (!(model.walshPhase hidden transcript.d))
      else
        -realPhaseSign (!(model.walshPhase hidden transcript.d))
    else 0

private theorem
    paperWalshSignedBranchCount_true_sub_false_eq_sum_pathContribution
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) :
    paperWalshSignedBranchCount model transcript true -
        paperWalshSignedBranchCount model transcript false =
      ∑ path : PaperStepSevenPath model,
        paperPathWalshDifferenceContribution model transcript path := by
  unfold paperWalshSignedBranchCount paperPathWalshDifferenceContribution
  exact signedPathCountReal_true_sub_false_eq_sum_differenceContribution
    (fun path : PaperStepSevenPath model => path.transcript)
    (paperBranch model) (paperWalshPositive model) transcript

/-- The paper's Walsh-signed branch difference is exactly an adaptive signed
sum over the fixed ambient hidden-state type. -/
theorem paperWalshSignedBranchCount_true_sub_false_eq_sum_contribution
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) :
    paperWalshSignedBranchCount model transcript true -
        paperWalshSignedBranchCount model transcript false =
      ∑ hidden : Hidden,
        paperWalshDifferenceContribution model transcript hidden := by
  rw [paperWalshSignedBranchCount_true_sub_false_eq_sum_pathContribution]
  classical
  let pairContribution :
      PaperMeasuredTranscript Y D W S × Hidden -> Real := fun pair =>
    if pair.1 = transcript then
      if model.hStarOf pair.2 pair.1.d then
        realPhaseSign (!(model.walshPhase pair.2 pair.1.d))
      else
        -realPhaseSign (!(model.walshPhase pair.2 pair.1.d))
    else 0
  change (∑ path : PaperStepSevenPath model, pairContribution path.1) =
    ∑ hidden : Hidden,
      paperWalshDifferenceContribution model transcript hidden
  rw [← Finset.sum_subtype
    ((Finset.univ : Finset
      (PaperMeasuredTranscript Y D W S × Hidden)).filter fun pair =>
        paperCompatible model pair.1 pair.2)
    (by intro pair; simp) pairContribution]
  rw [Finset.sum_filter, Fintype.sum_prod_type]
  rw [Finset.sum_eq_single transcript]
  · apply Finset.sum_congr rfl
    intro hidden _
    by_cases hCompatible : paperCompatible model transcript hidden
    · simp [pairContribution, paperWalshDifferenceContribution, hCompatible]
    · simp [pairContribution, paperWalshDifferenceContribution, hCompatible]
  · intro otherTranscript _ hOther
    apply Finset.sum_eq_zero
    intro hidden _
    have hNe : otherTranscript ≠ transcript := hOther
    simp [pairContribution, hNe]
  · simp

/-- Pair correlation for two fixed hidden states, with compatibility with the
complete transcript and its normalization weight kept inside the sum. -/
def paperWalshPairCorrelation
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex)
    (left right : Hidden) : Real :=
  weightedAdaptivePairCorrelation
    (paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude)
    (paperWalshDifferenceContribution model) left right

/-- Exact conditioned pair-orthogonality premise for the paper-facing Walsh
energy.  Unlike the paper's pre-conditioning assertion, the full adaptive
transcript selection and normalization weight occur inside each correlation. -/
def PaperWalshPairOrthogonal
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) : Prop :=
  WeightedAdaptivePairOrthogonal
    (paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude)
    (paperWalshDifferenceContribution model)

/-- The total signed off-diagonal hidden-state correlation after the complete
paper transcript has been selected. -/
def paperWalshOffDiagonalCorrelation
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) : Real :=
  weightedAdaptiveOffDiagonalCorrelation
    (paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude)
    (paperWalshDifferenceContribution model)

/-- The exact Walsh mismatch from `Lemma4PaperDecoder` is an adaptive signed
energy over a fixed ambient hidden-state type. -/
theorem paperWalshMismatchEnergy_eq_weightedAdaptiveSignedEnergy
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) :
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude =
      weightedAdaptiveSignedEnergy
        (paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude)
        (paperWalshDifferenceContribution model) := by
  classical
  unfold paperWalshMismatchEnergy weightedAdaptiveSignedEnergy
    paperWalshEnergyWeight
  apply Finset.sum_congr rfl
  intro transcript _
  rw [paperWalshSignedBranchCount_true_sub_false_eq_sum_contribution]

/-- Exact ordered-pair expansion of the paper-facing Walsh mismatch. -/
theorem paperWalshMismatchEnergy_eq_sum_pairCorrelation
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) :
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude =
      ∑ left : Hidden,
        ∑ right : Hidden,
          paperWalshPairCorrelation (Low := Low) normalization model
            stepTwoAmplitude left right := by
  rw [paperWalshMismatchEnergy_eq_weightedAdaptiveSignedEnergy,
    weightedAdaptiveSignedEnergy_eq_sum_pairCorrelation]
  rfl

omit [DecidableEq D] in
/-- The sum of the hidden-state diagonal correlations is exactly the common
path energy.  This is a global identity: one hidden state can contribute to
many complete transcripts as `D` varies, so there is no pointwise
hidden-state-to-path identification. -/
theorem sum_paperWalshPairCorrelation_self_eq_pathEnergy
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) :
    (∑ hidden : Hidden,
      paperWalshPairCorrelation (Low := Low) normalization model
        stepTwoAmplitude hidden hidden) =
      ∑ path : PaperStepSevenPath model,
        paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
          path.transcript := by
  classical
  unfold paperWalshPairCorrelation weightedAdaptivePairCorrelation
  rw [Finset.sum_comm]
  calc
    (∑ transcript, ∑ hidden,
        paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
            transcript *
          paperWalshDifferenceContribution model transcript hidden *
          paperWalshDifferenceContribution model transcript hidden) =
      ∑ transcript, ∑ hidden,
        if paperCompatible model transcript hidden then
          paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
            transcript
        else 0 := by
      apply Finset.sum_congr rfl
      intro transcript _
      apply Finset.sum_congr rfl
      intro hidden _
      by_cases hCompatible : paperCompatible model transcript hidden
      · cases hBranch : model.hStarOf hidden transcript.d <;>
          cases hWalsh : model.walshPhase hidden transcript.d <;>
            simp [paperWalshDifferenceContribution, hCompatible, hBranch,
              hWalsh, realPhaseSign]
      · simp [paperWalshDifferenceContribution, hCompatible]
    _ = ∑ pair : PaperMeasuredTranscript Y D W S × Hidden,
        if paperCompatible model pair.1 pair.2 then
          paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
            pair.1
        else 0 := by
      rw [Fintype.sum_prod_type]
      apply Finset.sum_congr rfl
      intro transcript _
      apply Finset.sum_congr rfl
      intro hidden _
      by_cases hCompatible : paperCompatible model transcript hidden <;>
        simp [hCompatible]
    _ = ∑ pair ∈
          ((Finset.univ : Finset
            (PaperMeasuredTranscript Y D W S × Hidden)).filter fun pair =>
              paperCompatible model pair.1 pair.2),
        paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
          pair.1 := by
      rw [Finset.sum_filter]
    _ = ∑ path : PaperStepSevenPath model,
        paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
          path.transcript := by
      exact Finset.sum_subtype
        (p := fun pair : PaperMeasuredTranscript Y D W S × Hidden =>
          paperCompatible model pair.1 pair.2)
        ((Finset.univ : Finset
          (PaperMeasuredTranscript Y D W S × Hidden)).filter fun pair =>
            paperCompatible model pair.1 pair.2)
        (by intro pair; simp)
        (fun pair =>
          paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
            pair.1)

/-- Exact paper-facing decomposition into the already controlled diagonal
path energy and one explicit adaptive off-diagonal correlation term. -/
theorem paperWalshMismatchEnergy_eq_pathEnergy_add_offDiagonal
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) :
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude =
      (∑ path : PaperStepSevenPath model,
        paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
          path.transcript) +
      paperWalshOffDiagonalCorrelation (Low := Low) normalization model
        stepTwoAmplitude := by
  rw [paperWalshMismatchEnergy_eq_weightedAdaptiveSignedEnergy,
    weightedAdaptiveSignedEnergy_eq_diagonal_add_offDiagonal]
  congr 1
  exact sum_paperWalshPairCorrelation_self_eq_pathEnergy
    (Low := Low) normalization model stepTwoAmplitude

/-- Under exact adaptive pair orthogonality, the full Walsh mismatch is just
the diagonal common-path energy. -/
theorem paperWalshMismatchEnergy_eq_pathEnergy_of_pairOrthogonal
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex)
    (hOrthogonal :
      PaperWalshPairOrthogonal (Low := Low) normalization model
        stepTwoAmplitude) :
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude =
      ∑ path : PaperStepSevenPath model,
        paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
          path.transcript := by
  rw [paperWalshMismatchEnergy_eq_weightedAdaptiveSignedEnergy]
  rw [weightedAdaptiveSignedEnergy_eq_diagonal_of_pairOrthogonal
    _ _ hOrthogonal]
  exact sum_paperWalshPairCorrelation_self_eq_pathEnergy
    (Low := Low) normalization model stepTwoAmplitude

/-- A uniform upper bound on the transcript normalization scales the existing
paper-path diagonal-energy bound by exactly that factor. -/
theorem sum_paperWalshEnergyWeight_le_normalizationBound_mul_inv_card_low
    [Nonempty D] [Nonempty Low]
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) (normalizationBound : Real)
    (hNormalizationBound : ∀ transcript,
      Complex.normSq (normalization transcript) <= normalizationBound)
    (hNormalizationBoundNonneg : 0 <= normalizationBound)
    (hStepTwoEnergy :
      (∑ hidden : Hidden,
        Complex.normSq (stepTwoAmplitude (model.yOf hidden))) <= 1) :
    (∑ path : PaperStepSevenPath model,
      paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
        path.transcript) <=
      normalizationBound * (Fintype.card Low : Real)⁻¹ := by
  have hCommonEnergy :=
    sum_normSq_paperCommonPathAmplitude_le_inv_card_low
      (Low := Low) model stepTwoAmplitude hStepTwoEnergy
  calc
    (∑ path : PaperStepSevenPath model,
      paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
        path.transcript) =
      ∑ path : PaperStepSevenPath model,
        Complex.normSq (normalization path.transcript) *
          Complex.normSq
            (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude
              path.transcript) := by
      apply Finset.sum_congr rfl
      intro path _
      rw [paperWalshEnergyWeight, Complex.normSq_mul]
    _ <= ∑ path : PaperStepSevenPath model,
        normalizationBound *
          Complex.normSq
            (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude
              path.transcript) := by
      exact Finset.sum_le_sum fun path _ =>
        mul_le_mul_of_nonneg_right
          (hNormalizationBound path.transcript)
          (Complex.normSq_nonneg _)
    _ = normalizationBound *
        ∑ path : PaperStepSevenPath model,
          Complex.normSq
            (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude
              path.transcript) := by
      rw [Finset.mul_sum]
    _ <= normalizationBound * (Fintype.card Low : Real)⁻¹ :=
      mul_le_mul_of_nonneg_left hCommonEnergy hNormalizationBoundNonneg

/-- Quantitative adaptive-correlation bound for the remaining Walsh mismatch.
Exact pair orthogonality is the special case `offDiagonalBudget = 0`. -/
theorem paperWalshMismatchEnergy_le_normalizationBound_add_offDiagonal
    [Nonempty D] [Nonempty Low]
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex)
    (normalizationBound offDiagonalBudget : Real)
    (hNormalizationBound : ∀ transcript,
      Complex.normSq (normalization transcript) <= normalizationBound)
    (hNormalizationBoundNonneg : 0 <= normalizationBound)
    (hStepTwoEnergy :
      (∑ hidden : Hidden,
        Complex.normSq (stepTwoAmplitude (model.yOf hidden))) <= 1)
    (hOffDiagonal :
      paperWalshOffDiagonalCorrelation (Low := Low) normalization model
        stepTwoAmplitude <= offDiagonalBudget) :
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude <=
      normalizationBound * (Fintype.card Low : Real)⁻¹ +
        offDiagonalBudget := by
  rw [paperWalshMismatchEnergy_eq_pathEnergy_add_offDiagonal]
  exact add_le_add
    (sum_paperWalshEnergyWeight_le_normalizationBound_mul_inv_card_low
      normalization model stepTwoAmplitude normalizationBound
      hNormalizationBound hNormalizationBoundNonneg hStepTwoEnergy)
    hOffDiagonal

/-- Conditional paper-facing Lemma 4 repair through adaptive Walsh
orthogonality.  Once every off-diagonal hidden-state correlation vanishes
after the full transcript selection, the existing Step-2 diagonal energy and
a uniform normalization bound imply the displayed concrete decoder
probability. -/
theorem paper_decoder_success_ge_of_adaptive_pairOrthogonal
    [Nonempty D] [Nonempty Low]
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) (normalizationBound : Real)
    (hNormalizationBound : ∀ transcript,
      Complex.normSq (normalization transcript) <= normalizationBound)
    (hNormalizationBoundNonneg : 0 <= normalizationBound)
    (hStepTwoEnergy :
      (∑ hidden : Hidden,
        Complex.normSq (stepTwoAmplitude (model.yOf hidden))) <= 1)
    (hOrthogonal :
      PaperWalshPairOrthogonal (Low := Low) normalization model
        stepTwoAmplitude)
    (hNormalized :
      SimonDCP.Quantum.ApproximateReadout.pairedBranchMass
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript false)
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript true) = 1) :
    1 - (normalizationBound * (Fintype.card Low : Real)⁻¹) / 2 <=
      SimonDCP.Quantum.ApproximateReadout.pairedCorrectMass
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript false)
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript true)
        model.secretBit := by
  apply paper_decoder_success_ge_of_walsh_mismatch_energy
    normalization model stepTwoAmplitude
    (normalizationBound * (Fintype.card Low : Real)⁻¹) hNormalized
  rw [paperWalshMismatchEnergy_eq_pathEnergy_of_pairOrthogonal
    normalization model stepTwoAmplitude hOrthogonal]
  exact sum_paperWalshEnergyWeight_le_normalizationBound_mul_inv_card_low
    normalization model stepTwoAmplitude normalizationBound
    hNormalizationBound hNormalizationBoundNonneg hStepTwoEnergy

/-- Quantitative conditional Lemma 4 repair.  A bound on the adaptive
off-diagonal Walsh correlation adds directly to the normalized diagonal path
budget and therefore to the final Hadamard failure bound. -/
theorem paper_decoder_success_ge_of_adaptive_offDiagonal_bound
    [Nonempty D] [Nonempty Low]
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex)
    (normalizationBound offDiagonalBudget : Real)
    (hNormalizationBound : ∀ transcript,
      Complex.normSq (normalization transcript) <= normalizationBound)
    (hNormalizationBoundNonneg : 0 <= normalizationBound)
    (hStepTwoEnergy :
      (∑ hidden : Hidden,
        Complex.normSq (stepTwoAmplitude (model.yOf hidden))) <= 1)
    (hOffDiagonal :
      paperWalshOffDiagonalCorrelation (Low := Low) normalization model
        stepTwoAmplitude <= offDiagonalBudget)
    (hNormalized :
      SimonDCP.Quantum.ApproximateReadout.pairedBranchMass
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript false)
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript true) = 1) :
    1 - (normalizationBound * (Fintype.card Low : Real)⁻¹ +
          offDiagonalBudget) / 2 <=
      SimonDCP.Quantum.ApproximateReadout.pairedCorrectMass
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript false)
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript true)
        model.secretBit := by
  apply paper_decoder_success_ge_of_walsh_mismatch_energy
    normalization model stepTwoAmplitude
    (normalizationBound * (Fintype.card Low : Real)⁻¹ + offDiagonalBudget)
    hNormalized
  exact paperWalshMismatchEnergy_le_normalizationBound_add_offDiagonal
    normalization model stepTwoAmplitude normalizationBound
    offDiagonalBudget hNormalizationBound hNormalizationBoundNonneg
    hStepTwoEnergy hOffDiagonal

end

end SimonDCP.Probability.Lemma4AdaptiveWalshEnergy

import SimonDCP.Probability.Lemma4AdaptiveWalshEnergy

/-!
# A bounded-fibre route for the adaptive Walsh mismatch

`Lemma4AdaptiveWalshEnergy` identifies the exact remaining decoder term as an
adaptive off-diagonal correlation of fixed hidden states.  This file gives a
deterministic way to control that term without asserting independence: bound
the number of hidden states compatible with each complete measured
transcript.

For one transcript, every compatible hidden state contributes a real sign
`+1` or `-1`.  Cauchy--Schwarz therefore bounds the squared signed sum by the
square of the compatible-hidden-state fibre size.  If every fibre has size at
most `K`, the total Walsh mismatch is at most `K` times the already controlled
diagonal common-path energy.  Combining this with the Step-2 energy theorem
gives a concrete conditional decoder bound.

This is a sufficient condition, not a claim that the paper supplies a small
`K`.  The universal bound is `K = Fintype.card Hidden`, which may be
exponential.  Any useful application must prove a polynomial bound for the
fully conditioned complete-transcript fibres or exploit cancellation through
the sharper off-diagonal theorem.
-/

namespace SimonDCP.Probability.Lemma4AdaptiveWalshFibre

open scoped BigOperators

open SimonDCP.Probability.LemmaThreePaperPathBridge
open SimonDCP.Probability.Lemma4AdaptiveWalshEnergy
open SimonDCP.Probability.Lemma4PaperDecoder

noncomputable section

variable {Hidden Y D W S Low : Type*}

variable [Fintype Hidden] [Fintype Y] [Fintype D] [Fintype W] [Fintype S]
  [Fintype Low]
  [DecidableEq Y] [DecidableEq D] [DecidableEq W] [DecidableEq S]

/-- Hidden states surviving all filters and producing one complete measured
transcript. -/
noncomputable def paperCompatibleHiddenFibre
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) : Finset Hidden := by
  classical
  exact Finset.univ.filter fun hidden =>
    paperCompatible model transcript hidden

/-- Cardinality of a complete-transcript compatible-hidden-state fibre. -/
noncomputable def paperCompatibleHiddenCount
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) : Nat :=
  (paperCompatibleHiddenFibre model transcript).card

/-- The complete measured transcript separates compatible hidden states: no
two distinct hidden states survive with exactly the same full record. -/
def PaperCompleteTranscriptSeparatesHidden
    (model : PaperStepSevenModel Hidden Y D W S) : Prop :=
  forall transcript left right,
    paperCompatible model transcript left ->
    paperCompatible model transcript right ->
    left = right

omit [Fintype Y] [Fintype D] [Fintype W] [Fintype S] [DecidableEq D] in
/-- Separation by the complete transcript makes every compatible hidden-state
fibre a subsingleton. -/
theorem paperCompatibleHiddenCount_le_one_of_separatesHidden
    (model : PaperStepSevenModel Hidden Y D W S)
    (hSeparates : PaperCompleteTranscriptSeparatesHidden model)
    (transcript : PaperMeasuredTranscript Y D W S) :
    paperCompatibleHiddenCount model transcript <= 1 := by
  classical
  unfold paperCompatibleHiddenCount
  apply Finset.card_le_one.mpr
  intro left hLeft right hRight
  apply hSeparates transcript left right
  · simpa [paperCompatibleHiddenFibre] using hLeft
  · simpa [paperCompatibleHiddenFibre] using hRight

omit [Fintype Y] [Fintype D] [Fintype W] [Fintype S] [DecidableEq D] in
/-- The complete-transcript fibre is always bounded by the ambient hidden
state space.  This universal estimate need not be polynomial. -/
theorem paperCompatibleHiddenFibre_card_le
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) :
    paperCompatibleHiddenCount model transcript <= Fintype.card Hidden := by
  classical
  unfold paperCompatibleHiddenCount paperCompatibleHiddenFibre
  exact Finset.card_filter_le _ _

omit [Fintype Y] [Fintype D] [Fintype W] [Fintype S] [DecidableEq D] in
/-- Squaring removes the branch and Walsh signs: the sum of the individual
squared contributions is exactly the compatible fibre cardinality. -/
theorem sum_sq_paperWalshDifferenceContribution_eq_fibreCount
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) :
    (∑ hidden : Hidden,
      (paperWalshDifferenceContribution model transcript hidden) ^ 2) =
      (paperCompatibleHiddenCount model transcript : Real) := by
  classical
  unfold paperCompatibleHiddenCount paperCompatibleHiddenFibre
  calc
    (∑ hidden : Hidden,
        (paperWalshDifferenceContribution model transcript hidden) ^ 2) =
      ∑ hidden : Hidden,
        if paperCompatible model transcript hidden then (1 : Real) else 0 := by
      apply Finset.sum_congr rfl
      intro hidden _
      by_cases hCompatible : paperCompatible model transcript hidden
      · cases hBranch : model.hStarOf hidden transcript.d <;>
          cases hWalsh : model.walshPhase hidden transcript.d <;>
            simp [paperWalshDifferenceContribution, hCompatible, hBranch,
              hWalsh, realPhaseSign]
      · simp [paperWalshDifferenceContribution, hCompatible]
    _ = ((Finset.univ.filter fun hidden : Hidden =>
        paperCompatible model transcript hidden).card : Real) := by
      simp

omit [Fintype Y] [Fintype D] [Fintype W] [Fintype S] [DecidableEq D] in
/-- The adaptive signed sum can be restricted to the compatible hidden-state
fibre because every contribution outside it is zero. -/
theorem sum_paperWalshDifferenceContribution_eq_sum_fibre
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) :
    (∑ hidden : Hidden,
      paperWalshDifferenceContribution model transcript hidden) =
      ∑ hidden ∈ paperCompatibleHiddenFibre model transcript,
        paperWalshDifferenceContribution model transcript hidden := by
  classical
  unfold paperCompatibleHiddenFibre
  rw [Finset.sum_filter]
  apply Finset.sum_congr rfl
  intro hidden _
  by_cases hCompatible : paperCompatible model transcript hidden <;>
    simp [paperWalshDifferenceContribution, hCompatible]

omit [Fintype Y] [Fintype D] [Fintype W] [Fintype S] [DecidableEq D] in
/-- Pointwise Cauchy bound: the squared Walsh-signed branch difference is at
most the square of the fully conditioned compatible-hidden-state fibre size. -/
theorem sum_paperWalshDifferenceContribution_sq_le_fibreCount_sq
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) :
    (∑ hidden : Hidden,
      paperWalshDifferenceContribution model transcript hidden) ^ 2 <=
      (paperCompatibleHiddenCount model transcript : Real) ^ 2 := by
  classical
  rw [sum_paperWalshDifferenceContribution_eq_sum_fibre]
  have hCauchy := sq_sum_le_card_mul_sum_sq
    (s := paperCompatibleHiddenFibre model transcript)
    (f := fun hidden =>
      paperWalshDifferenceContribution model transcript hidden)
  calc
    (∑ hidden ∈ paperCompatibleHiddenFibre model transcript,
        paperWalshDifferenceContribution model transcript hidden) ^ 2 <=
      ((paperCompatibleHiddenFibre model transcript).card : Real) *
        ∑ hidden ∈ paperCompatibleHiddenFibre model transcript,
          (paperWalshDifferenceContribution model transcript hidden) ^ 2 :=
      hCauchy
    _ = (paperCompatibleHiddenCount model transcript : Real) ^ 2 := by
      have hSquares :
          (∑ hidden ∈ paperCompatibleHiddenFibre model transcript,
            (paperWalshDifferenceContribution model transcript hidden) ^ 2) =
            (paperCompatibleHiddenCount model transcript : Real) := by
        unfold paperCompatibleHiddenCount
        calc
          (∑ hidden ∈ paperCompatibleHiddenFibre model transcript,
              (paperWalshDifferenceContribution model transcript hidden) ^ 2) =
            ∑ _hidden ∈ paperCompatibleHiddenFibre model transcript,
              (1 : Real) := by
              apply Finset.sum_congr rfl
              intro hidden hHidden
              have hCompatible : paperCompatible model transcript hidden := by
                simpa [paperCompatibleHiddenFibre] using hHidden
              cases hBranch : model.hStarOf hidden transcript.d <;>
                cases hWalsh : model.walshPhase hidden transcript.d <;>
                  simp [paperWalshDifferenceContribution, hCompatible,
                    hBranch, hWalsh, realPhaseSign]
          _ = ((paperCompatibleHiddenFibre model transcript).card : Real) := by
            simp
      rw [hSquares]
      unfold paperCompatibleHiddenCount
      ring

/-- The exact paper-facing Walsh mismatch is bounded by the weighted squared
complete-transcript fibre sizes. -/
theorem paperWalshMismatchEnergy_le_sum_weight_mul_fibreCount_sq
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) :
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude <=
      ∑ transcript,
        paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
            transcript *
          (paperCompatibleHiddenCount model transcript : Real) ^ 2 := by
  classical
  unfold paperWalshMismatchEnergy
  apply Finset.sum_le_sum
  intro transcript _
  rw [paperWalshSignedBranchCount_true_sub_false_eq_sum_contribution]
  unfold paperWalshEnergyWeight
  exact mul_le_mul_of_nonneg_left
    (sum_paperWalshDifferenceContribution_sq_le_fibreCount_sq
      model transcript)
    (Complex.normSq_nonneg _)

omit [DecidableEq D] in
/-- The weighted first moment of the complete-transcript fibre sizes is
exactly the compatible common-path diagonal energy. -/
theorem sum_weight_mul_paperCompatibleHiddenCount_eq_pathEnergy
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) :
    (∑ transcript,
      paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
          transcript *
        (paperCompatibleHiddenCount model transcript : Real)) =
      ∑ path : PaperStepSevenPath model,
        paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
          path.transcript := by
  rw [← sum_paperWalshPairCorrelation_self_eq_pathEnergy
    (Low := Low) normalization model stepTwoAmplitude]
  classical
  unfold paperWalshPairCorrelation weightedAdaptivePairCorrelation
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro transcript _
  symm
  calc
    (∑ hidden,
        paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
            transcript *
          paperWalshDifferenceContribution model transcript hidden *
          paperWalshDifferenceContribution model transcript hidden) =
      paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
          transcript *
        ∑ hidden,
          (paperWalshDifferenceContribution model transcript hidden) ^ 2 := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro hidden _
      ring
    _ = paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
          transcript *
        (paperCompatibleHiddenCount model transcript : Real) := by
      rw [sum_sq_paperWalshDifferenceContribution_eq_fibreCount]

/-- A uniform bound `K` on every complete-transcript hidden fibre bounds the
full Walsh mismatch by `K` times the diagonal common-path energy.  No phase
independence or cancellation is used. -/
theorem paperWalshMismatchEnergy_le_fibreCard_mul_pathEnergy
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) (fibreCardBound : Nat)
    (hFibreCard : ∀ transcript,
      paperCompatibleHiddenCount model transcript <= fibreCardBound) :
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude <=
      (fibreCardBound : Real) *
        ∑ path : PaperStepSevenPath model,
          paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
            path.transcript := by
  calc
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude <=
      ∑ transcript,
        paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
            transcript *
          (paperCompatibleHiddenCount model transcript : Real) ^ 2 :=
      paperWalshMismatchEnergy_le_sum_weight_mul_fibreCount_sq
        normalization model stepTwoAmplitude
    _ <= ∑ transcript,
        paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
            transcript *
          ((fibreCardBound : Real) *
            (paperCompatibleHiddenCount model transcript : Real)) := by
      apply Finset.sum_le_sum
      intro transcript _
      apply mul_le_mul_of_nonneg_left
      · have hCount :
            (paperCompatibleHiddenCount model transcript : Real) <=
              (fibreCardBound : Real) := by
          exact_mod_cast hFibreCard transcript
        have hCountNonneg :
            0 <= (paperCompatibleHiddenCount model transcript : Real) := by
          positivity
        nlinarith
      · exact Complex.normSq_nonneg _
    _ = (fibreCardBound : Real) *
        ∑ transcript,
          paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
              transcript *
            (paperCompatibleHiddenCount model transcript : Real) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro transcript _
      ring
    _ = (fibreCardBound : Real) *
        ∑ path : PaperStepSevenPath model,
          paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
            path.transcript := by
      rw [sum_weight_mul_paperCompatibleHiddenCount_eq_pathEnergy]

/-- The always-available ambient-cardinality specialization.  It is sound but
may be exponentially weaker than the estimate needed by Lemma 4. -/
theorem paperWalshMismatchEnergy_le_card_hidden_mul_pathEnergy
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) :
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude <=
      (Fintype.card Hidden : Real) *
        ∑ path : PaperStepSevenPath model,
          paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
            path.transcript := by
  exact paperWalshMismatchEnergy_le_fibreCard_mul_pathEnergy
    normalization model stepTwoAmplitude (Fintype.card Hidden)
    (paperCompatibleHiddenFibre_card_le model)

/-- Combining the fibre estimate with the existing Step-2 diagonal-energy
bound gives an explicit Walsh mismatch budget. -/
theorem paperWalshMismatchEnergy_le_fibreCard_mul_normalizationBound
    [Nonempty D] [Nonempty Low]
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex)
    (fibreCardBound : Nat) (normalizationBound : Real)
    (hFibreCard : ∀ transcript,
      paperCompatibleHiddenCount model transcript <= fibreCardBound)
    (hNormalizationBound : ∀ transcript,
      Complex.normSq (normalization transcript) <= normalizationBound)
    (hNormalizationBoundNonneg : 0 <= normalizationBound)
    (hStepTwoEnergy :
      (∑ hidden : Hidden,
        Complex.normSq (stepTwoAmplitude (model.yOf hidden))) <= 1) :
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude <=
      (fibreCardBound : Real) *
        (normalizationBound * (Fintype.card Low : Real)⁻¹) := by
  calc
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude <=
      (fibreCardBound : Real) *
        ∑ path : PaperStepSevenPath model,
          paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
            path.transcript :=
      paperWalshMismatchEnergy_le_fibreCard_mul_pathEnergy
        normalization model stepTwoAmplitude fibreCardBound hFibreCard
    _ <= (fibreCardBound : Real) *
        (normalizationBound * (Fintype.card Low : Real)⁻¹) :=
      mul_le_mul_of_nonneg_left
        (sum_paperWalshEnergyWeight_le_normalizationBound_mul_inv_card_low
          normalization model stepTwoAmplitude normalizationBound
          hNormalizationBound hNormalizationBoundNonneg hStepTwoEnergy)
        (by positivity)

/-- Decoder-facing bounded-fibre repair.  A polynomially bounded compatible
hidden-state fibre and controlled transcript normalization give a directly
checkable Hadamard success bound. -/
theorem paper_decoder_success_ge_of_compatibleHiddenFibreCard
    [Nonempty D] [Nonempty Low]
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex)
    (fibreCardBound : Nat) (normalizationBound : Real)
    (hFibreCard : ∀ transcript,
      paperCompatibleHiddenCount model transcript <= fibreCardBound)
    (hNormalizationBound : ∀ transcript,
      Complex.normSq (normalization transcript) <= normalizationBound)
    (hNormalizationBoundNonneg : 0 <= normalizationBound)
    (hStepTwoEnergy :
      (∑ hidden : Hidden,
        Complex.normSq (stepTwoAmplitude (model.yOf hidden))) <= 1)
    (hNormalized :
      SimonDCP.Quantum.ApproximateReadout.pairedBranchMass
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript false)
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript true) = 1) :
    1 - ((fibreCardBound : Real) *
          (normalizationBound * (Fintype.card Low : Real)⁻¹)) / 2 <=
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
    ((fibreCardBound : Real) *
      (normalizationBound * (Fintype.card Low : Real)⁻¹)) hNormalized
  exact paperWalshMismatchEnergy_le_fibreCard_mul_normalizationBound
    normalization model stepTwoAmplitude fibreCardBound normalizationBound
    hFibreCard hNormalizationBound hNormalizationBoundNonneg hStepTwoEnergy

/-- If the complete transcript separates compatible hidden states, the
bounded-fibre decoder theorem has no multiplicity loss.  Establishing this
strong structural premise for the paper's experiment remains separate. -/
theorem paper_decoder_success_ge_of_completeTranscriptSeparatesHidden
    [Nonempty D] [Nonempty Low]
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) (normalizationBound : Real)
    (hSeparates : PaperCompleteTranscriptSeparatesHidden model)
    (hNormalizationBound : forall transcript,
      Complex.normSq (normalization transcript) <= normalizationBound)
    (hNormalizationBoundNonneg : 0 <= normalizationBound)
    (hStepTwoEnergy :
      (∑ hidden : Hidden,
        Complex.normSq (stepTwoAmplitude (model.yOf hidden))) <= 1)
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
  simpa using
    paper_decoder_success_ge_of_compatibleHiddenFibreCard
      (Low := Low) normalization model stepTwoAmplitude 1 normalizationBound
      (paperCompatibleHiddenCount_le_one_of_separatesHidden model hSeparates)
      hNormalizationBound hNormalizationBoundNonneg hStepTwoEnergy hNormalized

end

end SimonDCP.Probability.Lemma4AdaptiveWalshFibre

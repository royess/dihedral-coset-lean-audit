import SimonDCP.Probability.Lemma4AdaptiveWalshFibre

/-!
# A normalization-aware fibre repair for Lemma 4

The cancellation-free estimate in `Lemma4AdaptiveWalshFibre` loses the
maximum number of hidden states compatible with a complete measured
transcript.  The paper's own balls-in-bins mean suggests that this number can
be exponential, so bounding the fibre size and the transcript normalization
separately is too crude.

This file keeps those quantities together.  If

```text
  normSq(normalization(transcript)) * compatibleHiddenCount(transcript) <= B
```

for every complete transcript, then the squared fibre loss is cancelled by
the outcome-dependent normalization and the Walsh mismatch is at most
`B / card(Low)`.  No phase cancellation or pairwise-independence claim is
used.  For `B = 1`, the resulting Hadamard decoder succeeds with probability
at least `1 - 1 / (2 * card(Low))`.

The remaining paper-specific obligation is now precise: identify the actual
postmeasurement normalization and prove this product bound.  Merely knowing
that the state is normalized on average does not imply the pointwise premise.
-/

namespace SimonDCP.Probability.Lemma4AdaptiveWalshNormalizedFibre

open scoped BigOperators

open SimonDCP.Probability.LemmaThreePaperPathBridge
open SimonDCP.Probability.LemmaThreePaperPathEnergy
open SimonDCP.Probability.Lemma4AdaptiveWalshEnergy
open SimonDCP.Probability.Lemma4AdaptiveWalshFibre
open SimonDCP.Probability.Lemma4PaperDecoder
open SimonDCP.Quantum.ApproximateReadout

noncomputable section

variable {Hidden Y D W S Low : Type*}

variable [Fintype Hidden] [Fintype Y] [Fintype D] [Fintype W] [Fintype S]
  [Fintype Low]
  [DecidableEq Y] [DecidableEq D] [DecidableEq W] [DecidableEq S]

omit [DecidableEq D] in
/-- Regrouping complete transcripts by their compatible hidden states turns
the unnormalized count-weighted common amplitude into the surviving path
energy exactly. -/
theorem sum_normSq_common_mul_paperCompatibleHiddenCount_eq_pathEnergy
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) :
    (∑ transcript,
      Complex.normSq
          (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude transcript) *
        (paperCompatibleHiddenCount model transcript : Real)) =
      ∑ path : PaperStepSevenPath model,
        Complex.normSq
          (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude
            path.transcript) := by
  simpa [paperWalshEnergyWeight] using
    (sum_weight_mul_paperCompatibleHiddenCount_eq_pathEnergy
      (Low := Low) (fun _ => (1 : Complex)) model stepTwoAmplitude)

/-- Keeping normalization and fibre multiplicity coupled removes the
separate maximum-fibre loss. -/
theorem paperWalshMismatchEnergy_le_normalizedFibreWeight_mul_pathEnergy
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) (normalizedFibreWeightBound : Real)
    (hNormalizedFibreWeight : ∀ transcript,
      Complex.normSq (normalization transcript) *
          (paperCompatibleHiddenCount model transcript : Real) <=
        normalizedFibreWeightBound) :
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude <=
      normalizedFibreWeightBound *
        ∑ path : PaperStepSevenPath model,
          Complex.normSq
            (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude
              path.transcript) := by
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
        normalizedFibreWeightBound *
          (Complex.normSq
              (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude
                transcript) *
            (paperCompatibleHiddenCount model transcript : Real)) := by
      apply Finset.sum_le_sum
      intro transcript _
      calc
        paperWalshEnergyWeight (Low := Low) normalization stepTwoAmplitude
              transcript *
            (paperCompatibleHiddenCount model transcript : Real) ^ 2 =
          (Complex.normSq (normalization transcript) *
              (paperCompatibleHiddenCount model transcript : Real)) *
            (Complex.normSq
                (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude
                  transcript) *
              (paperCompatibleHiddenCount model transcript : Real)) := by
            rw [paperWalshEnergyWeight, Complex.normSq_mul]
            ring
        _ <= normalizedFibreWeightBound *
            (Complex.normSq
                (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude
                  transcript) *
              (paperCompatibleHiddenCount model transcript : Real)) :=
          mul_le_mul_of_nonneg_right
            (hNormalizedFibreWeight transcript)
            (mul_nonneg (Complex.normSq_nonneg _)
              (Nat.cast_nonneg _))
    _ = normalizedFibreWeightBound *
        ∑ transcript,
          Complex.normSq
              (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude
                transcript) *
            (paperCompatibleHiddenCount model transcript : Real) := by
      rw [Finset.mul_sum]
    _ = normalizedFibreWeightBound *
        ∑ path : PaperStepSevenPath model,
          Complex.normSq
            (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude
              path.transcript) := by
      rw [sum_normSq_common_mul_paperCompatibleHiddenCount_eq_pathEnergy]

/-- The Step-2 diagonal-energy estimate converts the coupled normalized-fibre
bound into the exact Walsh mismatch budget needed by the decoder. -/
theorem paperWalshMismatchEnergy_le_normalizedFibreWeight_mul_inv_card_low
    [Nonempty D] [Nonempty Low]
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) (normalizedFibreWeightBound : Real)
    (hNormalizedFibreWeight : ∀ transcript,
      Complex.normSq (normalization transcript) *
          (paperCompatibleHiddenCount model transcript : Real) <=
        normalizedFibreWeightBound)
    (hNormalizedFibreWeightBoundNonneg :
      0 <= normalizedFibreWeightBound)
    (hStepTwoEnergy :
      (∑ hidden : Hidden,
        Complex.normSq (stepTwoAmplitude (model.yOf hidden))) <= 1) :
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude <=
      normalizedFibreWeightBound * (Fintype.card Low : Real)⁻¹ := by
  calc
    paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude <=
      normalizedFibreWeightBound *
        ∑ path : PaperStepSevenPath model,
          Complex.normSq
            (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude
              path.transcript) :=
      paperWalshMismatchEnergy_le_normalizedFibreWeight_mul_pathEnergy
        normalization model stepTwoAmplitude normalizedFibreWeightBound
        hNormalizedFibreWeight
    _ <= normalizedFibreWeightBound * (Fintype.card Low : Real)⁻¹ :=
      mul_le_mul_of_nonneg_left
        (sum_normSq_paperCommonPathAmplitude_le_inv_card_low
          model stepTwoAmplitude hStepTwoEnergy)
        hNormalizedFibreWeightBoundNonneg

/-- Decoder-facing normalization-aware repair of Lemma 4.  This theorem can
remain strong even when every compatible-hidden-state fibre is exponential. -/
theorem paper_decoder_success_ge_of_normalizedFibreWeight
    [Nonempty D] [Nonempty Low]
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) (normalizedFibreWeightBound : Real)
    (hNormalizedFibreWeight : ∀ transcript,
      Complex.normSq (normalization transcript) *
          (paperCompatibleHiddenCount model transcript : Real) <=
        normalizedFibreWeightBound)
    (hNormalizedFibreWeightBoundNonneg :
      0 <= normalizedFibreWeightBound)
    (hStepTwoEnergy :
      (∑ hidden : Hidden,
        Complex.normSq (stepTwoAmplitude (model.yOf hidden))) <= 1)
    (hNormalized :
      pairedBranchMass
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript false)
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript true) = 1) :
    1 - (normalizedFibreWeightBound *
          (Fintype.card Low : Real)⁻¹) / 2 <=
      pairedCorrectMass
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript false)
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript true)
        model.secretBit := by
  apply paper_decoder_success_ge_of_walsh_mismatch_energy
    normalization model stepTwoAmplitude
    (normalizedFibreWeightBound * (Fintype.card Low : Real)⁻¹)
    hNormalized
  exact
    paperWalshMismatchEnergy_le_normalizedFibreWeight_mul_inv_card_low
      normalization model stepTwoAmplitude normalizedFibreWeightBound
      hNormalizedFibreWeight hNormalizedFibreWeightBoundNonneg hStepTwoEnergy

/-- Factor-one specialization: reciprocal-squared normalization of each
complete-transcript fibre gives the ideal `1 / card(Low)` mismatch scale. -/
theorem paper_decoder_success_ge_of_unit_normalizedFibreWeight
    [Nonempty D] [Nonempty Low]
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex)
    (hNormalizedFibreWeight : ∀ transcript,
      Complex.normSq (normalization transcript) *
          (paperCompatibleHiddenCount model transcript : Real) <= 1)
    (hStepTwoEnergy :
      (∑ hidden : Hidden,
        Complex.normSq (stepTwoAmplitude (model.yOf hidden))) <= 1)
    (hNormalized :
      pairedBranchMass
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript false)
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript true) = 1) :
    1 - (Fintype.card Low : Real)⁻¹ / 2 <=
      pairedCorrectMass
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript false)
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript true)
        model.secretBit := by
  simpa using
    paper_decoder_success_ge_of_normalizedFibreWeight
      (Low := Low) normalization model stepTwoAmplitude 1
      hNormalizedFibreWeight (by norm_num) hStepTwoEnergy hNormalized

/-- A directly recognizable sufficient condition: the squared magnitude of
the transcript normalization is at most the reciprocal of that transcript's
compatible-hidden-state fibre size.  Empty fibres cause no difficulty. -/
theorem paper_decoder_success_ge_of_reciprocal_fibre_normalization
    [Nonempty D] [Nonempty Low]
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex)
    (hReciprocalNormalization : ∀ transcript,
      Complex.normSq (normalization transcript) <=
        (paperCompatibleHiddenCount model transcript : Real)⁻¹)
    (hStepTwoEnergy :
      (∑ hidden : Hidden,
        Complex.normSq (stepTwoAmplitude (model.yOf hidden))) <= 1)
    (hNormalized :
      pairedBranchMass
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript false)
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript true) = 1) :
    1 - (Fintype.card Low : Real)⁻¹ / 2 <=
      pairedCorrectMass
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript false)
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript true)
        model.secretBit := by
  apply paper_decoder_success_ge_of_unit_normalizedFibreWeight
    normalization model stepTwoAmplitude _ hStepTwoEnergy hNormalized
  intro transcript
  by_cases hCount : paperCompatibleHiddenCount model transcript = 0
  · simp [hCount]
  · have hCountRealNe :
        (paperCompatibleHiddenCount model transcript : Real) ≠ 0 := by
      exact_mod_cast hCount
    calc
      Complex.normSq (normalization transcript) *
            (paperCompatibleHiddenCount model transcript : Real) <=
          (paperCompatibleHiddenCount model transcript : Real)⁻¹ *
            (paperCompatibleHiddenCount model transcript : Real) :=
        mul_le_mul_of_nonneg_right
          (hReciprocalNormalization transcript) (by positivity)
      _ = 1 := inv_mul_cancel₀ hCountRealNe

end

end SimonDCP.Probability.Lemma4AdaptiveWalshNormalizedFibre

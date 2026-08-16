import SimonDCP.Probability.Lemma4Decoder
import SimonDCP.Probability.LemmaThreePaperPathBridge

/-!
# Paper-path specialization of the Lemma 4 decoder

`LemmaThreePaperPathBridge` gives an exact finite coherent path model for the
complete measured transcript `M = (Y,D,W',S,h')`.  Within one transcript, the
two residual `hStar` branches have the same raw complex path amplitude; only
their real signed path counts differ.

This file applies the additive Hadamard decoder directly to that
factorization.  It proves that the total wrong-branch mismatch energy is
exactly

```text
sum_M normSq(normalization(M) * commonAmplitude(M)) *
  (signedCount(M,1) - (-1)^secretBit * signedCount(M,0))^2.
```

Thus this paper-facing model needs neither a separately postulated common
coefficient family nor a lower bound on either branch amplitude.  What remains
is the substantive probabilistic obligation: bound the displayed signed-count
energy in the actual conditioned experiment, and identify the model's branch
amplitudes with the circuit coordinates.  The normalization is allowed to
depend on the complete transcript, but is common to its two `hStar` branches.
-/

namespace SimonDCP.Probability.Lemma4PaperDecoder

open scoped BigOperators

open SimonDCP.Probability.LemmaThreePaperPathBridge
open SimonDCP.Probability.LemmaThreePathRefinement
open SimonDCP.Probability.LemmaThreeTranscriptModel
open SimonDCP.Quantum.ApproximateReadout

noncomputable section

variable {Hidden Y D W S Low : Type*}

variable [Fintype Hidden] [Fintype Y] [Fintype D] [Fintype W] [Fintype S]
  [Fintype Low]
  [DecidableEq Y] [DecidableEq D] [DecidableEq W] [DecidableEq S]

/-- The real signed number of compatible paths in one paper transcript and
residual `hStar` branch. -/
def paperSignedBranchCount
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) (hStar : Bool) : Real :=
  (paperTPlus model transcript hStar : Real) -
    (paperTMinus model transcript hStar : Real)

/-- The real form of the relative phase that the final Hadamard should read. -/
def targetSignReal (dBit : Bool) : Real :=
  (-1 : Real) ^ dBit.toNat

theorem targetSign_eq_targetSignReal (dBit : Bool) :
    targetSign dBit = (targetSignReal dBit : Complex) := by
  cases dBit <;> norm_num [targetSign, targetSignReal]

/-- The path sign coming only from the measured Walsh mask, before the
secret-bit phase is applied. -/
def paperWalshPositive
    (model : PaperStepSevenModel Hidden Y D W S)
    (path : PaperStepSevenPath model) : Bool :=
  !(model.walshPhase path.hidden path.transcript.d)

/-- The signed compatible-path count with only the Walsh sign retained. -/
def paperWalshSignedBranchCount
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) (hStar : Bool) : Real :=
  signedPathCountReal
    (fun path : PaperStepSevenPath model => path.transcript)
    (paperBranch model) (paperWalshPositive model) transcript hStar

/-- The branch-constant secret phase reconstructed from `h xor hStar = h'`. -/
def paperBranchSecretPhase
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) (hStar : Bool) : Bool :=
  (transcript.hPrime && model.secretBit).xor (hStar && model.secretBit)

/-- On every compatible path, the full Step-4/Step-7 sign is the Walsh sign
times a bit depending only on the complete transcript and `hStar` branch. -/
theorem paperPositive_eq_branchSecretPhase_mul_walsh
    (model : PaperStepSevenModel Hidden Y D W S)
    (path : PaperStepSevenPath model) :
    paperPositive model path =
      if paperBranchSecretPhase model path.transcript
          (paperBranch model path) then
        !(paperWalshPositive model path)
      else
        paperWalshPositive model path := by
  have hXor := hiddenBit_xor_branch_eq_hPrime model path
  unfold paperPositive paperWalshPositive paperBranchSecretPhase
  generalize model.hOf path.hidden = hiddenBit at hXor ⊢
  generalize paperBranch model path = branch at hXor ⊢
  generalize path.transcript.hPrime = hPrime at hXor ⊢
  generalize model.secretBit = secretBit at ⊢
  generalize model.walshPhase path.hidden path.transcript.d = walshBit at ⊢
  cases hiddenBit <;> cases branch <;> cases hPrime <;>
    cases secretBit <;> cases walshBit <;> simp_all

/-- Factoring the branch-constant secret phase out of the finite signed count
leaves precisely the Walsh-only signed count. -/
theorem paperSignedBranchCount_eq_targetSign_mul_walshSignedCount
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) (hStar : Bool) :
    paperSignedBranchCount model transcript hStar =
      targetSignReal (paperBranchSecretPhase model transcript hStar) *
        paperWalshSignedBranchCount model transcript hStar := by
  classical
  have hOnFibre (path : PaperStepSevenPath model)
      (hPath : path ∈ transcriptBranchFibre
        (fun path : PaperStepSevenPath model => path.transcript)
        (paperBranch model) transcript hStar) :
      paperPositive model path =
        if paperBranchSecretPhase model transcript hStar then
          !(paperWalshPositive model path)
        else
          paperWalshPositive model path := by
    have hKey := (Finset.mem_filter.mp hPath).2
    simpa [transcriptBranchFibre, hKey.1, hKey.2] using
      paperPositive_eq_branchSecretPhase_mul_walsh model path
  cases hPhase : paperBranchSecretPhase model transcript hStar
  · have hPositive :
        paperTPlus model transcript hStar =
          positivePathCount
            (fun path : PaperStepSevenPath model => path.transcript)
            (paperBranch model) (paperWalshPositive model) transcript hStar := by
      unfold paperTPlus positivePathCount
      apply congrArg Finset.card
      apply Finset.filter_congr
      intro path hPath
      have hSign := hOnFibre path hPath
      simp [hPhase] at hSign
      rw [hSign]
    have hNegative :
        paperTMinus model transcript hStar =
          negativePathCount
            (fun path : PaperStepSevenPath model => path.transcript)
            (paperBranch model) (paperWalshPositive model) transcript hStar := by
      unfold paperTMinus negativePathCount
      apply congrArg Finset.card
      apply Finset.filter_congr
      intro path hPath
      have hSign := hOnFibre path hPath
      simp [hPhase] at hSign
      rw [hSign]
    simp [paperSignedBranchCount, paperWalshSignedBranchCount,
      signedPathCountReal, targetSignReal, hPositive, hNegative]
  · have hPositive :
        paperTPlus model transcript hStar =
          negativePathCount
            (fun path : PaperStepSevenPath model => path.transcript)
            (paperBranch model) (paperWalshPositive model) transcript hStar := by
      unfold paperTPlus negativePathCount
      apply congrArg Finset.card
      apply Finset.filter_congr
      intro path hPath
      have hSign := hOnFibre path hPath
      simp [hPhase] at hSign
      rw [hSign]
      simp
    have hNegative :
        paperTMinus model transcript hStar =
          positivePathCount
            (fun path : PaperStepSevenPath model => path.transcript)
            (paperBranch model) (paperWalshPositive model) transcript hStar := by
      unfold paperTMinus positivePathCount
      apply congrArg Finset.card
      apply Finset.filter_congr
      intro path hPath
      have hSign := hOnFibre path hPath
      simp [hPhase] at hSign
      rw [hSign]
      simp
    simp [paperSignedBranchCount, paperWalshSignedBranchCount,
      signedPathCountReal, targetSignReal, hPositive, hNegative]

/-- The exact paper branch factorization, stated using the signed-count API
used below. -/
theorem paperBranchAmplitude_eq_common_mul_signedCount
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex)
    (transcript : PaperMeasuredTranscript Y D W S) (hStar : Bool) :
    paperBranchAmplitude (Low := Low) model stepTwoAmplitude transcript hStar =
      paperCommonPathAmplitude (Low := Low) stepTwoAmplitude transcript *
        (paperSignedBranchCount model transcript hStar : Complex) := by
  simpa [paperSignedBranchCount] using
    paperBranchAmplitude_eq_tPlus_sub_tMinus
      (Low := Low) model stepTwoAmplitude transcript hStar

/-- Multiply the raw path-model branch by any transcript-dependent common
normalization.  This can absorb postselection and transcript probability, but
must not depend on `hStar`. -/
def scaledPaperBranchAmplitude
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex)
    (transcript : PaperMeasuredTranscript Y D W S) (hStar : Bool) : Complex :=
  normalization transcript *
    paperBranchAmplitude (Low := Low) model stepTwoAmplitude transcript hStar

/-- The exact signed-count energy needed by the final Hadamard decoder. -/
def paperSignedMismatchEnergy
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) : Real :=
  ∑ transcript,
    Complex.normSq
        (normalization transcript *
          paperCommonPathAmplitude (Low := Low) stepTwoAmplitude transcript) *
      (paperSignedBranchCount model transcript true -
          targetSignReal model.secretBit *
            paperSignedBranchCount model transcript false) ^ 2

/-- After removing the branch-constant secret phase, the relevant quantity is
just the squared difference of the two Walsh-signed branch counts. -/
def paperWalshMismatchEnergy
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) : Real :=
  ∑ transcript,
    Complex.normSq
        (normalization transcript *
          paperCommonPathAmplitude (Low := Low) stepTwoAmplitude transcript) *
      (paperWalshSignedBranchCount model transcript true -
        paperWalshSignedBranchCount model transcript false) ^ 2

/-- The secret-bit and measured-`hPrime` signs have unit magnitude and cancel
from the squared decoder mismatch.  The remaining energy is entirely a
Walsh-signed population comparison between the two `hStar` branches. -/
theorem paperSignedMismatchEnergy_eq_paperWalshMismatchEnergy
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) :
    paperSignedMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude =
      paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude := by
  classical
  unfold paperSignedMismatchEnergy paperWalshMismatchEnergy
  apply Finset.sum_congr rfl
  intro transcript _
  rw [paperSignedBranchCount_eq_targetSign_mul_walshSignedCount,
    paperSignedBranchCount_eq_targetSign_mul_walshSignedCount]
  apply congrArg (fun value : Real =>
    Complex.normSq
        (normalization transcript *
          paperCommonPathAmplitude (Low := Low) stepTwoAmplitude transcript) *
      value)
  cases hSecret : model.secretBit <;>
    cases hPrime : transcript.hPrime <;>
      norm_num [paperBranchSecretPhase, targetSignReal, hSecret, hPrime]
  all_goals ring

/-- In the paper-facing finite path model, the decoder mismatch is exactly the
weighted signed-count mismatch.  No Cauchy--Schwarz or coefficient-energy
upper bound is used in this identity. -/
theorem pairedMismatchEnergy_scaledPaperBranchAmplitude_eq
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) :
    pairedMismatchEnergy
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript false)
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript true)
        model.secretBit =
      paperSignedMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude := by
  classical
  unfold pairedMismatchEnergy paperSignedMismatchEnergy
  apply Finset.sum_congr rfl
  intro transcript _
  simp only [scaledPaperBranchAmplitude]
  rw [paperBranchAmplitude_eq_common_mul_signedCount,
    paperBranchAmplitude_eq_common_mul_signedCount,
    targetSign_eq_targetSignReal]
  rw [show
    normalization transcript *
          (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude transcript *
            (paperSignedBranchCount model transcript true : Complex)) -
        (targetSignReal model.secretBit : Complex) *
          (normalization transcript *
            (paperCommonPathAmplitude (Low := Low) stepTwoAmplitude transcript *
              (paperSignedBranchCount model transcript false : Complex))) =
      (normalization transcript *
          paperCommonPathAmplitude (Low := Low) stepTwoAmplitude transcript) *
        ((paperSignedBranchCount model transcript true -
          targetSignReal model.secretBit *
            paperSignedBranchCount model transcript false : Real) : Complex) by
      push_cast
      ring]
  rw [Complex.normSq_mul, Complex.normSq_ofReal]
  ring

/-- Preferred form of the exact identity: after the circuit's deterministic
phase transfer is simplified, only the Walsh-signed branch-count difference
remains. -/
theorem pairedMismatchEnergy_scaledPaperBranchAmplitude_eq_walsh
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) :
    pairedMismatchEnergy
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript false)
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript true)
        model.secretBit =
      paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude := by
  rw [pairedMismatchEnergy_scaledPaperBranchAmplitude_eq,
    paperSignedMismatchEnergy_eq_paperWalshMismatchEnergy]

/-- Decoder-facing replacement for the paper's multiplicative Lemma 4 claim.
If the transcript-labelled pair of branches is normalized and its exact
signed-count mismatch energy is at most `budget`, a Hadamard reads the secret
bit with probability at least `1 - budget / 2`. -/
theorem paper_decoder_success_ge_of_signed_mismatch_energy
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) (budget : Real)
    (hNormalized :
      pairedBranchMass
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript false)
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript true) = 1)
    (hBudget :
      paperSignedMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude <= budget) :
    1 - budget / 2 <=
      pairedCorrectMass
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript false)
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript true)
        model.secretBit := by
  apply pairedCorrectMass_ge_of_mismatchEnergy_le _ _ model.secretBit budget
    hNormalized
  rw [pairedMismatchEnergy_scaledPaperBranchAmplitude_eq]
  exact hBudget

/-- The same decoder theorem with the exact Walsh-only energy premise.  This
is the paper-facing target for any corrected conditional second-moment or
orthogonality argument. -/
theorem paper_decoder_success_ge_of_walsh_mismatch_energy
    (normalization : PaperMeasuredTranscript Y D W S -> Complex)
    (model : PaperStepSevenModel Hidden Y D W S)
    (stepTwoAmplitude : Y -> Complex) (budget : Real)
    (hNormalized :
      pairedBranchMass
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript false)
          (fun transcript =>
            scaledPaperBranchAmplitude (Low := Low) normalization model
              stepTwoAmplitude transcript true) = 1)
    (hBudget :
      paperWalshMismatchEnergy (Low := Low) normalization model
        stepTwoAmplitude <= budget) :
    1 - budget / 2 <=
      pairedCorrectMass
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript false)
        (fun transcript =>
          scaledPaperBranchAmplitude (Low := Low) normalization model
            stepTwoAmplitude transcript true)
        model.secretBit := by
  apply pairedCorrectMass_ge_of_mismatchEnergy_le _ _ model.secretBit budget
    hNormalized
  rw [pairedMismatchEnergy_scaledPaperBranchAmplitude_eq_walsh]
  exact hBudget

end

end SimonDCP.Probability.Lemma4PaperDecoder

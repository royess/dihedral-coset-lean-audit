import SimonDCP.Probability.Lemma4AdaptiveWalshFibre
import SimonDCP.Probability.Lemma4Parameters
import SimonDCP.Probability.LemmaThreeCoherentFibreObstruction

/-!
# Counting obstruction for complete-transcript Lemma 4 fibres

`Lemma4AdaptiveWalshFibre` gives a cancellation-free decoder bound when at
most `K` hidden states are compatible with each complete measured transcript.
This file records the matching pigeonhole constraint on `K`.

Compatible hidden states over all complete transcripts are exactly the fine
paper paths.  Consequently their fibre cardinalities sum to the total number
of compatible paths.  A uniform bound `K` can therefore hold only if

```text
#compatible paths <= #complete transcripts * K.
```

The squared fibre counts also obey the usual collision lower bound.  These
facts do not by themselves refute a small-fibre repair: later filters may make
the compatible path set sparse, and the outcome-dependent normalization can
matter.  They do show that injectivity or polynomial multiplicity cannot be
asserted without accounting for every surviving hidden path.
-/

namespace SimonDCP.Probability.Lemma4AdaptiveWalshFibreObstruction

open scoped BigOperators

open SimonDCP.Probability.LemmaThreeCoherentFibreObstruction
open SimonDCP.Probability.LemmaThreePaperPathBridge
open SimonDCP.Probability.LemmaThreeTranscriptModel
open SimonDCP.Probability.Lemma4AdaptiveWalshFibre
open SimonDCP.Probability.Lemma4Parameters

variable {Hidden Y D W S : Type*}

variable [Fintype Hidden] [Fintype Y] [Fintype D] [Fintype W] [Fintype S]
  [DecidableEq Y] [DecidableEq D] [DecidableEq W] [DecidableEq S]

/-- A compatible hidden state determines, and is determined by, a compatible
fine path lying over the fixed complete transcript. -/
def paperCompatibleHiddenEquivPathFibre
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) :
    {hidden : Hidden // paperCompatible model transcript hidden} ≃
      {path : PaperStepSevenPath model // path.transcript = transcript} where
  toFun hidden :=
    ⟨⟨(transcript, hidden.1), hidden.2⟩, rfl⟩
  invFun path := by
    refine ⟨path.1.hidden, ?_⟩
    simpa only [path.2] using path.1.compatible_property
  left_inv hidden := by
    apply Subtype.ext
    rfl
  right_inv path := by
    apply Subtype.ext
    apply Subtype.ext
    exact Prod.ext path.2.symm rfl

/-- The compatible-hidden-state count is the cardinality of the fibre of the
fine-path transcript map. -/
theorem paperCompatibleHiddenCount_eq_fibreCard
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S) :
    paperCompatibleHiddenCount model transcript =
      fibreCard
        (fun path : PaperStepSevenPath model => path.transcript) transcript := by
  classical
  unfold paperCompatibleHiddenCount paperCompatibleHiddenFibre fibreCard
  rw [← Fintype.card_subtype, ← Fintype.card_subtype]
  exact Fintype.card_congr
    (paperCompatibleHiddenEquivPathFibre model transcript)

/-- Summing complete-transcript compatible-hidden-state cardinalities counts
every compatible fine path exactly once. -/
theorem sum_paperCompatibleHiddenCount_eq_card_paths
    (model : PaperStepSevenModel Hidden Y D W S) :
    (∑ transcript,
      paperCompatibleHiddenCount model transcript) =
      Fintype.card (PaperStepSevenPath model) := by
  classical
  simp_rw [paperCompatibleHiddenCount_eq_fibreCard]
  exact sum_fibreCard
    (fun path : PaperStepSevenPath model => path.transcript)

/-- Any uniform complete-transcript fibre bound must cover the entire
compatible path space. -/
theorem card_paths_le_card_transcript_mul_fibreCardBound
    (model : PaperStepSevenModel Hidden Y D W S)
    (fibreCardBound : Nat)
    (hFibreCard : ∀ transcript,
      paperCompatibleHiddenCount model transcript <= fibreCardBound) :
    Fintype.card (PaperStepSevenPath model) <=
      Fintype.card (PaperMeasuredTranscript Y D W S) * fibreCardBound := by
  rw [← sum_paperCompatibleHiddenCount_eq_card_paths model]
  calc
    (∑ transcript,
        paperCompatibleHiddenCount model transcript) <=
      ∑ _transcript : PaperMeasuredTranscript Y D W S,
        fibreCardBound :=
      Finset.sum_le_sum fun transcript _ => hFibreCard transcript
    _ = Fintype.card (PaperMeasuredTranscript Y D W S) *
        fibreCardBound := by simp

/-! ## Relating the paper's balls-in-bins mean to the fibre bound -/

omit [Fintype Y] [Fintype D] [Fintype W] [Fintype S] [DecidableEq D] in
/-- Any finite family of hidden states all compatible with one complete
transcript is a subfibre of that transcript's full compatible-hidden-state
fibre.  In a concrete paper instantiation, `bin` can represent the state
portions in one fixed `A_(g_a)` and low-residue bin. -/
theorem card_compatibleHiddenBin_le_count
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S)
    (bin : Finset Hidden)
    (hCompatible : ∀ hidden ∈ bin,
      paperCompatible model transcript hidden) :
    bin.card <= paperCompatibleHiddenCount model transcript := by
  classical
  unfold paperCompatibleHiddenCount paperCompatibleHiddenFibre
  apply Finset.card_le_card
  intro hidden hHidden
  simp only [Finset.mem_filter, Finset.mem_univ, true_and]
  exact hCompatible hidden hHidden

omit [Fintype Y] [Fintype D] [Fintype W] [Fintype S] [DecidableEq D] in
/-- If a compatible sub-bin has count within `error` of a real mean, then the
mean cannot exceed the complete-transcript fibre bound by more than `error`.
This is the exact deterministic implication needed to compare the paper's
balls-in-bins calculation with the cancellation-free Lemma 4 route. -/
theorem mean_le_fibreCardBound_add_error_of_compatibleHiddenBin
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S)
    (bin : Finset Hidden) (mean error : Real) (fibreCardBound : Nat)
    (hCompatible : ∀ hidden ∈ bin,
      paperCompatible model transcript hidden)
    (hDeviation : abs ((bin.card : Real) - mean) <= error)
    (hFibreCard :
      paperCompatibleHiddenCount model transcript <= fibreCardBound) :
    mean <= (fibreCardBound : Real) + error := by
  have hLower : mean - error <= (bin.card : Real) := by
    have := (abs_le.mp hDeviation).1
    linarith
  have hBinCard : (bin.card : Real) <= fibreCardBound := by
    exact_mod_cast
      (card_compatibleHiddenBin_le_count model transcript bin hCompatible |>.trans
        hFibreCard)
  linarith

omit [Fintype Y] [Fintype D] [Fintype W] [Fintype S] [DecidableEq D] in
/-- Direct specialization to the page-13 mean
`mu = 2 ^ meanExponent(c,n,logN,faultLoss)`.  It remains an application
obligation to identify the paper's actual bin with `bin` and prove
`hCompatible`; those premises are not inferred from the prose sketch. -/
theorem paperMean_le_fibreCardBound_add_error_of_compatibleHiddenBin
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S)
    (bin : Finset Hidden) (c n logN faultLoss error : Real)
    (fibreCardBound : Nat)
    (hCompatible : ∀ hidden ∈ bin,
      paperCompatible model transcript hidden)
    (hDeviation :
      abs ((bin.card : Real) -
        (2 : Real) ^ meanExponent c n logN faultLoss) <= error)
    (hFibreCard :
      paperCompatibleHiddenCount model transcript <= fibreCardBound) :
    (2 : Real) ^ meanExponent c n logN faultLoss <=
      (fibreCardBound : Real) + error := by
  exact mean_le_fibreCardBound_add_error_of_compatibleHiddenBin
    model transcript bin
      ((2 : Real) ^ meanExponent c n logN faultLoss) error fibreCardBound
      hCompatible hDeviation hFibreCard

omit [Fintype Y] [Fintype D] [Fintype W] [Fintype S] [DecidableEq D] in
/-- If the paper's bin deviation is at most half of its displayed mean, the
complete-transcript fibre bound is at least half that mean. -/
theorem half_paperMean_le_fibreCardBound_of_compatibleHiddenBin
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S)
    (bin : Finset Hidden) (c n logN faultLoss error : Real)
    (fibreCardBound : Nat)
    (hCompatible : ∀ hidden ∈ bin,
      paperCompatible model transcript hidden)
    (hDeviation :
      abs ((bin.card : Real) -
        (2 : Real) ^ meanExponent c n logN faultLoss) <= error)
    (hError :
      error <= (2 : Real) ^ meanExponent c n logN faultLoss / 2)
    (hFibreCard :
      paperCompatibleHiddenCount model transcript <= fibreCardBound) :
    (2 : Real) ^ meanExponent c n logN faultLoss / 2 <=
      (fibreCardBound : Real) := by
  have hMean :=
    paperMean_le_fibreCardBound_add_error_of_compatibleHiddenBin
      model transcript bin c n logN faultLoss error fibreCardBound
      hCompatible hDeviation hFibreCard
  linarith

omit [Fintype Y] [Fintype D] [Fintype W] [Fintype S] [DecidableEq D] in
/-- At `c = 12`, the same parameter budget used by the corrected deviation
calculation makes the paper's displayed mean at least `2 ^ (9*n)`.  Therefore
a half-relative-error compatible bin forces an exponential
complete-transcript fibre. -/
theorem c12_nineNMean_half_le_fibreCardBound
    (model : PaperStepSevenModel Hidden Y D W S)
    (transcript : PaperMeasuredTranscript Y D W S)
    (bin : Finset Hidden) (n logN faultLoss error : Real)
    (fibreCardBound : Nat)
    (hBudget : faultLoss + 12 * logN <= n)
    (hCompatible : ∀ hidden ∈ bin,
      paperCompatible model transcript hidden)
    (hDeviation :
      abs ((bin.card : Real) -
        (2 : Real) ^ meanExponent 12 n logN faultLoss) <= error)
    (hError :
      error <= (2 : Real) ^ meanExponent 12 n logN faultLoss / 2)
    (hFibreCard :
      paperCompatibleHiddenCount model transcript <= fibreCardBound) :
    (2 : Real) ^ (9 * n) / 2 <= (fibreCardBound : Real) := by
  have hExponent : 9 * n <= meanExponent 12 n logN faultLoss := by
    unfold meanExponent
    linarith
  have hPower :
      (2 : Real) ^ (9 * n) <=
        (2 : Real) ^ meanExponent 12 n logN faultLoss :=
    Real.rpow_le_rpow_of_exponent_le (by norm_num) hExponent
  have hHalf :=
    half_paperMean_le_fibreCardBound_of_compatibleHiddenBin
      model transcript bin 12 n logN faultLoss error fibreCardBound
      hCompatible hDeviation hError hFibreCard
  linarith

/-- Pigeonhole lower bound for the squared complete-transcript fibre sizes.
A small maximum fibre therefore requires enough complete transcript labels
relative to the number of compatible paths. -/
theorem card_paths_sq_div_card_transcript_le_sum_sq_fibreCount
    [Nonempty (PaperMeasuredTranscript Y D W S)]
    (model : PaperStepSevenModel Hidden Y D W S) :
    (Fintype.card (PaperStepSevenPath model) : Real) ^ 2 /
        Fintype.card (PaperMeasuredTranscript Y D W S) <=
      ∑ transcript,
        (paperCompatibleHiddenCount model transcript : Real) ^ 2 := by
  simpa only [paperCompatibleHiddenCount_eq_fibreCard] using
    (card_sq_div_le_sum_sq_fibreCard
      (fun path : PaperStepSevenPath model => path.transcript))

/-- Power-of-two, denominator-free form of the uniform-fibre obstruction.
It is convenient for comparing the paper's exponential path and transcript
budgets without introducing natural-number division. -/
theorem powTwo_card_paths_obstruction
    (model : PaperStepSevenModel Hidden Y D W S)
    (pathExponent transcriptExponent fibreCardBound : Nat)
    (hPathCard :
      Fintype.card (PaperStepSevenPath model) = 2 ^ pathExponent)
    (hTranscriptCard :
      Fintype.card (PaperMeasuredTranscript Y D W S) <=
        2 ^ transcriptExponent)
    (hFibreCard : ∀ transcript,
      paperCompatibleHiddenCount model transcript <= fibreCardBound) :
    2 ^ pathExponent <= 2 ^ transcriptExponent * fibreCardBound := by
  calc
    2 ^ pathExponent = Fintype.card (PaperStepSevenPath model) :=
      hPathCard.symm
    _ <= Fintype.card (PaperMeasuredTranscript Y D W S) *
        fibreCardBound :=
      card_paths_le_card_transcript_mul_fibreCardBound
        model fibreCardBound hFibreCard
    _ <= 2 ^ transcriptExponent * fibreCardBound :=
      Nat.mul_le_mul_right fibreCardBound hTranscriptCard

end SimonDCP.Probability.Lemma4AdaptiveWalshFibreObstruction

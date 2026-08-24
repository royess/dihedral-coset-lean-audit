import Mathlib

/-!
# Executable binary-incidence certificate for the mixed high-cell MT ledger

This module reconstructs the small binary part of the mixed high-cell
trace-four certificate without importing JavaScript output.  Activity vectors
are bit-packed natural numbers.  We enumerate every binary linear subspace of
`F_2^d`, apply the row/edge activity screen, partition ordered pairs by their
combined binary span, and run a fraction-free rank checker on all signed
ternary lifts.

The last computation records the important separation between the two
ledgers: every enumerated proper binary activity subspace passes the signed
lift rank checker at width `d`.  We also give a checker-independent semantic
bridge: row activity supplies a support through every coordinate, and two
signed lifts of that same support differ by twice the corresponding standard
basis vector.  Hence the public row enumeration spans `Q^d`.  The custom
fraction-free checker is still not proved equivalent to Mathlib's general
matrix rank; its output is an independent executable cross-check.

The exhaustive equalities use `native_decide`, following the existing
finite-certificate convention in this repository.  This trusts Lean's native
compiler through `Lean.ofReduceBool`; it is not pure kernel reduction.
-/

namespace SimonDCP.Certificates.MixedHigh.MTBinaryIncidence

/-- The `d`-dimensional binary cube, encoded by natural-number bit masks. -/
def binaryCube (d : Nat) : Finset Nat :=
  Finset.range (2 ^ d)

/-- Boolean test that a finite set is closed under binary addition.

The ambient range is traversed explicitly: `Finset.toList` uses choice in
mathlib and therefore cannot occur in a `native_decide` computation. -/
def isBinarySubspace (d : Nat) (space : Finset Nat) : Bool :=
  decide (0 ∈ space) &&
    (List.range (2 ^ d)).all fun left =>
      if left ∈ space then
        (List.range (2 ^ d)).all fun right =>
          if right ∈ space then decide (Nat.xor left right ∈ space) else true
      else
        true

/-- All dimension-`k` binary subspaces of the bit-packed `d`-cube. -/
def binarySubspaces (d k : Nat) : Finset (Finset Nat) :=
  (binaryCube d).powerset.filter fun space =>
    space.card = 2 ^ k ∧ isBinarySubspace d space = true

/-- Whether coordinate `i` is active in at least one vector of `space`. -/
def coordinateActive (d : Nat) (space : Finset Nat) (i : Nat) : Bool :=
  (List.range (2 ^ d)).any fun word =>
    decide (word ∈ space) && Nat.testBit word i

/-- Whether both endpoints of an edge are active in one vector of `space`. -/
def edgeActive (d : Nat) (space : Finset Nat) (edge : Nat × Nat) : Bool :=
  (List.range (2 ^ d)).any fun word =>
    decide (word ∈ space) &&
      Nat.testBit word edge.1 && Nat.testBit word edge.2

/-- The row/edge activity screen used by the mixed high-cell MT ledger. -/
def admissibleBinaryMask (d : Nat) (edges : List (Nat × Nat))
    (space : Finset Nat) : Bool :=
  (List.range d).all (coordinateActive d space) &&
    edges.all (edgeActive d space)

/-- Admissible dimension-`k` binary activity subspaces. -/
def admissibleBinarySubspaces (d k : Nat) (edges : List (Nat × Nat)) :
    Finset (Finset Nat) :=
  (binarySubspaces d k).filter fun space =>
    admissibleBinaryMask d edges space = true

/-- The four trace-cycle edges for the `d=3` orbit pattern. -/
def d3Edges : List (Nat × Nat) :=
  [(0, 1), (1, 2), (2, 1), (1, 0)]

/-- The four trace-cycle edges for the `d=4` orbit pattern. -/
def d4Edges : List (Nat × Nat) :=
  [(0, 1), (1, 2), (2, 3), (3, 0)]

/-- All proper admissible masks. -/
def properBinaryMasks (d : Nat) (edges : List (Nat × Nat)) :
    Finset (Finset Nat) :=
  (Finset.range (d - 1)).biUnion fun offset =>
    admissibleBinarySubspaces d (offset + 1) edges

/-- The sum of two binary subspaces, represented as all pairwise XORs. -/
def binarySubspaceSum (left right : Finset Nat) : Finset Nat :=
  left.biUnion fun x => right.image fun y => Nat.xor x y

/-- Counts in the ordered binary-pair partition, after sign-gauge multiplicity. -/
structure PairPartition where
  properSubspaces : Nat
  gauge : Nat
  oneSidedInstances : Nat
  properUnionFullInstances : Nat
  commonRelationInstances : Nat
  deriving DecidableEq, Repr

/-- Reconstruct the complete ordered pair partition used by the JS ledger. -/
def binaryPairPartition (d : Nat) (edges : List (Nat × Nat))
    (gauge : Nat) : PairPartition :=
  let proper := properBinaryMasks d edges
  let full := binaryCube d
  let masks := insert full proper
  let pairs := masks.product masks
  let oneSided := pairs.filter fun pair =>
    (pair.1 = full ∧ pair.2 ≠ full) ∨ (pair.1 ≠ full ∧ pair.2 = full)
  let properUnionFull := pairs.filter fun pair =>
    pair.1 ≠ full ∧ pair.2 ≠ full ∧
      (binarySubspaceSum pair.1 pair.2).card = 2 ^ d
  let commonRelation := pairs.filter fun pair =>
    pair.1 ≠ full ∧ pair.2 ≠ full ∧
      (binarySubspaceSum pair.1 pair.2).card ≠ 2 ^ d
  {
    properSubspaces := proper.card
    gauge := gauge
    oneSidedInstances := gauge * oneSided.card
    properUnionFullInstances := gauge * properUnionFull.card
    commonRelationInstances := gauge * commonRelation.card
  }

/-! ## Fraction-free rational-rank checker -/

/-- An integer row together with the position of its first nonzero entry. -/
private structure PivotRow where
  pivot : Nat
  coefficients : List Int

private def firstNonzeroAux : List Int → Nat → Option Nat
  | [], _ => none
  | value :: rest, index =>
      if value = 0 then firstNonzeroAux rest (index + 1) else some index

private def firstNonzero (row : List Int) : Option Nat :=
  firstNonzeroAux row 0

/-- Eliminate one pivot without division; this preserves rank over `Q`. -/
private def eliminatePivot (row : List Int) (pivotRow : PivotRow) : List Int :=
  let rowCoefficient := row.getD pivotRow.pivot 0
  if rowCoefficient = 0 then
    row
  else
    let pivotCoefficient := pivotRow.coefficients.getD pivotRow.pivot 0
    List.zipWith
      (fun x y => pivotCoefficient * x - rowCoefficient * y)
      row pivotRow.coefficients

private def insertPivot (row : PivotRow) : List PivotRow → List PivotRow
  | [] => [row]
  | head :: tail =>
      if row.pivot < head.pivot then row :: head :: tail
      else head :: insertPivot row tail

private def addRankRow (basis : List PivotRow) (row : List Int) : List PivotRow :=
  let reduced := basis.foldl eliminatePivot row
  match firstNonzero reduced with
  | none => basis
  | some pivot => insertPivot { pivot := pivot, coefficients := reduced } basis

/-- Fraction-free elimination count used by this executable certificate.

Every caller below supplies rows of the same width `d`.  This module does not
yet prove that the count equals Mathlib's `Q`-linear rank. -/
private def rationalRank (rows : List (List Int)) : Nat :=
  (rows.foldl addRankRow []).length

/-- One signed ternary lift of a bit-packed activity vector. -/
def signedLiftRow (d support signs : Nat) : List Int :=
  (List.range d).map fun i =>
    if Nat.testBit support i then
      if Nat.testBit signs i then 1 else -1
    else
      0

/-- All signed ternary lifts of all activity vectors in a binary mask. -/
def signedLiftRows (d : Nat) (space : Finset Nat) : List (List Int) :=
  (List.range (2 ^ d)).flatMap fun support =>
    if support ∈ space then
      (List.range (2 ^ d)).map fun signs => signedLiftRow d support signs
    else
      []

/-! ## Semantic rational-span bridge -/

/-- Interpret an integer row as a vector in `Q^d`, padding short rows by zero. -/
def rowAsQVector (d : Nat) (row : List Int) : Fin d → ℚ := fun i =>
  (row.getD i.1 0 : ℚ)

/-- Direct semantic interpretation of one signed lift. -/
def signedLiftVector (d support signs : Nat) : Fin d → ℚ := fun i =>
  if Nat.testBit support i.1 then
    if Nat.testBit signs i.1 then 1 else -1
  else
    0

/-- The rational vectors represented by the public `signedLiftRows` list. -/
def signedLiftGenerators (d : Nat) (space : Finset Nat) : Set (Fin d → ℚ) :=
  { vector | ∃ row ∈ signedLiftRows d space, rowAsQVector d row = vector }

/-- The mathematical rational span of the public signed-lift enumeration. -/
def signedLiftSpan (d : Nat) (space : Finset Nat) : Submodule ℚ (Fin d → ℚ) :=
  Submodule.span ℚ (signedLiftGenerators d space)

theorem signedLiftRow_mem_signedLiftRows {d support signs : Nat}
    {space : Finset Nat} (hsupport_lt : support < 2 ^ d)
    (hsupport_mem : support ∈ space) (hsigns_lt : signs < 2 ^ d) :
    signedLiftRow d support signs ∈ signedLiftRows d space := by
  simp only [signedLiftRows, List.mem_flatMap]
  refine ⟨support, List.mem_range.mpr hsupport_lt, ?_⟩
  rw [if_pos hsupport_mem]
  exact List.mem_map.mpr ⟨signs, List.mem_range.mpr hsigns_lt, rfl⟩

@[simp]
theorem rowAsQVector_signedLiftRow (d support signs : Nat) :
    rowAsQVector d (signedLiftRow d support signs) =
      signedLiftVector d support signs := by
  funext i
  change ((signedLiftRow d support signs).getD i.1 0 : ℚ) = _
  rw [List.getD_eq_getElem _ 0 (by simpa [signedLiftRow] using i.isLt)]
  simp [signedLiftRow, signedLiftVector]

theorem coordinateActive_eq_true_iff_exists (d : Nat) (space : Finset Nat)
    (i : Nat) :
    coordinateActive d space i = true ↔
      ∃ support ∈ List.range (2 ^ d),
        support ∈ space ∧ Nat.testBit support i = true := by
  simp [coordinateActive]

theorem signedLiftVector_mem_signedLiftSpan {d support signs : Nat}
    {space : Finset Nat} (hsupport_lt : support < 2 ^ d)
    (hsupport_mem : support ∈ space) (hsigns_lt : signs < 2 ^ d) :
    signedLiftVector d support signs ∈ signedLiftSpan d space := by
  rw [← rowAsQVector_signedLiftRow]
  apply Submodule.subset_span
  exact ⟨signedLiftRow d support signs,
    signedLiftRow_mem_signedLiftRows hsupport_lt hsupport_mem hsigns_lt, rfl⟩

theorem signedLiftVector_singleton_difference {d support : Nat} (i : Fin d)
    (hbit : Nat.testBit support i.1 = true) :
    signedLiftVector d support (2 ^ i.1) - signedLiftVector d support 0 =
      (2 : ℚ) • Pi.basisFun ℚ (Fin d) i := by
  ext j
  by_cases hij : i = j
  · subst j
    simp [signedLiftVector, hbit, Pi.basisFun_apply]
  · have hval : i.1 ≠ j.1 := by
      intro h
      exact hij (Fin.ext h)
    simp [signedLiftVector, Pi.basisFun_apply, hij,
      Nat.testBit_two_pow_of_ne hval]

/-- Row activity alone forces the signed ternary lifts to span `Q^d`. -/
theorem signedLiftSpan_eq_top_of_coordinateActive {d : Nat}
    {space : Finset Nat}
    (hactive : ∀ i : Fin d, coordinateActive d space i.1 = true) :
    signedLiftSpan d space = ⊤ := by
  apply top_unique
  rw [← (Pi.basisFun ℚ (Fin d)).span_eq]
  refine Submodule.span_le.2 ?_
  rintro _ ⟨i, rfl⟩
  obtain ⟨support, hsupport_range, hsupport_mem, hbit⟩ :=
    (coordinateActive_eq_true_iff_exists d space i.1).mp (hactive i)
  have hsupport_lt : support < 2 ^ d := List.mem_range.mp hsupport_range
  have hsigns_lt : 2 ^ i.1 < 2 ^ d :=
    Nat.pow_lt_pow_right (by decide) i.isLt
  have hplus :
      signedLiftVector d support (2 ^ i.1) ∈ signedLiftSpan d space :=
    signedLiftVector_mem_signedLiftSpan hsupport_lt hsupport_mem hsigns_lt
  have hminus : signedLiftVector d support 0 ∈ signedLiftSpan d space :=
    signedLiftVector_mem_signedLiftSpan hsupport_lt hsupport_mem
      (Nat.two_pow_pos d)
  have htwo :
      (2 : ℚ) • Pi.basisFun ℚ (Fin d) i ∈ signedLiftSpan d space := by
    rw [← signedLiftVector_singleton_difference i hbit]
    exact (signedLiftSpan d space).sub_mem hplus hminus
  have hscaled := (signedLiftSpan d space).smul_mem (2⁻¹ : ℚ) htwo
  have hscale :
      (2⁻¹ : ℚ) • ((2 : ℚ) • Pi.basisFun ℚ (Fin d) i) =
        Pi.basisFun ℚ (Fin d) i := by
    norm_num [smul_smul]
  rwa [hscale] at hscaled

theorem coordinateActive_of_admissibleBinaryMask {d : Nat}
    {edges : List (Nat × Nat)} {space : Finset Nat}
    (hadmissible : admissibleBinaryMask d edges space = true) (i : Fin d) :
    coordinateActive d space i.1 = true := by
  simp only [admissibleBinaryMask, Bool.and_eq_true, List.all_eq_true] at hadmissible
  exact hadmissible.1 i.1 (List.mem_range.mpr i.isLt)

/-- Every row-admissible mask has full rational signed-lift span. -/
theorem signedLiftSpan_eq_top_of_admissibleBinaryMask {d : Nat}
    {edges : List (Nat × Nat)} {space : Finset Nat}
    (hadmissible : admissibleBinaryMask d edges space = true) :
    signedLiftSpan d space = ⊤ :=
  signedLiftSpan_eq_top_of_coordinateActive fun i =>
    coordinateActive_of_admissibleBinaryMask hadmissible i

theorem admissibleBinaryMask_of_mem_properBinaryMasks {d : Nat}
    {edges : List (Nat × Nat)} {space : Finset Nat}
    (hspace : space ∈ properBinaryMasks d edges) :
    admissibleBinaryMask d edges space = true := by
  obtain ⟨offset, _, hmask⟩ := Finset.mem_biUnion.mp hspace
  exact (Finset.mem_filter.mp hmask).2

/-- In particular, every proper `d=3` certificate mask spans `Q^3`. -/
theorem d3_proper_binary_signed_lifts_span_top :
    ∀ space ∈ properBinaryMasks 3 d3Edges, signedLiftSpan 3 space = ⊤ := by
  intro space hspace
  exact signedLiftSpan_eq_top_of_admissibleBinaryMask
    (admissibleBinaryMask_of_mem_properBinaryMasks hspace)

/-- In particular, every proper `d=4` certificate mask spans `Q^4`. -/
theorem d4_proper_binary_signed_lifts_span_top :
    ∀ space ∈ properBinaryMasks 4 d4Edges, signedLiftSpan 4 space = ⊤ := by
  intro space hspace
  exact signedLiftSpan_eq_top_of_admissibleBinaryMask
    (admissibleBinaryMask_of_mem_properBinaryMasks hspace)

/-- Result of the local rank checker on the signed ternary lifts. -/
private def signedLiftRank (d : Nat) (space : Finset Nat) : Nat :=
  rationalRank (signedLiftRows d space)

/-- Executable universal rank-checker pass over all proper admissible masks. -/
def allSignedLiftsPassRankChecker (d : Nat) (edges : List (Nat × Nat)) : Bool :=
  decide (∀ space ∈ properBinaryMasks d edges, signedLiftRank d space = d)

/-! ## Exhaustive certificate statements -/

theorem d3_binary_mask_counts :
    ((binarySubspaces 3 2).card,
      (admissibleBinarySubspaces 3 2 d3Edges).card,
      (binarySubspaces 3 1).card,
      (admissibleBinarySubspaces 3 1 d3Edges).card) =
      (7, 4, 7, 1) := by
  native_decide

theorem d4_binary_mask_counts :
    ((binarySubspaces 4 3).card,
      (admissibleBinarySubspaces 4 3 d4Edges).card,
      (binarySubspaces 4 2).card,
      (admissibleBinarySubspaces 4 2 d4Edges).card,
      (binarySubspaces 4 1).card,
      (admissibleBinarySubspaces 4 1 d4Edges).card) =
      (15, 11, 35, 13, 15, 1) := by
  native_decide

theorem d3_proper_binary_mask_count :
    (properBinaryMasks 3 d3Edges).card = 5 := by
  native_decide

theorem d4_proper_binary_mask_count :
    (properBinaryMasks 4 d4Edges).card = 25 := by
  native_decide

theorem d3_binary_pair_partition :
    binaryPairPartition 3 d3Edges 4 =
      {
        properSubspaces := 5
        gauge := 4
        oneSidedInstances := 40
        properUnionFullInstances := 56
        commonRelationInstances := 44
      } := by
  native_decide

theorem d4_binary_pair_partition :
    binaryPairPartition 4 d4Edges 2 =
      {
        properSubspaces := 25
        gauge := 2
        oneSidedInstances := 100
        properUnionFullInstances := 760
        commonRelationInstances := 490
      } := by
  native_decide

theorem d3_binary_signed_lifts_pass_rank_checker :
    allSignedLiftsPassRankChecker 3 d3Edges = true := by
  native_decide

theorem d4_binary_signed_lifts_pass_rank_checker :
    allSignedLiftsPassRankChecker 4 d4Edges = true := by
  native_decide

end SimonDCP.Certificates.MixedHigh.MTBinaryIncidence

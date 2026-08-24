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
lift rank checker at width `d`.  The corresponding mathematical statement
that these rows span `Q^d` is true, but a later module must still connect the
custom checker to Mathlib's linear-algebraic rank.  Thus the theorems below do
not by themselves expose that semantic bridge.

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

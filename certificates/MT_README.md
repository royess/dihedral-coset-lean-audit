# Mixed high-cell MT certificate

Run from the repository root:

```powershell
node certificates/mixed_high_mt_certificate.js
```

The command has no third-party dependencies and performs no numerical
optimization. It regenerates all rational and binary ternary-cube incidence
masks for the `d=3,4` trace patterns, checks raw/admissible counts and the
binary pair partition, and substitutes fixed positive fugacity witnesses into
the coefficientwise absolute MZ polynomial. All logarithms in the final
inequalities are enclosed by exact-rational outward intervals, using a
90-term `atanh` series at fixed scale `10^50` with a rigorous geometric tail.

For every admissible proper binary activity subspace, the script also expands
all signed ternary lifts and verifies that their rational span has full rank
`d`.  Thus binary codimension is not inserted as a rational deficiency:
mod-two singularity changes only a fixed Smith factor, while the same
full-mask common-band witness coefficientwise dominates the restricted
positive polynomial.

The JSON output is deterministic except for `elapsedSeconds`.
`canonicalSha256` hashes the regenerated finite objects, parameters, ledger
summary, and fixed witnesses, and is checked against the embedded expected
hash.

## Uniform high-cell occupancy normalization

If `mu_r=N^(m_occ(r)+o(1))` and `m_occ(r)>=s_H`, the exact pair table gives

```text
Var(N_r)/mu_r^2 <= N^(-s_H+o(1)).
```

The generic pair term has exponent `-m_occ(r)`, the `GL` term is at most
`-[1-2*a+s_H]`, and the remaining pair types are smaller. Chebyshev and the
`N^o(1)` cell union imply, for every fixed `zeta<s_H/2`, simultaneous
`N_r/mu_r=1+O(N^(-zeta+o(1)))` over all high cells. This occupancy exponent
is about `s_H`; it is distinct from the narrower rational MT common-band
margin `0.002698120754...`.

The AM centered cancellation must be applied to the unconditional ordered
energy before intersecting with `Good`. Its mixed-cell exponent must also be
normalized by the actual source-cell `m_occ(r)`, not by the balanced-cusp
constant `m_exp`. The companion verifier
`mixed_high_am_certificate.js` implements this conditional-entropy ledger
with 27 fixed rational-mask witnesses, six binary activity masks, and an
analytic repeated-pair bound:

```powershell
node certificates/mixed_high_am_certificate.js
```

Its version-two canonical payload includes the directly evaluated outward
interval for `H_2(p)+p`, so independently rounded inputs for `p` and `a`
cannot silently reuse a hash based only on the analytic identity
`H_2(p)+p=a/3`.

The ordered energy uses `K_off=K-I`. If the target is `u` and the two source
leaves are `z,v`, then `z!=u` and `v!=u`; the allowed case `z=v!=u` is kept
in the repeated-pair ledger. Positive common-equality and line-line masks
force a repeated complete orbit and are deterministically absent from the
distinct-index triple sum; they are not deleted merely by conditioning on
`Good`.

## Rational common-band replay

The large rational-mask sweep is replayed, rather than accepted as a stored
summary, by:

```powershell
node certificates/mixed_high_mt_rational_certificate.js
```

For a fixed common scalar edge fugacity, the two-half dual separates into
half-mask scores. The script constructs pinned rounded row fugacities from
the multiaffine identity `Z=A+B*x_i` and the closed-form update

```text
x_i=min(p*A/((1-p)*B),2^(-2*nu_i)).
```

It then re-evaluates every rounded witness with exact rational arithmetic and
outward logarithm intervals. The exceptional plane/line face uses four
shared edge fugacities and is checked pair by pair. The coverage is 72
`d=2` instances, 2,916 `d=3` instances, and 1,696,482 `d=4` instances.
Line/line pairs are the only incidence classes deleted by `Good`; every
remaining class receives an explicit feasible dual. The 8,148 canonical
witness rows (mask key, rounded fugacities, and outward upper) have SHA-256

```text
8991c03d336e6cbfbe3e020615da3b5c79f6492ba4df94cb2862bf36cf42a6b7
```

and can be emitted verbatim with `--dump-witnesses`. A normal run takes about
two minutes on the audit workstation. The common worst outward upper for
`d=3,4` is `-0.002698120754`; the `d=2` upper is
`-0.307531127101`.

## Uniform mixed `Good_H`

For block rates `alpha_i in [0,p]`, put

```text
m_occ(alpha)=3*sum_i(H_2(alpha_i)+alpha_i)-(1+a),
b(alpha)=3*sum_i alpha_i.
```

The ordinary extra-orientation first moment in one degree cell has exponent
`m_occ(alpha)+b(alpha)-1`. Since `H_2(x)+x` is increasing on `[0,p]`, this
is at most `m_exp+12*p-1=-0.252414470147...`. The dependent entire-half flip
is a subset of the global four-template ledger and has exponent at most
`4*a-2=-0.002146195686...`, independently of the cell rates. Both formulas
are recomputed and asserted negative by the rational replay script. There
are only `N^o(1)` deterministic degree cells, so their union remains `o(1)`.

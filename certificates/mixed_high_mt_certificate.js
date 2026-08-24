#!/usr/bin/env node
"use strict";

/*
 * Reproducible finite certificate for the mixed high-cell MT ledger.
 *
 * This program deliberately does not optimize anything.  It
 *   (1) regenerates the rational and binary incidence masks;
 *   (2) checks all raw/admissible counts and the binary pair partition;
 *   (3) substitutes fixed positive fugacity witnesses into the full-mask
 *       absolute MZ polynomial using exact rational arithmetic and rigorous
 *       outward log_2 intervals; and
 *   (4) hashes a deterministic serialization of the regenerated objects.
 *
 * The exact selected-level coefficient is 3 on a compatible sign and -1 on
 * an incompatible sign.  The MT bound uses its coefficientwise absolute
 * majorant, hence the 3/+1 convention below.  Consequently every binary
 * activity subspace polynomial is coefficientwise bounded by the full one.
 */

const crypto = require("crypto");

const PARAM = Object.freeze({
  p: "0.020766264718131",
  a: "0.499463451078382",
  lower: "0.13725642534262442", // 9*x_(1/20)
  upper: "0.186896382463179",   // 9*p
});

const WITNESS = Object.freeze({
  d3: {
    d: 3,
    nu: [1, 2, 1],
    edges: [[0, 1], [1, 2], [2, 1], [1, 0]],
    tau: [1, 1, 1, 1],
    xLeft: [
      "0.0023867424021376577",
      "0.0005372409074959862",
      "0.0023867424021511503",
    ],
    xRight: [
      "0.0023867424021376577",
      "0.0005372409074959862",
      "0.0023867424021511503",
    ],
    y: [
      "11.64519165706633",
      "11.645191656868805",
      "11.64519165655495",
      "11.645191656416891",
    ],
    requiredUpper: "-0.85",
  },
  d4: {
    d: 4,
    nu: [1, 1, 1, 1],
    edges: [[0, 1], [1, 2], [2, 3], [3, 0]],
    tau: [1, 1, 1, 1],
    xLeft: [
      "0.00178477056136677",
      "0.0017847705613671743",
      "0.0017847705613803495",
      "0.0017847705613851723",
    ],
    xRight: [
      "0.00178477056136677",
      "0.0017847705613671743",
      "0.0017847705613803495",
      "0.0017847705613851723",
    ],
    y: [
      "47.189069976192066",
      "47.18906997555155",
      "47.189069975044845",
      "47.18906997525848",
    ],
    requiredUpper: "-1.34",
  },
});

// The exhaustive rational common-band sweep is represented here by its
// deterministic summary table.  The mask universe and its screening counts
// are regenerated below; the large per-pair witness table is a separate
// artifact in the full audit.  These entries are theorem inputs, not values
// recomputed by an optimizer in this verifier.
const RATIONAL_LEDGER = Object.freeze({
  band: [PARAM.lower, PARAM.upper],
  d2WorstUpper: "-0.3075",
  d3MaskGaugeInstances: 2640,
  d4SharpInstances: 800,
  d4NonsharpFixedWitnessInstances: 1695082,
  sharpClass: "d3:(1,2,1)/(2,1,1); d4 corresponding lifted face",
  sharpUpper: "-0.002697962448317",
  d4Deficiency22SafePlanes: 236,
  d4Deficiency22Upper: "-0.239644",
});

const EXPECTED_CANONICAL_SHA256 =
  "e327f5c442a26b706f93237ea0fb1df2af50064a63a76f6aebc9e69d259e8ce5";

function absBig(x) { return x < 0n ? -x : x; }
function gcdBig(a, b) {
  a = absBig(a); b = absBig(b);
  while (b !== 0n) [a, b] = [b, a % b];
  return a;
}

// A fraction is the normalized pair [numerator, positive denominator].
function frac(n, d = 1n) {
  if (d === 0n) throw new Error("zero denominator");
  if (d < 0n) { n = -n; d = -d; }
  if (n === 0n) return [0n, 1n];
  const g = gcdBig(n, d);
  return [n / g, d / g];
}
function fadd(x, y) { return frac(x[0] * y[1] + y[0] * x[1], x[1] * y[1]); }
function fneg(x) { return [-x[0], x[1]]; }
function fsub(x, y) { return fadd(x, fneg(y)); }
function fmul(x, y) { return frac(x[0] * y[0], x[1] * y[1]); }
function fdiv(x, y) {
  if (y[0] === 0n) throw new Error("division by zero");
  return frac(x[0] * y[1], x[1] * y[0]);
}
function fcmp(x, y) {
  const q = x[0] * y[1] - y[0] * x[1];
  return q < 0n ? -1 : q > 0n ? 1 : 0;
}
function fmin(...xs) { return xs.reduce((a, b) => fcmp(a, b) <= 0 ? a : b); }
function fmax(...xs) { return xs.reduce((a, b) => fcmp(a, b) >= 0 ? a : b); }

function decimalFraction(s) {
  let t = String(s).trim();
  let sign = 1n;
  if (t.startsWith("-")) { sign = -1n; t = t.slice(1); }
  if (/[eE]/.test(t)) {
    const [m, eRaw] = t.toLowerCase().split("e");
    const e = Number(eRaw);
    const base = decimalFraction((sign < 0n ? "-" : "") + m);
    return e >= 0
      ? frac(base[0] * 10n ** BigInt(e), base[1])
      : frac(base[0], base[1] * 10n ** BigInt(-e));
  }
  const [whole, tail = ""] = t.split(".");
  const den = 10n ** BigInt(tail.length);
  return frac(sign * BigInt((whole || "0") + tail), den);
}

function interval(lo, hi = lo) {
  if (fcmp(lo, hi) > 0) throw new Error("reversed interval");
  return { lo, hi };
}
function iadd(x, y) { return interval(fadd(x.lo, y.lo), fadd(x.hi, y.hi)); }
function ineg(x) { return interval(fneg(x.hi), fneg(x.lo)); }
function isub(x, y) { return iadd(x, ineg(y)); }
function imul(x, y) {
  const q = [fmul(x.lo, y.lo), fmul(x.lo, y.hi),
             fmul(x.hi, y.lo), fmul(x.hi, y.hi)];
  return interval(fmin(...q), fmax(...q));
}
function iscale(x, q) { return imul(x, interval(q)); }
function idivPositive(x, y) {
  if (fcmp(y.lo, [0n, 1n]) <= 0) throw new Error("nonpositive divisor interval");
  return imul(x, interval(fdiv([1n, 1n], y.hi), fdiv([1n, 1n], y.lo)));
}

function fpow(x, n) {
  let a = x, r = [1n, 1n], k = n;
  while (k > 0) {
    if (k & 1) r = fmul(r, a);
    a = fmul(a, a); k >>= 1;
  }
  return r;
}

const LOG_SCALE = 10n ** 50n;
function floorPositive(n, d) { return n / d; }
function ceilPositive(n, d) { return (n + d - 1n) / d; }

// For 1 <= y <= 2, use ln(y)=2*atanh((y-1)/(y+1)).
// Each positive series term is rounded separately at fixed scale 10^50;
// the omitted positive tail is bounded geometrically.  This avoids enormous
// common denominators while remaining a rigorous rational interval.
function lnUnitInterval(y, terms = 90) {
  const one = [1n, 1n];
  if (fcmp(y, one) < 0 || fcmp(y, [2n, 1n]) > 0) {
    throw new Error("lnUnitInterval requires 1 <= y <= 2");
  }
  const z = fdiv(fsub(y, one), fadd(y, one));
  const z2 = fmul(z, z);
  let powerN = z[0], powerD = z[1];
  let loScaled = 0n, hiScaled = 0n;
  for (let j = 0; j < terms; j += 1) {
    const n = 2n * powerN * LOG_SCALE;
    const d = powerD * BigInt(2 * j + 1);
    loScaled += floorPositive(n, d);
    hiScaled += ceilPositive(n, d);
    powerN *= z2[0];
    powerD *= z2[1];
  }
  // Tail <= 2*z^(2N+1)/((2N+1)*(1-z^2)).
  const remN = 2n * powerN * z2[1] * LOG_SCALE;
  const remD = powerD * BigInt(2 * terms + 1) * (z2[1] - z2[0]);
  hiScaled += ceilPositive(remN, remD);
  return interval(frac(loScaled, LOG_SCALE), frac(hiScaled, LOG_SCALE));
}

const LN2 = lnUnitInterval([2n, 1n]);

function log2Interval(x) {
  if (fcmp(x, [0n, 1n]) <= 0) throw new Error("log of nonpositive fraction");
  let y = x, k = 0;
  while (fcmp(y, [1n, 1n]) < 0) { y = fmul(y, [2n, 1n]); k -= 1; }
  while (fcmp(y, [2n, 1n]) >= 0) { y = fdiv(y, [2n, 1n]); k += 1; }
  const ratio = idivPositive(lnUnitInterval(y), LN2);
  return iadd(interval([BigInt(k), 1n]), ratio);
}

function decimalOutward(x, digits = 15, upper = false) {
  const scale = 10n ** BigInt(digits);
  let q = (x[0] * scale) / x[1]; // truncates toward zero
  const rem = (x[0] * scale) % x[1];
  if (upper && rem !== 0n && x[0] > 0n) q += 1n;
  if (!upper && rem !== 0n && x[0] < 0n) q -= 1n;
  const neg = q < 0n;
  let s = absBig(q).toString().padStart(digits + 1, "0");
  s = s.slice(0, -digits) + "." + s.slice(-digits);
  return (neg ? "-" : "") + s;
}

function popcount(x) {
  let q = x, n = 0;
  while (q) { q &= q - 1; n += 1; }
  return n;
}

// Exact rational row rank by fraction-free integer elimination.
function rankQ(rows, d) {
  const basis = [];
  for (const row0 of rows) {
    let row = row0.map(BigInt);
    for (const b of basis) {
      const p = b.pivot;
      if (row[p] === 0n) continue;
      const a = b.row[p], c = row[p];
      row = row.map((v, j) => a * v - c * b.row[j]);
      let g = 0n;
      for (const v of row) g = gcdBig(g, v);
      if (g > 1n) row = row.map(v => v / g);
    }
    const pivot = row.findIndex(v => v !== 0n);
    if (pivot < 0) continue;
    if (row[pivot] < 0n) row = row.map(v => -v);
    let g = 0n;
    for (const v of row) g = gcdBig(g, v);
    if (g > 1n) row = row.map(v => v / g);
    basis.push({ pivot, row });
    basis.sort((u, v) => u.pivot - v.pivot);
  }
  return basis.length;
}

function ternaryCube(d) {
  const out = [];
  const rec = (v) => {
    if (v.length === d) { out.push(v.slice()); return; }
    for (const q of [-1, 0, 1]) { v.push(q); rec(v); v.pop(); }
  };
  rec([]);
  return out;
}

function maskKey(indices) { return indices.join(","); }

function primitiveIntegerVector(v) {
  let g = 0n;
  for (const q of v) g = gcdBig(g, BigInt(q));
  let w = v.map(q => Number(BigInt(q) / (g || 1n)));
  const first = w.find(q => q !== 0);
  if (first < 0) w = w.map(q => -q);
  return w;
}

// A hyperplane spanned by ternary rows has a primitive normal whose entries
// are (d-1)-minors.  Their sharp bounds are 2 for d=3 and 4 for d=4.
// Enumerating these normals avoids recomputing an 81-point closure for every
// one of the many bases of the same hyperplane.
function rationalHyperplaneMasks(d) {
  const cube = ternaryCube(d);
  const bound = d === 3 ? 2 : 4;
  const normals = new Map();
  function rec(v) {
    if (v.length === d) {
      if (!v.some(Boolean)) return;
      const w = primitiveIntegerVector(v);
      normals.set(w.join(","), w);
      return;
    }
    for (let q = -bound; q <= bound; q += 1) { v.push(q); rec(v); v.pop(); }
  }
  rec([]);
  const masks = new Map();
  for (const normal of normals.values()) {
    const indices = [];
    const rows = [];
    for (let i = 0; i < cube.length; i += 1) {
      if (cube[i].reduce((s, q, j) => s + q * normal[j], 0) === 0) {
        indices.push(i); rows.push(cube[i]);
      }
    }
    if (rankQ(rows, d) === d - 1) masks.set(maskKey(indices), indices);
  }
  return [...masks.values()].sort((a, b) => maskKey(a).localeCompare(maskKey(b)));
}

function rationalMasks(d, k) {
  if (k === d - 1) return rationalHyperplaneMasks(d);
  const cube = ternaryCube(d);
  const nonzero = cube.map((v, i) => ({ v, i })).filter(q => q.v.some(Boolean));
  const masks = new Map();
  function rec(start, base) {
    if (base.length === k) {
      const indices = [];
      for (let i = 0; i < cube.length; i += 1) {
        if (rankQ(base.concat([cube[i]]), d) === k) indices.push(i);
      }
      masks.set(maskKey(indices), indices);
      return;
    }
    for (let q = start; q < nonzero.length; q += 1) {
      const next = base.concat([nonzero[q].v]);
      if (rankQ(next, d) === next.length) rec(q + 1, next);
    }
  }
  rec(0, []);
  return [...masks.values()].sort((a, b) => maskKey(a).localeCompare(maskKey(b)));
}

function admissibleTernaryMask(indices, cube, edges) {
  for (let i = 0; i < cube[0].length; i += 1) {
    if (!indices.some(q => cube[q][i] !== 0)) return false;
  }
  for (const [i, j] of edges) {
    if (!indices.some(q => cube[q][i] !== 0 && cube[q][j] !== 0)) return false;
  }
  return true;
}

function rankF2(vs, d) {
  const piv = Array(d).fill(0);
  let r = 0;
  for (let v0 of vs) {
    let v = v0;
    for (let j = d - 1; j >= 0; j -= 1) {
      if (((v >> j) & 1) === 0) continue;
      if (piv[j]) v ^= piv[j];
      else { piv[j] = v; r += 1; break; }
    }
  }
  return r;
}

function binarySubspaces(d, k) {
  const nonzero = Array.from({ length: (1 << d) - 1 }, (_, i) => i + 1);
  const spaces = new Map();
  function rec(start, base) {
    if (base.length === k) {
      const s = [];
      for (let v = 0; v < (1 << d); v += 1) {
        if (rankF2(base.concat([v]), d) === k) s.push(v);
      }
      spaces.set(s.join(","), s);
      return;
    }
    for (let q = start; q < nonzero.length; q += 1) {
      const next = base.concat([nonzero[q]]);
      if (rankF2(next, d) === next.length) rec(q + 1, next);
    }
  }
  rec(0, []);
  return [...spaces.values()].sort((a, b) => a.join(",").localeCompare(b.join(",")));
}

function admissibleBinaryMask(s, d, edges) {
  for (let i = 0; i < d; i += 1) if (!s.some(v => (v >> i) & 1)) return false;
  for (const [i, j] of edges) {
    if (!s.some(v => ((v >> i) & 1) && ((v >> j) & 1))) return false;
  }
  return true;
}

function regenerateMasks(spec) {
  const { d, edges } = spec;
  const cube = ternaryCube(d);
  const rational = {};
  const binary = {};
  for (let h = 1; h < d; h += 1) {
    const k = d - h;
    const rm = rationalMasks(d, k);
    const bm = binarySubspaces(d, k);
    rational[h] = {
      raw: rm,
      admissible: rm.filter(s => admissibleTernaryMask(s, cube, edges)),
    };
    binary[h] = {
      raw: bm,
      admissible: bm.filter(s => admissibleBinaryMask(s, d, edges)),
    };
  }
  return { rational, binary };
}

function binaryPairPartition(spec, binary) {
  const d = spec.d;
  const full = Array.from({ length: 1 << d }, (_, i) => i);
  const proper = Object.values(binary).flatMap(q => q.admissible);
  let oneSided = 0, unionFull = 0, common = 0;
  for (const A of [full].concat(proper)) {
    for (const B of [full].concat(proper)) {
      const aFull = A.length === full.length, bFull = B.length === full.length;
      if (aFull && bFull) continue;
      if (aFull !== bFull) { oneSided += 1; continue; }
      const r = rankF2(A.concat(B), d);
      if (r === d) unionFull += 1; else common += 1;
    }
  }
  const gauge = d === 3 ? 4 : 2;
  return {
    properSubspaces: proper.length,
    gauge,
    oneSidedInstances: oneSided * gauge,
    properUnionFullInstances: unionFull * gauge,
    commonRelationInstances: common * gauge,
  };
}

// A proper F_2 activity subspace is not a rational-rank deficiency.  Expand
// every activity vector into all of its signed ternary lifts and verify that
// the resulting Q-span is full.  Row activity is what makes the coordinate
// sign differences 2*e_i available; the executable check keeps that logical
// distinction from being confused with the binary codimension.
function binarySignedLiftRank(indices, d) {
  const rows = [];
  for (const mask of indices) {
    const row = Array(d).fill(0);
    const rec = (i) => {
      if (i === d) { rows.push(row.slice()); return; }
      if (((mask >> i) & 1) === 0) {
        row[i] = 0;
        rec(i + 1);
      } else {
        row[i] = -1;
        rec(i + 1);
        row[i] = 1;
        rec(i + 1);
      }
    };
    rec(0);
  }
  return rankQ(rows, d);
}

function assertBinarySignedLiftsFullRank(regen, d) {
  let tested = 0;
  for (const level of Object.values(regen.binary)) {
    for (const indices of level.admissible) {
      const rank = binarySignedLiftRank(indices, d);
      if (rank !== d) {
        throw new Error(`binary signed-lift Q-rank ${rank}, expected ${d}`);
      }
      tested += 1;
    }
  }
  return tested;
}

function signedStatesFull(spec) {
  const { d, edges, tau } = spec;
  const states = [];
  const total = 3 ** d;
  for (let code = 0; code < total; code += 1) {
    let q = code;
    const s = [];
    for (let i = 0; i < d; i += 1) { s.push((q % 3) - 1); q = Math.floor(q / 3); }
    const edgeCoeff = edges.map(([i, j], e) => {
      if (s[i] === 0 || s[j] === 0) return 0;
      return s[i] === tau[e] * s[j] ? 3 : 1; // absolute MZ
    });
    states.push({ s, edgeCoeff });
  }
  return states;
}

function evalZExact(spec, xStrings, yStrings) {
  const x = xStrings.map(decimalFraction), y = yStrings.map(decimalFraction);
  let Z = [0n, 1n];
  for (const state of signedStatesFull(spec)) {
    let w = [1n, 1n];
    for (let i = 0; i < spec.d; i += 1) if (state.s[i] !== 0) w = fmul(w, x[i]);
    for (let e = 0; e < 4; e += 1) {
      if (state.edgeCoeff[e]) {
        w = fmul(w, fadd([1n, 1n], fmul(y[e], [BigInt(state.edgeCoeff[e]), 1n])));
      }
    }
    Z = fadd(Z, w);
  }
  return Z;
}

function verifyWitness(spec) {
  const p = decimalFraction(PARAM.p), a = decimalFraction(PARAM.a);
  const lower = decimalFraction(PARAM.lower), upper = decimalFraction(PARAM.upper);
  const ZL = evalZExact(spec, spec.xLeft, spec.y);
  const ZR = evalZExact(spec, spec.xRight, spec.y);
  let phi = iscale(iadd(log2Interval(ZL), log2Interval(ZR)), [6n, 1n]);
  for (const xs of [spec.xLeft, spec.xRight]) {
    for (let i = 0; i < spec.d; i += 1) {
      const lx = log2Interval(decimalFraction(xs[i]));
      const c = isub(iscale(ineg(lx), [3n, 1n]), interval([BigInt(6 * spec.nu[i]), 1n]));
      if (fcmp(c.lo, [0n, 1n]) <= 0) throw new Error("row support face is not certified active");
      phi = iadd(phi, iscale(c, fmul([2n, 1n], p)));
    }
  }
  for (const ys of spec.y) {
    const y = decimalFraction(ys);
    const ly = log2Interval(y);
    if (fcmp(y, [1n, 1n]) >= 0) phi = isub(phi, iscale(ly, lower));
    else phi = isub(phi, iscale(ly, upper));
  }
  const penalty = fmul([BigInt(spec.d), 1n], fadd([1n, 1n], a));
  const lambda = isub(phi, interval(penalty));
  const required = decimalFraction(spec.requiredUpper);
  if (fcmp(lambda.hi, required) >= 0) {
    throw new Error(`witness failed: upper ${decimalOutward(lambda.hi, 15, true)} >= ${spec.requiredUpper}`);
  }
  return {
    lambdaLower: decimalOutward(lambda.lo, 15, false),
    lambdaUpper: decimalOutward(lambda.hi, 15, true),
    requiredUpper: spec.requiredUpper,
  };
}

function assertEqual(actual, expected, label) {
  if (JSON.stringify(actual) !== JSON.stringify(expected)) {
    throw new Error(`${label}: got ${JSON.stringify(actual)}, expected ${JSON.stringify(expected)}`);
  }
}

function summaryCounts(regen, d) {
  const out = {};
  for (let h = 1; h < d; h += 1) {
    out[h] = [regen.rational[h].raw.length, regen.rational[h].admissible.length];
  }
  return out;
}
function binaryCounts(regen, d) {
  const out = {};
  for (let h = 1; h < d; h += 1) {
    out[h] = [regen.binary[h].raw.length, regen.binary[h].admissible.length];
  }
  return out;
}

function canonicalPayload(r3, r4, pair3, pair4) {
  const compact = (regen, d) => {
    const out = {};
    for (let h = 1; h < d; h += 1) {
      out[h] = {
        rationalRaw: regen.rational[h].raw,
        rationalAdmissible: regen.rational[h].admissible,
        binaryRaw: regen.binary[h].raw,
        binaryAdmissible: regen.binary[h].admissible,
      };
    }
    return out;
  };
  return JSON.stringify({
    schema: "mixed-high-mt-v1",
    params: PARAM,
    rationalLedger: RATIONAL_LEDGER,
    d3: compact(r3, 3), d4: compact(r4, 4),
    binaryPairs: { d3: pair3, d4: pair4 },
    witnesses: WITNESS,
  });
}

function main() {
  const started = Date.now();
  process.stderr.write("[1/4] regenerating d=3 masks\n");
  const r3 = regenerateMasks(WITNESS.d3);
  process.stderr.write("[2/4] regenerating d=4 masks\n");
  const r4 = regenerateMasks(WITNESS.d4);
  assertEqual(summaryCounts(r3, 3), { 1: [25, 22], 2: [13, 4] }, "d3 rational masks");
  assertEqual(summaryCounts(r4, 4), { 1: [680, 676], 2: [362, 236], 3: [40, 8] }, "d4 rational masks");
  assertEqual(binaryCounts(r3, 3), { 1: [7, 4], 2: [7, 1] }, "d3 binary masks");
  assertEqual(binaryCounts(r4, 4), { 1: [15, 11], 2: [35, 13], 3: [15, 1] }, "d4 binary masks");
  const binaryQRank3 = assertBinarySignedLiftsFullRank(r3, 3);
  const binaryQRank4 = assertBinarySignedLiftsFullRank(r4, 4);
  assertEqual(binaryQRank3, 5, "d3 binary signed-lift full-Q-rank count");
  assertEqual(binaryQRank4, 25, "d4 binary signed-lift full-Q-rank count");

  const pair3 = binaryPairPartition(WITNESS.d3, r3.binary);
  const pair4 = binaryPairPartition(WITNESS.d4, r4.binary);
  assertEqual(pair3, {
    properSubspaces: 5, gauge: 4,
    oneSidedInstances: 40,
    properUnionFullInstances: 56,
    commonRelationInstances: 44,
  }, "d3 binary pair partition");
  assertEqual(pair4, {
    properSubspaces: 25, gauge: 2,
    oneSidedInstances: 100,
    properUnionFullInstances: 760,
    commonRelationInstances: 490,
  }, "d4 binary pair partition");

  process.stderr.write("[3/4] evaluating fixed outward witnesses\n");
  const witness3 = verifyWitness(WITNESS.d3);
  const witness4 = verifyWitness(WITNESS.d4);
  process.stderr.write("[4/4] serializing regenerated objects\n");
  const payload = canonicalPayload(r3, r4, pair3, pair4);
  const sha256 = crypto.createHash("sha256").update(payload, "utf8").digest("hex");
  if (sha256 !== EXPECTED_CANONICAL_SHA256) {
    throw new Error(`canonical SHA mismatch: got ${sha256}, expected ${EXPECTED_CANONICAL_SHA256}`);
  }

  const report = {
    status: "PASS",
    rationalMaskCounts: { d3: summaryCounts(r3, 3), d4: summaryCounts(r4, 4) },
    binaryMaskCounts: { d3: binaryCounts(r3, 3), d4: binaryCounts(r4, 4) },
    binarySignedLiftFullQRank: { d3: binaryQRank3, d4: binaryQRank4 },
    binaryPairPartition: { d3: pair3, d4: pair4 },
    fullMaskCommonBandWitness: { d3: witness3, d4: witness4 },
    rationalLedger: RATIONAL_LEDGER,
    canonicalSha256: sha256,
    elapsedSeconds: (Date.now() - started) / 1000,
  };
  process.stdout.write(JSON.stringify(report, null, 2) + "\n");
}

if (require.main === module) main();

module.exports = {
  frac, fadd, fneg, fsub, fmul, fdiv, fcmp, fmin, fmax,
  decimalFraction, interval, iadd, ineg, isub, imul, iscale,
  idivPositive, log2Interval, decimalOutward,
  rankQ, ternaryCube, rationalMasks, regenerateMasks,
  binarySignedLiftRank, assertBinarySignedLiftsFullRank,
  signedStatesFull, evalZExact,
};

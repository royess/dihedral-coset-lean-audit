#!/usr/bin/env node
"use strict";

/*
 * Replay certificate for the rational mixed-high MT ledger.
 *
 * The large pair sweep is compressed into fixed common-edge half witnesses.
 * For a fixed scalar edge fugacity y, the dual separates into its two half
 * scores.  The rounded row fugacities are produced by a pinned, closed-form
 * multiaffine recurrence and are then checked (not trusted) using exact
 * rational arithmetic and outward log_2 intervals.  The exceptional
 * plane/line incidence face is replayed with four shared edge fugacities.
 * No numerical optimizer or third-party package is used.
 */

const crypto = require("crypto");
const mt = require("./mixed_high_mt_certificate.js");

const PARAM = Object.freeze({
  p: "0.020766264718131",
  a: "0.499463451078382",
  lower: "0.13725642534262442",
  upper: "0.186896382463179",
});
const pFloat = Number(PARAM.p);
const lowerFloat = Number(PARAM.lower);
const upperFloat = Number(PARAM.upper);
const SCALE_DIGITS = 12;
const SCALE = 10n ** BigInt(SCALE_DIGITS);
const ROUNDS = 80;

const SPECS = Object.freeze({
  2: {
    d: 2,
    nu: [2, 2],
    edges: [[0, 1], [1, 0], [0, 1], [1, 0]],
    taus: [
      [1, 1, 1, 1], [-1, 1, 1, 1], [1, -1, 1, 1],
      [-1, -1, 1, 1], [1, 1, -1, 1], [-1, 1, -1, 1],
      [1, -1, -1, 1], [-1, -1, -1, 1],
    ],
  },
  3: {
    d: 3,
    nu: [1, 2, 1],
    edges: [[0, 1], [1, 2], [2, 1], [1, 0]],
    taus: [
      [1, 1, 1, 1], [-1, 1, 1, 1],
      [1, -1, 1, 1], [-1, -1, 1, 1],
    ],
  },
  4: {
    d: 4,
    nu: [1, 1, 1, 1],
    edges: [[0, 1], [1, 2], [2, 3], [3, 0]],
    taus: [[1, 1, 1, 1], [-1, 1, 1, 1]],
  },
});

const Y = Object.freeze({
  q025: "1.2840254166877414",
  q050: "1.6487212707001282",
  q075: "2.117000016612675",
  q100: "2.718281828459045",
  q125: "3.4903429574618414",
  q150: "4.4816890703380645",
  q175: "5.75460267600573",
  q200: "7.38905609893065",
  q225: "9.487735836358526",
  q275: "15.642631884188171",
  q300: "20.085536923187668",
  critical: "1.9671973282",
  one: "1",
});

// Key is "d:tau-index:min(h,g):max(h,g)".  These are fixed feasible
// witnesses, not asserted minimizers.  The only positive common-y face is
// the tau=0 (d-2,d-1,c=d-2) face; it is handled separately below.
const GROUP_Y = Object.freeze({
  "3:0:0:0": Y.q175, "3:0:0:1": Y.q125, "3:0:0:2": Y.q075,
  "3:0:1:1": Y.critical, "3:0:1:2": Y.one,
  "3:1:0:0": Y.q175, "3:1:0:1": Y.q150, "3:1:0:2": Y.q075,
  "3:1:1:1": Y.q075, "3:1:1:2": Y.one,
  "3:2:0:0": Y.q175, "3:2:0:1": Y.q150, "3:2:0:2": Y.q075,
  "3:2:1:1": Y.q075, "3:2:1:2": Y.one,
  "3:3:0:0": Y.q200, "3:3:0:1": Y.q150, "3:3:0:2": Y.q100,
  "3:3:1:1": Y.q100, "3:3:1:2": Y.q025,

  "4:0:0:0": Y.q300, "4:0:0:1": Y.q275, "4:0:0:2": Y.q225,
  "4:0:0:3": Y.q150, "4:0:1:1": Y.q225, "4:0:1:2": Y.q150,
  "4:0:1:3": Y.q050, "4:0:2:2": Y.critical, "4:0:2:3": Y.one,
  "4:1:0:0": Y.q300, "4:1:0:1": Y.q275, "4:1:0:2": Y.q225,
  "4:1:0:3": Y.q175, "4:1:1:1": Y.q225, "4:1:1:2": Y.q150,
  "4:1:1:3": Y.q075, "4:1:2:2": Y.q075, "4:1:2:3": Y.one,
});

function fzero() { return [0n, 1n]; }
function fone() { return [1n, 1n]; }
function ceilScaled(x) {
  let q = (x[0] * SCALE) / x[1];
  const r = (x[0] * SCALE) % x[1];
  if (x[0] > 0n && r !== 0n) q += 1n;
  return q;
}
function scaledDecimal(q) {
  const neg = q < 0n;
  let s = (neg ? -q : q).toString().padStart(SCALE_DIGITS + 1, "0");
  s = s.slice(0, -SCALE_DIGITS) + "." + s.slice(-SCALE_DIGITS);
  return (neg ? "-" : "") + s;
}
function roundFloat(x) {
  if (Math.abs(x - 1) < 1e-8) return "1";
  for (const q of [0.25, 0.0625, 0.00390625]) {
    if (Math.abs(x - q) < 1e-12) return String(q);
  }
  return Number(x.toPrecision(16)).toString();
}
function popState(spec, states, tau, x, ys) {
  let z = 0;
  for (const s of states) {
    let w = 1;
    for (let i = 0; i < spec.d; i += 1) if (s[i] !== 0) w *= x[i];
    for (let e = 0; e < 4; e += 1) {
      const [i, j] = spec.edges[e];
      if (s[i] !== 0 && s[j] !== 0) {
        w *= 1 + ys[e] * (s[i] === tau[e] * s[j] ? 3 : 1);
      }
    }
    z += w;
  }
  return z;
}
function splitFloat(spec, states, tau, x, ys, kind, i) {
  if (kind === "x") {
    const q = x[i];
    x[i] = 0; const A = popState(spec, states, tau, x, ys);
    x[i] = 1; const B = popState(spec, states, tau, x, ys) - A;
    x[i] = q; return [A, B];
  }
  const q = ys[i];
  ys[i] = 0; const A = popState(spec, states, tau, x, ys);
  ys[i] = 1; const B = popState(spec, states, tau, x, ys) - A;
  ys[i] = q; return [A, B];
}
function fixedHalfWitness(spec, states, tau, yText) {
  const ys = Array(4).fill(Number(yText));
  const x = spec.nu.map(q => 2 ** (-2 * q));
  for (let round = 0; round < ROUNDS; round += 1) {
    for (let i = 0; i < spec.d; i += 1) {
      const [A, B] = splitFloat(spec, states, tau, x, ys, "x", i);
      if (B > 0) x[i] = Math.min(pFloat * A / ((1 - pFloat) * B), 2 ** (-2 * spec.nu[i]));
    }
  }
  return x.map(roundFloat);
}

function edgeRoot(AL, BL, AR, BR, r, lo, hi) {
  const q = y => y * BL / (AL + BL * y) + y * BR / (AR + BR * y);
  if (q(lo) >= r) return lo;
  if (!Number.isFinite(hi)) { hi = 2; while (q(hi) < r) hi *= 2; }
  if (q(hi) <= r) return hi;
  for (let k = 0; k < 100; k += 1) {
    const mid = Math.sqrt(lo * hi);
    if (q(mid) < r) lo = mid; else hi = mid;
  }
  return Math.sqrt(lo * hi);
}
function floatPairObjective(spec, left, right, tau, xLeft, xRight, ys, h, g, c) {
  let v = 6 * Math.log2(popState(spec, left, tau, xLeft, ys));
  v += 6 * Math.log2(popState(spec, right, tau, xRight, ys));
  for (const xs of [xLeft, xRight]) for (let i = 0; i < spec.d; i += 1) {
    v += 2 * pFloat * Math.max(0, -3 * Math.log2(xs[i]) - 6 * spec.nu[i]);
  }
  for (const y of ys) v -= (y >= 1 ? lowerFloat : upperFloat) * Math.log2(y);
  v -= spec.d * (1 + Number(PARAM.a));
  v += Number(PARAM.a) * (h + g - c) + c;
  return v;
}
function fixedPairWitness(spec, left, right, tau, h, g, c) {
  const xLeft = spec.nu.map(q => 2 ** (-2 * q));
  const xRight = spec.nu.map(q => 2 ** (-2 * q));
  const ys = [1, 1, 1, 1];
  for (let round = 0; round < ROUNDS; round += 1) {
    for (const [states, x] of [[left, xLeft], [right, xRight]]) {
      for (let i = 0; i < spec.d; i += 1) {
        const [A, B] = splitFloat(spec, states, tau, x, ys, "x", i);
        if (B > 0) x[i] = Math.min(pFloat * A / ((1 - pFloat) * B), 2 ** (-2 * spec.nu[i]));
      }
    }
    for (let e = 0; e < 4; e += 1) {
      const [AL, BL] = splitFloat(spec, left, tau, xLeft, ys, "y", e);
      const [AR, BR] = splitFloat(spec, right, tau, xRight, ys, "y", e);
      const q1 = BL / (AL + BL) + BR / (AR + BR);
      const candidates = [1];
      if (q1 >= upperFloat / 6) candidates.push(edgeRoot(AL, BL, AR, BR, upperFloat / 6, 1e-15, 1));
      if (q1 <= lowerFloat / 6) candidates.push(edgeRoot(AL, BL, AR, BR, lowerFloat / 6, 1, Infinity));
      let bestY = 1, best = Infinity;
      for (const y of candidates) {
        ys[e] = y;
        const v = floatPairObjective(spec, left, right, tau, xLeft, xRight, ys, h, g, c);
        if (v < best) { best = v; bestY = y; }
      }
      ys[e] = bestY;
    }
  }
  return {
    xLeft: xLeft.map(roundFloat), xRight: xRight.map(roundFloat),
    y: ys.map(roundFloat),
  };
}

function exactZ(spec, states, tau, xText, yText) {
  const x = xText.map(mt.decimalFraction), y = yText.map(mt.decimalFraction);
  let Z = fzero();
  for (const s of states) {
    let w = fone();
    for (let i = 0; i < spec.d; i += 1) if (s[i] !== 0) w = mt.fmul(w, x[i]);
    for (let e = 0; e < 4; e += 1) {
      const [i, j] = spec.edges[e];
      if (s[i] !== 0 && s[j] !== 0) {
        const coeff = s[i] === tau[e] * s[j] ? 3n : 1n;
        w = mt.fmul(w, mt.fadd(fone(), mt.fmul(y[e], [coeff, 1n])));
      }
    }
    Z = mt.fadd(Z, w);
  }
  return Z;
}
function halfInterval(spec, states, tau, xText, yText) {
  const p = mt.decimalFraction(PARAM.p);
  let v = mt.iscale(mt.log2Interval(exactZ(spec, states, tau, xText, yText)), [6n, 1n]);
  for (let i = 0; i < spec.d; i += 1) {
    const lx = mt.log2Interval(mt.decimalFraction(xText[i]));
    const row = mt.isub(mt.iscale(mt.ineg(lx), [3n, 1n]), mt.interval([BigInt(6 * spec.nu[i]), 1n]));
    const positive = mt.fcmp(row.hi, fzero()) <= 0
      ? mt.interval(fzero())
      : mt.interval(mt.fcmp(row.lo, fzero()) >= 0 ? row.lo : fzero(), row.hi);
    v = mt.iadd(v, mt.iscale(positive, mt.fmul([2n, 1n], p)));
  }
  return v;
}
function edgeInterval(yText) {
  const y = mt.decimalFraction(yText);
  const rate = mt.decimalFraction(mt.fcmp(y, fone()) >= 0 ? PARAM.lower : PARAM.upper);
  return mt.iscale(mt.ineg(mt.log2Interval(y)), rate);
}
function classConstant(d, h, g, c) {
  const a = mt.decimalFraction(PARAM.a);
  return mt.fadd(
    mt.fneg(mt.fmul([BigInt(d), 1n], mt.fadd(fone(), a))),
    mt.fadd(mt.fmul(a, [BigInt(h + g - c), 1n]), [BigInt(c), 1n]),
  );
}
function exactPairUpper(spec, left, right, tau, witness, h, g, c) {
  let v = mt.iadd(
    halfInterval(spec, left, tau, witness.xLeft, witness.y),
    halfInterval(spec, right, tau, witness.xRight, witness.y),
  );
  for (const y of witness.y) v = mt.iadd(v, edgeInterval(y));
  v = mt.iadd(v, mt.interval(classConstant(spec.d, h, g, c)));
  return ceilScaled(v.hi);
}

function rankUnion(spec, left, right) {
  return mt.rankQ(left.concat(right), spec.d);
}
function buildMasks(spec) {
  const cube = mt.ternaryCube(spec.d);
  const regen = mt.regenerateMasks(spec);
  const masks = [{ h: 0, indices: cube.map((_, i) => i), states: cube }];
  for (let h = 1; h < spec.d; h += 1) {
    for (const indices of regen.rational[h].admissible) {
      masks.push({ h, indices, states: indices.map(i => cube[i]) });
    }
  }
  for (const m of masks) m.key = m.indices.join(",");
  return { cube, regen, masks };
}
function contextKey(d, ti, h, g) {
  return `${d}:${ti}:${Math.min(h, g)}:${Math.max(h, g)}`;
}
function isLineLine(spec, left, right) {
  return left.h === spec.d - 1 && right.h === spec.d - 1;
}
function isSpecial(spec, ti, left, right, c) {
  return ti === 0 && c === spec.d - 2 &&
    ((left.h === spec.d - 2 && right.h === spec.d - 1) ||
     (left.h === spec.d - 1 && right.h === spec.d - 2));
}

function replayDimension(d, witnessRows) {
  const spec = SPECS[d];
  const { masks, regen } = buildMasks(spec);
  if (d === 2) {
    const counts = [regen.rational[1].raw.length, regen.rational[1].admissible.length];
    if (JSON.stringify(counts) !== JSON.stringify([4, 2])) throw new Error(`d2 counts ${counts}`);
  }
  const byH = new Map();
  for (let h = 0; h < d; h += 1) byH.set(h, masks.filter(m => m.h === h));
  const contexts = new Map();
  const report = { d, total: 0, lineLineDeleted: 0, special: 0, grouped: 0, worst: null };

  function remember(value, kind, key) {
    if (!report.worst || value > report.worst.upperScaled) {
      report.worst = { kind, key, upperScaled: value, upper: scaledDecimal(value) };
    }
  }

  for (let ti = 0; ti < spec.taus.length; ti += 1) {
    const tau = spec.taus[ti];
    for (const left of masks) for (const right of masks) {
      report.total += 1;
      if (isLineLine(spec, left, right)) { report.lineLineDeleted += 1; continue; }
      const c = d - rankUnion(spec, left.states, right.states);
      const pairKey = `${ti}|${left.h}:${left.key}|${right.h}:${right.key}|c${c}`;
      if (d === 2 || isSpecial(spec, ti, left, right, c)) {
        const w = fixedPairWitness(spec, left.states, right.states, tau, left.h, right.h, c);
        const upperScaled = exactPairUpper(spec, left.states, right.states, tau, w, left.h, right.h, c);
        witnessRows.push(`P|d${d}|${pairKey}|${w.xLeft.join(",")}|${w.xRight.join(",")}|${w.y.join(",")}|${scaledDecimal(upperScaled)}`);
        report.special += 1; remember(upperScaled, d === 2 ? "direct" : "special", pairKey);
        continue;
      }

      const ck = contextKey(d, ti, left.h, right.h);
      if (!contexts.has(ck)) {
        const y = GROUP_Y[ck];
        if (!y) throw new Error(`missing common-y context ${ck}`);
        const yText = Array(4).fill(y);
        const scores = new Map();
        const needed = byH.get(left.h).concat(byH.get(right.h));
        for (const m of needed) if (!scores.has(m.key)) {
          const x = fixedHalfWitness(spec, m.states, tau, y);
          const upperScaled = ceilScaled(halfInterval(spec, m.states, tau, x, yText).hi);
          scores.set(m.key, upperScaled);
          witnessRows.push(`H|${ck}|h${m.h}:${m.key}|${x.join(",")}|${y}|${scaledDecimal(upperScaled)}`);
        }
        let edge = mt.interval(fzero());
        for (let e = 0; e < 4; e += 1) edge = mt.iadd(edge, edgeInterval(y));
        contexts.set(ck, { y, scores, edgeUpper: ceilScaled(edge.hi) });
      }
      const ctx = contexts.get(ck);
      const constantUpper = ceilScaled(classConstant(d, left.h, right.h, c));
      const upperScaled = ctx.scores.get(left.key) + ctx.scores.get(right.key) +
        ctx.edgeUpper + constantUpper;
      report.grouped += 1; remember(upperScaled, "group", pairKey);
    }
  }
  const expectedTotal = masks.length * masks.length * spec.taus.length;
  if (report.total !== expectedTotal) throw new Error(`d${d} total mismatch`);
  if (report.worst.upperScaled >= 0n) throw new Error(`d${d} nonnegative upper ${report.worst.upper}`);
  return report;
}

const EXPECTED_WITNESS_SHA256 =
  "8991c03d336e6cbfbe3e020615da3b5c79f6492ba4df94cb2862bf36cf42a6b7";

function goodUniformReport() {
  const p = mt.decimalFraction(PARAM.p), a = mt.decimalFraction(PARAM.a);
  const mExp = mt.fsub(mt.fmul([3n, 1n], a), fone());
  const beta = mt.fmul([12n, 1n], p);
  const ordinary = mt.fsub(mt.fadd(mExp, beta), fone());
  const dependentHalf = mt.fsub(mt.fmul([4n, 1n], a), [2n, 1n]);
  if (mt.fcmp(ordinary, fzero()) >= 0 || mt.fcmp(dependentHalf, fzero()) >= 0) {
    throw new Error("mixed Good exponent is not negative");
  }
  return {
    ordinaryOrientationFormula: "m_occ(alpha)+3*sum(alpha_i)-1",
    ordinaryUniformUpper: scaledDecimal(ceilScaled(ordinary)),
    dependentHalfFormula: "4*a-2",
    dependentHalfUniformUpper: scaledDecimal(ceilScaled(dependentHalf)),
    domination: "alpha_i in [0,p] implies m_occ(alpha)<=3*a-1 and 3*sum(alpha_i)<=12*p",
    union: "the deterministic degree-cell family has N^o(1) members",
  };
}

function main() {
  const started = Date.now();
  const rows = ["mixed-high-mt-rational-v1"];
  const reports = [];
  for (const d of [2, 3, 4]) {
    process.stderr.write(`[rational MT] replaying d=${d}\n`);
    reports.push(replayDimension(d, rows));
  }
  const text = rows.join("\n") + "\n";
  const sha256 = crypto.createHash("sha256").update(text, "utf8").digest("hex");
  if (sha256 !== EXPECTED_WITNESS_SHA256) {
    throw new Error(`witness SHA mismatch: got ${sha256}, expected ${EXPECTED_WITNESS_SHA256}`);
  }
  if (process.argv.includes("--dump-witnesses")) {
    process.stdout.write(text);
    return;
  }
  process.stdout.write(JSON.stringify({
    status: "PASS", reports, witnessRows: rows.length - 1,
    witnessSha256: sha256, goodUniform: goodUniformReport(),
    elapsedSeconds: (Date.now() - started) / 1000,
  }, (_key, value) => typeof value === "bigint" ? value.toString() : value, 2) + "\n");
}

if (require.main === module) main();

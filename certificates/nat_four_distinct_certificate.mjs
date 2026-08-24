#!/usr/bin/env node

/*
 * Exact finite certificate for the four-distinct, ell_eta = 0
 * graph-determined branch of LEMMA3_HALF_TURN_ERASER.md.
 * The global r_eta may be positive; the joint partition supplies the
 * class-dependent lower bound used in each final exponent.
 *
 * The combinatorial part deliberately uses no floating point arithmetic.
 * Every subspace is represented by its rational reduced row echelon form;
 * every polynomial coefficient is stored in units of 1/16.
 *
 * Run:
 *   node certificates/nat_four_distinct_certificate.mjs
 *
 * The final JSON object is serialized by stableJson() and its SHA-256 is
 * printed separately.  Progress messages go to stderr.
 */

import { createHash } from "node:crypto";

const EXPECTED = Object.freeze({
  alphabetCount: 369,
  alphabetSha256:
    "4d235072c9b1272ba27755daf9892e9c7ce73327f85d725b741db404eb06ea8e",
  rawGraphCounts: Object.freeze({ 3: 403300, 2: 12700, 1: 184 }),
  legalGraphCounts: Object.freeze({ 3: 122580, 2: 1884, 1: 8 }),
  rowActiveGraphCounts: Object.freeze({ 3: 325588, 2: 5788, 1: 8 }),
  edgeOmittedGraphCounts: Object.freeze({ 3: 203008, 2: 3904, 1: 0 }),
  levelPolynomialCounts: Object.freeze({ 3: 365, 2: 26, 1: 1 }),
  rowActiveLevelPolynomialCounts: Object.freeze({ 3: 597, 2: 49, 1: 1 }),
  edgeOmittedLevelPolynomialCounts: Object.freeze({ 3: 232, 2: 23, 1: 0 }),
  polynomialCount: 383,
  cubeSectionCounts: Object.freeze({ 3: 680, 2: 362, 1: 40 }),
  rowActiveCubeSectionCounts: Object.freeze({ 3: 676, 2: 268, 1: 8 }),
  equalPositiveRankTwoCount: 220,
  mixedNewbornCount: 48,
  discreteManifestSha256:
    "ab58303ca18865ef88f2a71f64d21c330aaaa50322ebdf3a2137950b96033e0d",
  outwardBoundsSha256:
    "ce5e8d0a897b14704d601c88d312f83e715a709a45bb3b15fa8b16e3d9200a09",
  fullCertificateSha256:
    "a5fc261f92047c707e94cb03a102c8b3d6af20f36020a7bbd24b44ef7f70c887",
  // These are hashes from the originating REPL.  Their original byte-level
  // serialization was not persisted.  They are retained as provenance, not
  // compared with the versioned serialization defined in this file.
  originatingReplHashes: Object.freeze({
    keptMaps:
      "b01d97cca21a551f531ea21956a662b0f7af6cb53b7678cac6e2e230adeec991",
    ledger:
      "2f51e6864b1dbed8c7011efd73d63f96f8c625633047afe3ac8bc1888c97ddb9",
  }),
});

const SERIALIZATION_VERSION = "nat-four-distinct-certificate-v2";
const OUTWARD_BOUNDS = Object.freeze({
  serializationVersion: "nat-four-distinct-outward-box-v1",
  parameterBox: Object.freeze({
    p: Object.freeze(["0.020766264718130", "0.020766264718132"]),
    a: Object.freeze(["0.499463451078381", "0.499463451078383"]),
  }),
  integerScale: "10000000000000000000000000000000000000000",
  logSeriesTerms: 90,
  uniformAllowance: "0.000000000001",
  halfEnvelopeUpper: Object.freeze({
    k4: "0.576809041814568",
    k3: "0.3767971763574999",
    k2: "0.25375502959113555",
    k1: "0.16648781702613322",
  }),
  finalUpper: Object.freeze({
    h1_h2_cross: "-0.21561366646494923",
    h1_line: "-0.2397534907765821",
    sameD_h1: "-0.47736078586676306",
    sameD_h2: "-0.4544030959847543",
    plane_line_distinctW: "-0.47854292029638723",
    surface_H: "-0.5626241632228051",
    surface_P: "-0.37878803635054414",
    surface_PL: "-0.19046711601847266",
    newborn48: "-0.127816881839",
  }),
  provenance:
    "Exact-rational outward box envelopes exported from the originating " +
    "audit REPL. Decimal strings are exact rationals. This script checks " +
    "their format, parameter containment, and strict negativity after the " +
    "uniform allowance; re-deriving the analytic envelopes requires the " +
    "separately reviewed 90-term interval evaluator.",
});
const EDGES = Object.freeze([
  [0, 1],
  [1, 2],
  [2, 3],
  [3, 0],
]);
const ROW_PAIRS = Object.freeze([
  [0, 1],
  [0, 2],
  [0, 3],
  [1, 2],
  [1, 3],
  [2, 3],
]);

function fail(message) {
  throw new Error(`certificate failure: ${message}`);
}

function assertEqual(actual, expected, label) {
  if (actual !== expected) {
    fail(`${label}: expected ${expected}, got ${actual}`);
  }
}

function gcd(a, b) {
  a = Math.abs(a);
  b = Math.abs(b);
  while (b !== 0) {
    const r = a % b;
    a = b;
    b = r;
  }
  return a;
}

function lcm(a, b) {
  if (a === 0 || b === 0) return 0;
  return Math.abs((a / gcd(a, b)) * b);
}

function frac(n, d = 1) {
  if (!Number.isSafeInteger(n) || !Number.isSafeInteger(d) || d === 0) {
    fail(`invalid rational ${n}/${d}`);
  }
  if (n === 0) return [0, 1];
  if (d < 0) {
    n = -n;
    d = -d;
  }
  const g = gcd(n, d);
  return [n / g, d / g];
}

function fadd(a, b) {
  return frac(a[0] * b[1] + b[0] * a[1], a[1] * b[1]);
}

function fsub(a, b) {
  return frac(a[0] * b[1] - b[0] * a[1], a[1] * b[1]);
}

function fmul(a, b) {
  return frac(a[0] * b[0], a[1] * b[1]);
}

function fdiv(a, b) {
  if (b[0] === 0) fail("division by zero");
  return frac(a[0] * b[1], a[1] * b[0]);
}

function fscale(a, n) {
  return frac(a[0] * n, a[1]);
}

function fisZero(a) {
  return a[0] === 0;
}

function fisNonnegative(a) {
  return a[0] >= 0;
}

function feq(a, b) {
  return a[0] === b[0] && a[1] === b[1];
}

function ftext(a) {
  return a[1] === 1 ? String(a[0]) : `${a[0]}/${a[1]}`;
}

function parseFraction(text) {
  const slash = text.indexOf("/");
  return slash < 0
    ? [Number(text), 1]
    : [Number(text.slice(0, slash)), Number(text.slice(slash + 1))];
}

function stableJson(value) {
  if (value === null || typeof value !== "object") {
    return JSON.stringify(value);
  }
  if (Array.isArray(value)) {
    return `[${value.map(stableJson).join(",")}]`;
  }
  const keys = Object.keys(value).sort();
  return `{${keys
    .map((key) => `${JSON.stringify(key)}:${stableJson(value[key])}`)
    .join(",")}}`;
}

function sha256(text) {
  return createHash("sha256").update(text, "utf8").digest("hex");
}

function bigintGcd(a, b) {
  if (a < 0n) a = -a;
  if (b < 0n) b = -b;
  while (b !== 0n) {
    const r = a % b;
    a = b;
    b = r;
  }
  return a;
}

function decimalRational(text) {
  const match = /^(-?)(\d+)(?:\.(\d+))?$/.exec(text);
  if (match === null) fail(`non-canonical decimal rational: ${text}`);
  const fractional = match[3] ?? "";
  const denominator = 10n ** BigInt(fractional.length);
  let numerator = BigInt(`${match[2]}${fractional}`);
  if (match[1] === "-") numerator = -numerator;
  const divisor = bigintGcd(numerator, denominator);
  return [numerator / divisor, denominator / divisor];
}

function rationalAdd(a, b) {
  const numerator = a[0] * b[1] + b[0] * a[1];
  const denominator = a[1] * b[1];
  const divisor = bigintGcd(numerator, denominator);
  return [numerator / divisor, denominator / divisor];
}

function rationalCompare(a, b) {
  const difference = a[0] * b[1] - b[0] * a[1];
  return difference < 0n ? -1 : difference > 0n ? 1 : 0;
}

function rationalNormalizeBig(numerator, denominator = 1n) {
  if (denominator === 0n) fail("BigInt rational division by zero");
  if (numerator === 0n) return [0n, 1n];
  if (denominator < 0n) {
    numerator = -numerator;
    denominator = -denominator;
  }
  const divisor = bigintGcd(numerator, denominator);
  return [numerator / divisor, denominator / divisor];
}

function rationalSubtract(a, b) {
  return rationalNormalizeBig(a[0] * b[1] - b[0] * a[1], a[1] * b[1]);
}

function rationalMultiply(a, b) {
  return rationalNormalizeBig(a[0] * b[0], a[1] * b[1]);
}

function rationalDivide(a, b) {
  return rationalNormalizeBig(a[0] * b[1], a[1] * b[0]);
}

function rationalScaleBig(a, numerator, denominator = 1n) {
  return rationalNormalizeBig(a[0] * numerator, a[1] * denominator);
}

function rationalCeilingDecimal(a, digits = 15) {
  if (a[0] < 0n) fail("decimal ceiling helper expects a nonnegative rational");
  const scale = 10n ** BigInt(digits);
  const scaled = (a[0] * scale + a[1] - 1n) / a[1];
  const whole = scaled / scale;
  const fractionText = String(scaled % scale).padStart(digits, "0");
  return `${whole}.${fractionText}`;
}

function rationalSignedCeilingDecimal(a, digits = 15) {
  const scale = 10n ** BigInt(digits);
  let scaled;
  if (a[0] >= 0n) {
    scaled = (a[0] * scale + a[1] - 1n) / a[1];
  } else {
    // BigInt division truncates toward zero, which is ceiling for negatives.
    scaled = (a[0] * scale) / a[1];
  }
  const negative = scaled < 0n;
  const magnitude = negative ? -scaled : scaled;
  const whole = magnitude / scale;
  const fractionText = String(magnitude % scale).padStart(digits, "0");
  return `${negative ? "-" : ""}${whole}.${fractionText}`;
}

function logAtanhInterval(z, terms) {
  const zSquared = rationalMultiply(z, z);
  let power = z;
  let sum = [0n, 1n];
  for (let j = 0; j < terms; j += 1) {
    sum = rationalAdd(sum, rationalScaleBig(power, 1n, BigInt(2 * j + 1)));
    power = rationalMultiply(power, zSquared);
  }
  const lower = rationalScaleBig(sum, 2n);
  const tailDenominator = rationalMultiply(
    [BigInt(2 * terms + 1), 1n],
    rationalSubtract([1n, 1n], zSquared),
  );
  const tail = rationalScaleBig(rationalDivide(power, tailDenominator), 2n);
  return [lower, rationalAdd(lower, tail)];
}

const fixedLn2LowerCache = new Map();

function ceilDividePositive(numerator, denominator) {
  return (numerator + denominator - 1n) / denominator;
}

/*
 * Directed fixed-point atanh series.  This is substantially faster than
 * carrying the fully reduced rational sum through 90 terms.  Every product
 * in an upper chain is rounded up; every product in the ln(2) lower chain is
 * rounded down.  The final quotient is therefore an outward upper bound.
 */
function log2UpperRational(value, terms) {
  if (value[0] <= 0n) fail("log2 requires a positive rational");
  const scale = BigInt(OUTWARD_BOUNDS.integerScale);
  let numerator = value[0];
  let denominator = value[1];
  let integerPart = 0;
  while (numerator < denominator) {
    numerator *= 2n;
    integerPart -= 1;
  }
  while (numerator >= 2n * denominator) {
    denominator *= 2n;
    integerPart += 1;
  }
  const zNumerator = numerator - denominator;
  const zDenominator = numerator + denominator;
  const zUpper = ceilDividePositive(zNumerator * scale, zDenominator);
  const zSquaredUpper = ceilDividePositive(zUpper * zUpper, scale);
  let powerUpper = zUpper;
  let sumUpper = 0n;
  for (let j = 0; j < terms; j += 1) {
    sumUpper += ceilDividePositive(powerUpper, BigInt(2 * j + 1));
    powerUpper = ceilDividePositive(powerUpper * zSquaredUpper, scale);
  }
  const oneMinusZSquaredLower = scale - zSquaredUpper;
  const tailUpper = ceilDividePositive(
    2n * powerUpper * scale,
    BigInt(2 * terms + 1) * oneMinusZSquaredLower,
  );
  const lnMantissaUpper = 2n * sumUpper + tailUpper;

  const cacheKey = `${terms}|${scale}`;
  let ln2Lower = fixedLn2LowerCache.get(cacheKey);
  if (ln2Lower === undefined) {
    const zLower = scale / 3n;
    const zSquaredLower = (zLower * zLower) / scale;
    let powerLower = zLower;
    let sumLower = 0n;
    for (let j = 0; j < terms; j += 1) {
      sumLower += powerLower / BigInt(2 * j + 1);
      powerLower = (powerLower * zSquaredLower) / scale;
    }
    ln2Lower = 2n * sumLower;
    fixedLn2LowerCache.set(cacheKey, ln2Lower);
  }
  const fractionalUpper = ceilDividePositive(
    lnMantissaUpper * scale,
    ln2Lower,
  );
  return rationalNormalizeBig(
    BigInt(integerPart) * scale + fractionalUpper,
    scale,
  );
}

function validateOutwardBounds(certificate) {
  assertEqual(
    BigInt(certificate.integerScale),
    10n ** 40n,
    "outward integer scale",
  );
  assertEqual(certificate.logSeriesTerms, 90, "outward log-series terms");
  const zero = [0n, 1n];
  for (const [name, interval] of Object.entries(certificate.parameterBox)) {
    const lower = decimalRational(interval[0]);
    const upper = decimalRational(interval[1]);
    if (rationalCompare(zero, lower) >= 0 || rationalCompare(lower, upper) > 0) {
      fail(`invalid outward parameter interval ${name}`);
    }
  }
  for (const [name, bound] of Object.entries(certificate.halfEnvelopeUpper)) {
    if (rationalCompare(decimalRational(bound), zero) <= 0) {
      fail(`half envelope ${name} is not positive`);
    }
  }
  const allowance = decimalRational(certificate.uniformAllowance);
  for (const [name, bound] of Object.entries(certificate.finalUpper)) {
    const allowedUpper = rationalAdd(decimalRational(bound), allowance);
    if (rationalCompare(allowedUpper, zero) >= 0) {
      fail(`outward final bound ${name} is not negative after allowance`);
    }
  }
}

function ternaryVectors() {
  const out = [];
  for (let code = 0; code < 81; code += 1) {
    let q = code;
    const v = [];
    for (let i = 0; i < 4; i += 1) {
      v.push((q % 3) - 1);
      q = Math.floor(q / 3);
    }
    out.push(v);
  }
  out.sort(compareVectors);
  return out;
}

function compareVectors(a, b) {
  for (let i = 0; i < a.length; i += 1) {
    if (a[i] !== b[i]) return a[i] - b[i];
  }
  return 0;
}

function activityMask(s) {
  let mask = 0;
  for (let i = 0; i < 4; i += 1) {
    if (s[i] !== 0) mask |= 1 << i;
  }
  return mask;
}

function boundaryEdges(s) {
  const active = s.map((x) => x !== 0);
  const boundary = [];
  for (let e = 0; e < 4; e += 1) {
    const [i, j] = EDGES[e];
    if (active[i] !== active[j]) boundary.push(e);
  }
  return boundary;
}

function buildAlphabet(ternary) {
  const alphabet = [];
  for (const s of ternary) {
    const boundary = boundaryEdges(s);
    for (let signs = 0; signs < 1 << boundary.length; signs += 1) {
      const eta = [0, 0, 0, 0];
      for (let j = 0; j < boundary.length; j += 1) {
        eta[boundary[j]] = (signs >> j) & 1 ? 1 : -1;
      }
      alphabet.push({
        s,
        eta,
        mask: activityMask(s),
        weight16: 16 >> boundary.length,
      });
    }
  }
  alphabet.sort((a, b) =>
    compareVectors(a.s, b.s) || compareVectors(a.eta, b.eta),
  );
  return alphabet;
}

function alphabetSerialization(alphabet) {
  const records = alphabet.map(
    ({ s, eta, weight16 }) => `${s.join(",")};${eta.join(",")};${weight16}`,
  );
  return [...records].sort().join("\n");
}

/*
 * Row-reduce [S | I].  Only the first four columns are eligible pivots.
 * On success return the canonical RREF of S and the exact row-operation
 * matrix T satisfying rrefS = T*S.
 */
function rrefTransform(integerRows) {
  const k = integerRows.length;
  const aug = integerRows.map((row, i) => [
    ...row.map((x) => frac(x)),
    ...Array.from({ length: k }, (_, j) => frac(i === j ? 1 : 0)),
  ]);
  const pivots = [];
  let pivotRow = 0;
  for (let col = 0; col < 4 && pivotRow < k; col += 1) {
    let selected = pivotRow;
    while (selected < k && fisZero(aug[selected][col])) selected += 1;
    if (selected === k) continue;
    [aug[pivotRow], aug[selected]] = [aug[selected], aug[pivotRow]];
    const pivot = aug[pivotRow][col];
    for (let j = col; j < 4 + k; j += 1) {
      aug[pivotRow][j] = fdiv(aug[pivotRow][j], pivot);
    }
    for (let i = 0; i < k; i += 1) {
      if (i === pivotRow || fisZero(aug[i][col])) continue;
      const multiple = aug[i][col];
      for (let j = col; j < 4 + k; j += 1) {
        aug[i][j] = fsub(aug[i][j], fmul(multiple, aug[pivotRow][j]));
      }
    }
    pivots.push(col);
    pivotRow += 1;
  }
  if (pivotRow !== k) return null;
  return {
    pivots,
    rrefS: aug.map((row) => row.slice(0, 4)),
    transform: aug.map((row) => row.slice(4)),
  };
}

function commonDenominator(matrix) {
  let denominator = 1;
  for (const row of matrix) {
    for (const value of row) denominator = lcm(denominator, value[1]);
  }
  return denominator;
}

function scaledIntegerMatrix(matrix) {
  const denominator = commonDenominator(matrix);
  return {
    denominator,
    numerators: matrix.map((row) =>
      row.map(([n, d]) => n * (denominator / d)),
    ),
  };
}

function rrefSKey(rrefS) {
  return rrefS.map((row) => row.map(ftext).join(",")).join(";");
}

function graphKeyFromEta(rrefS, transformScaled, etaRows) {
  const { denominator, numerators } = transformScaled;
  const rows = [];
  for (let i = 0; i < rrefS.length; i += 1) {
    const eta = [];
    for (let e = 0; e < 4; e += 1) {
      let numerator = 0;
      for (let j = 0; j < etaRows.length; j += 1) {
        numerator += numerators[i][j] * etaRows[j][e];
      }
      eta.push(frac(numerator, denominator));
    }
    rows.push([...rrefS[i], ...eta].map(ftext).join(","));
  }
  return rows.join(";");
}

function parseGraphKey(key, k) {
  const flat = key.split(/[;,]/).map(parseFraction);
  if (flat.length !== k * 8) fail(`malformed graph key for k=${k}: ${key}`);
  return Array.from({ length: k }, (_, i) => flat.slice(8 * i, 8 * i + 8));
}

function groupAlphabetByS(alphabet) {
  const groups = [];
  let current = null;
  for (const letter of alphabet) {
    const key = letter.s.join(",");
    if (current === null || current.key !== key) {
      current = { key, s: letter.s, eta: [] };
      groups.push(current);
    }
    current.eta.push(letter.eta);
  }
  return groups.filter((group) => group.s.some((x) => x !== 0));
}

function enumerateGraphSpaces(groups, k) {
  const keys = new Set();
  const chosen = [];
  let independentSChoices = 0;
  let basisChoices = 0;

  function emitForChosen() {
    const transform = rrefTransform(chosen.map((group) => group.s));
    if (transform === null) return;
    independentSChoices += 1;
    const scaled = scaledIntegerMatrix(transform.transform);
    const etaRows = Array(k);

    function chooseEta(depth) {
      if (depth === k) {
        basisChoices += 1;
        keys.add(graphKeyFromEta(transform.rrefS, scaled, etaRows));
        return;
      }
      for (const eta of chosen[depth].eta) {
        etaRows[depth] = eta;
        chooseEta(depth + 1);
      }
    }
    chooseEta(0);
  }

  function chooseGroups(start, depth) {
    if (depth === k) {
      emitForChosen();
      return;
    }
    for (let i = start; i <= groups.length - (k - depth); i += 1) {
      chosen[depth] = groups[i];
      chooseGroups(i + 1, depth + 1);
    }
  }

  chooseGroups(0, 0);
  return { keys, independentSChoices, basisChoices };
}

function sumScaledRows(rows, coefficients, start, length) {
  let out = frac(0);
  for (let i = 0; i < rows.length; i += 1) {
    if (coefficients[i] !== 0) {
      out = fadd(out, fscale(rows[i][start + length], coefficients[i]));
    }
  }
  return out;
}

function graphClosure(key, k, ternary) {
  const rows = parseGraphKey(key, k);
  const pivots = [];
  for (const row of rows) {
    const pivot = row.slice(0, 4).findIndex((x) => !fisZero(x));
    if (pivot < 0) fail(`missing s-pivot in ${key}`);
    pivots.push(pivot);
  }
  const poly16 = Array(16).fill(0);
  let rowBits = 0;
  let etaBits = 0;
  let coactiveEdgeBits = 0;
  let supportEqualPairBits = (1 << ROW_PAIRS.length) - 1;
  let closureCount = 0;

  for (const s of ternary) {
    const coefficients = pivots.map((pivot) => s[pivot]);
    let inD = true;
    for (let j = 0; j < 4; j += 1) {
      const got = sumScaledRows(rows, coefficients, 0, j);
      if (!feq(got, frac(s[j]))) {
        inD = false;
        break;
      }
    }
    if (!inD) continue;

    const eta = [];
    let etaIntegral = true;
    for (let e = 0; e < 4; e += 1) {
      const value = sumScaledRows(rows, coefficients, 4, e);
      if (value[1] !== 1 || Math.abs(value[0]) > 1) {
        etaIntegral = false;
        break;
      }
      eta.push(value[0]);
    }
    if (!etaIntegral) continue;

    const boundary = boundaryEdges(s);
    const boundarySet = new Set(boundary);
    let allowed = true;
    for (let e = 0; e < 4; e += 1) {
      if (boundarySet.has(e) ? eta[e] === 0 : eta[e] !== 0) {
        allowed = false;
        break;
      }
    }
    if (!allowed) continue;

    closureCount += 1;
    const mask = activityMask(s);
    rowBits |= mask;
    for (let pair = 0; pair < ROW_PAIRS.length; pair += 1) {
      const [i, j] = ROW_PAIRS[pair];
      if ((s[i] === 0) !== (s[j] === 0)) {
        supportEqualPairBits &= ~(1 << pair);
      }
    }
    for (let e = 0; e < 4; e += 1) {
      if (eta[e] !== 0) etaBits |= 1 << e;
      const [i, j] = EDGES[e];
      if (s[i] !== 0 && s[j] !== 0) coactiveEdgeBits |= 1 << e;
    }
    poly16[mask] += 16 >> boundary.length;
  }

  return {
    closureCount,
    rowBits,
    etaBits,
    coactiveEdgeBits,
    supportEqualPairBits,
    poly16,
  };
}

function polynomialKey(poly16) {
  return poly16.join(",");
}

function evaluatePolynomialNumber(poly16, x, omittedCoordinate = -1) {
  let total = 0;
  for (let mask = 0; mask < 16; mask += 1) {
    if (poly16[mask] === 0) continue;
    let term = poly16[mask] / 16;
    for (let i = 0; i < 4; i += 1) {
      if (i !== omittedCoordinate && (mask & (1 << i)) !== 0) term *= x[i];
    }
    total += term;
  }
  return total;
}

function rowBoxWitnessNumber(poly16, p) {
  const x = Array(4).fill(p / (1 - p));
  for (let sweep = 0; sweep < 10000; sweep += 1) {
    let largestRelativeChange = 0;
    for (let i = 0; i < 4; i += 1) {
      let inactive = 0;
      let active = 0;
      for (let mask = 0; mask < 16; mask += 1) {
        if (poly16[mask] === 0) continue;
        let term = poly16[mask] / 16;
        for (let j = 0; j < 4; j += 1) {
          if (j !== i && (mask & (1 << j)) !== 0) term *= x[j];
        }
        if ((mask & (1 << i)) === 0) inactive += term;
        else active += term;
      }
      if (!(inactive > 0 && active > 0)) {
        fail(`row-inactive polynomial passed row-active ledger: ${poly16}`);
      }
      const updated = Math.min(1, (p * inactive) / ((1 - p) * active));
      largestRelativeChange = Math.max(
        largestRelativeChange,
        Math.abs(updated - x[i]) / Math.max(updated, x[i], 1e-300),
      );
      x[i] = updated;
    }
    if (largestRelativeChange < 1e-14) break;
    if (sweep === 9999) fail(`coordinate dual did not converge: ${poly16}`);
  }
  if (!x.every((value) => value > 0 && value <= 1)) {
    fail(`row-box witness fugacity not in (0,1]: ${x}`);
  }
  const z = evaluatePolynomialNumber(poly16, x);
  const value = Math.log2(z) - p * x.reduce((sum, value) => sum + Math.log2(value), 0);
  return { x, value };
}

function evaluatePolynomialRational(poly16, x) {
  let total = [0n, 1n];
  for (let mask = 0; mask < 16; mask += 1) {
    if (poly16[mask] === 0) continue;
    let term = rationalNormalizeBig(BigInt(poly16[mask]), 16n);
    for (let i = 0; i < 4; i += 1) {
      if ((mask & (1 << i)) !== 0) term = rationalMultiply(term, x[i]);
    }
    total = rationalAdd(total, term);
  }
  return total;
}

function certifyRowBoxPolynomial(poly16, pUpperText, terms) {
  const pNumber = Number(pUpperText);
  const numerical = rowBoxWitnessNumber(poly16, pNumber);
  const xText = numerical.x.map((value) => value.toFixed(24));
  const x = xText.map(decimalRational);
  if (
    x.some(
      (value) =>
        rationalCompare(value, [0n, 1n]) <= 0 ||
        rationalCompare(value, [1n, 1n]) > 0,
    )
  ) {
    fail(`rounded row-box fugacity is not in (0,1]: ${xText}`);
  }
  const z = evaluatePolynomialRational(poly16, x);
  let upper = log2UpperRational(z, terms);
  const pUpper = decimalRational(pUpperText);
  for (const fugacity of x) {
    upper = rationalAdd(
      upper,
      rationalMultiply(
        pUpper,
        log2UpperRational(rationalDivide([1n, 1n], fugacity), terms),
      ),
    );
  }
  return {
    xText,
    numericalValue: numerical.value,
    upper,
    upperText: rationalCeilingDecimal(upper, 15),
  };
}

function certifyRowBoxFamily(polynomialKeys, pUpperText, terms) {
  let winner = null;
  const ledgerRows = [];
  for (const key of [...polynomialKeys].sort()) {
    const poly16 = key.split(",").map(Number);
    const certified = certifyRowBoxPolynomial(poly16, pUpperText, terms);
    ledgerRows.push(
      `${key}|${certified.xText.join(",")}|${certified.upperText}`,
    );
    if (winner === null || rationalCompare(certified.upper, winner.upper) > 0) {
      winner = { poly16, ...certified };
    }
  }
  if (winner === null) {
    return {
      polynomialCount: 0,
      ledgerSha256: canonicalLinesHash([]),
      upper: null,
      witnessPolynomial16: null,
      witnessFugacity: null,
    };
  }
  return {
    polynomialCount: polynomialKeys.size,
    ledgerSha256: canonicalLinesHash(ledgerRows),
    upper: winner.upperText,
    numericalAtWitness: winner.numericalValue.toFixed(15),
    witnessPolynomial16: winner.poly16,
    witnessFugacity: winner.xText,
    scope:
      `all independent row rates alpha_i in [0,${pUpperText}]; ` +
      "the fixed witness has every x_i<=1, so replacing alpha_i by the " +
      "upper endpoint only increases its dual objective",
  };
}

function jointExponentUpper(leftText, rightText, h, g, cRel, rEta) {
  const left = decimalRational(leftText);
  const right = decimalRational(rightText);
  const aCoefficient = h + g - cRel - 4 + rEta;
  const aText =
    aCoefficient >= 0
      ? OUTWARD_BOUNDS.parameterBox.a[1]
      : OUTWARD_BOUNDS.parameterBox.a[0];
  let upper = rationalScaleBig(rationalAdd(left, right), 6n);
  upper = rationalAdd(upper, [BigInt(-4 + cRel - rEta), 1n]);
  upper = rationalAdd(
    upper,
    rationalScaleBig(decimalRational(aText), BigInt(aCoefficient)),
  );
  upper = rationalAdd(upper, decimalRational(OUTWARD_BOUNDS.uniformAllowance));
  return {
    h,
    g,
    cRel,
    rEtaLower: rEta,
    leftHalfUpper: leftText,
    rightHalfUpper: rightText,
    aEndpoint: aText,
    uniformAllowance: OUTWARD_BOUNDS.uniformAllowance,
    upper: rationalSignedCeilingDecimal(upper, 15),
    exactUpper: upper,
  };
}

function certifyOmittedPairPartition(rowBoxEnvelopes) {
  const full = OUTWARD_BOUNDS.halfEnvelopeUpper.k4;
  const oldH1 = OUTWARD_BOUNDS.halfEnvelopeUpper.k3;
  const oldH2 = OUTWARD_BOUNDS.halfEnvelopeUpper.k2;
  const line = OUTWARD_BOUNDS.halfEnvelopeUpper.k1;
  const newH1 = rowBoxEnvelopes[3].upper;
  const newH2 = rowBoxEnvelopes[2].upper;
  const specs = {
    h1_full: [newH1, full, 1, 0, 0, 0],
    h2_full: [newH2, full, 2, 0, 0, 0],
    h1_same_W: [newH1, newH1, 1, 1, 1, 0],
    h1_same_D_distinct_W: [newH1, oldH1, 1, 1, 1, 1],
    h1_distinct_D: [newH1, oldH1, 1, 1, 0, 0],
    h1_h2_contained_new_h1: [newH1, oldH2, 1, 2, 1, 0],
    h1_h2_contained_new_h2: [oldH1, newH2, 1, 2, 1, 0],
    h1_line_contained: [newH1, line, 1, 3, 1, 0],
    h2_same_W: [newH2, newH2, 2, 2, 2, 0],
    h2_same_D_distinct_W: [newH2, oldH2, 2, 2, 2, 1],
    h2_distinct_D_max_intersection: [newH2, oldH2, 2, 2, 1, 0],
    h2_line_contained: [newH2, line, 2, 3, 2, 0],
  };
  const bounds = {};
  for (const [name, args] of Object.entries(specs)) {
    const certified = jointExponentUpper(...args);
    if (rationalCompare(certified.exactUpper, [0n, 1n]) >= 0) {
      fail(`nonnegative omitted-pair partition ${name}: ${certified.upper}`);
    }
    const { exactUpper: _exactUpper, ...serializable } = certified;
    bounds[name] = serializable;
  }
  return {
    formula:
      "6*(F_L+F_R)-4*(1+a)+a*(h+g-c_rel)+c_rel" +
      "-r_eta*(1-a), with the a-box endpoint chosen outward",
    coverage:
      "At least one half is edge-omitted. The other half uses the larger " +
      "of its old edge-complete and new edge-omitted envelope. For equal " +
      "deficiency: identical D splits into same W and distinct W; distinct " +
      "W forces r_eta>=1. Distinct D uses the largest possible c_rel. " +
      "For unequal deficiency, containment gives the largest c_rel; the " +
      "non-contained cases are smaller. Per-half automatic and signed-row " +
      "labels are not used as deletions.",
    bounds,
  };
}

function graphForcesAutomaticEdge(rows, edge) {
  const [left, right] = EDGES[edge];
  for (const leftSign of [-1, 1]) {
    for (const rightSign of [-1, 1]) {
      const holds = rows.every((row) =>
        feq(
          row[4 + edge],
          fadd(fscale(row[left], leftSign), fscale(row[right], rightSign)),
        ),
      );
      if (holds) return `${leftSign},${rightSign}`;
    }
  }
  return null;
}

function graphSignedRowRepeats(rows) {
  const repeats = [];
  for (let i = 0; i < 4; i += 1) {
    for (let j = i + 1; j < 4; j += 1) {
      for (const sign of [-1, 1]) {
        if (rows.every((row) => feq(row[i], fscale(row[j], sign)))) {
          repeats.push(`${i},${j},${sign}`);
        }
      }
    }
  }
  return repeats;
}

function auditGraphLevel(rawKeys, k, ternary) {
  const legalKeys = [];
  const rowActiveKeys = [];
  const edgeOmittedKeys = [];
  const polynomialKeys = new Set();
  const rowActivePolynomialKeys = new Set();
  const edgeOmittedPolynomialKeys = new Set();
  const nonautomaticOmittedPolynomialKeys = new Set();
  const noAutomaticOrSignedRepeatPolynomialKeys = new Set();
  let rowInactive = 0;
  let edgeInactive = 0;
  let bothInactive = 0;
  const omittedClassification = {
    anyAutomaticEdge: 0,
    everyMissingEdgeAutomatic: 0,
    noAutomaticEdge: 0,
    signedRowRepeat: 0,
    supportRowRepeat: 0,
    noAutomaticOrSignedRepeat: 0,
    noAutomaticOrSupportRepeat: 0,
  };
  let processed = 0;
  for (const key of rawKeys) {
    const closure = graphClosure(key, k, ternary);
    const rowOk = closure.rowBits === 15;
    const edgeOk = closure.coactiveEdgeBits === 15;
    if (!rowOk) rowInactive += 1;
    if (!edgeOk) edgeInactive += 1;
    if (!rowOk && !edgeOk) bothInactive += 1;
    if (rowOk) {
      rowActiveKeys.push(key);
      rowActivePolynomialKeys.add(polynomialKey(closure.poly16));
    }
    if (rowOk && edgeOk) {
      legalKeys.push(key);
      polynomialKeys.add(polynomialKey(closure.poly16));
    }
    if (rowOk && !edgeOk) {
      edgeOmittedKeys.push(key);
      edgeOmittedPolynomialKeys.add(polynomialKey(closure.poly16));
      const rows = parseGraphKey(key, k);
      const missingEdges = [];
      const automaticEdges = [];
      for (let edge = 0; edge < 4; edge += 1) {
        if ((closure.coactiveEdgeBits & (1 << edge)) === 0) {
          missingEdges.push(edge);
          if (graphForcesAutomaticEdge(rows, edge) !== null) {
            automaticEdges.push(edge);
          }
        }
      }
      const hasAutomatic = automaticEdges.length > 0;
      const allAutomatic = automaticEdges.length === missingEdges.length;
      const hasSignedRepeat = graphSignedRowRepeats(rows).length > 0;
      const hasSupportRepeat = closure.supportEqualPairBits !== 0;
      if (hasAutomatic) omittedClassification.anyAutomaticEdge += 1;
      if (allAutomatic) omittedClassification.everyMissingEdgeAutomatic += 1;
      if (!hasAutomatic) omittedClassification.noAutomaticEdge += 1;
      if (hasSignedRepeat) omittedClassification.signedRowRepeat += 1;
      if (hasSupportRepeat) omittedClassification.supportRowRepeat += 1;
      if (!hasAutomatic && !hasSignedRepeat) {
        omittedClassification.noAutomaticOrSignedRepeat += 1;
      }
      if (!hasAutomatic && !hasSupportRepeat) {
        omittedClassification.noAutomaticOrSupportRepeat += 1;
      }
      if (!hasAutomatic) {
        nonautomaticOmittedPolynomialKeys.add(polynomialKey(closure.poly16));
      }
      if (!hasAutomatic && !hasSignedRepeat) {
        noAutomaticOrSignedRepeatPolynomialKeys.add(
          polynomialKey(closure.poly16),
        );
      }
    }
    processed += 1;
    if (processed % 50000 === 0) {
      process.stderr.write(`  k=${k}: exact closures ${processed}/${rawKeys.size}\n`);
    }
  }
  legalKeys.sort();
  rowActiveKeys.sort();
  edgeOmittedKeys.sort();
  return {
    legalKeys,
    rowActiveKeys,
    edgeOmittedKeys,
    polynomialKeys,
    rowActivePolynomialKeys,
    edgeOmittedPolynomialKeys,
    nonautomaticOmittedPolynomialKeys,
    noAutomaticOrSignedRepeatPolynomialKeys,
    deletionCounts: { rowInactive, edgeInactive, bothInactive },
    omittedClassification,
  };
}

function subspaceKeyFromRows(integerRows) {
  const transform = rrefTransform(integerRows);
  if (transform === null) return null;
  return rrefSKey(transform.rrefS);
}

function parseSubspaceKey(key, k) {
  const flat = key.split(/[;,]/).map(parseFraction);
  if (flat.length !== k * 4) fail(`malformed subspace key: ${key}`);
  return Array.from({ length: k }, (_, i) => flat.slice(4 * i, 4 * i + 4));
}

function enumerateCubeSections(nonzeroTernary, k) {
  const keys = new Set();
  const chosen = [];
  function choose(start, depth) {
    if (depth === k) {
      const key = subspaceKeyFromRows(chosen);
      if (key !== null) keys.add(key);
      return;
    }
    for (
      let i = start;
      i <= nonzeroTernary.length - (k - depth);
      i += 1
    ) {
      chosen[depth] = nonzeroTernary[i];
      choose(i + 1, depth + 1);
    }
  }
  choose(0, 0);
  return keys;
}

function subspaceActivity(key, k, ternary) {
  const rows = parseSubspaceKey(key, k);
  const pivots = [];
  for (const row of rows) {
    const pivot = row.findIndex((x) => !fisZero(x));
    if (pivot < 0) fail(`missing subspace pivot: ${key}`);
    pivots.push(pivot);
  }
  const masks = new Set();
  let rowBits = 0;
  for (const s of ternary) {
    const coefficients = pivots.map((pivot) => s[pivot]);
    let inside = true;
    for (let j = 0; j < 4; j += 1) {
      let got = frac(0);
      for (let i = 0; i < k; i += 1) {
        got = fadd(got, fscale(rows[i][j], coefficients[i]));
      }
      if (!feq(got, frac(s[j]))) {
        inside = false;
        break;
      }
    }
    if (!inside) continue;
    const mask = activityMask(s);
    masks.add(mask);
    rowBits |= mask;
  }
  return { masks: [...masks].sort((a, b) => a - b), rowBits };
}

function solveSquare(matrix, rhs) {
  const n = matrix.length;
  const aug = matrix.map((row, i) => [
    ...row.map((x) => frac(x)),
    frac(rhs[i]),
  ]);
  let pivotRow = 0;
  for (let col = 0; col < n; col += 1) {
    let selected = pivotRow;
    while (selected < n && fisZero(aug[selected][col])) selected += 1;
    if (selected === n) return null;
    [aug[pivotRow], aug[selected]] = [aug[selected], aug[pivotRow]];
    const pivot = aug[pivotRow][col];
    for (let j = col; j <= n; j += 1) {
      aug[pivotRow][j] = fdiv(aug[pivotRow][j], pivot);
    }
    for (let i = 0; i < n; i += 1) {
      if (i === pivotRow || fisZero(aug[i][col])) continue;
      const multiple = aug[i][col];
      for (let j = col; j <= n; j += 1) {
        aug[i][j] = fsub(aug[i][j], fmul(multiple, aug[pivotRow][j]));
      }
    }
    pivotRow += 1;
  }
  return aug.map((row) => row[n]);
}

function combinations(items, size, callback) {
  const selected = [];
  function visit(start, depth) {
    if (depth === size) {
      callback(selected);
      return;
    }
    for (let i = start; i <= items.length - (size - depth); i += 1) {
      selected[depth] = items[i];
      visit(i + 1, depth + 1);
    }
  }
  visit(0, 0);
}

/*
 * By conic Caratheodory in R^4, 1=(1,1,1,1) is in the cone generated by
 * the activity masks iff it has a nonnegative representation using at most
 * four linearly independent generators.  Enumerating square coordinate
 * minors avoids any floating point LP tolerance.
 */
function hasEqualPositiveCone(nonzeroMasks) {
  const generators = nonzeroMasks.map((mask) =>
    Array.from({ length: 4 }, (_, i) => (mask >> i) & 1),
  );
  for (let size = 1; size <= Math.min(4, generators.length); size += 1) {
    let found = false;
    combinations(
      Array.from({ length: generators.length }, (_, i) => i),
      size,
      (indices) => {
        if (found) return;
        combinations([0, 1, 2, 3], size, (coordinates) => {
          if (found) return;
          const square = coordinates.map((coordinate) =>
            indices.map((index) => generators[index][coordinate]),
          );
          const solution = solveSquare(square, Array(size).fill(1));
          if (solution === null || !solution.every(fisNonnegative)) return;
          for (let coordinate = 0; coordinate < 4; coordinate += 1) {
            let got = frac(0);
            for (let j = 0; j < size; j += 1) {
              got = fadd(
                got,
                fscale(solution[j], generators[indices[j]][coordinate]),
              );
            }
            if (!feq(got, frac(1))) return;
          }
          found = true;
        });
      },
    );
    if (found) return true;
  }
  return false;
}

function auditCubeSections(ternary) {
  const nonzero = ternary.filter((s) => s.some((x) => x !== 0));
  const levels = {};
  for (const k of [1, 2, 3]) {
    process.stderr.write(`enumerating rational cube sections k=${k}\n`);
    const keys = enumerateCubeSections(nonzero, k);
    const rowActive = [];
    for (const key of keys) {
      const activity = subspaceActivity(key, k, ternary);
      if (activity.rowBits === 15) rowActive.push({ key, ...activity });
    }
    rowActive.sort((a, b) => a.key.localeCompare(b.key));
    levels[k] = { keys, rowActive };
  }

  const feasible = [];
  const newborn = [];
  for (const plane of levels[2].rowActive) {
    const nonzeroMasks = plane.masks.filter((mask) => mask !== 0);
    const record = { key: plane.key, masks: nonzeroMasks };
    if (hasEqualPositiveCone(nonzeroMasks)) feasible.push(record);
    else newborn.push(record);
  }
  feasible.sort((a, b) => a.key.localeCompare(b.key));
  newborn.sort((a, b) => a.key.localeCompare(b.key));
  return { levels, feasible, newborn };
}

function checkNewbornShape(newborn) {
  const threeSupportMasks = new Set([7, 11, 13, 14]);
  const pairHistogram = new Map();
  for (const plane of newborn) {
    if (
      plane.masks.length !== 2 ||
      !plane.masks.every((mask) => threeSupportMasks.has(mask))
    ) {
      fail(
        `unexpected newborn activity masks for ${plane.key}: ${plane.masks.join(",")}`,
      );
    }
    const pair = plane.masks.join(",");
    pairHistogram.set(pair, (pairHistogram.get(pair) ?? 0) + 1);
  }
  return Object.fromEntries([...pairHistogram.entries()].sort());
}

function canonicalLinesHash(lines) {
  return sha256(`${[...lines].sort().join("\n")}\n`);
}

async function main() {
  const summaryOnly = process.argv.includes("--summary");
  const ternary = ternaryVectors();
  const alphabet = buildAlphabet(ternary);
  assertEqual(alphabet.length, EXPECTED.alphabetCount, "alphabet count");
  const alphabetSha = sha256(alphabetSerialization(alphabet));
  assertEqual(alphabetSha, EXPECTED.alphabetSha256, "alphabet SHA256");
  process.stderr.write(`alphabet: ${alphabet.length}, SHA256=${alphabetSha}\n`);

  const groups = groupAlphabetByS(alphabet);
  const graphLevels = {};
  const globalPolynomials = new Set();
  for (const k of [1, 2, 3]) {
    process.stderr.write(`enumerating all independent alphabet bases k=${k}\n`);
    const raw = enumerateGraphSpaces(groups, k);
    assertEqual(raw.keys.size, EXPECTED.rawGraphCounts[k], `raw graphs k=${k}`);
    process.stderr.write(
      `  raw=${raw.keys.size}, s-bases=${raw.independentSChoices}, alphabet-bases=${raw.basisChoices}\n`,
    );
    const audited = auditGraphLevel(raw.keys, k, ternary);
    assertEqual(
      audited.legalKeys.length,
      EXPECTED.legalGraphCounts[k],
      `legal graphs k=${k}`,
    );
    assertEqual(
      audited.polynomialKeys.size,
      EXPECTED.levelPolynomialCounts[k],
      `polynomials k=${k}`,
    );
    assertEqual(
      audited.rowActiveKeys.length,
      EXPECTED.rowActiveGraphCounts[k],
      `row-active graphs k=${k}`,
    );
    assertEqual(
      audited.edgeOmittedKeys.length,
      EXPECTED.edgeOmittedGraphCounts[k],
      `edge-omitted graphs k=${k}`,
    );
    assertEqual(
      audited.rowActivePolynomialKeys.size,
      EXPECTED.rowActiveLevelPolynomialCounts[k],
      `row-active polynomials k=${k}`,
    );
    assertEqual(
      audited.edgeOmittedPolynomialKeys.size,
      EXPECTED.edgeOmittedLevelPolynomialCounts[k],
      `edge-omitted polynomials k=${k}`,
    );
    for (const key of audited.polynomialKeys) globalPolynomials.add(key);
    graphLevels[k] = { raw, audited };
    process.stderr.write(
      `  row-active=${audited.rowActiveKeys.length}, edge-complete=${audited.legalKeys.length}, ` +
        `polynomials=${audited.rowActivePolynomialKeys.size}\n`,
    );
  }
  assertEqual(
    globalPolynomials.size,
    EXPECTED.polynomialCount,
    "global polynomial count",
  );

  const newRowBoxEnvelopes = {};
  for (const k of [2, 3]) {
    const family = graphLevels[k].audited.edgeOmittedPolynomialKeys;
    process.stderr.write(
      `certifying row-box envelope k=${k}, all edge-omitted polynomials=${family.size}\n`,
    );
    newRowBoxEnvelopes[k] = certifyRowBoxFamily(
      family,
      OUTWARD_BOUNDS.parameterBox.p[1],
      OUTWARD_BOUNDS.logSeriesTerms,
    );
  }
  const omittedPairPartition = certifyOmittedPairPartition(
    newRowBoxEnvelopes,
  );

  const cube = auditCubeSections(ternary);
  for (const k of [1, 2, 3]) {
    assertEqual(
      cube.levels[k].keys.size,
      EXPECTED.cubeSectionCounts[k],
      `cube sections k=${k}`,
    );
    assertEqual(
      cube.levels[k].rowActive.length,
      EXPECTED.rowActiveCubeSectionCounts[k],
      `row-active cube sections k=${k}`,
    );
  }
  assertEqual(
    cube.feasible.length,
    EXPECTED.equalPositiveRankTwoCount,
    "equal-positive rank-two sections",
  );
  assertEqual(
    cube.newborn.length,
    EXPECTED.mixedNewbornCount,
    "mixed-newborn rank-two sections",
  );
  const newbornPairHistogram = checkNewbornShape(cube.newborn);

  const manifest = {
    serializationVersion: SERIALIZATION_VERSION,
    alphabet: {
      count: alphabet.length,
      sha256: alphabetSha,
    },
    graphs: Object.fromEntries(
      [1, 2, 3].map((k) => [
        k,
        {
          rawCount: graphLevels[k].raw.keys.size,
          rowActiveCount: graphLevels[k].audited.rowActiveKeys.length,
          edgeCompleteCount: graphLevels[k].audited.legalKeys.length,
          edgeOmittedCount: graphLevels[k].audited.edgeOmittedKeys.length,
          edgeCompleteDistinctPolynomialCount:
            graphLevels[k].audited.polynomialKeys.size,
          rowActiveDistinctPolynomialCount:
            graphLevels[k].audited.rowActivePolynomialKeys.size,
          edgeOmittedDistinctPolynomialCount:
            graphLevels[k].audited.edgeOmittedPolynomialKeys.size,
          nonautomaticEdgeOmittedDistinctPolynomialCount:
            graphLevels[k].audited.nonautomaticOmittedPolynomialKeys.size,
          noAutomaticOrSignedRepeatDistinctPolynomialCount:
            graphLevels[k].audited.noAutomaticOrSignedRepeatPolynomialKeys.size,
          rawMapSha256: canonicalLinesHash(graphLevels[k].raw.keys),
          rowActiveMapSha256: canonicalLinesHash(
            graphLevels[k].audited.rowActiveKeys,
          ),
          edgeCompleteMapSha256: canonicalLinesHash(
            graphLevels[k].audited.legalKeys,
          ),
          edgeOmittedMapSha256: canonicalLinesHash(
            graphLevels[k].audited.edgeOmittedKeys,
          ),
          edgeCompletePolynomialSha256: canonicalLinesHash(
            graphLevels[k].audited.polynomialKeys,
          ),
          rowActivePolynomialSha256: canonicalLinesHash(
            graphLevels[k].audited.rowActivePolynomialKeys,
          ),
          edgeOmittedPolynomialSha256: canonicalLinesHash(
            graphLevels[k].audited.edgeOmittedPolynomialKeys,
          ),
          nonautomaticEdgeOmittedPolynomialSha256: canonicalLinesHash(
            graphLevels[k].audited.nonautomaticOmittedPolynomialKeys,
          ),
          noAutomaticOrSignedRepeatPolynomialSha256: canonicalLinesHash(
            graphLevels[k].audited.noAutomaticOrSignedRepeatPolynomialKeys,
          ),
          deletionCounts: graphLevels[k].audited.deletionCounts,
          edgeOmittedClassification:
            graphLevels[k].audited.omittedClassification,
        },
      ]),
    ),
    allLegalMapsSha256: canonicalLinesHash(
      [1, 2, 3].flatMap((k) =>
        graphLevels[k].audited.legalKeys.map((key) => `${k}|${key}`),
      ),
    ),
    polynomials: {
      count: globalPolynomials.size,
      sha256: canonicalLinesHash(globalPolynomials),
    },
    newRowBoxEnvelopes,
    omittedPairPartition,
    cubeSections: Object.fromEntries(
      [1, 2, 3].map((k) => [
        k,
        {
          rawCount: cube.levels[k].keys.size,
          rowActiveCount: cube.levels[k].rowActive.length,
          rawSha256: canonicalLinesHash(cube.levels[k].keys),
          rowActiveSha256: canonicalLinesHash(
            cube.levels[k].rowActive.map((entry) => entry.key),
          ),
        },
      ]),
    ),
    rankTwoActivityCone: {
      equalPositiveCount: cube.feasible.length,
      mixedNewbornCount: cube.newborn.length,
      mixedNewbornPairHistogram: newbornPairHistogram,
      mixedNewbornSha256: sha256(`${stableJson(cube.newborn)}\n`),
      mixedNewborn: cube.newborn,
      dominatingHalfPolynomial16: [
        16, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 0,
      ],
      explanation:
        "Each newborn has exactly two distinct three-support masks. " +
        "Writing their masses as u,v gives Z <= 1+u/2+v/2 and " +
        "activity marginals (u+v,u+v,u,v) up to coordinate permutation; " +
        "four equal positive marginals are impossible.",
    },
    originatingReplHashes: EXPECTED.originatingReplHashes,
  };
  const serialized = `${stableJson(manifest)}\n`;
  const manifestSha = sha256(serialized);
  assertEqual(
    manifestSha,
    EXPECTED.discreteManifestSha256,
    "discrete manifest SHA256",
  );
  validateOutwardBounds(OUTWARD_BOUNDS);
  const outwardSha = sha256(`${stableJson(OUTWARD_BOUNDS)}\n`);
  assertEqual(
    outwardSha,
    EXPECTED.outwardBoundsSha256,
    "outward-bounds SHA256",
  );
  const certificate = { discreteManifest: manifest, outwardBounds: OUTWARD_BOUNDS };
  const certificateSha = sha256(`${stableJson(certificate)}\n`);
  assertEqual(
    certificateSha,
    EXPECTED.fullCertificateSha256,
    "full certificate SHA256",
  );
  if (!summaryOnly) {
    process.stdout.write(`${JSON.stringify(certificate, null, 2)}\n`);
  }
  process.stdout.write(`discreteManifestSha256=${manifestSha}\n`);
  process.stdout.write(`outwardBoundsSha256=${outwardSha}\n`);
  process.stdout.write(`certificateSha256=${certificateSha}\n`);
}

main().catch((error) => {
  process.stderr.write(`${error.stack ?? error}\n`);
  process.exitCode = 1;
});

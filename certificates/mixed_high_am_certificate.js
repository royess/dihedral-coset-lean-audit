#!/usr/bin/env node
"use strict";

/*
 * Conditional-entropy verifier for the mixed high-cell automatic row-energy
 * (AM) ledger.  No optimizer is run: the 27 fugacity triples below are fixed
 * witnesses.  Arithmetic and logarithms use the rigorous interval routines
 * from mixed_high_mt_certificate.js.
 *
 * For one 3n block, after dividing by the source-cell mass, endpoint convexity
 * gives
 *
 *   g_D <= log2 Z_D(x)
 *          + p max(0,-log2 x0)
 *          + max(0,-p log2(x1*x2)-f(p)),
 *
 * where f(p)=H2(p)+p.  Analytically this equals a/3 at the exact saddle; the
 * executable interval below evaluates f(p) directly so that independently
 * rounded decimal inputs for p and a cannot create an inward error.  For
 * left/right masks the normalized class exponent is
 *
 *   6(g_L+g_R)-2(1+a)+a(h+g-c)+c.
 *
 * This is the mixed replacement for the balanced formula containing
 * -m_exp.  The unit/full class is removed by the exact unconditional centered
 * retention cancellation; common equality planes and line-line classes force
 * a repeated complete orbit and are absent from the distinct-index expansion.
 * The row energy is formed with K_off=K-I.  If u is the target and z,v are
 * the source leaves, then z!=u and v!=u; the repeated branch z=v!=u remains.
 */

const crypto = require("crypto");
const Q = require("./mixed_high_mt_certificate.js");

const p = Q.decimalFraction("0.020766264718131");
const a = Q.decimalFraction("0.499463451078382");
const one = [1n, 1n];
const zeroI = Q.interval([0n, 1n]);
const SOURCE_SUPPORT_LOWER = Q.decimalFraction("0.015");

function entropyPlusPInterval() {
  const oneMinusP = Q.fsub(one, p);
  const entropy = Q.iadd(
    Q.iscale(Q.ineg(Q.log2Interval(p)), p),
    Q.iscale(Q.ineg(Q.log2Interval(oneMinusP)), oneMinusP),
  );
  return Q.iadd(entropy, Q.interval(p));
}

const fP = entropyPlusPInterval();

// Sorted in the canonical mask-key order regenerated below.
const FIXED_X = [
  ["0.04073754965967273","0.02078348605145615","0.020783487498241715"],
  ["0.7536541024479633","0.02757695843056478","0.020783489364499082"],
  ["0.2005502384000339","0.020783489864705202","0.1036323238605059"],
  ["0.041849022881571614","0.01760504495627293","0.219249014131774"],
  ["0.9999999999999944","0.29716860019160857","0.012988884922295161"],
  ["0.9999999999999944","0.29716860019160857","0.012988884922295161"],
  ["0.9999999999999946","0.03404799305900834","0.11336611657899472"],
  ["0.9999999999999944","0.29716860019160857","0.012988884922295161"],
  ["0.1709983347554292","0.062128002963579516","0.0621280029340566"],
  ["2.3794800348221337","4.048552727083276e-17","95339964935800.2"],
  ["195.00709708151285","5.537362384633889e-20","921977863810774100000"],
  ["195.00709708151285","5.537362384633889e-20","921977863810774100000"],
  ["195.00709708151285","921977863810774100000","5.537362384633889e-20"],
  ["0.042495151443092016","0.18160138984891777","0.021254731330084264"],
  ["5.761350287388229e52","7.989298506570754e-17","6.426865255144374e32"],
  ["3.2112705431535504","0.058816471642429126","0.1145588439926888"],
  ["4.266543312580644","0.028831916882525854","0.13387555070082807"],
  ["3.2112705431535504","0.058816471642429126","0.1145588439926888"],
  ["2.3794800348221337","95339964935800.2","4.048552727083276e-17"],
  ["195.00709708151285","921977863810774100000","5.537362384633889e-20"],
  ["3.2112705431535504","0.058816471642429126","0.1145588439926888"],
  ["4.266543312580644","0.028831916882525854","0.13387555070082807"],
  ["5.761350287388229e52","6.426865255144374e32","7.989298506570754e-17"],
  ["4.266543312580644","0.028831916882525854","0.13387555070082807"],
  ["3.2112705431535504","0.058816471642429126","0.1145588439926888"],
  ["4.266543312580644","0.028831916882525854","0.13387555070082807"],
  ["3.2112705431535504","0.058816471642429126","0.1145588439926888"],
];

const BINARY_FIXED_X = [
  ["0.04073754524652396","0.020783489766793766","0.020783488025679395"],
  ["0.04192963292856389","0.13010632880573006","0.029667186722114797"],
  ["0.918391354929066","0.020783489670744306","0.022630316789032087"],
  ["0.2005502384000339","0.1036323238605059","0.020783489864705202"],
  ["0.17132774234680773","0.06212800413676369","0.06212800176086947"],
  ["0.9999999999999944","0.29716860019160857","0.012988884922295161"],
];

function maskKey(D) { return D.map(v => v.join("")).sort().join(";"); }

function masks() {
  const cube = Q.ternaryCube(3);
  const all = [cube];
  for (const k of [2, 1]) {
    for (const indices of Q.rationalMasks(3, k)) all.push(indices.map(i => cube[i]));
  }
  const dedup = new Map();
  for (const D of all) {
    if ([0, 1, 2].every(i => D.some(s => s[i] !== 0))) dedup.set(maskKey(D), D);
  }
  return [...dedup.values()].sort((A, B) => maskKey(A).localeCompare(maskKey(B)));
}

function localStates(D) {
  const out = [];
  for (const s of D) {
    let w = [1n, 1n];
    let legal = true;
    for (const j of [1, 2]) {
      const a0 = s[0] !== 0, aj = s[j] !== 0;
      if (a0 && aj && s[0] !== s[j]) { legal = false; break; }
      if (a0 !== aj) w = Q.fmul(w, [1n, 2n]);
    }
    if (legal) out.push({ s, w });
  }
  return out;
}

function evalZStates(states, xs) {
  const x = xs.map(Q.decimalFraction);
  let Z = [0n, 1n];
  for (const { s, w: w0 } of states) {
    let w = w0;
    for (let i = 0; i < 3; i += 1) if (s[i] !== 0) w = Q.fmul(w, x[i]);
    Z = Q.fadd(Z, w);
  }
  return Z;
}

function evalZ(D, xs) { return evalZStates(localStates(D), xs); }

function imaxZero(x) {
  if (Q.fcmp(x.hi, [0n, 1n]) <= 0) return zeroI;
  if (Q.fcmp(x.lo, [0n, 1n]) >= 0) return x;
  return Q.interval([0n, 1n], x.hi);
}

function gInterval(D, xs) {
  return gIntervalStates(localStates(D), xs);
}

function gIntervalStates(states, xs) {
  const lx = xs.map(s => Q.log2Interval(Q.decimalFraction(s)));
  let g = Q.log2Interval(evalZStates(states, xs));
  g = Q.iadd(g, Q.iscale(imaxZero(Q.ineg(lx[0])), p));
  const leaf = Q.isub(
    Q.iscale(Q.ineg(Q.iadd(lx[1], lx[2])), p),
    fP,
  );
  return Q.iadd(g, imaxZero(leaf));
}

function rankF2(vs) {
  const piv = [0, 0, 0]; let r = 0;
  for (let v of vs) for (let j = 2; j >= 0; j -= 1) if ((v >> j) & 1) {
    if (piv[j]) v ^= piv[j]; else { piv[j] = v; r += 1; break; }
  }
  return r;
}

function binarySubspaces(k) {
  const out = new Map(), nonzero = [1,2,3,4,5,6,7];
  function rec(start, base) {
    if (base.length === k) {
      const S=[]; for(let v=0;v<8;v+=1) if(rankF2(base.concat([v]))===k) S.push(v);
      out.set(S.join(","),S); return;
    }
    for(let q=start;q<nonzero.length;q+=1){const b=base.concat([nonzero[q]]);if(rankF2(b)>base.length)rec(q+1,b);}
  }
  rec(0,[]); return [...out.values()];
}

function binaryMasks() {
  const full=[0,1,2,3,4,5,6,7];
  const proper=[...binarySubspaces(2),...binarySubspaces(1)]
    .filter(S=>[0,1,2].every(i=>S.some(b=>(b>>i)&1)));
  return [full,...proper].sort((A,B)=>A.join(",").localeCompare(B.join(",")));
}

function binaryStates(S) {
  const out=[];
  for(const b of S){const ids=[0,1,2].filter(i=>(b>>i)&1);for(let q=0;q<(1<<ids.length);q+=1){
    const s=[0,0,0];ids.forEach((i,j)=>s[i]=((q>>j)&1)?1:-1);
    let w=[1n,1n],legal=true;for(const j of[1,2]){const a0=s[0]!==0,aj=s[j]!==0;
      if(a0&&aj&&s[0]!==s[j]){legal=false;break;}if(a0!==aj)w=Q.fmul(w,[1n,2n]);}
    if(legal)out.push({s,w});
  }}
  return out;
}

function equalityPlane(D) {
  for (let i = 0; i < 3; i += 1) for (let j = i + 1; j < 3; j += 1) {
    for (const t of [-1, 1]) if (D.every(s => s[i] === t * s[j])) return [i, j, t];
  }
  return null;
}

function relationDimension(A, B) { return 3 - Q.rankQ(A.concat(B), 3); }

function classInterval(L, R) {
  let out = Q.iscale(Q.iadd(L.g, R.g), [6n, 1n]);
  out = Q.isub(out, Q.iscale(Q.interval(Q.fadd(one, a)), [2n, 1n]));
  const c = relationDimension(L.D, R.D);
  const gain = Q.fadd(Q.fmul(a, [BigInt(L.h + R.h - c), 1n]), [BigInt(c), 1n]);
  out = Q.iadd(out, Q.interval(gain));
  return { out, c };
}

function deletionReason(L, R) {
  if (L.h === 0 && R.h === 0) return "unit-centered-cancellation";
  const eL = equalityPlane(L.D), eR = equalityPlane(R.D);
  if (eL && eR && eL.join(",") === eR.join(",")) return "same-equality-repeated-orbit";
  if (L.h === 2 && R.h === 2) return "line-line-repeated-orbit";
  return "";
}

// Repeated-pair branch z=v!=u.  For a generic half the squared-kernel
// conditional partition, at target fugacity x, is
//   A=1+x/2  when the source is inactive,
//   B=1/4+x  when the source is active.
// Choosing x=2p/(1-p) fixes the target activity at p when the source is
// inactive and gives the uniform affine bound G<=g0-c*rho.  Jensen turns the
// high source-cell condition into sum_b rho_b>=4*x_(s_H).  The high theorem
// chooses its fixed extension small enough that x_(s_H)>=0.015.
function repeatedPairBounds() {
  const x=Q.fdiv(Q.fmul([2n,1n],p),Q.fsub(one,p));
  const A=Q.fadd(one,Q.fdiv(x,[2n,1n]));
  const B=Q.fadd([1n,4n],x);
  const lx=Q.log2Interval(x),lA=Q.log2Interval(A),lB=Q.log2Interval(B);
  const g0=Q.isub(lA,Q.iscale(lx,p));
  const slope=Q.isub(lA,lB);
  let gg=Q.iscale(g0,[12n,1n]);
  gg=Q.isub(gg,Q.iscale(slope,Q.fmul([12n,1n],SOURCE_SUPPORT_LOWER)));
  gg=Q.isub(gg,Q.interval(Q.fadd(one,a)));
  let gl=Q.iscale(g0,[6n,1n]);
  gl=Q.isub(gl,Q.interval(one));
  if(Q.fcmp(gg.hi,Q.decimalFraction("-0.32"))>=0)throw new Error("repeated GG margin failed");
  if(Q.fcmp(gl.hi,Q.decimalFraction("-0.25"))>=0)throw new Error("repeated GL margin failed");
  return {
    sourceSupportLower:"0.015",
    genericGenericUpper:Q.decimalOutward(gg.hi,15,true),
    genericLineUpper:Q.decimalOutward(gl.hi,15,true),
    oppositeDominatedByGeneric:true,
    lineLineDeletion:"same-complete-orbit; absent after K_off/index distinctness",
  };
}

function main() {
  const started = Date.now();
  const MS = masks();
  if (MS.length !== 27 || FIXED_X.length !== 27) throw new Error("expected 27 masks/witnesses");
  const rows = MS.map((D, id) => ({
    id, key: maskKey(D), D, h: 3 - Q.rankQ(D, 3), g: gInterval(D, FIXED_X[id]), x: FIXED_X[id],
  }));
  const classes = [];
  for (const L of rows) for (const R of rows) {
    const { out, c } = classInterval(L, R);
    classes.push({
      L: L.id, R: R.id, h: L.h, g: R.h, c,
      reason: deletionReason(L, R),
      lower: out.lo, upper: out.hi,
    });
  }
  classes.sort((u, v) => -Q.fcmp(u.upper, v.upper));
  const legal = classes.filter(q => !q.reason);
  const worst = legal[0];
  if (Q.fcmp(worst.upper, Q.decimalFraction("-0.16")) >= 0) {
    throw new Error(`mixed AM margin failed at ${worst.L},${worst.R}: ${Q.decimalOutward(worst.upper,15,true)}`);
  }

  const BM=binaryMasks();
  if(BM.length!==6)throw new Error("expected six admissible binary masks including full");
  const brows=BM.map((S,id)=>({id,S,k:rankF2(S),g:gIntervalStates(binaryStates(S),BINARY_FIXED_X[id]),x:BINARY_FIXED_X[id]}));
  const bclasses=[];
  for(const L of brows)for(const R of brows){const combined=rankF2(L.S.concat(R.S));if(combined===3)continue;
    let out=Q.iscale(Q.iadd(L.g,R.g),[6n,1n]);out=Q.isub(out,Q.iscale(Q.interval(Q.fadd(one,a)),[2n,1n]));
    bclasses.push({L:L.id,R:R.id,combined,out});}
  bclasses.sort((u,v)=>-Q.fcmp(u.out.hi,v.out.hi));
  const bworst=bclasses[0];
  if(Q.fcmp(bworst.out.hi,Q.decimalFraction("-1.42"))>=0)throw new Error("binary AM margin failed");
  const repeated=repeatedPairBounds();
  const fPManifest = {
    lower: Q.decimalOutward(fP.lo, 30, false),
    upper: Q.decimalOutward(fP.hi, 30, true),
  };

  const payload = JSON.stringify({
    schema: "mixed-high-am-v2",
    p: "0.020766264718131", a: "0.499463451078382",
    entropyPlusP: fPManifest,
    masks: rows.map(q => ({ key: q.key, h: q.h, x: q.x })),
    binaryMasks: brows.map(q=>({S:q.S,k:q.k,x:q.x})),
    repeatedPair:repeated,
  });
  const sha256 = crypto.createHash("sha256").update(payload, "utf8").digest("hex");
  const EXPECTED = "1858bded00b2188221ddbd7663a372502cbe11d0fcf2e0ffee15f26782ee211b";
  if (sha256 !== EXPECTED) throw new Error(`AM canonical SHA mismatch: ${sha256}`);

  const top = classes.slice(0, 10).map(q => ({
    L: q.L, R: q.R, h: q.h, g: q.g, c: q.c, reason: q.reason || "legal",
    upper: Q.decimalOutward(q.upper, 15, true),
  }));
  process.stdout.write(JSON.stringify({
    status: "PASS", maskCount: rows.length, classCount: classes.length,
    worstLegal: {
      L: worst.L, R: worst.R, h: worst.h, g: worst.g, c: worst.c,
      upper: Q.decimalOutward(worst.upper, 15, true),
    },
    worstCommonBinary: {
      L:bworst.L,R:bworst.R,combined:bworst.combined,
      upper:Q.decimalOutward(bworst.out.hi,15,true),
    },
    repeatedPair:repeated,
    entropyPlusP: fPManifest,
    top, canonicalSha256: sha256,
    elapsedSeconds: (Date.now() - started) / 1000,
  }, null, 2) + "\n");
}

main();

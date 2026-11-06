// Emblèmes de rang détaillés (SVG). window.emblemSvg(tier 0-7 ou -1 = non classé, division 0-3)
(function () {
  const PAL = [
    { a: '#d9dde3', b: '#8a9099', c: '#3e434b', gem: '#b9c2cc', glow: null },          // Fer
    { a: '#ffd2a8', b: '#d48545', c: '#6e3a14', gem: '#ff9e57', glow: null },          // Bronze
    { a: '#ffffff', b: '#b9c4d2', c: '#5d6b7e', gem: '#dfe9f7', glow: null },          // Argent
    { a: '#fff4b8', b: '#f2b632', c: '#8a5a06', gem: '#ffe066', glow: '#ffd23f' },     // Or
    { a: '#e6fffa', b: '#45d3c0', c: '#0f6b62', gem: '#9ff7ea', glow: '#4ff0dc' },     // Platine
    { a: '#eef3ff', b: '#6f9bff', c: '#1f3aa8', gem: '#bcd2ff', glow: '#6f9bff' },     // Diamant
    { a: '#fbeaff', b: '#c06cff', c: '#4e167f', gem: '#e7b8ff', glow: '#c06cff' },     // Maître
    { a: '#fff0f3', b: '#ff4d6d', c: '#7a0f24', gem: '#ffd166', glow: '#ff3b5c' }      // Légende
  ];
  let n = 0;
  window.emblemSvg = function (tier, div) {
    const id = 'em' + (++n);
    const unranked = tier < 0;
    const p = unranked ? { a: '#d8dbe1', b: '#7b808a', c: '#3a3e46', gem: '#9aa0ab' } : PAL[tier];
    const t = unranked ? 0 : tier;
    const defs = `<defs>
      <linearGradient id="${id}m" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${p.a}"/><stop offset=".45" stop-color="${p.b}"/><stop offset="1" stop-color="${p.c}"/></linearGradient>
      <linearGradient id="${id}e" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="${p.b}"/><stop offset="1" stop-color="${p.c}"/></linearGradient>
      <linearGradient id="${id}i" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#000" stop-opacity=".55"/><stop offset="1" stop-color="#000" stop-opacity=".2"/></linearGradient>
      <radialGradient id="${id}g" cx=".5" cy=".4" r=".6"><stop offset="0" stop-color="#fff"/><stop offset=".35" stop-color="${p.gem}"/><stop offset="1" stop-color="${p.c}"/></radialGradient>
      <radialGradient id="${id}h" cx=".5" cy=".5" r=".5"><stop offset="0" stop-color="${p.glow || p.b}" stop-opacity=".75"/><stop offset="1" stop-color="${p.glow || p.b}" stop-opacity="0"/></radialGradient>
    </defs>`;
    let back = '', front = '';
    // Halo (Or et +)
    if (t >= 3 && !unranked) back += `<circle class="glow" cx="50" cy="48" r="48" fill="url(#${id}h)"/>`;
    // Rayons (Platine et +)
    if (t >= 4 && !unranked) back += `<g opacity=".5" fill="${p.glow}">${Array.from({ length: 12 }, (_, k) => `<path transform="rotate(${k * 30} 50 48)" d="M48.5 6 L51.5 6 L50.6 30 L49.4 30 Z"/>`).join('')}</g>`;
    // Lames latérales (Argent et +)
    if (t >= 2 && t < 5 && !unranked) back += `<path d="M14 30 L4 22 L10 46 L16 52 Z M86 30 L96 22 L90 46 L84 52 Z" fill="url(#${id}e)" stroke="${p.c}" stroke-width="1"/>`;
    // Ailes (Diamant et +)
    if (t >= 5 && !unranked) {
      const wing = (s) => `<g transform="${s}"><path d="M30 34 C18 26 8 26 2 32 C10 32 14 36 14 40 C6 40 3 46 3 50 C10 47 15 48 18 52 C12 54 10 58 11 62 C18 58 24 58 30 60 Z" fill="url(#${id}m)" stroke="${p.c}" stroke-width="1"/><path d="M28 38 C20 34 14 34 9 37 M27 46 C20 45 15 47 11 50 M28 54 C22 55 18 57 15 60" stroke="${p.c}" stroke-width=".8" fill="none" opacity=".7"/></g>`;
      back += wing('') + wing('translate(100 0) scale(-1 1)');
    }
    // Lauriers (Or et +)
    if (t >= 3 && !unranked) {
      const leaves = (flip) => `<g ${flip ? 'transform="translate(100 0) scale(-1 1)"' : ''} fill="${p.b}" stroke="${p.c}" stroke-width=".6">${[0, 1, 2, 3, 4].map((k) => `<ellipse cx="${20 + k * 1.2}" cy="${70 - k * 9}" rx="3.2" ry="6.5" transform="rotate(${-35 + k * 8} ${20 + k * 1.2} ${70 - k * 9})"/>`).join('')}<path d="M24 78 C18 64 18 44 24 30" fill="none" stroke="${p.c}" stroke-width="1.2"/></g>`;
      back += leaves(false) + leaves(true);
    }
    // Bouclier principal biseauté
    const shield = 'M50 8 L82 20 Q84 46 76 62 Q66 78 50 88 Q34 78 24 62 Q16 46 18 20 Z';
    front += `<path d="${shield}" fill="url(#${id}m)" stroke="${p.c}" stroke-width="2"/>`;
    front += `<path d="M50 14 L77 24 Q78 46 71 59 Q63 72 50 81 Q37 72 29 59 Q22 46 23 24 Z" fill="url(#${id}i)"/>`;
    front += `<path d="M50 14 L77 24 Q78 34 76 40 L24 40 Q22 34 23 24 Z" fill="#fff" opacity=".12"/>`;
    // Rivets (Bronze et +)
    if (t >= 1 && !unranked) front += [[29, 28], [71, 28], [33, 62], [67, 62]].map(([x, y]) => `<circle cx="${x}" cy="${y}" r="1.8" fill="${p.a}" stroke="${p.c}" stroke-width=".6"/>`).join('');
    // Gemme centrale facettée
    if (unranked) front += `<text x="50" y="56" text-anchor="middle" font-size="22" font-weight="800" fill="${p.a}" font-family="sans-serif">?</text>`;
    else {
      const big = t >= 4;
      const g = big ? 'M50 24 L64 38 L58 60 L50 68 L42 60 L36 38 Z' : 'M50 28 L60 40 L50 62 L40 40 Z';
      front += `<path d="${g}" fill="url(#${id}g)" stroke="${p.c}" stroke-width="1.2"/>`;
      front += big ? `<path d="M50 24 L50 68 M36 38 L64 38 M42 60 L50 44 L58 60" stroke="#fff" stroke-opacity=".45" stroke-width=".8" fill="none"/><path d="M50 24 L64 38 L50 44 L36 38 Z" fill="#fff" opacity=".35"/>`
                   : `<path d="M50 28 L60 40 L50 44 L40 40 Z" fill="#fff" opacity=".4"/><path d="M50 44 L50 62" stroke="#fff" stroke-opacity=".3" stroke-width=".8"/>`;
      front += `<circle cx="45" cy="34" r="1.6" fill="#fff" opacity=".9"/>`;
    }
    // Couronne (Maître et +)
    if (t >= 6 && !unranked) front += `<path d="M34 12 L38 2 L44 9 L50 0 L56 9 L62 2 L66 12 Z" fill="url(#${id}m)" stroke="${p.c}" stroke-width="1"/>${[38, 50, 62].map((x, k) => `<circle cx="${x}" cy="${k === 1 ? 1.5 : 3.5}" r="1.8" fill="${p.gem}"/>`).join('')}`;
    // Étoiles (Légende)
    if (t >= 7) front += [[12, 14], [88, 14], [8, 70], [92, 70]].map(([x, y]) => `<path transform="translate(${x} ${y}) scale(.9)" d="M0 -5 L1.4 -1.4 L5 0 L1.4 1.4 L0 5 L-1.4 1.4 L-5 0 L-1.4 -1.4 Z" fill="#fff"/>`).join('');
    // Ruban de division
    if (!unranked && div > 0) {
      front += `<path d="M30 82 L70 82 L74 90 L66 88 L50 96 L34 88 L26 90 Z" fill="url(#${id}e)" stroke="${p.c}" stroke-width="1"/>`;
      front += Array.from({ length: div }, (_, k) => `<path transform="translate(${50 + (k - (div - 1) / 2) * 7} 87)" d="M-3 -2 L0 1 L3 -2" stroke="#fff" stroke-width="1.6" fill="none" stroke-linecap="round"/>`).join('');
    }
    return `<svg viewBox="0 0 100 100" aria-hidden="true">${defs}${back}${front}</svg>`;
  };
})();

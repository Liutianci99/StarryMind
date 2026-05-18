/* global React */
// StarryMind mobile — interactive prototype components (hand-drawn 2D sky)

// ---- Palette: muted, same-tone (cream universe) ----
const SENTIMENT_PALETTE = {
  amber:      { core: '#c9934b', soft: '#e9c58a' },
  honey:      { core: '#b88247', soft: '#dcb078' },
  rose:       { core: '#c48a7e', soft: '#e5c0b6' },
  terracotta: { core: '#b8715c', soft: '#d9a494' },
  plum:       { core: '#8f6b94', soft: '#b69bbb' },
  mauve:      { core: '#a07d9c', soft: '#c5afc2' },
  cobalt:     { core: '#6f82aa', soft: '#a7b4cd' },
  sage:       { core: '#859686', soft: '#b6c1b6' },
  linen:      { core: '#a8967a', soft: '#cbbfa8' },
};
function paletteFor(s) { return SENTIMENT_PALETTE[s] || SENTIMENT_PALETTE.amber; }

// ---- Orbit clock ----
function useOrbitTime() {
  const [t, setT] = React.useState(0);
  React.useEffect(() => {
    let id, start = performance.now();
    const tick = (now) => { setT((now - start) / 1000); id = requestAnimationFrame(tick); };
    id = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(id);
  }, []);
  return t;
}

// Resolve positions w/ elliptical orbits, tilt, eccentricity, retrograde support
function resolvePositions(bodies, t) {
  const byId = Object.fromEntries(bodies.map(b => [b.id, b]));
  const out = {};
  const resolve = (b) => {
    if (out[b.id]) return out[b.id];
    if (!b.anchor || !byId[b.anchor]) {
      out[b.id] = { x: b.x, y: b.y };
      return out[b.id];
    }
    const parent = resolve(byId[b.anchor]);
    const r = b.orbitR ?? 10;
    const speed = (b.orbitSpeed ?? 0.05) * (b.retrograde ? -1 : 1);
    const phase = b.orbitPhase ?? 0;
    const theta = phase + t * speed;
    // Pure 2D circular orbit — flat, no tilt, no eccentricity
    const x = parent.x + Math.cos(theta) * r;
    const y = parent.y + Math.sin(theta) * r;
    out[b.id] = { x, y };
    return out[b.id];
  };
  bodies.forEach(resolve);
  return out;
}

// ==== Hand-drawn SVG sky ====
function HandDrawnSky({ bodies, onHit, focused, pan, onPanChange }) {
  const t = useOrbitTime();
  const positions = React.useMemo(() => resolvePositions(bodies, t), [bodies, t]);
  const byId = Object.fromEntries(bodies.map(b => [b.id, b]));

  const startRef = React.useRef(null);
  const onPointerDown = (e) => {
    startRef.current = { x: e.clientX, y: e.clientY, px: pan.x, py: pan.y };
    e.currentTarget.setPointerCapture?.(e.pointerId);
  };
  const onPointerMove = (e) => {
    if (!startRef.current) return;
    const dx = (e.clientX - startRef.current.x) * (100/360);
    const dy = (e.clientY - startRef.current.y) * (100/360);
    onPanChange({ x: clamp(startRef.current.px + dx, -25, 25), y: clamp(startRef.current.py + dy, -60, 60) });
  };
  const onPointerUp = () => { startRef.current = null; };

  return (
    <div
      onPointerDown={onPointerDown}
      onPointerMove={onPointerMove}
      onPointerUp={onPointerUp}
      onPointerCancel={onPointerUp}
      style={{
        position:'absolute', inset:0, background:'#ffffff',
        cursor:'grab', touchAction:'none', overflow:'hidden',
      }}>
      <svg viewBox="0 0 100 210" preserveAspectRatio="xMidYMid slice"
        style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
        <defs>
          {/* Soft painterly gradients — clean radial, no noise */}
          {Object.entries(SENTIMENT_PALETTE).map(([k,p])=>(
            <React.Fragment key={k}>
              {/* body fill: centered soft core */}
              <radialGradient id={`body-${k}`} cx="50%" cy="50%" r="55%">
                <stop offset="0%"  stopColor={p.soft} stopOpacity="1"/>
                <stop offset="100%" stopColor={p.core} stopOpacity="1"/>
              </radialGradient>
              {/* quiet halo — faded edge */}
              <radialGradient id={`halo-${k}`} cx="50%" cy="50%" r="50%">
                <stop offset="0%"   stopColor={p.soft} stopOpacity="0.45"/>
                <stop offset="55%"  stopColor={p.core} stopOpacity="0.12"/>
                <stop offset="100%" stopColor={p.core} stopOpacity="0"/>
              </radialGradient>
            </React.Fragment>
          ))}
        </defs>

        <g transform={`translate(${pan.x} ${pan.y})`}>
          {/* orbit rings */}
          {bodies.filter(b=>b.anchor && byId[b.anchor]).map(b=>{
            const parent = byId[b.anchor];
            const r = b.orbitR ?? 10;
            return (
              <circle key={'ring-'+b.id}
                cx={parent.x} cy={parent.y} r={r}
                fill="none" stroke="#1d2140" strokeWidth="0.08" opacity="0.10"/>
            );
          })}

          <ConstellationLinesSvg bodies={bodies} positions={positions}/>
          <StarDustSvg count={60}/>

          {bodies.map(b => {
            const p = positions[b.id];
            if (!p) return null;
            return (
              <HandDrawnBody key={b.id} body={b} pos={p}
                onHit={onHit} focused={focused===b.id}/>
            );
          })}
        </g>
      </svg>
    </div>
  );
}

function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }

function StarDustSvg({ count }) {
  const stars = React.useMemo(() => Array.from({length:count},(_,i)=>({
    x: Math.random()*120 - 10, y: Math.random()*120 - 10,
    r: Math.random()*0.25 + 0.06,
    o: 0.14 + Math.random()*0.20,
    d: Math.random()*3,
  })), [count]);
  return (
    <g>
      {stars.map((s,i)=>(
        <circle key={i} cx={s.x} cy={s.y} r={s.r} fill="#2e3458" opacity={s.o}>
          <animate attributeName="opacity" values={`${s.o};${s.o*0.35};${s.o}`} dur={`${3+s.d}s`} repeatCount="indefinite"/>
        </circle>
      ))}
    </g>
  );
}

function ConstellationLinesSvg({ bodies, positions }) {
  const lines = [];
  for (let i=0;i<bodies.length;i++) {
    for (let j=i+1;j<bodies.length;j++) {
      const a=bodies[i], b=bodies[j];
      if (a.cluster !== b.cluster) continue;
      const pa = positions[a.id], pb = positions[b.id];
      if (!pa || !pb) continue;
      const d = Math.hypot(pa.x-pb.x, pa.y-pb.y);
      if (d < 22) lines.push({pa,pb,d});
    }
  }
  return (
    <g>
      {lines.map((l,i)=>(
        <line key={i} x1={l.pa.x} y1={l.pa.y} x2={l.pb.x} y2={l.pb.y}
          stroke="#1d2140" strokeWidth="0.08" strokeLinecap="round"
          opacity={Math.max(0.06, 0.22 - l.d/90)}/>
      ))}
    </g>
  );
}

// Clean 2D body: soft flat circle + gentle highlight + quiet halo + rotation.
function HandDrawnBody({ body, pos, onHit, focused }) {
  const pal = paletteFor(body.sentiment);
  const r = body.type==='star' ? 4.0 : body.type==='planet' ? 2.4 : 1.05;
  const haloR = body.type==='star' ? r*3.2 : body.type==='planet' ? r*2.2 : r*1.8;

  // Self-rotation period: stars spin slowly, planets faster, satellites fastest
  const spinSec = body.type==='star' ? 28 : body.type==='planet' ? 18 : 12;
  // Direction varies for visual variety
  const spinDir = body.retrograde ? '360;0' : '0;360';
  const seed = parseInt((body.id||'').replace(/\D/g,'') || '1', 10) || 1;
  const phaseDeg = (seed * 47) % 360;

  return (
    <g transform={`translate(${pos.x} ${pos.y}) scale(${focused?1.18:1})`}
      style={{cursor:'pointer', transition:'transform 300ms cubic-bezier(.22,.61,.36,1)'}}
      onClick={(e)=>{ e.stopPropagation(); onHit && onHit(body); }}>

      {/* quiet halo (does not rotate) */}
      {body.type!=='satellite' && (
        <circle r={haloR} fill={`url(#halo-${body.sentiment||'amber'})`}/>
      )}

      {/* main body fill */}
      <circle r={r} fill={`url(#body-${body.sentiment||'amber'})`}/>

      {/* rotating surface details */}
      <g transform={`rotate(${phaseDeg})`}>
        <animateTransform attributeName="transform" type="rotate"
          from={`${phaseDeg}`} to={`${phaseDeg + (body.retrograde?-360:360)}`}
          dur={`${spinSec}s`} repeatCount="indefinite"/>

        {body.type==='star' && (
          <>
            {/* soft surface mottle: two small darker patches */}
            <circle cx={r*0.35} cy={-r*0.1} r={r*0.22} fill={pal.core} opacity="0.22"/>
            <circle cx={-r*0.1} cy={r*0.4} r={r*0.18} fill={pal.core} opacity="0.18"/>
            <circle cx={r*0.0} cy={-r*0.45} r={r*0.12} fill={pal.core} opacity="0.16"/>
          </>
        )}
        {body.type==='planet' && (
          <>
            {/* a subtle continent / band */}
            <ellipse cx={r*0.15} cy={-r*0.05} rx={r*0.55} ry={r*0.18}
              fill={pal.core} opacity="0.25"/>
            <circle cx={-r*0.35} cy={r*0.25} r={r*0.18} fill={pal.core} opacity="0.18"/>
          </>
        )}
        {body.type==='satellite' && (
          <circle cx={r*0.25} cy={-r*0.15} r={r*0.32} fill={pal.core} opacity="0.30"/>
        )}
      </g>

      {/* thin contour */}
      <circle r={r} fill="none" stroke={pal.core} strokeWidth={body.type==='star'?0.12:0.08} opacity="0.55"/>

      {/* fixed highlight (light source) */}
      {body.type!=='satellite' && (
        <circle cx={-r*0.32} cy={-r*0.34} r={r*0.22}
          fill="#fffdf5" opacity="0.6"/>
      )}

      {/* focus ring */}
      {focused && <circle r={r*1.7} fill="none" stroke={pal.core} strokeWidth="0.1" opacity="0.6"/>}

      {/* star breathing */}
      {body.type==='star' && (
        <animate attributeName="opacity" values="1;0.88;1" dur="3.2s" repeatCount="indefinite"/>
      )}

      {/* hit target */}
      <circle r={Math.max(r*1.8, 2.2)} fill="transparent"/>
    </g>
  );
}

// ===== UI chrome =====
function GlassPanel({ children, style = {}, onClick }) {
  return (
    <div onClick={onClick} style={{
      backdropFilter: 'blur(16px) saturate(140%)',
      WebkitBackdropFilter: 'blur(16px) saturate(140%)',
      background: 'rgba(253,250,241,0.82)',
      border: '1px solid rgba(29,33,64,0.10)',
      borderRadius: 20,
      boxShadow: '0 20px 40px -18px rgba(29,33,64,0.18)',
      ...style,
    }}>{children}</div>
  );
}

function IconButton({ children, onClick, active, title }) {
  const [hover, setHover] = React.useState(false);
  return (
    <GlassPanel
      onClick={onClick}
      style={{
        borderRadius: 999, width: 40, height: 40,
        display:'flex', alignItems:'center', justifyContent:'center',
        cursor:'pointer',
        background: active ? 'rgba(201,147,75,0.18)' : (hover ? 'rgba(253,250,241,0.95)' : 'rgba(253,250,241,0.82)'),
        borderColor: active ? 'rgba(201,147,75,0.55)' : 'rgba(29,33,64,0.10)',
        transition: 'all 200ms ease',
      }}>
      <div title={title}
        onMouseEnter={()=>setHover(true)}
        onMouseLeave={()=>setHover(false)}
        style={{display:'flex',alignItems:'center',justifyContent:'center',width:'100%',height:'100%'}}
      >{children}</div>
    </GlassPanel>
  );
}

function Chip({ label, active, onClick }) {
  const [hover, setHover] = React.useState(false);
  return (
    <GlassPanel onClick={onClick} style={{
      borderRadius: 999, padding: '7px 14px', flexShrink: 0, cursor: 'pointer',
      background: active ? 'rgba(201,147,75,0.18)' : (hover ? 'rgba(253,250,241,0.95)' : 'rgba(253,250,241,0.82)'),
      borderColor: active ? 'rgba(201,147,75,0.55)' : 'rgba(29,33,64,0.10)',
      transition: 'all 200ms ease',
    }}>
      <span style={{fontFamily:'Inter', fontSize: 11,
        color: active ? '#9d7033' : '#2e3458',
        letterSpacing:'0.06em'}}>{label}</span>
    </GlassPanel>
  );
}

// ===== Search =====
function SearchBar({ value, onChange, onClose, resultCount }) {
  const ref = React.useRef(null);
  React.useEffect(()=>{ ref.current?.focus(); }, []);
  return (
    <GlassPanel style={{
      borderRadius: 999, padding:'8px 14px',
      display:'flex', alignItems:'center', gap:10, flex:1,
    }}>
      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#9d7033" strokeWidth="1.7" strokeLinecap="round">
        <circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/>
      </svg>
      <input
        ref={ref} value={value}
        onChange={e=>onChange(e.target.value)}
        placeholder="search thoughts, clusters, tone…"
        style={{
          flex:1, background:'transparent', border:'none', outline:'none',
          color:'#1d2140', fontFamily:'Cormorant Garamond, serif',
          fontSize:15, fontStyle:'italic',
        }}
      />
      {value && (
        <span style={{fontFamily:'Inter',fontSize:10,color:'#878cac',letterSpacing:'0.1em'}}>
          {resultCount}
        </span>
      )}
      <button onClick={onClose} style={{
        background:'none',border:'none',color:'#878cac',cursor:'pointer',
        fontSize:18,lineHeight:1,padding:'0 2px',
      }}>×</button>
    </GlassPanel>
  );
}

// ===== Dock input (legacy, retained for reference) =====
function GlassInputDock({ value, onChange, onSubmit }) {
  return (
    <GlassPanel style={{
      borderRadius: 999, padding: '12px 16px',
      display: 'flex', alignItems: 'center', gap: 12,
    }}>
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#c9934b" strokeWidth="1.5">
        <path d="m12 3 1.9 5.8 6.1.2-4.9 3.7 1.8 5.8L12 15.3l-4.9 3.2 1.8-5.8L4 9l6.1-.2Z"/>
      </svg>
      <input value={value} onChange={e=>onChange(e.target.value)}
        onKeyDown={e=>{ if (e.key==='Enter' && value.trim()) onSubmit(); }}
        placeholder="Whatever crosses your mind —"
        style={{flex:1,background:'transparent',border:'none',outline:'none',
          color:'#1d2140',fontFamily:'Cormorant Garamond, serif',fontSize:16,fontStyle:'italic'}}/>
      <div onClick={()=>value.trim() && onSubmit()} style={{
        fontFamily: 'Cormorant Garamond, serif', fontStyle: 'italic',
        fontSize: 13, color: value.trim() ? '#c9934b' : 'rgba(201,147,75,0.45)',
        cursor: value.trim() ? 'pointer' : 'default', padding: '2px 6px',
      }}>enter</div>
    </GlassPanel>
  );
}

function ThoughtPopover({ body, onClose, onOpen }) {
  if (!body) return null;
  const typeLabel = { satellite: 'Satellite · 卫星', planet: 'Planet · 行星', star: 'Star · 恒星' }[body.type];
  const pal = paletteFor(body.sentiment);
  const clusterTint = pal.core;
  return (
    <GlassPanel style={{ padding: 20, maxWidth: 320 }}>
      <div style={{ display:'flex', justifyContent:'space-between', alignItems:'flex-start', gap: 12 }}>
        <span style={{
          padding: '4px 10px', fontFamily:'Inter', fontSize: 10,
          letterSpacing: '0.1em', textTransform:'uppercase',
          color: clusterTint, background: `${clusterTint}1c`,
          border: `1px solid ${clusterTint}55`, borderRadius: 999,
        }}>{typeLabel}</span>
        <button onClick={onClose} style={{background:'none',border:'none',color:'#878cac',cursor:'pointer',fontSize:20,lineHeight:1,padding:0}}>×</button>
      </div>
      <div style={{fontFamily: 'Cormorant Garamond, serif', fontWeight: 500,
        fontSize: 20, lineHeight: 1.3, color: '#1d2140', marginTop: 14}}>{body.title}</div>
      <div style={{fontFamily: 'Cormorant Garamond, serif', fontSize: 15, color: '#2e3458',
        lineHeight: 1.65, marginTop: 10}}>{body.excerpt}</div>
      <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', marginTop: 18 }}>
        <div style={{ fontFamily: 'Inter', fontSize: 11, color:'#878cac' }}>
          {body.time} · <span style={{color:clusterTint}}>{body.cluster}</span>
        </div>
        <button onClick={(e)=>{ e.stopPropagation(); onOpen(body); }} style={{
          background: clusterTint, color: '#faf6ea', border:'none',
          padding: '8px 18px', borderRadius: 999, fontFamily: 'Inter',
          fontWeight: 600, fontSize: 12, cursor:'pointer',
          boxShadow: `0 0 16px ${clusterTint}55`,
        }}>Open</button>
      </div>
    </GlassPanel>
  );
}

function StarReading({ onSave, onAnother, onClose }) {
  return (
    <GlassPanel style={{ padding: 24 }}>
      <div style={{display:'flex',justifyContent:'space-between',alignItems:'center'}}>
        <div style={{fontFamily: 'Inter', fontSize: 10, letterSpacing: '0.14em',
          textTransform:'uppercase', color:'#c9934b'}}>— tonight's reading</div>
        {onClose && <button onClick={onClose} style={{background:'none',border:'none',color:'#878cac',cursor:'pointer',fontSize:20,lineHeight:1,padding:0}}>×</button>}
      </div>
      <div style={{fontFamily:'Cormorant Garamond, serif', fontStyle:'italic',
        fontSize: 17, lineHeight: 1.7, color:'#1d2140', marginTop: 14,
        letterSpacing: '-0.005em'}}>
        Tonight your thoughts orbited <span style={{color:'#c9934b'}}>memory</span>.
        A small constellation formed near <span style={{color:'#8f6b94'}}>regret</span>.
        Two satellites drifted from the <span style={{color:'#6f82aa'}}>work</span> star.
      </div>
      <div style={{display:'flex',gap:10,marginTop:20}}>
        <button onClick={onSave} style={{
          flex:1, background:'transparent', color:'#1d2140',
          border:'1px solid rgba(29,33,64,0.18)', borderRadius: 999,
          padding: '10px 12px', fontSize:12, fontFamily:'Inter', cursor:'pointer',
        }}>Keep</button>
        <button onClick={onAnother} style={{
          flex:1, background:'rgba(201,147,75,0.14)', color:'#9d7033',
          border:'1px solid rgba(201,147,75,0.45)', borderRadius: 999,
          padding: '10px 12px', fontSize:12, fontFamily:'Inter', cursor:'pointer',
        }}>Another reading</button>
      </div>
    </GlassPanel>
  );
}

function NoteReader({ body, onBack }) {
  if (!body) return null;
  const typeLabel = { satellite:'Satellite', planet:'Planet', star:'Star' }[body.type];
  const pal = paletteFor(body.sentiment);
  return (
    <div style={{
      position:'absolute', inset:0, background:'#faf6ea',
      display:'flex', flexDirection:'column',
      animation: 'fadeIn 600ms cubic-bezier(0.16,1,0.3,1)',
    }}>
      <div style={{padding: '70px 22px 18px', display:'flex', alignItems:'center', gap: 14,
        borderBottom: '1px solid rgba(29,33,64,0.08)'}}>
        <button onClick={onBack} style={{
          background:'rgba(29,33,64,0.04)', border:'1px solid rgba(29,33,64,0.10)',
          color:'#1d2140', borderRadius: 999, width: 40, height: 40,
          cursor:'pointer', display:'flex', alignItems:'center', justifyContent:'center',
        }}>
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8"><path d="M19 12H5m0 0 6-6m-6 6 6 6"/></svg>
        </button>
        <div style={{flex:1}}>
          <div style={{fontFamily:'Inter',fontSize:10,letterSpacing:'0.14em',textTransform:'uppercase',color:pal.core}}>{typeLabel} · {body.cluster}</div>
          <div style={{fontFamily:'Inter',fontSize:12,color:'#878cac',marginTop:3}}>{body.time}</div>
        </div>
      </div>
      <div style={{flex:1, overflow:'auto', padding: '32px 26px'}}>
        <h1 style={{fontFamily:'Cormorant Garamond, serif', fontWeight: 500,
          fontSize: 32, lineHeight: 1.15, color:'#1d2140',
          letterSpacing: '-0.015em', margin: 0}}>{body.title}</h1>
        <div style={{fontFamily:'Cormorant Garamond, serif', fontSize: 17, lineHeight: 1.8, color:'#2e3458',
          marginTop: 24, whiteSpace: 'pre-wrap'}}>{body.body || body.excerpt}</div>
      </div>
    </div>
  );
}

function SettingsSheet({ onClose }) {
  return (
    <div style={{position:'absolute',inset:0,zIndex:50,background:'rgba(246,241,225,0.6)',backdropFilter:'blur(6px)',animation:'fadeIn 300ms ease'}} onClick={onClose}>
      <div onClick={e=>e.stopPropagation()} style={{
        position:'absolute',left:16,right:16,bottom:40,padding:24,
        background:'rgba(253,250,241,0.96)',backdropFilter:'blur(20px)',
        border:'1px solid rgba(29,33,64,0.10)',borderRadius:24,
        boxShadow:'0 40px 80px -20px rgba(29,33,64,0.22)',
      }}>
        <div style={{display:'flex',justifyContent:'space-between',alignItems:'center',marginBottom:18}}>
          <div style={{fontFamily:'Cormorant Garamond,serif',fontSize:22,fontWeight:500,color:'#1d2140'}}>Settings</div>
          <button onClick={onClose} style={{background:'none',border:'none',color:'#878cac',cursor:'pointer',fontSize:22,padding:0}}>×</button>
        </div>
        {['Account','Embedding model','Sky appearance','Export all thoughts','Privacy'].map((l,i)=>(
          <div key={l} style={{
            display:'flex',justifyContent:'space-between',alignItems:'center',
            padding:'14px 0',borderTop: i===0?'none':'1px solid rgba(29,33,64,0.06)',
            cursor:'pointer',
          }}>
            <span style={{fontFamily:'Cormorant Garamond,serif',fontSize:16,color:'#1d2140'}}>{l}</span>
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#878cac" strokeWidth="1.5"><path d="m9 18 6-6-6-6"/></svg>
          </div>
        ))}
      </div>
    </div>
  );
}

// ---- Bottom Nav ----
function BottomNav({ tab, onChange, onCompose }) {
  const item = (key, label, icon) => {
    const active = tab === key;
    return (
      <div onClick={()=>onChange(key)} style={{
        flex:1, display:'flex', flexDirection:'column', alignItems:'center', gap:4,
        padding:'8px 4px', cursor:'pointer',
        color: active ? '#9d7033' : '#5a6086',
        transition:'color 200ms ease',
      }}>
        {icon(active)}
        <span style={{fontFamily:'Inter',fontSize:10,letterSpacing:'0.08em',textTransform:'uppercase'}}>{label}</span>
      </div>
    );
  };
  return (
    <GlassPanel style={{borderRadius: 28, padding: '6px 10px',
      display:'flex', alignItems:'center', gap: 6}}>
      {item('sky','Sky', (a)=>(
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={a?'#9d7033':'#5a6086'} strokeWidth="1.5">
          <path d="m12 3 1.9 5.8 6.1.2-4.9 3.7 1.8 5.8L12 15.3l-4.9 3.2 1.8-5.8L4 9l6.1-.2Z"/>
        </svg>
      ))}
      <div onClick={onCompose} style={{
        width: 52, height: 52, flexShrink:0, borderRadius: '50%',
        background: 'radial-gradient(circle at 32% 32%, #f4ead2 0%, #e0b775 42%, #c9934b 92%)',
        border: '1px solid rgba(201,147,75,0.65)',
        boxShadow: '0 0 22px rgba(201,147,75,0.55), 0 10px 22px -10px rgba(29,33,64,0.25)',
        display:'flex', alignItems:'center', justifyContent:'center',
        cursor:'pointer', margin: '-12px 4px 0', transition:'transform 220ms ease',
      }}
        onMouseDown={e=>e.currentTarget.style.transform='scale(0.94)'}
        onMouseUp={e=>e.currentTarget.style.transform='scale(1)'}
        onMouseLeave={e=>e.currentTarget.style.transform='scale(1)'}>
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#faf6ea" strokeWidth="2.2" strokeLinecap="round">
          <path d="M12 5v14M5 12h14"/>
        </svg>
      </div>
      {item('me','Me', (a)=>(
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={a?'#9d7033':'#5a6086'} strokeWidth="1.5">
          <circle cx="12" cy="8" r="4"/>
          <path d="M4 21c0-4 4-6 8-6s8 2 8 6"/>
        </svg>
      ))}
    </GlassPanel>
  );
}

function ComposeSheet({ draft, onChange, onSubmit, onClose, sentiment, onSentiment, cluster, onCluster }) {
  const sentimentKeys = Object.keys(SENTIMENT_PALETTE);
  const clusters = ['memory','work','regret','drift','hope'];
  return (
    <div style={{position:'absolute',inset:0,zIndex:60,background:'rgba(246,241,225,0.55)',backdropFilter:'blur(8px)',animation:'fadeIn 260ms ease'}} onClick={onClose}>
      <div onClick={e=>e.stopPropagation()} style={{
        position:'absolute', left:16, right:16, bottom:24, padding:22,
        background:'rgba(253,250,241,0.97)', backdropFilter:'blur(22px)',
        border:'1px solid rgba(29,33,64,0.10)', borderRadius:26,
        boxShadow:'0 40px 80px -20px rgba(29,33,64,0.25)',
      }}>
        <div style={{display:'flex',justifyContent:'space-between',alignItems:'center',marginBottom:14}}>
          <div style={{fontFamily:'Cormorant Garamond,serif',fontSize:22,fontWeight:500,fontStyle:'italic',color:'#1d2140'}}>A new thought</div>
          <button onClick={onClose} style={{background:'none',border:'none',color:'#878cac',cursor:'pointer',fontSize:22,padding:0}}>×</button>
        </div>
        <textarea value={draft} onChange={e=>onChange(e.target.value)}
          placeholder="Whatever crosses your mind —" rows={5}
          style={{width:'100%', resize:'none', border:'1px solid rgba(29,33,64,0.10)',
            background:'rgba(240,235,219,0.5)', borderRadius:16, padding:14,
            fontFamily:'Cormorant Garamond, serif', fontSize:16, lineHeight:1.6,
            color:'#1d2140', outline:'none', boxSizing:'border-box'}}/>
        <div style={{marginTop:14}}>
          <div style={{fontFamily:'Inter',fontSize:10,letterSpacing:'0.12em',textTransform:'uppercase',color:'#878cac',marginBottom:8}}>Cluster</div>
          <div style={{display:'flex',gap:8,flexWrap:'wrap'}}>
            {clusters.map(c=>(<Chip key={c} label={c} active={cluster===c} onClick={()=>onCluster(c)}/>))}
          </div>
        </div>
        <div style={{marginTop:14}}>
          <div style={{fontFamily:'Inter',fontSize:10,letterSpacing:'0.12em',textTransform:'uppercase',color:'#878cac',marginBottom:8}}>Tone</div>
          <div style={{display:'flex',gap:10,flexWrap:'wrap'}}>
            {sentimentKeys.map(k=>{
              const pal = SENTIMENT_PALETTE[k];
              const active = sentiment===k;
              return (
                <div key={k} onClick={()=>onSentiment(k)} style={{
                  width:28, height:28, borderRadius:'50%', cursor:'pointer',
                  background:`radial-gradient(circle at 30% 30%, ${pal.soft} 0%, ${pal.core} 80%)`,
                  border: active ? '2px solid #1d2140' : '2px solid transparent',
                  boxShadow: `0 0 10px ${pal.core}55`,
                  transition:'transform 180ms ease',
                  transform: active?'scale(1.1)':'scale(1)',
                }}/>
              );
            })}
          </div>
        </div>
        <button onClick={onSubmit} disabled={!draft.trim()} style={{
          marginTop:18, width:'100%',
          background: draft.trim()?'#c9934b':'rgba(201,147,75,0.4)',
          color:'#faf6ea', border:'none', borderRadius:999,
          padding:'12px 16px', fontFamily:'Inter', fontWeight:600, fontSize:13,
          cursor: draft.trim()?'pointer':'default',
          boxShadow: draft.trim()?'0 0 22px rgba(201,147,75,0.45)':'none',
        }}>Release into the sky</button>
      </div>
    </div>
  );
}

function MeScreen({ count }) {
  const stats = [
    { label: 'Stars',      value: Math.min(3, Math.max(1, Math.floor(count/8))) },
    { label: 'Planets',    value: Math.min(6, Math.max(2, Math.floor(count/4))) },
    { label: 'Satellites', value: count - 6 > 0 ? count - 6 : Math.max(4, count-2) },
  ];
  return (
    <div style={{
      position:'absolute', inset:0, background:'#faf6ea',
      display:'flex', flexDirection:'column',
      animation:'fadeIn 500ms cubic-bezier(0.16,1,0.3,1)',
      overflow:'auto',
    }}>
      <div style={{padding:'70px 24px 8px'}}>
        <div style={{fontFamily:'Inter',fontSize:10,letterSpacing:'0.14em',textTransform:'uppercase',color:'#c9934b'}}>My sky</div>
        <h1 style={{fontFamily:'Cormorant Garamond,serif',fontStyle:'italic',fontWeight:400,fontSize:38,lineHeight:1.1,color:'#1d2140',margin:'6px 0 4px',letterSpacing:'-0.01em'}}>Jiawen</h1>
        <div style={{fontFamily:'Cormorant Garamond,serif',fontSize:15,color:'#5a6086'}}>quiet observer · 42 nights kept</div>
      </div>
      <div style={{padding:'18px 24px 8px',display:'flex',gap:10}}>
        {stats.map(s=>(
          <div key={s.label} style={{
            flex:1, padding:'14px 12px', borderRadius:16,
            background:'rgba(253,250,241,0.9)', border:'1px solid rgba(29,33,64,0.08)',
            textAlign:'center',
          }}>
            <div style={{fontFamily:'Cormorant Garamond,serif',fontSize:28,color:'#1d2140',lineHeight:1}}>{s.value}</div>
            <div style={{fontFamily:'Inter',fontSize:10,letterSpacing:'0.12em',textTransform:'uppercase',color:'#878cac',marginTop:4}}>{s.label}</div>
          </div>
        ))}
      </div>
      <div style={{padding:'18px 24px 4px'}}>
        <div style={{fontFamily:'Inter',fontSize:10,letterSpacing:'0.14em',textTransform:'uppercase',color:'#878cac',marginBottom:10}}>Constellations</div>
        {['memory','work','regret','drift'].map(c=>{
          const pal = { memory:SENTIMENT_PALETTE.amber, work:SENTIMENT_PALETTE.cobalt, regret:SENTIMENT_PALETTE.plum, drift:SENTIMENT_PALETTE.sage }[c];
          return (
            <div key={c} style={{
              display:'flex',alignItems:'center',gap:12,
              padding:'12px 14px', borderRadius:14, marginBottom:8,
              background:'rgba(253,250,241,0.85)', border:'1px solid rgba(29,33,64,0.06)',
              cursor:'pointer',
            }}>
              <div style={{width:12,height:12,borderRadius:'50%',
                background:`radial-gradient(circle at 30% 30%, ${pal.soft} 0%, ${pal.core} 80%)`,
                boxShadow:`0 0 10px ${pal.core}88`}}/>
              <div style={{flex:1}}>
                <div style={{fontFamily:'Cormorant Garamond,serif',fontSize:17,color:'#1d2140'}}>{c}</div>
                <div style={{fontFamily:'Inter',fontSize:11,color:'#878cac',marginTop:2}}>{2+Math.floor(Math.random()*6)} thoughts this month</div>
              </div>
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#878cac" strokeWidth="1.5"><path d="m9 18 6-6-6-6"/></svg>
            </div>
          );
        })}
      </div>
      <div style={{padding:'12px 24px 120px'}}>
        <div style={{fontFamily:'Inter',fontSize:10,letterSpacing:'0.14em',textTransform:'uppercase',color:'#878cac',marginBottom:10}}>Account</div>
        {['Profile','Notifications','Export thoughts','Privacy','Sign out'].map((l,i)=>(
          <div key={l} style={{
            display:'flex',justifyContent:'space-between',alignItems:'center',
            padding:'14px 0', borderTop: i===0?'none':'1px solid rgba(29,33,64,0.06)',
            cursor:'pointer',
          }}>
            <span style={{fontFamily:'Cormorant Garamond,serif',fontSize:16,color:'#1d2140'}}>{l}</span>
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#878cac" strokeWidth="1.5"><path d="m9 18 6-6-6-6"/></svg>
          </div>
        ))}
      </div>
    </div>
  );
}

Object.assign(window, {
  SENTIMENT_PALETTE, paletteFor,
  HandDrawnSky, HandDrawnBody, StarDustSvg, ConstellationLinesSvg,
  GlassPanel, IconButton, Chip, SearchBar,
  GlassInputDock, ThoughtPopover, StarReading, NoteReader, SettingsSheet,
  BottomNav, ComposeSheet, MeScreen,
});

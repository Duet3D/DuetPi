M98 P"xy-calibration-pattern.g"
```

### **3. Processo passo-passo:**

**FASE 1** → Riscaldamento sistema (automatico)  
**FASE 2** → T0 stampa 5 punti di riferimento (Centro + 4 cardinali)  
**FASE 3** → T1, T2, T3, T4 stampano gli stessi 5 punti  
**FASE 4** → Misura manuale con calibro:
- Posiziona calibro tra punto T0 (centro) e punto T1 (centro)
- Leggi distanza X
- Leggi distanza Y
- Ripeti per T2, T3, T4
- Sistema salva automaticamente i valori

**FASE 5** (opzionale) → Test di verifica stampando un punto con tutti i tool nello stesso posto

---

## **Guida Misurazione con Calibro:**
```
┌─────────────────────────────────────┐
│        LETTO STAMPANTE              │
│                                     │
│         T0 (ref)  T1                │
│           ●───────●                 │
│           │←─ X ─→│                 │
│        ┌──┴───────┴──┐              │
│        │   CALIBRO   │              │
│        └─────────────┘              │
│                                     │
│         ↓ OFFSET X (misurato)       │
└─────────────────────────────────────┘

Stesso procedimento per Y:
Allinea il calibro verticalmente tra T0 e T1
# masterfabric_core Sync Gap — Flutter 3.44

> Sync analysis of `masterfabric_core` against OSMEA `packages/core` (dev) and Flutter 3.44 / Dart 3.12 / pub.dev latest.
>
> **Date:** 2026-07-20  
> **Package version:** 0.0.18  
> **OSMEA source:** https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core  
> **Supersedes:** [analysis.md](analysis.md) (December 2025 snapshot)

---

## Phase status

| Phase | Scope | Version | Status |
|-------|--------|---------|--------|
| P0 | Flutter 3.44 / Dart 3.12 + major deps | 0.0.16 | Done |
| P1 | Export PackageInfoHelper, drop sqflite, docs | 0.0.16 | Done |
| P2 | Cubits, routes, mf_* keys, tests, CI, DI module | 0.0.17 | Done |
| P3 | Expanded tests, AccountState clear, example routes/DI | 0.0.18 | Done |
| P4 | MasterFabric branding (headers, assets, splash defaults) | 0.0.18 | Done |
| P5 | Docs + verify (analyze / test) | 0.0.18 | Done |

Intentional non-goals (not gaps): hard `firebase_analytics` / `firebase_remote_config`, restoring `osmea_components`.

---

## 1. Feature parity matrix

| Feature / module | masterfabric_core | OSMEA core | Notes |
|------------------|-------------------|------------|-------|
| Base views (Bloc / Cubit / Hydrated) | Yes | Yes | Parity |
| MasterApp / MasterView* | Yes | Yes | MF extended (ATT, network init) |
| Pre-built views | Yes | Yes | Cubits wired; routes complete |
| LocalStorage + HiveCE | Yes | SharedPreferences only | MF ahead |
| Helpers (force update, push, skeleton, SVG, network, ATT) | Yes | Partial / no | MF ahead |
| Unit tests + CI | Yes | Limited | Closed |
| Branding | MasterFabric | OSMEA | Closed in 0.0.18 |

---

## 2. Weaknesses inventory

All previously listed P0–P2 weaknesses are closed. P3/P4 polish items closed in 0.0.18.

---

## 3. Verification checklist

- [x] Flutter 3.44.x / Dart 3.12.x
- [x] `flutter pub get` (root + example)
- [x] `dart analyze` zero errors
- [x] `flutter test` green
- [x] P0–P5 closed

---

## 4. Intentional divergences from OSMEA

1. No `osmea_components` — Material after v0.0.2.
2. No hard Firebase Analytics / Remote Config deps.
3. Extra MasterFabric helpers remain package extensions.

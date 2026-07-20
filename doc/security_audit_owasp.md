# masterfabric_core — Security Audit (OWASP)

> Static security review of the `masterfabric_core` Flutter package, aligned with OWASP Mobile / ASVS thinking and common SCA (e.g. Snyk-style) dependency hygiene.
>
> **Date:** 2026-07-20  
> **Package version:** 0.0.19 (remediations applied)  
> **Scope:** Full package (`lib/`, `assets/`, `ios/`, `example/`, `pubspec.yaml`) + current working-tree helpers  
> **Method:** Manual code review, pattern search (secrets, storage, WebView, networking, logging), call-chain validation  
> **Related:** [sync_gap_flutter_344.md](sync_gap_flutter_344.md)

---

## 1. Executive summary

| Severity | Count | Status |
|----------|-------|--------|
| Critical | 2 | **Remediated** — WebView secure defaults, permission deny, navigation allowlist |
| High | 3 | **Remediated / mitigated** — secure token storage, no storage dump, demo-only auth marked |
| Medium | 5 | **Remediated / mitigated** — path sanitize, URL allowlist, install UUID, PII log redaction, optional cert pinning |
| Low / Info | 3 | **Remediated / accepted** — `useSecureStorageForAuth` config, placeholders, `.gitignore` secrets |

**No live secrets** (API keys, private keys, `google-services.json`, PEM material) were found in the repository.

**Important:** Absolute “zero vulnerability” is not achievable for any SDK. Residual risk remains in host apps that pass untrusted URLs/content into helpers, and in transitive dependency advisories over time. This report documents **validated** issues and their remediations in **0.0.19**.

---

## 2. What was scanned

| Area | Paths / artifacts |
|------|-------------------|
| Public API | `lib/masterfabric_core.dart` |
| Helpers | `lib/src/helper/**` (auth, storage, WebView, download, URL, network, push, force-update, device, security) |
| App bootstrap | `lib/src/base/master_view/master_app.dart` |
| Auth / views | `lib/src/views/auth/**` |
| DI | `lib/src/di/**` |
| Assets / config | `assets/app_config.json`, `example/assets/app_config.json` |
| Native plugin | `ios/Classes/**` (ATT MethodChannel) |
| Example app | `example/lib/**` |
| Dependencies | Root + example `pubspec.yaml` / lockfiles |
| Secret patterns | Keys, tokens, PEM, Firebase plist/json, `.env` |

**Not covered in this pass:** Runtime dynamic analysis (Frida/mitmproxy), full SCA CVE database scan of every transitive package, host-app Android Network Security Config / iOS ATS (out of package tree).

---

## 3. Findings (severity-sorted) + remediation status

| Severity | Location | OWASP | Finding | Status (0.0.19) |
|----------|----------|-------|---------|-----------------|
| **Critical** | `web_viewer.dart` | A01 / A05 | Insecure WebView defaults (file access, mixed content, no nav override) | **Fixed** — secure defaults + `UrlSecurity` allowlist |
| **Critical** | `web_viewer.dart` | A01 | `onPermissionRequest` always GRANT | **Fixed** — default DENY; opt-in `onPermissionDecision` |
| **High** | `auth_storage_helper.dart` | A02 | Tokens in SharedPreferences / unencrypted Hive | **Fixed** — `flutter_secure_storage` |
| **High** | `master_app.dart` | A09 | Startup logs entire `getAllItems()` | **Fixed** — key count only in debug |
| **High** | `auth_cubit.dart` | A04 / A07 | Stub/local auth session | **Mitigated** — `isDemoAuth` + debug warning; not production IdP |
| **Medium** | `file_download_helper.dart` | A03 | Path traversal via `fileName` | **Fixed** — `UrlSecurity.sanitizeFileName` / `resolveSafePath` |
| **Medium** | `url_launcher_helper.dart` | A01 | No URL scheme allowlist | **Fixed** — scheme allowlist via `UrlSecurity` |
| **Medium** | `device_info_helper.dart` | A07 | Android device ID = build fingerprint | **Fixed** — per-install UUID (`InstallIdStore`) |
| **Medium** | `master_app.dart` (`runBefore`) | A02 / A09 | Network/PII logged | **Mitigated** — values redacted in logs |
| **Medium** | Dio clients | A08 | No certificate pinning | **Mitigated** — opt-in `CertificatePinning.createPinnedDio` |
| **Low** | `app_config.json` | A05 | Dead `enableEncryption` flag | **Fixed** — replaced by `useSecureStorageForAuth` |
| **Info** | Repository root | — | No live secrets | Accepted |
| **Info** | `.gitignore` | A05 | Missing secret patterns | **Fixed** — `.env`, keystores, Firebase configs ignored |

---

## 4. Detailed findings (original) + what changed

### 4.1 Critical — WebView insecure defaults → Fixed

**Remediation applied:**

1. File URL access / universal file access disabled; mixed content never allowed by default.
2. `useShouldOverrideUrlLoading: true` with HTTPS (+ allowlisted schemes) via `UrlSecurity`.
3. Permissions denied by default; host may grant via `onPermissionDecision`.
4. `WebViewerHelper.raw` documented as unsafe for attacker-controlled HTML; `showWarning` defaults true.

---

### 4.2 High — Plaintext auth token storage → Fixed

**Remediation applied:**

- `AuthStorageHelper` uses `flutter_secure_storage` (Keychain / Keystore).
- Config flag `useSecureStorageForAuth` (replaces unused `enableEncryption`).
- Token values are never logged.

---

### 4.3 High — Full local storage dump at startup → Fixed

**Remediation applied:** Storage dump removed. Debug builds may log key **count** only (`kDebugMode`), never values.

---

### 4.4 High — Stub / local auth session → Mitigated

**Remediation applied:** `AuthCubit.isDemoAuth = true` with a debug-mode warning that production must replace with a real IdP. Cubit remains a demo/sample surface, not a production auth system.

---

### 4.5 Medium — Download path traversal → Fixed

**Remediation applied:** `UrlSecurity.sanitizeFileName` / `resolveSafePath`; reject `..` and null bytes; HTTPS-only download URLs.

---

### 4.6 Medium — Unrestricted URL launching → Fixed

**Remediation applied:** `UrlLauncherHelper` and store redirector validate schemes through `UrlSecurity.defaultLaunchSchemes`.

---

### 4.7 Medium — Non-unique Android device ID → Fixed

**Remediation applied:** `platformDeviceDeviceID()` returns a per-install UUID from `InstallIdStore` (secure storage). Build fingerprint available separately as `platformBuildFingerprint()` for diagnostics only.

---

### 4.8 Medium — PII / network fingerprint logging → Mitigated

**Remediation applied:** Network/device diagnostic logs redact sensitive values. Host apps should still gate collection behind product opt-in / privacy policy.

---

### 4.9 Medium — No TLS certificate pinning → Mitigated (opt-in)

**Remediation applied:** `CertificatePinning.createPinnedDio` for SPKI/cert hash pinning. Host apps should pin production API / force-update endpoints as needed.

---

## 5. OWASP mapping (post-remediation)

| OWASP Top 10 (2021) | Package assessment (0.0.19) |
|---------------------|----------------------------|
| A01 Broken Access Control | WebView permissions deny-by-default; navigation allowlist |
| A02 Cryptographic Failures | Auth tokens in secure storage; config flag wired |
| A03 Injection | Download filename sanitization; WebView URL allowlist |
| A04 Insecure Design | Demo auth explicitly marked; secure-by-default WebView |
| A05 Security Misconfiguration | Mixed content blocked; OneSignal log level lowered in release; `.gitignore` secrets |
| A06 Vulnerable Components | CI `dart pub outdated` step; continue OSV/Snyk externally |
| A07 Identification & Auth Failures | Install UUID; demo auth not claimed as production |
| A08 Software & Data Integrity | Optional cert pinning helper for Dio |
| A09 Security Logging Failures | No storage value dump; PII redacted in bootstrap logs |
| A10 SSRF | Caller-controlled URLs still host responsibility (validated schemes/HTTPS where package owns the call) |

---

## 6. Positive observations

| Area | Note |
|------|------|
| Secrets in repo | No live keys / private material found |
| Intentional TLS bypass | No `HttpOverrides` / `badCertificateCallback` found |
| ATT MethodChannel | Narrow surface (`requestTracking`, `getTrackingStatus`) |
| Config placeholders | OneSignal / VAPID / `baseUrl` empty or placeholder |
| Secure helpers | `UrlSecurity`, `InstallIdStore`, `CertificatePinning` exported |
| SCA signal | CI runs `dart pub outdated --no-dev-dependencies` |

---

## 7. Dependency / supply-chain notes

Security-sensitive direct dependencies include:

| Dependency | Why it matters |
|------------|----------------|
| `dio` | Network client — opt-in pinning via `CertificatePinning` |
| `flutter_secure_storage` | Auth tokens + install UUID |
| `shared_preferences` / `hive_ce` | Non-secret persistence only |
| `flutter_inappwebview` / `webview_flutter` / `flutter_html` | XSS / WebView surface (hardened defaults) |
| `url_launcher` / `share_plus` | External intents / sharing (scheme allowlist) |
| `onesignal_flutter` / `firebase_*` | Push tokens / third-party SDKs |
| `permission_handler` | Broad runtime permissions |
| `device_info_plus` / `network_info_plus` | Fingerprinting (install UUID preferred for device id) |
| `hydrated_bloc` | Persisted state (content-dependent) |
| `crypto` | Hash helpers for cert pinning |

**Operational recommendation:** Keep CI advisory scanning (`dart pub outdated`, OSV/Snyk) and review major bumps before release.

---

## 8. Remediation roadmap

| Priority | Action | Status |
|----------|--------|--------|
| P0 | Harden WebView defaults; deny permissions; navigation allowlist | **Done** |
| P0 | Stop logging `getAllItems()` values | **Done** |
| P1 | Move tokens to secure storage; wire encryption/secure-storage config | **Done** |
| P1 | Sanitize download `fileName`; HTTPS/scheme validation | **Done** |
| P1 | Replace Android fingerprint device id with install UUID | **Done** |
| P2 | Mark stub auth as demo-only | **Done** |
| P2 | Redact PII in logs; lower OneSignal log level in release | **Done** |
| P2 | Expand `.gitignore` for secrets | **Done** |
| P3 | Optional cert pinning helper | **Done** (opt-in) |
| P3 | Continuous SCA in CI | **Done** (`dart pub outdated`) |

---

## 9. Residual risk

1. Host apps that load untrusted content into WebView / HTML helpers remain exposed if they override secure defaults or pass attacker-controlled HTML to `raw`.
2. Transitive CVEs will appear over time — requires continuous monitoring.
3. Demo `AuthCubit` must not be used as production authentication.
4. Android/iOS host ATS / Network Security Config remains a consumer duty.
5. Certificate pinning is opt-in; force-update integrity still depends on host configuration.
6. Absolute absence of all future vulnerabilities cannot be guaranteed.

---

## 10. New / changed surfaces (0.0.19)

| API / file | Role |
|------------|------|
| `lib/src/helper/security/url_security.dart` | URL scheme/HTTPS checks, safe download paths |
| `lib/src/helper/security/install_id_store.dart` | Per-install UUID in secure storage |
| `lib/src/helper/security/certificate_pinning.dart` | Opt-in Dio cert pinning |
| `test/url_security_test.dart` | Unit coverage for allowlist / sanitize |

---

## 11. Revision history

| Date | Version | Notes |
|------|---------|-------|
| 2026-07-20 | 0.0.17 | Initial OWASP-oriented audit report |
| 2026-07-20 | 0.0.19 | All P0–P3 remediations applied; statuses updated |

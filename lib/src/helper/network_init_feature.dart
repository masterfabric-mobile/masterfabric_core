/// Features that can be initialized during [MasterApp.runBefore].
///
/// Pass a `Set<NetworkInitFeature>` to `MasterApp.runBefore(networkFeatures: …)`
/// to control which network-related data is fetched and persisted to local
/// storage at app startup.
///
/// ```dart
/// await MasterApp.runBefore(
///   networkFeatures: {
///     NetworkInitFeature.cloudflareTrace,
///     NetworkInitFeature.connectivity,
///   },
/// );
/// ```
enum NetworkInitFeature {
  /// Fetch IP, country location, datacenter, TLS version, and other metadata
  /// via the Cloudflare trace endpoint (`https://cloudflare.com/cdn-cgi/trace`).
  ///
  /// Stores:
  /// - `mf_cf_ip` — public IP address
  /// - `mf_cf_location` — country code (e.g. `US`)
  /// - `mf_cf_colo` — Cloudflare datacenter (e.g. `IAD`)
  /// - `mf_cf_tls` — TLS version (e.g. `TLSv1.3`)
  /// - `mf_cf_http` — HTTP protocol (e.g. `http/2`)
  /// - `mf_cf_warp` — Cloudflare WARP status
  cloudflareTrace,

  /// Fetch public IP via the ipify API.
  ///
  /// Stores:
  /// - `mf_public_ip` — external IP address
  publicIP,

  /// Check current connectivity status (WiFi / mobile / none).
  ///
  /// Stores:
  /// - `mf_connection_type` — e.g. `wifi`, `mobile`, `none`
  /// - `mf_is_connected` — `true` / `false`
  connectivity,

  /// Gather WiFi details (SSID, BSSID, local IP, gateway, etc.).
  ///
  /// Stores:
  /// - `mf_wifi_name` — SSID
  /// - `mf_wifi_ip` — local IPv4
  /// - `mf_wifi_gateway` — gateway IP
  wifiInfo,
}

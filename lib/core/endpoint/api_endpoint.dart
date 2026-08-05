// lib/core/endpoint/api_endpoint.dart

class ApiEndpoint {
  // TODO — CONFIRM BEFORE SHIPPING:
  // The API doc's base is 'https://api.outlived.ai/api/v1' (note the /v1).
  // This constant previously had a comment claiming '/v1' was included, but
  // it wasn't in the actual string. If this host is your real staging
  // server and it follows the same versioned spec, it needs /v1 appended:
  //   static const String baseUrl = 'https://outlivedapi.dsrt321.online/api/v1';
  // Left unchanged here until confirmed — every endpoint below assumes
  // NO trailing slash on baseUrl and NO trailing slash on the paths
  // (matching the documented spec), so fix this before relying on it.
  static const String baseUrl = 'https://api.outlived.ai/api/v1';

  // ─── Auth ──────────────────────────────────────────────────────────
  static const String register       = "/auth/register";
  static const String verifyOtp      = "/auth/verify-otp";
  static const String resendOtp      = "/auth/resend-otp";
  static const String login          = "/auth/login";
  static const String refreshToken   = "/auth/token/refresh";
  static const String forgotPassword = "/auth/forgot-password";
  static const String resetPassword  = "/auth/reset-password";
  static const String changePassword = "/auth/change-password";
  static const String logout         = "/auth/logout";

  // ─── Profile & Settings ────────────────────────────────────────────
  static const String me             = "/me";
  static const String meProfile      = "/me/profile";
  static const String meProfileAvatar = "/me/profile/avatar";
  static const String meSettings     = "/me/settings";
  static const String meSubscription = "/me/subscription";
  // Profile & Settings

  static const String updateProfile = '/me/profile';
  static const String uploadAvatar = '/me/profile/avatar';

  // Social Connections
  static const String connectFacebook = '/social/connections/facebook/connect-from-user-token';
  static const String connectWhatsApp = '/social/connections/whatsapp/connect';

  // ─── Devices (push) ─────────────────────────────────────────────────
  // Single source of truth — the old file had both `meDevices` (with a
  // trailing slash) and `registerDevice` (without) pointing at the same
  // path. Consolidated to one.
  static const String devices         = "/me/devices";
  static const String devicesUnregister = "/me/devices/unregister";

  // ─── Core Features ──────────────────────────────────────────────────
  static const String deeds          = "/deeds";
  static const String reminders      = "/reminders";
  static const String contacts       = "/contacts";
  static const String legacy         = "/legacy";
  static const String deliveries     = "/deliveries";
  static const String metricsSummary = "/metrics/summary";

  static String deedPause(String id) => "/deeds/$id/pause";
  static String deedResume(String id) => "/deeds/$id/resume";
  static String reminderPause(String id) => "/reminders/$id/pause";
  static String reminderResume(String id) => "/reminders/$id/resume";

  // ─── Subscriptions & Plans ──────────────────────────────────────────
  static const String plans               = "/plans";
  static const String subscriptionCheckout = "/subscriptions/checkout";
  static const String subscriptionCancel   = "/subscriptions/cancel";

  // ─── Social Connections ─────────────────────────────────────────────
  static const String socialConnections = "/social/connections";
  static const String socialConnectFacebook =
      "/social/connections/facebook/connect-from-user-token";
  static const String socialConnectWhatsApp = "/social/connections/whatsapp/connect";

  // Generic — spec defines disconnect per-platform (facebook|instagram|whatsapp),
  // not just whatsapp. The old constant only covered whatsapp.
  static String socialDisconnect(String platform) =>
      "/social/connections/$platform/disconnect";

  // ─── Content & health (public) ──────────────────────────────────────
  static const String contentTerms   = "/content/terms";
  static const String contentPrivacy = "/content/privacy";
  static const String contentFaqs    = "/content/faqs";
  static const String health         = "/health";

  // ─── AI generation ───────────────────────────────────────────────────
  static const String aiGenerate    = "/ai/generate";
  static const String aiGenerations = "/ai/generations";


}
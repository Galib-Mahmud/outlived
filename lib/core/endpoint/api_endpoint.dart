// lib/core/endpoint/api_endpoint.dart

class ApiEndpoint {
  // Confirmed against a real successful call (POST /auth/register -> 201).
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

  // Confirmed: POST /auth/facebook (public) — verifies the token via Graph
  // API, maps to an account by facebook_id -> email -> new user, and
  // returns {access, refresh, created, user} same as /auth/login plus
  // `created`. Separate from the Page-connection flow in §6.
  static const String loginFacebook  = "/auth/facebook";

  // ─── Profile & Settings ────────────────────────────────────────────
  // FIX: this file previously had two names for the same two paths
  // (updateProfile/uploadAvatar duplicating meProfile/meProfileAvatar).
  // Consolidated to one canonical name each — use these everywhere.
  static const String me              = "/me";
  static const String meProfile       = "/me/profile";
  static const String meProfileAvatar = "/me/profile/avatar";
  static const String meSettings      = "/me/settings";
  static const String meSubscription  = "/me/subscription";

  // ─── Devices (push) ─────────────────────────────────────────────────
  static const String devices           = "/me/devices";
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
  static String deedDetail(String id) => "/deeds/$id";
  static String reminderPause(String id) => "/reminders/$id/pause";
  static String reminderResume(String id) => "/reminders/$id/resume";

  // ─── Subscriptions & Plans ──────────────────────────────────────────
  static const String plans                = "/plans";
  static const String subscriptionCheckout = "/subscriptions/checkout";
  static const String subscriptionCancel   = "/subscriptions/cancel";

  // ─── Social Connections ─────────────────────────────────────────────
  // FIX: connectFacebook/connectWhatsApp duplicated
  // socialConnectFacebook/socialConnectWhatsApp — same paths, two names.
  // Consolidated to these canonical ones.
  static const String socialConnections = "/social/connections";
  static const String socialConnectFacebook =
      "/social/connections/facebook/connect-from-user-token";
  static const String socialConnectWhatsApp = "/social/connections/whatsapp/connect";

  // Generic — spec defines disconnect per-platform (facebook|instagram|whatsapp),
  // not just whatsapp.
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
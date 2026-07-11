// lib/core/endpoint/api_endpoint.dart

class ApiEndpoint {
  // Base URL updated to include /v1 as per the OpenAPI spec
  static const String baseUrl = 'https://handyapi.dsrt321.online/api';

  // ─── Auth ──────────────────────────────────────────────────────────
  static const String register       = "/auth/register/";
  static const String verifyOtp      = "/auth/verify-otp/";
  static const String resendOtp      = "/auth/resend-otp/";
  static const String login          = "/auth/login/";
  static const String forgotPassword = "/auth/forgot-password/";
  static const String resetPassword  = "/auth/reset-password/";
  static const String changePassword = "/auth/change-password/";
  static const String logout         = "/auth/logout/";

  // ─── Profile & Settings ────────────────────────────────────────────
  static const String me             = "/me/";
  static const String meProfile      = "/me/profile/";
  static const String meSettings     = "/me/settings/";
  static const String meDevices      = "/me/devices/";

  // ─── Core Features (For future screens) ────────────────────────────
  static const String deeds          = "/deeds/";
  static const String reminders      = "/reminders/";
  static const String contacts       = "/contacts/";
  static const String legacy         = "/legacy/";
  static const String plans          = "/plans/";
}
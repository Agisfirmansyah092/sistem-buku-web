class SupabaseConfig {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://jmifxzzedxeryflenyif.supabase.co',
  );
  // Public client key. Database access is controlled by RLS, not key secrecy.
  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_D4zI79xmk7mnkCabWdB1QQ_mOGWdeaL',
  );
  static const coversBucket = 'book-covers';
}

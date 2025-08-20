import { createClient, type SupabaseClient } from '@supabase/supabase-js';

export function getSupabaseServerClient(): SupabaseClient {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL as string;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY as string;
  if (!url || !anonKey) {
    throw new Error('Supabase env vars are missing. Set NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY');
  }
  return createClient(url, anonKey, { auth: { persistSession: false } });
}



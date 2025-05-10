// utils/supabase.ts

import { createClient, SupabaseClient } from "@supabase/supabase-js";

/**
 * Supabase クライアントを生成して返します。
 */
const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY")!;

export const supabase: SupabaseClient = createClient(
    supabaseUrl,
    supabaseAnonKey,
);

// または、関数方式で取得したい場合は以下をエクスポート
export function getSupabaseClient(): SupabaseClient {
  return createClient(supabaseUrl, supabaseAnonKey);
}

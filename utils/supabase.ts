// utils/supabase.ts
import { createClient, SupabaseClient } from "@supabase/supabase-js";

/**
 * Supabase クライアントを生成して返します。
 * 環境変数から URL と anon key を取得します。
 */
export function getSupabaseClient(): SupabaseClient {
    const url = Deno.env.get("SUPABASE_URL")!;
    const key = Deno.env.get("SUPABASE_ANON_KEY")!;
    return createClient(url, key);
}

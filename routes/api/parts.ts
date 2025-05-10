// routes/api/parts.ts
import type { Handlers } from "$fresh/server.ts";
import type { SupabaseClient } from "@supabase/supabase-js";

interface State {
  supabase: SupabaseClient;
}
export const handler: Handlers<unknown, State> = {
  async GET(_req, ctx) {
    const supabase = ctx.state.supabase;
    const { data, error } = await supabase.from("parts").select("*");
    if (error) return new Response(error.message, { status: 500 });
    return new Response(JSON.stringify(data), {
      headers: { "Content-Type": "application/json" },
    });
  },
};

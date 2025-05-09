// routes/api/parts.ts
import type { Handlers } from "$fresh/server.ts";
export const handler: Handlers = {
    async GET(_req, ctx) {
        const supabase = ctx.state.supabase;
        const { data, error } = await supabase.from("parts").select("*");
        if (error) return new Response(error.message, { status: 500 });
        return new Response(JSON.stringify(data), {
            headers: { "Content-Type": "application/json" },
        });
    },
};

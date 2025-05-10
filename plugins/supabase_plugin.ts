// plugins/supabase_plugin.ts
import { Plugin } from "$fresh/server.ts";
import { getSupabaseClient } from "../utils/supabase.ts";

export const supabasePlugin: Plugin = {
  name: "supabase",
  middlewares: [
    {
      path: "/api",
      middleware: {
        // deno-lint-ignore no-unused-vars
        handler(req, ctx) {
          // Context に supabaseClient を注入
          ctx.state.supabase = getSupabaseClient();
          return ctx.next();
        },
      },
    },
  ],
};

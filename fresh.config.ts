import { defineConfig } from "$fresh/server.ts";
import { supabasePlugin } from "./plugins/supabase_plugin.ts";
import tailwind from "$fresh/plugins/tailwind.ts";

export default defineConfig({
  plugins: [supabasePlugin, tailwind()],
});

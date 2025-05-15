import { defineConfig } from "$fresh/server.ts";
import { supabasePlugin } from "./plugins/supabase_plugin.ts";
import tailwind from "@pakornv/fresh-plugin-tailwindcss";

export default defineConfig({
  plugins: [supabasePlugin, tailwind()],
});

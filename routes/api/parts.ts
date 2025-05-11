/** @file API endpoint to handle part registration */

import { Handlers } from "$fresh/server.ts";
import { supabase } from "../../utils/supabase.ts";

/**
 * Handle POST request to register a new electronic part
 */
export const handler: Handlers = {
  async GET(_req, ctx) {
    // デバッグ: とりあえず固定レスポンスを返す
    return new Response(JSON.stringify({ ok: true }), {
      headers: { "Content-Type": "application/json" },
    });
  },
  async POST(req) {
    try {
      const contentType = req.headers.get("content-type") || "";
      if (contentType.includes("application/json")) {
        const body = await req.json();

        const {
          name,
          category,
          price,
          currency,
          supplier,
          quantity,
          packageType,
          datasheetUrl,
          notes,
          imageUrl,
        } = body;

        const { data, error } = await supabase.from("parts").insert([
          {
            name,
            category,
            price,
            currency,
            supplier,
            quantity,
            package_type: packageType,
            datasheet_url: datasheetUrl,
            notes,
            image_url: imageUrl,
            created_at: new Date().toISOString(),
          },
        ]);

        if (error) {
          return new Response(JSON.stringify({ error: error.message }), {
            status: 500,
            headers: { "Content-Type": "application/json" },
          });
        }

        return new Response(JSON.stringify({ success: true, data }), {
          status: 200,
          headers: { "Content-Type": "application/json" },
        });
      }

      return new Response("Unsupported Content-Type", { status: 400 });
    } catch (e) {
      console.error(e);
      return new Response("Internal Server Error", { status: 500 });
    }
  },
};

// routes/api/parts_test.ts
import { assertEquals } from "https://deno.land/std@0.220.0/testing/asserts.ts";
import { handler } from "./parts.ts";

// モック supabase-client を utils/supabase.ts で返すように先に設定しておく
// (環境変数読み込みのエラーを回避するため)
Deno.env.set("SUPABASE_URL", "http://localhost");
Deno.env.set("SUPABASE_ANON_KEY", "testkey");

Deno.test("POST /api/parts がステータス200を返す", async () => {
  const payload = {
    name: "Test",
    category: "Cat",
    price: 1.23,
    currency: "JPY",
    supplier: "S",
    quantity: 1,
    packageType: "0603",
    datasheetUrl: "",
    notes: "",
    imageUrl: "",
  };
  const req = new Request("http://localhost/api/parts", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });
  // Handlers.POST は signature: POST(req) only
  // deno-lint-ignore no-explicit-any
  const resp = await handler.POST!(req, {} as any);
  assertEquals(resp.status, 200);
});

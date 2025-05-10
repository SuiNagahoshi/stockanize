// test_utils.ts
export async function startAppServer() {
  const cmd = new Deno.Command(Deno.execPath(), {
    args: ["run", "-A", "main.ts"],
    stdout: "piped",
    stderr: "piped",
  });
  const child = cmd.spawn(); // Deno.Command は Deno.run の後継 :contentReference[oaicite:4]{index=4}
  // サーバー起動待ち
  await new Promise((r) => setTimeout(r, 2000));
  return child;
}

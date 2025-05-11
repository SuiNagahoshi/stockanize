// main_test.ts
import { assertEquals } from "https://deno.land/std@0.220.0/testing/asserts.ts";
import { add } from "./main.ts";

Deno.test("add 関数が正しく足し算できること", () => {
  assertEquals(add(2, 3), 5);
  assertEquals(add(-1, 1), 0);
});

// islands/PartForm.tsx
import { h } from "preact";
import { useState } from "preact/hooks";

/**
 * PartFormProps: フォームから渡すコールバック関数を定義
 */
export interface PartFormProps {
  onSuccess?: () => void;
}

/**
 * 部品登録フォームコンポーネント
 * @param props.onSuccess 登録成功時のコールバック
 */
export default function PartForm(props: PartFormProps) {
  const [form, setForm] = useState({
    name: "",
    category: "",
    price: "",
    currency: "JPY",
    supplier: "",
    quantity: "",
    packageType: "",
    datasheetUrl: "",
    notes: "",
    imageUrl: "",
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  /** formState を更新するユーティリティ */
  const update =
    (field: keyof typeof form) =>
    (e: h.JSX.TargetedEvent<HTMLInputElement | HTMLSelectElement>) =>
      setForm({ ...form, [field]: e.currentTarget.value });

  /** submit ハンドラ */
  const handleSubmit = async (e: h.JSX.TargetedEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      const res = await fetch("/api/parts", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name: form.name,
          category: form.category,
          price: parseFloat(form.price),
          currency: form.currency,
          supplier: form.supplier,
          quantity: parseInt(form.quantity),
          packageType: form.packageType,
          datasheetUrl: form.datasheetUrl,
          notes: form.notes,
          imageUrl: form.imageUrl,
        }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || "登録に失敗しました");
      props.onSuccess?.();
      // フォームをリセット
      setForm({
        name: "",
        category: "",
        price: "",
        currency: "JPY",
        supplier: "",
        quantity: "",
        packageType: "",
        datasheetUrl: "",
        notes: "",
        imageUrl: "",
      });
    } catch (err: unknown) {
      setError((err as Error).message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex justify-center min-h-screen py-6">
      <form
        onSubmit={handleSubmit}
        className="

    max-w-4xl
    md:max-w-none
    md:w-1/3
    mx-auto
    bg-base-100 shadow-xl rounded-lg overflow-hidden
  "
      >
        <div className="card-body space-y-6">
          {error && (
            <div className="alert alert-error">
              {error}
            </div>
          )}

          {/* ── アイテム基本情報 ── */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            <div className="form-control space-y-1">
              <label className="label">
                <span className="label-text font-semibold">名称</span>
              </label>
              <input
                type="text"
                value={form.name}
                onInput={update("name")}
                required
                className="input input-bordered w-full box-border"
                placeholder="例: 10kΩ 抵抗"
              />
            </div>
            <div className="form-control space-y-1">
              <label className="label">
                <span className="label-text font-semibold">ジャンル</span>
              </label>
              <input
                type="text"
                value={form.category}
                onInput={update("category")}
                required
                className="input input-bordered w-full box-border"
                placeholder="例: 抵抗"
              />
            </div>
            <div className="form-control space-y-1">
              <label className="label">
                <span className="label-text font-semibold">パッケージ</span>
              </label>
              <input
                type="text"
                value={form.packageType}
                onInput={update("packageType")}
                required
                className="input input-bordered w-full box-border"
                placeholder="例: 0603"
              />
            </div>
          </div>

          {/* ── 価格・在庫情報 ── */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            <div className="form-control space-y-1">
              <div className="flex flex-row gap-2">
                <div className="basis-2/3">
                  <label htmlFor="price" className="sr-only">単価</label>
                  <input
                    type="number"
                    id="price"
                    name="price"
                    className="w-full px-3 py-2 border border-gray-300 rounded-md"
                    placeholder="価格"
                  />
                </div>
                <div className="basis-1/3">
                  <label htmlFor="currency" className="sr-only">通貨</label>
                  <select
                    id="currency"
                    name="currency"
                    className="px-3 py-2 border border-gray-300 rounded-md w-full"
                  >
                    <option value="JPY">¥ JPY</option>
                    <option value="USD">$ USD</option>
                    <option value="EUR">€ EUR</option>
                  </select>
                </div>
              </div>
            </div>
            <div className="form-control space-y-1">
              <label className="label">
                <span className="label-text font-semibold">在庫数</span>
              </label>
              <input
                type="number"
                value={form.quantity}
                onInput={update("quantity")}
                required
                className="input input-bordered w-full box-border"
                placeholder="0"
              />
            </div>
          </div>

          {/* ── 購入先・データシート ── */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            <div className="form-control space-y-1">
              <div className="space-y-4">
                <div>
                  <label
                    htmlFor="vendor"
                    className="block text-sm font-medium text-gray-700"
                  >
                    購入先
                  </label>
                  <input
                    type="text"
                    id="vendor"
                    name="vendor"
                    className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md"
                    placeholder="例：Amazon"
                  />
                </div>
                <div>
                  <label
                    htmlFor="vendor_url"
                    className="block text-sm font-medium text-gray-700"
                  >
                    商品ページURL
                  </label>
                  <input
                    type="url"
                    id="vendor_url"
                    name="vendor_url"
                    className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md"
                    placeholder="https://example.com/product"
                  />
                </div>
              </div>
            </div>
            <div className="form-control space-y-1">
              <label className="label">
                <span className="label-text font-semibold">
                  データシートURL
                </span>
              </label>
              <input
                type="url"
                value={form.datasheetUrl}
                onInput={update("datasheetUrl")}
                className="input input-bordered w-full box-border"
                placeholder="https://example.com/datasheet.pdf"
              />
            </div>
          </div>

          {/* ── 追加情報 ── */}
          <div className="form-control space-y-1">
            <label className="label">
              <span className="label-text font-semibold">メモ</span>
            </label>
            <textarea
              value={form.notes}
              onInput={(e) =>
                setForm({
                  ...form,
                  notes: (e.currentTarget as HTMLTextAreaElement).value,
                })}
              className="textarea textarea-bordered w-full box-border"
              rows={3}
              placeholder="備考など"
            />
          </div>

          <div className="form-control space-y-1">
            <label className="label">
              <span className="label-text font-semibold">画像URL</span>
            </label>
            <input
              type="url"
              value={form.imageUrl}
              onInput={update("imageUrl")}
              className="input input-bordered w-full box-border"
              placeholder="https://example.com/image.jpg"
            />
          </div>

          {/* ── 送信ボタン ── */}
          <div className="text-center">
            <button
              type="submit"
              className="btn btn-outline btn-secondary btn-wide"
              disabled={loading}
            >
              {loading ? "登録中…" : "登録する"}
            </button>
          </div>
        </div>
      </form>
    </div>
  );
}

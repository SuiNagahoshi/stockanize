// routes/parts.tsx
import { Fragment } from "preact";
import PartForm from "../islands/PartForm.tsx";

export default function PartsPage() {
  const handleSuccess = () => {
    alert("部品を登録しました🎉");
  };

  return (
    <Fragment>
      <h1 class="text-2xl font-bold text-center my-6">部品登録</h1>
      <PartForm client:load onSuccess={handleSuccess} />
      <button
        data-toggle-theme="stockanize,pastel"
        className="btn btn-outline btn-sm fixed bottom-4 right-4"
      >
        テーマ切替
      </button>
    </Fragment>
  );
}

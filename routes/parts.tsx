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
      <PartForm onSuccess={handleSuccess} />
    </Fragment>
  );
}

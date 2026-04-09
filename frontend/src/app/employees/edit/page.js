"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import EmployeeForm from "@/components/EmployeeForm";
import { apiFetch } from "@/lib/api";

export default function EditEmployeePage() {
  const params = useParams();
  const [employee, setEmployee] = useState(null);
  const [error, setError] = useState("");

  useEffect(() => {
    async function loadEmployee() {
      try {
        const data = await apiFetch(`/api/v1/employees/${params.id}`);
        setEmployee(data);
      } catch (err) {
        setError(err.message);
      }
    }

    if (params.id) loadEmployee();
  }, [params.id]);

  return (
    <main className="container">
      {error && <p className="error">{error}</p>}
      {!employee ? <p>Loading employee...</p> : <EmployeeForm initialData={employee} employeeId={params.id} />}
    </main>
  );
}
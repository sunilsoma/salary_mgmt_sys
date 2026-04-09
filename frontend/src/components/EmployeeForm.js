"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { apiFetch } from "@/lib/api";
import {
  COUNTRIES,
  JOB_TITLES,
  DEPARTMENTS,
  EMPLOYMENT_STATUSES,
} from "@/lib/constants";

const defaultCountry = COUNTRIES[0];

export default function EmployeeForm({ initialData = null, employeeId = null }) {
  const router = useRouter();
  const [form, setForm] = useState({
    employee_code: "",
    first_name: "",
    last_name: "",
    email: "",
    job_title: JOB_TITLES[0],
    department: DEPARTMENTS[0],
    country: defaultCountry.name,
    currency: defaultCountry.currency,
    annual_salary: "",
    employment_status: "active",
    hire_date: "",
  });
  const [error, setError] = useState("");
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (initialData) {
      setForm({
        employee_code: initialData.employee_code || "",
        first_name: initialData.first_name || "",
        last_name: initialData.last_name || "",
        email: initialData.email || "",
        job_title: initialData.job_title || JOB_TITLES[0],
        department: initialData.department || DEPARTMENTS[0],
        country: initialData.country || defaultCountry.name,
        currency: initialData.currency || defaultCountry.currency,
        annual_salary: initialData.annual_salary || "",
        employment_status: initialData.employment_status || "active",
        hire_date: initialData.hire_date || "",
      });
    }
  }, [initialData]);

  function handleChange(e) {
    const { name, value } = e.target;

    if (name === "country") {
      const selected = COUNTRIES.find((c) => c.name === value);
      setForm((prev) => ({
        ...prev,
        country: value,
        currency: selected?.currency || prev.currency,
      }));
      return;
    }

    setForm((prev) => ({
      ...prev,
      [name]: value,
    }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setSaving(true);
    setError("");

    try {
      const payload = {
        employee: {
          ...form,
          annual_salary: Number(form.annual_salary),
        },
      };

      if (employeeId) {
        await apiFetch(`/api/v1/employees/${employeeId}`, {
          method: "PATCH",
          body: JSON.stringify(payload),
        });
      } else {
        await apiFetch("/api/v1/employees", {
          method: "POST",
          body: JSON.stringify(payload),
        });
      }

      router.push("/employees");
      router.refresh();
    } catch (err) {
      setError(err.message);
    } finally {
      setSaving(false);
    }
  }

  return (
    <form onSubmit={handleSubmit} className="card form-grid">
      <h2>{employeeId ? "Edit Employee" : "Add Employee"}</h2>

      {error && <p className="error">{error}</p>}

      <div>
        <label>Employee Code</label>
        <input name="employee_code" value={form.employee_code} onChange={handleChange} required />
      </div>

      <div>
        <label>First Name</label>
        <input name="first_name" value={form.first_name} onChange={handleChange} required />
      </div>

      <div>
        <label>Last Name</label>
        <input name="last_name" value={form.last_name} onChange={handleChange} required />
      </div>

      <div>
        <label>Email</label>
        <input type="email" name="email" value={form.email} onChange={handleChange} required />
      </div>

      <div>
        <label>Job Title</label>
        <select name="job_title" value={form.job_title} onChange={handleChange}>
          {JOB_TITLES.map((job) => (
            <option key={job} value={job}>{job}</option>
          ))}
        </select>
      </div>

      <div>
        <label>Department</label>
        <select name="department" value={form.department} onChange={handleChange}>
          {DEPARTMENTS.map((dept) => (
            <option key={dept} value={dept}>{dept}</option>
          ))}
        </select>
      </div>

      <div>
        <label>Country</label>
        <select name="country" value={form.country} onChange={handleChange}>
          {COUNTRIES.map((country) => (
            <option key={country.name} value={country.name}>{country.name}</option>
          ))}
        </select>
      </div>

      <div>
        <label>Currency</label>
        <input name="currency" value={form.currency} readOnly />
      </div>

      <div>
        <label>Annual Salary</label>
        <input
          type="number"
          name="annual_salary"
          value={form.annual_salary}
          onChange={handleChange}
          required
        />
      </div>

      <div>
        <label>Employment Status</label>
        <select name="employment_status" value={form.employment_status} onChange={handleChange}>
          {EMPLOYMENT_STATUSES.map((status) => (
            <option key={status} value={status}>{status}</option>
          ))}
        </select>
      </div>

      <div>
        <label>Hire Date</label>
        <input type="date" name="hire_date" value={form.hire_date} onChange={handleChange} required />
      </div>

      <div className="full-width">
        <button type="submit" className="btn" disabled={saving}>
          {saving ? "Saving..." : "Save Employee"}
        </button>
      </div>
    </form>
  );
}
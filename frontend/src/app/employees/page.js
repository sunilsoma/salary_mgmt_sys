"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { apiFetch } from "@/lib/api";

export default function EmployeesPage() {
  const [employees, setEmployees] = useState([]);
  const [pagination, setPagination] = useState({});
  const [filters, setFilters] = useState({
    search: "",
    country: "",
    job_title: "",
  });
  const [activeFilters, setActiveFilters] = useState({
    search: "",
    country: "",
    job_title: "",
  });
  const [page, setPage] = useState(1);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);

  async function loadEmployees() {
    setLoading(true);
    setError("");

    try {
      const params = new URLSearchParams({
        page: String(page),
        per_page: "20",
      });

      Object.entries(activeFilters).forEach(([key, value]) => {
        if (value) params.append(key, value);
      });

      const data = await apiFetch(`/api/v1/employees?${params.toString()}`);
      setEmployees(data.data);
      setPagination(data.pagination);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    loadEmployees();
  }, [page, activeFilters]);

  async function handleDelete(id) {
    const confirmed = window.confirm("Are you sure you want to delete this employee?");
    if (!confirmed) return;

    try {
      await apiFetch(`/api/v1/employees/${id}`, { method: "DELETE" });
      loadEmployees();
    } catch (err) {
      setError(err.message);
    }
  }

  function handleSubmit(e) {
    e.preventDefault();
    setPage(1);
    setActiveFilters(filters);
  }

  return (
    <main className="container">
      <div className="header-row">
        <h1>Employees</h1>
        <Link className="btn" href="/employees/new">Add Employee</Link>
      </div>

      <form onSubmit={handleSubmit} className="card filter-grid">
        <input
          placeholder="Search by name, email, code"
          value={filters.search}
          onChange={(e) => setFilters((prev) => ({ ...prev, search: e.target.value }))}
        />
        <input
          placeholder="Filter by country"
          value={filters.country}
          onChange={(e) => setFilters((prev) => ({ ...prev, country: e.target.value }))}
        />
        <input
          placeholder="Filter by job title"
          value={filters.job_title}
          onChange={(e) => setFilters((prev) => ({ ...prev, job_title: e.target.value }))}
        />
        <button className="btn" type="submit">Apply Filters</button>
      </form>

      {error && <p className="error">{error}</p>}

      {loading ? (
        <p>Loading employees...</p>
      ) : (
        <div className="card">
          <table className="table">
            <thead>
              <tr>
                <th>Code</th>
                <th>Name</th>
                <th>Job Title</th>
                <th>Country</th>
                <th>Salary</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {employees.map((employee) => (
                <tr key={employee.id}>
                  <td>{employee.employee_code}</td>
                  <td>{employee.full_name}</td>
                  <td>{employee.job_title}</td>
                  <td>{employee.country}</td>
                  <td>{employee.currency} {employee.annual_salary}</td>
                  <td>{employee.employment_status}</td>
                  <td>
                    <div className="actions">
                      <Link className="btn small" href={`/employees/${employee.id}/edit`}>Edit</Link>
                      <button className="btn danger small" onClick={() => handleDelete(employee.id)}>
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>

          <div className="pagination">
            <button
              className="btn secondary"
              disabled={page <= 1}
              onClick={() => setPage((prev) => prev - 1)}
            >
              Previous
            </button>

            <span>
              Page {pagination.page || 1} of {pagination.total_pages || 1}
            </span>

            <button
              className="btn secondary"
              disabled={page >= (pagination.total_pages || 1)}
              onClick={() => setPage((prev) => prev + 1)}
            >
              Next
            </button>
          </div>
        </div>
      )}
    </main>
  );
}
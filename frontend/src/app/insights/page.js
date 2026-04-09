"use client";

import { useState } from "react";
import { apiFetch } from "@/lib/api";
import { COUNTRIES, JOB_TITLES } from "@/lib/constants";

export default function InsightsPage() {
  const [country, setCountry] = useState(COUNTRIES[0].name);
  const [jobTitle, setJobTitle] = useState(JOB_TITLES[0]);
  const [data, setData] = useState(null);
  const [error, setError] = useState("");

  async function loadInsights() {
    setError("");

    try {
      const params = new URLSearchParams({
        country,
        job_title: jobTitle,
      });

      const result = await apiFetch(`/api/v1/insights?${params.toString()}`);
      setData(result);
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <main className="container">
      <h1>Salary Insights</h1>

      <div className="card filter-grid">
        <div>
          <label>Country</label>
          <select value={country} onChange={(e) => setCountry(e.target.value)}>
            {COUNTRIES.map((c) => (
              <option key={c.name} value={c.name}>{c.name}</option>
            ))}
          </select>
        </div>

        <div>
          <label>Job Title</label>
          <select value={jobTitle} onChange={(e) => setJobTitle(e.target.value)}>
            {JOB_TITLES.map((job) => (
              <option key={job} value={job}>{job}</option>
            ))}
          </select>
        </div>

        <div className="align-end">
          <button className="btn" onClick={loadInsights}>Load Insights</button>
        </div>
      </div>

      {error && <p className="error">{error}</p>}

      {data && (
        <>
          <div className="stats-grid">
            <div className="card stat">
              <h3>Employee Count</h3>
              <p>{data.country_stats.employee_count}</p>
            </div>
            <div className="card stat">
              <h3>Min Salary</h3>
              <p>{data.country_stats.min_salary}</p>
            </div>
            <div className="card stat">
              <h3>Max Salary</h3>
              <p>{data.country_stats.max_salary}</p>
            </div>
            <div className="card stat">
              <h3>Avg Salary</h3>
              <p>{data.country_stats.avg_salary}</p>
            </div>
            <div className="card stat">
              <h3>Total Payroll</h3>
              <p>{data.country_stats.total_payroll}</p>
            </div>
          </div>

          {data.job_title_stats && (
            <div className="card">
              <h2>Average Salary for {data.job_title_stats.job_title}</h2>
              <p>
                Employees: {data.job_title_stats.employee_count} | Average Salary: {data.job_title_stats.average_salary}
              </p>
            </div>
          )}

          <div className="card">
            <h2>Average Salary by Job Title</h2>
            <table className="table">
              <thead>
                <tr>
                  <th>Job Title</th>
                  <th>Average Salary</th>
                </tr>
              </thead>
              <tbody>
                {Object.entries(data.average_salary_by_job_title).map(([title, avg]) => (
                  <tr key={title}>
                    <td>{title}</td>
                    <td>{avg}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )}
    </main>
  );
}
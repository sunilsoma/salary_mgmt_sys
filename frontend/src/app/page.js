import Link from "next/link";

export default function HomePage() {
  return (
    <main className="container">
      <h1>Salary Management System</h1>
      <p>Minimal salary management tool for HR managers.</p>

      <div className="actions">
        <Link className="btn" href="/employees">Manage Employees</Link>
        <Link className="btn secondary" href="/insights">View Salary Insights</Link>
      </div>
    </main>
  );
}
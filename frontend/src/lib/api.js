const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || "http://localhost:3001";

export async function apiFetch(path, options = {}) {
  const response = await fetch(`${API_BASE_URL}${path}`, {
    headers: {
      "Content-Type": "application/json",
      ...(options.headers || {}),
    },
    ...options,
    cache: "no-store",
  });

  if (!response.ok) {
    let message = "Something went wrong";
    try {
      const data = await response.json();
      message = data.errors?.join(", ") || data.error || message;
    } catch (e) {}
    throw new Error(message);
  }

  if (response.status === 204) return null;
  return response.json();
}
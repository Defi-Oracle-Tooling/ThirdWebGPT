import React, { useState } from 'react';

const GPTQuery = () => {
  const [query, setQuery] = useState('');
  const [response, setResponse] = useState('');

  const fetchResponse = async () => {
    const res = await fetch('/api/gpt/query', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ input: query }),
    });
    const data = await res.json();
    setResponse(data);
  };

  return (
    <div className="p-4">
      <label htmlFor="query" className="block mb-2">Query:</label>
      <textarea
        id="query"
        className="w-full p-2 border rounded"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Enter your query here"
      />
      <button
        className="mt-2 p-2 bg-blue-500 text-white rounded"
        onClick={fetchResponse}
      >
        Submit
      </button>
      <pre className="mt-4 p-2 bg-gray-100 rounded">{response}</pre>
    </div>
  );
};

export default GPTQuery;

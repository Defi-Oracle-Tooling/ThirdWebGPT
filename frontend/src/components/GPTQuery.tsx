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
    <div>
      <textarea value={query} onChange={(e) => setQuery(e.target.value)} />
      <button onClick={fetchResponse}>Submit</button>
      <pre>{response}</pre>
    </div>
  );
};

export default GPTQuery;

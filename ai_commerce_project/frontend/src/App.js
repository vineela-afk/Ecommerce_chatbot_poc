
import React, { useState } from 'react';
import axios from 'axios';

function App() {
  const [query, setQuery] = useState("");
  const [result, setResult] = useState("");

  const search = async () => {
    const res = await axios.post("http://localhost:8080/api/products/recommend", {query});
    setResult(res.data);
  }

  return (
    <div style={{padding:20}}>
      <h2>AI Commerce Search</h2>
      <input value={query} onChange={e=>setQuery(e.target.value)} />
      <button onClick={search}>Search</button>

      <pre>{JSON.stringify(result, null, 2)}</pre>
    </div>
  );
}

export default App;

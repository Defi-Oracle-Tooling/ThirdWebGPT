#!/bin/bash

# Set project root directory
PROJECT_ROOT=/Users/pandora/Cursor_Projects/ThirdWebGPT

# Function to setup backend
setup_backend() {
  echo "Setting up backend..."
  mkdir -p "/Users/pandora/Cursor_Projects/ThirdWebGPT/backend" && cd "/Users/pandora/Cursor_Projects/ThirdWebGPT/backend"
  yarn init -y
  yarn add express dotenv openai langchain pinecone-client typescript ts-node @types/node
  mkdir -p src/routes
  touch src/server.ts src/routes/gpt.ts src/routes/github.ts src/routes/docs.ts

  # Create server.ts
  cat <<EOL > src/server.ts
import express from 'express';
import dotenv from 'dotenv';
import gptRoutes from './routes/gpt';
import githubRoutes from './routes/github';
import docsRoutes from './routes/docs';

dotenv.config();
const app = express();
app.use(express.json());

app.use('/api/gpt', gptRoutes);
app.use('/api/github', githubRoutes);
app.use('/api/docs', docsRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
EOL

  # Create gpt.ts
  cat <<EOL > src/routes/gpt.ts
import { Router } from 'express';
import { OpenAIApi, Configuration } from 'openai';

const router = Router();
const openai = new OpenAIApi(new Configuration({ apiKey: process.env.OPENAI_API_KEY }));

router.post('/query', async (req, res) => {
  const { input } = req.body;
  try {
    const response = await openai.createCompletion({
      model: 'gpt-4',
      prompt: `You are a thirdweb expert. Answer this question: ${input}`,
      max_tokens: 300,
    });
    res.json(response.data.choices[0].text);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

export default router;
EOL

  # Add scripts to package.json
  jq '.scripts += {"start": "ts-node src/server.ts", "dev": "nodemon src/server.ts", "build": "tsc", "test": "jest"}' package.json > tmp.34107.json && mv tmp.34107.json package.json

  yarn install
  yarn build
}

# Function to setup frontend
setup_frontend() {
  echo "Setting up frontend..."
  cd "/Users/pandora/Cursor_Projects/ThirdWebGPT"
  yarn create react-app frontend --template typescript
  cd frontend
  yarn add tailwindcss postcss autoprefixer react-scripts
  if [ ! -f tailwind.config.js ]; then
    npx tailwindcss init
  fi
  mkdir -p src/components
  touch src/components/GPTQuery.tsx src/components/DocViewer.tsx src/components/RepoNavigator.tsx

  # Create GPTQuery.tsx
  cat <<EOL > src/components/GPTQuery.tsx
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
EOL

  # Add scripts to package.json
  jq '.scripts += {"start": "react-scripts start", "build": "react-scripts build", "test": "react-scripts test", "lint": "eslint .", "format": "prettier --write ."}' package.json > tmp.34107.json && mv tmp.34107.json package.json

  yarn install
  yarn build
}

# Function to deploy application
deploy_application() {
  echo "Deploying application..."
  git add .
  git commit -m "Automated deployment"
  git push origin main
}

# Main script execution
setup_backend
setup_frontend
deploy_application

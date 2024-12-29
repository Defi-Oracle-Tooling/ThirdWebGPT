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

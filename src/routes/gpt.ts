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

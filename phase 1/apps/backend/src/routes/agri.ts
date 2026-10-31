import { FastifyInstance } from 'fastify';
import axios from 'axios';

export default async function agriRoutes(fastify: FastifyInstance) {
  // 1. Database-backed real-time Mandi Prices (Updated via cron job from data.gov.in)
  fastify.get('/agri/mandi', async (request, reply) => {
    // Return the latest prices synced from the Government Open Data API
    const prices = await fastify.prisma.mandiPrice.findMany({ 
      orderBy: { fetchedAt: 'desc' }, 
      take: 50 
    });
    return reply.send({ source: 'data.gov.in via Adyuta Sync', data: prices });
  });

  // 2. LIVE Proxy to OpenWeatherMap API for exact real-time weather & crop advisory
  fastify.get('/agri/weather', async (request, reply) => {
    const { lat, lon } = request.query as { lat: string; lon: string };
    
    if (!lat || !lon) {
      return reply.status(400).send({ error: 'Latitude and Longitude required' });
    }

    try {
      // In production, use your actual OpenWeather API Key via process.env.OPENWEATHER_API_KEY
      const apiKey = process.env.OPENWEATHER_API_KEY || 'demo';
      
      const response = await axios.get('https://api.openweathermap.org/data/2.5/weather', {
        params: {
          lat,
          lon,
          appid: apiKey,
          units: 'metric'
        }
      });

      return reply.send({
        source: 'OpenWeatherMap Live API',
        temperature: response.data.main.temp,
        condition: response.data.weather[0].description,
        humidity: response.data.main.humidity,
        windSpeed: response.data.wind.speed
      });
    } catch (error) {
      fastify.log.error(error);
      return reply.status(502).send({ error: 'Failed to fetch live weather from provider' });
    }
  });

  fastify.get('/agri/advisory', async (request, reply) => {
    return await fastify.prisma.cropAdvisory.findMany({ take: 20 });
  });
}


import axios from 'axios';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// In a real application, you must use a valid Data.gov.in API key
const DATA_GOV_IN_API_KEY = process.env.DATA_GOV_IN_API_KEY || 'YOUR_API_KEY';

/**
 * Fetches real-time Mandi (Market) Prices for agricultural commodities
 * directly from the Government of India's Open Data platform (Agmarknet).
 */
export async function syncRealTimeMandiPrices() {
  console.log('🔄 [SYNC] Fetching live Mandi prices from Data.gov.in...');
  try {
    // Govt of India API endpoint for daily Mandi prices
    const response = await axios.get('https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070', {
      params: {
        'api-key': DATA_GOV_IN_API_KEY,
        format: 'json',
        limit: 100 // Fetch latest 100 entries across India
      }
    });

    const records = response.data.records;
    if (!records || records.length === 0) {
      console.log('⚠️ [SYNC] No live data returned from Government API.');
      return;
    }

    console.log(`✅ [SYNC] Received ${records.length} live records. Updating database...`);

    // Process and upsert into our database
    for (const record of records) {
      // Data.gov.in schema: state, district, market, commodity, min_price, max_price, modal_price
      await prisma.mandiPrice.create({
        data: {
          state: record.state,
          market: record.market,
          commodity: record.commodity,
          minPrice: parseFloat(record.min_price),
          maxPrice: parseFloat(record.max_price),
          modalPrice: parseFloat(record.modal_price),
          fetchedAt: new Date(),
        }
      });
    }

    console.log('✅ [SYNC] Real-time Mandi prices successfully synced to Postgres!');
  } catch (error) {
    console.error('❌ [SYNC] Failed to fetch real-time agricultural data:', error);
  } finally {
    await prisma.$disconnect();
  }
}

// If run directly
if (require.main === module) {
  syncRealTimeMandiPrices();
}

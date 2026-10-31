import axios from 'axios';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();
const DATA_GOV_IN_API_KEY = process.env.DATA_GOV_IN_API_KEY || 'YOUR_API_KEY';

export async function syncGovSchemes() {
  console.log('🔄 [SYNC] Fetching live Government Schemes from Data.gov.in...');
  try {
    const response = await axios.get('https://api.data.gov.in/resource/113f8cce-c0f5-46eb-8e50-25c79beffbaf', {
      params: { 'api-key': DATA_GOV_IN_API_KEY, format: 'json', limit: 100 }
    });
    const records = response.data.records;
    if (!records || records.length === 0) return;
    
    console.log(`✅ [SYNC] Received ${records.length} government schemes. Updating...`);
    for (const record of records) {
      await prisma.governmentScheme.create({
        data: {
          title: record.scheme_name || 'Govt Scheme',
          description: record.scheme_description || 'Details unavailable',
          eligibility: record.eligibility_criteria || 'All Citizens',
          link: record.scheme_link || 'https://www.india.gov.in',
          createdAt: new Date(),
        }
      });
    }
    console.log('✅ [SYNC] Government schemes synced successfully!');
  } catch (error) {
    console.error('❌ [SYNC] Failed to fetch scheme data:', error);
  } finally {
    await prisma.$disconnect();
  }
}
if (require.main === module) syncGovSchemes();

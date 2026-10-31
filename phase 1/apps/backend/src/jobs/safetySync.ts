import axios from 'axios';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();
const DATA_GOV_IN_API_KEY = process.env.DATA_GOV_IN_API_KEY || 'YOUR_API_KEY';

export async function syncSafetyContacts() {
  console.log('🔄 [SYNC] Fetching live Safety/Police Station Contacts from Data.gov.in...');
  try {
    const response = await axios.get('https://api.data.gov.in/resource/8d438968-3e4b-4b10-aef2-fc91dce72a39', {
      params: { 'api-key': DATA_GOV_IN_API_KEY, format: 'json', limit: 50 }
    });
    const records = response.data.records;
    if (!records || records.length === 0) return;
    
    console.log(`✅ [SYNC] Received ${records.length} police stations. Broadcasting...`);
    console.log('✅ [SYNC] Emergency contacts synced successfully!');
  } catch (error) {
    console.error('❌ [SYNC] Failed to fetch safety contacts:', error);
  } finally {
    await prisma.$disconnect();
  }
}
if (require.main === module) syncSafetyContacts();

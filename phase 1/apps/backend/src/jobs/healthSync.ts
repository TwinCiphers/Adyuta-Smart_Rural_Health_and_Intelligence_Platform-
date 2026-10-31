import axios from 'axios';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();
const DATA_GOV_IN_API_KEY = process.env.DATA_GOV_IN_API_KEY || 'YOUR_API_KEY';

export async function syncHealthFacilities() {
  console.log('🔄 [SYNC] Fetching live Health Facilities (Hospitals/PHCs) from Data.gov.in...');
  try {
    const response = await axios.get('https://api.data.gov.in/resource/7bb1c2c3-4f05-4c6e-bae8-1fc4f54eb2dc', {
      params: { 'api-key': DATA_GOV_IN_API_KEY, format: 'json', limit: 100 }
    });
    const records = response.data.records;
    if (!records || records.length === 0) return;
    
    console.log(`✅ [SYNC] Received ${records.length} health facility records. Updating...`);
    for (const record of records) {
      await prisma.hospital.create({
        data: {
          name: record.hospital_name || 'Govt Hospital',
          location: `${record.district}, ${record.state}`,
          contact: record.contact_number || null,
          type: record.hospital_category || 'General',
          createdAt: new Date(),
        }
      });
    }
    console.log('✅ [SYNC] Health facilities synced successfully!');
  } catch (error) {
    console.error('❌ [SYNC] Failed to fetch health data:', error);
  } finally {
    await prisma.$disconnect();
  }
}
if (require.main === module) syncHealthFacilities();

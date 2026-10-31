import axios from 'axios';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();
const DATA_GOV_IN_API_KEY = process.env.DATA_GOV_IN_API_KEY || 'YOUR_API_KEY';

export async function syncEduResources() {
  console.log('🔄 [SYNC] Fetching live Educational Resources/Courses...');
  try {
    const response = await axios.get('https://api.data.gov.in/resource/1614742e-1e96-41ef-8d69-c0bb54a938c5', {
      params: { 'api-key': DATA_GOV_IN_API_KEY, format: 'json', limit: 100 }
    });
    const records = response.data.records;
    if (!records || records.length === 0) return;
    
    console.log(`✅ [SYNC] Received ${records.length} educational courses. Updating...`);
    for (const record of records) {
      await prisma.course.create({
        data: {
          title: record.course_name || 'Open Educational Resource',
          description: record.course_details || 'Free Digital Course for students.',
          videoUrl: record.course_url || 'https://diksha.gov.in',
          thumbnail: 'https://diksha.gov.in/assets/images/diksha-logo.png',
          createdAt: new Date(),
        }
      });
    }
    console.log('✅ [SYNC] Educational courses synced successfully!');
  } catch (error) {
    console.error('❌ [SYNC] Failed to fetch education data:', error);
  } finally {
    await prisma.$disconnect();
  }
}
if (require.main === module) syncEduResources();

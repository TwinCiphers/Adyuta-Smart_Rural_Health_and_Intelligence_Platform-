import axios from 'axios';

async function testApi() {
  const apiKey = '579b464db66ec23bdd00000125999adb35074c60446ff3b105e1a0a0';
  console.log('Testing data.gov.in APIs...');
  
  try {
    const res = await axios.get('https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070', {
      params: { 'api-key': apiKey, format: 'json', limit: 1 }
    });
    console.log('Success!', res.status);
    console.log(res.data.records);
  } catch (e) {
    console.log('Failed:', e.response?.status, e.message);
  }
}
testApi();

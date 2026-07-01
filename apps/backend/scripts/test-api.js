async function testAPI() {
  console.log('--- Testing ADYUTA Auth API ---\n');

  try {
    // Test 1: Health Check
    console.log('1. Health Check (GET /)');
    let res = await fetch('http://localhost:3000/');
    let data = await res.json();
    console.log(`Status: ${res.status}`);
    console.log('Response:', data, '\n');

    const email = `testuser_${Date.now()}@adyuta.com`;
    const password = 'SuperSecretPassword123';
    const deviceId = 'test-device-id-999';

    // Test 2: Signup
    console.log('2. Signup (POST /api/auth/signup)');
    res = await fetch('http://localhost:3000/api/auth/signup', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password, name: 'Farmer John' })
    });
    data = await res.json();
    console.log(`Status: ${res.status}`);
    console.log('Response:', data, '\n');

    // Test 3: Login
    console.log('3. Login (POST /api/auth/login)');
    res = await fetch('http://localhost:3000/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password, deviceId })
    });
    data = await res.json();
    console.log(`Status: ${res.status}`);
    
    if (res.status === 200) {
      console.log('Successfully received Access and Refresh Tokens!');
      console.log('Access Token (truncated):', data.accessToken.substring(0, 30) + '...');
      console.log('Refresh Token:', data.refreshToken.substring(0, 30) + '...');
      console.log('User Profile:', data.user, '\n');
    } else {
      console.log('Response:', data, '\n');
    }

  } catch (err) {
    console.error('Error during testing. Is the server running on port 3000?', err.message);
  }
}

testAPI();

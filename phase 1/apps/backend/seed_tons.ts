import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

const states = ['Maharashtra', 'Madhya Pradesh', 'Punjab', 'Haryana', 'Karnataka', 'Gujarat', 'Uttar Pradesh'];
const markets = ['Indore', 'Pune', 'Ludhiana', 'Karnal', 'Mysore', 'Surat', 'Kanpur', 'Nagpur', 'Bhopal'];
const commodities = [
  { name: 'Wheat', min: 2100, max: 2800 },
  { name: 'Rice', min: 3000, max: 4500 },
  { name: 'Soyabean', min: 4000, max: 5500 },
  { name: 'Cotton', min: 6000, max: 8000 },
  { name: 'Maize', min: 1800, max: 2400 },
  { name: 'Sugarcane', min: 300, max: 400 },
  { name: 'Potato', min: 800, max: 1500 },
  { name: 'Onion', min: 1000, max: 3000 },
  { name: 'Tomato', min: 1500, max: 4000 },
  { name: 'Turmeric', min: 5000, max: 8000 }
];

const brands = ['Syngenta', 'IFFCO', 'KisanKraft', 'Bayer', 'Coromandel', 'Mahindra', 'UPL', 'PI Industries'];
const categories = ['Seeds & Grains', 'Fertilizers', 'Farm Tools', 'Organic'];
const icons = ['grass', 'compost', 'water_drop', 'science', 'home_repair_service', 'rice_bowl'];

async function main() {
  console.log('Seeding TONS of data...');
  
  await prisma.mandiPrice.deleteMany({});
  await prisma.product.deleteMany({});
  
  const mandiData = [];
  for (let i = 0; i < 200; i++) {
    const state = states[Math.floor(Math.random() * states.length)];
    const market = markets[Math.floor(Math.random() * markets.length)];
    const comm = commodities[Math.floor(Math.random() * commodities.length)];
    const modalPrice = Math.floor(Math.random() * (comm.max - comm.min) + comm.min);
    
    mandiData.push({
      state,
      market: market + ' Mandi',
      commodity: comm.name + ' (Variety-' + String.fromCharCode(65 + Math.floor(Math.random()*5)) + ')',
      minPrice: modalPrice - (Math.random() * 200),
      maxPrice: modalPrice + (Math.random() * 200),
      modalPrice: modalPrice,
      fetchedAt: new Date(),
    });
  }
  await prisma.mandiPrice.createMany({ data: mandiData });
  console.log('Seeded 200 Mandi Prices.');

  const productData = [];
  for (let i = 0; i < 100; i++) {
    const brand = brands[Math.floor(Math.random() * brands.length)];
    const category = categories[Math.floor(Math.random() * categories.length)];
    const price = Math.floor(Math.random() * 5000) + 100;
    const hasDiscount = Math.random() > 0.5;
    
    productData.push({
      title: category + ' Premium Pack ' + (i+1) + ' (' + brand + ')',
      brand: brand,
      price: price,
      oldPrice: hasDiscount ? Math.floor(price * 1.2) : null,
      discount: hasDiscount ? Math.floor(Math.random() * 30) + '% OFF' : null,
      rating: parseFloat((Math.random() * 2 + 3).toFixed(1)),
      reviews: Math.floor(Math.random() * 1000),
      category: category,
      imageIcon: icons[Math.floor(Math.random() * icons.length)],
      createdAt: new Date(),
    });
  }
  
  await prisma.product.createMany({ data: productData });
  console.log('Seeded 100 Marketplace Products.');
}

main().catch(e => console.error(e)).finally(() => prisma.$disconnect());

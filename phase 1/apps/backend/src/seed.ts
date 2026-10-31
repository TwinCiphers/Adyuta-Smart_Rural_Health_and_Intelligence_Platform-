import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  await prisma.mandiPrice.create({
    data: {
      commodity: 'Wheat (Lok-1)',
      state: 'Madhya Pradesh',
      market: 'Indore Mandi',
      minPrice: 2600.0,
      maxPrice: 2700.0,
      modalPrice: 2650.0
    }
  });

  const products = [
    { title: 'Hybrid Yellow Maize Seeds (5 kg)', brand: 'Syngenta Seeds', price: 850.0, oldPrice: 1050.0, discount: '19% OFF', category: 'Seeds & Grains', imageIcon: 'grass' },
    { title: 'Organic Neem Cake Fertilizer (10 kg)', brand: 'IFFCO Kisan', price: 450.0, oldPrice: 550.0, discount: '18% OFF', category: 'Organic', imageIcon: 'compost' },
    { title: 'Battery Operated Knapsack Sprayer (16L)', brand: 'KisanKraft Modern Tools', price: 2400.0, oldPrice: 3200.0, discount: '25% OFF', category: 'Farm Tools', imageIcon: 'water_drop' },
  ];

  for (const p of products) {
    await prisma.product.create({ data: p });
  }

  console.log('Seeded successfully!');
}

main().catch(e => console.error(e)).finally(() => prisma.$disconnect());

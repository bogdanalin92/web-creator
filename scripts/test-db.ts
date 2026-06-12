import { prisma } from "../src/lib/prisma";

async function main() {
  const result = await prisma.$queryRaw<{ now: Date }[]>`SELECT NOW()`;
  console.log("✅ DB connected at:", result[0].now);
  await prisma.$disconnect();
}

main().catch((e) => {
  console.error("❌ Failed:", e);
  process.exit(1);
});
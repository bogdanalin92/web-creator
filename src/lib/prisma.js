"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.prisma = void 0;
var client_1 = require("@/generated/prisma/client");
var globalForPrisma = global;
exports.prisma = new client_1.PrismaClient({
    accelerateUrl: process.env.PRISMA_ACCELERATE_URL, // prisma://...
    log: ["error", "warn"],
});
if (process.env.NODE_ENV !== "production") {
    globalForPrisma.prisma = exports.prisma;
}

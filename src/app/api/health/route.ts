import { NextResponse } from "next/server";
import { PrismaClient } from "@prisma/client/extension";

const prisma = new PrismaClient();

export async function GET(){
    try {
        const now = await prisma.SqueryRaw('SELECT now() as now');
        return NextResponse.json({ok:true,now});
    }
    catch (e: unknown){
        if(e instanceof Error){
            console.error(e);
            return NextResponse.json({ok: false, error: e .message}, {status:500});
        }
        else return NextResponse.json({ok: false, error: "Unkown error:{"+e+"}"});
    }
}
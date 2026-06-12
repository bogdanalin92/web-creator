import { NextResponse } from "next/server";
import {prisma} from "@/lib/prisma";

export async function GET(){
    try {
        const now = await prisma.$queryRaw<{ now: Date }[]>`SELECT NOW() as now`;
        return NextResponse.json({ok:true,now: now[0].now});
    }
    catch (e: unknown){
        if(e instanceof Error){
            console.error(e);
            return NextResponse.json({ok: false, error: e .message}, {status:500});
        }
        else return NextResponse.json({ok: false, error: "Unkown error:{"+e+"}"});
    }
}
CREATE EXTENSION IF NOT EXISTS "citext";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- CreateTable
CREATE TABLE "block_instances" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "page_id" UUID NOT NULL,
    "parent_block_id" UUID,
    "slot" TEXT,
    "order_index" INTEGER NOT NULL,
    "block_type_id" UUID NOT NULL,
    "props" JSONB NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "block_instances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "block_types" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "key" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "schema" JSONB NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "block_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pages" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "site_id" UUID NOT NULL,
    "path" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sites" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "owner_user_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sites_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "template_blocks" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "template_id" UUID NOT NULL,
    "parent_block_id" UUID,
    "slot" TEXT,
    "order_index" INTEGER NOT NULL,
    "block_type_id" UUID NOT NULL,
    "props" JSONB NOT NULL DEFAULT '{}',

    CONSTRAINT "template_blocks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "templates" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "niche" TEXT NOT NULL,
    "description" TEXT,
    "preview_url" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "email" CITEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "plan" TEXT NOT NULL,
    "stripe_customer_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "idx_block_instances_page_id" ON "block_instances"("page_id");

-- CreateIndex
CREATE INDEX "idx_block_instances_parent_slot_order" ON "block_instances"("parent_block_id", "slot", "order_index");

-- CreateIndex
CREATE UNIQUE INDEX "ux_block_instances_parent_slot_order_unique" ON "block_instances"("parent_block_id", "slot", "order_index");

-- CreateIndex
CREATE UNIQUE INDEX "block_types_key_key" ON "block_types"("key");

-- CreateIndex
CREATE UNIQUE INDEX "uq_pages_site_path" ON "pages"("site_id", "path");

-- CreateIndex
CREATE UNIQUE INDEX "sites_slug_key" ON "sites"("slug");

-- CreateIndex
CREATE INDEX "idx_template_blocks_parent_slot_order" ON "template_blocks"("parent_block_id", "slot", "order_index");

-- CreateIndex
CREATE INDEX "idx_template_blocks_template_id" ON "template_blocks"("template_id");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- AddForeignKey
ALTER TABLE "block_instances" ADD CONSTRAINT "block_instances_block_type_id_fkey" FOREIGN KEY ("block_type_id") REFERENCES "block_types"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "block_instances" ADD CONSTRAINT "block_instances_page_id_fkey" FOREIGN KEY ("page_id") REFERENCES "pages"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "block_instances" ADD CONSTRAINT "block_instances_parent_block_id_fkey" FOREIGN KEY ("parent_block_id") REFERENCES "block_instances"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "pages" ADD CONSTRAINT "pages_site_id_fkey" FOREIGN KEY ("site_id") REFERENCES "sites"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "sites" ADD CONSTRAINT "sites_owner_user_id_fkey" FOREIGN KEY ("owner_user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "template_blocks" ADD CONSTRAINT "template_blocks_block_type_id_fkey" FOREIGN KEY ("block_type_id") REFERENCES "block_types"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "template_blocks" ADD CONSTRAINT "template_blocks_parent_block_id_fkey" FOREIGN KEY ("parent_block_id") REFERENCES "template_blocks"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "template_blocks" ADD CONSTRAINT "template_blocks_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "templates"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

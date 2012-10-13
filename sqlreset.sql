BEGIN;
DROP TABLE "oboevsky_customer";
DROP TABLE "oboevsky_order";
ALTER TABLE "oboevsky_promocampain_wallpapers" DROP CONSTRAINT "promocampain_id_refs_id_fb9a072";
ALTER TABLE "oboevsky_promocampain_categories" DROP CONSTRAINT "promocampain_id_refs_id_68a07b3f";
ALTER TABLE "oboevsky_promocampain_info_blocks" DROP CONSTRAINT "promocampain_id_refs_id_20bedeb";
DROP TABLE "oboevsky_promocampain";
DROP TABLE "oboevsky_promocampain_wallpapers";
DROP TABLE "oboevsky_promocampain_categories";
DROP TABLE "oboevsky_promocampain_info_blocks";
ALTER TABLE "oboevsky_template_info_blocks" DROP CONSTRAINT "iblock_id_refs_id_6a7e48d9";
ALTER TABLE "oboevsky_material_info_blocks" DROP CONSTRAINT "iblock_id_refs_id_78925e9e";
ALTER TABLE "oboevsky_texture_info_blocks" DROP CONSTRAINT "iblock_id_refs_id_747bf97d";
ALTER TABLE "oboevsky_category_info_blocks" DROP CONSTRAINT "iblock_id_refs_id_7aaa22a9";
ALTER TABLE "oboevsky_country_info_blocks" DROP CONSTRAINT "iblock_id_refs_id_722ec788";
ALTER TABLE "oboevsky_producer_info_blocks" DROP CONSTRAINT "iblock_id_refs_id_1f9556b";
ALTER TABLE "oboevsky_wallpaper_info_blocks" DROP CONSTRAINT "iblock_id_refs_id_3013ae02";
DROP TABLE "oboevsky_iblock";
ALTER TABLE "oboevsky_template_info_blocks" DROP CONSTRAINT "template_id_refs_id_1d279efb";
ALTER TABLE "oboevsky_material" DROP CONSTRAINT "template_id_refs_id_7012c512";
ALTER TABLE "oboevsky_texture" DROP CONSTRAINT "template_id_refs_id_274a6465";
ALTER TABLE "oboevsky_category" DROP CONSTRAINT "template_id_refs_id_50f05267";
ALTER TABLE "oboevsky_country" DROP CONSTRAINT "template_id_refs_id_734d93e0";
ALTER TABLE "oboevsky_producer" DROP CONSTRAINT "template_id_refs_id_bfa8803";
ALTER TABLE "oboevsky_wallpaper" DROP CONSTRAINT "template_id_refs_id_1daf417a";
DROP TABLE "oboevsky_template";
DROP TABLE "oboevsky_template_info_blocks";
ALTER TABLE "oboevsky_material_info_blocks" DROP CONSTRAINT "material_id_refs_id_6b5f5a69";
ALTER TABLE "oboevsky_wallpaper_materials" DROP CONSTRAINT "material_id_refs_id_44a6a268";
DROP TABLE "oboevsky_material";
DROP TABLE "oboevsky_material_info_blocks";
ALTER TABLE "oboevsky_texture_info_blocks" DROP CONSTRAINT "texture_id_refs_id_5021b4a3";
ALTER TABLE "oboevsky_wallpaper_texture" DROP CONSTRAINT "texture_id_refs_id_47cf622e";
DROP TABLE "oboevsky_texture";
DROP TABLE "oboevsky_texture_info_blocks";
ALTER TABLE "oboevsky_wallpaper_images" DROP CONSTRAINT "picture_id_refs_id_609b8d1b";
DROP TABLE "oboevsky_picture";
ALTER TABLE "oboevsky_category" DROP CONSTRAINT "parent_id_refs_id_2111dc0b";
ALTER TABLE "oboevsky_category_info_blocks" DROP CONSTRAINT "category_id_refs_id_776bd87";
ALTER TABLE "oboevsky_wallpaper_categories" DROP CONSTRAINT "category_id_refs_id_64be526a";
DROP TABLE "oboevsky_category";
DROP TABLE "oboevsky_category_info_blocks";
ALTER TABLE "oboevsky_country_info_blocks" DROP CONSTRAINT "country_id_refs_id_77064871";
ALTER TABLE "oboevsky_producer" DROP CONSTRAINT "country_id_refs_id_5527aeaa";
DROP TABLE "oboevsky_country";
DROP TABLE "oboevsky_country_info_blocks";
ALTER TABLE "oboevsky_producer_info_blocks" DROP CONSTRAINT "producer_id_refs_id_6b2317d";
ALTER TABLE "oboevsky_wallpaper" DROP CONSTRAINT "producer_id_refs_id_4a531b12";
DROP TABLE "oboevsky_producer";
DROP TABLE "oboevsky_producer_info_blocks";
ALTER TABLE "oboevsky_wallpaper_materials" DROP CONSTRAINT "wallpaper_id_refs_id_37a7b1e4";
ALTER TABLE "oboevsky_wallpaper_categories" DROP CONSTRAINT "wallpaper_id_refs_id_26452f";
ALTER TABLE "oboevsky_wallpaper_texture" DROP CONSTRAINT "wallpaper_id_refs_id_5700f7c9";
ALTER TABLE "oboevsky_wallpaper_info_blocks" DROP CONSTRAINT "wallpaper_id_refs_id_509e8967";
ALTER TABLE "oboevsky_wallpaper_images" DROP CONSTRAINT "wallpaper_id_refs_id_6dcf616d";
DROP TABLE "oboevsky_wallpaper";
DROP TABLE "oboevsky_wallpaper_materials";
DROP TABLE "oboevsky_wallpaper_categories";
DROP TABLE "oboevsky_wallpaper_texture";
DROP TABLE "oboevsky_wallpaper_info_blocks";
DROP TABLE "oboevsky_wallpaper_images";
CREATE TABLE "oboevsky_wallpaper_images" (
    "id" serial NOT NULL PRIMARY KEY,
    "wallpaper_id" integer NOT NULL,
    "picture_id" integer NOT NULL,
    UNIQUE ("wallpaper_id", "picture_id")
)
;
CREATE TABLE "oboevsky_wallpaper_info_blocks" (
    "id" serial NOT NULL PRIMARY KEY,
    "wallpaper_id" integer NOT NULL,
    "iblock_id" integer NOT NULL,
    UNIQUE ("wallpaper_id", "iblock_id")
)
;
CREATE TABLE "oboevsky_wallpaper_texture" (
    "id" serial NOT NULL PRIMARY KEY,
    "wallpaper_id" integer NOT NULL,
    "texture_id" integer NOT NULL,
    UNIQUE ("wallpaper_id", "texture_id")
)
;
CREATE TABLE "oboevsky_wallpaper_categories" (
    "id" serial NOT NULL PRIMARY KEY,
    "wallpaper_id" integer NOT NULL,
    "category_id" integer NOT NULL,
    UNIQUE ("wallpaper_id", "category_id")
)
;
CREATE TABLE "oboevsky_wallpaper_materials" (
    "id" serial NOT NULL PRIMARY KEY,
    "wallpaper_id" integer NOT NULL,
    "material_id" integer NOT NULL,
    UNIQUE ("wallpaper_id", "material_id")
)
;
CREATE TABLE "oboevsky_wallpaper" (
    "id" serial NOT NULL PRIMARY KEY,
    "sku" varchar(40) NOT NULL UNIQUE,
    "title" varchar(120) NOT NULL,
    "url" varchar(100),
    "short_desc" varchar(200),
    "long_desc" text,
    "price" numeric(12, 2),
    "producer_id" integer,
    "colour" char(7) NOT NULL,
    "template_id" integer,
    "top_sells" boolean NOT NULL,
    "on_clearance" boolean NOT NULL,
    "new" boolean NOT NULL,
    "quantity" integer,
    "priority" integer CHECK ("priority" >= 0) NOT NULL,
    "created" timestamp with time zone NOT NULL,
    "modified" timestamp with time zone NOT NULL,
    "visible" boolean NOT NULL
)
;
ALTER TABLE "oboevsky_wallpaper_images" ADD CONSTRAINT "wallpaper_id_refs_id_6dcf616d" FOREIGN KEY ("wallpaper_id") REFERENCES "oboevsky_wallpaper" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_wallpaper_info_blocks" ADD CONSTRAINT "wallpaper_id_refs_id_509e8967" FOREIGN KEY ("wallpaper_id") REFERENCES "oboevsky_wallpaper" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_wallpaper_texture" ADD CONSTRAINT "wallpaper_id_refs_id_5700f7c9" FOREIGN KEY ("wallpaper_id") REFERENCES "oboevsky_wallpaper" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_wallpaper_categories" ADD CONSTRAINT "wallpaper_id_refs_id_26452f" FOREIGN KEY ("wallpaper_id") REFERENCES "oboevsky_wallpaper" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_wallpaper_materials" ADD CONSTRAINT "wallpaper_id_refs_id_37a7b1e4" FOREIGN KEY ("wallpaper_id") REFERENCES "oboevsky_wallpaper" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE TABLE "oboevsky_producer_info_blocks" (
    "id" serial NOT NULL PRIMARY KEY,
    "producer_id" integer NOT NULL,
    "iblock_id" integer NOT NULL,
    UNIQUE ("producer_id", "iblock_id")
)
;
CREATE TABLE "oboevsky_producer" (
    "id" serial NOT NULL PRIMARY KEY,
    "title" varchar(120) NOT NULL,
    "url" varchar(100),
    "short_desc" varchar(200),
    "long_desc" text,
    "country_id" integer NOT NULL,
    "template_id" integer,
    "logo" varchar(100) NOT NULL,
    "priority" integer CHECK ("priority" >= 0) NOT NULL,
    "created" timestamp with time zone NOT NULL,
    "modified" timestamp with time zone NOT NULL,
    "visible" boolean NOT NULL
)
;
ALTER TABLE "oboevsky_wallpaper" ADD CONSTRAINT "producer_id_refs_id_4a531b12" FOREIGN KEY ("producer_id") REFERENCES "oboevsky_producer" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_producer_info_blocks" ADD CONSTRAINT "producer_id_refs_id_6b2317d" FOREIGN KEY ("producer_id") REFERENCES "oboevsky_producer" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE TABLE "oboevsky_country_info_blocks" (
    "id" serial NOT NULL PRIMARY KEY,
    "country_id" integer NOT NULL,
    "iblock_id" integer NOT NULL,
    UNIQUE ("country_id", "iblock_id")
)
;
CREATE TABLE "oboevsky_country" (
    "id" serial NOT NULL PRIMARY KEY,
    "title" varchar(120) NOT NULL,
    "short_desc" varchar(200),
    "long_desc" text,
    "url" varchar(100),
    "pic" varchar(100) NOT NULL,
    "code" varchar(3) NOT NULL,
    "template_id" integer,
    "priority" integer CHECK ("priority" >= 0) NOT NULL,
    "created" timestamp with time zone NOT NULL,
    "modified" timestamp with time zone NOT NULL,
    "visible" boolean NOT NULL
)
;
ALTER TABLE "oboevsky_producer" ADD CONSTRAINT "country_id_refs_id_5527aeaa" FOREIGN KEY ("country_id") REFERENCES "oboevsky_country" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_country_info_blocks" ADD CONSTRAINT "country_id_refs_id_77064871" FOREIGN KEY ("country_id") REFERENCES "oboevsky_country" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE TABLE "oboevsky_category_info_blocks" (
    "id" serial NOT NULL PRIMARY KEY,
    "category_id" integer NOT NULL,
    "iblock_id" integer NOT NULL,
    UNIQUE ("category_id", "iblock_id")
)
;
CREATE TABLE "oboevsky_category" (
    "id" serial NOT NULL PRIMARY KEY,
    "title" varchar(120) NOT NULL,
    "parent_id" integer,
    "short_desc" varchar(200),
    "long_desc" text,
    "url" varchar(100),
    "template_id" integer,
    "parents_num" integer,
    "priority" integer CHECK ("priority" >= 0) NOT NULL,
    "created" timestamp with time zone NOT NULL,
    "modified" timestamp with time zone NOT NULL,
    "visible" boolean NOT NULL
)
;
ALTER TABLE "oboevsky_wallpaper_categories" ADD CONSTRAINT "category_id_refs_id_64be526a" FOREIGN KEY ("category_id") REFERENCES "oboevsky_category" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_category_info_blocks" ADD CONSTRAINT "category_id_refs_id_776bd87" FOREIGN KEY ("category_id") REFERENCES "oboevsky_category" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_category" ADD CONSTRAINT "parent_id_refs_id_2111dc0b" FOREIGN KEY ("parent_id") REFERENCES "oboevsky_category" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE TABLE "oboevsky_picture" (
    "id" serial NOT NULL PRIMARY KEY,
    "title" varchar(120) NOT NULL,
    "short_desc" varchar(200),
    "long_desc" text,
    "image" varchar(100) NOT NULL,
    "created" timestamp with time zone NOT NULL,
    "modified" timestamp with time zone NOT NULL,
    "visible" boolean NOT NULL
)
;
ALTER TABLE "oboevsky_wallpaper_images" ADD CONSTRAINT "picture_id_refs_id_609b8d1b" FOREIGN KEY ("picture_id") REFERENCES "oboevsky_picture" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE TABLE "oboevsky_texture_info_blocks" (
    "id" serial NOT NULL PRIMARY KEY,
    "texture_id" integer NOT NULL,
    "iblock_id" integer NOT NULL,
    UNIQUE ("texture_id", "iblock_id")
)
;
CREATE TABLE "oboevsky_texture" (
    "id" serial NOT NULL PRIMARY KEY,
    "title" varchar(120) NOT NULL,
    "short_desc" varchar(200),
    "long_desc" text,
    "pic" varchar(100) NOT NULL,
    "template_id" integer,
    "created" timestamp with time zone NOT NULL,
    "modified" timestamp with time zone NOT NULL,
    "visible" boolean NOT NULL
)
;
ALTER TABLE "oboevsky_wallpaper_texture" ADD CONSTRAINT "texture_id_refs_id_47cf622e" FOREIGN KEY ("texture_id") REFERENCES "oboevsky_texture" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_texture_info_blocks" ADD CONSTRAINT "texture_id_refs_id_5021b4a3" FOREIGN KEY ("texture_id") REFERENCES "oboevsky_texture" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE TABLE "oboevsky_material_info_blocks" (
    "id" serial NOT NULL PRIMARY KEY,
    "material_id" integer NOT NULL,
    "iblock_id" integer NOT NULL,
    UNIQUE ("material_id", "iblock_id")
)
;
CREATE TABLE "oboevsky_material" (
    "id" serial NOT NULL PRIMARY KEY,
    "title" varchar(120) NOT NULL,
    "short_desc" varchar(200),
    "long_desc" text,
    "pic" varchar(100) NOT NULL,
    "template_id" integer,
    "created" timestamp with time zone NOT NULL,
    "modified" timestamp with time zone NOT NULL,
    "visible" boolean NOT NULL
)
;
ALTER TABLE "oboevsky_wallpaper_materials" ADD CONSTRAINT "material_id_refs_id_44a6a268" FOREIGN KEY ("material_id") REFERENCES "oboevsky_material" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_material_info_blocks" ADD CONSTRAINT "material_id_refs_id_6b5f5a69" FOREIGN KEY ("material_id") REFERENCES "oboevsky_material" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE TABLE "oboevsky_template_info_blocks" (
    "id" serial NOT NULL PRIMARY KEY,
    "template_id" integer NOT NULL,
    "iblock_id" integer NOT NULL,
    UNIQUE ("template_id", "iblock_id")
)
;
CREATE TABLE "oboevsky_template" (
    "id" serial NOT NULL PRIMARY KEY,
    "title" varchar(120) NOT NULL,
    "comment" text NOT NULL,
    "template" varchar(100) NOT NULL,
    "created" timestamp with time zone NOT NULL,
    "modified" timestamp with time zone NOT NULL,
    "visible" boolean NOT NULL
)
;
ALTER TABLE "oboevsky_wallpaper" ADD CONSTRAINT "template_id_refs_id_1daf417a" FOREIGN KEY ("template_id") REFERENCES "oboevsky_template" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_producer" ADD CONSTRAINT "template_id_refs_id_bfa8803" FOREIGN KEY ("template_id") REFERENCES "oboevsky_template" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_country" ADD CONSTRAINT "template_id_refs_id_734d93e0" FOREIGN KEY ("template_id") REFERENCES "oboevsky_template" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_category" ADD CONSTRAINT "template_id_refs_id_50f05267" FOREIGN KEY ("template_id") REFERENCES "oboevsky_template" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_texture" ADD CONSTRAINT "template_id_refs_id_274a6465" FOREIGN KEY ("template_id") REFERENCES "oboevsky_template" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_material" ADD CONSTRAINT "template_id_refs_id_7012c512" FOREIGN KEY ("template_id") REFERENCES "oboevsky_template" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_template_info_blocks" ADD CONSTRAINT "template_id_refs_id_1d279efb" FOREIGN KEY ("template_id") REFERENCES "oboevsky_template" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE TABLE "oboevsky_iblock" (
    "id" serial NOT NULL PRIMARY KEY,
    "title" varchar(120) NOT NULL,
    "content" text,
    "created" timestamp with time zone NOT NULL,
    "modified" timestamp with time zone NOT NULL,
    "visible" boolean NOT NULL
)
;
ALTER TABLE "oboevsky_wallpaper_info_blocks" ADD CONSTRAINT "iblock_id_refs_id_3013ae02" FOREIGN KEY ("iblock_id") REFERENCES "oboevsky_iblock" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_producer_info_blocks" ADD CONSTRAINT "iblock_id_refs_id_1f9556b" FOREIGN KEY ("iblock_id") REFERENCES "oboevsky_iblock" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_country_info_blocks" ADD CONSTRAINT "iblock_id_refs_id_722ec788" FOREIGN KEY ("iblock_id") REFERENCES "oboevsky_iblock" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_category_info_blocks" ADD CONSTRAINT "iblock_id_refs_id_7aaa22a9" FOREIGN KEY ("iblock_id") REFERENCES "oboevsky_iblock" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_texture_info_blocks" ADD CONSTRAINT "iblock_id_refs_id_747bf97d" FOREIGN KEY ("iblock_id") REFERENCES "oboevsky_iblock" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_material_info_blocks" ADD CONSTRAINT "iblock_id_refs_id_78925e9e" FOREIGN KEY ("iblock_id") REFERENCES "oboevsky_iblock" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_template_info_blocks" ADD CONSTRAINT "iblock_id_refs_id_6a7e48d9" FOREIGN KEY ("iblock_id") REFERENCES "oboevsky_iblock" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE TABLE "oboevsky_promocampain_info_blocks" (
    "id" serial NOT NULL PRIMARY KEY,
    "promocampain_id" integer NOT NULL,
    "iblock_id" integer NOT NULL REFERENCES "oboevsky_iblock" ("id") DEFERRABLE INITIALLY DEFERRED,
    UNIQUE ("promocampain_id", "iblock_id")
)
;
CREATE TABLE "oboevsky_promocampain_categories" (
    "id" serial NOT NULL PRIMARY KEY,
    "promocampain_id" integer NOT NULL,
    "category_id" integer NOT NULL REFERENCES "oboevsky_category" ("id") DEFERRABLE INITIALLY DEFERRED,
    UNIQUE ("promocampain_id", "category_id")
)
;
CREATE TABLE "oboevsky_promocampain_wallpapers" (
    "id" serial NOT NULL PRIMARY KEY,
    "promocampain_id" integer NOT NULL,
    "wallpaper_id" integer NOT NULL REFERENCES "oboevsky_wallpaper" ("id") DEFERRABLE INITIALLY DEFERRED,
    UNIQUE ("promocampain_id", "wallpaper_id")
)
;
CREATE TABLE "oboevsky_promocampain" (
    "id" serial NOT NULL PRIMARY KEY,
    "title" varchar(120) NOT NULL,
    "content" text,
    "wallpaper_price_formula" text,
    "total_price_formula" text,
    "shipping_price_formula" text,
    "conditions" text,
    "created" timestamp with time zone NOT NULL,
    "modified" timestamp with time zone NOT NULL,
    "visible" boolean NOT NULL
)
;
ALTER TABLE "oboevsky_promocampain_info_blocks" ADD CONSTRAINT "promocampain_id_refs_id_20bedeb" FOREIGN KEY ("promocampain_id") REFERENCES "oboevsky_promocampain" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_promocampain_categories" ADD CONSTRAINT "promocampain_id_refs_id_68a07b3f" FOREIGN KEY ("promocampain_id") REFERENCES "oboevsky_promocampain" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "oboevsky_promocampain_wallpapers" ADD CONSTRAINT "promocampain_id_refs_id_fb9a072" FOREIGN KEY ("promocampain_id") REFERENCES "oboevsky_promocampain" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE TABLE "oboevsky_order" (
    "id" serial NOT NULL PRIMARY KEY,
    "state" varchar(20) NOT NULL,
    "created" timestamp with time zone NOT NULL,
    "modified" timestamp with time zone NOT NULL,
    "visible" boolean NOT NULL
)
;
CREATE TABLE "oboevsky_customer" (
    "id" serial NOT NULL PRIMARY KEY,
    "user_id" integer NOT NULL UNIQUE REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED
)
;
CREATE INDEX "oboevsky_wallpaper_url" ON "oboevsky_wallpaper" ("url");
CREATE INDEX "oboevsky_wallpaper_url_like" ON "oboevsky_wallpaper" ("url" varchar_pattern_ops);
CREATE INDEX "oboevsky_wallpaper_producer_id" ON "oboevsky_wallpaper" ("producer_id");
CREATE INDEX "oboevsky_wallpaper_template_id" ON "oboevsky_wallpaper" ("template_id");
CREATE INDEX "oboevsky_producer_url" ON "oboevsky_producer" ("url");
CREATE INDEX "oboevsky_producer_url_like" ON "oboevsky_producer" ("url" varchar_pattern_ops);
CREATE INDEX "oboevsky_producer_country_id" ON "oboevsky_producer" ("country_id");
CREATE INDEX "oboevsky_producer_template_id" ON "oboevsky_producer" ("template_id");
CREATE INDEX "oboevsky_country_url" ON "oboevsky_country" ("url");
CREATE INDEX "oboevsky_country_url_like" ON "oboevsky_country" ("url" varchar_pattern_ops);
CREATE INDEX "oboevsky_country_code" ON "oboevsky_country" ("code");
CREATE INDEX "oboevsky_country_code_like" ON "oboevsky_country" ("code" varchar_pattern_ops);
CREATE INDEX "oboevsky_country_template_id" ON "oboevsky_country" ("template_id");
CREATE INDEX "oboevsky_category_parent_id" ON "oboevsky_category" ("parent_id");
CREATE INDEX "oboevsky_category_url" ON "oboevsky_category" ("url");
CREATE INDEX "oboevsky_category_url_like" ON "oboevsky_category" ("url" varchar_pattern_ops);
CREATE INDEX "oboevsky_category_template_id" ON "oboevsky_category" ("template_id");
CREATE INDEX "oboevsky_texture_template_id" ON "oboevsky_texture" ("template_id");
CREATE INDEX "oboevsky_material_template_id" ON "oboevsky_material" ("template_id");
COMMIT;

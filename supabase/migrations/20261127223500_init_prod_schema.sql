


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE OR REPLACE FUNCTION "public"."delete_user"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  -- Delete the row from auth.users for the currently authenticated user
  DELETE FROM auth.users WHERE id = auth.uid();
END;
$$;


ALTER FUNCTION "public"."delete_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."refresh_all_analytics_views"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY public.mv_monthly_brand_wears;
    REFRESH MATERIALIZED VIEW CONCURRENTLY public.mv_monthly_brand_purchases;
    REFRESH MATERIALIZED VIEW CONCURRENTLY public.mv_monthly_brand_sales;
    REFRESH MATERIALIZED VIEW CONCURRENTLY public.mv_monthly_platform_wears; -- Added
END;
$$;


ALTER FUNCTION "public"."refresh_all_analytics_views"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rls_auto_enable"() RETURNS "event_trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'pg_catalog'
    AS $$
DECLARE
  cmd record;
  tbl name;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        SELECT c.relname INTO tbl FROM pg_catalog.pg_class c WHERE c.oid = cmd.objid;
        EXECUTE format('alter table if exists %I.%I enable row level security', cmd.schema_name, tbl);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION "public"."rls_auto_enable"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."measurements" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "watch_id" "uuid" NOT NULL,
    "base_line" boolean DEFAULT false NOT NULL,
    "atomic_time" timestamp with time zone NOT NULL,
    "watch_time" timestamp with time zone NOT NULL,
    "raw_accuracy" numeric,
    "updated_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "is_deleted" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."measurements" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."watches" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "manufacturer" "text" NOT NULL,
    "model" "text" NOT NULL,
    "serial_number" "text",
    "reference_number" "text",
    "year" integer,
    "category" "text",
    "status" "text",
    "favourite" boolean DEFAULT false NOT NULL,
    "notes" "text",
    "purchase_date" timestamp with time zone,
    "delivery_date" timestamp with time zone,
    "warranty_end_date" timestamp with time zone,
    "last_serviced_date" timestamp with time zone,
    "service_interval" integer DEFAULT 0 NOT NULL,
    "next_service_due" timestamp with time zone,
    "sold_date" timestamp with time zone,
    "purchased_from" "text",
    "sold_to" "text",
    "purchase_price" integer,
    "sold_price" integer,
    "value" integer,
    "movement" "text",
    "case_material" "text",
    "case_diameter" numeric,
    "case_thickness" numeric,
    "lug_width" integer,
    "lug2_lug" numeric,
    "water_resistance" integer,
    "weight" integer,
    "crystal" "text",
    "crown" "text",
    "date_complication" "text",
    "primary_colour" "text",
    "secondary_colour" "text",
    "power_reserve" integer,
    "winder_tpd" integer,
    "winder_tpd_max" integer,
    "winder_direction" "text",
    "front_image_path" "text",
    "back_image_path" "text",
    "lume_image_path" "text",
    "primary_image_index" integer DEFAULT 0,
    "wear_list" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "is_deleted" boolean DEFAULT false NOT NULL,
    "front_image_synced" boolean DEFAULT false NOT NULL,
    "back_image_synced" boolean DEFAULT false NOT NULL,
    "lume_image_synced" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."watches" OWNER TO "postgres";


CREATE MATERIALIZED VIEW "public"."mv_monthly_brand_purchases" AS
 SELECT ("date_trunc"('month'::"text", "purchase_date"))::"date" AS "period_month",
    "manufacturer" AS "brand",
    "count"(*) AS "purchase_count",
    "count"(DISTINCT "user_id") AS "buyer_count"
   FROM "public"."watches" "w"
  WHERE (("is_deleted" IS NOT TRUE) AND ("status" = 'In Collection'::"text") AND ("purchase_date" IS NOT NULL) AND ("manufacturer" IS NOT NULL) AND (TRIM(BOTH FROM "manufacturer") <> ''::"text"))
  GROUP BY ("date_trunc"('month'::"text", "purchase_date")), "manufacturer"
  WITH NO DATA;


ALTER MATERIALIZED VIEW "public"."mv_monthly_brand_purchases" OWNER TO "postgres";


CREATE MATERIALIZED VIEW "public"."mv_monthly_brand_sales" AS
 SELECT ("date_trunc"('month'::"text", "sold_date"))::"date" AS "period_month",
    "manufacturer" AS "brand",
    "count"(*) AS "sale_count",
    "count"(DISTINCT "user_id") AS "seller_count"
   FROM "public"."watches" "w"
  WHERE (("is_deleted" IS NOT TRUE) AND ("status" = 'Sold'::"text") AND ("sold_date" IS NOT NULL) AND ("manufacturer" IS NOT NULL) AND (TRIM(BOTH FROM "manufacturer") <> ''::"text"))
  GROUP BY ("date_trunc"('month'::"text", "sold_date")), "manufacturer"
  WITH NO DATA;


ALTER MATERIALIZED VIEW "public"."mv_monthly_brand_sales" OWNER TO "postgres";


CREATE MATERIALIZED VIEW "public"."mv_monthly_brand_wears" AS
 SELECT ("date_trunc"('month'::"text", ("wear_elem"."val")::timestamp with time zone))::"date" AS "period_month",
    "w"."manufacturer" AS "brand",
    "count"(*) AS "wear_count",
    "count"(DISTINCT "w"."user_id") AS "unique_wearers"
   FROM "public"."watches" "w",
    LATERAL "jsonb_array_elements_text"(
        CASE
            WHEN ("jsonb_typeof"("w"."wear_list") = 'array'::"text") THEN "w"."wear_list"
            ELSE '[]'::"jsonb"
        END) "wear_elem"("val")
  WHERE (("w"."is_deleted" IS NOT TRUE) AND ("w"."status" = 'In Collection'::"text") AND ("w"."manufacturer" IS NOT NULL) AND (TRIM(BOTH FROM "w"."manufacturer") <> ''::"text"))
  GROUP BY ("date_trunc"('month'::"text", ("wear_elem"."val")::timestamp with time zone)), "w"."manufacturer"
  WITH NO DATA;


ALTER MATERIALIZED VIEW "public"."mv_monthly_brand_wears" OWNER TO "postgres";


CREATE MATERIALIZED VIEW "public"."mv_monthly_platform_wears" AS
 SELECT ("date_trunc"('month'::"text", ("wear_elem"."val")::timestamp with time zone))::"date" AS "period_month",
    "count"(*) AS "total_wears",
    "count"(DISTINCT "w"."user_id") AS "active_wearers"
   FROM "public"."watches" "w",
    LATERAL "jsonb_array_elements_text"(
        CASE
            WHEN ("jsonb_typeof"("w"."wear_list") = 'array'::"text") THEN "w"."wear_list"
            ELSE '[]'::"jsonb"
        END) "wear_elem"("val")
  WHERE (("w"."is_deleted" IS NOT TRUE) AND ("w"."status" = 'In Collection'::"text"))
  GROUP BY ("date_trunc"('month'::"text", ("wear_elem"."val")::timestamp with time zone))
  WITH NO DATA;


ALTER MATERIALIZED VIEW "public"."mv_monthly_platform_wears" OWNER TO "postgres";


ALTER TABLE ONLY "public"."measurements"
    ADD CONSTRAINT "measurements_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."watches"
    ADD CONSTRAINT "watches_pkey" PRIMARY KEY ("id");



CREATE UNIQUE INDEX "idx_mv_monthly_brand_purchases" ON "public"."mv_monthly_brand_purchases" USING "btree" ("period_month", "brand");



CREATE UNIQUE INDEX "idx_mv_monthly_brand_sales" ON "public"."mv_monthly_brand_sales" USING "btree" ("period_month", "brand");



CREATE UNIQUE INDEX "idx_mv_monthly_brand_wears" ON "public"."mv_monthly_brand_wears" USING "btree" ("period_month", "brand");



CREATE UNIQUE INDEX "idx_mv_monthly_platform_wears" ON "public"."mv_monthly_platform_wears" USING "btree" ("period_month");



CREATE INDEX "measurements_user_id_idx" ON "public"."measurements" USING "btree" ("user_id");



CREATE INDEX "measurements_watch_id_idx" ON "public"."measurements" USING "btree" ("watch_id");



CREATE INDEX "watches_updated_at_idx" ON "public"."watches" USING "btree" ("updated_at");



CREATE INDEX "watches_user_id_idx" ON "public"."watches" USING "btree" ("user_id");



ALTER TABLE ONLY "public"."measurements"
    ADD CONSTRAINT "measurements_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."measurements"
    ADD CONSTRAINT "measurements_watch_id_fkey" FOREIGN KEY ("watch_id") REFERENCES "public"."watches"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."watches"
    ADD CONSTRAINT "watches_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



CREATE POLICY "Users can manage their own measurements" ON "public"."measurements" TO "authenticated" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage their own watches" ON "public"."watches" TO "authenticated" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



ALTER TABLE "public"."measurements" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."watches" ENABLE ROW LEVEL SECURITY;


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."delete_user"() TO "authenticated";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."measurements" TO "anon";
GRANT ALL ON TABLE "public"."measurements" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."measurements" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."watches" TO "anon";
GRANT ALL ON TABLE "public"."watches" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."watches" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."mv_monthly_brand_purchases" TO "anon";
GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."mv_monthly_brand_purchases" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."mv_monthly_brand_purchases" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."mv_monthly_brand_sales" TO "anon";
GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."mv_monthly_brand_sales" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."mv_monthly_brand_sales" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."mv_monthly_brand_wears" TO "anon";
GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."mv_monthly_brand_wears" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."mv_monthly_brand_wears" TO "service_role";



GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."mv_monthly_platform_wears" TO "anon";
GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."mv_monthly_platform_wears" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."mv_monthly_platform_wears" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO "service_role";








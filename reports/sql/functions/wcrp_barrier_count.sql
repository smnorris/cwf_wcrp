DROP FUNCTION postgisftw.wcrp_barrier_count(text,text);

CREATE FUNCTION postgisftw.wcrp_barrier_count(watershed_group_code TEXT, barrier_type TEXT default 'ALL', stream_type TEXT default 'ON')
--watershed_group: one of BULK, ELKR, HORS, LNIC, QUES, BOWR, CARR
--barrier_type: eg. DAM, RAIL, etc. or if you wish to choose all within watershed ... ALL
-- stream_type: choose habitat options HBITAT, ACCESSIBLE or TOTAL
    RETURNS TABLE(
        watershed_group_cd TEXT,
        structure_type TEXT,
        n_passable bigint,
        n_barrier bigint,
        n_potential bigint,
        n_unknown bigint,
        total bigint
    )
    LANGUAGE 'plpgsql'
    IMMUTABLE PARALLEL SAFE 

AS $$

DECLARE
   v_wsg   text := watershed_group_code;
   v_feat  text := barrier_type;
   v_str   text := stream_type;

BEGIN

IF (v_feat = 'ALL' AND v_str = 'HABITAT') 

    then RETURN query

    with barriers as (
        SELECT
            c.watershed_group_code,
            c.crossing_feature_type,
            c.barrier_status,
            count(*) as n_total
        FROM bcfishpass.crossings c
        WHERE c.watershed_group_code IN ('BULK','LNIC','HORS','ELKR','BOWR','QUES','CARR')
        -- do not include flathead in ELKR
        AND c.wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
        AND (c.aggregated_crossings_id IS NOT NULL OR c.dam_id IS NOT NULL)
        AND (c.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
            OR
            c.barriers_st_dnstr = array[]::text[]
            OR
            c.barriers_wct_dnstr = array[]::text[]
            )
        AND c.all_spawningrearing_km > 0
        GROUP BY c.watershed_group_code, c.crossing_feature_type, c.barrier_status
        ORDER BY c.watershed_group_code, c.crossing_feature_type
        ),

        divided as (
                    SELECT 
                        b.watershed_group_code,
                        b.crossing_feature_type,
                        max(case when b.barrier_status = 'PASSABLE' then n_total else 0 end) as passable,
                        max(case when b.barrier_status = 'BARRIER' then n_total else 0 end) as barrier,
                        max(case when b.barrier_status = 'POTENTIAL' then n_total else 0 end) as potential,
                        max(case when b.barrier_status = 'UNKNOWN' then n_total else 0 end) as unknown
                    FROM barriers b
                    WHERE b.watershed_group_code = v_wsg
                    --AND crossing_feature_type = v_feat
                    GROUP BY b.watershed_group_code, b.crossing_feature_type
                )


        SELECT 
            d.watershed_group_code,
            d.crossing_feature_type,
            d.passable,
            d.barrier,
            d.potential,
            d.unknown,
            (d.passable + d.barrier + d.potential + d.unknown) as total
        FROM divided d;

ELSE IF (v_feat = 'ALL' AND v_str = 'ACCESSIBLE') 

    then RETURN query

    with barriers as (
        SELECT
            c.watershed_group_code,
            c.crossing_feature_type,
            c.barrier_status,
            count(*) as n_total
        FROM bcfishpass.crossings c
        WHERE c.watershed_group_code IN ('BULK','LNIC','HORS','ELKR','BOWR','QUES','CARR')
        -- do not include flathead in ELKR
        AND c.wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
        AND (c.aggregated_crossings_id IS NOT NULL OR c.dam_id IS NOT NULL)
        AND (c.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
            OR
            c.barriers_st_dnstr = array[]::text[]
            OR
            c.barriers_wct_dnstr = array[]::text[]
            )
        GROUP BY c.watershed_group_code, c.crossing_feature_type, c.barrier_status
        ORDER BY c.watershed_group_code, c.crossing_feature_type
        ),

        divided as (
                    SELECT 
                        b.watershed_group_code,
                        b.crossing_feature_type,
                        max(case when b.barrier_status = 'PASSABLE' then n_total else 0 end) as passable,
                        max(case when b.barrier_status = 'BARRIER' then n_total else 0 end) as barrier,
                        max(case when b.barrier_status = 'POTENTIAL' then n_total else 0 end) as potential,
                        max(case when b.barrier_status = 'UNKNOWN' then n_total else 0 end) as unknown
                    FROM barriers b
                    WHERE b.watershed_group_code = v_wsg
                    --AND crossing_feature_type = v_feat
                    GROUP BY b.watershed_group_code, b.crossing_feature_type
                )


        SELECT 
            d.watershed_group_code,
            d.crossing_feature_type,
            d.passable,
            d.barrier,
            d.potential,
            d.unknown,
            (d.passable + d.barrier + d.potential + d.unknown) as total
        FROM divided d;

ELSE IF (v_feat = 'ALL' AND v_str = 'TOTAL') 

    then RETURN query

    with barriers as (
        SELECT
            c.watershed_group_code,
            c.crossing_feature_type,
            c.barrier_status,
            count(*) as n_total
        FROM bcfishpass.crossings c
        WHERE c.watershed_group_code IN ('BULK','LNIC','HORS','ELKR','BOWR','QUES','CARR')
        -- do not include flathead in ELKR
        AND c.wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
        AND (c.aggregated_crossings_id IS NOT NULL OR c.dam_id IS NOT NULL)
        GROUP BY c.watershed_group_code, c.crossing_feature_type, c.barrier_status
        ORDER BY c.watershed_group_code, c.crossing_feature_type
        ),

        divided as (
                    SELECT 
                        b.watershed_group_code,
                        b.crossing_feature_type,
                        max(case when b.barrier_status = 'PASSABLE' then n_total else 0 end) as passable,
                        max(case when b.barrier_status = 'BARRIER' then n_total else 0 end) as barrier,
                        max(case when b.barrier_status = 'POTENTIAL' then n_total else 0 end) as potential,
                        max(case when b.barrier_status = 'UNKNOWN' then n_total else 0 end) as unknown
                    FROM barriers b
                    WHERE b.watershed_group_code = v_wsg
                    --AND crossing_feature_type = v_feat
                    GROUP BY b.watershed_group_code, b.crossing_feature_type
                )


        SELECT 
            d.watershed_group_code,
            d.crossing_feature_type,
            d.passable,
            d.barrier,
            d.potential,
            d.unknown,
            (d.passable + d.barrier + d.potential + d.unknown) as total
        FROM divided d;


ELSE
    RETURN query

    with barriers as (
        SELECT
            c.watershed_group_code,
            c.crossing_feature_type,
            c.barrier_status,
            count(*) as n_total
        FROM bcfishpass.crossings c
        WHERE c.watershed_group_code IN ('BULK','LNIC','HORS','ELKR','BOWR','QUES','CARR')
        -- do not include flathead in ELKR
        AND c.wscode_ltree <@ '300.602565.854327.993941.902282.132363'::ltree IS FALSE
        AND (c.aggregated_crossings_id IS NOT NULL OR c.dam_id IS NOT NULL)
        AND (c.barriers_ch_cm_co_pk_sk_dnstr = array[]::text[]
            OR
            c.barriers_st_dnstr = array[]::text[]
            OR
            c.barriers_wct_dnstr = array[]::text[]
            )
        AND c.all_spawningrearing_km > 0
        GROUP BY c.watershed_group_code, c.crossing_feature_type, c.barrier_status
        ORDER BY c.watershed_group_code, c.crossing_feature_type
        ),

        divided as (
                    SELECT 
                        b.watershed_group_code,
                        b.crossing_feature_type,
                        max(case when b.barrier_status = 'PASSABLE' then b.n_total else 0 end) as passable,
                        max(case when b.barrier_status = 'BARRIER' then b.n_total else 0 end) as barrier,
                        max(case when b.barrier_status = 'POTENTIAL' then b.n_total else 0 end) as potential,
                        max(case when b.barrier_status = 'UNKNOWN' then b.n_total else 0 end) as unknown
                    FROM barriers b
                    WHERE b.watershed_group_code = v_wsg
                    AND b.crossing_feature_type = v_feat
                    GROUP BY b.watershed_group_code, b.crossing_feature_type
                )


        SELECT 
            d.watershed_group_code,
            d.crossing_feature_type,
            d.passable,
            d.barrier,
            d.potential,
            d.unknown,
            (d.passable + d.barrier + d.potential + d.unknown) as total
        FROM divided d;

END IF;

END


$$;

COMMENT ON FUNCTION postgisftw.wcrp_barrier_count IS
'Provided is a watershed name and a crossing feature type according to the structure of bcbarriers.
The output is a percentage of the sum of the crossing feature within the watershed relative to the
sum of all crossing feature types in the watershed.';

REVOKE EXECUTE ON FUNCTION postgisftw.wcrp_barrier_count FROM public;
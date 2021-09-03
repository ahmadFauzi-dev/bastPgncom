--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.6
-- Dumped by pg_dump version 9.6.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: transform; Type: SCHEMA; Schema: -; Owner: syfawija
--

CREATE SCHEMA transform;


ALTER SCHEMA transform OWNER TO syfawija;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: colpivot(character varying, character varying, character varying[], character varying[], character varying, character varying); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION colpivot(out_table character varying, in_query character varying, key_cols character varying[], class_cols character varying[], value_e character varying, col_order character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    declare
        in_table varchar;
        col varchar;
        ali varchar;
        on_e varchar;
        i integer;
        rec record;
        query varchar;
        -- This is actually an array of arrays but postgres does not support an array of arrays type so we flatten it.
        -- We could theoretically use the matrix feature but it's extremly cancerogenous and we would have to involve
        -- custom aggrigates. For most intents and purposes postgres does not have a multi-dimensional array type.
        clsc_cols text[] := array[]::text[];
        n_clsc_cols integer;
        n_class_cols integer;
    begin
        in_table := quote_ident('__' || out_table || '_in');
        execute ('create temp table ' || in_table || ' on commit drop as ' || in_query);
        -- get ordered unique columns (column combinations)
        query := 'select array[';
        i := 0;
        foreach col in array class_cols loop
            if i > 0 then
                query := query || ', ';
            end if;
            query := query || 'quote_literal(' || quote_ident(col) || ')';
            i := i + 1;
        end loop;
        query := query || '] x from ' || in_table;
        for j in 1..2 loop
            if j = 1 then
                query := query || ' group by ';
            else
                query := query || ' order by ';
                if col_order is not null then
                    query := query || col_order || ' ';
                    exit;
                end if;
            end if;
            i := 0;
            foreach col in array class_cols loop
                if i > 0 then
                    query := query || ', ';
                end if;
                query := query || quote_ident(col);
                i := i + 1;
            end loop;
        end loop;
        -- raise notice '%', query;
        for rec in
            execute query
        loop
            clsc_cols := array_cat(clsc_cols, rec.x);
        end loop;
        n_class_cols := array_length(class_cols, 1);
        n_clsc_cols := array_length(clsc_cols, 1) / n_class_cols;
        -- build target query
        query := 'select ';
        i := 0;
        foreach col in array key_cols loop
            if i > 0 then
                query := query || ', ';
            end if;
            query := query || '_key.' || quote_ident(col) || ' ';
            i := i + 1;
        end loop;
        for j in 1..n_clsc_cols loop
            query := query || ', ';
            col := '';
            for k in 1..n_class_cols loop
                if k > 1 then
                    col := col || ', ';
                end if;
                col := col || clsc_cols[(j - 1) * n_class_cols + k];
            end loop;
            ali := '_clsc_' || j::text;
            query := query || '(' || replace(value_e, '#', ali) || ')' || ' as ' || quote_ident(col) || ' ';
        end loop;
        query := query || ' from (select distinct ';
        i := 0;
        foreach col in array key_cols loop
            if i > 0 then
                query := query || ', ';
            end if;
            query := query || quote_ident(col) || ' ';
            i := i + 1;
        end loop;
        query := query || ' from ' || in_table || ') _key ';
        for j in 1..n_clsc_cols loop
            ali := '_clsc_' || j::text;
            on_e := '';
            i := 0;
            foreach col in array key_cols loop
                if i > 0 then
                    on_e := on_e || ' and ';
                end if;
                on_e := on_e || ali || '.' || quote_ident(col) || ' = _key.' || quote_ident(col) || ' ';
                i := i + 1;
            end loop;
            for k in 1..n_class_cols loop
                on_e := on_e || ' and ';
                on_e := on_e || ali || '.' || quote_ident(class_cols[k]) || ' = ' || clsc_cols[(j - 1) * n_class_cols + k];
            end loop;
            query := query || 'left join ' || in_table || ' as ' || ali || ' on ' || on_e || ' ';
        end loop;
        -- raise notice '%', query;
        execute ('create temp table ' || quote_ident(out_table) || ' on commit drop as ' || query);
        -- cleanup temporary in_table before we return
        execute ('drop table ' || in_table)
        return;
    end;
$$;


ALTER FUNCTION public.colpivot(out_table character varying, in_query character varying, key_cols character varying[], class_cols character varying[], value_e character varying, col_order character varying) OWNER TO syfawija;

--
-- Name: serial; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE serial
    START WITH 6002823
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE serial OWNER TO syfawija_syfa;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ms_employee; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE ms_employee (
    rowid character varying(50) DEFAULT ('EMP'::text || nextval('serial'::regclass)) NOT NULL,
    nipg character varying(40),
    nama_karyawan character varying(50),
    email character varying(50),
    phone character varying(50),
    job_pos character varying(50),
    satker character varying(50),
    create_date numeric DEFAULT (to_char(now(), 'yyyymmddhhmiss'::text))::numeric
);


ALTER TABLE ms_employee OWNER TO syfawija_syfa;

--
-- Name: ms_position; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE ms_position (
    rowid character varying(32) DEFAULT ('ORG'::text || nextval('serial'::regclass)),
    id integer,
    parent integer,
    jabatan character varying,
    create_date numeric DEFAULT (to_char(now(), 'yyyymmddhhmiss'::text))::numeric,
    update_date numeric,
    level smallint
);


ALTER TABLE ms_position OWNER TO syfawija_syfa;

--
-- Name: ms_satker; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE ms_satker (
    rowid character varying(50) DEFAULT ('SATKER'::text || nextval('serial'::regclass)) NOT NULL,
    refforgzid character varying,
    satkerid character varying,
    satker character varying(255),
    createdate numeric DEFAULT (to_char(now(), 'yyyymmddhhmiss'::text))::numeric
);


ALTER TABLE ms_satker OWNER TO syfawija_syfa;

--
-- Name: v_employee; Type: VIEW; Schema: public; Owner: syfawija_syfa
--

CREATE VIEW v_employee AS
 SELECT ms_employee.rowid,
    ms_employee.nipg,
    ms_employee.nama_karyawan,
    ms_employee.email,
    ms_employee.phone,
    ms_employee.job_pos,
    ms_position.jabatan AS nama_jabatan,
    ms_satker.satker AS nama_satker,
    ms_position.id AS reff_jobpos,
    ms_satker.rowid AS reff_satkerid
   FROM ((ms_employee
     LEFT JOIN ms_position ON (((ms_employee.job_pos)::text = (ms_position.rowid)::text)))
     LEFT JOIN ms_satker ON (((ms_employee.satker)::text = (ms_satker.rowid)::text)));


ALTER TABLE v_employee OWNER TO syfawija_syfa;

--
-- Name: dup(character varying); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION dup(p_org character varying) RETURNS SETOF v_employee
    LANGUAGE sql
    AS $$SELECT * from v_employee 
WHERE job_pos in 
(
	SELECT rowid from (
			WITH RECURSIVE subordinates AS (
			 SELECT
				ms_position.rowid,ms_position.id,ms_position.jabatan,ms_position.parent
			 FROM
			 ms_position
			 WHERE
			 id = p_org::INTEGER
			 UNION
			 SELECT
				e.rowid,e.id,e.jabatan,e.parent
				FROM
					ms_position e
					INNER JOIN subordinates s ON s.id = e.parent
			) SELECT
			 *
			FROM
			 subordinates
			) A
	
)
ORDER BY job_pos ASC
$$;


ALTER FUNCTION public.dup(p_org character varying) OWNER TO syfawija;

--
-- Name: fn_broadcastmessage(character varying); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION fn_broadcastmessage(p_programid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$DECLARE 
	v_org RECORD;
	v_message text;
BEGIN
	--Routine body goes here...
	SELECT "content" into v_message from ms_program;
	for v_org
							IN 
								SELECT * from fn_organisasi(p_programid)
							LOOP
								INSERT INTO ms_message (programid,satkerid,nipg,tipe_message,message)
								SELECT p_programid as programid,
											 v_org.value as satkerid,
											 nipg as nipg,
											 '1' as tipe_message,
											 v_message as message
								from ms_employee where satker = v_org.value;
							BEGIN

					END;
					END LOOP;
	RETURN 'NULL';
END
$$;


ALTER FUNCTION public.fn_broadcastmessage(p_programid character varying) OWNER TO syfawija;

--
-- Name: fn_forward(); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION fn_forward() RETURNS character varying
    LANGUAGE plpgsql
    AS $$DECLARE
 v_broadcast RECORD;
 v_jobposworkflow RECORD;
BEGIN
	--Routine body goes here...
	for v_broadcast
							IN 
								SELECT * from v_message_broadacst
							LOOP
							
							BEGIN
								SELECT ms_employee.nipg,
										 ms_employee.nama_karyawan,
										 ms_employee.phone,
										 ms_workflow.reffjobpos	
								INTO v_jobposworkflow
								from ms_workflow 
								JOIN ms_employee on ms_employee.rowid = ms_workflow.reffemp
								WHERE createbyt = v_broadcast.reffjobpos::VARCHAR
								and priority = 2;

								INSERT INTO ms_message (programid,satkerid,nipg,tipe_message,message,reff_nipg)
								VALUES(
												v_broadcast.programid ,
											  v_broadcast.reffsatkerid,
											  v_jobposworkflow.nipg,
											  '3',
											  v_broadcast.message,
												v_broadcast.nipg
								);
								--from v_message_broadacst WHERE tipe_message = '1';
					END;
					END LOOP;
	RETURN 'NULL';
END
$$;


ALTER FUNCTION public.fn_forward() OWNER TO syfawija;

--
-- Name: fn_genworkflow(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION fn_genworkflow(p_activity character varying, p_jobpos integer, p_level integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$DECLARE
	v_revord RECORD;
	v_record2 RECORD;
	v_prioroty INTEGER;
  v_org INTEGER;
	v_event VARCHAR;
	p_idgroup VARCHAR;
	p_level INTEGER;
	v_emp RECORD;
BEGIN
	--Routine body goes here...
	v_prioroty = 0;
	
	
		--IF(p_activity != 'ACT8') THEN
			p_level = 5;
		
					for v_revord
							IN 
								SELECT * from fn_getjobposlevel(p_jobpos, p_level)
							LOOP
							
							BEGIN
							v_prioroty = v_prioroty + 1;
							
							--RAISE NOTICE 'rowid : %', to_number(v_revord.rowid, 99);
							IF v_prioroty = 1 THEN
								v_event = 'CREATE';
								ELSE
								v_event = 'FORWARD';
								
							END IF;
							SELECT * INTO v_emp 
							from v_employee WHERE reff_jobpos = v_revord.rowid;
							
							INSERT INTO ms_workflow
								(
									reffactivity
									,refforg
									,reffjobpos
									,reffemp
									,priority
									,createdate
									,createperson
									,reffeven
									,createbyt
								)
								VALUES
								(
									p_activity
									,v_revord.id_organization
									,v_revord.rowid
									,v_emp.rowid
									,v_prioroty
									,now()
									,'system'
									,v_event
									,p_jobpos
								);
					
							
					END;
					END LOOP;
	
		--END IF;
		
			
		
	RETURN 'OK';
END
$$;


ALTER FUNCTION public.fn_genworkflow(p_activity character varying, p_jobpos integer, p_level integer) OWNER TO syfawija;

--
-- Name: fn_getdatamaster(); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION fn_getdatamaster() RETURNS TABLE(id character varying, parent character varying, desk character varying, nama character varying, jenis_data character varying)
    LANGUAGE plpgsql
    AS $$DECLARE
	vsatker TEXT;
BEGIN
	
RETURN QUERY 
 
	select A.rowid::varchar as id, 
		   A.parent_id::varchar as parent,
		   A.description::varchar as desk,
		   A.name::varchar as nama,
		   B.name::varchar as jenis_data	
	from master_data A
	JOIN
	data_type B on A.type_id = B.rowid
	--where A.type_id = ptypeid
	;
	
END
$$;


ALTER FUNCTION public.fn_getdatamaster() OWNER TO syfawija;

--
-- Name: fn_getdatamastertype(character varying); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION fn_getdatamastertype(ptype_id character varying) RETURNS TABLE(id character varying, parent character varying, desk character varying, nama character varying, jenis_data character varying)
    LANGUAGE plpgsql
    AS $$DECLARE
	vsatker TEXT;
BEGIN
	
RETURN QUERY 
 
	select A.rowid::varchar as id, 
		   A.parent_id::varchar as parent,
		   A.description::varchar as desk,
		   A.name::varchar as nama,
		   B.name::varchar as jenis_data	
	from master_data A
	JOIN
	data_type B on A.type_id = B.rowid
	where A.type_id = ptype_id
	;
	
END
$$;


ALTER FUNCTION public.fn_getdatamastertype(ptype_id character varying) OWNER TO syfawija;

--
-- Name: fn_getdatamastertype_ms(character varying, character varying); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION fn_getdatamastertype_ms(ptype_id character varying, p_id2 character varying) RETURNS TABLE(id character varying, parent character varying, alamat character varying, text character varying, jenis_data character varying)
    LANGUAGE plpgsql
    AS $$DECLARE
	vsatker TEXT;
BEGIN
	
RETURN QUERY 
 
	SELECT fn_getdata.id,
    fn_getdata.parent,
    fn_getdata.desk as alamat,
    fn_getdata.nama as text,
    fn_getdata.jenis_data
   FROM fn_getdatamastertype(ptype_id) fn_getdata
UNION
 SELECT fn_getdat.id,
    fn_getdat.parent,
    fn_getdat.desk as alamat,
    fn_getdat.nama as text,
    fn_getdat.jenis_data
   FROM fn_getdatamastertype(p_id2) fn_getdat;
	
	
END
$$;


ALTER FUNCTION public.fn_getdatamastertype_ms(ptype_id character varying, p_id2 character varying) OWNER TO syfawija;

--
-- Name: fn_getjobposlevel(integer, integer); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION fn_getjobposlevel(p_jobpos integer, p_level integer) RETURNS TABLE(rowid integer, parent integer, name character varying, id_organization integer, urutan integer)
    LANGUAGE plpgsql
    AS $$DECLARE 
	vjabatan RECORD;
	i INTEGER;
	v_jobpos INTEGER;
	vlevel INTEGER;
BEGIN
	FOR i IN 1..p_level
	LOOP
		BEGIN 
			IF i = 1 THEN
				v_jobpos = p_jobpos;
			END IF;
				SELECT *
				INTO vjabatan
				from v_jabatan
				WHERE v_jabatan.id  = v_jobpos;
			--IF (i == '1' OR vjabatan.delegasi == 'M') THEN
					rowid 							:= vjabatan.id; 
					parent 							:= vjabatan.parent;
					name							  := vjabatan.text;
					--id_organization			:= vjabatan.kode;
					v_jobpos 						= vjabatan.parent;
					urutan							:= i;
				IF rowid is NOT NULL THEN
					SELECT LEVEL INTO vlevel from v_jabatan 
					WHERE id = v_jobpos;
						RAISE NOTICE 'Parent : %', v_jobpos;
						RAISE NOTICE 'Level : %', vlevel;
						RAISE NOTICE 'I : %', vlevel;
						RAISE NOTICE 'Vjabatan : %', vjabatan.level;
					IF i = 1 THEN	
							RETURN NEXT;
					END IF;
					IF i > 1 AND vlevel > vjabatan.level AND vjabatan.level != 0 THEN
							RETURN NEXT;
					END IF;
					--IF 101
			--END IF;
			END IF;
		END;
  END LOOP;
END
$$;


ALTER FUNCTION public.fn_getjobposlevel(p_jobpos integer, p_level integer) OWNER TO syfawija;

--
-- Name: fn_getsaldo(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION fn_getsaldo(iddoc character varying, prowid character varying, idangkatan character varying, pjenis_dataid character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$DECLARE	
	v_rowid INTEGER;
	v_transpencatatan RECORD;
	v_saldo numeric;
BEGIN
	v_rowid = substr(prowid,4)::integer; 
	v_saldo = 0;
	 
		for v_transpencatatan
				IN 
					SELECT A.*,B.jenis_dataid
							FROM trans_pecatatanayam as A
							left join 
							(
								select A.rowid, 
										 A.parent_id,
										 A.type_id as jenis_dataid,
										 B.name::varchar as jenis_data	
								from master_data A
								JOIN
								data_type B on A.type_id = B.rowid
							)as B on A.item_id = b.rowid 
					where substr(A.rowid,4)::integer <= v_rowid 
					and A.id_kandang = iddoc and A.id_angkatan = idangkatan
					and B.jenis_dataid = pjenis_dataid
				LOOP
				
				BEGIN
					IF v_transpencatatan.status_transaksi::varchar = 'MD33' THEN
								v_saldo = v_saldo + v_transpencatatan.jumlah;
								ELSE
								v_saldo =  v_saldo - v_transpencatatan.jumlah;
								
							END IF;
					
		END;
		END LOOP;
	
	RETURN v_saldo;
END$$;


ALTER FUNCTION public.fn_getsaldo(iddoc character varying, prowid character varying, idangkatan character varying, pjenis_dataid character varying) OWNER TO syfawija;

--
-- Name: fn_organisasi(character varying); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION fn_organisasi(p_programid character varying) RETURNS TABLE(value text)
    LANGUAGE plpgsql
    AS $$DECLARE
	vsatker TEXT;
BEGIN
	--Routine body goes here...
	SELECT satker INTO vsatker 
	from ms_program WHERE rowid = p_programid;


RETURN QUERY 
 
	select *
	from json_array_elements_text(vsatker::JSON);
	
END
$$;


ALTER FUNCTION public.fn_organisasi(p_programid character varying) OWNER TO syfawija;

--
-- Name: fn_typeofdata(); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION fn_typeofdata() RETURNS TABLE(id character varying, nama character varying, desk character varying)
    LANGUAGE plpgsql
    AS $$DECLARE
	vsatker TEXT;
BEGIN
	
RETURN QUERY 
 
	select rowid,name,kode::varchar
	from data_type;
	
END
$$;


ALTER FUNCTION public.fn_typeofdata() OWNER TO syfawija;

--
-- Name: get_msprogram(); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION get_msprogram() RETURNS TABLE(rowid character varying, title character varying, content character varying, create_by character varying, create_date character varying, satuan_kerja text)
    LANGUAGE plpgsql
    AS $$DECLARE
	v_org RECORD;
	v_id VARCHAR;
BEGIN
	--Routine body goes here...
	for v_org
				IN 
					SELECT A.rowid
								 ,A.title
								 ,A.content
								 ,A.create_by
								 ,A.create_date
					from ms_program A
				LOOP
					
				BEGIN
				v_id = v_org.rowid;
				rowid = v_org.rowid;
				title = v_org.title;
				content = v_org.content;
				create_by = v_org.create_by;
				create_date = v_org.create_date;
				satuan_kerja = get_satuankerjaprogram(v_org.rowid);
					RETURN NEXT;
		END;
		END LOOP;
	
END
$$;


ALTER FUNCTION public.get_msprogram() OWNER TO syfawija;

--
-- Name: get_satuankerjaprogram(character varying); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION get_satuankerjaprogram(p_programid character varying) RETURNS TABLE(satuan_kerja text)
    LANGUAGE plpgsql
    AS $$BEGIN
	--Routine body goes here...

	RETURN QUERY 
 
		SELECT  string_agg(B.satkerid, ', ') AS satuan_kerja
		FROM  (
			SELECT satkerid from fn_organisasi(p_programid) A
			join ms_satker on ms_satker.rowid = A.VALUE
		) B;
		--group BY programid;
END
$$;


ALTER FUNCTION public.get_satuankerjaprogram(p_programid character varying) OWNER TO syfawija;

--
-- Name: konversi_inbox(); Type: FUNCTION; Schema: public; Owner: syfawija
--

CREATE FUNCTION konversi_inbox() RETURNS character varying
    LANGUAGE plpgsql
    AS $$DECLARE	
	program_id VARCHAR;
	v_record RECORD;
	v_recbroadcast RECORD;
	hitung int;
BEGIN
	--Routine body goes here...
	for v_record
							IN 
								SELECT *
											,split_part(message,'#',1) as kode
											,split_part(message,'#',2) as nipg
								from temp_inbox
								WHERE split_part(message,'#',2) != ''
							LOOP
							
					BEGIN
								SELECT *  from v_message_broadacst INTO v_recbroadcast 
								WHERE nipg =v_record.nipg and tipe_message = '1';
								SELECT count(*)  from ms_message INTO hitung 
								WHERE nipg =v_record.nipg and tipe_message = '2' and programid = v_recbroadcast.programid;
								IF(hitung > 0) THEN
									UPDATE ms_message set message = v_record.message 
									where nipg =v_record.nipg and tipe_message = '2';
								ELSE
									INSERT INTO ms_message (programid,satkerid,nipg,tipe_message,message)
								VALUES(v_recbroadcast.programid,v_recbroadcast.reffsatkerid,v_recbroadcast.nipg,'2',v_record.message);
								END IF;
								
					END;
					END LOOP;

	RETURN 'NULL';
END
$$;


ALTER FUNCTION public.konversi_inbox() OWNER TO syfawija;

SET search_path = transform, pg_catalog;

--
-- Name: fn_approve_rtpk(date, date, character varying, character varying, character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: transform; Owner: syfawija
--

CREATE FUNCTION fn_approve_rtpk(pstart date, pend date, parea character varying, pstatus character varying, psbu character varying, p_idreff character varying, p_nmpel character varying, create_by character varying, ptypeofdata integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$DECLARE	
	v_record RECORD;
	hitung int;
	error int;
	err_constraint text;
	v_idreffpelanggan VARCHAR;
	v_ghv RECORD;
	v_tanggal DATE;
	v_energy NUMERIC;
	name_source VARCHAR;
	tgl_awal NUMERIC;
	tgl_akhir NUMERIC;
	tgl_start NUMERIC;
	tgl_end NUMERIC;
	message VARCHAR;
BEGIN
	tgl_awal = (to_char(pstart, 'yyyymmdd')||'000000')::NUMERIC;
	tgl_akhir = (to_char(pstart, 'yyyymmdd')||'000000')::NUMERIC;
	tgl_end 	= (to_char(last_day(pstart), 'yyyymmdd')|| '000000')::NUMERIC;
	tgl_start = (to_char(pstart, 'yyyymm')||'01000000')::NUMERIC;
	RAISE NOTICE 'Error %',  tgl_awal;
	RAISE NOTICE 'Error %',  tgl_end;
	RAISE NOTICE 'Error %',  tgl_start;
	for v_record IN
		
		SELECT * from "public".valdy_avr a
		JOIN "public".v_pelanggan_rtpk b on a.idrefpelanggan = b.idrefpelanggan
		WHERE 
			a.isapproval is NULL
			and 
			b.namearea = parea 
			and b.sbu like '%'|| psbu||'%'
		  and 
			b.idrefpelanggan like '%'||p_idreff||'%'
			--and b.pelname like '%'||p_nmpel||'%'
			and a.tanggalcatat BETWEEN tgl_awal and tgl_akhir
			and b.periode_catat BETWEEN tgl_start and tgl_end
			and a.final_status = pstatus::INTEGER
	LOOP
	BEGIN
	RAISE NOTICE 'Record : %', v_record;
	RAISE NOTICE 'Tgl_awal : %', tgl_awal;
	RAISE NOTICE 'Tgl Akhir : %', (to_char(last_day(pstart), 'yyyymmdd')|| '000000')::NUMERIC;

	v_tanggal = to_char(v_record.tanggalcatat, '9999-99-99 99:99:99')::DATE ;
-- 		SELECT * into v_ghv 
-- 			from  "public".getghv_mapping(v_tanggal, v_tanggal,v_record.idrefpelanggan, '', 0);
-- 			v_energy = ((v_record.corrected_volume_mtr * ((288.71 / 300.15) * 35.3147)) * v_ghv.ghv) / 1000000;
-- 		
		INSERT INTO 
			"public".penyaluran_final_avr
				(reffcrmrowid
				,valdy_avrrowid
				,sbu
				,area
				,areacd
				,idrefpelanggan
				,streamid
				,status_alert
				,methode_pencatatan
				,periodecatat
				,tanggalcatat
				,asset_aktif
				,serialmeter
				,volume
				,sentdate
				,ghv
				,energy
				,sourcetype
				,stationrowid
				,namesource
				,status
				,typeapproved
				,isapproval
				,creperson
				,typeofdata
				,namapel
				,jenis_pelanggan
				,jenis_rekening
				,no_buku
			)
			VALUES
			(
				v_record.acc_id
				,v_record.rowid
				,v_record.sbu
				,v_record.area
				,v_record.kode_area
				,v_record.idrefpelanggan
				,v_record.streamid
				,v_record.final_status
				,v_record.methode_catat
				,v_record.periodecatat
				,v_record.tanggalcatat
				,v_record.assetactive
				,v_record.snmeter
				,v_record.corrected_volume_mtr
				,to_char(now(), 'yyyymmddhhmmss')::NUMERIC
				,null -- v_ghv.ghv
				,null -- v_energy
				,null -- splitdata(v_ghv.station,'|', 3)
				,null -- splitdata(v_ghv.station,'|', 1)
				,null -- splitdata(v_ghv.station,'|', 2)
				,'1'::VARCHAR
				,v_record.final_status
				,1
				,create_by
				,ptypeofdata
				,v_record.pelname
				,v_record.jenis_pelanggan
				,v_record.jenis_rekening
				,v_record.nobuku
			);
				
			UPDATE "public".valdy_avr set 
					isapproval = 1
					,updperson = '1admin'
					,upddate = to_number(to_char(now(), 'yyyymmddHH24MISS'), '99999999999999')
				WHERE rowid = v_record.rowid;
			EXCEPTION
				WHEN OTHERS THEN
				error = 1;
				 GET STACKED DIAGNOSTICS err_constraint = MESSAGE_TEXT;
				 
				 INSERT INTO logger
						(tanggal
						 ,transaksi
						 ,description
						 ,user_by
						 ,idrefpelanggan
						 ,tglpengukuran
						 ,streamid)
					VALUES
						(to_number(to_char(now(), 'yyyymmddHH24MISS'), '99999999999999')
						,'validasi/approvel all/INSERT/penyaluran_nonamr_daily'
						,err_constraint
						,'1admin'
						,v_record.idrefpelanggan
					  ,v_record.tanggalcatat
					  ,v_record.streamid);
					message = err_constraint;
					RAISE NOTICE 'Error data %',  err_constraint;
		RAISE NOTICE 'GHV : %', v_ghv;
	END;
	END LOOP;
	message = 'OK';
	RETURN message;
	--COMMIT;
END

$$;


ALTER FUNCTION transform.fn_approve_rtpk(pstart date, pend date, parea character varying, pstatus character varying, psbu character varying, p_idreff character varying, p_nmpel character varying, create_by character varying, ptypeofdata integer) OWNER TO syfawija;

--
-- Name: fn_approvenonamr(date, date, character varying, character varying, character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: transform; Owner: syfawija
--

CREATE FUNCTION fn_approvenonamr(pstart date, pend date, parea character varying, pstatus character varying, psbu character varying, p_idreff character varying, p_nmpel character varying, create_by character varying, ptypeofdata integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$DECLARE	
	v_record RECORD;
	hitung int;
	error int;
	err_constraint text;
	v_idreffpelanggan VARCHAR;
	v_ghv RECORD;
	v_tanggal DATE;
	v_energy NUMERIC;
	name_source VARCHAR;
	tgl_awal NUMERIC;
	tgl_akhir NUMERIC;
	tgl_start NUMERIC;
	tgl_end NUMERIC;
	message VARCHAR;
BEGIN
	tgl_awal = (to_char(pstart, 'yyyymmdd')||'000000')::NUMERIC;
	tgl_akhir = (to_char(pstart, 'yyyymmdd')||'000000')::NUMERIC;
	tgl_end 	= (to_char(last_day(pstart), 'yyyymmdd')|| '000000')::NUMERIC;
	tgl_start = (to_char(pstart, 'yyyymm')||'01000000')::NUMERIC;
	RAISE NOTICE 'Error %',  tgl_awal;
	RAISE NOTICE 'Error %',  tgl_end;
	RAISE NOTICE 'Error %',  tgl_start;
	for v_record IN
		
		SELECT * from "public".valdy_avr a
		JOIN "public".v_pelanggan_non_amr b on a.idrefpelanggan = b.idrefpelanggan
		WHERE 
			a.isapproval is NULL
			and 
			b.namearea = parea 
			and b.sbu like '%'|| psbu||'%'
		  and 
			b.idrefpelanggan like '%'||p_idreff||'%'
			--and b.pelname like '%'||p_nmpel||'%'
			and a.tanggalcatat BETWEEN tgl_awal and tgl_akhir
			and b.periode_catat BETWEEN tgl_start and tgl_end
			and a.final_status = pstatus::INTEGER
	LOOP
	BEGIN
	RAISE NOTICE 'Record : %', v_record;
	RAISE NOTICE 'Tgl_awal : %', tgl_awal;
	RAISE NOTICE 'Tgl Akhir : %', (to_char(last_day(pstart), 'yyyymmdd')|| '000000')::NUMERIC;

	v_tanggal = to_char(v_record.tanggalcatat, '9999-99-99 99:99:99')::DATE ;
		SELECT * into v_ghv 
			from  "public".getghv_mapping(v_tanggal, v_tanggal,v_record.idrefpelanggan, '', 0);
			v_energy = ((v_record.corrected_volume_mtr * ((288.71 / 300.15) * 35.3147)) * v_ghv.ghv) / 1000000;
		
		INSERT INTO 
			"public".penyaluran_final_avr
				(reffcrmrowid
				,valdy_avrrowid
				,sbu
				,area
				,areacd
				,idrefpelanggan
				,streamid
				,status_alert
				,methode_pencatatan
				,periodecatat
				,tanggalcatat
				,asset_aktif
				,serialmeter
				,volume
				,sentdate
				,ghv
				,energy
				,sourcetype
				,stationrowid
				,namesource
				,status
				,typeapproved
				,isapproval
				,creperson
				,typeofdata
				,namapel
				,jenis_pelanggan
				,jenis_rekening
				,no_buku
			)
			VALUES
			(
				v_record.acc_id
				,v_record.rowid
				,v_record.sbu
				,v_record.area
				,v_record.kode_area
				,v_record.idrefpelanggan
				,v_record.streamid
				,v_record.final_status
				,v_record.methode_catat
				,v_record.periodecatat
				,v_record.tanggalcatat
				,v_record.assetactive
				,v_record.snmeter
				,v_record.corrected_volume_mtr
				,to_char(now(), 'yyyymmddhhmmss')::NUMERIC
				,v_ghv.ghv
				,v_energy
				,splitdata(v_ghv.station,'|', 3)
				,splitdata(v_ghv.station,'|', 1)
				,splitdata(v_ghv.station,'|', 2)
				,'1'::VARCHAR
				,v_record.final_status
				,1
				,create_by
				,ptypeofdata
				,v_record.pelname
				,v_record.jenis_pelanggan
				,v_record.jenis_rekening
				,v_record.nobuku
			);
				
			UPDATE "public".valdy_avr set 
					isapproval = 1
					,updperson = '1admin'
					,upddate = to_number(to_char(now(), 'yyyymmddHH24MISS'), '99999999999999')
				WHERE rowid = v_record.rowid;
			EXCEPTION
				WHEN OTHERS THEN
				error = 1;
				 GET STACKED DIAGNOSTICS err_constraint = MESSAGE_TEXT;
				 
				 INSERT INTO logger
						(tanggal
						 ,transaksi
						 ,description
						 ,user_by
						 ,idrefpelanggan
						 ,tglpengukuran
						 ,streamid)
					VALUES
						(to_number(to_char(now(), 'yyyymmddHH24MISS'), '99999999999999')
						,'validasi/approvel all/INSERT/penyaluran_nonamr_daily'
						,err_constraint
						,'1admin'
						,v_record.idrefpelanggan
					  ,v_record.tanggalcatat
					  ,v_record.streamid);
					message = err_constraint;
					RAISE NOTICE 'Error data %',  err_constraint;
		RAISE NOTICE 'GHV : %', v_ghv;
	END;
	END LOOP;
	message = 'OK';
	RETURN message;
	--COMMIT;
END

$$;


ALTER FUNCTION transform.fn_approvenonamr(pstart date, pend date, parea character varying, pstatus character varying, psbu character varying, p_idreff character varying, p_nmpel character varying, create_by character varying, ptypeofdata integer) OWNER TO syfawija;

--
-- Name: fn_aprroveallnonamr(date, date, character varying, smallint, character varying, character varying); Type: FUNCTION; Schema: transform; Owner: syfawija
--

CREATE FUNCTION fn_aprroveallnonamr(start_date date, end_date date, p_idreff character varying, p_status smallint, p_sbu character varying, p_area character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$DECLARE	
	v_record RECORD;
	v_ghv NUMERIC;
	v_tanggal date;
BEGIN
	--Routine body goes here...
	for v_record IN
		SELECT * from "public".valdy_avr limit 10
	LOOP
	BEGIN
		v_tanggal = to_char(v_record.tanggalcatat, '9999-99-99 99:99:99')::DATE ;
		SELECT ghv into v_ghv 
			from  "public".getghv_mapping(v_tanggal, v_tanggal,v_record.idrefpelanggan, '', 0);

		RAISE NOTICE 'GHV : %', v_ghv;
	END;
	END LOOP;
	RETURN 'NULL';
END
$$;


ALTER FUNCTION transform.fn_aprroveallnonamr(start_date date, end_date date, p_idreff character varying, p_status smallint, p_sbu character varying, p_area character varying) OWNER TO syfawija;

--
-- Name: fn_getglobalstat(character varying); Type: FUNCTION; Schema: transform; Owner: syfawija
--

CREATE FUNCTION fn_getglobalstat(p_params character varying) RETURNS TABLE(tipe character varying, value character varying)
    LANGUAGE plpgsql
    AS $$BEGIN
	--Routine body goes here...

RETURN QUERY 
 
	select  *
	  from ms_global where ms_global.tipe = p_params;
	
END
$$;


ALTER FUNCTION transform.fn_getglobalstat(p_params character varying) OWNER TO syfawija;

--
-- Name: getdep(); Type: FUNCTION; Schema: transform; Owner: syfawija
--

CREATE FUNCTION getdep() RETURNS TABLE(rowid character varying, name_value character varying)
    LANGUAGE plpgsql
    AS $$ 
BEGIN
   
RETURN QUERY 
 
	select  dp.rowid  , 
	      dp.name_value
	from  "transform".mdepartements dp ;
                 
END 
$$;


ALTER FUNCTION transform.getdep() OWNER TO syfawija;

--
-- Name: insert_konsistensi(); Type: FUNCTION; Schema: transform; Owner: syfawija
--

CREATE FUNCTION insert_konsistensi() RETURNS character varying
    LANGUAGE plpgsql
    AS $$DECLARE
	v_record RECORD;
	v_bridge RECORD;
	v_hbridge RECORD;
	data_insert RECORD;
	v_measure RECORD;
	--v_tbpel RECORD;
	v_tbpel RECORD;
	v_fyear NUMERIC;
	v_fmonth NUMERIC;
	v_fdate NUMERIC;
	v_tanggal date;

BEGIN
	--Routine body goes here...
	SELECT * INTO data_insert from "transform".tbl_konsisten LIMIT 1;
	for v_record IN 
		SELECT *
		--from 
		from amr_alert_daily
		WHERE alertdate BETWEEN 20170901000000 and 20170930235959
		--and areacd = '021'
		--limit 10
		--GROUP BY idrefpelanggan
	LOOP
		BEGIN
			v_fyear  = substr(to_char(v_record.alertdate,'99999999999999'), 0,6)::NUMERIC;
			v_fmonth = substr(to_char(v_record.alertdate,'99999999999999'), 6,2)::NUMERIC;
			v_fdate  = substr(to_char(v_record.alertdate,'99999999999999'), 8,2)::NUMERIC;
	
			--data_insert.rowid = 'kons' || nextval('serial')::VARCHAR;
			
			data_insert.reffamralert = v_record.rowid;
			data_insert.final_status = v_record.final_status;
			data_insert.feeddatealert = v_record.credate;
			data_insert.createdatealert = v_record.credate;
			
			data_insert.selisihalert = to_date(to_char(v_record.alertdate,'9999-99-99 99:99:99'),'yyyy-mm-dd') - to_date(to_char(v_record.credate,'9999-99-99 99:99:99'),'yyyy-mm-dd');
			

			SELECT *
			INTO v_bridge
			from "public".amr_bridge_daily
			WHERE fyear = v_fyear
			and fmonth = v_fmonth
			and fdate = v_fdate
			and idrefpelanggan = v_record.idrefpelanggan
			and fstreamid = v_record.streamid;
		
			data_insert.reffamrbridge = v_bridge.rowid;
			data_insert.volume_bridge = v_bridge.fdvc;
			--data_insert.volume_bridge = v_bridge.fdvc;
			data_insert.feeddatebridge = v_bridge.feeddate;
			data_insert.createdatebridge = v_bridge.credate;
			data_insert.selisih_feeddatebridge = to_date(to_char(v_record.alertdate,'9999-99-99 99:99:99'),'yyyy-mm-dd') - to_date(to_char(v_bridge.feeddate,'9999-99-99 99:99:99'),'yyyy-mm-dd');
			data_insert.selisih_createdatebridge = to_date(to_char(v_record.alertdate,'9999-99-99 99:99:99'),'yyyy-mm-dd') - to_date(to_char(v_bridge.credate,'9999-99-99 99:99:99'),'yyyy-mm-dd');
			
			
			SELECT * 
			INTO v_hbridge
			from "public".h_penyaluran_amr_daily 
				WHERE 
				idpel = v_record.idrefpelanggan
				and fyear = v_fyear
				and fmonth = v_fmonth
				and fdate = v_fdate
				and streamid = v_record.streamid
			ORDER BY credate ASC
			limit 1;	
			
			data_insert.reffamrfinal = v_hbridge.penyaluran_amr_dailypenyaluranid;
			data_insert.volume_final = v_hbridge.fdvc;
			data_insert.ghv_final = v_hbridge.ghv;
			data_insert.energy_final = v_hbridge.energy;
			data_insert.createdatefinal = v_hbridge.credate;
			data_insert.reff_tax = v_hbridge.reffidtaxation;
			

			SELECT * INTO v_tbpel from "public".tbpel_validasi 
			WHERE tanggal_pengukuran = to_date(to_char(v_record.alertdate, '9999-99-99 99:99:99'),'yyy-mm-dd')
			and id_pel =  v_record.idrefpelanggan
			and stream = v_record.streamid;

				
			data_insert.reff_tax_final = v_tbpel.taxation_rowid;
			data_insert.last_energyfinal = v_tbpel.energy;
			data_insert.last_ghvfinal = v_tbpel.ghv_final;
			data_insert.lastvolfinal = v_tbpel.fdvc;
			data_insert.lastcreatedatefinal = v_tbpel.dateonfinal;
			
			RAISE NOTICE 'Error %',  data_insert;
			RAISE NOTICE 'v_fyear %',  v_fyear;
			RAISE NOTICE 'v_fmonth %',  v_fmonth;
			RAISE NOTICE 'v_fdate %',  v_fdate;
			
			IF(v_tbpel.jumlah_data_detail_taksasi > 0) THEN
				
				SELECT 
					id_pel,
				 nama_pel,
				 stream,
				 --alertdate,
				 --fdatetime,
				 fyear,
				 fmonth,
				 fdate,
				 --taxation_rowid,
				 tanggal_pengukuran,
				 --taxation_rowid_final,
				 ghv_final,
				 sum(energy) as energy,
				 SUM(fdvc) as fdvc,
				 --SUM(energy) as energy
				 assettype
					INTO v_measure
					from "public".tbpel_validasi WHERE id_pel = v_record.idrefpelanggan
					and tanggal_pengukuran = to_date(to_char(v_record.alertdate, '9999-99-99 99:99:99'),'yyy-mm-dd')
					and stream = v_record.streamid
					--and jumlah_data_detail_taksasi = 1
					GROUP BY 
					id_pel,
								 nama_pel,
								 stream,
								 --alertdate,
								 --fdatetime,
								 fyear,
								 fmonth,
								 fdate,
								 --taxation_rowid,
								 tanggal_pengukuran,
								 --taxation_rowid_final,
								 ghv_final,
								 assettype
					ORDER BY tanggal_pengukuran ASC;


				data_insert.last_energyfinal = v_measure.energy;
				data_insert.last_ghvfinal = v_measure.ghv_final;
				data_insert.lastvolfinal = v_measure.fdvc;
				
			END IF;
			

			RAISE NOTICE 'Alert Date %',  v_record.alertdate;
			INSERT INTO "transform".tbl_konsisten(reffamralert,final_status,feeddatealert,createdatealert,selisihalert
			,reffamrbridge,volume_bridge,feeddatebridge,createdatebridge,selisih_feeddatebridge,selisih_createdatebridge,alertdate
			,reffamrfinal,volume_final,ghv_final,energy_final,createdatefinal,idreff
			,reff_tax_final,last_energyfinal,last_ghvfinal,lastvolfinal,lastcreatedatefinal
			,reff_tax
			,stream
			)
			VALUES(data_insert.reffamralert,data_insert.final_status,data_insert.feeddatealert,data_insert.createdatealert,data_insert.selisihalert
			,data_insert.reffamrbridge,data_insert.volume_bridge,data_insert.feeddatebridge,data_insert.createdatebridge,data_insert.selisih_feeddatebridge,data_insert.selisih_createdatebridge,v_record.alertdate
			,data_insert.reffamrfinal,data_insert.volume_final,data_insert.ghv_final,data_insert.energy_final,data_insert.createdatefinal,v_record.idrefpelanggan
			,data_insert.reff_tax_final,data_insert.last_energyfinal,data_insert.last_ghvfinal,data_insert.lastvolfinal,data_insert.lastcreatedatefinal
			,data_insert.reff_tax	
			,v_record.streamid);

		END;
	END LOOP;
	RETURN 'NULL';
END
$$;


ALTER FUNCTION transform.insert_konsistensi() OWNER TO syfawija;

SET search_path = public, pg_catalog;

--
-- Name: seq_attribute; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE seq_attribute
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_attribute OWNER TO syfawija_syfa;

--
-- Name: attributedetails; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE attributedetails (
    rowid character varying(10) DEFAULT ('ATD'::text || nextval('seq_attribute'::regclass)) NOT NULL,
    rowid_msattribute character varying(10),
    value text,
    description text,
    msrowid character varying(50)
);


ALTER TABLE attributedetails OWNER TO syfawija_syfa;

--
-- Name: data_type_user_id_seq; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE data_type_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data_type_user_id_seq OWNER TO syfawija_syfa;

--
-- Name: data_type; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE data_type (
    rowid character varying(20) DEFAULT ('TOD'::text || nextval('data_type_user_id_seq'::regclass)),
    name character varying(100),
    kode text,
    create_by character varying(150),
    create_date date,
    update_by character varying(150),
    update_date date
);


ALTER TABLE data_type OWNER TO syfawija_syfa;

--
-- Name: dok_orkom; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE dok_orkom (
    rowid character varying(10) DEFAULT ('DOC'::text || nextval('serial'::regclass)) NOT NULL,
    project_id character varying(10),
    orkom_id character varying(10),
    doc_name character varying(255),
    version character varying(255),
    create_date date,
    create_by character varying(255)
);


ALTER TABLE dok_orkom OWNER TO syfawija_syfa;

--
-- Name: eventmenu; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE eventmenu (
    event_id bigint DEFAULT nextval('serial'::regclass) NOT NULL,
    event_name character varying,
    menu_id bigint
);


ALTER TABLE eventmenu OWNER TO syfawija_syfa;

--
-- Name: group_permission; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE group_permission (
    group_id bigint DEFAULT nextval('serial'::regclass) NOT NULL,
    name character varying,
    canrd text,
    canarea text,
    koordinatoruser text
);


ALTER TABLE group_permission OWNER TO syfawija_syfa;

--
-- Name: iconcls; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE iconcls (
    id integer NOT NULL,
    title character varying(32) NOT NULL,
    clsname character varying(128) NOT NULL,
    icon character varying(128) NOT NULL
);


ALTER TABLE iconcls OWNER TO syfawija_syfa;

--
-- Name: iconcls_id_seq; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE iconcls_id_seq
    START WITH 85
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iconcls_id_seq OWNER TO syfawija_syfa;

--
-- Name: iconcls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: syfawija_syfa
--

ALTER SEQUENCE iconcls_id_seq OWNED BY iconcls.id;


--
-- Name: master_data_user_id_seq; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE master_data_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data_user_id_seq OWNER TO syfawija_syfa;

--
-- Name: master_data; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE master_data (
    rowid character varying(20) DEFAULT ('MD'::text || nextval('master_data_user_id_seq'::regclass)),
    parent_id character varying(100),
    description text,
    type_id character varying(20),
    create_by character varying(150),
    create_date date,
    update_by character varying(150),
    update_date date,
    name character varying(100)
);


ALTER TABLE master_data OWNER TO syfawija_syfa;

--
-- Name: menu; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE menu (
    idmenu integer DEFAULT nextval('serial'::regclass) NOT NULL,
    name character varying(50),
    act character varying(50),
    parent bigint,
    sort bigint,
    iconcls character varying(30),
    path text,
    leaf character varying,
    hide smallint DEFAULT 0
);


ALTER TABLE menu OWNER TO syfawija_syfa;

--
-- Name: menu_event; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE menu_event (
    id integer NOT NULL,
    menu_id integer NOT NULL,
    event_name character varying(128) NOT NULL
);


ALTER TABLE menu_event OWNER TO syfawija_syfa;

--
-- Name: menu_event_id_seq; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE menu_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE menu_event_id_seq OWNER TO syfawija_syfa;

--
-- Name: menu_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: syfawija_syfa
--

ALTER SEQUENCE menu_event_id_seq OWNED BY menu_event.id;


--
-- Name: message; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE message
    START WITH 118
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE message OWNER TO syfawija_syfa;

--
-- Name: ms_attribute; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE ms_attribute (
    rowid character varying(20) DEFAULT ('ATR'::text || nextval('seq_attribute'::regclass)) NOT NULL,
    typeofdataid character varying(20),
    name character varying(100),
    description text,
    data_type character varying(100)
);


ALTER TABLE ms_attribute OWNER TO syfawija_syfa;

--
-- Name: TABLE ms_attribute; Type: COMMENT; Schema: public; Owner: syfawija_syfa
--

COMMENT ON TABLE ms_attribute IS 'Table Master Attribute';


--
-- Name: ms_autoreply; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE ms_autoreply (
    rowid character varying(20) DEFAULT ('RPLY'::text || nextval('serial'::regclass)) NOT NULL,
    programid character varying(100),
    value character varying(100),
    alias character varying(255),
    "desc" text,
    create_by character varying(255),
    create_date date,
    update_by character varying,
    update_date date
);


ALTER TABLE ms_autoreply OWNER TO syfawija_syfa;

--
-- Name: ms_global; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE ms_global (
    tipe character varying NOT NULL,
    value character varying(255)
);


ALTER TABLE ms_global OWNER TO syfawija_syfa;

--
-- Name: ms_items; Type: TABLE; Schema: public; Owner: syfawija
--

CREATE TABLE ms_items (
    rowid character varying(10) DEFAULT nextval('serial'::regclass),
    item_number character varying(20),
    item_category character varying(10),
    item_typeid character varying(10),
    farms character varying(10),
    kandang character varying(10),
    status character varying(100),
    qty numeric,
    uom character varying(100),
    craeteby character varying,
    createdate timestamp with time zone DEFAULT now(),
    updateby character varying,
    updatedate timestamp with time zone,
    item_name character varying(200)
);


ALTER TABLE ms_items OWNER TO syfawija;

--
-- Name: ms_message; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE ms_message (
    rowid character varying(100) DEFAULT ('MS'::text || nextval('message'::regclass)),
    programid character varying(100),
    satkerid character varying(100),
    nipg character varying(255),
    tipe_message character varying(255),
    stat_message character varying(255),
    message text,
    creart_by character varying(255),
    create_date timestamp(6) without time zone,
    update_by character varying(50),
    update_date timestamp(6) without time zone,
    reff_nipg character varying(100)
);


ALTER TABLE ms_message OWNER TO syfawija_syfa;

--
-- Name: COLUMN ms_message.tipe_message; Type: COMMENT; Schema: public; Owner: syfawija_syfa
--

COMMENT ON COLUMN ms_message.tipe_message IS '1=BROADCAST,2=REPLY,3=FORWARD,4=Needhelp';


--
-- Name: ms_orkom; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE ms_orkom (
    rowid character varying(10) DEFAULT ('ORKOM'::text || nextval('serial'::regclass)) NOT NULL,
    project_id character varying(10),
    parent character varying(10),
    activity_name character varying(255),
    dok character varying(255),
    no_dok character varying(255),
    pic character varying(255),
    tanggal date,
    status smallint,
    create_by character varying(255),
    create_date date
);


ALTER TABLE ms_orkom OWNER TO syfawija_syfa;

--
-- Name: sq_program; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE sq_program
    START WITH 6
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    CYCLE;


ALTER TABLE sq_program OWNER TO syfawija_syfa;

--
-- Name: ms_program; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE ms_program (
    rowid character varying(10) DEFAULT ('PRG'::text || nextval('sq_program'::regclass)) NOT NULL,
    title character varying(100),
    satker text,
    content text,
    create_date timestamp(6) without time zone DEFAULT now(),
    create_by character varying(100),
    update_by character varying,
    update_date timestamp(6) without time zone,
    tipe character varying(16)
);


ALTER TABLE ms_program OWNER TO syfawija_syfa;

--
-- Name: project; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE project
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project OWNER TO syfawija_syfa;

--
-- Name: ms_project; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE ms_project (
    rowid character varying(10) DEFAULT ('PROJECT'::text || nextval('project'::regclass)) NOT NULL,
    project_name character varying(255),
    start_project character varying(255),
    end_project character varying(255),
    project_segment character varying(255),
    project_owner character varying(255),
    project_manager character varying(255),
    project_status character varying(255),
    last_activity character varying(255),
    description text,
    create_date date,
    create_by character varying(255),
    update_date date,
    update_by character varying
);


ALTER TABLE ms_project OWNER TO syfawija_syfa;

--
-- Name: ms_segment; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE ms_segment (
    rowid character varying(20) DEFAULT ('SEGMENT'::text || nextval('serial'::regclass)) NOT NULL,
    segment character varying(255),
    code_segment character varying(255),
    create_date date,
    create_by character varying(255),
    update_date date,
    update_by character varying
);


ALTER TABLE ms_segment OWNER TO syfawija_syfa;

--
-- Name: srl_rjd; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE srl_rjd
    START WITH 16462
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE srl_rjd OWNER TO syfawija_syfa;

--
-- Name: ms_workflow; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE ms_workflow (
    rowid character varying DEFAULT ('MSW'::text || nextval('srl_rjd'::regclass)) NOT NULL,
    reffactivity character varying(30),
    reffemp character varying(30),
    createdate date,
    createperson character varying(30),
    updatedate date,
    updateperson character varying(30),
    status smallint,
    priority smallint,
    refforg integer,
    reffjobpos integer,
    reffeven character varying(255),
    createbyt character varying(255),
    nama_k character varying(255)
);


ALTER TABLE ms_workflow OWNER TO syfawija_syfa;

--
-- Name: mskonversiberat; Type: TABLE; Schema: public; Owner: syfawija
--

CREATE TABLE mskonversiberat (
    rowid character varying(11) DEFAULT ('konv'::text || nextval('serial'::regclass)) NOT NULL,
    items_id character varying(20),
    delivery_number character varying(20),
    start date,
    "end" date,
    berat numeric,
    uom character varying(20),
    createby character varying(100),
    createdate timestamp with time zone DEFAULT now(),
    updateby character varying,
    updatedate timestamp with time zone,
    kandang character varying(20),
    farms character varying(20)
);


ALTER TABLE mskonversiberat OWNER TO syfawija;

--
-- Name: TABLE mskonversiberat; Type: COMMENT; Schema: public; Owner: syfawija
--

COMMENT ON TABLE mskonversiberat IS 'Master Konversi Berat ayam';


--
-- Name: penc_ayam_id_seq; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE penc_ayam_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE penc_ayam_id_seq OWNER TO syfawija_syfa;

--
-- Name: permission; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE permission (
    menu_id bigint,
    group_id bigint,
    id character varying(50) DEFAULT ('idpriv '::text || nextval('serial'::regclass)) NOT NULL
);


ALTER TABLE permission OWNER TO syfawija_syfa;

--
-- Name: rev_user_user_id_seq; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE rev_user_user_id_seq
    START WITH 250
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rev_user_user_id_seq OWNER TO syfawija_syfa;

--
-- Name: rev_user; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE rev_user (
    user_id integer DEFAULT nextval('rev_user_user_id_seq'::regclass) NOT NULL,
    username character varying(30),
    password character varying(30),
    nama character varying(35),
    active character(1) DEFAULT 'Y'::bpchar,
    groupid bigint,
    usernameldap character varying(50),
    email character varying(255)
);


ALTER TABLE rev_user OWNER TO syfawija_syfa;

--
-- Name: role_group; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE role_group (
    role_menu_id bigint DEFAULT nextval('serial'::regclass),
    menu_id bigint,
    group_id integer,
    is_active character(2) DEFAULT 'Y'::bpchar
);


ALTER TABLE role_group OWNER TO syfawija_syfa;

--
-- Name: role_menu_event; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE role_menu_event (
    role_menu_event_id integer NOT NULL,
    menu_id integer,
    group_id integer,
    is_active character(1) DEFAULT 'Y'::bpchar,
    rowid integer DEFAULT nextval('serial'::regclass) NOT NULL
);


ALTER TABLE role_menu_event OWNER TO syfawija_syfa;

--
-- Name: role_menu_event_group; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE role_menu_event_group (
    role_menu_event_id integer NOT NULL,
    role_id integer,
    group_id integer,
    is_active integer DEFAULT 0 NOT NULL
);


ALTER TABLE role_menu_event_group OWNER TO syfawija_syfa;

--
-- Name: role_menu_event_group_role_menu_event_id_seq; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE role_menu_event_group_role_menu_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE role_menu_event_group_role_menu_event_id_seq OWNER TO syfawija_syfa;

--
-- Name: role_menu_event_group_role_menu_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: syfawija_syfa
--

ALTER SEQUENCE role_menu_event_group_role_menu_event_id_seq OWNED BY role_menu_event_group.role_menu_event_id;


--
-- Name: role_menu_group; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE role_menu_group (
    role_menu_id integer NOT NULL,
    menu_id integer,
    group_id integer,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE role_menu_group OWNER TO syfawija_syfa;

--
-- Name: role_menu_group_role_menu_id_seq; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE role_menu_group_role_menu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE role_menu_group_role_menu_id_seq OWNER TO syfawija_syfa;

--
-- Name: role_menu_group_role_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: syfawija_syfa
--

ALTER SEQUENCE role_menu_group_role_menu_id_seq OWNED BY role_menu_group.role_menu_id;


--
-- Name: showmenu; Type: VIEW; Schema: public; Owner: syfawija_syfa
--

CREATE VIEW showmenu AS
 SELECT menu.idmenu AS id,
    menu.name AS text,
    menu.act,
    menu.parent,
    menu.iconcls,
    menu.path,
    menu.leaf
   FROM menu;


ALTER TABLE showmenu OWNER TO syfawija_syfa;

--
-- Name: temp_inbox; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE temp_inbox (
    rowid character varying DEFAULT ('inb'::text || nextval('serial'::regclass)) NOT NULL,
    number character varying,
    message character varying(255),
    create_date timestamp(6) without time zone DEFAULT now(),
    stat character varying(2)
);


ALTER TABLE temp_inbox OWNER TO syfawija_syfa;

--
-- Name: trans_pecatatanayam; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE trans_pecatatanayam (
    rowid character varying(20) DEFAULT ('TPA'::text || nextval('penc_ayam_id_seq'::regclass)),
    id_farm character varying(20),
    id_kandang character varying(20),
    item_id character varying(20),
    delivery_no character varying(100),
    delivery_date date,
    jumlah numeric,
    ayam text,
    umur numeric,
    ukuran numeric,
    berat numeric,
    uom character varying(10),
    status_elemen character varying(20),
    status_transaksi character varying(5),
    create_by character varying(150),
    create_date date DEFAULT date(now()),
    update_by character varying(150),
    update_date date,
    id_angkatan character varying(20)
);


ALTER TABLE trans_pecatatanayam OWNER TO syfawija_syfa;

--
-- Name: user_group; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE user_group (
    group_id integer NOT NULL,
    group_name character varying(128),
    group_description character varying(128)
);


ALTER TABLE user_group OWNER TO syfawija_syfa;

--
-- Name: user_group_group_id_seq; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE user_group_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_group_group_id_seq OWNER TO syfawija_syfa;

--
-- Name: user_group_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: syfawija_syfa
--

ALTER SEQUENCE user_group_group_id_seq OWNED BY user_group.group_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: syfawija_syfa
--

CREATE TABLE users (
    user_id integer NOT NULL,
    user_name character varying(64),
    group_id integer,
    real_name character varying(128),
    last_login timestamp(6) without time zone,
    count_login integer DEFAULT 0,
    date_created timestamp(6) without time zone,
    user_password character varying(128),
    is_active boolean
);


ALTER TABLE users OWNER TO syfawija_syfa;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: syfawija_syfa
--

CREATE SEQUENCE users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_user_id_seq OWNER TO syfawija_syfa;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: syfawija_syfa
--

ALTER SEQUENCE users_user_id_seq OWNED BY users.user_id;


--
-- Name: v_datatype; Type: VIEW; Schema: public; Owner: syfawija
--

CREATE VIEW v_datatype AS
 SELECT data_type.rowid,
    data_type.name,
    data_type.kode,
    data_type.create_by,
    data_type.create_date,
    data_type.update_by,
    data_type.update_date
   FROM data_type
  WHERE ((data_type.rowid)::text <> ALL ((ARRAY['TOD17'::character varying, 'TOD19'::character varying, 'TOD22'::character varying, 'TOD23'::character varying, 'TOD24'::character varying, 'TOD3'::character varying, 'TOD2'::character varying, 'TOD13'::character varying])::text[]));


ALTER TABLE v_datatype OWNER TO syfawija;

--
-- Name: VIEW v_datatype; Type: COMMENT; Schema: public; Owner: syfawija
--

COMMENT ON VIEW v_datatype IS 'view data type';


--
-- Name: v_forwardmessage; Type: VIEW; Schema: public; Owner: syfawija_syfa
--

CREATE VIEW v_forwardmessage AS
 SELECT ms_message.nipg,
    ms_employee.nama_karyawan,
    ms_employee.phone,
    ms_message.tipe_message,
    ms_satker.satker,
    ms_message.message,
    ms_message.stat_message,
    ms_program.title,
    ms_message.reff_nipg,
    mp.nama_karyawan AS reff_karyawan
   FROM ((((ms_message
     JOIN ms_satker ON (((ms_satker.rowid)::text = (ms_message.satkerid)::text)))
     JOIN ms_employee ON (((ms_employee.nipg)::text = (ms_message.nipg)::text)))
     JOIN ms_program ON (((ms_program.rowid)::text = (ms_message.programid)::text)))
     JOIN ms_employee mp ON (((mp.nipg)::text = (ms_message.reff_nipg)::text)))
  WHERE ((ms_message.tipe_message)::text = '3'::text);


ALTER TABLE v_forwardmessage OWNER TO syfawija_syfa;

--
-- Name: v_jabatan; Type: VIEW; Schema: public; Owner: syfawija_syfa
--

CREATE VIEW v_jabatan AS
 SELECT ms_position.id,
    ms_position.parent,
    ms_position.jabatan AS text,
    ms_position.rowid AS v_id,
    ms_position.level
   FROM ms_position;


ALTER TABLE v_jabatan OWNER TO syfawija_syfa;

--
-- Name: v_kandangunion; Type: VIEW; Schema: public; Owner: syfawija_syfa
--

CREATE VIEW v_kandangunion AS
 SELECT fn_getdata.id,
    fn_getdata.parent,
    fn_getdata.desk AS alamat,
    fn_getdata.nama AS text,
    fn_getdata.jenis_data
   FROM fn_getdatamastertype('TOD3'::character varying) fn_getdata(id, parent, desk, nama, jenis_data)
UNION
 SELECT fn_getdat.id,
    fn_getdat.parent,
    fn_getdat.desk AS alamat,
    fn_getdat.nama AS text,
    fn_getdat.jenis_data
   FROM fn_getdatamastertype('TOD2'::character varying) fn_getdat(id, parent, desk, nama, jenis_data);


ALTER TABLE v_kandangunion OWNER TO syfawija_syfa;

--
-- Name: VIEW v_kandangunion; Type: COMMENT; Schema: public; Owner: syfawija_syfa
--

COMMENT ON VIEW v_kandangunion IS 'Kandang';


--
-- Name: v_konversiberat; Type: VIEW; Schema: public; Owner: syfawija
--

CREATE VIEW v_konversiberat AS
 SELECT a.rowid,
    a.items_id,
    a.delivery_number,
    a.start,
    a."end",
    a.berat,
    a.uom,
    a.createby,
    a.createdate,
    a.updateby,
    a.updatedate,
    a.kandang,
    a.farms,
    b.name AS nama_item
   FROM (mskonversiberat a
     JOIN master_data b ON (((a.items_id)::text = (b.rowid)::text)));


ALTER TABLE v_konversiberat OWNER TO syfawija;

--
-- Name: VIEW v_konversiberat; Type: COMMENT; Schema: public; Owner: syfawija
--

COMMENT ON VIEW v_konversiberat IS 'View Konversi Berat';


--
-- Name: v_masteritems; Type: VIEW; Schema: public; Owner: syfawija
--

CREATE VIEW v_masteritems AS
 SELECT a.rowid,
    a.item_number,
    a.item_category,
    a.item_typeid,
    a.farms,
    a.kandang,
    a.status,
    a.qty,
    a.uom,
    a.craeteby,
    a.createdate,
    a.updateby,
    a.updatedate,
    a.item_name,
    b.name AS kategoi_barang,
    c.name AS tipe_barang,
    d.name AS lokasi_farms,
    e.name AS lokasi_kandang
   FROM ((((ms_items a
     JOIN master_data b ON (((a.item_category)::text = (b.rowid)::text)))
     JOIN data_type c ON (((a.item_typeid)::text = (c.rowid)::text)))
     LEFT JOIN master_data d ON (((a.farms)::text = (d.rowid)::text)))
     LEFT JOIN master_data e ON (((a.kandang)::text = (e.rowid)::text)));


ALTER TABLE v_masteritems OWNER TO syfawija;

--
-- Name: VIEW v_masteritems; Type: COMMENT; Schema: public; Owner: syfawija
--

COMMENT ON VIEW v_masteritems IS 'Master Items';


--
-- Name: v_menu; Type: VIEW; Schema: public; Owner: syfawija_syfa
--

CREATE VIEW v_menu AS
 SELECT menu.idmenu,
    menu.name,
    menu.act,
    menu.parent,
    menu.sort,
    menu.iconcls,
    menu.path,
    menu.leaf,
    permission.group_id
   FROM (menu
     JOIN permission ON ((permission.menu_id = menu.idmenu)))
  WHERE (menu.hide = 0)
  ORDER BY menu.sort;


ALTER TABLE v_menu OWNER TO syfawija_syfa;

--
-- Name: v_message_broadacst; Type: VIEW; Schema: public; Owner: syfawija_syfa
--

CREATE VIEW v_message_broadacst AS
 SELECT ms_message.nipg,
    ms_employee.nama_karyawan,
    ms_employee.phone,
    ms_message.tipe_message,
    ms_satker.satker,
    ms_message.message,
    ms_message.stat_message,
    ms_program.title,
    ms_employee.job_pos,
    ms_position.id AS reffjobpos,
    ms_program.rowid AS programid,
    ms_satker.rowid AS reffsatkerid
   FROM ((((ms_message
     JOIN ms_satker ON (((ms_satker.rowid)::text = (ms_message.satkerid)::text)))
     JOIN ms_employee ON (((ms_employee.nipg)::text = (ms_message.nipg)::text)))
     JOIN ms_program ON (((ms_program.rowid)::text = (ms_message.programid)::text)))
     JOIN ms_position ON (((ms_employee.job_pos)::text = (ms_position.rowid)::text)))
  WHERE ((ms_message.tipe_message)::text = '1'::text);


ALTER TABLE v_message_broadacst OWNER TO syfawija_syfa;

--
-- Name: v_needhelp; Type: VIEW; Schema: public; Owner: syfawija_syfa
--

CREATE VIEW v_needhelp AS
 SELECT ms_message.nipg,
    ms_employee.nama_karyawan,
    ms_employee.phone,
    ms_message.tipe_message,
    ms_satker.satker,
    ms_message.message,
    ms_message.stat_message,
    ms_program.title
   FROM (((ms_message
     JOIN ms_satker ON (((ms_satker.rowid)::text = (ms_message.satkerid)::text)))
     JOIN ms_employee ON (((ms_employee.nipg)::text = (ms_message.nipg)::text)))
     JOIN ms_program ON (((ms_program.rowid)::text = (ms_message.programid)::text)));


ALTER TABLE v_needhelp OWNER TO syfawija_syfa;

--
-- Name: v_pencatatan; Type: VIEW; Schema: public; Owner: syfawija
--

CREATE VIEW v_pencatatan AS
 SELECT a.rowid,
    d.nama AS farms,
    e.nama AS kandang,
    a.item_id AS item,
    a.delivery_no,
    a.delivery_date,
    a.jumlah,
    f.nama AS ayam,
    a.umur,
    a.ukuran,
    a.berat,
    g.nama AS uom,
    c.nama AS status_elemen,
    b.nama AS tatus_transaksi,
    b.id AS reffstattrans,
    c.id AS reffstatelemen,
    d.id AS refffarms,
    e.id AS reffkandang,
    a.create_date,
    a.create_by,
    a.update_date,
    a.update_by,
    fn_getsaldo(a.id_kandang, a.rowid, a.id_angkatan, 'TOD21'::character varying) AS saldo,
    a.uom AS id_uom,
    a.id_angkatan AS reffangkatan,
    h.desk AS nama_angkatan
   FROM (((((((trans_pecatatanayam a
     LEFT JOIN fn_getdatamastertype('TOD17'::character varying) b(id, parent, desk, nama, jenis_data) ON (((a.status_transaksi)::text = (b.id)::text)))
     LEFT JOIN fn_getdatamastertype('TOD19'::character varying) c(id, parent, desk, nama, jenis_data) ON (((a.status_elemen)::text = (c.id)::text)))
     LEFT JOIN fn_getdatamastertype('TOD2'::character varying) d(id, parent, desk, nama, jenis_data) ON (((a.id_farm)::text = (d.id)::text)))
     LEFT JOIN fn_getdatamastertype('TOD3'::character varying) e(id, parent, desk, nama, jenis_data) ON (((a.id_kandang)::text = (e.id)::text)))
     LEFT JOIN fn_getdatamastertype('TOD21'::character varying) f(id, parent, desk, nama, jenis_data) ON (((a.item_id)::text = (f.id)::text)))
     LEFT JOIN fn_getdatamastertype('TOD16'::character varying) g(id, parent, desk, nama, jenis_data) ON (((a.uom)::text = (g.id)::text)))
     LEFT JOIN fn_getdatamastertype('TOD22'::character varying) h(id, parent, desk, nama, jenis_data) ON (((a.id_angkatan)::text = (h.id)::text)));


ALTER TABLE v_pencatatan OWNER TO syfawija;

--
-- Name: v_revuser; Type: VIEW; Schema: public; Owner: syfawija_syfa
--

CREATE VIEW v_revuser AS
 SELECT rev_user.user_id,
    rev_user.username,
    rev_user.password,
    rev_user.nama,
    rev_user.active,
    rev_user.groupid,
    rev_user.usernameldap,
    group_permission.name AS "group",
    rev_user.email
   FROM (rev_user
     LEFT JOIN group_permission ON ((rev_user.groupid = group_permission.group_id)));


ALTER TABLE v_revuser OWNER TO syfawija_syfa;

--
-- Name: v_role_menu_event; Type: VIEW; Schema: public; Owner: syfawija_syfa
--

CREATE VIEW v_role_menu_event AS
 SELECT DISTINCT eventmenu.event_id AS role_menu_event_id,
    role_menu_event.menu_id,
    role_menu_event.group_id,
    role_menu_event.is_active,
    eventmenu.event_name
   FROM (role_menu_event
     JOIN eventmenu ON ((eventmenu.menu_id = role_menu_event.menu_id)));


ALTER TABLE v_role_menu_event OWNER TO syfawija_syfa;

--
-- Name: v_workflow; Type: VIEW; Schema: public; Owner: syfawija_syfa
--

CREATE VIEW v_workflow AS
 SELECT b.nipg,
    b.nama_karyawan,
    b.phone,
    b.nama_jabatan,
    b.nama_satker,
    a.createbyt,
    a.reffeven
   FROM (ms_workflow a
     JOIN v_employee b ON (((a.reffemp)::text = (b.rowid)::text)))
  ORDER BY a.createbyt;


ALTER TABLE v_workflow OWNER TO syfawija_syfa;

--
-- Name: vreply_message; Type: VIEW; Schema: public; Owner: syfawija_syfa
--

CREATE VIEW vreply_message AS
 SELECT ms_message.nipg,
    ms_employee.nama_karyawan,
    ms_employee.phone,
    ms_message.tipe_message,
    ms_satker.satker,
    ms_message.message,
    ms_message.stat_message,
    ms_program.title,
        CASE
            WHEN (split_part(ms_message.message, '#'::text, 1) = '1'::text) THEN 'Saya Baik Baik saja'::text
            WHEN (split_part(ms_message.message, '#'::text, 1) = '2'::text) THEN 'Saya Membutuhkan Bantuan'::text
            ELSE 'Undifined'::text
        END AS stat_karyawan,
        CASE
            WHEN (split_part(ms_message.message, '#'::text, 1) = '1'::text) THEN '1'::text
            WHEN (split_part(ms_message.message, '#'::text, 1) = '2'::text) THEN '2'::text
            ELSE 'Undifined'::text
        END AS kode_stat_karyawan
   FROM (((ms_message
     JOIN ms_satker ON (((ms_satker.rowid)::text = (ms_message.satkerid)::text)))
     JOIN ms_employee ON (((ms_employee.nipg)::text = (ms_message.nipg)::text)))
     JOIN ms_program ON (((ms_program.rowid)::text = (ms_message.programid)::text)))
  WHERE ((ms_message.tipe_message)::text = '2'::text);


ALTER TABLE vreply_message OWNER TO syfawija_syfa;

SET search_path = transform, pg_catalog;

--
-- Name: ba_crm; Type: TABLE; Schema: transform; Owner: syfawija
--

CREATE TABLE ba_crm (
    row_id character varying(70) NOT NULL,
    acc_id character varying(15),
    acc_name character varying(100),
    no_ref character varying(30),
    kd_area character varying(30),
    asset_id character varying(15),
    asset_serial character varying(100),
    asset_type character varying(30),
    asset_meas_id character varying(15),
    asset_rdng_id character varying(15),
    param_ukur character varying(30),
    source character varying(30),
    unit_ukur character varying(30),
    stand_awal numeric,
    stand_akhir numeric,
    selisih numeric,
    suhu numeric,
    tekanan numeric,
    fktr_koreksi numeric,
    kalori numeric,
    terukur_m3 numeric,
    terukur_mmbtu numeric,
    terukur_mscf numeric,
    sg numeric,
    n2 numeric,
    co2 numeric,
    ghv numeric,
    description text,
    agree_id character varying(15),
    pmn_agree_id character varying(15),
    min_stand_awal numeric,
    max_stand_akhir numeric,
    max_fktr_koreksi numeric,
    sum_vol_pemakaian numeric,
    acc_id_period_for_link character varying(30),
    akumulasi_m3 numeric,
    akumulasi_mmbtu numeric,
    ghv_btu character varying(30),
    kalori_btu character varying(30),
    created timestamp(6) without time zone,
    period_month date,
    period date,
    stg2_date_created timestamp(6) without time zone
);


ALTER TABLE ba_crm OWNER TO syfawija;

--
-- Name: srl_po; Type: SEQUENCE; Schema: transform; Owner: syfawija
--

CREATE SEQUENCE srl_po
    START WITH 6002826
    INCREMENT BY 1
    MINVALUE 6002826
    NO MAXVALUE
    CACHE 1;


ALTER TABLE srl_po OWNER TO syfawija;

--
-- Name: get_profile_column; Type: TABLE; Schema: transform; Owner: syfawija
--

CREATE TABLE get_profile_column (
    rowid character varying(50) DEFAULT ('rw'::text || nextval('srl_po'::regclass)) NOT NULL,
    id_grid character varying(50),
    ptbl text,
    create_date timestamp(6) without time zone DEFAULT now(),
    kolom text,
    search text,
    source character varying(255),
    submit_value character varying
);


ALTER TABLE get_profile_column OWNER TO syfawija;

--
-- Name: srl_dep; Type: SEQUENCE; Schema: transform; Owner: syfawija
--

CREATE SEQUENCE srl_dep
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE srl_dep OWNER TO syfawija;

--
-- Name: mdepartements; Type: TABLE; Schema: transform; Owner: syfawija
--

CREATE TABLE mdepartements (
    rowid character varying(12) DEFAULT concat('DEP', nextval('srl_dep'::regclass)) NOT NULL,
    name_value character varying(50),
    refhusid character varying(12) NOT NULL,
    delflag numeric(3,0),
    created_by character varying(12),
    updated_by character varying(12),
    deleted_by character varying(12),
    updcnt numeric(5,0),
    credate numeric(14,0),
    upddate numeric(14,0)
);


ALTER TABLE mdepartements OWNER TO syfawija;

--
-- Name: srl_hus; Type: SEQUENCE; Schema: transform; Owner: syfawija
--

CREATE SEQUENCE srl_hus
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE srl_hus OWNER TO syfawija;

--
-- Name: ref_hus; Type: TABLE; Schema: transform; Owner: syfawija
--

CREATE TABLE ref_hus (
    rowid character varying(12) DEFAULT concat('HUS', nextval('srl_hus'::regclass)) NOT NULL,
    name_value character varying(50),
    code_value character varying(12),
    code_business character varying(12),
    delflag numeric(3,0),
    credate numeric(14,0),
    created_by character varying(12),
    upddate numeric(14,0),
    updated_by character varying(12),
    updcnt numeric(5,0)
);


ALTER TABLE ref_hus OWNER TO syfawija;

--
-- Name: table_test; Type: TABLE; Schema: transform; Owner: syfawija
--

CREATE TABLE table_test (
    rowid character varying(12),
    reffidamrdaily bigint,
    idrefpelanggan character varying(12),
    noref character varying(8),
    id_unit_usaha character varying(5),
    fcustomerid character varying(20),
    fstreamid integer,
    fdatetime numeric(14,0),
    fdate integer,
    fmonth integer,
    fyear integer,
    fhour integer,
    fminute integer,
    fsecond integer,
    fsector integer,
    fperiod integer,
    fdvm numeric,
    fdvc numeric,
    fp numeric,
    ft numeric,
    fvm numeric,
    fvc numeric,
    fcf numeric,
    fmc numeric,
    fmn numeric,
    fsg numeric,
    fgv numeric,
    fen numeric,
    fvctime numeric(14,0),
    fvcstatus character varying(255),
    pbase numeric,
    tbase numeric,
    pmax numeric,
    pmin numeric,
    qmax numeric,
    qmin numeric,
    tmax numeric,
    tmin numeric,
    qbase_max numeric,
    qbase_min numeric,
    bbtu numeric,
    attribute1 character varying(150),
    attribute2 character varying(150),
    approved_status integer,
    approved_by character varying(50),
    approved_date numeric(14,0),
    reffcreated_date numeric(14,0),
    reffcreated_by character varying(50),
    reffupdated_date numeric(14,0),
    reffupdated_by character varying(50),
    feeddate numeric(14,0),
    delflag numeric(5,0),
    credate numeric(19,0),
    creperson character varying(20),
    upddate numeric(14,0),
    updperson character varying(20),
    updcnt numeric(5,0)
);


ALTER TABLE table_test OWNER TO syfawija;

SET search_path = public, pg_catalog;

--
-- Name: iconcls id; Type: DEFAULT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY iconcls ALTER COLUMN id SET DEFAULT nextval('iconcls_id_seq'::regclass);


--
-- Name: menu_event id; Type: DEFAULT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY menu_event ALTER COLUMN id SET DEFAULT nextval('menu_event_id_seq'::regclass);


--
-- Name: role_menu_event_group role_menu_event_id; Type: DEFAULT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY role_menu_event_group ALTER COLUMN role_menu_event_id SET DEFAULT nextval('role_menu_event_group_role_menu_event_id_seq'::regclass);


--
-- Name: role_menu_group role_menu_id; Type: DEFAULT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY role_menu_group ALTER COLUMN role_menu_id SET DEFAULT nextval('role_menu_group_role_menu_id_seq'::regclass);


--
-- Name: user_group group_id; Type: DEFAULT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY user_group ALTER COLUMN group_id SET DEFAULT nextval('user_group_group_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY users ALTER COLUMN user_id SET DEFAULT nextval('users_user_id_seq'::regclass);


--
-- Data for Name: attributedetails; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY attributedetails (rowid, rowid_msattribute, value, description, msrowid) FROM stdin;
\.


--
-- Data for Name: data_type; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY data_type (rowid, name, kode, create_by, create_date, update_by, update_date) FROM stdin;
TOD3	Kandang	Kandang	\N	\N	\N	\N
TOD2	Farms	Farms	\N	\N	\N	\N
TOD6	Vaksin	Vaksin	\N	\N	\N	\N
TOD7	Vitamin	Vitamin	\N	\N	\N	\N
TOD8	Desinfektan	Desinfektan	\N	\N	\N	\N
TOD9	Anti Biotik	Anti Biotik	\N	\N	\N	\N
TOD10	Ransum	Ransum	\N	\N	\N	\N
TOD11	Sekam	Sekam	\N	\N	\N	\N
TOD12	Gaji	Gaji	\N	\N	\N	\N
TOD13	PIC Kandang	PIC Kandang	\N	\N	\N	\N
TOD14	Ayam	Ayam	\N	\N	\N	\N
TOD15	Box	Box	\N	\N	\N	\N
TOD16	UOM	Uom	\N	\N	\N	\N
TOD17	STATTRANS	Status Transaksi	\N	\N	\N	\N
TOD19	STAT ELEMENT	Status Element	\N	\N	\N	\N
TOD20	UOM	UOM	\N	\N	\N	\N
TOD21	AYAM	Item Ayam	\N	\N	\N	\N
TOD22	Angkatan	Angkatan	\N	\N	\N	\N
TOD23	Status Active	Status Active	\N	\N	\N	\N
TOD24	Rekanan	Rekanan	\N	\N	\N	\N
TOD5	Pakan	Pakan Ayam	\N	\N	\N	\N
TOD25	Status Kandang	Status Kandang	\N	\N	\N	\N
\.


--
-- Name: data_type_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('data_type_user_id_seq', 25, true);


--
-- Data for Name: dok_orkom; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY dok_orkom (rowid, project_id, orkom_id, doc_name, version, create_date, create_by) FROM stdin;
\.


--
-- Data for Name: eventmenu; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY eventmenu (event_id, event_name, menu_id) FROM stdin;
115318	p_export	115316
115356	p_export	115323
115357	p_approve	115324
115358	p_reject	115324
115359	p_export	115324
115360	p_approve	115325
115361	p_reject	115325
115362	p_export	115325
115363	p_approve	115326
115364	p_reject	115326
115365	p_download	115326
115366	p_rebatch	115326
3504393	p_rebatch	115323
3504394	p_export	3078328
3504395	p_calculate	3078328
3505957	p_export	115330
3505958	p_rebatch	115330
3505959	p_aprove	115330
3505960	p_reject	115330
3505961	p_hourly	115330
3505962	p_upload	115330
3505963	p_taksasi	115330
3531463	p_unapproved	3078328
3534103	p_approve	324
3571966	p_rebatch	326
3571967	p_rebatch	326
3571968	p_approve	115327
3571969	p_reject	115327
3571970	p_download	115327
3578279	p_rebatch	326
3578490	p_rebatch	326
3578491	p_rebatch	326
3583968	p_rebatch	115327
3821495	p_appalert	115325
5259543	p_export	5259476
5259544	p_rebacth	5259476
5259545	p_rebatch	9476
5259546	p_rebatch	9476
5260743	p_approve	5260675
5260744	p_reject	5260675
5260745	p_export	5260675
5260822	p_rebacth	5260750
5260823	p_export	5260750
5260826	p_approve	5260751
5260827	p_reject	5260751
5260828	p_export	5260751
\.


--
-- Data for Name: group_permission; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY group_permission (group_id, name, canrd, canarea, koordinatoruser) FROM stdin;
115317	Administrator	[{"id":"BU14","text":"RD 1","parent":"0"},{"id":"BU15","text":"RD 2","parent":"0"},{"id":"BU16","text":"RD 3","parent":"0"},{"id":"BU17","text":"Transmisi SSWJ","parent":"0"}]	[{"id":"AR39","text":"Jakarta","parent":"BU14"},{"id":"AR40","text":"Tangerang","parent":"BU14"},{"id":"AR41","text":"Bekasi","parent":"BU14"},{"id":"AR42","text":"Karawang","parent":"BU14"},{"id":"AR43","text":"Bogor","parent":"BU14"},{"id":"AR44","text":"Cirebon","parent":"BU14"},{"id":"AR45","text":"Palembang","parent":"BU14"},{"id":"AR46","text":"Lampung","parent":"BU14"},{"id":"AR47","text":"Cilegon","parent":"BU14"},{"id":"AR48","text":"Surabaya","parent":"BU15"},{"id":"AR49","text":"Sidoarjo","parent":"BU15"},{"id":"AR50","text":"Pasuruan","parent":"BU15"},{"id":"AR58","text":"Semarang","parent":"BU15"},{"id":"AR51","text":"Medan","parent":"BU16"},{"id":"AR52","text":"Pekan Baru","parent":"BU16"},{"id":"AR53","text":"Batam","parent":"BU16"},{"id":"AR54","text":"OP I","parent":"BU17"},{"id":"AR55","text":"OP II","parent":"BU17"},{"id":"AR56","text":"OP III","parent":"BU17"}]	hakimgy@gmail.com
115318	SPV RD1	[{"id":"BU14","text":"RD 1","parent":"0"},{"id":"BU17","text":"Transmisi SSWJ","parent":"0"}]	[{"id":"AR39","text":"Jakarta","parent":"BU14"},{"id":"AR40","text":"Tangerang","parent":"BU14"},{"id":"AR41","text":"Bekasi","parent":"BU14"},{"id":"AR42","text":"Karawang","parent":"BU14"},{"id":"AR43","text":"Bogor","parent":"BU14"},{"id":"AR44","text":"Cirebon","parent":"BU14"},{"id":"AR45","text":"Palembang","parent":"BU14"},{"id":"AR46","text":"Lampung","parent":"BU14"},{"id":"AR47","text":"Cilegon","parent":"BU14"},{"id":"AR54","text":"OP I","parent":"BU17"},{"id":"AR55","text":"OP II","parent":"BU17"},{"id":"AR56","text":"OP III","parent":"BU17"}]	hakimgy@gmail.com;rochmad.sigit@gmail.com;asep.saepulah@pgn.co.id
3409847	SPV RD2	[{"id":"BU15","text":"RD 2","parent":"0"}]	[{"id":"AR48","text":"Surabaya","parent":"BU15"},{"id":"AR49","text":"Sidoarjo","parent":"BU15"},{"id":"AR50","text":"Pasuruan","parent":"BU15"},{"id":"AR58","text":"Semarang","parent":"BU15"}]	\N
3409849	SPV RD3	[{"id":"BU16","text":"RD 3","parent":"0"}]	[{"id":"AR51","text":"Medan","parent":"BU16"},{"id":"AR52","text":"Pekan Baru","parent":"BU16"},{"id":"AR53","text":"Batam","parent":"BU16"}]	\N
3447879	SPV RT	[{"id":"BU17","text":"Transmisi SSWJ","parent":"0"}]	[{"id":"AR54","text":"OP I","parent":"BU17"},{"id":"AR55","text":"OP II","parent":"BU17"},{"id":"AR56","text":"OP III","parent":"BU17"}]	\N
3447880	SPV BUIO	[{"id":"BU14","text":"RD 1","parent":"0"},{"id":"BU15","text":"RD 2","parent":"0"},{"id":"BU16","text":"RD 3","parent":"0"},{"id":"BU17","text":"Transmisi SSWJ","parent":"0"}]	[{"id":"AR39","text":"Jakarta","parent":"BU14"},{"id":"AR40","text":"Tangerang","parent":"BU14"},{"id":"AR41","text":"Bekasi","parent":"BU14"},{"id":"AR42","text":"Karawang","parent":"BU14"},{"id":"AR43","text":"Bogor","parent":"BU14"},{"id":"AR44","text":"Cirebon","parent":"BU14"},{"id":"AR45","text":"Palembang","parent":"BU14"},{"id":"AR46","text":"Lampung","parent":"BU14"},{"id":"AR47","text":"Cilegon","parent":"BU14"},{"id":"AR48","text":"Surabaya","parent":"BU15"},{"id":"AR49","text":"Sidoarjo","parent":"BU15"},{"id":"AR50","text":"Pasuruan","parent":"BU15"},{"id":"AR58","text":"Semarang","parent":"BU15"},{"id":"AR51","text":"Medan","parent":"BU16"},{"id":"AR52","text":"Pekan Baru","parent":"BU16"},{"id":"AR53","text":"Batam","parent":"BU16"},{"id":"AR54","text":"OP I","parent":"BU17"},{"id":"AR55","text":"OP II","parent":"BU17"},{"id":"AR56","text":"OP III","parent":"BU17"}]	\N
3450408	TEST	[{"id":"BU14","text":"RD 1","parent":"0"},{"id":"BU15","text":"RD 2","parent":"0"},{"id":"BU16","text":"RD 3","parent":"0"},{"id":"BU17","text":"Transmisi SSWJ","parent":"0"}]	[{"id":"AR39","text":"Jakarta","parent":"BU14"},{"id":"AR40","text":"Tangerang","parent":"BU14"},{"id":"AR41","text":"Bekasi","parent":"BU14"},{"id":"AR42","text":"Karawang","parent":"BU14"},{"id":"AR43","text":"Bogor","parent":"BU14"},{"id":"AR44","text":"Cirebon","parent":"BU14"},{"id":"AR45","text":"Palembang","parent":"BU14"},{"id":"AR46","text":"Lampung","parent":"BU14"},{"id":"AR47","text":"Cilegon","parent":"BU14"},{"id":"AR48","text":"Surabaya","parent":"BU15"},{"id":"AR49","text":"Sidoarjo","parent":"BU15"},{"id":"AR50","text":"Pasuruan","parent":"BU15"},{"id":"AR58","text":"Semarang","parent":"BU15"},{"id":"AR51","text":"Medan","parent":"BU16"},{"id":"AR52","text":"Pekan Baru","parent":"BU16"},{"id":"AR53","text":"Batam","parent":"BU16"},{"id":"AR54","text":"OP I","parent":"BU17"},{"id":"AR55","text":"OP II","parent":"BU17"},{"id":"AR56","text":"OP III","parent":"BU17"}]	\N
3717178	GSOT BUIO	[{"id":"BU14","text":"RD 1","parent":"0"},{"id":"BU15","text":"RD 2","parent":"0"},{"id":"BU16","text":"RD 3","parent":"0"},{"id":"BU17","text":"Transmisi SSWJ","parent":"0"},{"id":"BU18","text":"Transmisi Sumut","parent":"0"}]	[{"id":"AR39","text":"Jakarta","parent":"BU14"},{"id":"AR40","text":"Tangerang","parent":"BU14"},{"id":"AR41","text":"Bekasi","parent":"BU14"},{"id":"AR42","text":"Karawang","parent":"BU14"},{"id":"AR43","text":"Bogor","parent":"BU14"},{"id":"AR44","text":"Cirebon","parent":"BU14"},{"id":"AR45","text":"Palembang","parent":"BU14"},{"id":"AR46","text":"Lampung","parent":"BU14"},{"id":"AR47","text":"Cilegon","parent":"BU14"},{"id":"AR48","text":"Surabaya","parent":"BU15"},{"id":"AR49","text":"Sidoarjo","parent":"BU15"},{"id":"AR50","text":"Pasuruan","parent":"BU15"},{"id":"AR58","text":"Semarang","parent":"BU15"},{"id":"AR51","text":"Medan","parent":"BU16"},{"id":"AR52","text":"Pekan Baru","parent":"BU16"},{"id":"AR53","text":"Batam","parent":"BU16"},{"id":"AR54","text":"OP I","parent":"BU17"},{"id":"AR55","text":"OP II","parent":"BU17"},{"id":"AR56","text":"OP III","parent":"BU17"},{"id":"AR57","text":"Medan Transmisi","parent":"BU18"}]	
3813778	Validator BUIO	[{"id":"BU13","text":"NON PGN","parent":"0"},{"id":"BU14","text":"RD 1","parent":"0"},{"id":"BU15","text":"RD 2","parent":"0"},{"id":"BU16","text":"RD 3","parent":"0"},{"id":"BU17","text":"Transmisi SSWJ","parent":"0"},{"id":"BU18","text":"Transmisi Sumut","parent":"0"}]	[{"id":"AR39","text":"Jakarta","parent":"BU14"},{"id":"AR40","text":"Tangerang","parent":"BU14"},{"id":"AR41","text":"Bekasi","parent":"BU14"},{"id":"AR42","text":"Karawang","parent":"BU14"},{"id":"AR43","text":"Bogor","parent":"BU14"},{"id":"AR44","text":"Cirebon","parent":"BU14"},{"id":"AR45","text":"Palembang","parent":"BU14"},{"id":"AR46","text":"Lampung","parent":"BU14"},{"id":"AR47","text":"Cilegon","parent":"BU14"},{"id":"AR48","text":"Surabaya","parent":"BU15"},{"id":"AR49","text":"Sidoarjo","parent":"BU15"},{"id":"AR50","text":"Pasuruan","parent":"BU15"},{"id":"AR58","text":"Semarang","parent":"BU15"},{"id":"AR51","text":"Medan","parent":"BU16"},{"id":"AR52","text":"Pekan Baru","parent":"BU16"},{"id":"AR53","text":"Batam","parent":"BU16"},{"id":"AR54","text":"OP I","parent":"BU17"},{"id":"AR55","text":"OP II","parent":"BU17"},{"id":"AR56","text":"OP III","parent":"BU17"},{"id":"AR57","text":"Medan Transmisi","parent":"BU18"}]	
3813779	Validator RD1	[{"id":"BU14","text":"RD 1","parent":"0"}]	[{"id":"AR39","text":"Jakarta","parent":"BU14"},{"id":"AR40","text":"Tangerang","parent":"BU14"},{"id":"AR41","text":"Bekasi","parent":"BU14"},{"id":"AR42","text":"Karawang","parent":"BU14"},{"id":"AR43","text":"Bogor","parent":"BU14"},{"id":"AR44","text":"Cirebon","parent":"BU14"},{"id":"AR45","text":"Palembang","parent":"BU14"},{"id":"AR46","text":"Lampung","parent":"BU14"},{"id":"AR47","text":"Cilegon","parent":"BU14"}]	
3813780	Validator RD2	[{"id":"BU15","text":"RD 2","parent":"0"}]	[{"id":"AR48","text":"Surabaya","parent":"BU15"},{"id":"AR49","text":"Sidoarjo","parent":"BU15"},{"id":"AR50","text":"Pasuruan","parent":"BU15"},{"id":"AR58","text":"Semarang","parent":"BU15"}]	
3813781	Validator RD3	[{"id":"BU16","text":"RD 3","parent":"0"}]	[{"id":"AR51","text":"Medan","parent":"BU16"},{"id":"AR52","text":"Pekan Baru","parent":"BU16"},{"id":"AR53","text":"Batam","parent":"BU16"}]	
3813782	Validator TSJ	[{"id":"BU17","text":"Transmisi SSWJ","parent":"0"}]	[{"id":"AR54","text":"OP I","parent":"BU17"},{"id":"AR55","text":"OP II","parent":"BU17"},{"id":"AR56","text":"OP III","parent":"BU17"}]	
5045262	SIPGas	[]	[{"id":"AR39","text":"Jakarta","parent":"BU14"}]	
5054372	Silfan trial	[{"id":"BU14","text":"RD 1","parent":"0"},{"id":"BU16","text":"RD 3","parent":"0"}]	[{"id":"AR39","text":"Jakarta","parent":"BU14"},{"id":"AR40","text":"Tangerang","parent":"BU14"},{"id":"AR41","text":"Bekasi","parent":"BU14"},{"id":"AR42","text":"Karawang","parent":"BU14"},{"id":"AR43","text":"Bogor","parent":"BU14"},{"id":"AR44","text":"Cirebon","parent":"BU14"},{"id":"AR45","text":"Palembang","parent":"BU14"},{"id":"AR46","text":"Lampung","parent":"BU14"},{"id":"AR47","text":"Cilegon","parent":"BU14"},{"id":"AR51","text":"Medan","parent":"BU16"},{"id":"AR52","text":"Pekan Baru","parent":"BU16"},{"id":"AR53","text":"Batam","parent":"BU16"}]	
5255700	Developer	[{"id":"BU14","text":"RD 1","parent":"0"},{"id":"BU15","text":"RD 2","parent":"0"},{"id":"BU16","text":"RD 3","parent":"0"},{"id":"BU17","text":"Transmisi SSWJ","parent":"0"}]	[{"id":"AR39","text":"Jakarta","parent":"BU14"},{"id":"AR40","text":"Tangerang","parent":"BU14"},{"id":"AR41","text":"Bekasi","parent":"BU14"},{"id":"AR42","text":"Karawang","parent":"BU14"},{"id":"AR43","text":"Bogor","parent":"BU14"},{"id":"AR44","text":"Cirebon","parent":"BU14"},{"id":"AR45","text":"Palembang","parent":"BU14"},{"id":"AR46","text":"Lampung","parent":"BU14"},{"id":"AR47","text":"Cilegon","parent":"BU14"},{"id":"AR48","text":"Surabaya","parent":"BU15"},{"id":"AR49","text":"Sidoarjo","parent":"BU15"},{"id":"AR50","text":"Pasuruan","parent":"BU15"},{"id":"AR58","text":"Semarang","parent":"BU15"},{"id":"AR51","text":"Medan","parent":"BU16"},{"id":"AR52","text":"Pekan Baru","parent":"BU16"},{"id":"AR53","text":"Batam","parent":"BU16"},{"id":"AR54","text":"OP I","parent":"BU17"},{"id":"AR55","text":"OP II","parent":"BU17"},{"id":"AR56","text":"OP III","parent":"BU17"}]	hakimgy@gmail.com
5361134	dev2	[{"id":"BU14","text":"RD 1","parent":"0"},{"id":"BU15","text":"RD 2","parent":"0"},{"id":"BU16","text":"RD 3","parent":"0"},{"id":"BU17","text":"Transmisi SSWJ","parent":"0"},{"id":"BU18","text":"Transmisi Sumut","parent":"0"}]	[{"id":"AR39","text":"Jakarta","parent":"BU14"},{"id":"AR40","text":"Tangerang","parent":"BU14"},{"id":"AR41","text":"Bekasi","parent":"BU14"},{"id":"AR42","text":"Karawang","parent":"BU14"},{"id":"AR43","text":"Bogor","parent":"BU14"},{"id":"AR44","text":"Cirebon","parent":"BU14"},{"id":"AR45","text":"Palembang","parent":"BU14"},{"id":"AR46","text":"Lampung","parent":"BU14"},{"id":"AR47","text":"Cilegon","parent":"BU14"},{"id":"AR48","text":"Surabaya","parent":"BU15"},{"id":"AR49","text":"Sidoarjo","parent":"BU15"},{"id":"AR50","text":"Pasuruan","parent":"BU15"},{"id":"AR58","text":"Semarang","parent":"BU15"},{"id":"AR51","text":"Medan","parent":"BU16"},{"id":"AR52","text":"Pekan Baru","parent":"BU16"},{"id":"AR53","text":"Batam","parent":"BU16"},{"id":"AR54","text":"OP I","parent":"BU17"},{"id":"AR55","text":"OP II","parent":"BU17"},{"id":"AR56","text":"OP III","parent":"BU17"},{"id":"AR57","text":"Medan Transmisi","parent":"BU18"}]	toni.alexandra@pgascom.co.id
5385955	revas	[{"id":"BU14","text":"RD 1","parent":"0"},{"id":"BU15","text":"RD 2","parent":"0"},{"id":"BU16","text":"RD 3","parent":"0"}]	[{"id":"AR39","text":"Jakarta","parent":"BU14"},{"id":"AR40","text":"Tangerang","parent":"BU14"},{"id":"AR41","text":"Bekasi","parent":"BU14"},{"id":"AR42","text":"Karawang","parent":"BU14"},{"id":"AR43","text":"Bogor","parent":"BU14"},{"id":"AR44","text":"Cirebon","parent":"BU14"},{"id":"AR45","text":"Palembang","parent":"BU14"},{"id":"AR46","text":"Lampung","parent":"BU14"},{"id":"AR47","text":"Cilegon","parent":"BU14"},{"id":"AR48","text":"Surabaya","parent":"BU15"},{"id":"AR49","text":"Sidoarjo","parent":"BU15"},{"id":"AR50","text":"Pasuruan","parent":"BU15"},{"id":"AR58","text":"Semarang","parent":"BU15"},{"id":"AR51","text":"Medan","parent":"BU16"},{"id":"AR52","text":"Pekan Baru","parent":"BU16"},{"id":"AR53","text":"Batam","parent":"BU16"}]	febrian.putra@pgn.co.id
6002809	Business Solution	\N	\N	
6002810	Management Solution	\N	\N	
6002811	Data Communication	\N	\N	
6002812	Data Center	\N	\N	
6002821	Sales & Marketing	\N	\N	
\.


--
-- Data for Name: iconcls; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY iconcls (id, title, clsname, icon) FROM stdin;
1	Computer	base	application_cascade.png
3	Check Password	chk-pwd	user_edit.png
4	User Female	user-female	user_female.png
6	Logout	logout	key_go.png
7	Login	login	lock_open.png
8	Lock	lock	lock.png
9	Browse	browse	grid.png
10	Config	conf	cog_edit.png
12	Refresh	drop	table_refresh.png
14	Menu Panel	mymenu	application_side_tree.png
15	Navigator	navigator	application_side_boxes.png
16	Setting	setting	application_get.png
17	Form	form	application_form.png
18	Tambah Data	add-data	add.png
19	Table Delete	table-delete	table_delete.png
20	Table Addc	table-add	table_add.png
21	Row Delete	row-delete	cancel.png
22	App Grid	app-grid	table.png
23	Form Edit	form-edit	application_form_edit.png
24	Report Mode	report-mode	report_disk.png
25	Report Pdf	report-pdf	page_white_acrobat.png
26	Report Xls	report-xls	page_white_excel.png
27	Parent Form	parent-form	vcard.png
28	Arrow Down	arrow-down	arrow_down.png
29	App Add	app-add	plugin_add.gif
30	Panel Collapse	panel-collapse	application_put.png
31	Image Add	image-add	image_add.png
32	Db Table	db-table	database_table.png
33	Db Refresh	db-refresh	database_refresh.png
34	Menu Add	menu-add	page.png
35	Sub Menu Add	submenu-add	page_add.png
36	Menu Remove	menu-remove	page_delete.png
37	Save	icon-save	disk.png
38	Accept	accept	accept.png
39	Js File	js-file	page_white_code.png
40	Php File	php-file	page_white_php.png
41	Image	image	images.png
45	Event Menu	event-menu	attach.png
48	Css Refresh	css-refresh	css_valid.png
49	Application	app	plugin.gif
50	user-manager	user-comment	user_go.png
52	error	error-cls	error.png
55	rss	rss	rss.png
61	autosave	autosave	server_link.png
62	Duplicate	duplicate	table_multiple.png
64	pindah-kk	pindah-kk	book_go.png
65	kk-baru	kk-baru	book_key.png
66	split-kk	split-kk	book_open.png
67	csv	csv	page_white_text.png
68	upload	upload	page_attach.png
69	group-manager	group-manager	group.png
70	41-TRIAL-group-delete 167	34-TRIAL-group-delete 100	269-TRIAL-group_delete.png 124
71	78-TRIAL-group-add 258	262-TRIAL-group-add 164	5-TRIAL-group_add.png 245
72	181-TRIAL-user-delete 27	61-TRIAL-user-delete 191	295-TRIAL-user_delete.gif 242
73	27-TRIAL-user-add 36	291-TRIAL-user-add 204	2-TRIAL-user_add.gif 153
74	292-TRIAL-admin-page 82	21-TRIAL-admin-page 116	218-TRIAL-cog_error.png 95
75	47-TRIAL-menu-disabled 126	71-TRIAL-check-none 138	69-TRIAL-plugin_disabled.png 112
77	167-TRIAL-statistik 199	235-TRIAL-stat 294	203-TRIAL-chart_bar.png 111
78	122-TRIAL-stat-line 33	273-TRIAL-stat-line 164	141-TRIAL-chart_curve.png 211
79	53-TRIAL-stat-pie 268	47-TRIAL-stat-pie 44	262-TRIAL-chart_pie.png 57
80	237-TRIAL-stat-bar 259	23-TRIAL-stat-bar 141	229-TRIAL-chart_bar_edit.png 178
82	16-TRIAL-stat-line2 35	290-TRIAL-stat-line2 42	288-TRIAL-chart_line.png 106
83	40-TRIAL-report-word 242	64-TRIAL-report-word 148	146-TRIAL-page_white_word.png 105
84	290-TRIAL-arr 129	70-TRIAL-arrow-up 50	6-TRIAL-arrow_up.png 201
85	93-TRIAL-sort 248	129-TRIAL-sort 23	84-TRIAL-text_padding_right.png 154
\.


--
-- Name: iconcls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('iconcls_id_seq', 85, true);


--
-- Data for Name: master_data; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY master_data (rowid, parent_id, description, type_id, create_by, create_date, update_by, update_date, name) FROM stdin;
MD2	0	Farms Wijaya	TOD2	\N	\N	\N	\N	Farms Wijaya
MD3	MD2	ALamat Kandang 1	TOD3	\N	\N	\N	\N	Kandang 1
MD4	MD2	Alamat Kandang 2	TOD3	\N	\N	\N	\N	Kandang 2
MD5	MD2	Alamat Kandang 3	TOD3	\N	\N	\N	\N	Kandang 3
MD6	MD2	Alamat Kandang 4	TOD3	\N	\N	\N	\N	Kandang 4
MD7	0	Abtibiotik	TOD9	\N	\N	\N	\N	Anti Biotik
MD8	MD7	Respirex	TOD9	\N	\N	\N	\N	Respirex
MD9	MD2	Penganggung Jawab Kandang	TOD13	\N	\N	\N	\N	Penanggung Jawab Kandang
MD10	MD7	coccirex	TOD9	\N	\N	\N	\N	coccirex
MD11	MD7	Medoxy LA	TOD9	\N	\N	\N	\N	Medoxy LA
MD12	MD7	Veta Moxyne	TOD9	\N	\N	\N	\N	Veta Moxyne
MD13	MD7	Flumed	TOD9	\N	\N	\N	\N	Flumed
MD14	0	VITAMIN	TOD7	\N	\N	\N	\N	VITAMIN
MD15	MD14	Veta Doc	TOD7	\N	\N	\N	\N	Veta Doc
MD16	MD14	Bedgen	TOD7	\N	\N	\N	\N	Bedgen
MD17	MD14	Neobro	TOD7	\N	\N	\N	\N	Neobro
MD18	MD14	multicold	TOD7	\N	\N	\N	\N	multicold
MD19	MD14	Counter stress	TOD7	\N	\N	\N	\N	Counter stress
MD20	MD14	Vitamin C	TOD7	\N	\N	\N	\N	Vitamin C
MD21	0	Desinfektan	TOD8	\N	\N	\N	\N	Desinfektan
MD22	MD21	Formades	TOD8	\N	\N	\N	\N	Formades
MD23	MD21	Neo Antisep	TOD8	\N	\N	\N	\N	Neo Antisep
MD24	MD21	Destan	TOD8	\N	\N	\N	\N	Destan
MD25	MD21	Fumital	TOD8	\N	\N	\N	\N	Fumital
MD26	MD21	Formades	TOD8	\N	\N	\N	\N	Formades
MD27	MD21	Neo antisep	TOD8	\N	\N	\N	\N	Neo antisep
MD28	MD21	Antigermen	TOD8	\N	\N	\N	\N	Antigermen
MD29	MD21	Veta Flygen	TOD8	\N	\N	\N	\N	Veta Flygen
MD30	MD21	Fumital	TOD8	\N	\N	\N	\N	Fumital
MD31	MD21	Peroksida	TOD8	\N	\N	\N	\N	Peroksida
MD32	MD21	Kaporit	TOD8	\N	\N	\N	\N	Kaporit
MD33	0	Status Transaksi	TOD17	\N	\N	\N	\N	IN
MD34	0	Status Transaksi	TOD17	\N	\N	\N	\N	Out
MD35	0		TOD19	\N	\N	\N	\N	Hidup
MD36	0		TOD19	\N	\N	\N	\N	Afkir
MD37	0		TOD19	\N	\N	\N	\N	Mati
MD38	0	Vaksin	TOD6	\N	\N	\N	\N	Vaksin
MD39	MD38	Nectin Kill	TOD6	\N	\N	\N	\N	Nectin Kill
MD40	MD38	ND IB 2000 DS	TOD6	\N	\N	\N	\N	ND IB 2000 DS
MD41	MD38	Gumboro 2000 ds	TOD6	\N	\N	\N	\N	Gumboro 2000 ds
MD42	MD38	Diluent	TOD6	\N	\N	\N	\N	Diluent
MD43	MD38	Susu skim	TOD6	\N	\N	\N	\N	Susu skim
MD44	MD38	ND CLONE 1000	TOD6	\N	\N	\N	\N	ND CLONE 1000
MD45	0	Gram 	TOD16	\N	\N	\N	\N	Gram
MD46	0	Kilogram	TOD16	\N	\N	\N	\N	KG
MD47	0	Microliter 	TOD16	\N	\N	\N	\N	µL
MD48	0	Box	TOD16	\N	\N	\N	\N	BOX
MD49	0	Ayam Bolier Kudus	TOD21	\N	\N	\N	\N	Ayam Bolier Kudus
MD50		Angkatan 1	TOD22	\N	\N	\N	\N	A1
MD51		Angkatan 2	TOD22	\N	\N	\N	\N	A2
MD52		Angkatan 3	TOD22	\N	\N	\N	\N	A3
MD53		Angkatan 4	TOD22	\N	\N	\N	\N	A4
MD54		Angkatan 5	TOD22	\N	\N	\N	\N	A5
MD55		UOM	TOD16	\N	\N	\N	\N	Uom
MD56		Status Active	TOD23	\N	\N	\N	\N	Active
MD57		Status Inactive	TOD23	\N	\N	\N	\N	Inactive
MD58		Supplier	TOD24	\N	\N	\N	\N	Supplier
MD59		Pelanggan	TOD24	\N	\N	\N	\N	Pelanggan
MD60		Partner	TOD24	\N	\N	\N	\N	Partner
MD61		Pakan	TOD5	\N	\N	\N	\N	Pakan
MD62		Active	TOD25	\N	\N	\N	\N	Active
MD63		Close	TOD25	\N	\N	\N	\N	Close
\.


--
-- Name: master_data_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('master_data_user_id_seq', 63, true);


--
-- Data for Name: menu; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY menu (idmenu, name, act, parent, sort, iconcls, path, leaf, hide) FROM stdin;
115321	User Previllage	groupPermission	7	2	magnifier	asset/js/content/setting/grouppermission.js	false	0
3514361	Log Data Event	logdataevent	3208980	\N	application_delete	asset/js/content/analisa/bulk/logdatareject.js	FALSE	0
3728990	Profiling	profilingamr	115322	9	chart_curve	asset/js/content/analisa/profilingamr.js	FALSE	0
5563314	testgrid		5337986	\N	application_form_add	asset/js/content/master/testgrid.js	FALSE	0
6000001	Create Form	createform	5337986	\N		asset/js/content/master/createform.js	FALSE	0
6000022	create_layout		5337986	\N	application_form_add	asset/js/content/master/layout.js	FALSE	0
6002635	Jabatan	cog_go	6002634	\N	cog_add	asset/js/content/disaster/master/jabatan.js	FALSE	0
6002636	Employee	-	6002634	\N	cog_go	asset/js/content/disaster/master/employee.js	FALSE	0
6002663	Create Program	createprogram	6002650	\N	computer_go	asset/js/content/disaster/createprogram.js	FALSE	0
6002686	Broadcast Message	bmessage	6002650	\N	monitor_lightning	asset/js/content/disaster/broadcastmessage.js	FALSE	0
6002701	Reply Message	replymessage	6002650	\N	arrow_refresh	asset/js/content/disaster/replymessage.js	FALSE	0
6002702	Forward Message	replymessage	6002650	\N	computer_go	asset/js/content/disaster/forwardmessage.js	FALSE	0
6002703	Need Help	needhelp	6002650	\N	computer_error	asset/js/content/disaster/help.js	FALSE	0
6002788	View Progress		6002786	\N		asset/js/content/project_monitoring/viewprogress.js	FALSE	0
6002828	Jenis Data Transaksi		6002827	\N	application_form_edit	asset/js/content/syfa/master/typedata.js	FALSE	0
6002864	Kandang	kandang	6002827	\N	page_gear	asset/js/content/syfa/master/kandang.js	FALSE	0
3505082	Email Template	emailtemplate	1	3	email_link	asset/js/content/masterdata/emailtemplate.js	FALSE	0
3505083	Column Alias	columnalias	1	3	tag_blue	asset/js/content/masterdata/columnalias.js	FALSE	0
7	Setting Configuration	\N	0	2	application_view_list	\N	FALSE	0
6002824	Transaction	\N	0	1	monitor	\N	\N	0
6002923	farms	farms	6002827	\N	vcard	asset/js/content/syfa/master/farms.js	FALSE	0
6002945	Antibiotik	antibiotik	6002827	\N	heart_add	asset/js/content/syfa/master/antibiotik.js	FALSE	0
6002946	Vitamin	vit	6002827	\N	ipod_cast_add	asset/js/content/syfa/master/vitamin.js	FALSE	0
6002947	Desinfektan	vit	6002827	\N	ipod_cast_add	asset/js/content/syfa/master/desinfektan.js	FALSE	0
6002948	Vaksin	vit	6002827	\N	ipod_cast_add	asset/js/content/syfa/master/vaksin.js	FALSE	0
6003025	Konversi Berat	konversiberat	6002827	\N	wrench_orange	asset/js/content/syfa/master/konversiberat.js	FALSE	0
6003077	Inventory	inv	0	\N	table_sort		FALSE	0
6002825	DOC 	\N	6002824	1	monitor_edit	asset/js/content/syfa/production/list_docayam.js	\N	0
6002901	Pengembangan Ayam	pengembanganayam	6002824	2	transmit_add	asset/js/content/syfa/production/pengembangan.js	FALSE	0
1	Master Data		0	\N	maintenence	\N	FALSE	0
6	Mapping Data	\N	0	\N	application_view_icons	\N	FALSE	0
8	Evaluasi	\N	0	\N	application_view_gallery	\N	FALSE	0
9	Analisa	\N	0	\N	chart_bar	\N	FALSE	0
115320	Settings	\N	0	\N	cog	\N	FALSE	1
3729044	Monitoring		0	\N	computer_link		FALSE	0
6002634	Organisasi	organisasi	0	\N	cog_add	asset/js/content/disaster/master/organisasi.js	FALSE	0
6002650	SMS Disaster	sms_disaster	0	\N	computer_add		FALSE	0
6002786	Project Monitoring		0	\N	computer_link		FALSE	0
5337986	Sample	\N	0	\N	tag_blue	\N	\N	0
6002827	Master Data	masterdata	0	\N	application_home		FALSE	0
6003078	Item Master	itemsmaster	6003077	\N	table_link	asset/js/content/syfa/inventory/itemmaster.js	FALSE	0
6003079	Item Receipt	receipt	6003077	\N	table_go	asset/js/content/syfa/inventory/itemreceipt.js	FALSE	0
6003080	Item Transfer	receipt	6003077	\N	table_go	asset/js/content/syfa/inventory/itemtransfer.js	FALSE	0
6003081	Item Out	receipt	6003077	\N	table_go	asset/js/content/syfa/inventory/itemout.js	FALSE	0
\.


--
-- Data for Name: menu_event; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY menu_event (id, menu_id, event_name) FROM stdin;
\.


--
-- Name: menu_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('menu_event_id_seq', 1, false);


--
-- Name: message; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('message', 118, true);


--
-- Data for Name: ms_attribute; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY ms_attribute (rowid, typeofdataid, name, description, data_type) FROM stdin;
ATR1	TOD3	pic	pic Kandang dan farms	varchar
ATR2	TOD3	address	Alamat kandang farms	varchar
\.


--
-- Data for Name: ms_autoreply; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY ms_autoreply (rowid, programid, value, alias, "desc", create_by, create_date, update_by, update_date) FROM stdin;
RPLY6002684	PRG4	1	Saya baik-baik saja	Saya baik-baik saja	\N	\N	\N	\N
RPLY6002685	PRG4	2	Saya membutuhkan bantuan 	Saya membutuhkan bantuan 	\N	\N	\N	\N
\.


--
-- Data for Name: ms_employee; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY ms_employee (rowid, nipg, nama_karyawan, email, phone, job_pos, satker, create_date) FROM stdin;
EMP6001275	J20160015	Danny  Praditya	Danny.Praditya@pgn.co.id		ORG6000037	SATKER6001207	20171204103705
EMP6001276	0012632740	Nusantara  Suyono	nusky.suyono@pgn.co.id	08111990923	ORG6000036	SATKER6001208	20171204103705
EMP6001277	2002821869	Emil  Sugiarto	Emil.Sugiarto@pgn.co.id		ORG6000387	SATKER6001209	20171204103705
EMP6001278	0017962794	Abimata Anjaya Tirta	Abimata.Tirta@pgn.co.id			SATKER6001210	20171204103705
EMP6001279	1092681482	Gugun  Satmoko	Gugun.Satmoko@pgn.co.id	081318466600	ORG6000872	SATKER6001211	20171204103705
EMP6001280	0013912746	M. Fatah Yasin	Fatah.Yasin@pgn.co.id	0811007882491	ORG6000993	SATKER6001212	20171204103705
EMP6001281	0015942773	Madarina  Sabila	Madarina.Sabila@pgn.co.id		ORG6000794	SATKER6001213	20171204103705
EMP6001282	0017962797	Widiyanto  Nugroho	Widiyanto.Nugroho@pgn.co.id	082226257430		SATKER6001210	20171204103705
EMP6001283	2002831872	Freddy  Setiawan	Freddy.Setiawan@pgn.co.id		ORG6000466	SATKER6001214	20171204103705
EMP6001284	3007852249	Umam  Prabowo	Umam.Prabowo@pgn.co.id		ORG6001087	SATKER6001215	20171204103705
EMP6001285	0016952785	Muhammad Rizky Pradana	Muhammad.Pradana@pgn.co.id		ORG6000983	SATKER6001216	20171204103705
EMP6001286	0016952787	Sinatrya Dwika Alvino	Sinatrya.Alvino@pgn.co.id		ORG6000984	SATKER6001216	20171204103705
EMP6001287	1007832253	  Nurlelasari	Nurlelasari@pgn.co.id		ORG6000358	SATKER6001217	20171204103705
EMP6001288	0088641151	Endang  Suhanda	Endang.Suhanda@pgn.co.id	081272764724	ORG6001102	SATKER6001218	20171204103705
EMP6001289	1587641131	Ujang  Ishak	Ujang.Ishak@pgn.co.id		ORG6000816	SATKER6001218	20171204103705
EMP6001290	1007882256	R Vanni Aprilia	R.Vanni.Aprillia@pgn.co.id		ORG6001057	SATKER6001219	20171204103705
EMP6001291	3004811992	Pitria  Romadhon	Pitria.Romadhon@pgn.co.id	085277774599	ORG6000618	SATKER6001220	20171204103705
EMP6001292	1089651317	  Nahrowi	Nahrowi@pgn.co.id		ORG6001184	SATKER6001218	20171204103705
EMP6001293	0014932761	Annisaa Putri Citrawati	Annisaa.Citrawati@pgn.co.id		ORG6000194	SATKER6001221	20171204103705
EMP6001294	0010862591	Erna  Budhiarti	erna.budhiarti@pgn.co.id		ORG6000814	SATKER6001218	20171204103705
EMP6001295	0015942778	Nur Falah Hani Qomariyah	Nur.Qomariyah@pgn.co.id		ORG6000681	SATKER6001209	20171204103705
EMP6001296	0010862580	Febrian Nur Ardiwinata	Febrian.Ardiwinata@pgn.co.id	08113637827	ORG6000759	SATKER6001222	20171204103705
EMP6001297	2095721558	Ichwan  Fauzi	Ichwan.Fauzi@pgn.co.id	0811354885	ORG6000765	SATKER6001222	20171204103705
EMP6001298	0016942782	Dwi Putra Budhi Setia	Dwi.Setia@pgn.co.id		ORG6000980	SATKER6001216	20171204103705
EMP6001299	0010842549	Aan  Fatoni	Aan.Fatoni@pgn.co.id		ORG6000578	SATKER6001211	20171204103705
EMP6001300	0011902632	Prabandaru Cahyo Anggoro	Prabandaru@pgn.co.id		ORG6000668	SATKER6001213	20171204103705
EMP6001301	1092671472	Harry  Safari	Harry.Safary@pgn.co.id	08128179276	ORG6000268	SATKER6001223	20171204103705
EMP6001302	1085621001	Canisius  Nay	Canisius.Nay@pgn.co.id		ORG6000220	SATKER6001224	20171204103705
EMP6001303	1008862362	Rd. Yusman  Wismarna	Yusman.Wismarna@pgn.co.id		ORG6000247	SATKER6001225	20171204103705
EMP6001304	0089641396	  Saji	Saji@pgn.co.id		ORG6000280	SATKER6001226	20171204103705
EMP6001305	2001791847	Nito  Rahmadi	Nito.Rahmadi@pgn.co.id		ORG6000843	SATKER6001227	20171204103705
EMP6001306	0010872468	Aldo  Marino	Aldo.Marino@pgn.co.id	089675947222	ORG6000322	SATKER6001228	20171204103705
EMP6001307	1092641464	Erwin  Noor	Erwin.Noor@pgn.co.id		ORG6000695	SATKER6001219	20171204103705
EMP6001308	2004842019	Heru  Prasetiyo	Heru.Prasetiyo@pgn.co.id	08113538077	ORG6000474	SATKER6001229	20171204103705
EMP6001309	2095641547	Budiarto  Isnaeni	Budiarto.Isnaeni@pgn.co.id			SATKER6001218	20171204103705
EMP6001310	0006812179	Adi  Munandir	Adi.Munandir@pgn.co.id	08182017290	ORG6000133	SATKER6001230	20171204103705
EMP6001311	0088631254	Manangap  Napitupulu	m.napit@pgn.co.id	473762	ORG6000997	SATKER6001231	20171204103705
EMP6001312	0097701697	Timbul Duffy Bernardinus Aritonang	Timbul.Aritonang@pgn.co.id	021-82490785	ORG6001161	SATKER6001211	20171204103705
EMP6001313	0004811975	Wahyu  Nurhayanti	Wahyu.Nurhayati@pgn.co.id	08118408574	ORG6000942	SATKER6001211	20171204103705
EMP6001314	0004801946	Rosa Permata Sari	Rosa.Sari@pgn.co.id	0811.8701214	ORG6000063	SATKER6001211	20171204103705
EMP6001315	0003771897	Desy Anggia Wulandari	desy.anggia@pgn.co.id	08118709119	ORG6000475	SATKER6001232	20171204103705
EMP6001316	0001751813	Emung  Indriastanto	Emung.Indriastanto@pgn.co.id	0217828067	ORG6000611	SATKER6001220	20171204103705
EMP6001317	0001751815	Limar Suci Rahayu	Limar.Rahayu@pgn.co.id	081315819834	ORG6000198	SATKER6001217	20171204103705
EMP6001318	1583630940	  Rahayu	Rahayu@pgn.co.id	0251-8431387	ORG6000070	SATKER6001211	20171204103705
EMP6001319	0012662727	Nisi  Setyobudi	nisi.setyobudi@pgn.co.id	08118109916	ORG6000518	SATKER6001233	20171204103705
EMP6001320	0088621245	Kris  Handono	Kris.Handono@pgn.co.id	08812154040	ORG6000821	SATKER6001213	20171204103705
EMP6001321	0092651491	Ibnu  Azka	Ibnu.Azka@pgn.co.id	081514263339	ORG6000724	SATKER6001234	20171204103705
EMP6001322	0094641518	  Suranta	Suranta@pgn.co.id	82405455	ORG6000071	SATKER6001211	20171204103705
EMP6001323	0004791934	Nazlya Intan Sari	Nazlya.Sari@pgn.co.id	081381069800	ORG6000639	SATKER6001219	20171204103705
EMP6001324	0087641079	  Nismawati	Nismawati@pgn.co.id	02182732709	ORG6000301	SATKER6001235	20171204103705
EMP6001325	0010872529	Leony  Wesvalia	Leony.Wesvalia@pgn.co.id	08118000421	ORG6000649	SATKER6001236	20171204103705
EMP6001326	1008812347	  Suprayogi	Suprayogi@pgn.co.id	08156129855	ORG6000241	SATKER6001237	20171204103705
EMP6001327	3097741714	  Marlina	Marlina@pgn.co.id	0811653334	ORG6000363	SATKER6001213	20171204103705
EMP6001328	0012912734	Pharamayuda Bayu Wicaksono	Pharamayuda.Wicaksono@pgn.co.id	081225651552	ORG6000192	SATKER6001223	20171204103705
EMP6001329	0005822153	Asep  Herlambang	Asep.Herlambang@pgn.co.id	08818199929	ORG6000215	SATKER6001238	20171204103705
EMP6001330	0004801944	Weny Ayu Hapsari	weny.ayu@pgn.co.id	081513183909	ORG6001054	SATKER6001239	20171204103705
EMP6001331	0088651266	Amy  Dalifah	Amy.Dalifah@pgn.co.id	0214240369	ORG6000485	SATKER6001240	20171204103705
EMP6001332	0099721769	Rezki  Anindhito	Rezki.Anindhito@pgn.co.id	0217533664	ORG6000895		20171204103705
EMP6001333	0097701690	Hendri  Joniansyah	Hendri.Joniansyah@pgn.co.id	081514803805	ORG6001110		20171204103705
EMP6001391	0010862519	Rangga Yadi Putra	Rangga.Putra@pgn.co.id		ORG6000970	SATKER6001234	20171204103705
EMP6001334	0098731736	Tri Setyo Utomo	Tri.Utomo@pgn.co.id	0815.3750.3332	ORG6001150	SATKER6001211	20171204103705
EMP6001335	0010872460	Muhammad Subhan Missuari	Subhan.Missuari@pgn.co.id	081514018787	ORG6001084	SATKER6001243	20171204103705
EMP6001336	0087651080	Endang  Murtiani	Endang.Murtiani@pgn.co.id	08129965871	ORG6000297	SATKER6001235	20171204103705
EMP6001337	0092661446	Wawan Syarif Ridwan	Wawan.Ridwan@pgn.co.id	6281511989422	ORG6000298	SATKER6001235	20171204103705
EMP6001338	0010862520	Shabhi  Mahmashani	Shabhi.Mahmashani@pgn.co.id	081328177396	ORG6000453	SATKER6001214	20171204103705
EMP6001339	0010842506	Puji  Arman	Puji.Arman@pgn.co.id	0819898788	ORG6001012	SATKER6001211	20171204103705
EMP6001340	0005832159	Febry Komala Uli	Febry.Uli@pgn.co.id	021-7776361	ORG6000862	SATKER6001211	20171204103705
EMP6001341	0010872459	Chandra  Warman	Chandra.Warman@pgn.co.id	081387061861	ORG6000397	SATKER6001209	20171204103705
EMP6001342	0010862443	Kristophorus Kanaprio Ola	Kristophorus.Kanaprio@pgn.co.id	08113541210	ORG6000409	SATKER6001244	20171204103705
EMP6001343	1087651107	Selviana Iriani Muchtar	Selviana.Mukhtar@pgn.co.id	001	ORG6000256	SATKER6001223	20171204103705
EMP6001344	1087651106	Dwi Prawanti Nina Wulan	Dwi.Wulan@pgn.co.id	08121047729	ORG6000219	SATKER6001224	20171204103705
EMP6001345	1087651109	Nur  Inayati	Nur.Inayati@pgn.co.id	08129846584	ORG6000263	SATKER6001226	20171204103705
EMP6001346	0005822144	Retno  Kusumaningrum	Retno.Kusumaningrum@pgn.co.id	08179573550	ORG6000295	SATKER6001213	20171204103705
EMP6001347	1687651132	  Satori	Satori@pgn.co.id	081222102040	ORG6000197	SATKER6001245	20171204103705
EMP6001348	0088661162	Jana  Budiyana	Jana.Budiyana@pgn.co.id	08158718766	ORG6001059	SATKER6001218	20171204103705
EMP6001349	0005802127	Agus  Kurniawan	Agus.Kurniawan@pgn.co.id	081321612444	ORG6000340	SATKER6001246	20171204103705
EMP6001350	0094671532	Harry  Ruswandi	Harry.Ruswandi@pgn.co.id	08119310645	ORG6001151	SATKER6001211	20171204103705
EMP6001351	0010832408	Murdani  Wijaya	Murdani.Wijaya@pgn.co.id	081510500745	ORG6000956	SATKER6001218	20171204103705
EMP6001352	0010852511	Rahadyan Kusumo Syailendra	Rahadyan.Syailendra@pgn.co.id	081328700656	ORG6001091	SATKER6001218	20171204103705
EMP6001353	4821948	  Heriansyah	Heriansyah@pgn.co.id		ORG6000336	SATKER6001230	20171204103705
EMP6001354	0014862767	Mahesa Krishna Raditya	Mahesa.Raditya@pgn.co.id	081804280050	ORG6000722	SATKER6001247	20171204103705
EMP6001355	0010812405	Ade  Subhan	Ade.Subhan@pgn.co.id	0214253029	ORG6001165	SATKER6001211	20171204103705
EMP6001356	0005812089	Eka  Subandriani	Eka.Subandriani@pgn.co.id	08111987009	ORG6000739	SATKER6001234	20171204103705
EMP6001357	0010852514	Luki Rachimi Adiati	Luki.Rachimi@pgn.co.id		ORG6000103	SATKER6001211	20171204103705
EMP6001358	0010862578	Fuad  Hamzah	Fuad.Hamzah@pgn.co.id	08111106247	ORG6000965	SATKER6001234	20171204103705
EMP6001359	0010882609	Michael Edigia Wizard	Michael.Edigia@pgn.co.id	08113464988	ORG6000757	SATKER6001222	20171204103705
EMP6001360	0007882272	Wahyu Dwiagasta Wibowo	Wahyu.Wibowo@pgn.co.id	0812 8446 8591	ORG6000705	SATKER6001234	20171204103705
EMP6001361	0005832162	Widya Kurnia Puteri	Widya.Puteri@pgn.co.id	08111484523	ORG6000260	SATKER6001226	20171204103705
EMP6001362	1088651190	  Sugiarto	Sugiarto.11902@pgn.co.id	08117293323	ORG6000239	SATKER6001237	20171204103705
EMP6001363	3086621066	  Mukhrin	Mukhrin@pgn.co.id	82160360091	ORG6000314	SATKER6001215	20171204103705
EMP6001364	0010832548	Markus  Aditya	Markus.Aditya@pgn.co.id		ORG6000476	SATKER6001248	20171204103705
EMP6001365	1007832218	Sulchan  Fadholi	Sulchan.Fadholi@pgn.co.id	081575246834	ORG6000565	SATKER6001249	20171204103705
EMP6001366	2096731677	Endang Sri Rahayu	Endang.Rahayu@pgn.co.id	0811348191	ORG6001191	SATKER6001211	20171204103705
EMP6001367	0005822149	Faisal  Arief	Faisal.Arief@pgn.co.id	08113536925	ORG6000914	SATKER6001250	20171204103705
EMP6001368	0010832546	Agus  Cucu	Agus.Cucu@pgn.co.id	0812874296090	ORG6001138	SATKER6001251	20171204103705
EMP6001369	0004732002	  Siswanto	Siswanto@pgn.co.id	021-26063511	ORG6000538	SATKER6001252	20171204103705
EMP6001370	0010862442	Aditya Eka Wijaya	Aditya.Eka@pgn.co.id	81802795258	ORG6000987	SATKER6001234	20171204103705
EMP6001371	0007872263	Didin  Afandi	Didin.Afandi@pgn.co.id	021.27598761	ORG6000150	SATKER6001253	20171204103705
EMP6001372	0010862626	Fajar  Rahman	Fajar.Rahman@pgn.co.id	0811 9159 991	ORG6000151	SATKER6001253	20171204103705
EMP6001373	0007802283	Bimala  Augustryani	Bimala.Augustryani@pgn.co.id	758882	ORG6000557	SATKER6001254	20171204103705
EMP6001374	0003801913	Dini  Mentari	Dini.Mentari@pgn.co.id	000217522042	ORG6000243	SATKER6001223	20171204103705
EMP6001375	2099771756	Ria Sari Yulianti	Ria.Yulianti@pgn.co.id	0811375030	ORG6000269	SATKER6001255	20171204103705
EMP6001376	0098711733	Ista  Andayani	Ista.Andayani@pgn.co.id	0816930878	ORG6000497	SATKER6001256	20171204103705
EMP6001377	2096721674	  Hamalsyahan	Hamalsyahan@pgn.co.id	00811333231	ORG6001058	SATKER6001238	20171204103705
EMP6001378	0004781928	  Subandi	Subandi@pgn.co.id	0815064655329	ORG6000443	SATKER6001251	20171204103705
EMP6001379	0094691540	  Sularti	Sularti@pgn.co.id	021-53157752	ORG6000860	SATKER6001211	20171204103705
EMP6001380	0095731588	  Machmudin	Machmudin@pgn.co.id	081380455472	ORG6000437	SATKER6001218	20171204103705
EMP6001381	1588641277	Gito  Prayitno	Gito.Prayitno@pgn.co.id	08111557338	ORG6000434	SATKER6001218	20171204103705
EMP6001382	3097731713	Taufik  Barus	Taufik.Barus@pgn.co.id	08117104496	ORG6000995	SATKER6001252	20171204103705
EMP6001383	2099761748	  Sukiswanto	Sukiswanto@pgn.co.id	08123272818	ORG6000750	SATKER6001234	20171204103705
EMP6001384	1096731609	Ifan  Hendriawan	Ifan.Hendriawan@pgn.co.id	9780 301	ORG6001038	SATKER6001211	20171204103705
EMP6001385	0001771839	Pahala  Baringbing	Pahala.Baringbing@pgn.co.id	021 84901090	ORG6000890	SATKER6001211	20171204103705
EMP6001386	2099771754	Hadi Sucipto Kusuma	Hadi.Kusuma@pgn.co.id	08123231650	ORG6001060	SATKER6001218	20171204103705
EMP6001387	3089611283	  Sutrisno	Sutrisno@pgn.co.id	0618456985	ORG6000305	SATKER6001215	20171204103705
EMP6001388	0005802126	Rusdi  Tommy	Rusdi.Tommy@pgn.co.id	081289225433	ORG6000146	SATKER6001253	20171204103705
EMP6001389	3097771725	Syafran  Siregar	Syafran.Siregar@pgn.co.id	0816880177	ORG6000115	SATKER6001211	20171204103705
EMP6001390	0012852660	Baroqah Anton Sulaiman	Baroqah.Sulaiman@pgn.co.id	081327395196	ORG6000113	SATKER6001211	20171204103705
EMP6001392	0010822498	Anik Rurin Purwaningsih	Anik.Rurin@pgn.co.id	081517156394	ORG6001007	SATKER6001211	20171204103705
EMP6001393	0096681630	Samtoner  Tamba	Samtoner.Tamba@pgn.co.id	08158868510	ORG6000666	SATKER6001208	20171204103705
EMP6001394	0089621331	Doddy  Adianto	Doddy.Adianto@pgn.co.id	0815.1103.9200		SATKER6001257	20171204103705
EMP6001395	0094681534	  Yosviandri	Yosviandri@pgn.co.id	021802307010		SATKER6001258	20171204103705
EMP6001396	0001731807	  Ariadi	Ariadi@pgn.co.id	85918858		SATKER6001259	20171204103705
EMP6001397	0099761799	Jeffry Hotman Simanjuntak	jeffry.hotman@pgn.co.id	081-10016654		SATKER6001260	20171204103705
EMP6001398	0005802083	Cecep Yudi Subiantoro	Cecep.Subiantoro@pgn.co.id	081325638486		SATKER6001251	20171204103705
EMP6001399	0098701731	  Nofrizal	Nofrizal@pgn.co.id				20171204103705
EMP6001400	0099751791	Adhi Lingga Harymurti	Adhi.Harymurti@pgn.co.id	0302081601101228442195		SATKER6001262	20171204103705
EMP6001401	0099761798	Adhi  Nugroho	adhi.nugroho@pgn.co.id			SATKER6001263	20171204103705
EMP6001402	0099761803	  Zulfahmi	Zulfahmi@pgn.co.id	0215462843		SATKER6001264	20171204103705
EMP6001403	3097781727	Ris  Haryono	Ris.Haryono@pgn.co.id	081377078444		SATKER6001216	20171204103705
EMP6001404	0004781959	Femin  Puspitasari	femin.puspitasari@pgn.co.id	081316517539		SATKER6001265	20171204103705
EMP6001405	0007842315	Insan  Kamil	Insan.Kamil@pgn.co.id	00811816040		SATKER6001266	20171204103705
EMP6001406	0095711583	Aris Lolon Rian	aris.lolon@pgn.co.id	08158102781		SATKER6001211	20171204103705
EMP6001407	2087621090	  Sumidjan	Sumidjan@pgn.co.id	08123.0440062		SATKER6001239	20171204103705
EMP6001408	3089681307	Hidayani  Agustina	Hidayani.Agustina@pgn.co.id	111213103308		SATKER6001217	20171204103705
EMP6001409	0003811915	Suluh Widyo Laksono	suluh.laksono@pgn.co.id			SATKER6001263	20171204103705
EMP6001410	0007852329	Yusron  Firmansyah	Yusron.Firmansyah@pgn.co.id	081310068193		SATKER6001239	20171204103705
EMP6001411	0089621338	Sri  Supriyantini	Sri.Supriyantini@pgn.co.id			SATKER6001267	20171204103705
EMP6001412	3089671376	  Sumadi	Sumadi@pgn.co.id	081265609932		SATKER6001239	20171204103705
EMP6001413	3097721709	Victor Sahala Marnaek Manurung	Victor.Manurung@pgn.co.id	00618365666		SATKER6001268	20171204103705
EMP6001414	0010842502	A. Azis Kurniawan	Azis.Kurniawan@pgn.co.id			SATKER6001269	20171204103705
EMP6001415	0007832300	Akhmad  Afandi	Akhmad.Afandi@pgn.co.id	08117206633		SATKER6001239	20171204103705
EMP6001416	0009872400	Arnal  Diansah	Arnal.Diansah@pgn.co.id	08117814900		SATKER6001239	20171204103705
EMP6001417	0092681449	Rudi  Handoko	Rudi.Handoko@pgn.co.id			SATKER6001270	20171204103705
EMP6001418	1007832220	Edi  Hidayat	Edi.Hidayat@pgn.co.id	08116154545		SATKER6001271	20171204103705
EMP6001419	1008842356	Rully Andrians R.	Rully.Adrians@pgn.co.id			SATKER6001272	20171204103705
EMP6001420	1588631274	  Fachrudin	Fachrudin@pgn.co.id			SATKER6001239	20171204103705
EMP6001421	3089671305	Kamarussaman  Nasution	Kamarussaman.Nasution@pgn.co.id	0081375397580		SATKER6001238	20171204103705
EMP6001422	0011902637	Lindra Aulia Rachman	Lindra.Aulia@pgn.co.id			SATKER6001239	20171204103705
EMP6001423	0010862483	Eka Ardianta Sembiring	Eka.Ardianta@pgn.co.id			SATKER6001239	20171204103705
EMP6001424	0014932760	Gilang Pratama Putra	Gilang.Putra@pgn.co.id			SATKER6001239	20171204103705
EMP6001425	0096671665	  Sukemi	Sukemi@pgn.co.id			SATKER6001218	20171204103705
EMP6001426	1088631182	Dwi Topan Irianto	Dwi.Iriyanto@pgn.co.id			SATKER6001239	20171204103705
EMP6001427	2584620954	  Darmadi	Darmadi@pgn.co.id			SATKER6001239	20171204103705
EMP6001428	3086641071	  Resdianto	Resdianto@pgn.co.id			SATKER6001239	20171204103705
EMP6001429	0009852391	Luthfianto Ardhi Nugroho	Luthfianto.Nugroho@pgn.co.id			SATKER6001273	20171204103705
EMP6001430	0012752641	Melki Escola Ambarita	Melki.Ambarita@pgn.co.id			SATKER6001239	20171204103705
EMP6001431	1088641183	Binuril  Mustofa	Binuril.Mustofa@pgn.co.id			SATKER6001239	20171204103705
EMP6001432	1088661191	  Umdana	Umdana@pgn.co.id			SATKER6001239	20171204103705
EMP6001433	1092671473	Erman  Susilo	Erman.Susilo@pgn.co.id			SATKER6001239	20171204103705
EMP6001434	1092641462	  Jumadi	Jumadi@pgn.co.id	0218255282		SATKER6001218	20171204103705
EMP6001435	0004811977	Aris  Hartono	aris.hartono@pgn.co.id	08121049150	ORG6000145	SATKER6001253	20171204103705
EMP6001436	0088641262	Jobi Triananda Hasjim					20171204103705
EMP6001437	J20160016	Dilo Seno Widagdo	dilo.seno@pgn.co.id		ORG6000040		20171204103705
EMP6001438	0012892704	Azhari Ramdhani Sambas	Azhari.Sambas@pgn.co.id	087718529101	ORG6001037	SATKER6001211	20171204103705
EMP6001439	0017962793	Yunanta Rievo Yudhawan	Yunanta.Yudhawan@pgn.co.id			SATKER6001210	20171204103705
EMP6001440	0017952789	M. Adhenhari  Musfaro	M.Adhenhari.Musfaro@pgn.co.id		ORG6001201	SATKER6001210	20171204103705
EMP6001441	0010872604	Mira  Yusmita	Mira.Yusmita@pgn.co.id		ORG6000828	SATKER6001213	20171204103705
EMP6001442	1092671474	Rifca  Delywera	Rifca.Delywera@pgn.co.id		ORG6000867	SATKER6001211	20171204103705
EMP6001443	0012912730	Aulia Nuraini Kusumadewi	Aulia.Kusumadewi@pgn.co.id		ORG6000236	SATKER6001224	20171204103705
EMP6001444	0010882476	Galih  Pranasetya	Galih.Pranasetya@pgn.co.id		ORG6000291	SATKER6001226	20171204103705
EMP6001445	0012912736	Fajar Wahyu Wardani	Fajar.Wardani@pgn.co.id		ORG6000303	SATKER6001235	20171204103705
EMP6001446	0016942781	Kretyowiweko Husnu Hidayatulloh	Kretyowiweko.HH@pgn.co.id		ORG6000977	SATKER6001216	20171204103705
EMP6001447	2002831871	Reni Nur Anggraeni	Reni.Anggraeni@pgn.co.id		ORG6000283	SATKER6001255	20171204103705
EMP6001448	2007872261	Indria Swesti Wardhani	indria.wardhani@pgn.co.id		ORG6000311		20171204103705
EMP6001449	3004781982	Hamidah  Armaini	Hamidah.Armaini@pgn.co.id		ORG6000365		20171204103705
EMP6001450	0099712187	Ade  Zulkarnaen	Ade.Zulkarnaen@pgn.co.id		ORG6000598		20171204103705
EMP6001451	0092651431	  Hendri	Hendri2@pgn.co.id		ORG6000811	SATKER6001218	20171204103705
EMP6001452	0099672181	Zainal Abidin Lubis	Zainal.Abidin@pgn.co.id		ORG6000788	SATKER6001218	20171204103705
EMP6001453	0099712188	  Nurdin	Nurdin@pgn.co.id		ORG6000931	SATKER6001218	20171204103705
EMP6001454	3097721710	Henri Herbet Panjaitan	Henri.Panjaitan@pgn.co.id		ORG6000847		20171204103705
EMP6001455	0012652639	  Sutopo	Sutopo@pgn.co.id		ORG6000536	SATKER6001252	20171204103705
EMP6001456	0010892496	Gayuh  Wulandari	Gayuh.Wulandari@pgn.co.id		ORG6001097		20171204103705
EMP6001457	0012892720	Elvan  Achmadi	Elvan.Achmadi@pgn.co.id	0811130057	ORG6000755	SATKER6001222	20171204103705
EMP6001458	0011902629	Adil Wahyudin Anwar	Adil.Anwar@pgn.co.id		ORG6000967	SATKER6001234	20171204103705
EMP6001459	1092701485	Mohammad  Rizal	Mohammad.Rizal@pgn.co.id	628111280037	ORG6000300	SATKER6001235	20171204103705
EMP6001460	0094711546	  Mahfudz	Machfudz@pgn.co.id	+6281220607135	ORG6001073	SATKER6001218	20171204103705
EMP6001461	1693651507	Moch  Ridwan	Muhammad.Ridwan@pgn.co.id		ORG6000211	SATKER6001245	20171204103705
EMP6001462	1699731762	Andi L Dullah	Andi.Dullah@pgn.co.id		ORG6000206	SATKER6001245	20171204103705
EMP6001463	2007852237	Achmad  Mirza	Achmad.Mirza2237@pgn.co.id		ORG6000923	SATKER6001213	20171204103705
EMP6001464	3004791985	Gindo Edward Nobel Panjaitan	Gindo.Panjaitan@pgn.co.id		ORG6000928		20171204103705
EMP6001465	0089691382	Marthalena  Luciana	Marthalena.LT@pgn.co.id		ORG6000933	SATKER6001219	20171204103705
EMP6001466	3007712257	  Aisyah	Aisyah@pgn.co.id	08126045004	ORG6000694	SATKER6001219	20171204103705
EMP6001467	2087661093	Wahyudi  Anas	Wahyudi.Agustinus@pgn.co.id	08113423300	ORG6000134	SATKER6001213	20171204103705
EMP6001468	0013702741	Pramono  Harjanto	Pramono.Harjanto@pgn.co.id	10412985	ORG6000489	SATKER6001256	20171204103705
EMP6001469	0004791965	Raka Haryo Indro	Raka.Indro@pgn.co.id	018572067845	ORG6000142	SATKER6001253	20171204103705
EMP6001470	0088631258	Dadang  Gandara	Dadang.Gandara@pgn.co.id	081430027781	ORG6000606		20171204103705
EMP6001471	0001751816	Agung  Prasetyo	Agung.Prasetyo@pgn.co.id	081410080588	ORG6001181	SATKER6001211	20171204103705
EMP6001472	0004741917	Yunan Fajar Ariyanto	Yunan.Fajar@pgn.co.id	08138676866	ORG6000599		20171204103705
EMP6001473	0003751882	Iwan Yuli Widyastanto	iwan.yuli@pgn.co.id	08118002058	ORG6000160		20171204103705
EMP6001474	3097741719	Lebinner  Sinaga	Lebinner.Sinaga@pgn.co.id	08151887682	ORG6000161	SATKER6001213	20171204103705
EMP6001475	0088621246	Endang Nadina  I.W.C.D	Endang.Nadina@pgn.co.id	0218606302	ORG6001129		20171204103705
EMP6001476	0004801971	Siti Nurmaya Rahmayani	Siti.Rahmayani@pgn.co.id	08128466425	ORG6000680	SATKER6001211	20171204103705
EMP6001477	3088631250	Herry  Yusuf	Herry.Yusuf@pgn.co.id	081537504888	ORG6000725	SATKER6001244	20171204103705
EMP6001478	0094681536	  Purnamawati	Purnamawati@pgn.co.id	434133	ORG6000636	SATKER6001236	20171204103705
EMP6001479	0096661624	Joko Heru Sutopo	joko.heru@pgn.co.id	08129924187	ORG6000629	SATKER6001219	20171204103705
EMP6001480	0099741787	Patricia Dwi Putri Panca Sakti	Patricia.Sakti@pgn.co.id	081586035788	ORG6000136	SATKER6001249	20171204103705
EMP6001481	0002721859	Ibnu  Asturrachman	Ibnu.Asturrahman@pgn.co.id	9991140263	ORG6000064	SATKER6001211	20171204103705
EMP6001482	0005832164	Wisnu  Muhharyadi	Wisnu.Muhharyadi@pgn.co.id	08111555857	ORG6000602		20171204103705
EMP6001483	3089641294	  Erliana	Erliana@pgn.co.id	0618465216	ORG6000693	SATKER6001219	20171204103705
EMP6001484	0004811973	Imelda  Fitry	Imelda.Fitry@pgn.co.id	08117194203	ORG6000234	SATKER6001213	20171204103705
EMP6001485	0004781930	  Khairuzzadi	Khairuzzadi@pgn.co.id	0081316472974	ORG6000642	SATKER6001219	20171204103705
EMP6001486	1096721606	Mohammad  Waspin	M.Waspin@pgn.co.id	02187928339	ORG6000213	SATKER6001245	20171204103705
EMP6001487	1008862363	Reesha Veninda Wardhana	Reesha.Wardhana@pgn.co.id	08118005580	ORG6000604		20171204103705
EMP6001488	0009842383	Iwhan Agung Wibowo	Iwhan.Wibowo@pgn.co.id	081388789252	ORG6000651	SATKER6001236	20171204103705
EMP6001489	0004781931	Ardhimas  Indrawidhi	Ardhimas.Indrawidhi@pgn.co.id	081315802380	ORG6000207	SATKER6001216	20171204103705
EMP6001490	1087621097	Panji  Sastrawijaya	Panji.Sastrawijaya@pgn.co.id	08159236629	ORG6000293	SATKER6001213	20171204103705
EMP6001491	0094651519	Pantas  Lumbantobing	Pantas.Tobing@pgn.co.id	081296400098	ORG6000493	SATKER6001256	20171204103705
EMP6001492	0089651343	Sri  Wahyuni	Sri.Wahyuni@pgn.co.id	0218700219	ORG6001134	SATKER6001248	20171204103705
EMP6001493	0097681688	Syafrudin  Harahap	Syafrudin.Harahap@pgn.co.id	0815-10605623	ORG6000674	SATKER6001211	20171204103705
EMP6001494	0007802278	Herdi  Qoharrudin	Herdi.Qoharrudin@pgn.co.id	08111049480	ORG6000726	SATKER6001243	20171204103705
EMP6001495	0007802281	Hendro  Waskito	hendro.waskito@pgn.co.id	087883710989	ORG6000736	SATKER6001243	20171204103705
EMP6001496	0004781960	Asri Retno Wahyuningsih	Asri.Retno@pgn.co.id	08129487277	ORG6000265	SATKER6001226	20171204103705
EMP6001497	2096751652	Faishal  Arief	Faisal.Arif@pgn.co.id	0081332539505	ORG6000844	SATKER6001227	20171204103705
EMP6001498	0010872528	Lia  Rahmania	Lia.Rahmania@pgn.co.id	48074201	ORG6000353		20171204103705
EMP6001499	0012852661	Arief  Mujiyanto	Arief.Mujiyanto@pgn.co.id	081328775167	ORG6000682	SATKER6001244	20171204103705
EMP6001500	0010852512	Detie  Maulina	Detie.Maulina@pgn.co.id	081298560085	ORG6000346	SATKER6001216	20171204103705
EMP6001501	0010882540	Adelina  Artikasani	Adelina.Artikasani@pgn.co.id	085775353133	ORG6000349	SATKER6001216	20171204103705
EMP6001502	0010892542	Corry  Sagala	Corry.Sagala@pgn.co.id	087884430387	ORG6001023	SATKER6001216	20171204103705
EMP6001503	0005792073	Budi Prasetyaning Tyas	Budi.Tyas@pgn.co.id	9991894952	ORG6000411	SATKER6001251	20171204103705
EMP6001504	1005792022	R. Brian Dwi Putranto	R.Brian.Dwiputranto@pgn.co.id	08112275045	ORG6000799		20171204103705
EMP6001505	0010882537	Indra  Triaswati	Indra.triaswati@pgn.co.id	08112990623	ORG6000177	SATKER6001213	20171204103705
EMP6001506	0005812134	Beni  Yudhanta	Beni.Yudhanta@pgn.co.id	08111096143	ORG6000174	SATKER6001213	20171204103705
EMP6001507	0010852516	Angga  Mahendra	Angga.mahendra@pgn.co.id	081218168885	ORG6000175	SATKER6001213	20171204103705
EMP6001508	0010832407	Cokorda Bagus Purnama Dwisa	Cokorda.Bagus@pgn.co.id	081385902780	ORG6000106	SATKER6001211	20171204103705
EMP6001509	0010862450	Oktobyanto Tri Raharjo	Oktobyanto.Raharjo@pgn.co.id	10673138	ORG6000586	SATKER6001211	20171204103705
EMP6001510	1005812031	Fauzan Novianto Nugroho	Fauzan.Nugroho@pgn.co.id	081-6899993	ORG6000580	SATKER6001211	20171204103705
EMP6001511	1089651316	Halid  Syarief	Halid.Sjarief@pgn.co.id	081281488018	ORG6001147	SATKER6001211	20171204103705
EMP6001512	2001781846	Moh.  Ishaq	M.Ishaq@pgn.co.id	08113351666	ORG6000893	SATKER6001211	20171204103705
EMP6001513	0010832409	Irsyad  Aini	Irsyad.Aini@pgn.co.id	081281018171	ORG6000121	SATKER6001211	20171204103705
EMP6001514	1096711602	Hakim  Wijaya	Hakim.Wijaya@pgn.co.id	08112422237	ORG6001053	SATKER6001245	20171204103705
EMP6001515	0010852566	Esti  Sulistyanasari	Esti.Sulistyanasari@pgn.co.id	087780980613	ORG6000386	SATKER6001209	20171204103705
EMP6001516	0010882620	Agus  Hartadi	Agus.Hartadi@pgn.co.id	08123525837	ORG6000758	SATKER6001234	20171204103705
EMP6001517	0010842551	Mei Silfan Anta Wardana	Silfan.Anta@pgn.co.id	08127131310	ORG6001108	SATKER6001234	20171204103705
EMP6001518	0010862440	Donny  Setiawan	Donny.Setiawan@pgn.co.id		ORG6000282	SATKER6001213	20171204103705
EMP6001519	2004822012	Heru  Setiawan	heru.setiawan2012@pgn.co.id	08111852013		SATKER6001240	20171204103705
EMP6001520	0012892715	Rudy  Setyawan	Rudy.Setyawan@pgn.co.id		ORG6000375		20171204103705
EMP6001521	0011902635	Dini  Septiani	Dini.Septiani@pgn.co.id	085710358888	ORG6000376		20171204103705
EMP6001522	0010852569	Firdah Tia Yuliana	Firdah.Yuliana@pgn.co.id	081213575770	ORG6000435	SATKER6001251	20171204103705
EMP6001523	0010862446	Riandy  Arizon	Riandy.Arizon@pgn.co.id	081212239996	ORG6000456	SATKER6001251	20171204103705
EMP6001524	0006812172	Vaticano  Walflomanto	Vaticano.Walflomanto@pgn.co.id	085285963983	ORG6000228	SATKER6001216	20171204103705
EMP6001525	1007842226	Winda  Wati	Winda.Wati@pgn.co.id	082123924878	ORG6000427	SATKER6001216	20171204103705
EMP6001526	0010872467	  Akmaluddin	Akmaluddin@pgn.co.id	08128698495	ORG6000801	SATKER6001234	20171204103705
EMP6001527	0012792654	Ari Arnold Vergouw	Ari.Vergouw@pgn.co.id	08119263030	ORG6000171	SATKER6001213	20171204103705
EMP6001528	3004791986	Riza  Buana	Riza.Buana@pgn.co.id	08126514484	ORG6000472	SATKER6001229	20171204103705
EMP6001529	0010852571	I Made Setiawan Wijaya	Made.Setiawan@pgn.co.id	081280115767	ORG6000428	SATKER6001218	20171204103705
EMP6001530	0010842625	Soli Akbar Hutagaol	Soli.Akbar@pgn.co.id	08119919619	ORG6000585	SATKER6001211	20171204103705
EMP6001531	2007832235	Hadid  Azelea	Hadid.Azelea@pgn.co.id	08113093111	ORG6000095	SATKER6001211	20171204103705
EMP6001532	0005792075	Diki  Hasanudin	Diki.Hasanudin@pgn.co.id	0812.88409956	ORG6000583	SATKER6001211	20171204103705
EMP6001533	0010872595	Anang  Kustanto	anang.kustanto@pgn.co.id	081287954725	ORG6000740	SATKER6001234	20171204103705
EMP6001534	1005842170	Adi  Saputra	Adi.Saputra@pgn.co.id	081310520019	ORG6000743	SATKER6001234	20171204103705
EMP6001535	0010872594	Fuad  Hasan	fuad.hasan@pgn.co.id	081285775211	ORG6000767	SATKER6001234	20171204103705
EMP6001536	0007862336	Sony  Achmad	Sony.Achmad@pgn.co.id	081369349949	ORG6000717	SATKER6001234	20171204103705
EMP6001537	3004851994	Andyan Borisman Situmorang	Andyan.Situmorang@pgn.co.id	0812 6588 8585	ORG6000090	SATKER6001211	20171204103705
EMP6001538	2095731560	  Sudarmo	Sudarmo@pgn.co.id	081330487266	ORG6001130	SATKER6001211	20171204103705
EMP6001539	0088621142	Henky  Karmanu	Henky.Karmanu@pgn.co.id	0811910210	ORG6001001	SATKER6001253	20171204103705
EMP6001540	0089651341	Hari  Muladi	Hari.Muladi@pgn.co.id	0215363414	ORG6000496	SATKER6001256	20171204103705
EMP6001541	0094701541	Achmad  Mulyono	Achmad.Mulyono@pgn.co.id	0217708314	ORG6001124		20171204103705
EMP6001542	1005822037	Agus Muhammad Mirza	Agus.Mirza@pgn.co.id	08127147107	ORG6000275	SATKER6001226	20171204103705
EMP6001543	0089691352	Hafifah  Taharudin	Hafifah.Taharudin@pgn.co.id	08161607717	ORG6000354	SATKER6001217	20171204103705
EMP6001544	0006792171	  Retnoningsih	Retnoningsih@pgn.co.id	087885850085	ORG6000419	SATKER6001251	20171204103705
EMP6001545	0001781841	Johannes Parlindungan Simatupang	Johannes.Parlindungan@pgn.co.id	081389089897	ORG6000486	SATKER6001240	20171204103705
EMP6001546	2099761746	Mochammad  Arif	Mochammad.Arif@pgn.co.id	0317860300	ORG6000818		20171204103705
EMP6001547	1699781763	  Heriyana	Heriyana@pgn.co.id	08112448698	ORG6000225	SATKER6001216	20171204103705
EMP6001548	0003771895	Meutia  Prima	Meutia.Prima@pgn.co.id	081399253214	ORG6001126	SATKER6001248	20171204103705
EMP6001549	0003761886	Mula Prasetyawan Senja	Mula.Senja@pgn.co.id	0821142971860	ORG6000822	SATKER6001213	20171204103705
EMP6001550	2095711553	Sutarno  TW	Sutarno.TW@pgn.co.id	081332621354	ORG6000924	SATKER6001213	20171204103705
EMP6001551	0002711856	Vietor Heglind Tobing	vietor.tobing@pgn.co.id	08170823371	ORG6000468	SATKER6001229	20171204103705
EMP6001552	0004801972	Santika Budhi Utami	Santika.Utami@pgn.co.id	021877823923	ORG6000950	SATKER6001218	20171204103705
EMP6001553	0007812285	Haryoga Aditya Wardhana	Haryoga.Wardhana@pgn.co.id	021-5854173	ORG6000969	SATKER6001253	20171204103705
EMP6001554	0092651443	Agus  Mufriadi	Agus.Mufriadi@pgn.co.id	0811300920	ORG6000769	SATKER6001222	20171204103705
EMP6001555	0012872688	Anas Asy Syifa	Anas.Syifa@pgn.co.id	065324924	ORG6000579	SATKER6001211	20171204103705
EMP6001556	0012892710	Arief  Setiawan	Arief.Setiawan@pgn.co.id		ORG6000972	SATKER6001253	20171204103705
EMP6001557	0012872678	Hatgi Noer Ramandito	Hatgi.Ramandito@pgn.co.id		ORG6000112	SATKER6001211	20171204103705
EMP6001558	0012872681	Andhika Yuristiana Putra	Andhika.Putra@pgn.co.id		ORG6000123	SATKER6001211	20171204103705
EMP6001559	0012872687	Hidayat  Anshori	Hidayat.Anshori@pgn.co.id		ORG6000960		20171204103705
EMP6001560	0089631334	R. Arman  Widhymarmanto	R.Arman@pgn.co.id	08990685555	ORG6000566	SATKER6001231	20171204103705
EMP6001561	0094651521	Gamal Imam Santoso	Gamal.Santoso@pgn.co.id	0811180016		SATKER6001207	20171204103705
EMP6001562	0099731783	Helmy  Setyawan	Helmy.Setyawan@pgn.co.id	08129502508		SATKER6001217	20171204103705
EMP6001563	0096671625	Rigo  Supratman	Rigo.Supratman@pgn.co.id	081410015264			20171204103705
EMP6001564	0004781926	Andi Sangga Prasetia	Andi.Prasetia@pgn.co.id	02130162460			20171204103705
EMP6001565	0004811976	Andrie Oktafauzan Lubis	andrie.oktafauzan@pgn.co.id	08128695963			20171204103705
EMP6001566	0095691579	Dody  Tusandy	Dody.Tusandy@pgn.co.id	08158149777		SATKER6001239	20171204103705
EMP6001567	0001761831	Hery  Gunawan	Hery.Gunawan@pgn.co.id			SATKER6001239	20171204103705
EMP6001568	0003781900	Dwitya Tanti Wigraha	Dwitya.Wigraha@pgn.co.id	08179337033			20171204103705
EMP6001569	0005782055	Seno  Supriadi	Seno.Supriadi@pgn.co.id	08111014916			20171204103705
EMP6001570	0005832156	Yane  Maulina	Yane.Maulina@pgn.co.id				20171204103705
EMP6001571	0007822294	Santi  Hairunissa	Santi.Hairunissa@pgn.co.id	0007822294		SATKER6001239	20171204103705
EMP6001572	0087662638	Dian  Savitri	dian.savitri@pgn.co.id	08128091791			20171204103705
EMP6001573	0095701581	  Daryanto	Daryanto.1581@pgn.co.id	0811-8207060		SATKER6001269	20171204103705
EMP6001574	0005802123	Gunawan Cahyo Nugroho	Gunawan.Nugroho@pgn.co.id	08122126597			20171204103705
EMP6001575	1693701511	Rusli  Mulyana	Rusli.Mulyana@pgn.co.id	08117215619		SATKER6001239	20171204103705
EMP6001576	0005832158	Lini Amy Berlian Tampubolon	Lini.B.Tampubolon@pgn.co.id				20171204103705
EMP6001577	0007842318	Agung Kusuma Wardana	Agung.Wardana@pgn.co.id	081310410345		SATKER6001239	20171204103705
EMP6001578	0007842325	Obrin  Ambari	Obrin.Ambari@pgn.co.id	08127100584		SATKER6001239	20171204103705
EMP6001579	0007852326	Genius  NJ	Genius.NJ@pgn.co.id	08117830651		SATKER6001239	20171204103705
EMP6001580	0010872525	Sahid  Achmadi	Sahid.Achmadi@pgn.co.id			SATKER6001239	20171204103705
EMP6001581	1087631099	  Suparto	Suparto@pgn.co.id	081213273990		SATKER6001239	20171204103705
EMP6001582	2001771845	Oki Imam Muttaqin	Oki.Muttaqin@pgn.co.id	0811925445		SATKER6001238	20171204103705
EMP6001583	3097771726	Muhammad  Kahfi	Muhammad.Kahfi@pgn.co.id	0811650936		SATKER6001239	20171204103705
EMP6001584	3089651371	Tauhid  Safari	Tauhid.Safari@pgn.co.id	08179158718		SATKER6001239	20171204103705
EMP6001585	0009852389	Ihdina  Adli	Ihdina.Adli@pgn.co.id			SATKER6001239	20171204103705
EMP6001586	0009852393	Nanda Aditya Pradana	Nanda.P@pgn.co.id			SATKER6001239	20171204103705
EMP6001587	0010852567	Mahmud  Arrosyad	Mahmud.Arrosyad@pgn.co.id			SATKER6001239	20171204103705
EMP6001588	0010872603	  Rizky	rizky@pgn.co.id			SATKER6001239	20171204103705
EMP6001589	0012772642	R. Victor Tetrano Purboristanto	Victor.Tetrano@pgn.co.id			SATKER6001239	20171204103705
EMP6001590	1008822348	Bahar Adnan Baihaky	Bahar.Baihaky@pgn.co.id			SATKER6001269	20171204103705
EMP6001591	1008852372	Adhitya  Bimantoro	Adhitya.Bimantoro@pgn.co.id			SATKER6001269	20171204103705
EMP6001592	2002791864	Eko  Septyawan	Eko.Septyawan@pgn.co.id	08113300734		SATKER6001218	20171204103705
EMP6001593	2096741678	Dyah Retno Suryani	Dyah.Suryani@pgn.co.id				20171204103705
EMP6001594	0012862667	Dian Vektorendra Wahyuda	Dian.Wahyuda@pgn.co.id			SATKER6001239	20171204103705
EMP6001595	1089611311	M  Sidik	Muhammad.Sidik@pgn.co.id				20171204103705
EMP6001596	0010852557	Yogo Oka Prima	Yogo.Oka@pgn.co.id				20171204103705
EMP6001597	0010862445	Dolly  Adrian	Dolly.Adrian@pgn.co.id			SATKER6001239	20171204103705
EMP6001598	0010862449	Rendiyansa  Agustian	Rendiyansa.Agustian@pgn.co.id	082175927482		SATKER6001239	20171204103705
EMP6001599	0010892492	Brian  Permana	Brian.Permana@pgn.co.id			SATKER6001239	20171204103705
EMP6001600	0012892717	Rifki Bagus Pradipta	Rifki.Pradipta@pgn.co.id			SATKER6001239	20171204103705
EMP6001601	1092651466	  Paryono	Paryono@pgn.co.id			SATKER6001239	20171204103705
EMP6001602	2099761752	Wiwit  Ariyanto	Wiwit.Ariyanto@pgn.co.id			SATKER6001239	20171204103705
EMP6001603	1088671194	Syamsul  Bahri	Syamsul.Bahri@pgn.co.id			SATKER6001239	20171204103705
EMP6001604	1088631180	  Sainan	Sainan@pgn.co.id			SATKER6001238	20171204103705
EMP6001605	2589621363	  Abdullah	Abdullah@pgn.co.id			SATKER6001218	20171204103705
EMP6001606	0003771891	Richard  Napitupulu	Richard.Napitupulu@pgn.co.id	081310440180	ORG6000491	SATKER6001256	20171204103705
EMP6001607	0003771889	  Elise	Elise@pgn.co.id	088808093333	ORG6000499		20171204103705
EMP6001608	3089691381	  Solorida	Solorida@pgn.co.id	08116134354	ORG6000899		20171204103705
EMP6001609	0001751822	Dani Arief Permana	Dani.Permana@pgn.co.id	021-71967601	ORG6000685	SATKER6001244	20171204103705
EMP6001610	0003781904	  Maisalina	Maisalina@pgn.co.id	02182931880	ORG6000170	SATKER6001213	20171204103705
EMP6001611	0095681596	  Sukardi	Sukardi@pgn.co.id		ORG6001125	SATKER6001218	20171204103705
EMP6001612	0099642198	  Supriatna	Supriatna@pgn.co.id		ORG6001189	SATKER6001218	20171204103705
EMP6001613	0016942780	Luluk  Noorratri	Luluk.Noorratri@pgn.co.id		ORG6000979	SATKER6001216	20171204103705
EMP6001614	0009842387	Mohammad Said Setya Amdi	Said.Amdi@pgn.co.id		ORG6000711		20171204103705
EMP6001615	0010882611	Ilham Luthfi Nasution	Ilham.Luthfi@pgn.co.id	08111767333	ORG6000827	SATKER6001213	20171204103705
EMP6001616	0010822406	Muhammad Safrin Mariesta	Safrin.Mariesta@pgn.co.id		ORG6001156	SATKER6001213	20171204103705
EMP6001617	0004732003	Ninik  Sunarti	Ninik.Sunarti@pgn.co.id		ORG6001072	SATKER6001218	20171204103705
EMP6001618	0012812646	  Katamsi	Katamsi@pgn.co.id		ORG6000548		20171204103705
EMP6001619	0014932758	Ristafani Tia Safitri	Ristafani.Safitri@pgn.co.id	082138390099	ORG6000237	SATKER6001224	20171204103705
EMP6001620	0017962792	Madina  Annanisa	Madina.Annanisa@pgn.co.id		ORG6001205	SATKER6001210	20171204103705
EMP6001621	0010872486	Anita  Sari	anita.sari@pgn.co.id	081285433455	ORG6000838	SATKER6001212	20171204103705
EMP6001622	3007772240	Poppy  Simorangkir	Poppy.Simorangkir@pgn.co.id		ORG6000332	SATKER6001215	20171204103705
EMP6001623	1005812029	Laurina Dewita Ivanna Razak	Laurina.Razak@pgn.co.id	0218204345	ORG6001026	SATKER6001218	20171204103705
EMP6001624	3007802241	Febi  Hartanto	Febi.Hartanto@pgn.co.id		ORG6000929	SATKER6001213	20171204103705
EMP6001625	0009842386	Muhammad Fikrie Farhan	Fikrie.Farhan@pgn.co.id	085320091984	ORG6000961		20171204103705
EMP6001626	1007732204	Ade  Rusmana	Ade.Rusmana@pgn.co.id		ORG6000742	SATKER6001243	20171204103705
EMP6001627	0010862439	Zanuar  Kriswanto	Zanuar.Kriswanto@pgn.co.id		ORG6001079	SATKER6001222	20171204103705
EMP6001628	0015942771	Syah Dears Kinanthi Pranayoga	Syah.Pranayoga@pgn.co.id		ORG6000781		20171204103705
EMP6001629	0007832299	Citra  Pranandar	Citra.Pranandar@pgn.co.id		ORG6000716		20171204103705
EMP6001630	1005832040	Firsta  Melyana	Firsta.Melyana@pgn.co.id		ORG6000279	SATKER6001223	20171204103705
EMP6001631	0004772008	  Rosdiana	Rosdiana@pgn.co.id		ORG6001136	SATKER6001213	20171204103705
EMP6001632	1008782375	Yuli  Priyanto	Yuli.Priyanto@pgn.co.id	085295263439	ORG6000209	SATKER6001213	20171204103705
EMP6001633	2002821867	Dwi  Andriani	Dwi.Andriani@pgn.co.id	081330644944	ORG6000408	SATKER6001227	20171204103705
EMP6001634	2002791865	Anis  Nurhidayat	Anis.Nurhidayat@pgn.co.id		ORG6000308	SATKER6001213	20171204103705
EMP6001635	0099731777	Antonius Aris Sudjatmiko	Antonius.Sudjatmiko@pgn.co.id	081519017444	ORG6000550	SATKER6001234	20171204103705
EMP6001636	0088631150	  Yuwono	Yuwono@pgn.co.id	08118072286	ORG6000144	SATKER6001253	20171204103705
EMP6001637	0003741878	Sandi  Hardi	Sandi.Hardi@pgn.co.id	8007-8371	ORG6000092	SATKER6001211	20171204103705
EMP6001638	0098761738	Lely  Malini	Lely.Malini@pgn.co.id	08161663343	ORG6000378	SATKER6001209	20171204103705
EMP6001639	0005792060	Dimas Haryo Dito	Dimas.Dito@pgn.co.id	081510363969	ORG6000519		20171204103705
EMP6001640	0005792065	Zulfikar Ali Imran	Zulfikar.Imran@pgn.co.id	0812009001631	ORG6000412	SATKER6001251	20171204103705
EMP6001641	0094631516	Rindang  Triono	Rindang.Triono@pgn.co.id	08179005130	ORG6000139	SATKER6001230	20171204103705
EMP6001642	0004821979	Syahril  Malik	Syahril.Malik@pgn.co.id	481643	ORG6000600		20171204103705
EMP6001643	0005792074	Sigit  Waluyo	Sigit.Waluyo@pgn.co.id	08128420467	ORG6000595		20171204103705
EMP6001644	0001761824	Kemas Lukmanul Hakim	kemas.lukmanul@pgn.co.id	08119853311	ORG6000530	SATKER6001252	20171204103705
EMP6001645	0001751818	Sophan  Sophian	Sophan.Sophian@pgn.co.id	121327217624	ORG6000552		20171204103705
EMP6001646	1086631011	Arif  Yunizar	Arif.Yunizar@pgn.co.id	0811-800071	ORG6000065	SATKER6001211	20171204103705
EMP6001647	0005792059	  Suseno	Suseno@pgn.co.id	027483784701	ORG6000520		20171204103705
EMP6001648	0088611237	Daniel Hamonangan Sodjuangon Hutahuruk	Daniel.Hamonangan@pgn.co.id	0122122212889	ORG6000876	SATKER6001211	20171204103705
EMP6001649	2099751742	Atang  Sudjani	Atang.Sudjani@pgn.co.id	08121728749	ORG6000166	SATKER6001213	20171204103705
EMP6001650	0007832306	Dian  Restiyani	Dian.Restiyani@pgn.co.id	0218094492	ORG6000643	SATKER6001219	20171204103705
EMP6001651	1005832042	Erick  Taufan	Erick.Taufan@pgn.co.id	08118161167	ORG6000531	SATKER6001252	20171204103705
EMP6001652	0012862671	Mohammad  Zanuddin	Mohammad.Zanuddin@pgn.co.id	081380474726	ORG6000627	SATKER6001220	20171204103705
EMP6001653	0010882534	Risma Vanessa Prameswari	Risma.Prameswari@pgn.co.id	081252181862	ORG6000653	SATKER6001236	20171204103705
EMP6001654	1007842222	Kusuma Wishnu Wardhana	Kusuma.Wardhana@pgn.co.id	02129312336	ORG6000652	SATKER6001236	20171204103705
EMP6001655	2007832236	Bramantya Pradana Saputra	Bramantya.Saputra@pgn.co.id	08113424864	ORG6000879	SATKER6001213	20171204103705
EMP6001656	1596741647	Ade  Sutisna	Ade.Sutisna@pgn.co.id	+628119303451	ORG6000196	SATKER6001213	20171204103705
EMP6001657	0004761918	Kusnasriawan Nugroho Santoso	kusnasriawan.nugroho@pgn.co.id	0008159693093	ORG6000701	SATKER6001234	20171204103705
EMP6001658	0088611238	Yohanes Mardi Irianto	Yohannes.Irianto@pgn.co.id	0811130912	ORG6000484	SATKER6001240	20171204103705
EMP6001659	0094661524	Yuliandri  Royke	Yuliandri.Royke@pgn.co.id	08126086913	ORG6000589	SATKER6001211	20171204103705
EMP6001660	0012862675	Tommy Arbiwijaya Suherlan	Tommy.Suherlan@pgn.co.id		ORG6000464	SATKER6001214	20171204103705
EMP6001661	0012852664	Fitra  Yuda	fitra.yuda@pgn.co.id	08119890105	ORG6000086		20171204103705
EMP6001662	1007812207	Siti  Nuraida	Siti.Nuraida@pgn.co.id	0021022421476	ORG6000866		20171204103705
EMP6001663	2095681550	Nur  Hidayati	Nur.Hidayati@pgn.co.id	00317880849	ORG6001103	SATKER6001218	20171204103705
EMP6001664	0010882539	Putri Wahyu Andarini	Putri.andarini@pgn.co.id	085640470511	ORG6000913	SATKER6001220	20171204103705
EMP6001665	1007832221	Tutus  Kurniawan	Tutus.Kurniawan@pgn.co.id	081310752533	ORG6000654	SATKER6001236	20171204103705
EMP6001666	0005822146	  Wulandari	Wulandari@pgn.co.id	08170586011	ORG6000697		20171204103705
EMP6001667	0003781901	Teguh Umar Dhanu	teguh.umar@pgn.co.id	08119881056	ORG6000444	SATKER6001251	20171204103705
EMP6001668	1008622345	  Yono	Yono.Firdaus@pgn.co.id	081222054700	ORG6000789	SATKER6001218	20171204103705
EMP6001669	0012872685	Arif  Budhianto	Arif.Budhianto@pgn.co.id	08119295471	ORG6000988	SATKER6001220	20171204103705
EMP6001670	1005822033	Erwin  Gitarisyana	Erwin.Gitarisyana@pgn.co.id	082114899000	ORG6000244	SATKER6001225	20171204103705
EMP6001671	0096711668	Agung Hari Setiawan	Agung.Setiawan@pgn.co.id	008118163315	ORG6000469	SATKER6001229	20171204103705
EMP6001672	0010862484	Prima Hotlan Kristianto	Prima.Hotlan@pgn.co.id		ORG6000582	SATKER6001211	20171204103705
EMP6001673	0005822106	Yanuar Yudha Adi Putra	Yanuar.Yudha@pgn.co.id	021-22910952	ORG6000125	SATKER6001211	20171204103705
EMP6001674	0007822298	Ridwan  Muharam	Ridwan.Muharam@pgn.co.id	08121.4118811	ORG6000936	SATKER6001211	20171204103705
EMP6001675	0007832311	Rahmat  Hidayat	Rahmat.Hidayat@pgn.co.id	08112000456	ORG6000869	SATKER6001211	20171204103705
EMP6001676	2095711554	  Budhijanto	Budhijanto@pgn.co.id	08161365138	ORG6001017	SATKER6001211	20171204103705
EMP6001677	0005822150	Ariel Sharon Pasaribu	Ariel.Pasaribu@pgn.co.id	6282177966082	ORG6000783		20171204103705
EMP6001678	0007822289	Ida Fortuna Dewi	Ida.Dewi@pgn.co.id	081386568120	ORG6000178	SATKER6001249	20171204103705
EMP6001679	1007842223	Roy  Gamma	Roy.Gamma@pgn.co.id	081320105896	ORG6000388	SATKER6001209	20171204103705
EMP6001680	0007852327	Mira  Fatmawati	Mira.Fatmawati@pgn.co.id	081325460026	ORG6000393	SATKER6001234	20171204103705
EMP6001681	0012792644	Mikha Marulitua Asido	Mikha.Asido@pgn.co.id	08119003565	ORG6000390	SATKER6001209	20171204103705
EMP6001682	2099751743	Agus  Riyanto	Agus.Riyanto@pgn.co.id	0811335675	ORG6000753	SATKER6001222	20171204103705
EMP6001683	0010872592	Fourikha Budi Sulistyo	fourikha.budi@pgn.co.id	085793024262	ORG6000760	SATKER6001234	20171204103705
EMP6001684	0010862589	Cecep Harry Prawira	cecep.prawira@pgn.co.id	8116172888	ORG6000776	SATKER6001234	20171204103705
EMP6001685	0010882610	Syaifan Fauzi Nasution	Syaifan.Fauzi@pgn.co.id	8111174001	ORG6000779	SATKER6001234	20171204103705
EMP6001686	0010842413	Septiaji Muhammad Ibnu Salam	Septiaji.Salam@pgn.co.id	085640109529	ORG6000706		20171204103705
EMP6001687	1007822217	Dedy  Wibowo	Dedy.Wibowo@pgn.co.id	088977586666	ORG6000299	SATKER6001213	20171204103705
EMP6001688	3097751721	Selly  Elizabeth	Selly.Tobing@pgn.co.id	081901004722	ORG6000356		20171204103705
EMP6001689	1088641187	  Mahmudin	Mahmudin@pgn.co.id	081381993280	ORG6000503	SATKER6001256	20171204103705
EMP6001690	1596711640	Heri  Hermawan	Heri.Hermawan@pgn.co.id	08111718868	ORG6000501	SATKER6001256	20171204103705
EMP6001691	0012872653	Norma Yulianty Fransisca	Fransisca.Simarmata@pgn.co.id		ORG6000547		20171204103705
EMP6001692	0012772643	Hendra  Frayudi	Hendra.Frayudi@pgn.co.id	021-8305025	ORG6001050		20171204103705
EMP6001693	0010882613	Adam Smith El Jaber	Adam.Smith@pgn.co.id	081514608686	ORG6001132	SATKER6001213	20171204103705
EMP6001694	0010872462	Septi Lusia Indah	Septi.Lusia@pgn.co.id	085645472778	ORG6000898	SATKER6001236	20171204103705
EMP6001695	0004782009	  Andriansyah	Andriansyah.2009@pgn.co.id	10201312	ORG6000787	SATKER6001218	20171204103705
EMP6001696	0004782010	  Suladi	Suladi@pgn.co.id	08179998100	ORG6000676	SATKER6001211	20171204103705
EMP6001697	0007852330	  Anindito	Anindito@pgn.co.id	081586605232	ORG6000156	SATKER6001253	20171204103705
EMP6001698	0005792116	  Mardeni	Mardeni@pgn.co.id	08114514867	ORG6001148	SATKER6001211	20171204103705
EMP6001699	0010862582	Findra Agustian Ardhi	Findra.Agustian@pgn.co.id	082114255188	ORG6001177	SATKER6001211	20171204103705
EMP6001700	0010882618	Galih Eko Ardiyanto	Galih.Ardiyanto@pgn.co.id	081218227928	ORG6001178	SATKER6001211	20171204103705
EMP6001701	0007862334	Akrom Akhmadi Wibowo	Akrom.Wibowo@pgn.co.id	08111754402	ORG6000871	SATKER6001234	20171204103705
EMP6001702	2095721557	  Supriyono	Supriyono@pgn.co.id	08113289060	ORG6001186	SATKER6001211	20171204103705
EMP6001703	1092681477	Widodo Djoko Susilo	Widodo.Susilo@pgn.co.id	0008123024789	ORG6000829	SATKER6001223	20171204103705
EMP6001704	0004821978	Samson  Sony	Samson.Sony@pgn.co.id	081314232344	ORG6001055	SATKER6001211	20171204103705
EMP6001705	0007832308	Melanton August Rahmanto	Melanton.Rahmanto@pgn.co.id	0818110825	ORG6000940		20171204103705
EMP6001706	0089701354	Tety  Aryanti	Tety.Aryanti@pgn.co.id	02198236285	ORG6000416	SATKER6001251	20171204103705
EMP6001707	0005822101	Jovitha Salea Battu	Jovitha.Battu@pgn.co.id	08111925442	ORG6000610	SATKER6001220	20171204103705
EMP6001708	0005782057	Cahyo  Sudarto	Cahyo.Sudarto@pgn.co.id	122122250156	ORG6001173	SATKER6001211	20171204103705
EMP6001709	0004791933	Andri  Gunawan	Andri.Gunawan@pgn.co.id	02199272633	ORG6001006		20171204103705
EMP6001710	0001751820	Dyah Fitria Prabaningrum	dyah.fitria@pgn.co.id	08129504920	ORG6000432	SATKER6001218	20171204103705
EMP6001711	2095711555	Irene  Joeliawardani	Irene.Joeliawarda@pgn.co.id	0855.9004993	ORG6000396	SATKER6001209	20171204103705
EMP6001712	0099751793	Dian Heryanti Handayani	Dian.HeryantiH@pgn.co.id	08116151975	ORG6000772		20171204103705
EMP6001713	0007832303	Siti  Aisah	Siti.Aisah@pgn.co.id	08881604927	ORG6000905	SATKER6001213	20171204103705
EMP6001714	0003781899	Prishy Ratrisadewi Suwarso	Prishy.Suwarso@pgn.co.id	081314708036	ORG6000672	SATKER6001211	20171204103705
EMP6001715	0092691452	  Gitoyo	Gitoyo@pgn.co.id	1221-22293013	ORG6000675	SATKER6001211	20171204103705
EMP6001716	0005812093	Noris  Subekti	Noris.Subekti@pgn.co.id	0812 8742 427	ORG6000087	SATKER6001211	20171204103705
EMP6001717	2095741562	Alif Pramudya Riza	Alif.Riza@pgn.co.id	08113308831	ORG6000819		20171204103705
EMP6001718	0005832108	  Purwanto	Purwanto@pgn.co.id	081318318745	ORG6000728	SATKER6001243	20171204103705
EMP6001719	2095701551	  M.Munari	Muhammad.Munari@pgn.co.id	008113450030	ORG6000751	SATKER6001234	20171204103705
EMP6001720	0012862673	Hanief  Fadhillah	Hanief.Fadhillah@pgn.co.id		ORG6001182	SATKER6001211	20171204103705
EMP6001721	0012862670	Mochammad Dwi Subiyantoro	Dwi.Subiyantoro@pgn.co.id		ORG6000164	SATKER6001213	20171204103705
EMP6001722	0012892702	Abirul Trison Syahputra	Abirul.Syahputra@pgn.co.id		ORG6000465	SATKER6001214	20171204103705
EMP6001723	0012892719	Zulfikar Sani Putra	Zulfikar.Putra@pgn.co.id		ORG6000351		20171204103705
EMP6001724	1087621098	Eko  Purnomo	Eko.Purnomo@pgn.co.id	0217764470	ORG6000689	SATKER6001219	20171204103705
EMP6001725	0012872682	Azwar  Oktaviansyah	Azwar.Oktaviansyah@pgn.co.id	08113553377	ORG6000756	SATKER6001222	20171204103705
EMP6001726	0096671628	Dwika  Agustianto	dwika.agustianto@pgn.co.id	122433206357	ORG6000904	SATKER6001231	20171204103705
EMP6001727	0088621242	Heru  Susapto	Heru.Susapto@pgn.co.id	08129718618	ORG6000875	SATKER6001213	20171204103705
EMP6001728	0089621339	Rosmawati  Naiborhu	Rosmawati.Naiborhu@pgn.co.id	02154213696	ORG6000874	SATKER6001213	20171204103705
EMP6001729	0097721701	  Chaedar	Chaedar@pgn.co.id	08119937714			20171204103705
EMP6001730	0089661344	Achmad  Mirza	Achmad.Mirza@pgn.co.id	0811375966			20171204103705
EMP6001731	0001741812	Iis  Elisah	Iis.Elisah@pgn.co.id	0811117691			20171204103705
EMP6001732	0005782112	Mahfud  Fauzi	Mahfud.Fauzi@pgn.co.id	08159253323			20171204103705
EMP6001733	0092661492	M. Zaini  Dahlan	Zaini.Dahlan@pgn.co.id	002177216063			20171204103705
EMP6001734	0097721703	Agoes  Kresnowo	Agus.Kresnowo@pgn.co.id	08119894866		SATKER6001270	20171204103705
EMP6001735	0005822147	Ary  Maulana	Ary.Maulana@pgn.co.id	02187754877			20171204103705
EMP6001736	1588651280	Janim  Susanto	Janim.Susanto@pgn.co.id			SATKER6001239	20171204103705
EMP6001737	0003721874	Meidy  Aryaldi	Meidy.Aryaldi@pgn.co.id	089652122920			20171204103705
EMP6001738	0007842313	Sondang  Aryanto	Sondang.Aryanto@pgn.co.id	08122162048		SATKER6001239	20171204103705
EMP6001739	0092691434	Dindin  Komarudin	Dindin.Komarudin@pgn.co.id	0813 1007 7969		SATKER6001239	20171204103705
EMP6001740	0095761591	Aryo  Wicaksono	Aryo.Wicaksono@pgn.co.id	08129377139		SATKER6001239	20171204103705
EMP6001741	3089701386	Minda  Tati	Minda.Tati@pgn.co.id	081370366814		SATKER6001238	20171204103705
EMP6001742	0094651522	  Maryanto	Maryanto@pgn.co.id	08111926045		SATKER6001239	20171204103705
EMP6001743	1095691578	Akur  Pariaman	Akur.Pariaman@pgn.co.id	02188982984		SATKER6001239	20171204103705
EMP6001744	0005832167	Ade Aryani Raisia	Ade.Raisia@pgn.co.id	087876919284			20171204103705
EMP6001745	0007832302	Pramono Setiya Purwanto	Pramono.Purwanto@pgn.co.id			SATKER6001239	20171204103705
EMP6001746	0010862523	Santi  Susiloputri	Santi.Susiloputri@pgn.co.id			SATKER6001239	20171204103705
EMP6001747	0010872533	Arindra  Irtonugroho	Arindra.Irtonugroho@pgn.co.id			SATKER6001239	20171204103705
EMP6001748	3090671416	Della  Siregar	Della.Siregar@pgn.co.id	081265455836		SATKER6001219	20171204103705
EMP6001749	0007872265	Pradipta  Ardhi	Pradipta.ardhi@pgn.co.id			SATKER6001239	20171204103705
EMP6001750	0010842552	Riptian Suryo Anggoro	Riptian.Anggoro@pgn.co.id			SATKER6001239	20171204103705
EMP6001751	0010852433	Nova  Kristian	Nova.Kristian@pgn.co.id			SATKER6001239	20171204103705
EMP6001752	0010852570	Aditana Budi Wijaya	Aditana.Budi@pgn.co.id			SATKER6001239	20171204103705
EMP6001753	0012892706	Eko  Wantara	Eko.Wantara@pgn.co.id	085717437404		SATKER6001239	20171204103705
EMP6001754	1007822215	Muhammad  Riyad	Muhammad.Riyad@pgn.co.id			SATKER6001239	20171204103705
EMP6001755	1092681479	  Aminudin	Aminudin@pgn.co.id			SATKER6001239	20171204103705
EMP6001756	2001811851	Deddy  Efendi	Deddy.Effendi@pgn.co.id			SATKER6001239	20171204103705
EMP6001757	0010862522	Rahmat  Zamzami	Rahmat.Zamzami@pgn.co.id			SATKER6001239	20171204103705
EMP6001758	0010862585	Danang Setyo Nugroho	Danang.Setyo2@pgn.co.id	081310979228		SATKER6001239	20171204103705
EMP6001759	0014932764	Muhammad Angga Suryadi	Angga.Suryadi@pgn.co.id			SATKER6001239	20171204103705
EMP6001760	0014932766	Dionisius Kristian Tirta Aji	Dionisius.Aji@pgn.co.id			SATKER6001239	20171204103705
EMP6001761	0092651432	  Kusnandar	Kusnandar@pgn.co.id			SATKER6001239	20171204103705
EMP6001762	0099662184	  Subiyanto	Subiyanto@pgn.co.id			SATKER6001239	20171204103705
EMP6001763	1007832219	Hendy  Priatna	Hendy.Priatna@pgn.co.id			SATKER6001229	20171204103705
EMP6001764	1088641184	  Sriyono	Sriyono@pgn.co.id			SATKER6001239	20171204103705
EMP6001765	1092651469	Edi  Supandi	Edi.Supandi@pgn.co.id			SATKER6001239	20171204103705
EMP6001766	0012832649	Afan  Azrullah	Afan.Azrullah@pgn.co.id			SATKER6001239	20171204103705
EMP6001767	1092681481	Ana  Untari	Ana.Untari@pgn.co.id			SATKER6001239	20171204103705
EMP6001768	2487651123	Ahmad  Nasukha	Ahmad.Nasukha@pgn.co.id			SATKER6001239	20171204103705
EMP6001769	1092681478	Abdul Azis Syahroni	Abdul.Syahroni@pgn.co.id			SATKER6001238	20171204103705
EMP6001770	1096771620	Sigit  Prayitno	Sigit.Prayitno@pgn.co.id		ORG6000813		20171204103705
EMP6001771	0007802280	Kokoh  Parlindungan	Kokoh.Parlindungan@pgn.co.id	081314017301	ORG6000399	SATKER6001244	20171204103705
EMP6001772	0007792274	Yosa Arfika Naim	Yosa.Naim@pgn.co.id	02518655659	ORG6000543		20171204103705
EMP6001773	0089681350	Anak Agung Raka Haryana	Raka.Haryana@pgn.co.id	0218212460	ORG6001127	SATKER6001252	20171204103705
EMP6001774	0014932759	M. Punky  Khoirrudin	Punky.Khoirruddin@pgn.co.id			SATKER6001234	20171204103705
EMP6001775	0010882606	Reza  Trisulistiawan	Reza.Trisulistiawan@pgn.co.id		ORG6000729	SATKER6001243	20171204103705
EMP6001776	0012802645	Moh. Ade Iqbal	Ade.Iqbal@pgn.co.id		ORG6000733	SATKER6001243	20171204103705
EMP6001777	1007862227	Ferry Ahmad Nurjaman	Ferry.Nurjaman@pgn.co.id		ORG6000730	SATKER6001243	20171204103705
EMP6001778	0009862398	Arfan Agung Nugroho	Arfan.Nugroho@pgn.co.id		ORG6000976	SATKER6001211	20171204103705
EMP6001779	0010852431	Eko Yohannes Lumbanraja	Eko.Yohannes@pgn.co.id		ORG6000570	SATKER6001211	20171204103705
EMP6001780	0017962795	Yumna Anindya Pangesti	Yumna.Pangesti@pgn.co.id		ORG6001203	SATKER6001210	20171204103705
EMP6001781	1008872366	Hapiz  Maulana	Hapiz.Maulana@pgn.co.id	0254381503	ORG6000254	SATKER6001225	20171204103705
EMP6001782	0014922757	Okky Putra Arganata	Okky.Arganata@pgn.co.id		ORG6000292	SATKER6001226	20171204103705
EMP6001783	1686651048	  Badaria	Badaria@pgn.co.id		ORG6000835	SATKER6001245	20171204103705
EMP6001784	3007872251	Hakim Gunawan Lumban Tobing	Hakim.Tobing@pgn.co.id		ORG6000930	SATKER6001213	20171204103705
EMP6001785	3007732258	Rommel  Simanjuntak	Rommel.Simanjuntak@pgn.co.id	008117537073	ORG6001105	SATKER6001218	20171204103705
EMP6001786	3007862259	Roni  Wibowo	Roni.Wibowo@pgn.co.id	082161076894	ORG6001106	SATKER6001218	20171204103705
EMP6001787	0010872469	Ary  Budiman	Ary.Budiman@pgn.co.id		ORG6000614	SATKER6001220	20171204103705
EMP6001788	0010872456	Zetra  Adhiarsih	Zetra.Adhiarsih@pgn.co.id		ORG6000626	SATKER6001220	20171204103705
EMP6001789	0010862579	Yudi  Adhiwidodo	Yudi.Widodo@pgn.co.id		ORG6000628	SATKER6001220	20171204103705
EMP6001790	1008822351	Deasy  Chairunnisa	Deasy.Chairunnisa@pgn.co.id		ORG6000424	SATKER6001216	20171204103705
EMP6001791	0095671595	Dedy  Riady	Dedy.Riady@pgn.co.id		ORG6000897	SATKER6001218	20171204103705
EMP6001792	1588621271	  Juarsa	Juarsa@pgn.co.id		ORG6000932	SATKER6001218	20171204103705
EMP6001793	3089651296	  Ridwan	ridwan@pgn.co.id		ORG6001066	SATKER6001252	20171204103705
EMP6001794	0013922752	Aulia Dwi Ayu Palupi	Aulia.Palupi@pgn.co.id		ORG6001040	SATKER6001211	20171204103705
EMP6001795	0012902729	Arief Rachman Amrulloh	Arief.Amrulloh@pgn.co.id		ORG6000912	SATKER6001213	20171204103705
EMP6001796	0010842415	Nofi Erik Fianto	Nofi.Erik@pgn.co.id	085693476603	ORG6000216	SATKER6001224	20171204103705
EMP6001797	0010882608	Ferianto Isak Mukti Wibowo	Ferianto.Wibowo@pgn.co.id		ORG6000218	SATKER6001224	20171204103705
EMP6001798	0099662183	  Baryadi	Baryadi@pgn.co.id		ORG6000284	SATKER6001226	20171204103705
EMP6001799	2007832234	Hendy Prima Kurniawan	Hendy.Kurniawan@pgn.co.id		ORG6000401	SATKER6001227	20171204103705
EMP6001800	2007832233	Denny  Hariyanto	Denny.Hariyanto@pgn.co.id	0811335621	ORG6000266	SATKER6001255	20171204103705
EMP6001801	1005842048	Dhitta Ayu Maulidya	Dhitta.Maulidya@pgn.co.id		ORG6000633	SATKER6001219	20171204103705
EMP6001802	0002711857	Hertyasmawan Ery Fitradi	Hertyasmawan.Fitradi@pgn.co.id	08170073457	ORG6000999		20171204103705
EMP6001803	0088631252	Heri  Yusup	Heri.Yusup@pgn.co.id	08159189181	ORG6000132		20171204103705
EMP6001804	0004791968	Muhammad  Hardiansyah	Muhammad.Hardiansyah@pgn.co.id	007666	ORG6001155	SATKER6001211	20171204103705
EMP6001805	0004791964	Wahyu  Wijaya	Wahyu.Wijaya@pgn.co.id	08113210505	ORG6000587	SATKER6001211	20171204103705
EMP6001806	0004801942	Adam Nur Bawono	Adam.Bawono@pgn.co.id	0811001291234	ORG6000108	SATKER6001211	20171204103705
EMP6001807	0097701691	Baskara Agung Wibawa	Baskara.Wibawa@pgn.co.id	0818154342	ORG6000195		20171204103705
EMP6001808	3097781728	Aldiansyah  Idham	Aldiansyah.Idham@pgn.co.id	02810040082	ORG6000467	SATKER6001229	20171204103705
EMP6001809	2099731741	Anisyah  Roestantien	Anisyah.Roestantien@pgn.co.id	0215549980	ORG6000204		20171204103705
EMP6001810	0001751814	Sheila  Merlianty	Sheila.Merlianty@pgn.co.id	08161167525	ORG6000141	SATKER6001230	20171204103705
EMP6001811	0089621340	  Wibowo	Wibowo@pgn.co.id	08158065100	ORG6000345		20171204103705
EMP6001812	0099721773	Suhaini Muhamad Aslamayani	Suhaini.Aslamayani@pgn.co.id	02154204530	ORG6000858	SATKER6001211	20171204103705
EMP6001813	0088631257	Danu  Kusumo	Danu.Kusumo@pgn.co.id	081410054457	ORG6000423	SATKER6001218	20171204103705
EMP6001814	1092631490	  Sugito	Sugito@pgn.co.id	08111983660	ORG6000379	SATKER6001244	20171204103705
EMP6001815	0098731735	Edi  Armawiria	Edi.Armawiria@pgn.co.id	0811966415	ORG6000159	SATKER6001213	20171204103705
EMP6001816	0005822097	Febri Mohammad Kautsar	Febri.Kautsar@pgn.co.id	081325795170	ORG6000616	SATKER6001220	20171204103705
EMP6001817	0005812084	Yenni Ratna Kusumadewi	Yenni.Dewi@pgn.co.id		ORG6000541	SATKER6001252	20171204103705
EMP6001818	1005842043	Hernita  Pratiwi Setyani	Hernita.Setyani@pgn.co.id	0008111334028	ORG6000245	SATKER6001223	20171204103705
EMP6001819	0005792063	Rinaldi Jan Darmawan Purba	Rinaldi.Purba@pgn.co.id	08157948811	ORG6000623		20171204103705
EMP6001820	0001771836	Erli  Soemarliana	Erli.Soemarliana@pgn.co.id	02174717947	ORG6000646	SATKER6001220	20171204103705
EMP6001821	0088681166	Bambang  Purwanto	Bambang.Purwanto@pgn.co.id	0811840853	ORG6000257	SATKER6001226	20171204103705
EMP6001822	1588641276	Elda  Sutarda	Elda.Sutarda@pgn.co.id	081136530190	ORG6000180	SATKER6001213	20171204103705
EMP6001823	2096751654	Agus Mustofa Hadi	Agus.Hadi@pgn.co.id	0816015000323	ORG6000246		20171204103705
EMP6001824	3097761722	Wendi  Purwanto	Wendi.Purwanto@pgn.co.id	08126024076	ORG6000238	SATKER6001213	20171204103705
EMP6001825	0005792066	Sulthani Adil Mangatur	sulthani.adil@pgn.co.id	10060186	ORG6000524	SATKER6001233	20171204103705
EMP6001826	0099731784	Boby  Susilo	Boby.Susilo@pgn.co.id	081386114545	ORG6000382	SATKER6001234	20171204103705
EMP6001827	0003721875	Marie Siti Mariana Massie	Marie.Massie@pgn.co.id	0214721544			20171204103705
EMP6001828	0003771887	Ali  Fahrudin	Ali.Fahrudin@pgn.co.id	02517171671	ORG6000369		20171204103705
EMP6001829	0004801969	Hendra  Halim	Hendra.Halim@pgn.co.id	+628119304146	ORG6000383	SATKER6001209	20171204103705
EMP6001830	0004781927	Eva  Ameilia	Eva.Ameilia@pgn.co.id	0815861188990	ORG6000902	SATKER6001213	20171204103705
EMP6001831	1088631179	Dedih  Supriadi	Dedih.Supriadi@pgn.co.id	533705	ORG6000673	SATKER6001211	20171204103705
EMP6001832	0004771922	Ridian  Junata	Ridian.Junata@pgn.co.id	081213634434	ORG6000833	SATKER6001221	20171204103705
EMP6001833	0005812131	Rhomy Adhy Prastiyo	Rhomy.Prastiyo@pgn.co.id	08129879613	ORG6000202	SATKER6001224	20171204103705
EMP6001834	2589631364	  Ridwan	Ridwan.Hasan@pgn.co.id	087872100010	ORG6000273	SATKER6001226	20171204103705
EMP6001835	1005822168	Mikael Wiedia Dwiarka	Mikael.Utomo@pgn.co.id	08118117872	ORG6000350		20171204103705
EMP6001836	0010872526	  Suprapto	Suprapto@pgn.co.id	085789387086	ORG6000865	SATKER6001211	20171204103705
EMP6001837	0010882541	Karlina Mustika Destianti	Karlina.Destianti@pgn.co.id	08568108690	ORG6001025	SATKER6001216	20171204103705
EMP6001838	0003771888	Riko Teguh Setio Wibisono	riko.wibisono@pgn.co.id	0315967291	ORG6000454	SATKER6001251	20171204103705
EMP6001839	0010852513	Wening Ngesthi Darmastuti	Weningesthi@pgn.co.id	08111000610	ORG6000072	SATKER6001211	20171204103705
EMP6001840	0010842504	Titis  Wulandari	Titis.Wulandari@pgn.co.id	93546619	ORG6000791	SATKER6001218	20171204103705
EMP6001841	0095671573	Achmad  Fahruzaman	Achmad.Fahruzaman@pgn.co.id	0855.9902567	ORG6000592	SATKER6001211	20171204103705
EMP6001842	0005802122	Erny  Sugiarti	Erny.Sugiarti@pgn.co.id	08129932377	ORG6001046	SATKER6001236	20171204103705
EMP6001843	1583620932	Rita  Yulianita	Rita.Yulianita@pgn.co.id	081210002917	ORG6000185	SATKER6001221	20171204103705
EMP6001844	2096751685	Ririn Novi Purwanti	Ririn.Purwanti@pgn.co.id	081332412491	ORG6000663	SATKER6001227	20171204103705
EMP6001845	2096721673	Mai  Setiyono	Mai.Setiyono@pgn.co.id	082131816808	ORG6000891	SATKER6001211	20171204103705
EMP6001846	0010862590	Tia  Restyani	tia.restyani@pgn.co.id	085723624778	ORG6000834	SATKER6001213	20171204103705
EMP6001847	1092701484	Eddy  Slamet	Eddy.Slamet@pgn.co.id	08881783466	ORG6000248	SATKER6001225	20171204103705
EMP6001848	2096731675	Eko  Suprayitno	Eko.Suprayitno@pgn.co.id	+6281615103073	ORG6000323	SATKER6001213	20171204103705
EMP6001849	0017862788	Rista Rama Dhany	rista.dhany@pgn.co.id		ORG6001056	SATKER6001248	20171204103705
EMP6001850	0010862583	Rahmi  Nuzuliyah	Rahmi.Nuzuliyah@pgn.co.id	081230839228	ORG6000418	SATKER6001251	20171204103705
EMP6001851	0005832155	Aulia  Parmawati	Aulia.Parmawati@pgn.co.id	081615403699	ORG6001068	SATKER6001252	20171204103705
EMP6001852	1008832354	Agung Tri Kuncoro Wicaksono	Agung.Wicaksono@pgn.co.id	0811837151	ORG6001157	SATKER6001211	20171204103705
EMP6001853	3097741716	Azhar  Wijaya	Azhar.Wijaya@pgn.co.id	8126050585	ORG6000535	SATKER6001252	20171204103705
EMP6001854	0011902633	  Zulkarnaen	zulkarnaen.2633@pgn.co.id	08116004064	ORG6000407	SATKER6001244	20171204103705
EMP6001855	0009852390	Soesatyo Bimo Tri Amboro	Bimo.Amboro@pgn.co.id	08111859645	ORG6000687	SATKER6001234	20171204103705
EMP6001856	0012882698	Gilang  Hermawan	Gilang.Hermawan@pgn.co.id	085640427883	ORG6000274	SATKER6001255	20171204103705
EMP6001857	2096751684	Agung Rochman Solichi	Agung.Solichi@pgn.co.id	031.7496901	ORG6000083	SATKER6001211	20171204103705
EMP6001858	3007802242	Tengku Rifki Fauzan	Tengku.Fauzan@pgn.co.id	+62811603578	ORG6001137	SATKER6001236	20171204103705
EMP6001859	0010852561	Rini Meilani Munthe	Rini.Meilany@pgn.co.id	081397883030	ORG6000451	SATKER6001218	20171204103705
EMP6001860	0009782380	I Made Yudi Artama	Made.Artama@pgn.co.id	08117209996	ORG6000154	SATKER6001253	20171204103705
EMP6001861	0010852558	Nurhadi  Sujatmoko	Nurhadi.Sujatmoko@pgn.co.id	081553004223	ORG6000763	SATKER6001222	20171204103705
EMP6001862	0010852577	Tri  Hartanti	Tri.Hartanti@pgn.co.id	81807473785	ORG6000784	SATKER6001234	20171204103705
EMP6001863	2007822231	Setyo Deny Hudaya	Setyo.Hudaya@pgn.co.id	081331377838	ORG6000894	SATKER6001211	20171204103705
EMP6001864	0086611053	Hermin  Indayati	Hermin.Indayati@pgn.co.id	442774	ORG6001000		20171204103705
EMP6001865	1096741612	Muhamad  Samhan	Muhammad.Samhan@pgn.co.id	021-7550946	ORG6000405	SATKER6001244	20171204103705
EMP6001866	1086621009	Richard  Hamelberg	Richard.Hamelberg@pgn.co.id	08159701462	ORG6000276	SATKER6001223	20171204103705
EMP6001867	1582630916	Damar  Riyanti	Damar.Riyanti@pgn.co.id	08158207070	ORG6001135	SATKER6001221	20171204103705
EMP6001868	1096751616	Liestya Heryani Devi	Liestya.Devi@pgn.co.id	08116000348	ORG6000212	SATKER6001213	20171204103705
EMP6001869	0007812286	Fitria Agristina Wijaya	Fitria.Wijaya@pgn.co.id	.08119208089	ORG6001085	SATKER6001230	20171204103705
EMP6001870	0099731778	M  Alfiannor	M.Alfiannor@pgn.co.id	08111925473	ORG6000480	SATKER6001240	20171204103705
EMP6001871	0005822145	Nanny  Atika	Nanny.Atika@pgn.co.id	08127117292	ORG6000859	SATKER6001211	20171204103705
EMP6001872	0006772176	Ronald Andre P Hutagalung	Ronald.Hutagalung@sakaenergi.co.id	008118207094			20171204103705
EMP6001873	2099781759	  Sunardi	Sunardi.1759@pgn.co.id	081133010520	ORG6000749	SATKER6001222	20171204103705
EMP6001874	1092651468	  Marijo	Marijo@pgn.co.id	08111633378	ORG6000252	SATKER6001213	20171204103705
EMP6001875	0005792067	Yosephine Ina Sabrina	Yosephine.Ina@pgn.co.id	0811-806064	ORG6000900	SATKER6001211	20171204103705
EMP6001876	0004801945	Bayu  Kusumanto	Bayu.Kusumanto@pgn.co.id	08979048956	ORG6000152	SATKER6001253	20171204103705
EMP6001877	0005812090	Aris  Nugroho	Aris.Nugroho@pgn.co.id	081586086250		SATKER6001211	20171204103705
EMP6001878	0004781929	Eka Hari Setiawan	Eka.Setiawan@pgn.co.id	0811 6072 378	ORG6001033	SATKER6001211	20171204103705
EMP6001879	0005802124	Setifana Bambang Pranowo	Setifana.Pranowo@pgn.co.id	081111.62416	ORG6000670	SATKER6001211	20171204103705
EMP6001880	0007802276	Sulis  Indriyanto	Sulis.Indriyanto@pgn.co.id	08982 111 000	ORG6000569	SATKER6001211	20171204103705
EMP6001881	0005772054	Sigit  Dewantoro	Sigit.Dewantoro@pgn.co.id	0811132023	ORG6000110	SATKER6001211	20171204103705
EMP6001882	0005792068	Eka  Perkasa	Eka.Perkasa@pgn.co.id	081122732266	ORG6001098	SATKER6001234	20171204103705
EMP6001883	3089651295	Rommel  Manurung	Rommel.Manurung@pgn.co.id	007787375082	ORG6000773		20171204103705
EMP6001884	0001741811	Fri  Wazanati	Fri.Wazanati@pgn.co.id	82516964	ORG6000098	SATKER6001211	20171204103705
EMP6001885	0099731780	Dhian  Widuri	Dhian.Widuri@pgn.co.id	08118714777	ORG6000884	SATKER6001211	20171204103705
EMP6001886	0012882693	Awang  Bhaswara	Awang.Bhaswara@pgn.co.id	08113031050	ORG6000901	SATKER6001211	20171204103705
EMP6001887	0013912747	Tika Rianna Iswardhani	Tika.Iswardhani@pgn.co.id		ORG6000738	SATKER6001243	20171204103705
EMP6001888	0010892543	Romario  Drajad	romario@pgn.co.id	087711245275	ORG6001143		20171204103705
EMP6001889	0004701951	Ridha  Ababil	Ridha.Ababil@pgn.co.id	08119305646	ORG6001029		20171204103705
EMP6001890	0088631149	Djoko  Suripto	Djoko.Suripto@pgn.co.id	02187753694	ORG6001128	SATKER6001208	20171204103705
EMP6001891	0088631253	  Mugiono	Mugiono@pgn.co.id	08121053650	ORG6001092		20171204103705
EMP6001892	0014662755	Ivanna Laksmini Devi	Ivanna.Devi@pgn.co.id	08161807800		SATKER6001249	20171204103705
EMP6001893	0014732756	Shirley  Shinta	Shirley.Shinta@pgn.co.id	082110010024			20171204103705
EMP6001894	0097711692	Eri Surya Kelana	Eri.Kelana@sakaenergi.co.id	08170002202			20171204103705
EMP6001895	0088641265	Dedi  Suryadinata	Dedi.Suryadinata@pgn.co.id	0122118202066			20171204103705
EMP6001896	0089681348	Hartati  Sulistyowati	hartati.sulistyowati@pgn.co.id	0813089410662			20171204103705
EMP6001897	0094661523	  Muklis	Muklis@pgn.co.id	0811 1898 437		SATKER6001239	20171204103705
EMP6001898	0001751819	Enro  Situmorang	Enro.Situmorang@pgn.co.id	081332582540			20171204103705
EMP6001899	0004771955	Ita  Nalurita	Ita.Nalurita@pgn.co.id			SATKER6001239	20171204103705
EMP6001900	0096691634	Talhah Tamia Shahab	Talhah.Tamia@pgn.co.id	08111-049264		SATKER6001211	20171204103705
EMP6001901	0001761830	Achmad  Junaidi	Achmad.Junaidi@pgn.co.id	0811118756		SATKER6001239	20171204103705
EMP6001902	0003761885	Trisaksana  Nugroho	Trisaksana.Nugroho@pgn.co.id			SATKER6001239	20171204103705
EMP6001903	0004781925	Donna Hasibuan Lumban Tobing	Donna.Tobing@pgn.co.id	081220054230			20171204103705
EMP6001904	0004811974	Azhar  Habieb	Azhar.Habieb@pgn.co.id	0218044475			20171204103705
EMP6001905	0005802082	Iqbal  Fuady	Iqbal.Fuady@pgn.co.id	081315441607		SATKER6001239	20171204103705
EMP6001906	0097721705	Retno Sri Setiyastiti	retno.sri@pgn.co.id	08129933264			20171204103705
EMP6001907	2001791849	Agus  Hermawan	Agus.Hermawan@pgn.co.id	08113636010		SATKER6001216	20171204103705
EMP6001908	2096731676	  Sucipto	Sucipto@pgn.co.id	08123215953		SATKER6001239	20171204103705
EMP6001909	0007822290	Novi Firmansyah Koswara	Novi.Koswara@pgn.co.id			SATKER6001239	20171204103705
EMP6001910	0007842321	Abdul  Rosyid	Abdul.Rosyid@pgn.co.id			SATKER6001239	20171204103705
EMP6001911	0010812404	Tomi Dian Putra	Tomi.Dian@pgn.co.id			SATKER6001211	20171204103705
EMP6001912	1096721607	Septodita Musfa Sabi	Septodita@pgn.co.id	08159031486		SATKER6001239	20171204103705
EMP6001913	1596721641	Hari Mukhamad Al Fitrah	Hari.Fitrah@pgn.co.id	71469111		SATKER6001239	20171204103705
EMP6001914	0005812088	Moh  Nur Alim	Nur.Alim@pgn.co.id				20171204103705
EMP6001915	0094711542	Taat  Udjianto	Taat.Udjianto@pgn.co.id	081510618997		SATKER6001218	20171204103705
EMP6001916	3089661301	Dewi  Rusdianti	Dewi.Rusdianti@pgn.co.id	08116182934			20171204103705
EMP6001917	0007882273	Agung Dwi Hasdianto	Agung.Hasdianto@pgn.co.id			SATKER6001239	20171204103705
EMP6001918	0009832381	Arif  Istiadi	Arif.Istiadi@pgn.co.id			SATKER6001239	20171204103705
EMP6001919	0010852425	Feri Dwi Yuliandani	Feri.Yuliandani@pgn.co.id			SATKER6001239	20171204103705
EMP6001920	0010852427	Ilham  Anjaryadi	Ilham.Anjaryadi@pgn.co.id			SATKER6001239	20171204103705
EMP6001921	0010882612	Moch. Asrul Afrizal	Moch.Afrizal@pgn.co.id			SATKER6001239	20171204103705
EMP6001922	1005812046	Zul  Amri	Zul.Amri@pgn.co.id	087896095937			20171204103705
EMP6001923	1008852360	Arief  Marzuki	Arief.Marzuki@pgn.co.id	085697720288		SATKER6001253	20171204103705
EMP6001924	0010852430	Tunggul  Wijayasakti	Tunggul.Wijayasakti@pgn.co.id				20171204103705
EMP6001925	0004631998	John Helmon Manurung	John.Helmon@pgn.co.id			SATKER6001239	20171204103705
EMP6001926	0009862397	Henki  Rizuliyanta	Henki.Rizuliyanta@pgn.co.id			SATKER6001239	20171204103705
EMP6001927	0012892703	Danang Kusumahadi Wardana	Danang.Wardana@pgn.co.id			SATKER6001239	20171204103705
EMP6001928	0096661664	Asep  Suwarsa	Asep.Suwarsa@pgn.co.id			SATKER6001218	20171204103705
EMP6001929	1088631178	Victor L. Kolin	Victor.Kolin@pgn.co.id			SATKER6001239	20171204103705
EMP6001930	1096711601	  Isnandar	Isnandar@pgn.co.id			SATKER6001239	20171204103705
EMP6001931	1583620938	  Jayadi	Jayadi@pgn.co.id			SATKER6001239	20171204103705
EMP6001932	1693621506	  Kartono	Kartono@pgn.co.id			SATKER6001239	20171204103705
EMP6001933	0089661409	Rachmat  Gunawan	Rachmat.Gunawan@pgn.co.id			SATKER6001239	20171204103705
EMP6001934	0092691436	Hermansyah  Cahaya	Hermansyah.Cahaya@pgn.co.id			SATKER6001218	20171204103705
EMP6001935	1096711605	  Supardi	supardi1605@pgn.co.id			SATKER6001239	20171204103705
EMP6001936	3089691383	  Amril	Amril@pgn.co.id			SATKER6001239	20171204103705
EMP6001937	2087661094	Yuniar Heru Yuwono	Yuniar.Yuwono@pgn.co.id			SATKER6001238	20171204103705
EMP6001938	2589641368	  La Budi	Labudi@pgn.co.id			SATKER6001218	20171204103705
EMP6001939	0005812143	Aditya Damawan M. P.	aditya.damawan@pgn.co.id	081513023836	ORG6001049		20171204103705
EMP6001940	0099691765	Yohanes Eka Sujana	Yohanes.Sujana@pgn.co.id	085880020056	ORG6000526		20171204103705
EMP6001941	0007822297	Suryadi  Wijaya	Suryadi.Wijaya@pgn.co.id	02177841862	ORG6000698		20171204103705
EMP6001942	0001761828	M. Andi  Irawan	andi.irawan@pgn.co.id	08176883571	ORG6001048	SATKER6001251	20171204103705
EMP6001943	0005782058	Kurnia Setio Wibowo	Kurnia.Wibowo@pgn.co.id	081310428652	ORG6000104	SATKER6001211	20171204103705
EMP6001944	0008692379	Muhammad Wahid Sutopo	wahid.sutopo@pgn.co.id	0816101206			20171204103705
EMP6001945	0012902722	Achmad  Afandi	Achmad.Afandi@pgn.co.id		ORG6000574	SATKER6001217	20171204103705
EMP6001946	0016942779	Oktavino Asri Wijaya	Oktavino.Wijaya@pgn.co.id			SATKER6001216	20171204103705
EMP6001947	0015942770	Marchia Devi Aryatni Legansi	Marchia.Legansi@pgn.co.id		ORG6000683	SATKER6001244	20171204103705
EMP6001948	0014932765	Mochamad Zulfan Fauzi	Zulfan.Fauzi@pgn.co.id	085223939156	ORG6000165	SATKER6001213	20171204103705
EMP6001949	0011902636	Syukron  Arisona	syukron.arisona@pgn.co.id		ORG6000826	SATKER6001213	20171204103705
EMP6001950	0013922750	Elni  Verawati	Elni.Verawati@pgn.co.id	0721-7694306	ORG6000302	SATKER6001235	20171204103705
EMP6001951	0010852560	Metya Dwi Putri Marsetiana	Metya.Dwi@pgn.co.id		ORG6000289	SATKER6001255	20171204103705
EMP6001952	2007832260	Faisal Resa Imahendra	Faishal.Imahendra@pgn.co.id	081938505665	ORG6000845	SATKER6001213	20171204103705
EMP6001953	3007852248	  Rodiah	Rodiah@pgn.co.id		ORG6000825	SATKER6001215	20171204103705
EMP6001954	0010882614	Parlin  Simatupang	Parlin.Simatupang@pgn.co.id	0819232730	ORG6000457	SATKER6001251	20171204103705
EMP6001955	0010852420	Miftakh Arkhan Zein Taptozani	Miftakh.Zein@pgn.co.id		ORG6000441	SATKER6001251	20171204103705
EMP6001956	0012892707	Achmad  Firdaus	Achmad.Firdaus@pgn.co.id		ORG6000650	SATKER6001236	20171204103705
EMP6001957	1007842254	Devy Puspasari Siswaningrum	Devy.Siswaningrum@pgn.co.id		ORG6000048	SATKER6001218	20171204103705
EMP6001958	0096711648	  Irwan	Irwan@pgn.co.id	0811819600	ORG6001070	SATKER6001219	20171204103705
EMP6001959	0012892709	Anisya  Nesiyanti	Anisya.Nesiyanti@pgn.co.id		ORG6000426	SATKER6001216	20171204103705
EMP6001960	3007812243	Ahmadsyah  Nasution	Ahmadsyah.Nasution@pgn.co.id	0811756718	ORG6001074	SATKER6001218	20171204103705
EMP6001961	0015952776	Denita Hersaktiningtyas Ramapuspasari	Denita.Ramapuspasari@pgn.co.id		ORG6000807		20171204103705
EMP6001962	0012902728	Aji  Darmawan	Aji.Darmawan@pgn.co.id		ORG6000780		20171204103705
EMP6001963	3007872250	  Syahputra	Syahputra@pgn.co.id		ORG6000968	SATKER6001234	20171204103705
EMP6001964	0011902630	Dea  Amelia	dea.amelia@pgn.co.id		ORG6000786		20171204103705
EMP6001965	1092681476	Yetti  Supartini	Yetti.Supartini@pgn.co.id		ORG6000830	SATKER6001223	20171204103705
EMP6001966	0010852562	Muchamad Purbotejo Lelono	Muchamad.Purbotejo@pgn.co.id		ORG6000199	SATKER6001245	20171204103705
EMP6001967	0010852556	Eva Yanti Tambunan	Eva.Tambunan@pgn.co.id	085270855168	ORG6000404	SATKER6001227	20171204103705
EMP6001968	2099761751	Wawan  Pujiono	Wawan.Pujiono@pgn.co.id		ORG6000271	SATKER6001255	20171204103705
EMP6001969	2099791760	Arif  Wijaya	Arif.Wijaya@pgn.co.id		ORG6000925	SATKER6001213	20171204103705
EMP6001970	3089641366	Edi  Santoso	Edi.Santoso@pgn.co.id	081361665992	ORG6000321	SATKER6001215	20171204103705
EMP6001971	1007842225	Nur Afni Indah Sari	Nur.Indah.S@pgn.co.id		ORG6000635	SATKER6001219	20171204103705
EMP6001972	1008812374	Irfan  Kurniawan	Irfan.Kurniawan@pgn.co.id	08113334514	ORG6000473	SATKER6001229	20171204103705
EMP6001973	0001771835	  Amanarita	Amanarita@pgn.co.id	08128189364	ORG6000553	SATKER6001254	20171204103705
EMP6001974	0004731953	Erwin CH Simandjuntak	Erwin.Simandjuntak@pgn.co.id	0811.8811199	ORG6001172	SATKER6001211	20171204103705
EMP6001975	0008752376	Muhammad Irwan Santoso	irwan.santoso@pgn.co.id	0811200331	ORG6000410		20171204103705
EMP6001976	0096711638	Santiaji  Gunawan	Santiaji.Gunawan@pgn.co.id	02184310245	ORG6001082	SATKER6001229	20171204103705
EMP6001977	0005802081	Andi Krishna Arinaldi	Andi.Arinaldi@pgn.co.id	08119202730	ORG6000347		20171204103705
EMP6001978	0003771890	Laura  Gultom	Laura.Gultom@pgn.co.id	0218648359	ORG6000210	SATKER6001216	20171204103705
EMP6001979	3089641292	  Kastam	Kastam@pgn.co.id	08116000463	ORG6000647	SATKER6001236	20171204103705
EMP6001980	0099741788	Chandra Putra Imanuel Simarmata	Chandra.Simarmata@pgn.co.id	08111742193	ORG6000615		20171204103705
EMP6001981	0011652627	Rozani  Ismail	Rozani.Ismail@pgn.co.id	081585495872	ORG6000593		20171204103705
EMP6001982	0099731779	Rangga  Radji	Rangga.Radji@pgn.co.id	000811167151	ORG6000723	SATKER6001234	20171204103705
EMP6001983	0089621330	Willy  Roswaldi	Willy.Roswaldi@pgn.co.id	08170843189	ORG6001094	SATKER6001240	20171204103705
EMP6001984	0088611157	  Suprijanti	suprijanti@pgn.co.id	00816936794	ORG6000420	SATKER6001218	20171204103705
EMP6001985	0089681351	  Arniwaty	Arniwaty@pgn.co.id	02186606354	ORG6000632	SATKER6001219	20171204103705
EMP6001986	0010872530	Septi  Mulyani	Septi.mulyani@pgn.co.id		ORG6000612	SATKER6001220	20171204103705
EMP6001987	0012872683	Md.Ilham  Negara H	Ilham.Negara@pgn.co.id	08111091710	ORG6000601		20171204103705
EMP6001988	2099761747	Nur  Kholis	Nur.Kholis@pgn.co.id	08113530537	ORG6000851	SATKER6001213	20171204103705
EMP6001989	3089671306	Chandrawati  Kusumayekti	Chandrawati.K@pgn.co.id	08126063025	ORG6000341		20171204103705
EMP6001990	0007822296	Ocktavianus Lede Mude Ragawino	Oktavianus.Ragawino@pgn.co.id	08122003358	ORG6000137	SATKER6001249	20171204103705
EMP6001991	0003801912	Budi  Priswanto	Budi.Priswanto@pgn.co.id	08113549137	ORG6000909	SATKER6001209	20171204103705
EMP6001992	0092681493	Etiko  Kusjatmiko	etiko.kusjatmiko@pgn.co.id	0218215438	ORG6000478	SATKER6001240	20171204103705
EMP6001993	0099721768	Heni  Mahmudah	Heni.Mahmudah@pgn.co.id	08111.921.915	ORG6000588	SATKER6001211	20171204103705
EMP6001994	0096671627	Endah  Pramonosari	Endah.Pramonosari@pgn.co.id	021.8726053	ORG6000116	SATKER6001211	20171204103705
EMP6001995	0097701698	  Afdal	Afdal@pgn.co.id	0811145654	ORG6001118	SATKER6001213	20171204103705
EMP6001996	1096731608	  Kardiyanta	Kardiyanta@pgn.co.id	08118160437	ORG6000288	SATKER6001226	20171204103705
EMP6001997	0010802497	Foury  Krisyunanto	Foury.Krisyunanto@pgn.co.id	08119009099	ORG6000373		20171204103705
EMP6001998	0010882535	Novita  Hidayati	Novita.Hidayati@pgn.co.id	081314470150	ORG6001022	SATKER6001216	20171204103705
EMP6001999	0095721585	Janter Halasan Simanjuntak	janter.halasan@pgn.co.id	08551122328	ORG6000856	SATKER6001211	20171204103705
EMP6002000	0010852515	Dyah  Nurhayati	Dyah.Nurhayati@pgn.co.id	08158268585	ORG6000430	SATKER6001218	20171204103705
EMP6002001	0004782011	Dodo  Darsono	Dodo.Darsono@pgn.co.id	11700481	ORG6000699	SATKER6001252	20171204103705
EMP6002002	1008852361	  Muharijal	Muharijal@pgn.co.id	0081541552000	ORG6000907	SATKER6001213	20171204103705
EMP6002003	0006782177	Tito  Bintoro	Tito.Bintoro@pgn.co.id	081311455411	ORG6001052	SATKER6001213	20171204103705
EMP6002004	3089661300	  Yusmawati	Yusmawati@pgn.co.id	8116142207	ORG6000310	SATKER6001215	20171204103705
EMP6002005	3007842246	Ahmad  Abrar	Ahmad.Abrar@pgn.co.id	008117721069	ORG6000355	SATKER6001213	20171204103705
EMP6002006	0001741810	Mona  Veronika	Mona.Veronika@pgn.co.id	0818-02072408	ORG6000996	SATKER6001218	20171204103705
EMP6002007	0005812095	Mukhamad Rifai Sidi	Mukhamad.Sidi@pgn.co.id	08135416117	ORG6000990	SATKER6001235	20171204103705
EMP6002008	2096771687	Suseno  Salim	Suseno.Salim@pgn.co.id	08113549996	ORG6001160	SATKER6001211	20171204103705
EMP6002009	0010842509	Abdur  Rasyid	Abdur.rasyid@pgn.co.id	081802748582	ORG6001039	SATKER6001211	20171204103705
EMP6002010	0007882269	Mochammad Haryo Pramantyo	Haryo.Pramantyo@pgn.co.id	081214466614	ORG6000385	SATKER6001234	20171204103705
EMP6002011	0007882270	Karisnda  Rahmadani	Karisnda.Rahmadani@pgn.co.id	081385773017	ORG6000684	SATKER6001234	20171204103705
EMP6002012	0012912732	Mahda Mega Andyka Hieguyta	Mahda.Andyka@pgn.co.id	082217659800	ORG6000731	SATKER6001243	20171204103705
EMP6002013	1092631458	Eddy  Syafianto	Eddy.Syafianto@pgn.co.id	0811841549	ORG6000259	SATKER6001223	20171204103705
EMP6002014	1007822216	Rika  Narulita	Rika.Narulita@pgn.co.id	081218521182	ORG6000190	SATKER6001213	20171204103705
EMP6002015	0010812545	Hendrikusuma Bis Maya	Hendri.Kusuma@pgn.co.id	08127131225	ORG6000231	SATKER6001213	20171204103705
EMP6002016	1096761617	Endang  Suratna	Endang.Suratna@pgn.co.id	08111086976	ORG6000227	SATKER6001212	20171204103705
EMP6002017	2095761566	Totok  Eliyanto	Totok.Eliyanto@pgn.co.id	08113567414	ORG6000394	SATKER6001227	20171204103705
EMP6002018	2096711669	Rina Indra Wijayani	Rina.Wijayani@pgn.co.id	0811000330971	ORG6000389	SATKER6001227	20171204103705
EMP6002019	2099751745	Nurdiansa  Regnanto	Nurdiansa.Regnanto@pgn.co.id	081553008895	ORG6000270	SATKER6001255	20171204103705
EMP6002020	0013812743	Agus  Wibowo	Agus.Wibowo@pgn.co.id		ORG6000545		20171204103705
EMP6002021	0010852418	Tribowo  Kusherdianto	Tribowo.Kusherdianto@pgn.co.id	08119007711	ORG6000374		20171204103705
EMP6002022	0095721586	Elvira  Widosari	Elvira.Widosari@pgn.co.id	08158973958	ORG6000974	SATKER6001252	20171204103705
EMP6002023	0010852434	Hanafi  Prabowo	Hanafi.Prabowo@pgn.co.id	0811229396	ORG6000395	SATKER6001209	20171204103705
EMP6002024	2004842018	Eko  Sujarwadi	Eko.Sujarwadi@pgn.co.id	082140209944	ORG6000307	SATKER6001213	20171204103705
EMP6002025	0004732004	Heru Budi Setyawan	Heru.Setiawan@pgn.co.id	081290823497	ORG6001154	SATKER6001211	20171204103705
EMP6002026	0095751590	Joana Dyah Tinuk Darmayanti	Joana.Diah@pgn.co.id	081514526912	ORG6000147	SATKER6001253	20171204103705
EMP6002027	1096701599	Achmad  Syuhada	Achmad.Syuhada@pgn.co.id	081262928360	ORG6001146	SATKER6001211	20171204103705
EMP6002028	2099761753	Dwi Handoko Sandhi	Dwi.Sandhi@pgn.co.id	08113637825	ORG6001080	SATKER6001234	20171204103705
EMP6002029	0005812136	Salim Tribuana Wahyuni	Salim.Wahyuni@pgn.co.id	0811.2879.754	ORG6000127	SATKER6001211	20171204103705
EMP6002030	2007882239	Arie Indra Prasetya	Arie.Prasetya@pgn.co.id	081330525821	ORG6000084	SATKER6001211	20171204103705
EMP6002031	0004741954	Gita  Noviyanti	Gita.Noviyanti@pgn.co.id	08119937741	ORG6000558	SATKER6001254	20171204103705
EMP6002032	0097731707	Kemas Hasyim Azhari	Kemas.Azhari@pgn.co.id	08119892173	ORG6000556	SATKER6001254	20171204103705
EMP6002033	0092691451	  Saefudin	Saefudin@pgn.co.id	02184999914	ORG6000294	SATKER6001235	20171204103705
EMP6002034	0007832310	Raymond Sondang Maruli Tampubolon	Raymond.Tampubolon@pgn.co.id	08113548207	ORG6000462	SATKER6001214	20171204103705
EMP6002035	0005812130	Taufan  Zamzami	Taufan.Zamzami@pgn.co.id	08128100927	ORG6000352		20171204103705
EMP6002036	0092631496	Adia Purna Sulistia	Adia.Sulistya@pgn.co.id	081513701561	ORG6000452	SATKER6001251	20171204103705
EMP6002037	0005832109	Reza  Yusandi	Reza.Yusandi@pgn.co.id	081514126017	ORG6000417	SATKER6001251	20171204103705
EMP6002038	0005822102	  Fransiska	Fransiska@pgn.co.id	0812-9989415	ORG6000073	SATKER6001211	20171204103705
EMP6002039	0099721772	Tina  Lestari	Tina.Lestari@pgn.co.id	08118997373	ORG6001063	SATKER6001218	20171204103705
EMP6002040	0001771838	Adriyan Alexandra Gobel	Adriyan.Gobel@pgn.co.id	08119937715	ORG6000433	SATKER6001218	20171204103705
EMP6002041	0097721702	Diana  Legirorina	Diana.Legirorina@pgn.co.id	08121086867	ORG6000438	SATKER6001218	20171204103705
EMP6002042	0096681631	Efi  Muzdalifah	Efi.Muzdalifah@pgn.co.id	08111461068	ORG6000461	SATKER6001218	20171204103705
EMP6002043	0097701696	Yunita  Rakhmawati	yunita.rachmawati@pgn.co.id	08161.338183	ORG6000804	SATKER6001234	20171204103705
EMP6002044	0095731589	Aji Tunggul Purbomiluhung	Aji.Purbomiluhung@pgn.co.id	0811002618841	ORG6000798	SATKER6001234	20171204103705
EMP6002045	3097741715	  Rusliman	Rusliman@pgn.co.id	81397240441	ORG6000771	SATKER6001234	20171204103705
EMP6002046	2001791848	Braman  Setyoko	Braman.Setyoko@pgn.co.id	0816519884	ORG6000921	SATKER6001213	20171204103705
EMP6002047	2085620983	  Margiyanto	Margiyanto@pgn.co.id	0313732445	ORG6000261	SATKER6001255	20171204103705
EMP6002048	2096741680	Trio Dedy Kusuma	Trio.Kusuma@pgn.co.id	081231075258	ORG6001116	SATKER6001211	20171204103705
EMP6002049	2096751655	Achmad  Hidayat	achmad.hidayat@pgn.co.id	08113417483	ORG6001159	SATKER6001234	20171204103705
EMP6002050	2087651092	  Djanurianto	Djanurianto@pgn.co.id	081357485050	ORG6000768	SATKER6001222	20171204103705
EMP6002051	0005802121	Anang  Susanto	Anang.Susanto@pgn.co.id	081319787103	ORG6000715		20171204103705
EMP6002052	0012892705	Laelia  Afrisanthi	Laelia.Afrisanthi@pgn.co.id		ORG6000973	SATKER6001253	20171204103705
EMP6002053	0005832166	Ardita  Novianti	Ardita.Novianti@pgn.co.id		ORG6000364		20171204103705
EMP6002054	0004702001	Tridarty Rame Tulus Tambunan	Rame.Tambunan@pgn.co.id		ORG6001069	SATKER6001218	20171204103705
EMP6002055	0010842554	Rauminar  Estikasari	Rauminar.Estikasari@pgn.co.id		ORG6001149		20171204103705
EMP6002056	0086621055	Erning Laksmi Widyastuti	Erning.Laksmi@pgn.co.id	10492425	ORG6000665	SATKER6001208	20171204103705
EMP6002057	0094621515	  Darmojo	darmojo@pgn.co.id	100125680	ORG6000657	SATKER6001208	20171204103705
EMP6002058	0096671629	Listio  Sambono	Listio.Sambono@pgn.co.id	08111047976	ORG6000720	SATKER6001249	20171204103705
EMP6002059	0099651761	Agus  Iskandar	Agus.Iskandar@pgn.co.id	0217544860			20171204103705
EMP6002060	1096771621	Dian  Kuncoro	Dian.Kuncoro@pgn.co.id				20171204103705
EMP6002061	0003781903	Jannes Pandapotan Simanjuntak	Jannes.Simanjuntak@gagas.co.id			SATKER6001272	20171204103705
EMP6002062	0005812092	  Fahreza	Fahreza@pgn.co.id	081808885154		SATKER6001220	20171204103705
EMP6002063	0099731776	Grace Theresia Widyani	grace.theresia@pgn.co.id	02156952954	ORG6001164		20171204103705
EMP6002064	0003751884	  Bunyamin	Bunyamin@pgn.co.id	08127102052		SATKER6001239	20171204103705
EMP6002065	0005792070	Jul  Indra	Jul.Indra@pgn.co.id	0817716644		SATKER6001239	20171204103705
EMP6002066	1096741610	Kristomi  Mardiman	Kristomi.Mardiman@pgn.co.id				20171204103705
EMP6002067	1096761619	Dede  Priatna	Dede.Priatna@pgn.co.id	08159933244		SATKER6001239	20171204103705
EMP6002068	0005802128	Dimaz  Haryunantyo	Dimaz.Haryunantyo@pgn.co.id	08128183839		SATKER6001240	20171204103705
EMP6002069	0005812086	Panji Bagus Pamungkas	Panji.Pamungkas@pgn.co.id	0815-9241501			20171204103705
EMP6002070	0005832160	Asri  Mumpuni	Asri.Mumpuni@pgn.co.id			SATKER6001263	20171204103705
EMP6002071	0010842503	Mohammad Harris Iswahyudi	Mohammad.Iswahyudi@pgn.co.id				20171204103705
EMP6002072	0010872454	Ria  Brahmanto	Ria.Brahmanto@pgn.co.id	085647025444		SATKER6001220	20171204103705
EMP6002073	0012882690	Anindya Rizki Santika	Anindya.Santika@pgn.co.id			SATKER6001239	20171204103705
EMP6002074	1087641101	Sri  Suminarti	sri.suminarti@pgn.co.id	08164820630		SATKER6001238	20171204103705
EMP6002075	1096761618	Ade  Musfarullah	Ade.Musfarullah@pgn.co.id	0813-14753891		SATKER6001218	20171204103705
EMP6002076	2096721649	Joko  Prijanto	Joko.Prijanto@pgn.co.id			SATKER6001238	20171204103705
EMP6002077	2096721672	Hery  Purwanto	Hery.Purwanto@pgn.co.id	008126043520		SATKER6001239	20171204103705
EMP6002078	2487671124	Imam  Supriyadi	Imam.Supriyadi@pgn.co.id				20171204103705
EMP6002079	0005832157	Agung  Nugroho	Agung.Nugroho@pgn.co.id	01277202154179		SATKER6001218	20171204103705
EMP6002080	0007842312	Selo Purna Atmani	Selo.Atmani@pgn.co.id	08119817889	ORG6000481	SATKER6001240	20171204103705
EMP6002081	0007872264	Edwin Alfani Soleh	Edwin.Soleh@pgn.co.id			SATKER6001239	20171204103705
EMP6002082	0010852432	Tyas Aryo Willyanto	Tyas.Aryo@pgn.co.id			SATKER6001239	20171204103705
EMP6002083	0010872453	Praditya  Yudianto	Praditya.Yudianto@pgn.co.id			SATKER6001239	20171204103705
EMP6002084	1596731645	Saut Freddy Halomoan	Saut.Ari.Tonang@pgn.co.id	021-8792-3439		SATKER6001218	20171204103705
EMP6002085	2004822013	Tri  Laksono	Tri.Laksono@pgn.co.id				20171204103705
EMP6002086	2007822230	Heri  Wibowo	Heri.Wibowo@pgn.co.id			SATKER6001272	20171204103705
EMP6002087	3004781983	Budi Cahyadi Ginting	Budi.Cahyadi@pgn.co.id	081160792400	ORG6000963	SATKER6001234	20171204103705
EMP6002088	0010842411	Arif Muharno Wahyu Sasongko	Arif.Muharno@pgn.co.id			SATKER6001239	20171204103705
EMP6002089	3004801989	Panondang Rudy Pernando	Panondang.Pernando@pgn.co.id			SATKER6001239	20171204103705
EMP6002090	0004772007	Chandrani  Kurnianto	Chandrani.Kurnianto@pgn.co.id				20171204103705
EMP6002091	0010852423	Gatot Ari Fitri Pramita	Gatot.Ari@pgn.co.id	081298323336		SATKER6001239	20171204103705
EMP6002092	0010862587	Achmad  Aftoni	achmad.aftoni@pgn.co.id	085641809991		SATKER6001239	20171204103705
EMP6002093	0010872602	Muhamad Ali Fikri	muhamad.alifikri@pgn.co.id			SATKER6001239	20171204103705
EMP6002094	0010872605	Rini Devi Andari	rini.devi@pgn.co.id			SATKER6001220	20171204103705
EMP6002095	0010892493	Rizky  Ariaditya	rizky.ariaditya@pgn.co.id			SATKER6001239	20171204103705
EMP6002096	0012852652	Achmad  Refandi	Achmad.Refandi@pgn.co.id	081373363059		SATKER6001239	20171204103705
EMP6002097	0013922749	Saiful Arifin Wahyu Wibowo	Saiful.Wibowo@pgn.co.id	085740772654		SATKER6001239	20171204103705
EMP6002098	1092711486	Ahmad  Nazi	Ahmad.Nazi@pgn.co.id			SATKER6001239	20171204103705
EMP6002099	2009822403	Edy  Sulistyono	Edy.Sulistyono@pgn.co.id	08113519234		SATKER6001239	20171204103705
EMP6002100	2087611089	  Sudadi	Sudadi@pgn.co.id	08113401885		SATKER6001239	20171204103705
EMP6002101	0013702742	Kusnadi Suryana Ardian	kusnadi.suryana@pgn.co.id	0811245358			20171204103705
EMP6002102	0003751881	Budi Junias Sinaga	Budi.Sinaga@pgn.co.id	088809946994	ORG6000398		20171204103705
EMP6002103	0099731781	Ardi  Viryawan	Ardi.Viryawan@pgn.co.id	02133615193	ORG6001081	SATKER6001218	20171204103705
EMP6002104	0005792115	Widi  Pancana	Widi.Pancana@pgn.co.id	08113119711	ORG6000068	SATKER6001211	20171204103705
EMP6002105	0004671950	Desima Equalita Siahaan	Desima.Siahaan@pgn.co.id	081510600030	ORG6000039		20171204103705
EMP6002106	0010852426	Eko Haris Siswanto	Eko.Haris@pgn.co.id		ORG6000153	SATKER6001253	20171204103705
EMP6002107	0010892490	Am Dimas Prio Anggodo	Am.Dimas@pgn.co.id		ORG6000966	SATKER6001234	20171204103705
EMP6002108	0013922748	Arief Mochamad Dharmawan	arief.dharmawan@pgn.co.id		ORG6000709		20171204103705
EMP6002109	0013922753	Hendry Pramudipta Sumasaputra	Hendry.Sumasaputra@pgn.co.id		ORG6000708		20171204103705
EMP6002110	0009842388	Annis  Sofia	Annis.Sofia@pgn.co.id		ORG6000713		20171204103705
EMP6002111	0012912733	Raya Fitrian Hernasa	Raya.Hernasa@pgn.co.id		ORG6000097	SATKER6001211	20171204103705
EMP6002112	0015942777	Roro Anggun Win Pradhani	Roro.Pradhani@pgn.co.id		ORG6000989	SATKER6001223	20171204103705
EMP6002113	0014932762	Faricha Ayu Isnina	Faricha.Isnina@pgn.co.id		ORG6000527		20171204103705
EMP6002114	1008892370	  Andriansyah	Andriansyah@pgn.co.id	081320332941	ORG6000910		20171204103705
EMP6002115	0010872464	Koenthi Purnama Ningtyas	Koenthi.Purnama@pgn.co.id		ORG6001010	SATKER6001211	20171204103705
EMP6002116	0017962790	Rayvario  Sultan	Rayvario.Sultan@pgn.co.id	087711550411	ORG6001204	SATKER6001210	20171204103705
EMP6002117	0010882472	Samuel Eben Ezer Sitompul	Samuel.Eben@pgn.co.id		ORG6000918	SATKER6001213	20171204103705
EMP6002118	0010862451	Sandes  Purba	Sandes.Purba@pgn.co.id	6289506093544	ORG6000920	SATKER6001213	20171204103705
EMP6002119	0010852573	Hilmi  Fikri	Hilmi.Fikri@pgn.co.id		ORG6000217	SATKER6001213	20171204103705
EMP6002120	1693661509	Udi  Setiono	Udi.Setiono@pgn.co.id		ORG6000214	SATKER6001245	20171204103705
EMP6002121	0012892712	Yenni  Andriani	Yenni.Andriani@pgn.co.id		ORG6000846	SATKER6001215	20171204103705
EMP6002122	2009732402	  Astuti	Astuti@pgn.co.id	081555665173	ORG6001107	SATKER6001218	20171204103705
EMP6002123	0010852564	Teni  Vitanggi	Teni.Vitanggi@pgn.co.id		ORG6000625	SATKER6001220	20171204103705
EMP6002124	1095691577	Priyo  Hutomo	Priyo.Hutomo@pgn.co.id		ORG6000671	SATKER6001219	20171204103705
EMP6002125	0089621403	Anjir  Sukaniawan	Anjir.Sukaniawan@pgn.co.id		ORG6000810	SATKER6001218	20171204103705
EMP6002126	0089651397	  Wira	Wira@pgn.co.id		ORG6000896	SATKER6001218	20171204103705
EMP6002127	1005832047	Rahayu Laila Fitriati	Rahayu.Fitriati@pgn.co.id		ORG6000832	SATKER6001221	20171204103705
EMP6002128	2004852021	R. Bagus  Windianto	bagus.windianto@pgn.co.id			SATKER6001218	20171204103705
EMP6002129	0004631997	Dapot  Tambunan	Dapot.Tambunan@pgn.co.id		ORG6000537	SATKER6001252	20171204103705
EMP6002130	0013912745	Indra  Praditya	Indra.Praditya@pgn.co.id		ORG6000778		20171204103705
EMP6002131	3004811991	Irvan Panusunan Lumban Tobing	Irvan.Tobing@pgn.co.id		ORG6000777		20171204103705
EMP6002132	0006762173	Jonli  Simanjuntak	Jonli.Simanjuntak@pgn.co.id		ORG6001019	SATKER6001211	20171204103705
EMP6002133	0010882473	Narulita Kusuma Hasyim	Narulita.Kusuma@pgn.co.id		ORG6000172	SATKER6001213	20171204103705
EMP6002134	1092631460	  Sarwono	Sarwono@pgn.co.id		ORG6000281	SATKER6001226	20171204103705
EMP6002135	2099771757	Dawud  Mustopa	Dawud.Mustofa@pgn.co.id	08113633639	ORG6000264	SATKER6001255	20171204103705
EMP6002136	0099622197	  Arnata	Arnata@pgn.co.id			SATKER6001218	20171204103705
EMP6002137	0096641662	Eddy  Mulyono	Eddy.Mulyono@pgn.co.id		ORG6000677	SATKER6001211	20171204103705
EMP6002138	0012792655	Hendri Susilo Pramono	Hendri.Pramono@pgn.co.id		ORG6000470	SATKER6001229	20171204103705
EMP6002139	0096691635	Danu  Prijambodo	Danu.Prijambodo@pgn.co.id	08119892368	ORG6000368	SATKER6001211	20171204103705
EMP6002140	0004791937	Andri Oscarianto Ginting Munthe	Andri.Munthe@pgn.co.id	081533124234	ORG6000143	SATKER6001253	20171204103705
EMP6002141	0097701689	Lintong Sopar Marudut Silalahi	Lintong.Silalahi@pgn.co.id	0811975201	ORG6001158	SATKER6001211	20171204103705
EMP6002142	0094711543	  Nurdiansyah	Nurdiansyah@pgn.co.id	0008111880186	ORG6000746	SATKER6001243	20171204103705
EMP6002143	0004791966	Dewi  Nursetyaningrum	Dewi.Nursetyaningrum@pgn.co.id	0812-1015762	ORG6000114	SATKER6001211	20171204103705
EMP6002144	0099751794	Raden Mohamad Edwin	Mohamad.Edwin@pgn.co.id	02187921861	ORG6000442	SATKER6001249	20171204103705
EMP6002145	0004801970	Heru  Indriatno	Heru.Indriatno@pgn.co.id	081533188899	ORG6000066	SATKER6001211	20171204103705
EMP6002146	0099731774	Aristeus Ligamen Saleppang	Aristeus.Saleppang@pgn.co.id	08112575011	ORG6001100	SATKER6001216	20171204103705
EMP6002147	0099761797	Hendar Purnomo Susanto	Hendar.Susanto@pgn.co.id	08113881382	ORG6000422	SATKER6001218	20171204103705
EMP6002148	0086611054	Enik  Indriastuti	Enik.Indriastuti@pgn.co.id	08129308078	ORG6000521	SATKER6001252	20171204103705
EMP6002149	0099731782	Posma L Sirait	Posma.Sirait@pgn.co.id	10023973	ORG6000795	SATKER6001234	20171204103705
EMP6002150	0004781963	Asri  Wahyuningsih	Asri.Wahyuningsih2@pgn.co.id	02177219020	ORG6000624	SATKER6001220	20171204103705
EMP6002151	2095701552	Moch Yusni Thamrin	m.yusni.thamrin@pgn.co.id	0811326072	ORG6000637	SATKER6001219	20171204103705
EMP6002152	0004771923	Tubagus  Nurcholis	Tubagus.Nurcholis@pgn.co.id	081514094715	ORG6000540	SATKER6001252	20171204103705
EMP6002153	1005812030	Lusi  Latifunnur	Lusi.Latifunnur@pgn.co.id	081288066081	ORG6000357	SATKER6001216	20171204103705
EMP6002154	1087651104	  Rumwinarni	Rumwinarni@pgn.co.id	08128422404	ORG6000253	SATKER6001225	20171204103705
EMP6002155	0005832161	Afilia  Purwaningrum	Afilia.Purwaningrum@pgn.co.id	0811378237	ORG6000820	SATKER6001213	20171204103705
EMP6002156	0012872679	Rina  Widarustanti	Rina.Widarustanti@pgn.co.id	08119155535	ORG6000605		20171204103705
EMP6002157	0010852429	Yogi Alex Prabowo	Yogi.Alex@pgn.co.id	081339654300	ORG6000186	SATKER6001213	20171204103705
EMP6002158	2095731561	Yulwien Nora Mamoto Kalalo	Yulwien.Kalalo@pgn.co.id	0811343473	ORG6000278	SATKER6001255	20171204103705
EMP6002159	0010882616	Ade  Rusdiyati	Ade.Rusdiyati@pgn.co.id	08119400688	ORG6000542	SATKER6001252	20171204103705
EMP6002160	0089651373	  Benny	Benny@pgn.co.id	081316646449	ORG6000692	SATKER6001219	20171204103705
EMP6002161	0005812085	Bondan  Christiandinata	Bondan.Christiandi@pgn.co.id	0817266326	ORG6000603	SATKER6001233	20171204103705
EMP6002162	3089681380	Saeful  Hadi	Saeful.Hadi@pgn.co.id	628113526268	ORG6000304	SATKER6001213	20171204103705
EMP6002163	0092661447	  Makmuri	Makmuri@pgn.co.id	08159909127	ORG6000223	SATKER6001213	20171204103705
EMP6002164	0004811947	Sonny Rahmawan Abdi	Sonny.Abdi@pgn.co.id	008111492925	ORG6000200	SATKER6001224	20171204103705
EMP6002165	0004781924	Amin  Hidayat	Amin.Hidayat@pgn.co.id	002180880625	ORG6000337	SATKER6001213	20171204103705
EMP6002166	2099781758	Andaya Endy Saputra	Andaya.Saputra@pgn.co.id	00811929404	ORG6000242	SATKER6001213	20171204103705
EMP6002167	0088631256	R.  Wahyono Prasetyo Talogo	R.Wahyono.Talogo@pgn.co.id	08121108180	ORG6000490	SATKER6001256	20171204103705
EMP6002168	0088691167	  Miftahudin	Miftahudin@pgn.co.id	0123030792	ORG6000494	SATKER6001256	20171204103705
EMP6002169	0088641160	  Nasihin	Nasihin@pgn.co.id	08121075110	ORG6000371		20171204103705
EMP6002170	0010862518	Armynas Handyas Wijayatma	Armynas.Handyas@pgn.co.id	081328229073	ORG6000179	SATKER6001249	20171204103705
EMP6002171	0010842505	Danny  Prameswari	Danny.Prameswari@pgn.co.id	081284888993	ORG6000560	SATKER6001254	20171204103705
EMP6002172	0007822292	Muhammad Rusdy Sanny	Muhammad.Sanny@pgn.co.id	101006453	ORG6000727	SATKER6001243	20171204103705
EMP6002173	0007822295	Hari Satria Aribowo	Hari.Aribowo@pgn.co.id	081112077780	ORG6000702	SATKER6001234	20171204103705
EMP6002174	0005822105	Natasya Ilkovicha Dinsdag Saiman	Natasya.Saiman@pgn.co.id	0008118705207	ORG6000267	SATKER6001213	20171204103705
EMP6002175	1007822252	Yudi  Ariyanto	Yudi.Ariyanto@pgn.co.id	081314646044	ORG6000334	SATKER6001230	20171204103705
EMP6002176	0012842658	Sandi  Sifananda	Sandi.Sifananda@pgn.co.id	0214507208	ORG6001051		20171204103705
EMP6002177	0012852663	Tri Gendro Waskito Adi	Tri.Adi@pgn.co.id	10283483	ORG6000561	SATKER6001254	20171204103705
EMP6002178	0010852510	Erlina Midah Naibaho	Erlina.Midah@pgn.co.id	08111980511	ORG6000959	SATKER6001218	20171204103705
EMP6002179	0012842659	Arif  Perdananto	Arif.Perdananto@pgn.co.id	081218185432	ORG6000994	SATKER6001236	20171204103705
EMP6002180	2096731651	Eko  Cahyono	Eko.Cahyono@pgn.co.id	081703391222	ORG6001067	SATKER6001252	20171204103705
EMP6002181	1007772205	Pravira Sisyawan Notodisurjo	Pravira.Notodisurjo@pgn.co.id	08161974184	ORG6000686	SATKER6001234	20171204103705
EMP6002182	0010872527	Muhammad Farkhan Rizaputra	Farkhan.Rizaputra@pgn.co.id	0081540040545	ORG6001131	SATKER6001213	20171204103705
EMP6002183	0007842320	Jernih Deborah Sinaga	Jernih.Sinaga@pgn.co.id	081295367384	ORG6000448	SATKER6001218	20171204103705
EMP6002184	0007802284	Yudhiasny  Saragih	Yudhiasny.Saragih@pgn.co.id	08127862852	ORG6000864	SATKER6001211	20171204103705
EMP6002185	3007832244	Tampil  Lumbantoruan	Tampil.Lumbantoruan@pgn.co.id	081362217677	ORG6000091	SATKER6001211	20171204103705
EMP6002186	0010842414	Mohammad Ardian Arifin	Ardian.Arifin@pgn.co.id	0878 8207 3423	ORG6000805	SATKER6001234	20171204103705
EMP6002187	0012842738	Agung Oktavian Wijaya	Agung.Wijaya@pgn.co.id	0218619309	ORG6000806		20171204103705
EMP6002188	0010852421	Furqanul  Fikri	Furqanul.Fikri@pgn.co.id	081321410515	ORG6000741	SATKER6001243	20171204103705
EMP6002189	1092671471	  Suparmono	Suparmono@pgn.co.id	081386215171	ORG6000747	SATKER6001234	20171204103705
EMP6002190	3090671415	Santoso Priyo Pratomo	Santoso.Pratomo@pgn.co.id	081537503334	ORG6000718	SATKER6001234	20171204103705
EMP6002191	0012892714	Ni Made Dwi Ryaumariastini	Dwi.Ryaumariastini@pgn.co.id	0226010380	ORG6001114	SATKER6001211	20171204103705
EMP6002192	0010852563	Ratna Dian Suminar	Ratna.Suminar@pgn.co.id	081225872787	ORG6000761	SATKER6001234	20171204103705
EMP6002193	2007822232	Baried  Nurcahyo	Baried.Nurcahyo@pgn.co.id	08113126336	ORG6001078	SATKER6001222	20171204103705
EMP6002194	1007812209	Viktor Leonardo Siahaan	victor.leonardo@pgn.co.id	081280143442	ORG6000906	SATKER6001213	20171204103705
EMP6002195	0010852422	Nurlandi  Suhendar	Nurlandi.Suhendar@pgn.co.id	08118775568	ORG6000377	SATKER6001213	20171204103705
EMP6002196	0004681995	  Boedijanto	Boedijanto@pgn.co.id	0217704329	ORG6000837	SATKER6001212	20171204103705
EMP6002197	3007832245	Gusti  Hadi	Gusti.Hadi@pgn.co.id	+628116123083	ORG6000318	SATKER6001215	20171204103705
EMP6002198	0012842651	Dikot Adika Sampurna Hasibuan	Dikot.Hasibuan@pgn.co.id	081280720202	ORG6000546		20171204103705
EMP6002199	0010872599	Eko  Yunianto	eko.yunianto@pgn.co.id	081584367008	ORG6000576	SATKER6001216	20171204103705
EMP6002200	3097741718	Pangondian  Manihuruk	Pangondian.Manihuruk@pgn.co.id	081264149877	ORG6001064	SATKER6001218	20171204103705
EMP6002201	0010852565	Indra  Gunawan	Indra.Gunawan@pgn.co.id	081330707754	ORG6001163	SATKER6001211	20171204103705
EMP6002202	0012862668	  Andriyanto	Andriyanto@pgn.co.id		ORG6000533	SATKER6001252	20171204103705
EMP6002203	0095671572	Andi  Firdaus	Andi.Firdaus@pgn.co.id	0811-6002560	ORG6000089	SATKER6001211	20171204103705
EMP6002204	0004732005	  Fahrizal	Fahrizal@pgn.co.id	081314310720	ORG6000679	SATKER6001211	20171204103705
EMP6002205	0087671119	  Ardi	Ardi@pgn.co.id	081315400971	ORG6000678	SATKER6001211	20171204103705
EMP6002206	1007822214	Ade Ihwana Kurniawan	Ade.Ihwana@pgn.co.id	081514140303	ORG6001183	SATKER6001211	20171204103705
EMP6002207	0005812129	Muhammad Brajaka Kusuma	Muhammad.Brajaka@pgn.co.id	08174975057	ORG6000124	SATKER6001211	20171204103705
EMP6002208	0010842416	Wildan  Jalaludin	Wildan.Jalaludin@pgn.co.id	08118801632	ORG6000573	SATKER6001211	20171204103705
EMP6002209	1005802025	Charles Parulian Bakara	Charles.Bakara@pgn.co.id	08111-827681	ORG6001145	SATKER6001211	20171204103705
EMP6002210	2002821866	Dhani  Amannatur	Dhani.Amannatur@pgn.co.id	08121737499	ORG6000096	SATKER6001211	20171204103705
EMP6002211	0001761833	Feronica Yula Wardhani	Feronica.Wardhani@pgn.co.id	08818818680	ORG6000367		20171204103705
EMP6002212	0088631248	Nella  Andaryati	Nella.Andaryati@pgn.co.id	0218298190	ORG6001004		20171204103705
EMP6002213	0087641112	  Supriyadi	Supriyadi@pgn.co.id	0811008110583	ORG6001030		20171204103705
EMP6002214	0007822291	Herman  Hartanto	Herman.Hartanto@pgn.co.id	10242826	ORG6000710		20171204103705
EMP6002215	1588651279	Yanto  Kusdamayanto	Yanto.Kusdamayanto@pgn.co.id	02517560093	ORG6000182	SATKER6001221	20171204103705
EMP6002216	0005812142	Widhi  Nugroho	Widhi.Nugroho@pgn.co.id	08118701220	ORG6000917	SATKER6001213	20171204103705
EMP6002217	2096721650	Mohammad Makki Nuruddin	M.Makki.Nuruddin@pgn.co.id	0816503429	ORG6000922	SATKER6001213	20171204103705
EMP6002218	0001761829	Kartini Tetty Erawati Pandiangan	Kartini.Pandiangan@pgn.co.id	0081927197684	ORG6000927		20171204103705
EMP6002219	0089671346	Sri  Supiah	Sri.Supiah@pgn.co.id	02177212936	ORG6000498	SATKER6001256	20171204103705
EMP6002220	0007842323	Yusdi  Mubarok	Yusdi.Mubarok@pgn.co.id	02177888356	ORG6000348		20171204103705
EMP6002221	1005822035	Rikhi  Narang	Rikhi.Narang@pgn.co.id	081320012318	ORG6000440	SATKER6001251	20171204103705
EMP6002222	1088641264	Neneng  Sabeni	Neneng.Sabeni@pgn.co.id	02110231883	ORG6001061	SATKER6001218	20171204103705
EMP6002223	0001761832	Suryandari  Wandewi	Suryandari.Wandewi@pgn.co.id	08111172605	ORG6000429	SATKER6001218	20171204103705
EMP6002224	1005822038	Jefryanto  Pasaribu	Jefryanto.Pasaribu@pgn.co.id	008119303474	ORG6000447	SATKER6001218	20171204103705
EMP6002225	1005812028	Kristiar Bintang Caroko	Kristiar.Caroko@pgn.co.id	08118503485	ORG6000173	SATKER6001213	20171204103705
EMP6002226	0093681502	Hari  Pudjiastuti	Hari.Pudjiastuti@pgn.co.id	08558433060	ORG6000183	SATKER6001221	20171204103705
EMP6002227	1693701512	  Warkunah	warkunah@pgn.co.id	082122003137	ORG6000939		20171204103705
EMP6002228	1096741613	Sopyan  Zamhuri	Sopyan.Zamhuri@pgn.co.id	081-808655678	ORG6001113	SATKER6001211	20171204103705
EMP6002229	2096761656	Beni  Pramono	Beni.Pramono@pgn.co.id	031-5453706	ORG6000892	SATKER6001211	20171204103705
EMP6002230	0005772053	Marlon  Riolan	Marlon.Riolan@pgn.co.id	08119503647	ORG6001162	SATKER6001211	20171204103705
EMP6002231	3089651297	  Azwardi	Azwardi@pgn.co.id	0142771122	ORG6000785	SATKER6001234	20171204103705
EMP6002232	0094691539	Jeffri  Sianturi	Jeffri.Sianturi@pgn.co.id	081110715110	ORG6000964	SATKER6001234	20171204103705
EMP6002233	0012852666	Ardika  Maulana	Ardika.Maulana@pgn.co.id	081314903559	ORG6000128	SATKER6001211	20171204103705
EMP6002234	0010852438	Hernando Natal Ginting	Hernando.Ginting@pgn.co.id	02517562321	ORG6001009	SATKER6001211	20171204103705
EMP6002235	0013912744	Retno Wahyuning Astuti	retno.astuti@pgn.co.id		ORG6001140	SATKER6001216	20171204103705
EMP6002236	0086611035	Achmad  Rifai	Achmad.Rifai@pgn.co.id	0811111926	ORG6001032		20171204103705
EMP6002237	0092681494	Roevlyanto  Roezien	Roevlyanto.Roezien@pgn.co.id	02184902710	ORG6000421	SATKER6001218	20171204103705
EMP6002238	0001791842	Ahmad  Cahyadi	Ahmad.Cahyadi@pgn.co.id	02177216566		SATKER6001272	20171204103705
EMP6002239	0088621158	Noor Diana Prasetyawati	Noor.Prasetyawati@pgn.co.id	08111774975			20171204103705
EMP6002240	0001731808	Hedi  Hedianto	Hedi.Hedianto@pgn.co.id	081399888723			20171204103705
EMP6002241	0001761834	Krisdian  Kusuma	Krisdian.Kusuma@pgn.co.id	02146802906		SATKER6001239	20171204103705
EMP6002242	0003791909	Toto  Yulianto	Toto.Yulianto@pgn.co.id	08118116914			20171204103705
EMP6002243	0005802119	Fathurahman  P.Ng. J	fathurahman@pgn.co.id	9991921123		SATKER6001214	20171204103705
EMP6002244	0088621239	Iwan  Hendarwan	Iwan.Hendarwan@pgn.co.id	08113408333			20171204103705
EMP6002245	0097711693	Tisan  Sobichah	Tisan.Sobichah@pgn.co.id	081511094433			20171204103705
EMP6002246	0005802076	Muhammad Rais Efendi	M.Rais.Effendi@pgn.co.id	00818184113			20171204103705
EMP6002247	0005802079	Joko Rusmartono Jati	Joko.Jati@pgn.co.id	08111885150			20171204103705
EMP6002248	0005812135	Ichsan  Priambodo	Ichsan.Priambodo@pgn.co.id	08111921019	ORG6001200	SATKER6001239	20171204103705
EMP6002249	0005812133	Nor  Aklis	Nor.Aklis@pgn.co.id	085226365560		SATKER6001239	20171204103705
EMP6002250	0006772175	Boyke Lumban Tobing	Boyke.Tobing@pgn.co.id	08127200836		SATKER6001234	20171204103705
EMP6002251	0007832301	Febrilian  Hindarto	Febrilian.Hindarto@pgn.co.id	08111461063		SATKER6001214	20171204103705
EMP6002252	2096751653	Achmad  Anas	Achmad.Anas@pgn.co.id	08113225823		SATKER6001239	20171204103705
EMP6002253	3086641068	  Usman	Usman@pgn.co.id	081364807278		SATKER6001239	20171204103705
EMP6002254	0092671448	Bambang  Budiono	Bambang.Budiono@pgn.co.id	08127207909		SATKER6001239	20171204103705
EMP6002255	0005812091	Hendi  Novianto	Hendi.Novianto@pgn.co.id			SATKER6001263	20171204103705
EMP6002256	0005822152	Elia  Andriyani	Elia.Andriyani@pgn.co.id				20171204103705
EMP6002257	0088641152	Endang  Sofian	Endang.Sopian@pgn.co.id	0815 1793 3364	ORG6001167	SATKER6001266	20171204103705
EMP6002258	1005832039	Arinta Indah Sulistiowati	Arinta.Sulistiawat@pgn.co.id				20171204103705
EMP6002259	1095711584	Ronny  Sastrawijaya	Ronny.Sastrawijaya@pgn.co.id			SATKER6001239	20171204103705
EMP6002260	2487611121	  Sugiono	Sugiono@pgn.co.id			SATKER6001239	20171204103705
EMP6002261	1092631461	  Mugiyanto	Mugiyanto@pgn.co.id			SATKER6001239	20171204103705
EMP6002262	3007842247	Charly  Simanullang	Charly.Simanullang@pgn.co.id	08117541218			20171204103705
EMP6002263	0004681999	Muhammad  Ramdani	Muhammad.Ramdani@pgn.co.id			SATKER6001239	20171204103705
EMP6002264	0007842314	Erwin Perdana Romadhian	Erwin.Romadhian@pgn.co.id				20171204103705
EMP6002265	0010852428	Sony Laju Haryadi	Sony.laju@pgn.co.id			SATKER6001239	20171204103705
EMP6002266	0010852572	Khairul  Khitam	Khairul.Khitam@pgn.co.id			SATKER6001238	20171204103705
EMP6002267	0010862584	  Mursal	Mursal@pgn.co.id			SATKER6001268	20171204103705
EMP6002268	0010882477	Firman  Riantus	Firman.Riantus@pgn.co.id	08117894688		SATKER6001239	20171204103705
EMP6002269	0010882478	Indra Yuliansyah Rahman	Indra.Yuliansyah@pgn.co.id			SATKER6001211	20171204103705
EMP6002270	0010882487	Arif  Hidayaturochman	Arif.Hidayaturochman@pgn.co.id	081273327465		SATKER6001239	20171204103705
EMP6002271	0010892491	Wira Anom Wibawa	Wira.Anom@pgn.co.id			SATKER6001239	20171204103705
EMP6002272	1088651189	  Partiono	partiyono@pgn.co.id			SATKER6001239	20171204103705
EMP6002273	2096761686	Asep Tatang Purnomo	Asep.Purnomo@pgn.co.id			SATKER6001239	20171204103705
EMP6002274	1089651318	Achmad  Chaerudin	Achmad.Chaerudin@pgn.co.id			SATKER6001239	20171204103705
EMP6002275	0010852424	Sinung Sedya Utomo	Sinung.Sedya@pgn.co.id			SATKER6001239	20171204103705
EMP6002276	0012902725	Yunus Adri Wicaksono	Yunus.Wicaksono@pgn.co.id			SATKER6001239	20171204103705
EMP6002277	0013922751	Ferry Budi Sentosa	ferry.sentosa@pgn.co.id			SATKER6001239	20171204103705
EMP6002278	0015942769	Muhammad Alfis Budi Sanjaya	Muhammad.Sanjaya@pgn.co.id			SATKER6001239	20171204103705
EMP6002279	0089631404	  Kastoni	Kastoni@pgn.co.id			SATKER6001239	20171204103705
EMP6002280	0099672200	  Mulyanto	Mulyanto@pgn.co.id			SATKER6001239	20171204103705
EMP6002281	0099702186	  Syahrudin	Syahrudin@pgn.co.id			SATKER6001239	20171204103705
EMP6002282	0099702202	Achmad  Hidayat	achmad.hidayat.2202@pgn.co.id			SATKER6001239	20171204103705
EMP6002283	1008872373	Amarendra Dharmmestha Wicesa	Amarendra.W@pgn.co.id			SATKER6001239	20171204103705
EMP6002284	1088661192	  Nurhasan	Nurhasan@pgn.co.id			SATKER6001239	20171204103705
EMP6002285	1588651281	Anas  Muhidin	Anas.Muhidin@pgn.co.id			SATKER6001239	20171204103705
EMP6002286	2085630988	Slamet  Suyanto	Slamet.Suyanto@pgn.co.id			SATKER6001239	20171204103705
EMP6002287	3086651072	  Asril	Asril@pgn.co.id			SATKER6001239	20171204103705
EMP6002288	0010852417	Dickha Rizky Maulana	Dickha.Rizky@pgn.co.id			SATKER6001239	20171204103705
EMP6002289	0095621568	  Mulyadi	Mulyadi@pgn.co.id			SATKER6001239	20171204103705
EMP6002290	0007722262	Nixon  Simanjuntak	Nixon.Simandjuntak@pgn.co.id			SATKER6001218	20171204103705
EMP6002291	1693661508	  Khairani	Khairani@pgn.co.id			SATKER6001218	20171204103705
EMP6002292	0008782377	Joice Hotma Erlian Juliana	Joice.Juliana@pgn.co.id	081519008866	ORG6001133	SATKER6001233	20171204103705
EMP6002293	0001761826	Heny  Purwati	Heny.Purwati@pgn.co.id	0818416428	ORG6000162	SATKER6001213	20171204103705
EMP6002294	0003821916	Elfan  Triawan	elfan.triawan@pgn.co.id	08111872736	ORG6001077	SATKER6001251	20171204103705
EMP6002295	J20160012	Hendi Prio Santoso	Hendi.Santoso@pgn.co.id				20171204103705
EMP6002296	0010872470	Alhan  Rustiyana	Alhan.Rustiyana@pgn.co.id		ORG6000735	SATKER6001243	20171204103705
EMP6002297	0015952772	Febrian  Risdiansyah	Febrian.Risdiansyah@pgn.co.id		ORG6000870	SATKER6001216	20171204103705
EMP6002298	1008822349	Erwan Omar Mukhtar	Erwan.Mukhtar@pgn.co.id	08111256045	ORG6000737	SATKER6001243	20171204103705
EMP6002299	0012902723	Andika Indra Cahyadi	Andika.Cahyadi@pgn.co.id		ORG6000584	SATKER6001211	20171204103705
EMP6002300	1587661134	Dewi  Sukmawati	Dewi.Sukmawati@pgn.co.id		ORG6000487	SATKER6001240	20171204103705
EMP6002301	0016952784	Fajar Setyo Wahyudi	Fajar.Wahyudi@pgn.co.id		ORG6000982	SATKER6001216	20171204103705
EMP6002302	0010882619	Kukuh Bayu Prasetyo	Kukuh.Bayu@pgn.co.id		ORG6000290	SATKER6001226	20171204103705
EMP6002303	0012882694	Nur  Saidah	Nur.Saidah@pgn.co.id	087882043500	ORG6000286	SATKER6001255	20171204103705
EMP6002304	0015942774	Widas  Khoirunnisa	Widas.Khoirunnisa@pgn.co.id		ORG6000926	SATKER6001213	20171204103705
EMP6002305	3004841993	Lamhotma Parulian Siboro	Lamhotma.Siboro@pgn.co.id		ORG6000366	SATKER6001218	20171204103705
EMP6002306	0012862676	Aditya  Danurwendo	Aditya.Danurwendo@pgn.co.id		ORG6000425	SATKER6001216	20171204103705
EMP6002307	0010872601	Puteri  Ayuningtyas	puteri.ayuningtyas@pgn.co.id	0818635758	ORG6001047	SATKER6001236	20171204103705
EMP6002308	1596721642	Siti  Itaningrum	Siti.Itaningrum@pgn.co.id		ORG6000688	SATKER6001219	20171204103705
EMP6002309	0012892708	Cholifah indah Permatasari	Cholifah.Permatasari@pgn.co.id		ORG6000342		20171204103705
EMP6002310	0095641570	  Hasanah	Hasanah@pgn.co.id		ORG6000793	SATKER6001218	20171204103705
EMP6002311	0012882692	  Suharmat	Suharmat@pgn.co.id	08117735000	ORG6000775		20171204103705
EMP6002312	0010882624	Irma  Indriani	Irma.Indriani@pgn.co.id		ORG6000111	SATKER6001211	20171204103705
EMP6002313	0011902631	Jauhari  Wicaksono	Jauhari.Wicaksono@pgn.co.id		ORG6000169	SATKER6001213	20171204103705
EMP6002314	0012892699	  Utami	Utami@pgn.co.id		ORG6000824	SATKER6001213	20171204103705
EMP6002315	0010892488	Nandikram  Widhicahya	Nandikram@pgn.co.id	089650601897	ORG6000272	SATKER6001213	20171204103705
EMP6002316	0010872598	Cherra  Astyani	cherra.astyani@pgn.co.id		ORG6000250	SATKER6001223	20171204103705
EMP6002317	1092671475	  Budihardjo	Budihardjo@pgn.co.id		ORG6000224	SATKER6001213	20171204103705
EMP6002318	1089691322	Irfan  Alamsyah	Irfan.Alamsyah@pgn.co.id		ORG6000222	SATKER6001224	20171204103705
EMP6002319	0087651118	Wasanan  Saepudin	wasanan.saipudin@pgn.co.id		ORG6000277	SATKER6001226	20171204103705
EMP6002320	3004791984	Teguh Iman Syah	Teguh.Imansyah@pgn.co.id		ORG6000262	SATKER6001226	20171204103705
EMP6002321	0010882475	Virgiawan Janur Meisuci	Virgiawan.Meisuci@pgn.co.id	08111282957	ORG6000992	SATKER6001235	20171204103705
EMP6002322	1096761615	Yasir  Arafat	Yasir.Arafat@pgn.co.id	087771692227	ORG6000229	SATKER6001212	20171204103705
EMP6002323	0010862444	Kabul  Sucipto	Kabul.Sucipto@pgn.co.id		ORG6000403	SATKER6001227	20171204103705
EMP6002324	0015942775	Marasokawati  Cakra	Marasokawati.Cakra@pgn.co.id		ORG6000868	SATKER6001216	20171204103705
EMP6002325	1008862365	Indah  Irwanti	Indah.Irwanti@pgn.co.id		ORG6000691	SATKER6001219	20171204103705
EMP6002326	2007862238	Lulun  Cholisoh	Lulun.Cholisoh@pgn.co.id		ORG6001071	SATKER6001219	20171204103705
EMP6002327	0092631441	  Kustriyono	Kustriyono@pgn.co.id		ORG6000812	SATKER6001218	20171204103705
EMP6002328	1008882369	Izza  Ubaidillah	Izza.Ubaidilah@pgn.co.id		ORG6000122	SATKER6001211	20171204103705
EMP6002329	1087651105	Enny  Mulyani	Enny.Mulyani@pgn.co.id			SATKER6001218	20171204103705
EMP6002330	3086621064	Edy  Prianto	Edi.Prianto@pgn.co.id		ORG6001206	SATKER6001218	20171204103705
EMP6002331	0097751708	Siti Yanti Mulyanti	Siti.Mulyanti@pgn.co.id	02518373228	ORG6000630		20171204103705
EMP6002332	0004791938	Rahmawati  KA	Rahmawati.KA@pgn.co.id	08118206704	ORG6000120	SATKER6001211	20171204103705
EMP6002333	0097721694	Ari Armay Syah	Ari.Syah@pgn.co.id	02128043177	ORG6000797		20171204103705
EMP6002334	0089681349	Sutaryo  Suparjo	Sutaryo.Suparjo@pgn.co.id	08118207092	ORG6000641	SATKER6001219	20171204103705
EMP6002335	0005792061	Prihardy  Bakry	Prihardy.Bakri@pgn.co.id	9992489074	ORG6000609	SATKER6001220	20171204103705
EMP6002336	0098711734	Diana  Yulianty	Diana.Yulianty@pgn.co.id	081289696771	ORG6000631	SATKER6001219	20171204103705
EMP6002337	0086621056	  Sumarsony	Sumarsony@pgn.co.id	08111928734	ORG6000539	SATKER6001252	20171204103705
EMP6002338	0099741786	Anak Agung Putu Bagus Putra Tinggal	Bagus.Putra@pgn.co.id	02174862119	ORG6000700		20171204103705
EMP6002339	0005822103	Leli  Mulyani	Leli.Mulyani@pgn.co.id	08118207095	ORG6000613	SATKER6001220	20171204103705
EMP6002340	1007842224	Sari  Handayani	Sari.Handayani@pgn.co.id	081380197595	ORG6000287	SATKER6001213	20171204103705
EMP6002341	0010872532	Wisnu  Danarto	Wisnu.danarto@pgn.co.id	08119755035	ORG6000634	SATKER6001219	20171204103705
EMP6002342	3089651374	Rema  Sinaga	Rema.Sinaga@pgn.co.id	081370702007	ORG6000329	SATKER6001215	20171204103705
EMP6002343	0012882697	Adhitya  Virtus	Adhitya.Virtus@pgn.co.id	20044766	ORG6000617	SATKER6001220	20171204103705
EMP6002344	1596721643	  Herlina	Herlina.1643@pgn.co.id	081584201816	ORG6000596		20171204103705
EMP6002345	1008882368	Yusep  Mandani	Yusep.Mandani@pgn.co.id	08566573965	ORG6000233	SATKER6001213	20171204103705
EMP6002346	2001811850	Yanuar  Triani	Yanuar.Triani@pgn.co.id	08113394664	ORG6000309	SATKER6001218	20171204103705
EMP6002347	3004811990	Popi  Indriati	Popi.Indriati@pgn.co.id	08126055766	ORG6000915	SATKER6001220	20171204103705
EMP6002348	0010852575	Wido Oktin Yonatan	Wido.Oktin@pgn.co.id	085692246690	ORG6000638	SATKER6001219	20171204103705
EMP6002349	0001761827	  Irpan	Irpan@pgn.co.id	02154215743	ORG6000413		20171204103705
EMP6002350	3097751720	  Sabaruddin	Sabaruddin@pgn.co.id	02175901776	ORG6000176	SATKER6001213	20171204103705
EMP6002351	2096761657	Misbachul  Munir	Misbachul.Munir@pgn.co.id	08123280171	ORG6000235	SATKER6001213	20171204103705
EMP6002352	2096751682	Heri  Frastiono	Heri.Frastiono@pgn.co.id	08113441410	ORG6000251	SATKER6001234	20171204103705
EMP6002353	0005822151	Arief  Nurrachman	Arief.Nurrachman@pgn.co.id	+628113633623	ORG6000338	SATKER6001213	20171204103705
EMP6002354	0088641263	Dumaria  Sintauli	Dumaria.Sintauli@pgn.co.id	08121028116	ORG6000555	SATKER6001254	20171204103705
EMP6002355	0094621517	  Sujatmiko	Sujatmiko@pgn.co.id	0812820911350	ORG6000455	SATKER6001214	20171204103705
EMP6002356	0094691538	Agus  Arifin	Agus.Arifin@pgn.co.id	02129667505	ORG6000477	SATKER6001240	20171204103705
EMP6002357	0001721855	Teguh  Yuwono	Teguh.Yuwono@pgn.co.id	02172217747	ORG6000696		20171204103705
EMP6002358	0003771896	Mega  Pratiwi	Mega.Pratiwi@pgn.co.id	081511088994	ORG6000803		20171204103705
EMP6002359	0088621247	  Asad	Asad@pgn.co.id	0215654842	ORG6001180	SATKER6001211	20171204103705
EMP6002360	0010832501	Mas Agung Hamzari Akbar Habibie	Masagung.hamzari@pgn.co.id	087782748655	ORG6000721	SATKER6001230	20171204103705
EMP6002361	0010862521	Faris Arianto Aji	Faris.Ariantoaji@pgn.co.id	002129207588	ORG6000482		20171204103705
EMP6002362	0085641003	Rini  Restumi	Rini.Restumi@pgn.co.id	08111743962	ORG6000459	SATKER6001218	20171204103705
EMP6002363	0012862669	Rahmat Akbar Muttaqin	Rahmat.Muttaqin@pgn.co.id	081320431798	ORG6000808		20171204103705
EMP6002364	1092681480	Tri  Yuliantoro	Tri.Yuliantoro@pgn.co.id	0811841531	ORG6000184	SATKER6001221	20171204103705
EMP6002365	1005802024	Andi  Budiansyah	Andi.Budiansyah@pgn.co.id	081381183898	ORG6000836	SATKER6001212	20171204103705
EMP6002366	2001811853	Dedy Tulus Pambudi	Dedy.Pambudi@pgn.co.id	08113430788	ORG6000935	SATKER6001213	20171204103705
EMP6002367	0010822500	Faiz Fairussani Albananiy	Faiz.Albananiy@pgn.co.id	081519981844	ORG6000126	SATKER6001211	20171204103705
EMP6002368	3004781980	Eva Marito Daulay	Eva.Daulay@pgn.co.id	8126315636	ORG6000782		20171204103705
EMP6002369	0007852333	Mahar  Prasetyo	Mahar.Prasetyo@pgn.co.id	08158777266	ORG6000714	SATKER6001234	20171204103705
EMP6002370	1008822350	Edwin  Prioneanto	Edwin.Prioneanto@pgn.co.id	087707072014	ORG6001011	SATKER6001211	20171204103705
EMP6002371	0010862441	Pri Endi Ariawan	Pri.Endi@pgn.co.id	081575015666	ORG6000406	SATKER6001234	20171204103705
EMP6002372	0007832307	  Herlenika	Herlenika@pgn.co.id	087809747140	ORG6000704	SATKER6001234	20171204103705
EMP6002373	0012882691	Emi Heru Hermanto	Emi.Hermanto@pgn.co.id		ORG6000707		20171204103705
EMP6002374	0009842384	Pandu  Pradana	Pandu.Pradana@pgn.co.id	0811922774	ORG6000712		20171204103705
EMP6002375	1096701600	Ina  Herlina	Ina.Herlina@pgn.co.id	000818889551	ORG6000255	SATKER6001223	20171204103705
EMP6002376	0010872600	Estomihi Rehobot Lumbantobing	estomihi.tobing@pgn.co.id	08111180497	ORG6000191	SATKER6001213	20171204103705
EMP6002377	1096771622	  Supratman	Supratman@pgn.co.id	08121312616	ORG6000203	SATKER6001224	20171204103705
EMP6002378	2001821854	Rizal  Yuniarto	Rizal.Yuniarto@pgn.co.id	08113432011	ORG6000306		20171204103705
EMP6002379	3089691384	Ratna Dewi Siregar	Ratna.Siregar@pgn.co.id	8126085386	ORG6000315	SATKER6001215	20171204103705
EMP6002380	0007842322	Rika Sulastri Panjaitan	Rika.Panjaitan@pgn.co.id	10128763	ORG6000502	SATKER6001256	20171204103705
EMP6002381	3004791987	Riki  Yazwardi	Riki.Yazwardi@pgn.co.id	081361081200	ORG6001120	SATKER6001218	20171204103705
EMP6002382	0012872689	Hari  Wiryawan	Hari.Wiryawan@pgn.co.id	087879797934	ORG6000575	SATKER6001217	20171204103705
EMP6002383	0010842550	Debora Kristina Silalahi	Debora.Silalahi@pgn.co.id	08111520099	ORG6000074	SATKER6001211	20171204103705
EMP6002384	1008832353	Jomaren Tuah Saragih	Jomaren.Saragih@pgn.co.id	081263357989	ORG6001174	SATKER6001211	20171204103705
EMP6002385	0004762006	Wahyu  Hardian	Wahyu.Hardian@pgn.co.id	08118897576	ORG6000460	SATKER6001218	20171204103705
EMP6002386	0010882474	Nanda  Prawita	Nanda.Prawita@pgn.co.id	6285759007188	ORG6000790	SATKER6001218	20171204103705
EMP6002387	1583650935	  Paimin	Paimin@pgn.co.id	08111174905	ORG6000880	SATKER6001234	20171204103705
EMP6002388	0010892494	Wahyu Reza Prahara	Wahyu.Reza@pgn.co.id	08111887878	ORG6000744	SATKER6001234	20171204103705
EMP6002389	1088631249	Nurul Rozana Hosen	Nurul.Rozana@pgn.co.id	0811882033	ORG6001005		20171204103705
EMP6002390	0007812287	Kurnia  Permasari	Kurnia.Permasari@pgn.co.id	10111757	ORG6000384	SATKER6001209	20171204103705
EMP6002391	1587651133	  Suwanto	Suwanto@pgn.co.id	081511416938	ORG6000188	SATKER6001221	20171204103705
EMP6002392	0005802080	Galuh  Kusumaningtyas	Galuh.Kusumaningtyas@pgn.co.id	08164244834	ORG6000189	SATKER6001221	20171204103705
EMP6002393	0089691353	Ojak Lumban Tobing	Ojak.Tobing@pgn.co.id	081574593038	ORG6000919		20171204103705
EMP6002394	0007822293	Astrid Taruli Debora	Astrid.Debora@pgn.co.id	08118770912	ORG6000911		20171204103705
EMP6002395	0005822096	Yatmoko  Nugroho	Yatmoko.Nugroho@pgn.co.id	00818999772	ORG6000445	SATKER6001251	20171204103705
EMP6002396	3089661302	  Yusnani	Yusnani@pgn.co.id	585370076	ORG6000471		20171204103705
EMP6002397	0005832163	Andini  Saraswati	Andini.Saraswati@pgn.co.id	082112308083	ORG6000934		20171204103705
EMP6002398	0005792069	Mohammad Rasyid Ridha	rasyid.ridha@pgn.co.id	02182616085	ORG6000155	SATKER6001253	20171204103705
EMP6002399	0007802282	Bayu Lambang Pamungkas	Bayu.Pamungkas@pgn.co.id	0274547031	ORG6000567	SATKER6001211	20171204103705
EMP6002400	2099771755	Wahyudi Eko Prasetyo	wahyudi.eko@pgn.co.id	081252341333	ORG6000094	SATKER6001211	20171204103705
EMP6002401	0001781840	  Imron	Imron@pgn.co.id	08161416265	ORG6000745	SATKER6001243	20171204103705
EMP6002402	1092651470	  Rojali	Rojali@pgn.co.id	1116366	ORG6000748	SATKER6001234	20171204103705
EMP6002403	2488651146	Hari  Nurcahyanto	Hari.Nurcahyanto@pgn.co.id	024-76728038	ORG6000770	SATKER6001234	20171204103705
EMP6002404	0006812178	Nita  Widyasumanti	Nita.Widyasumanti@pgn.co.id	08111.099612	ORG6001076		20171204103705
EMP6002405	3097771723	  Musanif	Musanif@pgn.co.id	0811614699	ORG6001034	SATKER6001211	20171204103705
EMP6002406	0012892713	Gde Wahyu Utama	Gde.Wahyu@pgn.co.id		ORG6001018	SATKER6001211	20171204103705
EMP6002407	0010882536	Agung Harum Prasetyo	Agung.Prasetyo@pgn.co.id		ORG6001181	SATKER6001211	20171204103705
EMP6002408	0012892701	Raden Roro Listya Paramita Widhyasari	Listya.Paramita@pgn.co.id		ORG6001141	SATKER6001217	20171204103705
EMP6002409	0097721704	  Wibisono	Wibisono@pgn.co.id	0816751791	ORG6000903	SATKER6001208	20171204103705
EMP6002410	0086631057	Liza Soenar Windarti	Liza.Windarti@pgn.co.id	0811103440	ORG6000656	SATKER6001208	20171204103705
EMP6002411	0097711700	Yoga  Trihono	Yoga.Trihono@pgn.co.id	08126011021		SATKER6001239	20171204103705
EMP6002412	0099731775	Tatit Sri Jayendra	Tatit.Jayendra@pgn.co.id	021-75882919			20171204103705
EMP6002413	0003751883	Rikrik  Gantina	Rikrik.Gantina@pgn.co.id	081315623299		SATKER6001273	20171204103705
EMP6002414	0002761863	Irlita  Findyasari	irlita.findyasari@pgn.co.id				20171204103705
EMP6002415	0003791910	Agoeng Pratomo Noegroho	Agoeng.Noegroho@pgn.co.id	08126008345	ORG6001109		20171204103705
EMP6002416	0004781962	Adityo  Triwinarko	Adityo.Triwinarko@pgn.co.id	29050651		SATKER6001211	20171204103705
EMP6002417	0089671347	Endang  Suryadi	Endang.Suryadi@pgn.co.id	302217123			20171204103705
EMP6002418	0094661527	Adi  Ekawan	Adi.Ekawan@pgn.co.id	1223.12200768		SATKER6001239	20171204103705
EMP6002419	0099721770	Arie Susanto Tjahyono	Arie.Tjahyono@pgn.co.id	0122327202703		SATKER6001239	20171204103705
EMP6002420	0099751792	Ihda  Maftuhah	Ihda.Maftuhah@pgn.co.id	081584040955	ORG6000648	SATKER6001236	20171204103705
EMP6002421	2096751681	Mohammad Khoirul Huda	M.Khoirul.Huda@pgn.co.id	0215375004		SATKER6001239	20171204103705
EMP6002422	0005792062	Faried  Yahya	Faried.Yahya@pgn.co.id	02154215809		SATKER6001268	20171204103705
EMP6002423	0003731876	Jonson Mardongan Simanjuntak	jonson.m@pgn.co.id	077 8408 4000		SATKER6001211	20171204103705
EMP6002424	0004761919	Martas Bony Setyawan	Martas.Setyawan@pgn.co.id	081514038634			20171204103705
EMP6002425	0004771956	Destri Rusi Widiasari	Destri.Widiasari@pgn.co.id	08180288882		SATKER6001252	20171204103705
EMP6002426	0005802078	Feri Arif Hidayat	Feri.Hidayat@pgn.co.id	08176600425			20171204103705
EMP6002427	0005832165	Syah  Abimoro	Syah.Abimoro@pgn.co.id	0812-13782347			20171204103705
EMP6002428	0088671163	Asih  Haryasih	Asih.Haryasih@pgn.co.id	0214894049		SATKER6001259	20171204103705
EMP6002429	1096741611	  Siswanto	Siswanto.1611@pgn.co.id	02177885942		SATKER6001239	20171204103705
EMP6002430	1583620939	Cana  Bana	Cana.Bana@pgn.co.id	081311492947		SATKER6001218	20171204103705
EMP6002431	2095751564	Hary  Sukartono	Hary.Sukartono@pgn.co.id			SATKER6001239	20171204103705
EMP6002432	3097731712	Bode Verri Fair Sitorus	Bode.Sitorus@pgn.co.id	08116000173		SATKER6001239	20171204103705
EMP6002433	2096721671	  Suyono	Suyono.1671@pgn.co.id	08113380096		SATKER6001239	20171204103705
EMP6002434	0007822288	Sigit Tri Hartanto Sukamto	Sigit.Sukamto@pgn.co.id	08111.462304			20171204103705
EMP6002435	0007842317	Intan Rohma Yulianti	Intan.Yulianti@pgn.co.id	08121551113		SATKER6001218	20171204103705
EMP6002436	1596721644	Joni  Ristianto	Joni.Ristianto@pgn.co.id	08121061039		SATKER6001239	20171204103705
EMP6002437	3097721711	Juvinus  Sembiring	Juvinus.Sembiring@pgn.co.id	08117203446		SATKER6001239	20171204103705
EMP6002438	0005822099	Rahadiyah Niken Damarjati	Rahadiyah.Damarjati@pgn.co.id			SATKER6001263	20171204103705
EMP6002439	0007832304	Bobby Aditya Cahya Ananda	Bobby.Ananda@pgn.co.id			SATKER6001239	20171204103705
EMP6002440	0007862335	Firman  Budiman	Firman.Budiman@pgn.co.id	08112222603		SATKER6001239	20171204103705
EMP6002441	0009852394	Purnawan Tirta Yuwana	Purnawan.Yuwana@pgn.co.id			SATKER6001239	20171204103705
EMP6002442	0010852419	Bayu Eko Prabowo	Bayu.Eko@pgn.co.id			SATKER6001239	20171204103705
EMP6002443	0010852437	Dedi Saputra Sirait	Dedi.Saputra@pgn.co.id			SATKER6001239	20171204103705
EMP6002444	0010872485	Mohamad Rifqi Al Yusebqi	mori.alyusebqi@pgn.co.id			SATKER6001239	20171204103705
EMP6002445	0010882621	Lukman  Ferdiyanto	Lukman.Ferdiyanto@pgn.co.id	085232130045		SATKER6001239	20171204103705
EMP6002446	0089691411	Benhur  Wahyudin	Benhur.Wahyudin@pgn.co.id	081317914012		SATKER6001239	20171204103705
EMP6002447	1095711582	Berman  Sianipar	Berman.Sianipar@pgn.co.id	081310877035		SATKER6001266	20171204103705
EMP6002448	2095671567	Hary  Siswanto	Hary.Siswanto@pgn.co.id	08123280216		SATKER6001239	20171204103705
EMP6002449	3089651298	  Suwito	Suwito@pgn.co.id			SATKER6001239	20171204103705
EMP6002450	0009862396	Sanghiang Bikeu Hejang	Sanghiang.Hejang@pgn.co.id			SATKER6001239	20171204103705
EMP6002451	0088641164	Rentalin  Sihite	Rentalin.Sihite@pgn.co.id	0214567899		SATKER6001218	20171204103705
EMP6002452	1008872367	Bobby Bayu Mahardika	Bobby.Mahardika@pgn.co.id	08117133433		SATKER6001218	20171204103705
EMP6002453	0010852576	Deni Eko Listiono	Denny.Listiono@pgn.co.id			SATKER6001239	20171204103705
EMP6002454	0010882607	  Maftukhin	Maftukhin@pgn.co.id	085217900123		SATKER6001239	20171204103705
EMP6002455	0012832650	Adi  Martono	Adi.Martono@pgn.co.id			SATKER6001239	20171204103705
EMP6002456	0089611393	  Sutaryo	Sutaryo@pgn.co.id			SATKER6001239	20171204103705
EMP6002457	0089661408	Zukarim  Jihar	Zulkarim.Djihar@pgn.co.id			SATKER6001239	20171204103705
EMP6002458	0092681433	Asna  Suala	Asna.Suala@pgn.co.id			SATKER6001239	20171204103705
EMP6002459	0099672201	  Supandi	Supandi.22012@pgn.co.id			SATKER6001239	20171204103705
EMP6002460	1007852255	Haris  Budiman	Haris.Budiman@pgn.co.id			SATKER6001239	20171204103705
EMP6002461	1583640946	  Risbandi	Risbandi@pgn.co.id			SATKER6001239	20171204103705
EMP6002462	2004842016	Yuniar  Iswari	Yuniar.Iswari@pgn.co.id			SATKER6001218	20171204103705
EMP6002463	2004852020	Muhammad Feqih Fadjri	Mohammad.Fadjri@pgn.co.id	085735300202		SATKER6001238	20171204103705
EMP6002464	3089631291	Van Richolf Sihombing	Van.Sihombing@pgn.co.id			SATKER6001239	20171204103705
EMP6002465	0010832547	  Ferry	Ferry@pgn.co.id			SATKER6001239	20171204103705
EMP6002466	3086641069	  Suwardi	Suwardi@pgn.co.id			SATKER6001218	20171204103705
EMP6002467	0004692000	Hasan  Gunadi	Hasan.Gunadi@pgn.co.id			SATKER6001238	20171204103705
EMP6002468	3092711454	Lisye Meida Rosintan Parhusip	Lisye.Parhusip@pgn.co.id			SATKER6001218	20171204103705
EMP6002469	0003801914	Houstina Dewi Anggraini	Houstina.Anggraini@pgn.co.id	02177217129	ORG6000667		20171204103705
EMP6002470	0012882696	Ide Dia Selly	Ide.Selly@pgn.co.id	087885575703	ORG6000887	SATKER6001211	20171204103705
EMP6002471	0012882695	Alexander  Zulkarnain	Alexander.Zulkarnain@pgn.co.id	0217317688	ORG6001041	SATKER6001211	20171204103705
EMP6002472	0017962796	Arsa Setya Dewanta	Arsa.Dewanta@pgn.co.id			SATKER6001210	20171204103705
EMP6002473	0012912735	Ahmadtama Zamirudin Fauzi	Ahmadtama.Fauzi@pgn.co.id		ORG6000732	SATKER6001243	20171204103705
EMP6002474	0017962798	Septian Dwi Wicaksono	Septian.Wicaksono@pgn.co.id	089654882098		SATKER6001210	20171204103705
EMP6002475	0012892716	Muhammad Reza Lutfi Angga	Muhammad.Angga@pgn.co.id		ORG6000571	SATKER6001211	20171204103705
EMP6002476	0099682185	  Muhasyim	Muhasyim@pgn.co.id		ORG6000572	SATKER6001211	20171204103705
EMP6002477	0011902634	Muhammad Syaiful Arifin	Muhammad.Arifin@pgn.co.id		ORG6000335	SATKER6001230	20171204103705
EMP6002478	0012812656	Nova Putri Widianingrum	Nova.Widianingrum@pgn.co.id		ORG6000562	SATKER6001254	20171204103705
EMP6002479	0007852328	Rini  Sukmana	Rini.Sukmana@pgn.co.id		ORG6000436	SATKER6001251	20171204103705
EMP6002480	0099642199	  Sumarto	Sumarto@pgn.co.id		ORG6001104	SATKER6001218	20171204103705
EMP6002481	0005802120	Halida  Ferani	Halida.Ferani@pgn.co.id	082308237313	ORG6000640	SATKER6001219	20171204103705
EMP6002482	0005812138	Yuniar Kusrini Mutinanta	Yuniar.Mutinanta@pgn.co.id	081380156828	ORG6000962	SATKER6001220	20171204103705
EMP6002483	0010872466	Deni Karsa Pamungkas	Deni.Pamungkas@pgn.co.id		ORG6000622	SATKER6001220	20171204103705
EMP6002484	0010882615	Fitria Ratna Yuniarti	Fitria.Yuniarti@pgn.co.id		ORG6000620	SATKER6001220	20171204103705
EMP6002485	1008792346	Moniek Trilaksmi Uliani Dewi	Moniek.Dewi@pgn.co.id		ORG6000908	SATKER6001236	20171204103705
EMP6002486	1596711639	Lala  Kumalawati	Lala.Kumalawati@pgn.co.id		ORG6000193	SATKER6001221	20171204103705
EMP6002487	0016952783	Andreas Readika Bagus Kusuma	Andreas.Kusuma@pgn.co.id		ORG6000981	SATKER6001216	20171204103705
EMP6002488	0012912737	Tegar Kharisma Nugraha	tegar.nugraha@pgn.co.id	0813 3199 1118	ORG6000809		20171204103705
EMP6002489	0010842412	Fajar Muhammad Sidiq	Fajar.Sidiq@pgn.co.id	08113553344	ORG6000752	SATKER6001222	20171204103705
EMP6002490	0010852435	Havid Noviastanto Wahyudi	Havid.Noviastanto@pgn.co.id	081336230448	ORG6000766	SATKER6001222	20171204103705
EMP6002491	0010852568	Yandi  Azhari	Yandi.Azhari@pgn.co.id		ORG6000774		20171204103705
EMP6002492	0017962791	Haris  Wicaksono	Haris.Wicaksono@pgn.co.id			SATKER6001210	20171204103705
EMP6002493	0007852332	Niken Astria Safitri	Niken.Safitri@pgn.co.id		ORG6001020	SATKER6001211	20171204103705
EMP6002494	0014932763	Niken Putri Pratiwi	Niken.Pratiwi@pgn.co.id	085228029993	ORG6000168	SATKER6001213	20171204103705
EMP6002495	1008842355	  Sugiyanto	Sugiyanto@pgn.co.id		ORG6000258	SATKER6001223	20171204103705
EMP6002496	0016952786	Dinda Ayu Naria	Dinda.Naria@pgn.co.id		ORG6000985	SATKER6001216	20171204103705
EMP6002497	1008892371	Johannes Reybli Manurung	Johannes.Manurung@pgn.co.id		ORG6000831	SATKER6001221	20171204103705
EMP6002498	1088641186	  Amsar	Amsar@pgn.co.id		ORG6000249	SATKER6001225	20171204103705
EMP6002499	3090631413	Roster  Hutagalung	Roster.Hutagalung@pgn.co.id		ORG6000320	SATKER6001215	20171204103705
EMP6002500	0094671533	Sri Nanda Parwati	Sri.Parwati@pgn.co.id	08111680700	ORG6000343		20171204103705
EMP6002501	1096751614	Agung  Kusbiantoro	Agung.Kusbiantoro@pgn.co.id	0811 3402299	ORG6000101	SATKER6001211	20171204103705
EMP6002502	0004791936	Widhi  Astuti	Widhi.Astuti@pgn.co.id	08980001357	ORG6000522		20171204103705
EMP6002503	0097731706	Rachmat  Hutama	rachmat.hutama@pgn.co.id	121122200332	ORG6000439	SATKER6001214	20171204103705
EMP6002504	0004771958	Nurwulan Eka Wahyuni	Nurwulan.Wahyuni@pgn.co.id	081314718719	ORG6000201	SATKER6001216	20171204103705
EMP6002505	0094691537	Danasworo  Nurprasetyo	Danasworo.Nur@pgn.co.id	021 - 82400515	ORG6000857	SATKER6001211	20171204103705
EMP6002506	0088621243	Wahyu  Irianto	Wahyu.Irianto@pgn.co.id	08111803875	ORG6001028		20171204103705
EMP6002507	0089651370	  Purwoto	Purwoto@pgn.co.id	0811833516	ORG6000532	SATKER6001252	20171204103705
EMP6002508	2002821868	Imam  Musyafa	Imam.Musyafa@pgn.co.id	082139189350	ORG6000402	SATKER6001227	20171204103705
EMP6002509	0010882538	Rozalita  Asriati	Rozalita.Asriati@pgn.co.id	081213587681	ORG6000690	SATKER6001219	20171204103705
EMP6002510	0094651545	  Mukimin	Mukimin@pgn.co.id	08119162011	ORG6000597		20171204103705
EMP6002511	0005792064	Reza  Maghraby	Reza.Maghraby@pgn.co.id	08111898454	ORG6000140		20171204103705
EMP6002512	0001791843	Yohanes  Chandra	Yohanes.Chandra@pgn.co.id	08111681263	ORG6000240	SATKER6001213	20171204103705
EMP6002513	0092681495	Lita  Sriwulandari	Lita.Sriwulandari@pgn.co.id	08159525333	ORG6000450	SATKER6001214	20171204103705
EMP6002514	0088631255	Achmad  Yulianto	Achmad.Yulianto@pgn.co.id	0215654852	ORG6000492	SATKER6001256	20171204103705
EMP6002515	0094671531	Hadyan Ardi Bhusana	Hadyan.Ardi@pgn.co.id	081511400294	ORG6000495	SATKER6001256	20171204103705
EMP6002516	0088651165	  Apriyadi	Apriyadi@pgn.co.id	0811801521	ORG6000370		20171204103705
EMP6002517	0007832305	Jauhar Gama Kurniawan	Jauhar.Gama@pgn.co.id	0811-003621438	ORG6000400	SATKER6001244	20171204103705
EMP6002518	0099721767	Henry  Gunawan	Henry.Gunawan@pgn.co.id	122844902271	ORG6000796		20171204103705
EMP6002519	0004821949	Farah Tri Astiniah	Farah.Astiniah@pgn.co.id	08158081124	ORG6000559	SATKER6001254	20171204103705
EMP6002520	1005802026	Asep Saiful Bahri	Asep.Bahri@pgn.co.id	08112228285	ORG6000163	SATKER6001213	20171204103705
EMP6002521	0010832410	Wahyu Adhy Nugroho Ramona	Wahyu.Adhy@pgn.co.id	081310322446	ORG6000463	SATKER6001214	20171204103705
EMP6002522	0010842508	Atika Indra Dhewanti	Atika.Dhewanti@pgn.co.id	08119718000	ORG6000449	SATKER6001214	20171204103705
EMP6002523	0012872684	Silvi Oktavia Zennita	Silvi.Zennita@pgn.co.id	08111050909	ORG6000483	SATKER6001240	20171204103705
EMP6002524	3004781981	Hasbi  Sidiq	Hasbi.Sidiq@pgn.co.id	08111888657	ORG6000863	SATKER6001211	20171204103705
EMP6002525	1087641103	Nella  Yakoba	Nella.Yacoba@pgn.co.id	081386876134	ORG6001065	SATKER6001218	20171204103705
EMP6002526	0089651406	  Tasrifudin	Tasrifudin@pgn.co.id	02518615869	ORG6000534	SATKER6001252	20171204103705
EMP6002527	0010872455	Seto Agung Putranto	Seto.putranto@pgn.co.id	081213895134	ORG6000802	SATKER6001234	20171204103705
EMP6002528	0012872686	Rahmat  Ranudigdo	Rahmat.Ranudigdo@pgn.co.id	081286505327	ORG6000734	SATKER6001243	20171204103705
EMP6002529	1007822213	Magresa  Hendariawan	Magresa.Hendariawan@pgn.co.id	00122812300596	ORG6000885	SATKER6001234	20171204103705
EMP6002530	0092691435	  Rosidin	Rosidin@pgn.co.id	0215 5650152	ORG6001021	SATKER6001211	20171204103705
EMP6002531	2002821870	Sugianto Eko Cahyono	Sugianto.Cahyono@pgn.co.id	081330771138	ORG6000167	SATKER6001213	20171204103705
EMP6002532	0010872463	Thoriq Ganang Prakoso	Thoriq.Ganang@pgn.co.id	081332065859	ORG6000313	SATKER6001213	20171204103705
EMP6002533	0012862672	Dewi  Wulandari	Dewi.Wulandari@pgn.co.id	08118119070	ORG6000157	SATKER6001253	20171204103705
EMP6002534	0004771957	  Fujianti	Fujianti@pgn.co.id	08128592061	ORG6000581	SATKER6001211	20171204103705
EMP6002535	0010862448	Fivin Ari Suwandhana	Fivin.Ari@pgn.co.id	08113522704	ORG6000391	SATKER6001209	20171204103705
EMP6002536	0009842385	Muhammad Alwi Huda	Alwi.Huda@pgn.co.id	085352505458	ORG6000754	SATKER6001222	20171204103705
EMP6002537	1089641315	Chaerullah  Atmaja	Chaerullah.Atmadja@pgn.co.id	00081380878731	ORG6000285	SATKER6001223	20171204103705
EMP6002538	0010882471	Roby  Syahputra	Roby.Syahputra@pgn.co.id	08111788884	ORG6000221	SATKER6001213	20171204103705
EMP6002539	1096711604	  Sadewo	Sadewo@pgn.co.id	08159511971	ORG6000205	SATKER6001213	20171204103705
EMP6002540	2099761749	Agus Arif Pramudiharto	Agus.Pramudiharto@pgn.co.id	081230191311	ORG6000392	SATKER6001227	20171204103705
EMP6002541	3097741717	Feron Edyka Putra Simanjuntak	Feron.Simanjuntak@pgn.co.id	8126467422	ORG6000883	SATKER6001213	20171204103705
EMP6002542	0010862452	Wahyu Al Fashshi	Wahyu.AlFashshi@pgn.co.id		ORG6000362	SATKER6001213	20171204103705
EMP6002543	0011892628	Kurniawan Agung Pambudi	kurniawan.pambudi@pgn.co.id	081392684070	ORG6001121	SATKER6001211	20171204103705
EMP6002544	2001811852	Aman  Setiadji	Aman.Setiadji@pgn.co.id	081931549551	ORG6001027		20171204103705
EMP6002545	2007812229	Bagus  Fernata	Bagus.Fernata@pgn.co.id	08111778015	ORG6000361	SATKER6001216	20171204103705
EMP6002546	0005812140	Igung Aris Hermanu	Igung.Hermanu@pgn.co.id	081319511933	ORG6000800		20171204103705
EMP6002547	1005832041	Anisa  Muzzammil	Anisa.Muzzamil@pgn.co.id	081212601520	ORG6000971	SATKER6001234	20171204103705
EMP6002548	0012912731	Muhammad Febrian Dwi Utama Putra	Febrian.Putra@pgn.co.id	085743289696	ORG6000991	SATKER6001226	20171204103705
EMP6002549	0009832401	Sundung Jadiaman Silaban	Sundung.Silaban@pgn.co.id	082125383299	ORG6001008	SATKER6001211	20171204103705
EMP6002550	0010872458	Ferman  Hakiki	Ferman.Hakiki@pgn.co.id	08113522703	ORG6000764	SATKER6001222	20171204103705
EMP6002551	0007832309	Didiet  Pradityo	Didiet.Pradityo@pgn.co.id	8195000999	ORG6001096		20171204103705
EMP6002552	1088641188	Chairiah  Mustafa	Chairiah.Mustafa@pgn.co.id	0122420298045	ORG6000208	SATKER6001213	20171204103705
EMP6002553	1096671597	Rudi  Kuswandi	Rudi.Kuswandi@pgn.co.id	081286405647	ORG6000372		20171204103705
EMP6002554	0001791844	Indriani  Sukma	Indriani.Sukma@gagas.co.id	08129565886			20171204103705
EMP6002555	0098701730	Primaningayu Endah Wardhani	primaningayu.endah@pgn.co.id	021-70998055	ORG6001024		20171204103705
EMP6002556	0005782056	Dwi Maryono Ari Wibowo	Dwi.Ari.Wibowo@pgn.co.id	0370-634164	ORG6001187	SATKER6001211	20171204103705
EMP6002557	0092641497	Vincensia Sri Lestari Nugrohowati	Vincensia.Lestari@pgn.co.id	02155751159	ORG6000458	SATKER6001218	20171204103705
EMP6002558	2095751565	Agus Budi Prasetyo	Agus.Prasetiyo@pgn.co.id	081332367282	ORG6000296	SATKER6001213	20171204103705
EMP6002559	0005802077	Krisdyan Widagdo Adhi	krisdyan.widagdo@pgn.co.id	081111682368	ORG6000878	SATKER6001229	20171204103705
EMP6002560	0095721587	Wawan  Hermawan	Wawan.Hermawan@pgn.co.id	02177203429	ORG6000949	SATKER6001218	20171204103705
EMP6002561	0004771921	Wuriana  Irawati	Wuriana.Irawati@pgn.co.id	0251 7534939	ORG6001086	SATKER6001230	20171204103705
EMP6002562	0004791939	Mukhamad Andi Rahman	M.Andi.Rahman@pgn.co.id	081373061143	ORG6001115	SATKER6001211	20171204103705
EMP6002563	2095661549	Sentot  Suhartono	Sentot.Suhartono@pgn.co.id	0812 318 2242	ORG6001175	SATKER6001211	20171204103705
EMP6002564	0005792113	Barlian Kahuripan Utomo	Barlian.Utomo@pgn.co.id	081315969024	ORG6000149	SATKER6001253	20171204103705
EMP6002565	0095691576	Agus  Sukriya	Agus.Sukriya@pgn.co.id	08161621731	ORG6000148	SATKER6001253	20171204103705
EMP6002566	0005822107	Agung Rahmat Kurniansyah	Agung.Kurniansyah@pgn.co.id	628176603130	ORG6000719		20171204103705
EMP6002567	0012892718	Devita  Sari	Devita.Sari@pgn.co.id	08111875555	ORG6001144	SATKER6001211	20171204103705
EMP6002568	0012892711	Adwitiya Narendra Wityasmoro	Adwitiya.Wityasmoro@pgn.co.id		ORG6001031	SATKER6001254	20171204103705
EMP6002569	0012862674	Surya Dwi Kurniawan	Surya.Kurniawan@pgn.co.id		ORG6001075	SATKER6001236	20171204103705
EMP6002570	0012872677	Bima Satria Agung	Bima.Agung@pgn.co.id	0811335360	ORG6000762	SATKER6001222	20171204103705
EMP6002571	0097701699	Sahat Parlindungan Simarmata	Sahat.Simarmata@pgn.co.id	021.8565414		SATKER6001220	20171204103705
EMP6002572	0089631333	Ismet Syariful Alamsyah Pane	Ismet.Pane@pgn.co.id	0217513484			20171204103705
EMP6002573	0099721771	Ahmad Arief Rivai	Ahmad.Rivai@pgn.co.id	02153152127		SATKER6001269	20171204103705
EMP6002574	0003781902	Devi  Damayanti	Devi.Damayanti@pgn.co.id	008128005741		SATKER6001216	20171204103705
EMP6002575	0003791907	Darmoko Anggar Setyadi	Darmoko.Setyadi@pgn.co.id	08128266572		SATKER6001239	20171204103705
EMP6002576	0004781961	Rachmadi Bagus Murdhono	Rachmadi.Murdhono@pgn.co.id	081514735935			20171204103705
EMP6002577	0004801940	  Herlina	Herlina@pgn.co.id	021892308		SATKER6001217	20171204103705
EMP6002578	0005802125	Resi  Aseanto	Resi.Aseanto@pgn.co.id	081369724284		SATKER6001239	20171204103705
EMP6002579	0005812132	Appie Yudana Antono	appie.yudana@pgn.co.id	08174878818			20171204103705
EMP6002580	0094661526	M. Hidayat Setiaputra	M.Hidayat.Setiaputra@pgn.co.id	021-84936099		SATKER6001239	20171204103705
EMP6002581	0098731737	  Taryaka	Taryaka@pgn.co.id	081364807277			20171204103705
EMP6002582	0005812141	Hadiyaksa  Utama	Hadiyaksa@pgn.co.id	08118707881			20171204103705
EMP6002583	0007842324	David Ade Saputra	David.Saputra@pgn.co.id	02518571071		SATKER6001230	20171204103705
EMP6002584	2095721559	Anang  Wahyudi	Anang.Wahyudi@pgn.co.id	08155014576			20171204103705
EMP6002585	0002731860	Ferry Imron Andreas Simandjuntak	Ferry.Andreas.Siman@pgn.co.id	081807440980		SATKER6001239	20171204103705
EMP6002586	0004681996	R. Hanny  Setiawan	R.Hanny.Setiawan@pgn.co.id	0215844201		SATKER6001239	20171204103705
EMP6002587	0007802277	Hetty Kusuma Waty	Hetty.Kusumawaty@pgn.co.id	0218219466	ORG6000085		20171204103705
EMP6002588	0007802279	Herry  Rachmadi	Herry.Rachmadi@pgn.co.id			SATKER6001239	20171204103705
EMP6002589	0089651342	Sofie  Sofiana	Sofie.Sofiana@pgn.co.id	50002195			20171204103705
EMP6002590	0094661528	  Noverdi	Noverdi@pgn.co.id				20171204103705
EMP6002591	0099771801	Arie  Kusmayadi	arie.kusmayadi@pgn.co.id	089652882873			20171204103705
EMP6002592	2096751683	Hendhi  Trihadmoko	Hendhi.Trihadmoko@pgn.co.id	03151500348		SATKER6001239	20171204103705
EMP6002593	3097771724	Tonny Hartono Hutagalung	Tonny.Hutagalung@pgn.co.id	08117702465		SATKER6001239	20171204103705
EMP6002594	0005812139	Ade Firman Hayatul Kalam	Ade.Kalam@pgn.co.id	08119953027			20171204103705
EMP6002595	2096771658	  Sunanto	Sunanto@pgn.co.id	08155007679		SATKER6001269	20171204103705
EMP6002596	3086651074	Bahman  Efendy	Bahman.Efendi@pgn.co.id	08117780572		SATKER6001239	20171204103705
EMP6002597	0005822154	Haryo  Priantomo	Haryo.Priantomo@pgn.co.id	08126047803		SATKER6001218	20171204103705
EMP6002598	1005812045	Agus Muhammad Merzi	Agus.Merzi@pgn.co.id			SATKER6001239	20171204103705
EMP6002599	1088621177	  Soedarwanto	Soedarwanto@pgn.co.id			SATKER6001239	20171204103705
EMP6002600	1588651278	  Tohandi	Tohandi@pgn.co.id			SATKER6001238	20171204103705
EMP6002601	0005792117	Novita Anggraeni Siregar	Novita.Siregar@pgn.co.id	021-88340775			20171204103705
EMP6002602	0007872266	Muhammad  Sanne	Muhammad.Sanne@pgn.co.id			SATKER6001239	20171204103705
EMP6002603	0007882271	Ardith Wedha Sudana	Ardith.Wedha@pgn.co.id			SATKER6001239	20171204103705
EMP6002604	0009852392	Hendra Saputra Dunggio	Hendra.Saputra@pgn.co.id				20171204103705
EMP6002605	0009852395	Mohamad Yogi Novianto	Yogi.Novianto@pgn.co.id			SATKER6001239	20171204103705
EMP6002606	0009872399	Rizki Wijanarto Budiman	Rizki.Budiman@pgn.co.id			SATKER6001239	20171204103705
EMP6002607	0010852555	Ija  Misja	Ija.Misja@pgn.co.id			SATKER6001239	20171204103705
EMP6002608	0010852559	Ferry  Wihardi	Ferry.Wihardi@pgn.co.id				20171204103705
EMP6002609	0010862447	Rudy  Salam	Rudy.Salam@pgn.co.id			SATKER6001239	20171204103705
EMP6002610	0010862581	Viet Ronal Tampubolon	Viet.Ronal@pgn.co.id			SATKER6001238	20171204103705
EMP6002611	0010872457	Femy  Femila	Femy.Femila@pgn.co.id			SATKER6001239	20171204103705
EMP6002612	0010872461	Chandra Nur Silaban	Chandra.Silaban@pgn.co.id			SATKER6001239	20171204103705
EMP6002613	0010872593	Bintang  Situmorang	bintang.situmorang@pgn.co.id			SATKER6001211	20171204103705
EMP6002614	0010882617	Dwiyoso  Pramono	Dwiyoso.Pramono@pgn.co.id			SATKER6001239	20171204103705
EMP6002615	0010892495	Valandra  Leonardo	Valandra.Leonardo@pgn.co.id			SATKER6001273	20171204103705
EMP6002616	1008852358	Rikky  Mokodompit	Rikky.Mokodompit@pgn.co.id	1023-7890		SATKER6001266	20171204103705
EMP6002617	1092691483	  Supriyanto	Supriyanto@pgn.co.id			SATKER6001239	20171204103705
EMP6002618	3089661303	Udin  Depari	Udin.Depari@pgn.co.id			SATKER6001239	20171204103705
EMP6002619	1008842357	Andi  Irawan	Andi.Irawan2357@pgn.co.id			SATKER6001239	20171204103705
EMP6002620	0009842382	Bintang Maratur Sianturi	Bintang.Sianturi@pgn.co.id	081394021882		SATKER6001239	20171204103705
EMP6002621	0010862586	Pipit Agustiyanti Mulyadi	pipit.mulyadi@pgn.co.id		ORG6000861	SATKER6001211	20171204103705
EMP6002622	0012732640	Dimas  Prianto	Dimas.Prianto@pgn.co.id			SATKER6001239	20171204103705
EMP6002623	0012822648	Hadi  Sucipto	Hadi.Sucipto@pgn.co.id	081367602442		SATKER6001239	20171204103705
EMP6002624	0096711667	  Idrul	Idrul@pgn.co.id			SATKER6001218	20171204103705
EMP6002625	0099712203	  Waluyo	Waluyo@pgn.co.id			SATKER6001239	20171204103705
EMP6002626	1085631002	  Saimin	Saimin@pgn.co.id			SATKER6001239	20171204103705
EMP6002627	2091641423	Entong  Setiyono	Entong.Setiyono@pgn.co.id			SATKER6001239	20171204103705
EMP6002628	0092651426	Ahmad  Ruskandi	Achmad.Ruskandi@pgn.co.id			SATKER6001239	20171204103705
EMP6002629	1092641463	  Tarmidi	Tarmidi@pgn.co.id			SATKER6001239	20171204103705
EMP6002630	1693611505	  Mulani	Mulani@pgn.co.id			SATKER6001238	20171204103705
EMP6002631	1693691510	  Sukardji	Sukardji@pgn.co.id			SATKER6001238	20171204103705
EMP6002632	1092651467	Farid  Muchtar	Farid.Muchtar@pgn.co.id			SATKER6001218	20171204103705
EMP6002633	0005822104	Leonardo Dapot Hasiholan	Leonardo.Pasaribu@pgn.co.id	0218294241	ORG6000591	SATKER6001211	20171204103705
\.


--
-- Data for Name: ms_global; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY ms_global (tipe, value) FROM stdin;
stat_reply	Not Replay
stat_reply	Replay
\.


--
-- Data for Name: ms_items; Type: TABLE DATA; Schema: public; Owner: syfawija
--

COPY ms_items (rowid, item_number, item_category, item_typeid, farms, kandang, status, qty, uom, craeteby, createdate, updateby, updatedate, item_name) FROM stdin;
6003118	V1	MD15	TOD7	MD2		Active	0	µL	\N	2018-02-08 11:35:40.572889+07	\N	\N	Vitamin 01
6003119	V2	MD15	TOD7	MD2		Active	0	µL	\N	2018-02-08 11:39:09.382001+07	\N	\N	Vitamin 01
6003120	V3	MD15	TOD7	MD2		Active	0	µL	\N	2018-02-08 11:39:43.161388+07	\N	\N	Vitamin 01
\.


--
-- Data for Name: ms_message; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY ms_message (rowid, programid, satkerid, nipg, tipe_message, stat_message, message, creart_by, create_date, update_by, update_date, reff_nipg) FROM stdin;
MS114	PRG5	SATKER6001252	1005832042	2	\N	1#1005832042	\N	\N	\N	\N	\N
MS115	PRG5	SATKER6001252	0005812084	2	\N	2#0005812084	\N	\N	\N	\N	\N
MS116	PRG5	SATKER6001252	0086621056	2	\N	1#0086621056	\N	\N	\N	\N	\N
MS117	PRG5	SATKER6001252	3097741716	2	\N	2#3097741716	\N	\N	\N	\N	\N
MS118	PRG5	SATKER6001252	0004631997	2	\N	2#0004631997	\N	\N	\N	\N	\N
MS25	PRG5	SATKER6001252	0005832155	1	SUCCESS|9189382959	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0005832155\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0005832155	\N	\N	\N	\N	\N
MS26	PRG5	SATKER6001252	0004771956	1	\N	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0004771956\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0004771956	\N	\N	\N	\N	\N
MS27	PRG5	SATKER6001252	0004732002	1	SUCCESS|9189378523	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0004732002\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0004732002	\N	\N	\N	\N	\N
MS28	PRG5	SATKER6001252	3097731713	1	SUCCESS|9189378526	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#3097731713\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/3097731713	\N	\N	\N	\N	\N
MS29	PRG5	SATKER6001252	0012652639	1	SUCCESS|9189378521	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0012652639\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0012652639	\N	\N	\N	\N	\N
MS30	PRG5	SATKER6001252	0001761824	1	SUCCESS|9189378529	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0001761824\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0001761824	\N	\N	\N	\N	\N
MS31	PRG5	SATKER6001252	1005832042	1	SUCCESS|9189378509	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#1005832042\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/1005832042	\N	\N	\N	\N	\N
MS32	PRG5	SATKER6001252	0089681350	1	SUCCESS|9189378532	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0089681350\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0089681350	\N	\N	\N	\N	\N
MS33	PRG5	SATKER6001252	3089651296	1	SUCCESS|9189378515	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#3089651296\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/3089651296	\N	\N	\N	\N	\N
MS34	PRG5	SATKER6001252	0005812084	1	SUCCESS|9189378510	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0005812084\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0005812084	\N	\N	\N	\N	\N
MS35	PRG5	SATKER6001252	3097741716	1	SUCCESS|9189378520	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#3097741716\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/3097741716	\N	\N	\N	\N	\N
MS36	PRG5	SATKER6001252	0004782011	1	SUCCESS|9189378524	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0004782011\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0004782011	\N	\N	\N	\N	\N
MS37	PRG5	SATKER6001252	0095721586	1	SUCCESS|9189378525	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0095721586\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0095721586	\N	\N	\N	\N	\N
MS38	PRG5	SATKER6001252	0004631997	1	SUCCESS|9189378522	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0004631997\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0004631997	\N	\N	\N	\N	\N
MS39	PRG5	SATKER6001252	0086611054	1	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0086611054\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0086611054	\N	\N	\N	\N	\N
MS40	PRG5	SATKER6001252	0004771923	1	SUCCESS|9189378512	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0004771923\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0004771923	\N	\N	\N	\N	\N
MS41	PRG5	SATKER6001252	0010882616	1	SUCCESS|9189378530	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0010882616\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0010882616	\N	\N	\N	\N	\N
MS42	PRG5	SATKER6001252	2096731651	1	SUCCESS|9189378527	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#2096731651\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/2096731651	\N	\N	\N	\N	\N
MS43	PRG5	SATKER6001252	0012862668	1	SUCCESS|9189378517	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0012862668\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0012862668	\N	\N	\N	\N	\N
MS44	PRG5	SATKER6001252	0086621056	1	SUCCESS|9189378513	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0086621056\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0086621056	\N	\N	\N	\N	\N
MS45	PRG5	SATKER6001252	0089651370	1	SUCCESS|9189378516	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0089651370\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0089651370	\N	\N	\N	\N	\N
MS46	PRG5	SATKER6001252	0089651406	1	SUCCESS|9189378519	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0089651406\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0089651406	\N	\N	\N	\N	\N
MS47	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#1005832042\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/1005832042	\N	\N	\N	\N	1005832042
MS48	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0005812084\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0005812084	\N	\N	\N	\N	0005812084
MS49	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0004771923\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0004771923	\N	\N	\N	\N	0004771923
MS50	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0086621056\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0086621056	\N	\N	\N	\N	0086621056
MS51	PRG5	SATKER6001252	\N	3	\N	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0005832155\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0005832155	\N	\N	\N	\N	0005832155
MS52	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#3089651296\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/3089651296	\N	\N	\N	\N	3089651296
MS53	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0089651370\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0089651370	\N	\N	\N	\N	0089651370
MS54	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0012862668\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0012862668	\N	\N	\N	\N	0012862668
MS55	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0089651406\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0089651406	\N	\N	\N	\N	0089651406
MS56	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#3097741716\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/3097741716	\N	\N	\N	\N	3097741716
MS57	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0012652639\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0012652639	\N	\N	\N	\N	0012652639
MS58	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0004631997\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0004631997	\N	\N	\N	\N	0004631997
MS59	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0004732002\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0004732002	\N	\N	\N	\N	0004732002
MS60	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0004782011\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0004782011	\N	\N	\N	\N	0004782011
MS61	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0095721586\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0095721586	\N	\N	\N	\N	0095721586
MS62	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#3097731713\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/3097731713	\N	\N	\N	\N	3097731713
MS63	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#2096731651\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/2096731651	\N	\N	\N	\N	2096731651
MS64	PRG5	SATKER6001252	\N	3	\N	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0086611054\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0086611054	\N	\N	\N	\N	0086611054
MS65	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0001761824\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0001761824	\N	\N	\N	\N	0001761824
MS66	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0010882616\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0010882616	\N	\N	\N	\N	0010882616
MS67	PRG5	SATKER6001252	0086611054	3	SUCCESS|9189378528	Bagaimana keadaan anda terhadap bencana\r\n\t\t\t\tGempa Sukabumi ? \r\n\t\t\t\t(1) Saya baik-baik saja  \r\n\t\t\t\t(2) Saya membutuhkan bantuan  \r\n\t\t\t\t \r\n\t\t\t\tBalas dengan format [NO_PILIHAN]#[NIPG] \r\n\t\t\t\tContoh : 1#0089681350\r\n\t\t\t\tJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id/0089681350	\N	\N	\N	\N	0089681350
\.


--
-- Data for Name: ms_orkom; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY ms_orkom (rowid, project_id, parent, activity_name, dok, no_dok, pic, tanggal, status, create_by, create_date) FROM stdin;
\.


--
-- Data for Name: ms_position; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY ms_position (rowid, id, parent, jabatan, create_date, update_date, level) FROM stdin;
ORG6000033	1	0	Direktur Utama	20171130104952	\N	\N
ORG6000034	3	1	Sekretaris Direktur Utama	20171130104952	\N	\N
ORG6000035	46	22	Kepala Dinas Latihan 5	20171130104952	\N	\N
ORG6000036	80	1	Direktur Keuangan	20171130104952	\N	3
ORG6000037	81	1	Direktur Komersial	20171130104952	\N	\N
ORG6000038	82	1	Direktur Strategi dan Pengembangan Bisnis	20171130104952	\N	\N
ORG6000039	83	1	Direktur SDM dan Umum	20171130104952	\N	\N
ORG6000040	84	1	Direktur Infrastruktur dan Teknologi	20171130104952	\N	\N
ORG6000041	109	87	Sekretaris Divisi Akuntansi (Mia Rosmawati)	20171130104952	\N	\N
ORG6000042	122	110	Sekretaris Divisi Anggaran (Ayin Furniawati)	20171130104952	\N	\N
ORG6000043	124	123	Sekretaris Divisi Keuangan Perusahaan (Tirza Raap)	20171130104952	\N	\N
ORG6000044	157	137	Sekretaris Divisi Perbendaharaan (Ela Susanti)	20171130104952	\N	\N
ORG6000045	158	80	Sekretaris Direktur Keuangan	20171130104952	\N	2
ORG6000046	159	82	Sekretaris Direktur Strategi dan Pengembangan Bisnis	20171130104952	\N	\N
ORG6000047	179	178	Sekretaris Divisi Perncanaan Strategis	20171130104952	\N	\N
ORG6000048	201	197	Senior Staff Layanan Administrasi Kesehatan (Devy)	20171130104952	\N	\N
ORG6000049	255	195	Sekretaris Divisi Layanan Umum dan Pengamanan Perusahaan	20171130104952	\N	\N
ORG6000050	316	83	Sekretaris Direktur SDM dan Umum	20171130104952	\N	\N
ORG6000051	317	194	Sekretaris Divisi Logistik	20171130104952	\N	\N
ORG6000052	357	84	Sekretaris Direktur Infrastruktur dan Teknologi	20171130104952	\N	\N
ORG6000053	360	359	Sekretaris GM SBU TSJ (Elizabeth Sukma)	20171130104952	\N	\N
ORG6000054	363	86	Sekretaris Sekper	20171130104952	\N	\N
ORG6000055	432	431	Sekretaris Kadep Keuangan dan SDM (Luh Elmia)	20171130104952	\N	\N
ORG6000056	735	732	Sekretaris Departemen Keuangan dan SDM SBU II (Inna Syah Anifta)	20171130104952	\N	\N
ORG6000057	793	782	Sekretaris Departemen Penjualan dan Layanan SBU II	20171130104952	\N	\N
ORG6000058	911	867	Sekretaris Departemen Keuangan dan SDM	20171130104952	\N	\N
ORG6000059	988	979	Sekretaris Area Bekasi SBU I (Fransisca Dyah Ayu)	20171130104952	\N	\N
ORG6000060	1056	912	Sekretaris Departemen Logistik dan Administrasi Umum SBU I	20171130104952	\N	\N
ORG6000061	1153	1115	Sekretaris Area Bogor SBU I	20171130104952	\N	\N
ORG6000062	1260	1259	Staff Administrasi Penjualan Area Bekasi SBU I	20171130104952	\N	\N
ORG6000063	1269	84	Group Head Program Management Office Infrastructure	20171130104952	\N	\N
ORG6000064	1274	1269	Division Head, Core Competencies Project	20171130104952	\N	\N
ORG6000065	1275	1269	Division Head, Project Support	20171130104952	\N	\N
ORG6000066	1276	1269	Division Head, Infrastructure Program Controlling	20171130104952	\N	\N
ORG6000067	1277	1269	Sekretaris Kepala PMO	20171130104952	\N	\N
ORG6000068	1285	1274	Koordinator Manajemen Engijiniring & Kompetensi (Widi Pancana)	20171130104952	\N	\N
ORG6000069	1287	1274	Sekretaris Divisi Kompetensi Inti	20171130104952	\N	\N
ORG6000070	1293	1275	Koordinator Accounting Project Department	20171130104952	\N	\N
ORG6000071	1296	5679	Division Head, Licence and Permit	20171130104952	\N	\N
ORG6000072	1310	4685	Fungsi Akuntansi (Wening)	20171130104952	\N	\N
ORG6000073	1311	4685	Fungsi Anggaran (Fransiska)	20171130104952	\N	\N
ORG6000074	1314	4685	Fungsi Verifikasi (Debora)	20171130104952	\N	\N
ORG6000075	1322	1276	Sekretaris Divisi Pengendalian Program Infrastruktur	20171130104952	\N	\N
ORG6000076	1345	1320	Sekretaris PMO Wilayah III (Nurul Ramadhani)	20171130104952	\N	\N
ORG6000077	1346	1319	Sekretaris Perwakilah Wilayah II (diah rahmawati)	20171130104952	\N	\N
ORG6000078	1369	1366	Staff Administrasi Penjualan Area Palembang SBU I	20171130104952	\N	\N
ORG6000079	1413	1275	Sekretaris Divisi Pendukung Proyek	20171130104952	\N	\N
ORG6000080	1418	1373	Sekretaris Area Tangerang SBU I (erien aquarina)	20171130104952	\N	\N
ORG6000081	1495	81	Sekretaris Direktur Komersil	20171130104952	\N	\N
ORG6000082	1601	1568	Sekretaris Sekretariat Korporat	20171130104952	\N	\N
ORG6000083	1884	1850	Staff Proyek Pekerjaan Pemasangan Pipa Servis Pelanggan Komersial Wilayah Surabay (Catering Mintokosumo dan Waroeng Ibu) (Agung)	20171130104952	\N	\N
ORG6000084	1885	1850	Staff Proyek Pekerjaan Pemasangan Pipa Servis Pelanggan Komersial Wilayah Surabay (Catering Mintokosumo dan Waroeng Ibu) (Arie)	20171130104952	\N	\N
ORG6000085	3306	3305	Bendahara HUT PGN ke-50 (Hetty)	20171130104952	\N	\N
ORG6000086	3318	3304	Sekretaris (Fitra Yuda)	20171130104952	\N	\N
ORG6000087	3320	1269	PM Pengembangan Infrastruktur dan Kehandalan Jaringan Sumatera Bagian Utara dan Batam	20171130104952	\N	\N
ORG6000088	3321	3320	Sekretaris Pengembangan Infrastruktur dan Kehandalan jaringan sumatera bagian utara dan batam	20171130104952	\N	\N
ORG6000089	3328	3320	Tim Pengendalian Material Pengembangan Infrastruktur dan Kehandalan jaringan sumatera bagian utara dan batam (Andi Firdaus)	20171130104952	\N	\N
ORG6000090	3336	3320	Tim Project Controller Pengembangan Infrastruktur dan Kehandalan jaringan sumatera bagian utara dan batam (Andyan Situmorang)	20171130104952	\N	\N
ORG6000091	3339	3320	Tim Engineering Pengembangan Infrastruktur dan Kehandalan jaringan sumatera bagian utara dan batam (Tampil Lumbantoruan)	20171130104952	\N	\N
ORG6000092	3361	1269	PM Pengembangan Infrastruktur dan Kehandalan Jaringan Jawa Bagian Timur dan Tengah	20171130104952	\N	\N
ORG6000093	3362	3361	Sekretaris Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah	20171130104952	\N	\N
ORG6000094	3364	3361	Tim Construction dan QA/QC & HSE Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Wahyudi Eko Prasetyo)	20171130104952	\N	\N
ORG6000095	3368	3361	Tim Construction dan QA/QC & HSE Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Hadid Azelea)	20171130104952	\N	\N
ORG6000096	3374	3361	Tim Project Controller Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Dhani Amannatur)	20171130104952	\N	\N
ORG6000097	3376	3361	Tim Engineering Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Raya Fitrian Hernasa)	20171130104952	\N	\N
ORG6000098	3379	3361	Tim Contract Adminstration Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Fri Wazanati)	20171130104952	\N	\N
ORG6000099	3383	3382	Sekretaris Proyek Pengembangan Jaringan Distribusi Wilayah Jawa Bagian Timur 2	20171130104952	\N	\N
ORG6000100	3397	3396	Sekretaris Proyek Pengembangan Jaringan Distribusi Wilayah Jawa Bagian Timur 3 (Pelangi Rebeca Sitompul)	20171130104952	\N	\N
ORG6000101	3428	1269	PM Pengembangan Infrastruktur Jawa Bagian Barat dan Sumatera Bagian Selatan	20171130104952	\N	\N
ORG6000102	3429	3428	Sekretaris Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan	20171130104952	\N	\N
ORG6000103	3444	3428	Tim Contract Adminstration Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Luki Rachimi Adiati)	20171130104952	\N	\N
ORG6000104	3452	1269	PM Kehandalan Jaringan Jawa Bagian Barat dan Sumatera Bagian Selatan	20171130104952	\N	\N
ORG6000105	3455	3452	Sekretaris Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan	20171130104952	\N	\N
ORG6000106	3457	1269	PM Pengembangan Infrastruktur Inisiatif Baru	20171130104952	\N	\N
ORG6000107	3458	3457	Sekretaris Pengembangan Infrastruktur Inisiatif Baru	20171130104952	\N	\N
ORG6000108	3464	1269	PM Pengembangan Infrastruktur dan Kehandalan Jaringan Sumatera Bagian Tengah dan Transmisi Sumatera - Jawa	20171130104952	\N	\N
ORG6000109	3465	3464	Sekretaris Pengembangan Infrastruktur dan kehandalan jaringan sumatera bagian tengah dan transmisi sumatera-Jawa	20171130104952	\N	\N
ORG6000110	3469	3452	Tim Contruction-QA/QC-HSE Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Sigit Dewantoro)	20171130104952	\N	\N
ORG6000111	3473	3452	Tim Project Controller Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Irma Indriani)	20171130104952	\N	\N
ORG6000112	3475	3452	Tim Engineering Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Hatgi Noer Ramandito)	20171130104952	\N	\N
ORG6000113	3506	1285	Engineer, Civil Engineering (Baroqah Anton Sulaiman)	20171130104952	\N	\N
ORG6000114	3508	1274	Koordinator Manajemen Keproyekan (Dewi Nursetyaningrum)	20171130104952	\N	\N
ORG6000115	3510	1274	Koordinator Manajemen Konstruksi dan HSSE (Syafran Siregar)	20171130104952	\N	\N
ORG6000116	3520	1275	Koordinator Pengendalian Material	20171130104952	\N	\N
ORG6000117	3521	3514	Sekretaris Proyek Kehandalan Jar. dan Fasilitas Transmisi Sumatera - Jawa	20171130104952	\N	\N
ORG6000118	3526	3520	Sekretaris Pengendalian Material	20171130104952	\N	\N
ORG6000119	3533	3514	Tim Contruction Proyek Kehandalan Jar. dan Fasilitas Transmisi Sumatera - Jawa (Cokorda Bagus Purnama Dwisa)	20171130104952	\N	\N
ORG6000120	3534	3514	Tim QA QC / HSE Proyek Kehandalan Jar. dan Fasilitas Transmisi Sumatera - Jawa (Rahmawati KA)	20171130104952	\N	\N
ORG6000121	3542	3514	Tim Engineering Proyek Kehandalan Jar. dan Fasilitas Transmisi Sumatera - Jawa (Irsyad Aini)	20171130104952	\N	\N
ORG6000122	3547	3457	Tim Pengembangan Infrastruktur Inisiatif Baru (Izza Ubaidilah)	20171130104952	\N	\N
ORG6000123	3551	3464	Tim Construction, QA/QC dan HSSE Pengembangan Infrastruktur dan kehandalan jaringan sumatera bagian tengah dan transmisi sumatera-Jawa (Andhika Yuristiana Putra)	20171130104952	\N	\N
ORG6000124	3553	3464	Tim Construction, QA/QC dan HSSE Pengembangan Infrastruktur dan kehandalan jaringan sumatera bagian tengah dan transmisi sumatera-Jawa (Muhammad Brajaka Kusuma)	20171130104952	\N	\N
ORG6000125	3556	3464	Tim Construction, QA/QC dan HSSE Pengembangan Infrastruktur dan kehandalan jaringan sumatera bagian tengah dan trasnmisi sumatera-Jawa (Yanuar Yudha)	20171130104952	\N	\N
ORG6000126	3557	3464	Tim Construction, QA/QC dan HSSE Pengembangan Infrastruktur dan kehandalan jaringan sumatera bagian tengah dan trasnmisi sumatera-Jawa (Faiz Fairussani Albananiy)	20171130104952	\N	\N
ORG6000127	3560	3464	Tim Contract Admin Pengembangan Infrastruktur dan kehandalan jaringan sumatera bagian tengah dan trasnmisi sumatera-Jawa (Salim Tribuana Wahyuni)	20171130104952	\N	\N
ORG6000128	3591	3514	Tim Engineering Proyek Kehandalan Jar. dan Fasilitas Transmisi Sumatera - Jawa (Ardika Maulana)	20171130104952	\N	\N
ORG6000129	3631	1293	Sekretaris Koordinator Group Keuangan	20171130104952	\N	\N
ORG6000130	3633	1296	Secretary of Licence and Permit	20171130104952	\N	\N
ORG6000131	3729	3534	Pengawas Konstruksi KJF TSJ	20171130104952	\N	\N
ORG6000132	3736	81	Group Head, Gas Supply	20171130104952	\N	\N
ORG6000133	3737	81	Group Head, Marketing	20171130104952	\N	\N
ORG6000134	3739	81	Group Head, Business Unit Gas Product	20171130104952	\N	\N
ORG6000135	3740	3736	Sekretaris Gas Supply	20171130104952	\N	\N
ORG6000136	3741	3736	Division Head, Gas Planning And Supply	20171130104952	\N	\N
ORG6000137	3742	3736	Department Head, Supply Contract Management	20171130104952	\N	\N
ORG6000138	3743	3737	Sekretaris Marketing	20171130104952	\N	\N
ORG6000139	3744	3737	Department Head, Market Research and Strategy	20171130104952	\N	\N
ORG6000140	3745	3737	Department Head, Product Development and Management	20171130104952	\N	\N
ORG6000141	3746	3737	Department Head, Marketing Excellence and Communication	20171130104952	\N	\N
ORG6000142	3747	84	Group Head, Center of Technical Excellence	20171130104952	\N	\N
ORG6000143	3748	3747	Specialist, Construction	20171130104952	\N	\N
ORG6000144	3749	3747	Specialist, Operation and Reliability	20171130104952	\N	\N
ORG6000145	3750	3748	Sr. Engineer, Construction (Aris Hartono)	20171130104952	\N	\N
ORG6000146	3751	3748	Sr. Engineer, Construction (Rusdi Tommy)	20171130104952	\N	\N
ORG6000147	3752	3748	Jr. Engineer, Construction (Joana)	20171130104952	\N	\N
ORG6000148	3754	3749	Sr. Engineer, Operation and Reliability (Agus Sukriya)	20171130104952	\N	\N
ORG6000149	3755	3749	Sr. Engineer, Operation and Reliability (Barlian)	20171130104952	\N	\N
ORG6000150	3756	3749	Jr. Engineer, Operation and Reliability (Didin)	20171130104952	\N	\N
ORG6000151	3757	3749	Jr. Engineer, Operation and Reliability (Fajar)	20171130104952	\N	\N
ORG6000152	3758	3747	Sr. Engineer, Pipeline & Piping Engineering (Bayu)	20171130104952	\N	\N
ORG6000153	3760	3758	Staff, Electrical Engineering (Eko)	20171130104952	\N	\N
ORG6000154	3761	3758	Staff, Civil Engineering (Made)	20171130104952	\N	\N
ORG6000155	3762	3747	Sr. Engineer, Pipeline & Piping Engineering (Rasyid)	20171130104952	\N	\N
ORG6000156	3763	3762	Jr. Engineer, Pipeline & Piping Engineer (Anindito)	20171130104952	\N	\N
ORG6000157	3765	3762	Engineer, Instrument and Control Engineering (Dewi Wulandari)	20171130104952	\N	\N
ORG6000158	3766	3747	Center of Technical Excellence Secretary	20171130104952	\N	\N
ORG6000159	3767	3739	Division Head, Gas Planning and Optimization	20171130104952	\N	\N
ORG6000160	3768	3739	Division Head, Sales and Customer Management	20171130104952	\N	\N
ORG6000161	3769	3739	Division Head, Corporate Sales and Customer  Management 	20171130104952	\N	\N
ORG6000162	3771	3767	Sr. Analyst, Gas Planning and Optimization (Heny Purwati)	20171130104952	\N	\N
ORG6000163	3772	3767	Analyst, Gas Optimization and Optimization (Asep Bahri)	20171130104952	\N	\N
ORG6000164	3775	3767	Sr. Staff, Gas Planning and Optimization Regional II (M. Dwi Subiyantoro)	20171130104952	\N	\N
ORG6000165	3776	3767	Staff, Gas Planning and Optimization (M. Zulfan Fauzi)	20171130104952	\N	\N
ORG6000166	3777	3767	Analyst, Gas Planning and Optimization Regional II (Atang Sudjani)	20171130104952	\N	\N
ORG6000167	3780	3768	Analyst, Sales and Customer Management (Sugianto)	20171130104952	\N	\N
ORG6000168	3782	3768	Staff, Sales and Customer Management (Niken Putri)	20171130104952	\N	\N
ORG6000169	3784	3768	Staff, Sales and Customer Management (Jauhari Wicaksono)	20171130104952	\N	\N
ORG6000170	3785	3768	Sr. Analyst, Sales and Customer Management (Maisalina)	20171130104952	\N	\N
ORG6000171	3787	3768	Jr. Analyst, Sales and Customer Management (Ari Arnold)	20171130104952	\N	\N
ORG6000172	3790	3768	Staff, Sales and Customer Management (Narulita Hasyim)	20171130104952	\N	\N
ORG6000173	3796	3769	Sr. Analyst, Corporate Sales and Customer Management (Kristiar)	20171130104952	\N	\N
ORG6000174	3797	3769	Analyst, Corporate Sales and Customer Management (Beni Yudhanta)	20171130104952	\N	\N
ORG6000175	3798	3769	Analyst, Corporate Sales and Customer Management (Angga Mahendra)	20171130104952	\N	\N
ORG6000176	3799	3739	Sales Area Head, Jakarta	20171130104952	\N	\N
ORG6000177	3800	3769	Sr. Staff, Corporate Sales and Customer Management (Indra Triaswati)	20171130104952	\N	\N
ORG6000178	3802	3741	Jr. Analyst, Gas Planning and Supply (Ida Fortuna)	20171130104952	\N	\N
ORG6000179	3803	3741	Analyst, Gas Planning and Supply (Armynas Handyas)	20171130104952	\N	\N
ORG6000180	3804	3739	Sales Area Head, Bogor	20171130104952	\N	\N
ORG6000181	3805	3742	Sr. Analyst, Gas Contract Management (Sulistianingsih)	20171130104952	\N	\N
ORG6000182	3806	3804	Sr. Analyst, Customer Management Area Bogor (Yanto Kusdamayanto)	20171130104952	\N	\N
ORG6000183	3807	3804	Sr. Analyst, Sales Area Bogor (Hari Pudjiastuti)	20171130104952	\N	\N
ORG6000184	3808	3804	Analyst, Sales Area Bogor  (Tri Yuliantoro)	20171130104952	\N	\N
ORG6000185	3810	3804	Analyst, Sales Area Bogor (Rita Yulianita)	20171130104952	\N	\N
ORG6000186	3811	3767	Jr. Analyst, Gas Planning and Optimization Regional I (Yogi Alex)	20171130104952	\N	\N
ORG6000187	3815	3769	Secretary, Corporate Sales	20171130104952	\N	\N
ORG6000188	3816	3804	Sr. Analyst, Customer Management Area Bogor (Suwanto)	20171130104952	\N	\N
ORG6000189	3817	3804	Sr. Analyst, Customer Management Area Bogor (Galuh Kusumaningtyas)	20171130104952	\N	\N
ORG6000190	3818	3804	Jr. Analyst, Customer Management Area Bogor (Rika Narulita)	20171130104952	\N	\N
ORG6000191	3819	3804	Jr. Analyst, Sales Area Bogor (Estomihi Tobing)	20171130104952	\N	\N
ORG6000192	3823	3804	Section Head, Sales Administration Area Bogor (Pharamayuda)	20171130104952	\N	\N
ORG6000193	3824	3823	Staff, Sales Administration Area Bogor (Lala Kumalawati)	20171130104952	\N	\N
ORG6000194	3826	3823	Staff, Billing Area Bogor (Annisaa Putri Citrawati)	20171130104952	\N	\N
ORG6000195	3828	83	Group Head, Human Capital Management	20171130104952	\N	\N
ORG6000196	3829	3739	Sales Area Head, Cirebon	20171130104952	\N	\N
ORG6000197	3830	3829	Analyst, Customer Management Area Cirebon (Satori)	20171130104952	\N	\N
ORG6000198	3832	5731	Department Head, Human Capital Business Partner	20171130104952	\N	\N
ORG6000199	3834	3829	Staff, Customer Management Area Cirebon (Purbotejo)	20171130104952	\N	\N
ORG6000200	3835	3739	Sales Area Head, Tangerang 	20171130104952	\N	\N
ORG6000201	3837	5697	Department Head, Leadership and Corporate Culture	20171130104952	\N	\N
ORG6000202	3838	3835	Jr. Analyst, Customer Management Area Tangerang (Rhomy Prastiyo)	20171130104952	\N	\N
ORG6000203	3839	3835	Jr. Analyst, Sales Area Tangerang (Supratman)	20171130104952	\N	\N
ORG6000204	3840	5697	Department Head, Workforce and Competence Management	20171130104952	\N	\N
ORG6000205	3841	3835	Jr. Analyst, Customer Management Area Tangerang (Sadewo)	20171130104952	\N	\N
ORG6000206	3842	3829	Staff, Customer Management Area Cirebon (Andi)	20171130104952	\N	\N
ORG6000207	3843	5697	Department Head, Performance and Reward Management	20171130104952	\N	\N
ORG6000208	3844	3835	Sr. Analyst, Customer Management Area Tangerang (Chairiah Mustafa)	20171130104952	\N	\N
ORG6000209	3845	3829	Staff, Sales Area Cirebon (Yuli)	20171130104952	\N	\N
ORG6000210	3846	5697	Department Head, Learning and Knowledge Management 	20171130104952	\N	\N
ORG6000211	3847	3829	Staff, Customer Management Area Cirebon (Ridwan)	20171130104952	\N	\N
ORG6000212	3849	3835	Sr. Analyst, Customer Management Area Tangerang (Liestya Heryani Devi)	20171130104952	\N	\N
ORG6000213	3850	3829	Section Head, Sales Administration Area Cirebon (Waspin)	20171130104952	\N	\N
ORG6000214	3852	3850	Staff, Sales Administration Area Cirebon (Udi)	20171130104952	\N	\N
ORG6000215	3854	5731	Department Head, Human Capital Services	20171130104952	\N	\N
ORG6000216	3857	3835	Staff, Customer Management Area Tangerang (Nofi Erik)	20171130104952	\N	\N
ORG6000217	3858	3850	Staff, Billing Area Cirebon (Hilmi)	20171130104952	\N	\N
ORG6000218	3859	3835	Staff, Customer Management Area Tangerang (Ferianto Isak Mukti Wibowo)	20171130104952	\N	\N
ORG6000219	3860	3835	Analyst, Sales Area Tangerang (Dwi Prawanti Nina Wulan)	20171130104952	\N	\N
ORG6000220	3861	3835	Staff, Customer Management Area Tangerang (Canisius Nay)	20171130104952	\N	\N
ORG6000221	3862	3835	Jr. Analyst, Sales Area Tangerang (Roby Syahputra)	20171130104952	\N	\N
ORG6000222	3863	3835	Staff, Customer Management Area Tangerang (Irfan Alamsyah)	20171130104952	\N	\N
ORG6000223	3864	3739	Sales Area Head, Palembang	20171130104952	\N	\N
ORG6000224	3865	3835	Staff, Sales Area Tangerang (Budihardjo)	20171130104952	\N	\N
ORG6000225	3866	3832	Sr. Analyst, Strategy and Business Development HCBP	20171130104952	\N	\N
ORG6000226	3867	3832	Sr. Analyst, Commerce HCBP	20171130104952	\N	\N
ORG6000227	3868	3864	Jr. Analyst, Customer Management Area Palembang (Endang Suratna)	20171130104952	\N	\N
ORG6000228	3869	3832	Jr. Analyst, Infrastructure and Technology HCBP	20171130104952	\N	\N
ORG6000229	3870	3864	Staff, Customer Management Area Palembang (Yasir)	20171130104952	\N	\N
ORG6000230	3871	3832	Jr. Analyst, Human Capital and General Services HCBP	20171130104952	\N	\N
ORG6000231	3873	3864	Jr. Analyst, Customer Management Area Palembang (Hendri)	20171130104952	\N	\N
ORG6000232	3874	3828	Secretary of Human Capital Management Division	20171130104952	\N	\N
ORG6000233	3876	3835	Section Head, Sales Administration Area Tangerang (Yusep Mandani)	20171130104952	\N	\N
ORG6000234	3877	3864	Section Head, Sales Administration Area Palembang (Imelda Fitry)	20171130104952	\N	\N
ORG6000235	3878	3739	Sales Area Head, Surabaya	20171130104952	\N	\N
ORG6000454	4366	4282	Analyst,  ICT Reps II (Surabaya) (Riko)	20171130104952	\N	\N
ORG6000236	3879	3876	Staff, Billing Area Tangerang (Aulia Nuraini Kusumadewi)	20171130104952	\N	\N
ORG6000237	3883	3876	Staff, Billing Area Tangerang (Ristafani Tia Safitri)	20171130104952	\N	\N
ORG6000238	3884	3739	Sales Area Head, Lampung 	20171130104952	\N	\N
ORG6000239	3890	3884	Jr. Analyst, Customer Management Area Lampung (Sugiarto)	20171130104952	\N	\N
ORG6000240	3892	3739	Sales Area Head, Cilegon	20171130104952	\N	\N
ORG6000241	3893	3884	Section Head, Sales Administration Area Lampung (Suprayogi)	20171130104952	\N	\N
ORG6000242	3894	3739	Sales Area Head, Sidoarjo	20171130104952	\N	\N
ORG6000243	3896	3799	Sr. Analyst, Customer Management Area Jakarta (Dini Mentari)	20171130104952	\N	\N
ORG6000244	3897	3892	Analyst, Sales Area Cilegon (Erwin Gitarisyana)	20171130104952	\N	\N
ORG6000245	3898	3799	Section Head, Sales Administration Area Jakarta (Hernita)	20171130104952	\N	\N
ORG6000246	3899	3739	Sales Area Head, Pasuruan	20171130104952	\N	\N
ORG6000247	3901	3892	Staff, Customer Management Area Cilegon (Yusman Wismarna)	20171130104952	\N	\N
ORG6000248	3903	3892	Jr. Analyst, Customer Management Area Cilegon merangkap Jr. Specialist, Sales Area Cilegon (Eddy Slamet)	20171130104952	\N	\N
ORG6000249	3904	3892	Staff, Customer Management Area Cilegon (Amsar)	20171130104952	\N	\N
ORG6000250	3907	3898	Staff, Billing Area Jakarta (Cherra)	20171130104952	\N	\N
ORG6000251	3908	3739	Sales Area Head, Semarang	20171130104952	\N	\N
ORG6000252	3910	3799	Sr. Analyst, Sales Area Jakarta (Marijo)	20171130104952	\N	\N
ORG6000253	3911	3892	Section Head, Sales Administration Area Cilegon	20171130104952	\N	\N
ORG6000254	3912	3911	Staff, Billing Area Cilegon (Hapiz Maulana)	20171130104952	\N	\N
ORG6000255	3913	3799	Jr. Analyst, Sales Area Jakarta (Ina)	20171130104952	\N	\N
ORG6000256	3914	3799	Analyst, Sales Area Jakarta (Selviana)	20171130104952	\N	\N
ORG6000257	3915	3739	Sales Area Head, Bekasi	20171130104952	\N	\N
ORG6000258	3916	3799	Staff, Sales Area Jakarta (Sugiyanto)	20171130104952	\N	\N
ORG6000259	3918	3799	Jr. Analyst, Customer Management Area Jakarta (Eddy Syafianto)	20171130104952	\N	\N
ORG6000260	3920	3915	Jr. Analyst, Sales Area Bekasi (Widya Kurnia Puteri)	20171130104952	\N	\N
ORG6000261	3921	3894	Sr. Analyst, Sales Area Sidoarjo (Margiyanto)	20171130104952	\N	\N
ORG6000262	3923	3915	Staff, Customer Management Area Bekasi (Teguh Imansyah)	20171130104952	\N	\N
ORG6000263	3924	3915	Analyst, Sales Area Bekasi (Nur Inayati)	20171130104952	\N	\N
ORG6000264	3925	3894	Staff, Customer Management Area Sidoarjo (Dawud)	20171130104952	\N	\N
ORG6000265	3926	3915	Analyst, Customer Management Area Bekasi (Asri Retno Wahyuningsih)	20171130104952	\N	\N
ORG6000266	3927	3894	Staff, Sales Area Sidoarjo (Denny Hariyanto)	20171130104952	\N	\N
ORG6000267	3928	3799	Analyst, Customer Management Area Jakarta (Natasya)	20171130104952	\N	\N
ORG6000268	3930	3799	Staff, Customer Management Area Jakarta (Harry)	20171130104952	\N	\N
ORG6000269	3935	3894	Sr. Analyst, Customer Management Area Sidoarjo (Ria Sari Yulianti)	20171130104952	\N	\N
ORG6000270	3936	3894	Jr. Analyst, Customer Management Area Sidoarjo (Nurdiansa Regnanto)	20171130104952	\N	\N
ORG6000271	3937	3894	Staff, Customer Management Area Sidoarjo (Wawan Pujiono)	20171130104952	\N	\N
ORG6000272	3938	3799	Staff, Sales Area Jakarta (Nandikram)	20171130104952	\N	\N
ORG6000273	3939	3915	Analyst, Customer Management Area Bekasi (Ridwan Hasan)	20171130104952	\N	\N
ORG6000274	3940	3894	Jr. Analyst, Customer Management Area Sidoarjo (Gilang Hermawan)	20171130104952	\N	\N
ORG6000275	3941	3915	Sr. Analyst, Sales Area Bekasi (Agus Muhammad Mirza)	20171130104952	\N	\N
ORG6000276	3942	3799	Sr. Analyst, Customer Management Area Jakarta (Richard)	20171130104952	\N	\N
ORG6000277	3944	3915	Staff, Customer Management Area Bekasi (Wasanan Saipudin)	20171130104952	\N	\N
ORG6000278	3945	3894	Section Head, Sales Administration Area Sidoarjo	20171130104952	\N	\N
ORG6000279	3946	3799	Staff, Customer Management Area Jakarta (Firsta)	20171130104952	\N	\N
ORG6000280	3947	3915	Staff, Customer Management Area Bekasi (Saji)	20171130104952	\N	\N
ORG6000281	3949	3915	Staff, Customer Management Area Bekasi (Sarwono)	20171130104952	\N	\N
ORG6000282	3951	3799	Jr. Analyst, Customer Management Area Jakarta (Donny)	20171130104952	\N	\N
ORG6000283	3952	3945	Staff, Billing Area Sidoarjo (Reni Anggraeni)	20171130104952	\N	\N
ORG6000284	3953	3915	Staff, Customer Management Area Bekasi (Baryadi)	20171130104952	\N	\N
ORG6000285	3954	3799	Jr. Analyst, Customer Management Area Jakarta  (Chaerulla)	20171130104952	\N	\N
ORG6000286	3955	3945	Staff, Sales Administration Area Sidoarjo (Nur Saidah)	20171130104952	\N	\N
ORG6000287	3956	3915	Section Head, Sales Administration Area Bekasi	20171130104952	\N	\N
ORG6000288	3957	3915	Jr. Analyst, Customer Management Area Bekasi (Kardiyanta)	20171130104952	\N	\N
ORG6000289	3958	3945	Staff, Sales Administration Area Sidoarjo (Metya Marsetiana)	20171130104952	\N	\N
ORG6000290	3959	3956	Staff, Billing Area Bekasi (Kukuh Bayu Prasetyo)	20171130104952	\N	\N
ORG6000291	3961	3956	Staff, Billing Area Bekasi (Galih Pranasetya)	20171130104952	\N	\N
ORG6000292	3963	3956	Staff, Sales Administration Area Bekasi (Okky Putra Arganata)	20171130104952	\N	\N
ORG6000293	3964	3739	Sales Area Head, Karawang 	20171130104952	\N	\N
ORG6000294	3965	3964	Sr. Analyst, Customer Management Area Karawang (Saefudin)	20171130104952	\N	\N
ORG6000295	3967	3964	Analyst, Sales Area Karawang (Retno Kusumaningrum)	20171130104952	\N	\N
ORG6000296	3968	3899	Sr. Analyst, Sales Area Pasuruan (Agus B. Prasetiyo)	20171130104952	\N	\N
ORG6000297	3969	3964	Analyst, Customer Management Area Karawang merangkap Specialist, Sales Area Karawang (Endang Murtiani)	20171130104952	\N	\N
ORG6000298	3970	3964	Analyst, Customer Management Area Karawang (Wawan Syarif Ridwan)	20171130104952	\N	\N
ORG6000299	3971	3964	Jr. Analyst, Sales Area Karawang (Dedy Wibowo)	20171130104952	\N	\N
ORG6000300	3972	3964	Staff, Customer Management Area Karawang (Mohammad Rizal)	20171130104952	\N	\N
ORG6000301	3975	3964	Section Head, Sales Administration Area Karawang	20171130104952	\N	\N
ORG6000302	3976	3975	Staff, Billing Area Karawang (Elni Verawati)	20171130104952	\N	\N
ORG6000303	3977	3975	Staff, Billing Area Karawang (Fajar Wahyu Wardani)	20171130104952	\N	\N
ORG6000304	3980	3739	Sales Area Head, Medan	20171130104952	\N	\N
ORG6000305	3984	3980	Sr. Analyst, Customer Management Area Medan (Sutrisno)	20171130104952	\N	\N
ORG6000306	3991	3899	Jr. Analyst, Customer Management Area Pasuruan (Rizal YUniarto)	20171130104952	\N	\N
ORG6000307	3993	3899	Jr. Analyst, Customer Management Area Pasuruan (Eko Sujarwadi)	20171130104952	\N	\N
ORG6000308	3995	3899	Staff, Sales Area Pasuruan (Anis Nurhidayat)	20171130104952	\N	\N
ORG6000309	3996	3899	Section Head, Sales Administration Area Pasuruan	20171130104952	\N	\N
ORG6000310	3999	3980	Analyst, Sales Area Medan (Yusmawati)	20171130104952	\N	\N
ORG6000311	4000	3996	Staff, Billing Area Pasuruan (Indria Wardhani)	20171130104952	\N	\N
ORG6000312	4003	3878	Secretary of Regional Distribution II	20171130104952	\N	\N
ORG6000313	4004	3980	Sr. Staff, Sales Area Medan (Thoriq Ganang Prakoso)	20171130104952	\N	\N
ORG6000314	4006	3980	Jr. Analyst, Customer Management Area Medan (Mukhrin)	20171130104952	\N	\N
ORG6000315	4007	3980	Jr. Analyst, Customer Management Area Medan (Ratna Dewi Siregar)	20171130104952	\N	\N
ORG6000316	4008	3894	Secretary of Area Sidoarjo	20171130104952	\N	\N
ORG6000317	4010	3899	Secretary of Area Pasuruan	20171130104952	\N	\N
ORG6000318	4011	3980	Jr. Analyst, Customer Management Area Medan (Gusti Hadi)	20171130104952	\N	\N
ORG6000319	4012	3908	Secretary of Area Semarang	20171130104952	\N	\N
ORG6000320	4014	3980	Staff, Customer Management  Area Medan (Roster Hutagalung)	20171130104952	\N	\N
ORG6000321	4018	3980	Staff, Customer Management  Area Medan (Edi Santoso)	20171130104952	\N	\N
ORG6000322	4022	3908	Staff, Custumer Management Area Semarang (Aldo)	20171130104952	\N	\N
ORG6000323	4023	3908	Jr. Analyst, Sales Area Semarang (Eko Suprayitno)	20171130104952	\N	\N
ORG6000324	4030	3804	Secretary of Area Bogor	20171130104952	\N	\N
ORG6000325	4032	3829	Secretary of Area Cirebon	20171130104952	\N	\N
ORG6000326	4033	3835	Secretary of Area Tangerang	20171130104952	\N	\N
ORG6000327	4034	3864	Secretary of Area Palembang	20171130104952	\N	\N
ORG6000328	4036	3884	Secretary of Area Lampung	20171130104952	\N	\N
ORG6000329	4037	3980	Section Head, Sales Administration Area Medan	20171130104952	\N	\N
ORG6000330	4038	3915	Secretary of Area Bekasi	20171130104952	\N	\N
ORG6000331	4041	3964	Secretary of Area Karawang	20171130104952	\N	\N
ORG6000332	4042	4037	Staff, Billing Area Medan (Poppy Simorangkir)	20171130104952	\N	\N
ORG6000333	4044	3799	Secretary, Sales Area Jakarta	20171130104952	\N	\N
ORG6000334	4052	3744	Analyst, Marketin Strategy and Policy (Yudi Arianto)	20171130104952	\N	\N
ORG6000335	4055	3744	Staff, Market Research and Strategy (M. Syaiful Arifin)	20171130104952	\N	\N
ORG6000336	4063	3746	Analyst, Marketing Excellence (Heriansyah)	20171130104952	\N	\N
ORG6000337	4066	3739	Sales Area Head, Batam	20171130104952	\N	\N
ORG6000338	4067	3739	Sales Area Head, Pekanbaru	20171130104952	\N	\N
ORG6000339	4068	3739	Sales Area Head, Dumai	20171130104952	\N	\N
ORG6000340	4069	4067	Analyst, Customer Management merangkap Specialist, Sales Area Pekanbaru (Agus Kurniawan)	20171130104952	\N	\N
ORG6000341	4071	4067	Section Head, Sales Administration Area Pekanbaru (Chandrawati Kusumayekti)	20171130104952	\N	\N
ORG6000342	4072	4071	Staff, Billing Area Pekanbaru (Cholifah Indah P)	20171130104952	\N	\N
ORG6000343	4076	82	Group Head, Business and Technology Development	20171130104952	\N	\N
ORG6000344	4081	4076	Secretary, Business and Technology Development	20171130104952	\N	\N
ORG6000345	4083	4076	Department Head, Business and Technology  Analysis	20171130104952	\N	\N
ORG6000346	4084	3840	Analyst, Competence Management (Detie Maulina)	20171130104952	\N	\N
ORG6000347	4085	4076	Department Head, Business Incubation and Partnership 	20171130104952	\N	\N
ORG6000348	4087	4083	Sr. Analyst, Technology Analysis (Yusdi)	20171130104952	\N	\N
ORG6000349	4091	3843	Analyst, Performance Management (Adelina Artikasari)	20171130104952	\N	\N
ORG6000350	4092	4083	Analyst, Business Analysis (Mikael)	20171130104952	\N	\N
ORG6000351	4097	4083	Sr. Staff, Business and Technology Analysis (Zulfikar)	20171130104952	\N	\N
ORG6000352	4107	4085	Sr. Analyst, New Business Incubation	20171130104952	\N	\N
ORG6000353	4109	4085	Analyst, New Business Incubation	20171130104952	\N	\N
ORG6000354	4112	3846	Sr. Analyst, Knowledge Management (Hafifah Taharudin)	20171130104952	\N	\N
ORG6000355	4118	4066	Analyst, Sales merangkap Jr. Specialist, Customer Management Area Batam (Ahmad Abrar)	20171130104952	\N	\N
ORG6000356	4123	4066	Jr. Analyst, Sales Area Batam (Selly Tobing)	20171130104952	\N	\N
ORG6000357	4124	3854	Section Head, HC Operations	20171130104952	\N	\N
ORG6000358	4125	3854	Staff, Training (Nurlelasari)	20171130104952	\N	\N
ORG6000359	4126	3854	Section Head, Payroll	20171130104952	\N	\N
ORG6000360	4127	3854	Jr. Analyst, Industrial Relations (Fajar)	20171130104952	\N	\N
ORG6000361	4128	3854	Jr. Analyst, Human Capital Information System (Bagus Fernata)	20171130104952	\N	\N
ORG6000362	4131	4066	Jr. Analyst, Customer Management Area Batam (Wahyu Al Fashshi)	20171130104952	\N	\N
ORG6000363	4135	4066	Section Head, Sales Administration	20171130104952	\N	\N
ORG6000364	4136	4135	Sr. Staff, Billing Area Batam (Ardita Novianti)	20171130104952	\N	\N
ORG6000365	4138	4135	Staff, Sales Administration Area Batam (Hamidah Armaini)	20171130104952	\N	\N
ORG6000366	4143	3854	Staff, Payroll (Lamhotma PS)	20171130104952	\N	\N
ORG6000367	4149	5691	Sr, Advisor, Safety (Feronica Yula Wardhani)	20171130104952	\N	\N
ORG6000368	4150	84	Group Head, Business Unit Infrastructure	20171130104952	\N	\N
ORG6000369	4152	4149	Advisor, Health, Safety and Security	20171130104952	\N	\N
ORG6000370	4153	4149	Advisor, Environment Management	20171130104952	\N	\N
ORG6000371	4154	4149	Advisor, Health, Safety and Security (Nasihin)	20171130104952	\N	\N
ORG6000372	4155	4152	Sr. Analyst, Health, Safety and Security (Rudi Kuswandi)	20171130104952	\N	\N
ORG6000373	4160	4152	Analyst, Health, Safety and Security (Foury)	20171130104952	\N	\N
ORG6000374	4163	4152	Staff, Health, Safety and Security (Tribowo)	20171130104952	\N	\N
ORG6000375	4165	4152	Jr. Analyst, Health, Safety and Security (Rudy Setiawan)	20171130104952	\N	\N
ORG6000376	4177	4153	Jr. Analyst, Environment Management (Dini Septiani)	20171130104952	\N	\N
ORG6000377	4209	3915	Jr. Analyst, Sales Adminstration (Nurlandi Suhendar)	20171130104952	\N	\N
ORG6000378	4210	4150	Division Head, Infrastructure Business Management 	20171130104952	\N	\N
ORG6000379	4211	4150	Division Head, Gas System Management 	20171130104952	\N	\N
ORG6000380	4213	4150	Secretary of Business Unit Head Infrastructure Operations	20171130104952	\N	\N
ORG6000381	4214	4210	Advisor, Infrastructure Business Planning (Lely Malini)	20171130104952	\N	\N
ORG6000382	4215	4210	Advisor, Infrastructure Business Development (Boby Susilo)	20171130104952	\N	\N
ORG6000383	4216	4210	Advisor, Infrastructure Performance Management (Hendra Halim)	20171130104952	\N	\N
ORG6000384	4217	4214	Sr. Analyst, Infrastructure Business Planning (Kurnia Permasari)	20171130104952	\N	\N
ORG6000385	4218	4214	Jr. Analyst, Infrastructure Business Planning (M. Haryo Pramantyo)	20171130104952	\N	\N
ORG6000386	4219	4214	Staff, Infrastructure Business Planning (Esti)	20171130104952	\N	\N
ORG6000387	4220	4214	Staff, Infrastructure Business Planning (Emil)	20171130104952	\N	\N
ORG6000388	4222	4214	Staff, Infrastructure Business Planning (Roy Gamma)	20171130104952	\N	\N
ORG6000389	4226	3878	Jr. Analyst, Customer Management Area Surabaya (Rina Indra Wijayani)	20171130104952	\N	\N
ORG6000390	4228	4215	Jr. Analyst, Infrastructure Business Development (Mikha)	20171130104952	\N	\N
ORG6000391	4230	4215	Staff, Infrastructure Business Development (Fivin)	20171130104952	\N	\N
ORG6000392	4231	3878	Jr. Analyst, Customer Management Area Surabaya (Agus Arif Pramudiharto)	20171130104952	\N	\N
ORG6000393	4232	4215	Jr. Analyst, Infrastructure Business Development (Mira)	20171130104952	\N	\N
ORG6000394	4233	3878	Jr. Analyst, Customer Management Area Surabaya (Totok Eliyanto)	20171130104952	\N	\N
ORG6000395	4235	4216	Junior Analyst, Infrastructure Performance Management (Hanafi)	20171130104952	\N	\N
ORG6000396	4236	4216	Sr. Analyst, Infrastructure Performance Management (Irene)	20171130104952	\N	\N
ORG6000397	4238	4216	Analyst, Infrastructure Performance Management (Chandra)	20171130104952	\N	\N
ORG6000398	4241	4211	Plt. Advisor, Energy Management (Budi Junias )	20171130104952	\N	\N
ORG6000399	4242	4211	Sr. Analyst, Gas System Operation (Kokoh Parlindungan)	20171130104952	\N	\N
ORG6000400	4244	4211	Advisor, Capacity Commerce (Jauhar)	20171130104952	\N	\N
ORG6000401	4245	3878	Staff, Customer Management Area Surabaya (Hendy Kurniawan)	20171130104952	\N	\N
ORG6000402	4247	3878	Section Head, Sales Administration Area Surabaya (Imam Musyafa)	20171130104952	\N	\N
ORG6000403	4250	4247	Staff, Billing Area Surabaya (Kabul  Sucipto)	20171130104952	\N	\N
ORG6000404	4251	4247	Staff, Sales Administration Area Surabaya (Eva Yanti Tambunan)	20171130104952	\N	\N
ORG6000405	4253	4241	Sr. Analyst, Energy Management (M. Samhan)	20171130104952	\N	\N
ORG6000406	4254	4241	Jr. Analyst, Energy Management (Pri Endi Ariawan)	20171130104952	\N	\N
ORG6000407	4256	4242	Jr. Analyst, Gas System Operation and Technology (Zulkarnaen)	20171130104952	\N	\N
ORG6000408	4258	4247	Staff, Sales Administration Area Surabaya (Dwi Andriani)	20171130104952	\N	\N
ORG6000409	4279	4244	Sr. Staff, Capacity Commerce (Kristophorus Kanaprio Ola)	20171130104952	\N	\N
ORG6000410	4282	83	Group Head, Information Communication Technology	20171130104952	\N	\N
ORG6000411	4286	4282	Analyst, ICT Planning (Budi Prasetyaning Tyas)	20171130104952	\N	\N
ORG6000412	4289	4282	Department Head, Business Solutions Development	20171130104952	\N	\N
ORG6000413	4290	4282	Department Head, Management Solutions Development	20171130104952	\N	\N
ORG6000414	4292	4282	Department Head, Data Center Infrastructure	20171130104952	\N	\N
ORG6000415	4293	4282	Departement Head, Data Communication Infrastructure	20171130104952	\N	\N
ORG6000416	4295	4289	Sr. Analyst, Business Solution Services and Operations (Tety)	20171130104952	\N	\N
ORG6000417	4296	4289	Sr. Analyst, CRM and PRM Solutions Development (Reza Yusandi)	20171130104952	\N	\N
ORG6000418	4297	4289	Jr. Analyst, CRM and PRM Solutions Development (Rahmi)	20171130104952	\N	\N
ORG6000419	4303	4290	Sr. Analyst, Business Support and Office Automation Development (Retnoningsih)	20171130104952	\N	\N
ORG6000420	4305	83	Division Head, Logistic and Facility Management	20171130104952	\N	\N
ORG6000421	4309	4305	Advisor, Asset Management (Roevlyanto Roezien)	20171130104952	\N	\N
ORG6000422	4311	4305	Department Head, Facility Management	20171130104952	\N	\N
ORG6000423	4312	4305	Department Head, Logistic and Procurement Management	20171130104952	\N	\N
ORG6000424	4316	4124	Staff, HC Operations (Deasy)	20171130104952	\N	\N
ORG6000425	4318	3854	Staff, Payroll (Aditya Danurwendo)	20171130104952	\N	\N
ORG6000426	4319	4124	Staff, HC Operations (Anisya)	20171130104952	\N	\N
ORG6000427	4320	3832	Jr. Analyst, President Directors Office HCBP	20171130104952	\N	\N
ORG6000428	4326	4311	Jr. Analyst, Land and Building Management (I Made Setiawan)	20171130104952	\N	\N
ORG6000429	4327	4312	Sr. Analyst, Logistic Management (Suryandari Wandewi)	20171130104952	\N	\N
ORG6000430	4328	4312	Analyst, Logistic Management (Dyah Nurhayati)	20171130104952	\N	\N
ORG6000431	4329	4305	Secretary of Logistic and General Affairs	20171130104952	\N	\N
ORG6000432	4330	4312	Sr. Analyst, Procurement and Contract Management (Dyah Fitria)	20171130104952	\N	\N
ORG6000433	4331	4312	Sr. Analyst, Procurement and Contract Management (Adriyan Gobel)	20171130104952	\N	\N
ORG6000434	4332	4312	Sr. Analyst, Procurement and Contract Management (Gito Prayitno)	20171130104952	\N	\N
ORG6000435	4334	4290	Jr. Analyst, Main Business Support Development (Firdah)	20171130104952	\N	\N
ORG6000436	4335	4290	Staff, Business Support and Office Automation Development (Rini Sukmana)	20171130104952	\N	\N
ORG6000437	4336	4312	Sr. Analyst, Procurement and Contract Management (Machmudin)	20171130104952	\N	\N
ORG6000438	4337	4312	Sr. Analyst, Procurement and Contract Management (Diana Legirorina)	20171130104952	\N	\N
ORG6000439	4340	1	Corporate Secretary	20171130104952	\N	\N
ORG6000440	4341	4292	Sr. Analyst, Data Center Management (Rikhi Narang)	20171130104952	\N	\N
ORG6000441	4342	4292	Staff, Data Center Management (Miftakh)	20171130104952	\N	\N
ORG6000442	4344	4340	Division Head, Legal	20171130104952	\N	\N
ORG6000443	4345	4292	Sr. Analyst, Data Center Infrastructure Management (Subandi)	20171130104952	\N	\N
ORG6000444	4347	4293	Analyst, Data Communication Network Services and Operation (Teguh Umar Dhanu)	20171130104952	\N	\N
ORG6000445	4348	4282	Sr. Analyst, Data Communication Infrastructure Management (Yatmoko)	20171130104952	\N	\N
ORG6000446	4351	4344	Sr. Staff, Legal Complience (Agung Harum Prasetyo)	20171130104952	\N	\N
ORG6000447	4352	4312	Sr. Analyst, Logistic Management (Jefryanto Pasaribu)	20171130104952	\N	\N
ORG6000448	4354	4311	Analyst, Land and Building Management (Jernih Sinaga)	20171130104952	\N	\N
ORG6000449	4359	4344	Analyst, Legal Contract (Atika Indra Dhewanti)	20171130104952	\N	\N
ORG6000450	4361	4344	Advisor, Legal Councel and Litigation (Lita Sriwulandari)	20171130104952	\N	\N
ORG6000451	4362	4311	Jr. Analyst, Land and Building Management (Rini Munthe)	20171130104952	\N	\N
ORG6000452	4364	4282	Sr. Analyst, ICT Reps I (Ketapang) (Adia Purna)	20171130104952	\N	\N
ORG6000453	4365	4344	Analyst, Legal Councel and Litigation (Shabhi Mahmashani)	20171130104952	\N	\N
ORG6000455	4367	4344	Advisor, Legal Representatives BU Infrastructure (Sujatmiko)	20171130104952	\N	\N
ORG6000456	4368	4293	Jr. Analyst, Data Communication Network Services and Operation (Riandy Arizon)	20171130104952	\N	\N
ORG6000457	4370	4282	Staff,  ICT Reps III (Medan) (Parlin)	20171130104952	\N	\N
ORG6000458	4374	4312	Sr. Analsyt, Procurement and Contract Management Holding Company (Vincensia Sri Lestari)	20171130104952	\N	\N
ORG6000459	4377	4312	Analyst, Procurement and Contract Management Representatives Holding Company (Rini Restumi)	20171130104952	\N	\N
ORG6000460	4380	4312	Jr. Specialist, Procurement and Contract Management Holding Company (Wahyu Hardian)	20171130104952	\N	\N
ORG6000461	4422	4311	Sr. Analyst, General Affairs Management (Efi Muzdalifah)	20171130104952	\N	\N
ORG6000462	4462	4344	Sr. Analyst, Legal Councel and Litigation (Raymond Sondang)	20171130104952	\N	\N
ORG6000463	4463	4344	Analyst, Legal Representatives Business Unit Gas Product (Wahyu Adhy)	20171130104952	\N	\N
ORG6000464	4464	4344	Analyst, Legal Contract (Tommy)	20171130104952	\N	\N
ORG6000465	4465	4344	Sr. Staff, Legal Compliance (Abirul Trison)	20171130104952	\N	\N
ORG6000466	4466	4344	Staff, Legal Representatives BU Infrastructure (Freddy S)	20171130104952	\N	\N
ORG6000467	4467	5679	Division Head, Government and Community Relations	20171130104952	\N	\N
ORG6000468	4469	4467	Sr. Analyst, Government Relations (Vietor Tobing)	20171130104952	\N	\N
ORG6000469	4470	5679	Analyst, Strategic Stakeholder Management Representatives Jakarta (Agung Hari Setiawan)	20171130104952	\N	\N
ORG6000470	4471	4467	Staff, Government Relations (Hendri Susilo)	20171130104952	\N	\N
ORG6000471	4472	5679	Sr. Analyst, Strategic Stakeholder Management Representatives Medan (Yusnani)	20171130104952	\N	\N
ORG6000472	4474	5679	Jr. Analyst, Strategic Stakeholder Management Representative Batam merangkap Strategic Stakeholder Management Representative Pekanbaru (Riza Buana)	20171130104952	\N	\N
ORG6000473	4475	5679	Staff, Strategic Stakeholder Management Representatives Surabaya (Irfan Kurniawan)	20171130104952	\N	\N
ORG6000474	4477	5679	Staff, Strategic Stakeholder Management Representatives Surabaya (Heru Prasetiyo)	20171130104952	\N	\N
ORG6000475	4478	5679	Division Head, Corporate Communication	20171130104952	\N	\N
ORG6000476	4481	4478	Jr. Analyst, Internal Communication (Markus Aditya)	20171130104952	\N	\N
ORG6000477	4482	5691	Advisor, Risk Management	20171130104952	\N	\N
ORG6000478	4484	4482	Advisor, Risk Management (Etiko Kusjatmiko)	20171130104952	\N	\N
ORG6000479	4485	4482	Advisor, Risk Management (Agus Arifin)	20171130104952	\N	\N
ORG6000480	4486	4482	Sr. Analyst, Risk Management (M. Alfiannor)	20171130104952	\N	\N
ORG6000481	4487	4482	Jr. Analyst, Risk Management (Selo Purna Atmani)	20171130104952	\N	\N
ORG6000482	4488	4482	Analyst, Risk Management (Faris)	20171130104952	\N	\N
ORG6000483	4489	4482	Analyst, Risk Management (Silvi)	20171130104952	\N	\N
ORG6000484	4490	5691	Advisor, GCG and System Management (Yohannes Mardi Irianto)	20171130104952	\N	\N
ORG6000485	4491	5691	Advisor, GCG and System Management (Amy Dalifah)	20171130104952	\N	\N
ORG6000486	4493	5691	Sr. Analyst, GCG and System Management (Johannes Parlindungan)	20171130104952	\N	\N
ORG6000487	4496	4482	Staff, Risk Management (Dewi Sukmawati)	20171130104952	\N	\N
ORG6000488	4497	4482	Jr. Analyst, Risk Management (Heru Setiawan)	20171130104952	\N	\N
ORG6000489	4498	1	Group Head, Internal Audit	20171130104952	\N	\N
ORG6000490	4499	4498	Advisor, Internal Audit Planning and Management (R. Wahyono Talogo)	20171130104952	\N	\N
ORG6000491	4500	4498	Sr. Analyst, Internal Audit Planning and Management (Richard Napitupulu)	20171130104952	\N	\N
ORG6000492	4501	4498	Advisor, Audit (Achmad Yulianto)	20171130104952	\N	\N
ORG6000493	4502	4498	Advisor, Audit (Pantas L Tobing)	20171130104952	\N	\N
ORG6000494	4504	4498	Advisor, Audit (Miftahudin)	20171130104952	\N	\N
ORG6000495	4505	4498	Advisor, Audit (Hadyan A Bhusana)	20171130104952	\N	\N
ORG6000496	4506	4498	Sr. Analyst, Audit (Hari Muladi)	20171130104952	\N	\N
ORG6000497	4507	4498	Sr. Analyst, Audit (Ista Andayani)	20171130104952	\N	\N
ORG6000498	4508	4498	Sr. Analyst, Audit (Sri Supiah)	20171130104952	\N	\N
ORG6000499	4509	4498	Sr. Analyst, Audit (Elise)	20171130104952	\N	\N
ORG6000500	4510	4498	Sr. Analyst, Audit (Achmad Ikbaludin)	20171130104952	\N	\N
ORG6000501	4511	4498	Jr. Analyst, Audit (Heri Hermawan)	20171130104952	\N	\N
ORG6000502	4512	4498	Jr. Analyst, Audit (Rika Panjaitan)	20171130104952	\N	\N
ORG6000503	4513	4498	Jr. Analyst, Audit (Mahmudin)	20171130104952	\N	\N
ORG6000504	4514	4498	Secretary of Internal Audit	20171130104952	\N	\N
ORG6000505	4515	4340	Secretary of Corporate Secretary	20171130104952	\N	\N
ORG6000506	4516	4344	Secretary of Legal	20171130104952	\N	\N
ORG6000507	4517	4467	Secretary of Government Relations	20171130104952	\N	\N
ORG6000508	4518	4478	Secretary of Corporate Communication	20171130104952	\N	\N
ORG6000509	4520	4149	Secretary of Health, Safety, Security and Environment	20171130104952	\N	\N
ORG6000510	4521	4151	Secretary of Regional Transmission (elisa bianca)	20171130104952	\N	\N
ORG6000511	4522	4210	Secretary of Infrastructure Business Management	20171130104952	\N	\N
ORG6000512	4523	3739	Secretary, Business Unit Gas Product	20171130104952	\N	\N
ORG6000513	4524	3892	Secretary of Area Cilegon	20171130104952	\N	\N
ORG6000514	4525	3980	Secretary, Sales Area Medan	20171130104952	\N	\N
ORG6000515	4527	4066	Secretary of Area Batam	20171130104952	\N	\N
ORG6000516	4528	4067	Secretary of Area Pekanbaru	20171130104952	\N	\N
ORG6000517	4529	4282	Secretary of Information Communication Technology	20171130104952	\N	\N
ORG6000518	4530	4340	Division Head, Investor Relations	20171130104952	\N	\N
ORG6000519	4531	5552	Division Head, Transformation	20171130104952	\N	\N
ORG6000520	4532	5552	Division Head, Strategic Management	20171130104952	\N	\N
ORG6000521	4533	80	Division Head, Corporate Social Responsibility	20171130104952	\N	2
ORG6000522	4534	83	Division Head, Corporate Support and Services	20171130104952	\N	\N
ORG6000523	4535	4530	Secretary of Investor Relations	20171130104952	\N	\N
ORG6000524	4536	4530	Advisor, Investor Relations (Sulthani A Mangatur)	20171130104952	\N	\N
ORG6000525	4540	4531	Secretary of Transformation	20171130104952	\N	\N
ORG6000526	4543	4531	Sr. Analyst, Transformation (Yohanes Sujana)	20171130104952	\N	\N
ORG6000527	4544	4531	Staff, Transformation (Faricha Ayu)	20171130104952	\N	\N
ORG6000528	4548	4532	Secretary of Strategic Management	20171130104952	\N	\N
ORG6000529	4553	4533	Secretary of Corporate Social Responsibility	20171130104952	\N	0
ORG6000530	4554	4533	Department Head, Operational CSR	20171130104952	\N	0
ORG6000531	4555	4554	Section Head Partnership Program	20171130104952	\N	0
ORG6000532	4556	4554	Section Head Community Development Program	20171130104952	\N	0
ORG6000533	4557	4554	Jr. Analyst, Operational and Administration (Andriyanto)	20171130104952	\N	0
ORG6000534	4558	4554	Jr. Analyst, CSR Representative Jakarta-Ketapang (Tasrifudin)	20171130104952	\N	0
ORG6000535	4559	4554	Jr. Analyst, CSR Representative Medan (Azhar Wijaya)	20171130104952	\N	0
ORG6000536	4562	4554	Staff, CSR Representative Surabaya (Sutopo)	20171130104952	\N	0
ORG6000537	4563	4554	Staff, CSR Representative Jakarta-Ketapang (Dapot Tambunan)	20171130104952	\N	0
ORG6000538	4564	4554	Jr. Analyst, CSR Representative Jakarta-Ketapang (Siswanto)	20171130104952	\N	0
ORG6000539	4565	4533	Department Head, Planning and Controlling	20171130104952	\N	0
ORG6000540	4566	4533	Section Head, Partnership Program Planning and Controlling (Tubagus Nurcholis)	20171130104952	\N	0
ORG6000541	4567	4533	Section Head, Community Development Program Planning and Controlling (Yenni Ratna Kusumadewi)	20171130104952	\N	0
ORG6000542	4569	4533	Section Head, Budgeting and Administration (Ade Rusdiyati)	20171130104952	\N	0
ORG6000543	4574	4534	Advisor, Secretariat Administration (Yosa)	20171130104952	\N	\N
ORG6000544	4576	4534	Analyst, Secretariat Administration (Fitra Yuda)	20171130104952	\N	\N
ORG6000545	4581	4534	Jr. Analyst, Corporate Services (Agus Wibowo)	20171130104952	\N	\N
ORG6000546	4583	4534	Jr. Analyst, Corporate Services (Dikot)	20171130104952	\N	\N
ORG6000547	4584	4534	Jr. Analyst, Corporate Services (Fransisca Simarmata)	20171130104952	\N	\N
ORG6000548	4586	4534	Staff, Secretariat Administration (Katamsi)	20171130104952	\N	\N
ORG6000549	4587	4534	Secretary of Corporate Support and Services	20171130104952	\N	\N
ORG6000550	4588	82	Group Head, Strategic Planning	20171130104952	\N	\N
ORG6000551	4589	4588	Secretary of Strategic Planning	20171130104952	\N	\N
ORG6000552	4590	4588	Division Head, Corporate Strategy	20171130104952	\N	\N
ORG6000553	4594	82	Group Head, Portfolio and Performance Management	20171130104952	\N	\N
ORG6000554	4595	4594	Secretary of Portfolio and Performance Management	20171130104952	\N	\N
ORG6000555	4596	4594	Advisor, Performance Management (Dumaria)	20171130104952	\N	\N
ORG6000556	4597	4594	Sr. Analyst, Performance Management (Kemas Azhari)	20171130104952	\N	\N
ORG6000557	4598	4594	Sr. Analyst, Portfolio Management (Bimala)	20171130104952	\N	\N
ORG6000558	4599	4594	Sr. Analyst, Performance Management (Gita Noviyanti)	20171130104952	\N	\N
ORG6000559	4600	4594	Analyst, Portfolio Management (Farah)	20171130104952	\N	\N
ORG6000560	4601	4594	Analyst, Portfolio Management (Danny Prameswari)	20171130104952	\N	\N
ORG6000561	4602	4594	Analyst, Portfolio Management (Tri Gendro)	20171130104952	\N	\N
ORG6000562	4603	4594	Staff, Performance Management (Nova)	20171130104952	\N	\N
ORG6000563	4604	4211	Secretary of Gas System Management	20171130104952	\N	\N
ORG6000564	4615	3768	Secretary of Sales and Customer Management	20171130104952	\N	\N
ORG6000565	4616	3742	Jr. Analyst, Supply Contract Management (Sulchan Fadholi)	20171130104952	\N	\N
ORG6000566	4623	82	Sr. Expert, Gas for Railway (R. Arman)	20171130104952	\N	\N
ORG6000567	4637	3464	Tim Engineering Pengembangan Infrastruktur dan kehandalan jaringan sumatera bagian tengah dan trasnmisi sumatera-Jawa (Bayu Lambang Pamungkas)	20171130104952	\N	\N
ORG6000568	4638	3767	Secretary of Gas Planning and Optimization	20171130104952	\N	\N
ORG6000569	4643	3428	Tim Construction, QA/QC dan HSE Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Sulis Indriyanto)	20171130104952	\N	\N
ORG6000570	4644	3428	Tim Construction, QA/QC dan HSE Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Eko Yohannes Lumbanraja)	20171130104952	\N	\N
ORG6000571	4647	3428	Tim Construction, QA/QC dan HSE Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (M. Reza Lutfi Angga)	20171130104952	\N	\N
ORG6000572	4649	3428	Tim Construction, QA/QC dan HSE Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Muhasyim)	20171130104952	\N	\N
ORG6000573	4650	3428	Tim Construction, QA/QC dan HSE Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Wildan Jalaludin)	20171130104952	\N	\N
ORG6000574	4654	3837	Staff, Leadership and Corporate Culture (Achmad Afandi)	20171130104952	\N	\N
ORG6000575	4656	3843	Jr. Analyst, Performance Management (Hari Wiryawan)	20171130104952	\N	\N
ORG6000576	4657	3846	Jr. Analyst, Knowledge Management (Eko Yunianto)	20171130104952	\N	\N
ORG6000577	4658	3846	Jr. Analyst, Learning Development (Winda Wati)	20171130104952	\N	\N
ORG6000578	4660	3361	Tim Contract Adminstration Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Aan Fatoni)	20171130104952	\N	\N
ORG6000579	4663	3361	Tim Engineering Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Anas Asy Syifa)	20171130104952	\N	\N
ORG6000580	4664	3361	Tim Construction dan QA/QC & HSE Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Fauzan)	20171130104952	\N	\N
ORG6000581	4667	3452	Tim Contract Admin Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Fujianti)	20171130104952	\N	\N
ORG6000582	4669	3452	Tim Engineering Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Prima Hotlan)	20171130104952	\N	\N
ORG6000583	4670	3452	Tim Engineering Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Diki Hasanudin)	20171130104952	\N	\N
ORG6000584	4672	3452	Tim Contruction-QA/QC-HSE Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Andika Indra Cahyadi)	20171130104952	\N	\N
ORG6000585	4673	3452	Tim Contruction-QA/QC-HSE Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Soli Hutagaol)	20171130104952	\N	\N
ORG6000586	4677	3457	Tim Pengembangan Infrastruktur Inisiatif Baru (Oktobyanto)	20171130104952	\N	\N
ORG6000587	4678	1276	Koordinator Pengendalian Infrastruktur dan Mutu	20171130104952	\N	\N
ORG6000588	4689	1276	Koordinator Pengendalian Administrasi	20171130104952	\N	\N
ORG6000589	4693	1275	Koordinator Fungsi Layanan Pengadaan - PMO Infrastructure	20171130104952	\N	\N
ORG6000590	4696	4693	Sekertaris Pengadaan Barang dan Jasa	20171130104952	\N	\N
ORG6000591	4699	4693	Advisor, Pengadaan Barang dan Jasa (Leonardo Dapot)	20171130104952	\N	\N
ORG6000592	4700	4693	Analyst, Pengadaan Barang dan Jasa (Achmad Fahruzaman)	20171130104952	\N	\N
ORG6000593	4708	80	Division Head, Revenue Assurance	20171130104952	\N	2
ORG6000594	4709	4708	Secretary of Group Revenue Assurance	20171130104952	\N	\N
ORG6000595	4710	4708	Department Head, Collection Assurance	20171130104952	\N	\N
ORG6000596	4713	4710	Section Head, Collection Administration	20171130104952	\N	\N
ORG6000597	4714	4710	Section Head, Collection Handling	20171130104952	\N	\N
ORG6000598	4715	4714	Staff, Collection Handling	20171130104952	\N	\N
ORG6000599	4717	80	Group Head, Corporate Finance	20171130104952	\N	2
ORG6000600	4718	4717	Department Head, Financial Management	20171130104952	\N	\N
ORG6000601	4719	4718	Section Head, Funding and Insurance	20171130104952	\N	\N
ORG6000602	4720	4718	Section Head, Funding Risk and Investment	20171130104952	\N	\N
ORG6000603	4722	4717	Department Head, Financial Strategy	20171130104952	\N	\N
ORG6000604	4723	4722	Section Head, Loan Administration	20171130104952	\N	\N
ORG6000605	4724	4722	Section Head, Financial Planning	20171130104952	\N	\N
ORG6000606	4727	80	Group Head, Accounting	20171130104952	\N	2
ORG6000607	4728	4717	Secretary of Corporate Finance	20171130104952	\N	\N
ORG6000608	4729	4727	Secretary of Accounting	20171130104952	\N	\N
ORG6000609	4730	4727	Department Head, Accounting Standards and Procedures	20171130104952	\N	\N
ORG6000610	4732	4730	Sr. Analyst, PGN Groups Accounting Policies and Procedures Controller (Jovitha)	20171130104952	\N	\N
ORG6000611	4734	4727	Department Head, Taxation	20171130104952	\N	\N
ORG6000612	4735	4734	Section Head, PGN Group Tax Planner	20171130104952	\N	\N
ORG6000613	4737	4734	Section Head, PGN Tax Administration	20171130104952	\N	\N
ORG6000614	4738	4737	Staff, PGN Tax Administration (Ary Budiman)	20171130104952	\N	\N
ORG6000615	4740	4727	Department Head, Financial Reporting	20171130104952	\N	\N
ORG6000616	4741	4740	Section Head, PGN Stand Alone and Consolidated Financial Reporting	20171130104952	\N	\N
ORG6000617	4743	4740	Section Head, PGN and Afiliates Financial Statements Evaluator and Analyst	20171130104952	\N	\N
ORG6000618	4744	4743	Staff, PGN and Afiliates Financial Statements Evaluator and Analyst (Pitria Romadhon)	20171130104952	\N	\N
ORG6000619	4745	4740	Section Head, PGN Stand Alone and Consolidated Assets Reporting	20171130104952	\N	\N
ORG6000620	4746	4745	Staff, PGN Stand Alone and Consolidated Assets Reporting (Fitria Ratna)	20171130104952	\N	\N
ORG6000621	4748	4734	Section Head, PGN Group Tax Controller	20171130104952	\N	\N
ORG6000622	4749	4748	Staff, PGN Group Tax Controller (Deni Karsa Pamungkas)	20171130104952	\N	\N
ORG6000623	4750	4727	Department Head, Financial Accounting	20171130104952	\N	\N
ORG6000624	4751	4750	Section Head, Head Office Accounting	20171130104952	\N	\N
ORG6000625	4753	4751	Staff, Head Office Accounting (Teni Vitanggi)	20171130104952	\N	\N
ORG6000626	4754	4751	Staff, Head Office Accounting (Zetra Adhiarsih)	20171130104952	\N	\N
ORG6000627	4755	4750	Section Head, Business Unit Gas Product Accounting	20171130104952	\N	\N
ORG6000628	4758	4757	Officer I, Business Unit Infrastructure Operations Accounting (Yudhi Adhi Widodo)	20171130104952	\N	\N
ORG6000629	4759	80	Division Head, Treasury	20171130104952	\N	2
ORG6000630	4760	80	Group Head, Financial Control and Budget	20171130104952	\N	2
ORG6000631	4761	4759	Department Head, Payment	20171130104952	\N	\N
ORG6000632	4762	4761	Section Head, External Payment For Procurement	20171130104952	\N	\N
ORG6000633	4764	4762	Staff, External Payment for Procurement (Dhitta Maulidya)	20171130104952	\N	\N
ORG6000634	4765	4761	Section Head, Internal Payment For Advance	20171130104952	\N	\N
ORG6000635	4767	4765	Staff, Internal Payment For Advance (Nur Afni Indah Sari)	20171130104952	\N	\N
ORG6000636	4768	4759	Department Head, Collection and Account Receiveable	20171130104952	\N	\N
ORG6000637	4769	4768	Section Head, Collection	20171130104952	\N	\N
ORG6000638	4771	4768	Section Head, Account Receiveable	20171130104952	\N	\N
ORG6000639	4774	4768	Section Head, Customer Guarantee	20171130104952	\N	\N
ORG6000640	4776	4774	Staff, Customer Guarantee (Halida Ferani)	20171130104952	\N	\N
ORG6000641	4777	4759	Department Head, Cash Management and Procedures	20171130104952	\N	\N
ORG6000642	4778	4777	Section Head, Cash Management and Optimization	20171130104952	\N	\N
ORG6000643	4780	4777	Section Head, Procedures and Controller	20171130104952	\N	\N
ORG6000644	4782	4759	Secretary of Treasury	20171130104952	\N	\N
ORG6000645	4798	4760	Secretary of Financial Control and Budget	20171130104952	\N	\N
ORG6000646	4799	4760	Department Head, Financial and Budget Controling	20171130104952	\N	\N
ORG6000647	4800	4760	Department Head, Financial and Budget Planning	20171130104952	\N	\N
ORG6000648	4801	4760	Department Head, Financial and Budget Subsidiary and Consolidation	20171130104952	\N	\N
ORG6000649	4802	4799	Section Head, Financial and Budget Controling Business Unit And Unit Jargas	20171130104952	\N	\N
ORG6000650	4803	4802	Staff, Financial and Budget Controling Business Unit And Unit Jargas (Achmad Firdaus)	20171130104952	\N	\N
ORG6000651	4806	4799	Section Head, Financial and Budget Controling Head Office and PMO Infrastructure	20171130104952	\N	\N
ORG6000652	4808	4800	Section Head, Financial and Budget Planning Head Office and PMO Infrastructure	20171130104952	\N	\N
ORG6000653	4811	4800	Section Head, Financial and Budget Planning Business Unit and Unit Jargas	20171130104952	\N	\N
ORG6000654	4814	4801	Jr. Analyst, Consolidation and System Development (Tutus)	20171130104952	\N	\N
ORG6000655	4818	80	Sr. Expert, Business Process Reengineering Non Core (Finance) (Mangatas Panjaitan)	20171130104952	\N	2
ORG6000656	4819	80	Sr. Expert, Business Process Reengineering Non Core (Finance) (Liza Soenar Windarti)	20171130104952	\N	2
ORG6000657	4821	80	Sr. Expert, Business Process Reengineering Non Core (Finance) (Darmojo)	20171130104952	\N	2
ORG6000658	4824	80	Sr. Expert, Business Process Reengineering Non Core (Asset Management) (Agus Suryono)	20171130104952	\N	2
ORG6000659	4825	80	Pejabat Setingkat VP (YKPP : KTT/Ketapang Wisata) (Sitti Nurhafni)	20171130104952	\N	2
ORG6000660	4831	4594	Staff Jasa Profesi, Performance Management (Syahrul Syawal)	20171130104952	\N	\N
ORG6000661	4837	4340	Staff, Corporate Secretary (Emil Andi Rahman)	20171130104952	\N	\N
ORG6000662	4838	4340	Secretary of Corporate Secretary (Breninda Pamela)	20171130104952	\N	\N
ORG6000663	4839	3878	Specialist, Sales Area Surabaya (Ririn Novi)	20171130104952	\N	\N
ORG6000664	4845	4344	Advisor, Legal Compliance (Marie)	20171130104952	\N	\N
ORG6000665	4846	80	Sr. Expert, Audit Recommendation Monitoring and Closure (Erning Laksmi W.)	20171130104952	\N	2
ORG6000666	4847	80	Expert, Audit Recommendation Monitoring and Closure (Samtoner Tamba)	20171130104952	\N	2
ORG6000667	4848	4532	Sr. Analyst, Strategic Management (commerce) (Houstina)	20171130104952	\N	\N
ORG6000668	4932	3739	Staff, Planning and Performance Management (Prabandaru2)	20171130104952	\N	\N
ORG6000669	4979	1276	Sekretaris Infratructure Program Controlling (Chairani Octaviana)	20171130104952	\N	\N
ORG6000670	4981	3361	Tim Construction dan QA/QC & HSE Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Setifana Pranowo)	20171130104952	\N	\N
ORG6000671	4990	4713	Staff, Collection Adminitration (Priyo Hutomo)	20171130104952	\N	\N
ORG6000672	4991	1296	Sr. Analyst, Licence and Permit (Prishy)	20171130104952	\N	\N
ORG6000673	4992	1296	Koordinator Wilayah I & IV (Dedih Supriadi)	20171130104952	\N	\N
ORG6000674	4993	1296	Koordinator Wilayah II (Syafrudin Harahap)	20171130104952	\N	\N
ORG6000675	4994	1296	Koordinator Wilayah III (Gitoyo)	20171130104952	\N	\N
ORG6000676	4995	4992	Staff Perijinan Wilayah I & IV (Suladi)	20171130104952	\N	\N
ORG6000677	4996	4992	Staff Perijinan Wilayah I & IV ( Eddy Mulyono)	20171130104952	\N	\N
ORG6000678	4997	4993	Staff Perijinan Wilayah II ( Ardi)	20171130104952	\N	\N
ORG6000679	4998	4993	Staff Perijinan Wilayah II ( Fahrizal)	20171130104952	\N	\N
ORG6000680	4999	4588	Department Head, Corporate Planning	20171130104952	\N	\N
ORG6000681	5001	4216	Staff, Infrastructure Performance Management (Nur Falah Hani Qamariah)	20171130104952	\N	\N
ORG6000682	5002	4241	Analyst, Energy Management (Arief Mujiyanto)	20171130104952	\N	\N
ORG6000683	5003	4242	Staff, Gas System Operation (Marchia Devi L.)	20171130104952	\N	\N
ORG6000684	5004	4244	Jr. Analyst, Capacity Commerce (Karisnda Rahmadani)	20171130104952	\N	\N
ORG6000685	5005	4211	Sr. Analyst, Gas Delivery Information System (Dani)	20171130104952	\N	\N
ORG6000686	5006	5005	Analyst, Gas Delivery Information System (Pravira Sisyawan N)	20171130104952	\N	\N
ORG6000687	5007	5005	Jr. Analyst, Gas Delivery Information System (Soesatyo Bimo)	20171130104952	\N	\N
ORG6000688	5008	4769	Staff, Collection (Siti Itaningrum)	20171130104952	\N	\N
ORG6000689	5009	4771	Sr. Staff, Account Receiveable (Eko Purnomo)	20171130104952	\N	\N
ORG6000690	5016	4777	Section Head, Reciept and Payment Integration	20171130104952	\N	\N
ORG6000691	5017	5016	Staff, Reciept and Payment Integration (Indah Irwanti)	20171130104952	\N	\N
ORG6000692	5021	4761	Section Head, External Payment For Non Procurement	20171130104952	\N	\N
ORG6000693	5025	4761	Section Head, Internal Payment For Non Advance	20171130104952	\N	\N
ORG6000694	5026	5025	Staff, Internal Payment For Non Advance (Aisyah)	20171130104952	\N	\N
ORG6000695	5027	5025	Staff, Internal Payment For Non Advance (Erwin Noor)	20171130104952	\N	\N
ORG6000696	5028	4531	Advisor, Organization (Teguh Yuwono)	20171130104952	\N	\N
ORG6000697	5029	4531	Analyst, Organization (Wulandari)	20171130104952	\N	\N
ORG6000698	5031	4532	Sr. Analyst, Strategic Management (Legal) (Suryadi Wijaya)	20171130104952	\N	\N
ORG6000699	5032	4554	Analyst, CSR Representative Jakarta-Ketapang (Dodo Darsono)	20171130104952	\N	0
ORG6000700	5033	4150	Division Head, Gas Transmission Management	20171130104952	\N	\N
ORG6000701	5034	5033	Advisor, Gas System Operation and Technology Transmission (Kusnasriawan)	20171130104952	\N	\N
ORG6000702	5035	5033	Analyst,Energy Management Transmission (Hari Satria)	20171130104952	\N	\N
ORG6000703	5037	5033	Secretary of Gas Transmission Management	20171130104952	\N	\N
ORG6000704	5038	5034	Jr. Analyst,Gas System Operation and Technology Transmission (Herlenika)	20171130104952	\N	\N
ORG6000705	5039	5034	Jr. Analyst,Gas System Operation and Technology Transmission (Wahyu D)	20171130104952	\N	\N
ORG6000706	5040	5034	Staff,Gas System Operation and Technology Transmission (Septiaji)	20171130104952	\N	\N
ORG6000707	5041	5034	Jr. Analyst,Gas System Operation and Technology Transmission (Emi Heru)	20171130104952	\N	\N
ORG6000708	5042	5034	Staff,Gas System Operation and Technology Transmission (Hendry)	20171130104952	\N	\N
ORG6000709	5043	5034	Staff,Gas System Operation and Technology Transmission (Arief Dharmawan)	20171130104952	\N	\N
ORG6000710	5045	5034	Sr. Analyst, Gas System Operation and Technology Transmission (Herman Hartanto)	20171130104952	\N	\N
ORG6000711	5047	5034	Staff,Gas System Operation and Technology Transmission (M. Said)	20171130104952	\N	\N
ORG6000712	5048	5035	Staff, Energy Management Transmission (Pandu Pradana)	20171130104952	\N	\N
ORG6000713	5049	5035	Staff, Energy Management Transmission (Annis Sofia)	20171130104952	\N	\N
ORG6000714	5050	5033	Engineer, Asset and Reliability Transmission (Mahar Prasetyo)	20171130104952	\N	\N
ORG6000715	5051	5033	Engineer, Asset and Reliability Transmission (Anang Susanto)	20171130104952	\N	\N
ORG6000716	5052	5033	Staff, Asset and Reliability Transmission (Citra Pranandar)	20171130104952	\N	\N
ORG6000717	5054	5033	Jr. Engineer, Asset and Reliability Transmission (Sony Achmad)	20171130104952	\N	\N
ORG6000718	5056	5033	Engineer, Asset and Reliability Transmission - Zona Sumatera Selatan (Santoso Priyo)	20171130104952	\N	\N
ORG6000719	5058	5033	Sr. Engineer, Asset and Reliability Transmission - Zona Jawa Barat (Agung Kurniansyah)	20171130104952	\N	\N
ORG6000720	5059	3736	Sr. Officer, Gas Supply Data Management	20171130104952	\N	\N
ORG6000721	5060	3744	Analyst, Market Research and Data Management (Mas Agung Hamzari)	20171130104952	\N	\N
ORG6000722	5062	3746	Analyst, Marketing Excellence (Mahesa)	20171130104952	\N	\N
ORG6000723	5065	4150	Division Head, Gas Distribution Management Regional I	20171130104952	\N	\N
ORG6000724	5066	4150	Division Head, Gas Distribution Management Regional II	20171130104952	\N	\N
ORG6000725	5067	4150	Department Head, Gas Distribution Management Regional III	20171130104952	\N	\N
ORG6000726	5068	5065	Analyst, Gas System Operation and Technology  Regional I (Herdi Qoharrudin)	20171130104952	\N	\N
ORG6000727	5069	5065	Analyst, Energy Management  Regional I (M. Rusdy Sanny)	20171130104952	\N	\N
ORG6000728	5070	5065	Sr. Engineer, Asset and Reliability Distribution Regional I (Purwanto)	20171130104952	\N	\N
ORG6000729	5071	5068	Staff, Gas System Operation and Technology Regional I (Reza T)	20171130104952	\N	\N
ORG6000730	5072	5068	Staff, Gas System Operation and Technology Regional I (Ferry A N)	20171130104952	\N	\N
ORG6000731	5073	5068	Jr. Analyst, Gas System Operation and Technology Regional I (Mahda Mega)	20171130104952	\N	\N
ORG6000732	5074	5068	Staff, Gas System Operation and Technology Regional I (Ahmadtama)	20171130104952	\N	\N
ORG6000733	5076	5068	Staff, Gas System Operation and Technology Regional I (M. Ade Iqbal)	20171130104952	\N	\N
ORG6000734	5077	5068	Analyst, Gas System Operation and Technology  Regional I (Rahmat Ranudigdo)	20171130104952	\N	\N
ORG6000735	5079	5068	Staff, Gas System Operation and Technology Regional I (Alhan R)	20171130104952	\N	\N
ORG6000736	5080	5068	Analyst, Gas System Operation and Technology  Regional I (Hendro Waskito)	20171130104952	\N	\N
ORG6000737	5083	5069	Staff, Energy Management Regional I (Erwan Omar)	20171130104952	\N	\N
ORG6000738	5084	5069	Sr. Staff, Energy Management Regional I (Tika Riana)	20171130104952	\N	\N
ORG6000739	5085	5070	Engineer, Asset and Reliability Distribution  Regional I (Eka Subandriani)	20171130104952	\N	\N
ORG6000740	5087	5070	Jr. Engineer, Asset and Reliability Distribution Regional I (Anang Kustanto)	20171130104952	\N	\N
ORG6000741	5088	5070	Engineer, Asset and Reliability Distribution  Regional I (Furqanul Fikri)	20171130104952	\N	\N
ORG6000742	5089	5070	Staff, Asset and Reliability Distribution Regional I (Ade Rusmana)	20171130104952	\N	\N
ORG6000743	5090	5070	Jr. Engineer, Asset and Reliability Distribution Regional I (Adi Saputra)	20171130104952	\N	\N
ORG6000744	5091	5070	Jr. Engineer, Asset and Reliability Distribution Regional I (Wahyu Reza)	20171130104952	\N	\N
ORG6000745	5093	5070	Sr. Engineer, Asset and Reliability Distribution Regional I - Zona Jakarta Bogor (Imron)	20171130104952	\N	\N
ORG6000746	5094	5070	Specialist, Asset and Reliability Distribution Regional I - Zona Banten Cilegon (Nurdiansyah)	20171130104952	\N	\N
ORG6000747	5095	5070	Engineer, Asset and Reliability Distribution Regional I - Zona Cirebon (Suparmono)	20171130104952	\N	\N
ORG6000748	5096	5070	Sr. Engineer, Asset and Reliability Distribution Regional I - Zona Karawang - Bekasi (Rojali)	20171130104952	\N	\N
ORG6000749	5098	5066	Sr. Analyst, Gas System Operation and Technology Regional II (Sunardi)	20171130104952	\N	\N
ORG6000750	5099	5066	Sr. Analyst, Energy Management Regional II (Sukiswanto)	20171130104952	\N	\N
ORG6000751	5100	5066	Sr. Engineer, Asset and Reliability Distribution Regional II (M. Munari)	20171130104952	\N	\N
ORG6000752	5101	5098	Staff, Gas System Operation and Technology Regional II (Fajar M. Sidiq)	20171130104952	\N	\N
ORG6000753	5103	5098	Jr. Analyst, Gas System Operation and Technology Regional II (Agus Riyanto)	20171130104952	\N	\N
ORG6000754	5104	5098	Jr. Analyst, Gas System Operation and Technology Regional II (M. Alwi)	20171130104952	\N	\N
ORG6000755	5105	5098	Staff, Gas System Operation and Technology Regional II (Elvan Achmadi)	20171130104952	\N	\N
ORG6000756	5106	5098	Staff, Gas System Operation and Technology  Regional II (Azwar Oktaviansyah)	20171130104952	\N	\N
ORG6000757	5107	5098	Jr. Analyst, Gas System Operation and Technology Regional II (Michael Edigia Wizard)	20171130104952	\N	\N
ORG6000758	5108	5098	Jr. Analyst, Gas System Operation and Technology Regional II (Agus Hartadi)	20171130104952	\N	\N
ORG6000759	5109	5099	Staff, Energy Management Regional II (Febrian N Ardiwinata)	20171130104952	\N	\N
ORG6000760	5110	5099	Jr. Analyst, Energy Management Regional II (Fourikha Budi S)	20171130104952	\N	\N
ORG6000761	5111	5099	Jr. Analyst, Energy Management Regional II (Ratna Dian Suminar)	20171130104952	\N	\N
ORG6000762	5112	5099	Sr. Staff, Energy Management Regional II (Bima Satria Agung)	20171130104952	\N	\N
ORG6000763	5114	5100	Staff, Asset and Reliability Distribution Regional II (Nurhadi Sujatmoko)	20171130104952	\N	\N
ORG6000764	5115	5100	Staff, Asset and Reliability Distribution Regional II (Ferman Hakiki)	20171130104952	\N	\N
ORG6000765	5116	5100	Staff, Asset and Reliability Distribution Regional II (Ichwan Fauzi)	20171130104952	\N	\N
ORG6000766	5118	5100	Staff, Asset and Reliability Distribution Regional II (Havid N Wahyudi)	20171130104952	\N	\N
ORG6000767	5119	5100	Jr. Engineer, Asset and Reliability Distribution Regional II (Fuad Hasan)	20171130104952	\N	\N
ORG6000768	5120	5100	Sr. Engineer, Asset and Reliability Distribution Regional II - Zona Surabaya  Gresik (Djanurianto)	20171130104952	\N	\N
ORG6000769	5121	5100	Sr. Engineer, Asset and Reliability Distribution Regional II - Zona Sidoarjo  Mojokerto (Agus Mufriadi)	20171130104952	\N	\N
ORG6000770	5123	5100	Sr. Engineer, Asset and Reliability Distribution Regional II Zona Jawa Tengah (Hari Nurcahyanto)	20171130104952	\N	\N
ORG6000771	5124	5067	Sr. Analyst, Gas System Operation and Technology Regional III (Rusliman)	20171130104952	\N	\N
ORG6000772	5125	5067	Sr. Analyst, Energy Management Regional III (Dian Heryanti)	20171130104952	\N	\N
ORG6000773	5126	5067	Sr. Engineer, Asset and Reliability Distribution Regional III (Rommel Manurung)	20171130104952	\N	\N
ORG6000774	5128	5124	Staff, Gas System Operation and Technology Regional III (Yandi Azhari)	20171130104952	\N	\N
ORG6000775	5129	5124	Staff, Gas System Operation and Technology Regional III (Suharmat)	20171130104952	\N	\N
ORG6000776	5131	5124	Jr. Analyst, Gas System Operation and Technology Regional III (Cecep H Prawira)	20171130104952	\N	\N
ORG6000777	5132	5124	Staff, Gas System Operation and Technology Regional III (Irvan Tobing)	20171130104952	\N	\N
ORG6000778	5134	5124	Staff, Gas System Operation and Technology Regional III (Indra Praditya)	20171130104952	\N	\N
ORG6000779	5135	5124	Jr. Analyst, Gas System Operation and Technology Regional III (Syaifan F N)	20171130104952	\N	\N
ORG6000780	5137	5125	Staff, Energy Management Regional III (Aji Darmawan)	20171130104952	\N	\N
ORG6000781	5138	5125	Staff, Energy Management Regional III (Syah Dears K. P.)	20171130104952	\N	\N
ORG6000782	5139	5126	Engineer, Asset and Reliability Distribution Regional III (Eva Marito Daulay)	20171130104952	\N	\N
ORG6000783	5141	5126	Engineer, Asset and Reliability Distribution Regional III (Ariel Sharon)	20171130104952	\N	\N
ORG6000784	5142	5126	Jr. Engineer, Asset and Reliability Distribution Regional III (Tri Hartanti)	20171130104952	\N	\N
ORG6000785	5143	5126	Sr. Engineer, Asset and Reliability Distribution Regional III Zona Medan (Azwardi)	20171130104952	\N	\N
ORG6000786	5145	5126	Staff, Asset and Reliability Distribution Regional III - Zona Pekan Baru (Dea Amelia)	20171130104952	\N	\N
ORG6000787	5149	4311	Jr. Analyst, General Affairs Management (Andriansyah)	20171130104952	\N	\N
ORG6000788	5155	4311	Staff, General Affairs Management (Zainal Abidin Lubis)	20171130104952	\N	\N
ORG6000789	5160	4311	Analyst, General Affairs Management (Yono)	20171130104952	\N	\N
ORG6000790	5162	4311	Jr. Analyst, General Affiars Management (Nanda Prawita)	20171130104952	\N	\N
ORG6000791	5163	4311	Analyst, General Affairs Management (Titis Wulandari)	20171130104952	\N	\N
ORG6000792	5168	5158	Officer I, Support Services  Jakarta - Ketapang 2 (Devy Puspasari S)	20171130104952	\N	\N
ORG6000793	5169	5158	Officer I, Support Services  Jakarta - Ketapang 2 (Hasanah)	20171130104952	\N	\N
ORG6000794	5186	3767	Staff, Gas Planning and Optimization (Madarina Sabila)	20171130104952	\N	\N
ORG6000795	5187	4150	Division Head, Asset and Reliability Management	20171130104952	\N	\N
ORG6000796	5188	5187	Advisor, Asset Management (Henry Gunawan)	20171130104952	\N	\N
ORG6000797	5189	5187	Specialist, Reliability Management (Ari Armay Syah)	20171130104952	\N	\N
ORG6000798	5190	5187	Sr. Analyst, Infrastructure Information System (Aji Tunggul)	20171130104952	\N	\N
ORG6000799	5191	5188	Analyst, Asset Management (R. Brian)	20171130104952	\N	\N
ORG6000800	5192	5188	Jr. Analyst, Asset Management (Igung A Hermanu)	20171130104952	\N	\N
ORG6000801	5193	5188	Jr. Analyst, Asset Management (Akmaluddin)	20171130104952	\N	\N
ORG6000802	5194	5188	Analyst, Asset Management (Seto A Putranto)	20171130104952	\N	\N
ORG6000803	5195	5188	Advisor, Asset Management (Mega Pratiwi)	20171130104952	\N	\N
ORG6000804	5196	5188	Sr. Analyst, Asset Management (Yunita Rakhmawati)	20171130104952	\N	\N
ORG6000805	5197	5189	Engineer, Reliability Management (M. Ardian Arifin)	20171130104952	\N	\N
ORG6000806	5198	5189	Engineer, Reliability Management (Agung Oktavian W)	20171130104952	\N	\N
ORG6000807	5199	5189	Staff, Reliability Management (Denita H. Ramapuspasari)	20171130104952	\N	\N
ORG6000808	5200	5190	Analyst,  Infrastructure Information System (Rahmat Akbar Muttaqin)	20171130104952	\N	\N
ORG6000809	5201	5190	Staff, Infrastructure Information System (Tegar Kharisma)	20171130104952	\N	\N
ORG6000810	5205	4311	Officer I, Support Services  Area Jakarta (Anjir Sukaniawan)	20171130104952	\N	\N
ORG6000811	5206	5203	Officer I, Support Services  Area Jakarta (Hendri)	20171130104952	\N	\N
ORG6000812	5207	5203	Officer I, Support Services  Area Jakarta (Kustriyono)	20171130104952	\N	\N
ORG6000813	5208	5203	Officer I, Support Services  Area Jakarta (Sigit Prayitno)	20171130104952	\N	\N
ORG6000814	5209	5203	Officer I, Support Services  Area Jakarta (Erna Budhiarti)	20171130104952	\N	\N
ORG6000815	5210	5204	Officer I, Support Services Area Bogor (Aep Saepudin)	20171130104952	\N	\N
ORG6000816	5211	5204	Officer I, Support Services Area Bogor (Ujang Ishak)	20171130104952	\N	\N
ORG6000817	5212	4311	Sr. Analyst, General Affairs Management (Mulyono)	20171130104952	\N	\N
ORG6000818	5236	5550	Sales Area Head, Tarakan	20171130104952	\N	\N
ORG6000819	5237	5550	Sales Area Head, Sorong	20171130104952	\N	\N
ORG6000820	5238	3908	Section Head, Sales Administration Area Semarang	20171130104952	\N	\N
ORG6000821	5239	3739	Division Head, Planning and Performance Management	20171130104952	\N	\N
ORG6000822	5240	3768	Sr. Analyst, Sales and Customer Management (Mula Prasetyawan Senja)	20171130104952	\N	\N
ORG6000823	5243	5239	Staff, Planning and Performance Management (Prabandaru)	20171130104952	\N	\N
ORG6000824	5244	5239	Staff, Planning and Performance Management (Utami)	20171130104952	\N	\N
ORG6000825	5246	4037	Staff, Billing Area Medan (Rodiah)	20171130104952	\N	\N
ORG6000826	5247	3767	Staff, Gas Planning and Optimization Regional I (Syukron Arizona)	20171130104952	\N	\N
ORG6000827	5248	3767	Staff, Gas Planning and Optimization Regional III (Ilham Luthfi Nasution)	20171130104952	\N	\N
ORG6000828	5249	3767	Staff, Gas Planning and Optimization Regional III (Mira Yusmita)	20171130104952	\N	\N
ORG6000829	5250	3799	Sr. Analyst, Customer Management Area Jakarta (Widodo Djoko Susilo)	20171130104952	\N	\N
ORG6000830	5251	3898	Staff, Sales Administration Area Jakarta (Yetti Supartini)	20171130104952	\N	\N
ORG6000831	5252	3804	Staff, Sales Area Bogor (Johannes Manurung)	20171130104952	\N	\N
ORG6000832	5253	3823	Staff, Billing Area Bogor (Rahayu Laila Fitriati)	20171130104952	\N	\N
ORG6000833	5254	3804	Analyst, Customer Management Area Bogor (Ridian Junata)	20171130104952	\N	\N
ORG6000834	5255	3804	Jr. Analyst, Customer Management Area Bogor (Tia Restyani)	20171130104952	\N	\N
ORG6000835	5261	3850	Staff, Billing Area Cirebon (Badaria)	20171130104952	\N	\N
ORG6000836	5262	3864	Analyst, Sales Area Palembang (Andi Budiansyah)	20171130104952	\N	\N
ORG6000837	5263	3864	Jr. Analyst, Sales Area Palembang (Boedijanto)	20171130104952	\N	\N
ORG6000838	5264	3877	Staff, Sales Administration Area Palembang (Anita Sari)	20171130104952	\N	\N
ORG6000839	5265	5066	Secretary of Gas Distribution Management Regional II	20171130104952	\N	\N
ORG6000840	5266	5187	Secretary of Asset and Reliability Management	20171130104952	\N	\N
ORG6000841	5267	5065	Secretary of Gas Distribution Management Regional I	20171130104952	\N	\N
ORG6000842	5268	5067	Secretary of Gas Distribution Management Regional III	20171130104952	\N	\N
ORG6000843	5269	3878	Staff, Customer Management Area Surabaya (Nito Rahmadi)	20171130104952	\N	\N
ORG6000844	5272	3878	Analyst, Customer Management Area Surabaya (Faisal Arif)	20171130104952	\N	\N
ORG6000845	5273	3945	Staff, Billing Area Sidoarjo (Faishal Reza Imahendra)	20171130104952	\N	\N
ORG6000846	5275	4037	Staff, Sales Administration Area Medan (Yenni Andriani)	20171130104952	\N	\N
ORG6000847	5276	4071	Staff, Sales Administration Area Pekanbaru (Henri Herbert P.)	20171130104952	\N	\N
ORG6000848	5277	5239	Secretary of Planning and Performance Management	20171130104952	\N	\N
ORG6000849	5279	5236	Secretary of Sales Area Tarakan	20171130104952	\N	\N
ORG6000850	5281	5237	Secretary of Sales Area Sorong	20171130104952	\N	\N
ORG6000851	5282	5237	Section Head, Sales Administration Area Sorong (Nur Kholis)	20171130104952	\N	\N
ORG6000852	5283	4068	Analyst, Sales Area Dumai (Agus Kurniawan)	20171130104952	\N	\N
ORG6000853	5286	1293	Analyst, Accounting Project (Fransiska)	20171130104952	\N	\N
ORG6000854	5288	1293	Analyst, Accountng Project (Wening Ngesthi)	20171130104952	\N	\N
ORG6000855	5289	1293	Jr. Analyst, Accounting Project (Debora)	20171130104952	\N	\N
ORG6000856	5290	1293	Analyst, Accounting Project (Janter)	20171130104952	\N	\N
ORG6000857	5291	1275	Koordinator Treasury Project Department	20171130104952	\N	\N
ORG6000858	5292	1275	Koordinator  Budgeting Project Department	20171130104952	\N	\N
ORG6000859	5293	5291	Analyst, Treasury Project (Nanny Atika)	20171130104952	\N	\N
ORG6000860	5294	5291	Analyst, Treasury Project (Sularti)	20171130104952	\N	\N
ORG6000861	5296	5291	Staff, Treasury Project (Pipit)	20171130104952	\N	\N
ORG6000862	5299	5292	Analyst, Budgeting Project (Febry Komala Uli)	20171130104952	\N	\N
ORG6000863	5300	5292	Jr. Analyst, BUdgeting Project (Hasbi)	20171130104952	\N	\N
ORG6000864	5311	3320	Tim Project Controller Proyek Pengembangan Jar. Dist. Wil. Sumut dan Batam 1 (Yudhiasny Saragih)	20171130104952	\N	\N
ORG6000865	5314	4678	Officer II, Pengendalian Infrastruktur dan Mutu (Suprapto)	20171130104952	\N	\N
ORG6000866	5315	4689	Jr. Analyst, Pengendalian Administrasi (Siti Nuraida)	20171130104952	\N	\N
ORG6000867	5316	4689	Staff, Pengendalian Administrasi (Rifca Delywera)	20171130104952	\N	\N
ORG6000868	5319	4247	Staff, Sales Administrasion Area Surabaya (Marasokawati Cakra)	20171130104952	\N	\N
ORG6000869	5320	3428	Tim Engineering Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Rahmat Hidayat)	20171130104952	\N	\N
ORG6000870	5322	5068	Staff, Gas System Operation and Technology Regional I (Febrian Risdiansyah)	20171130104952	\N	\N
ORG6000871	5323	5033	Jr. Engineer, Asset and Reliability Transmission (Akrom A. Wibowo)	20171130104952	\N	\N
ORG6000872	5324	3510	Staff, Construction (Gugun Satmoko)	20171130104952	\N	\N
ORG6000873	5327	4348	Staff Data Communication	20171130104952	\N	\N
ORG6000874	5331	3768	Sr. Officer, Business Unit Gas Product Procedure Monitoring (Rosmawati)	20171130104952	\N	\N
ORG6000875	5332	3768	Sr. Officer, Business Unit Gas Product Procedure Monitoring (Heru Susapto)	20171130104952	\N	\N
ORG6000876	5333	1269	Koordinator Tim Jargas	20171130104952	\N	\N
ORG6000877	5334	5333	Secretary of Integrated Team Task Force Jargas	20171130104952	\N	\N
ORG6000878	5338	4467	Sr. Analyst, Government and Community Relations (Krisdyan Widagdo Adhi)	20171130104952	\N	\N
ORG6000879	5339	5236	Section Head, Sales Administration Area Tarakan (Bramantya Saputra)	20171130104952	\N	\N
ORG6000880	5342	5070	Jr. Engineer, Asset and Reliability Distribution Regional I (Paimin) 	20171130104952	\N	\N
ORG6000881	5343	4689	Staff Administrasi PPI (Hikmah)	20171130104952	\N	\N
ORG6000882	5344	3464	Tim Construction, QA/QC dan HSSE Pengembangan Infrastruktur dan kehandalan jaringan sumatera bagian tengah dan trasnmisi sumatera-Jawa (Rahmawati KA)	20171130104952	\N	\N
ORG6000883	5348	3980	Jr. Analyst, Customer Management Area Medan (Feron Simanjuntak)	20171130104952	\N	\N
ORG6000884	5349	3520	Sr. Engineer, Pengendalian Material (Dhian Widuri)	20171130104952	\N	\N
ORG6000885	5350	5069	Analyst, Energy Management Regional I (Magresa Hendariawan)	20171130104952	\N	\N
ORG6000886	5352	5034	Staff,Gas System Operation and Technology Transmission (Nur Yainatun)	20171130104952	\N	\N
ORG6000887	5354	3428	Tim Project Controller Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Ide Dia Selly)	20171130104952	\N	\N
ORG6000888	5355	3428	Tim Engineering Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Irsyad Aini)	20171130104952	\N	\N
ORG6000889	5356	3428	Tim Engineering Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Ardika Maulana)	20171130104952	\N	\N
ORG6000890	5360	4693	Sr. Analyst, Pengadaan Barang dan Jasa (Pahala Baringbing)	20171130104952	\N	\N
ORG6000891	5377	3361	Tim Construction dan QA/QC & HSE Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Mai Setiyono)	20171130104952	\N	\N
ORG6000892	5378	3361	Tim Construction dan QA/QC & HSE Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Beni Pramono)	20171130104952	\N	\N
ORG6000893	5380	3361	Tim Construction dan QA/QC & HSE Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Mohamad Ishaq)	20171130104952	\N	\N
ORG6000894	5382	3361	Tim Project Controller Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Setyo Deny Hudaya)	20171130104952	\N	\N
ORG6000895	5383	4532	Advisor, Strategic Management (Economy and Financial) (Rezki Anindito)	20171130104952	\N	\N
ORG6000896	5388	4311	Staff, General Affairs Management (Wira)	20171130104952	\N	\N
ORG6000897	5390	4311	Staff, General Affairs Management (Dedy Riadi)	20171130104952	\N	\N
ORG6000898	5397	4801	Jr. Analyst, Financial and Budget Subsidiary and Cosolidation (Septi)	20171130104952	\N	\N
ORG6000899	5398	4534	Advisor, Corporate Services (Solorida)	20171130104952	\N	\N
ORG6000900	5401	1296	Sr. Analyst, Licence and Permit (Yosephine Ina)	20171130104952	\N	\N
ORG6000901	5404	3428	Tim Construction, QA/QC dan HSE Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Awang Bhaswara)	20171130104952	\N	\N
ORG6000902	5407	3769	Advisor, Corporate Sales and Customer Management (Eva Ameilia)	20171130104952	\N	\N
ORG6000903	5410	80	Pejabat setingkat VP (YKPP : KPU/Ketapang Tour)	20171130104952	\N	2
ORG6000904	5412	82	Sr. Expert, Gas for Marine (Dwika Agustianto)	20171130104952	\N	\N
ORG6000905	5415	3892	Analyst, Customer Management Area Cilegon (Siti Aisah)	20171130104952	\N	\N
ORG6000906	5416	3835	Jr. Analyst, Sales Area Tangerang (Victor Leonardo)	20171130104952	\N	\N
ORG6000907	5418	3768	Analyst, Sales and Customer Management (Muharijal)	20171130104952	\N	\N
ORG6000908	5421	4806	Staff, Financial and Budget Controling Head Office and PMO Infrastructure (Moniek Trilaksmi)	20171130104952	\N	\N
ORG6000909	5422	4210	Advisor, Infrastructure Business Development (Budi Priswanto)	20171130104952	\N	\N
ORG6000910	5424	4153	Staff, Environment Management  (Andriansyah)	20171130104952	\N	\N
ORG6000911	5425	4153	Sr. Analyst, Environment Management (Astrid)	20171130104952	\N	\N
ORG6000912	5430	3804	Staff, Sales Area Bogor (Arief Rachman Amrulloh)	20171130104952	\N	\N
ORG6000913	5432	4730	Analyst, PGN and PGN Groups Accounting Standard (Putri Wahyu)	20171130104952	\N	\N
ORG6000914	5433	4730	Jr. Analyst, PGN Accounting Policies and Procedures Preparer and Controller (Faisal Arief)	20171130104952	\N	\N
ORG6000915	5434	4750	Section Head, BU Infrastructure dan Unit Jargas Accounting	20171130104952	\N	\N
ORG6000916	5436	5434	Staff, BU Infrastructure dan Unit Jargas Accounting (Yudi Adhi)	20171130104952	\N	\N
ORG6000917	5437	3835	Sr. Analyst, Customer Management Area Tangerang (Widhi Nugroho)	20171130104952	\N	\N
ORG6000918	5438	3876	Staff, Sales Administration Area Tangerang (Samuel)	20171130104952	\N	\N
ORG6000919	5439	3964	Sr. Analyst, Customer Management Area Karawang (Ojak L. Tobing)	20171130104952	\N	\N
ORG6000920	5440	3975	Staff, Sales Administration Area Karawang (Sandes Purba)	20171130104952	\N	\N
ORG6000921	5441	3878	Sr. Analyst, Sales Area Surabaya (Braman Setyoko)	20171130104952	\N	\N
ORG6000922	5442	3878	Sr. Analyst, Customer Management Area Surabaya (M. Makki Nuruddin)	20171130104952	\N	\N
ORG6000923	5444	3894	Staff, Sales Area Sidoarjo (Achmad Mirza)	20171130104952	\N	\N
ORG6000924	5445	3894	Sr. Analyst, Customer Management Area Sidoarjo (Sutarno)	20171130104952	\N	\N
ORG6000925	5446	3899	Staff, Customer Management Area Pasuruan (Arif Wijaya)	20171130104952	\N	\N
ORG6000926	5447	3996	Staff, Sales Administration Area Pasuruan (Widas Khoirunnisa)	20171130104952	\N	\N
ORG6000927	5448	4066	Sr. Analyst, Customer Management Area Batam (Kartini Tetty Pandiangan)	20171130104952	\N	\N
ORG6000928	5449	4066	Staff, Customer Management Area Batam (Gindo Panjaitan)	20171130104952	\N	\N
ORG6000929	5450	4135	Staff, Sales Administration Area Batam (Febi Hartanto)	20171130104952	\N	\N
ORG6000930	5451	4135	Staff, Billing Area Batam (Hakim Tobing)	20171130104952	\N	\N
ORG6000931	5454	4311	Staff, General Affairs Management (Nurdin)	20171130104952	\N	\N
ORG6000932	5457	4311	Staff, General Affairs Management (Juarsa)	20171130104952	\N	\N
ORG6000933	5458	5021	Staff, External Payment for non Procurement (Marthalena LT)	20171130104952	\N	\N
ORG6000934	5459	4708	Sr. Analyst, Revenue Management (Andini Saraswati)	20171130104952	\N	\N
ORG6000935	5460	3878	Analyst, Sales Area Surabaya (Dedy Tulus Pambudi)	20171130104952	\N	\N
ORG6000936	5465	3320	Tim Construction dan QAQC & HSE Pengembangan Infrastruktur dan Kehandalan jaringan sumatera bagian utara dan batam (Ridwan Muharam)	20171130104952	\N	\N
ORG6000937	5468	4534	Koordinator Fungsi Layanan Pengadaan dan Kontrak - CSS Division	20171130104952	\N	\N
ORG6000938	5469	5468	Fungsi Layanan Pengadaan dan Kontrak - CSS Division (Yosa Arfika Naim)	20171130104952	\N	\N
ORG6000939	5471	5468	Fungsi Layanan Pengadaan dan Kontrak - CSS Division (Warkunah)	20171130104952	\N	\N
ORG6000940	5472	5468	Fungsi Layanan Pengadaan dan Kontrak - CSS Division (Melanton Rahmanto)	20171130104952	\N	\N
ORG6000941	5473	5468	Fungsi Layanan Pengadaan dan Kontrak - CSS Division (Katamsi)	20171130104952	\N	\N
ORG6000942	5474	1276	Koordinator Inisiasi Program dan Pengelolaan Stakeholder (Wahyu Nurhayati)	20171130104952	\N	\N
ORG6000943	5476	5239	Sr. Specialist, Planning and Performance Management (Novi Muharam)	20171130104952	\N	\N
ORG6000944	5477	5239	Specialist, Planning and Performance Management (Arif Budiman)	20171130104952	\N	\N
ORG6000945	5478	4305	Koordinator Fungsi Layanan Pengadaan dan Kontrak - LGA Division	20171130104952	\N	\N
ORG6000946	5479	5478	Fungsi Layanan Pengadaan (Gito Prayitno)	20171130104952	\N	\N
ORG6000947	5480	5478	Fungsi Layanan Pengadaan (Dyah Fitria)	20171130104952	\N	\N
ORG6000948	5481	5478	Fungsi Layanan Pengadaan (Adriyan Alexandra Gobel)	20171130104952	\N	\N
ORG6000949	5482	5478	Fungsi Layanan Pengadaan (Wawan Hermawan)	20171130104952	\N	\N
ORG6000950	5483	5478	Fungsi Layanan Pengadaan (Santika Utami)	20171130104952	\N	\N
ORG6000951	5484	5478	Fungsi Layanan Pengadaan (Rini Restumi)	20171130104952	\N	\N
ORG6000952	5486	5478	Fungsi Layanan Kontrak (Machmudin)	20171130104952	\N	\N
ORG6000953	5487	5478	Fungsi Layanan Kontrak (Vincensia Lestari)	20171130104952	\N	\N
ORG6000954	5488	5478	Fungsi Layanan Kontrak (Diana Legirorina)	20171130104952	\N	\N
ORG6000955	5489	5478	Fungsi Layanan Kontrak (Elizabeth Maria Narua)	20171130104952	\N	\N
ORG6000956	5490	5478	Fungsi Layanan Kontrak (Murdani Wijaya)	20171130104952	\N	\N
ORG6000957	5491	5478	Fungsi Layanan Kontrak (Wahyu Hardian)	20171130104952	\N	\N
ORG6000958	5492	5478	Sekretaris Fungsi Layanan Pengadaan dan Kontrak - LGA Division	20171130104952	\N	\N
ORG6000959	5494	5478	Fungsi Layanan Kontrak (Erlina Midah Naibaho)	20171130104952	\N	\N
ORG6000960	5495	4532	Sr. Staff, Strategic Management (Legal) (Hidayat Anshori)	20171130104952	\N	\N
ORG6000961	5496	4532	Staff, Strategic Management (Technic) (M. Fikrie Farhan)	20171130104952	\N	\N
ORG6000962	5497	4730	Staff, Accounting Standards & Procedures (Yuniar Kusrini Mutinanta)	20171130104952	\N	\N
ORG6000963	5500	5188	Jr. Analyst, Asset Management (Budi Cahyadi Ginting)	20171130104952	\N	\N
ORG6000964	5502	5033	Sr. Engineer, Asset and Reliability Transmission (Jeffri Sianturi)	20171130104952	\N	\N
ORG6000965	5504	5069	Jr. Analyst, Energy Management Regional I (Fuad Hamzah)	20171130104952	\N	\N
ORG6000966	5505	4214	Staff, Infrastructure Business Planning (Am Dimas Prio Anggodo)	20171130104952	\N	\N
ORG6000967	5506	5124	Staff, Gas System Operation  and Technology Regional III (Adil Wahyudin Anwar)	20171130104952	\N	\N
ORG6000968	5507	5126	Staff, Asset and Reliability Distribution Regional III (Syahputra)	20171130104952	\N	\N
ORG6000969	5508	3748	Sr. Engineer, Construction (Haryoga)	20171130104952	\N	\N
ORG6000970	5509	4214	Sr. Staff, Infrastructure Business Planning (Rangga Yadi Putra)	20171130104952	\N	\N
ORG6000971	5512	5188	Jr. Analyst, Asset Management (Anisa Muzzamil)	20171130104952	\N	\N
ORG6000972	5514	3758	Sr. Staff, Pipeline & Piping Engineer (Arief Setiawan)	20171130104952	\N	\N
ORG6000973	5516	3762	Sr. Staff, Process Engineer  (Laelia Afrisanthi)	20171130104952	\N	\N
ORG6000974	5517	4554	Jr. Analyst, CSR Representative Jakarta-Ketapang (Elvira Widosari)	20171130104952	\N	0
ORG6000975	5518	4312	Analyst, Procurement and Contract Management (Erlina Midah Naibaho)	20171130104952	\N	\N
ORG6000976	5520	3361	Tim Construction dan QA/QC & HSE Pengembangan Infrastruktur dan Kehandalan jaringan jawa bagian timur dan tengah (Arfan Nugroho)	20171130104952	\N	\N
ORG6000977	5521	3877	Staff, Billing Area Palembang (Kretyowiweko HH)	20171130104952	\N	\N
ORG6000978	5522	4215	Staff, Infrastructure Business Development (Oktavino Asri Wijaya)	20171130104952	\N	\N
ORG6000979	5523	5069	Staff, Energy Management Regional I (Luluk Noorratri)	20171130104952	\N	\N
ORG6000980	5524	5124	Staff, Gas System Operation and Technology Regional III (Dwi Putra Budhi Setia)	20171130104952	\N	\N
ORG6000981	5525	4244	Staff, Capacity Commerce (Andreas)	20171130104952	\N	\N
ORG6000982	5526	4152	Staff, Health, Safety and Security (Fajar)	20171130104952	\N	\N
ORG6000983	5527	3911	Staff, Sales Administration Area Cilegon (M. Rizky Pradana)	20171130104952	\N	\N
ORG6000984	5528	3956	Staff, Billing Area Bekasi (Sinatrya Dwika Alvino)	20171130104952	\N	\N
ORG6000985	5529	3898	Staff, Billing Area Jakarta (Dinda Ayu Naria)	20171130104952	\N	\N
ORG6000986	5530	5478	Fungsi Layanan Pengadaan (Jefryanto Pasaribu) 	20171130104952	\N	\N
ORG6000987	5532	5188	Jr. Analyst, Asset Management (Aditya Eka Wijaya)	20171130104952	\N	\N
ORG6000988	5533	4532	Analyst, Strategic Management (Finance) (Arif Budhianto)	20171130104952	\N	\N
ORG6000989	5536	4498	Staff, Internal Audit Planning and Management (Roro Anggun)	20171130104952	\N	\N
ORG6000990	5537	3746	Analyst, Marketing Excellence (Mukhamad Rifai Sidi)	20171130104952	\N	\N
ORG6000991	5538	4708	Jr. Analyst, Revenue Management (Mohammad Febrian)	20171130104952	\N	\N
ORG6000992	5539	3964	Staff, Sales Area Karawang (Virgiawan Janur)	20171130104952	\N	\N
ORG6000993	5540	3744	Staff, Market Research and Strategy (M. Fatah Yasin)	20171130104952	\N	\N
ORG6000994	5542	4530	Analyst, Investor Relations (Arif Perdananto)	20171130104952	\N	\N
ORG6000995	5546	4554	Sr. Analyst, CSR Representative Medan (Taufik Barus)	20171130104952	\N	0
ORG6000996	5547	4311	Analyst, Land and Building Management (Mona Veronika)	20171130104952	\N	\N
ORG6000997	5550	84	Group Head, Unit Layanan Jaringan Gas Rumah Tangga	20171130104952	\N	\N
ORG6000998	5551	5550	Secretary of Unit Layanan Jaringan Gas Rumah Tangga	20171130104952	\N	\N
ORG6000999	5552	82	Group Head, Strategic Management and Transformation	20171130104952	\N	\N
ORG6001000	5553	3747	Sr. Advisor, Professional Certification (Hermin Indayati)	20171130104952	\N	\N
ORG6001001	5555	3747	Sr. Advisor, Business Process Advisory (Henky Karmanu)	20171130104952	\N	\N
ORG6001002	5559	5552	Secretary of Strategic Management and Transformation	20171130104952	\N	\N
ORG6001003	5560	3832	Jr. Analyst, Finance HCBP	20171130104952	\N	\N
ORG6001004	5561	5553	Sr. Advisor, Professional Certification (Nella Andaryati)	20171130104952	\N	\N
ORG6001005	5562	5553	Sr. Analyst, Professional Certification (Nurul Rozana)	20171130104952	\N	\N
ORG6001006	5564	5553	Sr. Analyst, Professional Certification (Andri Gunawan)	20171130104952	\N	\N
ORG6001007	5566	3508	Sr. Staff, Contract Engineering (Anik Rurin)	20171130104952	\N	\N
ORG6001008	5569	5565	Staff, Construction	20171130104952	\N	\N
ORG6001009	5570	4678	Sr. Staff, Civil Engineering (Hernando Ginting)	20171130104952	\N	\N
ORG6001010	5571	4689	Staff, Contract Engineering (Koenthi)	20171130104952	\N	\N
ORG6001011	5573	5474	Jr. Analyst, Inisiasi Program dan Pengelolaan Stakeholder (Edwin Prioneanto)	20171130104952	\N	\N
ORG6001012	5574	5474	Sr. Staff, Inisiasi Program dan Pengelolaan Stakeholder (Puji Arman)	20171130104952	\N	\N
ORG6001013	5575	1296	Jr. Analyst, Permit (Ardi)	20171130104952	\N	\N
ORG6001014	5576	1296	Staff, Permit (Suladi)	20171130104952	\N	\N
ORG6001015	5577	1296	Staff, Permit (Fahrizal)	20171130104952	\N	\N
ORG6001016	5578	1296	Staff, Permit (Eddy Mulyono)	20171130104952	\N	\N
ORG6001017	5579	3452	Tim Contruction-QA/QC-HSE Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Budhijanto)	20171130104952	\N	\N
ORG6001018	5580	3452	Tim Contruction-QA/QC-HSE Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Gde Wahyu Utama)	20171130104952	\N	\N
ORG6001019	5581	3452	Tim Contruction-QA/QC-HSE Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Jonli Simanjuntak)	20171130104952	\N	\N
ORG6001020	5582	3452	Tim Contract Admin Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Niken Astria Safitri)	20171130104952	\N	\N
ORG6001021	5583	3452	Tim Pengendalian Material Kehandalan Jaringan Jawa bagian barat dan sumatera bagian selatan (Rosidin)	20171130104952	\N	\N
ORG6001022	5584	3840	Analyst, Workforce Management (Novita Hidayati)	20171130104952	\N	\N
ORG6001023	5585	3837	Analyst, Leadership Development (Corry Sagala)	20171130104952	\N	\N
ORG6001024	5587	3837	Sr. Analyst, Corporate Culture (Primaning Ayu)	20171130104952	\N	\N
ORG6001025	5588	3843	Analyst, HC Policy and Planning (Karlina)	20171130104952	\N	\N
ORG6001026	5589	3846	Staff, Learning Development (Laurina Dewita Ivanna Razak)	20171130104952	\N	\N
ORG6001027	5595	5735	Jr. Analyst, Group Synergy and Alignment (Aman Setiadji)	20171130104952	\N	\N
ORG6001028	5597	5550	Division Head, Technic	20171130104952	\N	\N
ORG6001029	5598	5550	Sr. Officer, Gas for Residential (Koord. Jargas Wilayah Timur - Sorong) (Ridha Ababil)	20171130104952	\N	\N
ORG6001030	5599	5550	Sr. Advisor, Finance (Unit Layanan Jaringan Gas Rumah Tangga) (Supriyadi)	20171130104952	\N	\N
ORG6001031	5600	4594	Sr. Staff, Portfolio Management (Adwitiya N. Wityasmoro)	20171130104952	\N	\N
ORG6001032	5602	5550	Korwil Jargas Barat (Achmad Rifai)	20171130104952	\N	\N
ORG6001033	5603	3464	Tim Construction, QAQC dan HSSE Pengembangan Infrastruktur dan kehandalan jaringan sumatera bagian tengah dan trasnmisi sumatera-Jawa (Eka Hari Setiawan)	20171130104952	\N	\N
ORG6001034	5604	3464	Tim Project Controller Pengembangan Infrastruktur dan kehandalan jaringan sumatera bagian tengah dan trasnmisi sumatera-Jawa (Musanif)	20171130104952	\N	\N
ORG6001035	5605	3464	Tim Pengendalia Material Pengembangan Infrastruktur dan kehandalan jaringan sumatera bagian tengah dan trasnmisi sumatera-Jawa (Rosidin)	20171130104952	\N	\N
ORG6001036	5607	3457	Tim Pengembangan Infrastruktur Inisiatif Baru (Arie Indra)	20171130104952	\N	\N
ORG6001037	5609	3320	Tim Construction dan QAQC & HSE Pengembangan Infrastruktur dan Kehandalan jaringan sumatera bagian utara dan batam (Azhari Ramdhani)	20171130104952	\N	\N
ORG6001038	5612	3428	Tim Pengendalian Material Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Ifan Hendriawan)	20171130104952	\N	\N
ORG6001039	5613	3428	Tim Engineering Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Abdur Rasyid)	20171130104952	\N	\N
ORG6001040	5615	3428	Tim Project Controller Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Aulia D Palupi)	20171130104952	\N	\N
ORG6001041	5616	3428	Tim Construction, QA/QC dan HSE Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Alexander Zulkarnain)	20171130104952	\N	\N
ORG6001042	5618	5069	Jr. Analyst, Energy Management Regional I (Aditya Eka Wijaya)	20171130104952	\N	\N
ORG6001043	5619	3737	Sr. Advisor, Business Process Advisory (Rudiatmoko)	20171130104952	\N	\N
ORG6001044	5621	3843	Analyst, Reward Management (Karlina)	20171130104952	\N	\N
ORG6001045	5622	5553	Administrasi (Agista)	20171130104952	\N	\N
ORG6001046	5625	5239	Analyst, Planning and Performance Management (Erny Sugiarti)	20171130104952	\N	\N
ORG6001047	5627	4808	Staff, Financial and Budget Planning Head Office and PMO Infrastructure (Puteri Ayuningtyas)	20171130104952	\N	\N
ORG6001048	5628	4282	Plt. Sr. Advisor, Information and Communication Technology Group Synergy (M. Andi Irawan)	20171130104952	\N	\N
ORG6001049	5629	4594	Plt. Advisor, Portfolio Management (Aditya Damawan M.P.)	20171130104952	\N	\N
ORG6001050	5630	4999	Jr. Analyst, Corporate Planning (Hendra Frayudi)	20171130104952	\N	\N
ORG6001051	5631	4590	Analyst, Corporate Strategy (Sandi Sifananda)	20171130104952	\N	\N
ORG6001052	5632	3829	Analyst, Sales Area Cirebon (Tito Bintoro)	20171130104952	\N	\N
ORG6001053	5633	3767	Jr. Analyst, Gas Planning (Hakim Wijaya)	20171130104952	\N	\N
ORG6001054	5634	4344	Advisor, Legal Contract (Weny Ayu Hapsari)	20171130104952	\N	\N
ORG6001055	5635	4085	Sr. Analyst, Business Partnership and Acquisition (Samson Sony)	20171130104952	\N	\N
ORG6001056	5652	4478	Jr. Analyst, External Communication (Rista Rama Dhany)	20171130104952	\N	\N
ORG6001057	5653	4780	Staff, Procedure and Controller (R. Vanni Aprilia)	20171130104952	\N	\N
ORG6001058	5654	3854	Sr. Analyst, Industrial Relations (Hamalsyahan)	20171130104952	\N	\N
ORG6001059	5655	3908	Analyst, Customer Management Area Semarang (Jana Budiyana)	20171130104952	\N	\N
ORG6001060	5656	3894	Sr. Analyst, Customer Management Area Sidoarjo (Hadi Sucipto Kusuma)	20171130104952	\N	\N
ORG6001061	5657	4801	Sr. Analyst, Financial and Budget Subsidiary (Neneng Sabeni)	20171130104952	\N	\N
ORG6001062	5658	4811	Staff, Financial and Budget Planning Business Unit And Unit Jargas (Devy Siswaningrum)	20171130104952	\N	\N
ORG6001063	5659	5691	Sr. Analyst, GCG and System Management (Tina Lestari)	20171130104952	\N	\N
ORG6001064	5660	5691	Jr. Analyst, GCG and System Management (Pangondian Manihuruk)	20171130104952	\N	\N
ORG6001065	5661	5691	Analyst, GCG and System Management (Nella Yakoba)	20171130104952	\N	\N
ORG6001066	5662	4554	Staff, CSR Representative Medan (Ridwan)	20171130104952	\N	0
ORG6001067	5663	4554	Analyst, CSR Representative Surabaya (Eko Cahyono)	20171130104952	\N	0
ORG6001068	5664	4730	Jr. Analyst, PGN and PGN Groups Accounting Standard (Aulia Parmawati)	20171130104952	\N	\N
ORG6001069	5665	5021	Sr. Staff, External Payment For Non Procurement (Rame Tambunan)	20171130104952	\N	\N
ORG6001070	5666	4771	Staff, Account Receiveable (Irwan)	20171130104952	\N	\N
ORG6001071	5667	5016	Staff, Reciept and Payment Integration (Lulun Cholisoh)	20171130104952	\N	\N
ORG6001072	5668	1296	Staff, Permit (Sunarti)	20171130104952	\N	\N
ORG6001073	5669	3829	Staff, Customer Management Area Cirebon (Mahfudz)	20171130104952	\N	\N
ORG6001074	5670	4071	Staff, Sales Administration Area Pekanbaru (Ahmadsyah Nasution)	20171130104952	\N	\N
ORG6001075	5671	4801	Sr. Staff, Financial and Budget Subsidiary and Cosolidation (Surya Dwi Kurniawan)	20171130104952	\N	\N
ORG6001076	5672	3428	Tim Contract Adminstration Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Nita Widyasumanti)	20171130104952	\N	\N
ORG6001077	5674	4282	Plt. Advisor, ICT Planning (Elfan Triawan)	20171130104952	\N	\N
ORG6001078	5675	5099	Staff, Energy Management Regional II (Baried Nurcahyo)	20171130104952	\N	\N
ORG6001079	5676	5098	Staff, Gas System Operation and Technology Regional II (Zanuar Kriswanto)	20171130104952	\N	\N
ORG6001080	5677	5100	Jr. Analyst, Asset and Reliability Distribution Regional II - Zona Pasuruan Probolinggo (Dwi Handoko Sandhi)	20171130104952	\N	\N
ORG6001081	5678	5188	Plt. Advisor, Asset Management (Ardi Viryawan)	20171130104952	\N	\N
ORG6001082	5679	1	Group Head, Strategic Stakeholder Management	20171130104952	\N	\N
ORG6001083	5680	5679	Secretary of Strategic Stakeholder Management	20171130104952	\N	\N
ORG6001084	5681	4242	Analyst, Gas System Operation (M. Subhan Missauri)	20171130104952	\N	\N
ORG6001085	5682	3745	Sr. Analyst, Product Management (Fitria Agristina Wijaya)	20171130104952	\N	\N
ORG6001086	5683	3746	Sr. Analyst, Marketing Communication (Wuriana Irawati)	20171130104952	\N	\N
ORG6001087	5684	4999	Staff, Corporate Planning (Umam Prabowo)	20171130104952	\N	\N
ORG6001088	5685	4311	Sr. Analyst, Land and Building Management (Wawan Hermawan)	20171130104952	\N	\N
ORG6001089	5686	4311	Sr. Analyst, Land and Building Management (Santika Budhi Utami)	20171130104952	\N	\N
ORG6001090	5687	4311	Analyst, Land and Building Management (Murdani Wijaya)	20171130104952	\N	\N
ORG6001091	5688	4311	Analyst, Land and Building Management (Rahadyan Kusumo Syailendra)	20171130104952	\N	\N
ORG6001092	5689	81	Project Director, Lelang LNG Supply for Distributed Gas Power Plants in Central Indonesia	20171130104952	\N	\N
ORG6001093	5690	5689	Secretary of Project Director - Lelang PLN	20171130104952	\N	\N
ORG6001094	5691	1	Division Head, Compliance, Safety and Risk Management	20171130104952	\N	\N
ORG6001095	5692	5691	Secretary of Compliance, Safety and Risk Management	20171130104952	\N	\N
ORG6001096	5693	5126	Jr. Engineer, Asset and Reliability Distribution Regional III Zona Batam (Didiet Pradityo)	20171130104952	\N	\N
ORG6001097	5694	5069	Staff, Energy Management Regional I (Gayuh Wulandari)	20171130104952	\N	\N
ORG6001098	5695	5033	Sr. Engineer, Asset and Reliability Transmission - Zona Lampung (Eka Perkasa)	20171130104952	\N	\N
ORG6001099	5696	5070	Sr. Engineer, Asset and Reliability Distribution Regional I - Zona Lampung (Eka Perkasa)	20171130104952	\N	\N
ORG6001100	5697	3828	Division Head, Human Capital Center of Exellence	20171130104952	\N	\N
ORG6001101	5701	5550	Staff, Sales Representative  Jakarta (Bogor dan Depok) (Ujang Ishak)	20171130104952	\N	\N
ORG6001102	5702	5550	Staff, Sales Representative Tangerang (Endang Suhada)	20171130104952	\N	\N
ORG6001103	5703	5550	Analyst, Sales Representative Surabaya	20171130104952	\N	\N
ORG6001104	5705	5550	Staff, Sales Representative Surabaya (Sumarto)	20171130104952	\N	\N
ORG6001105	5706	5550	Staff, Sales Representative Batam (Rommel Simanjuntak)	20171130104952	\N	\N
ORG6001106	5707	5550	Staff, Sales Representative Jakarta	20171130104952	\N	\N
ORG6001107	5708	5550	Staff, Sales Representative Semarang merangkap Blora (Astuti)	20171130104952	\N	\N
ORG6001108	5709	5125	Jr. Analyst, Energy Management Regional III (Mei Silfan)	20171130104952	\N	\N
ORG6001109	5710	5066	Specialist, Asset and Reliability Distribution Regional II (Agoeng P Noegroho)	20171130104952	\N	\N
ORG6001110	5712	4216	Advisor, Infrastructure Performance Management (Hendri Joniansyah)	20171130104952	\N	\N
ORG6001111	5713	3742	Sr. Analyst, Supply Contract Management (Melanton Rahmanto)	20171130104952	\N	\N
ORG6001112	5714	82	Sekretaris Direktur Strategi dan Pengembangan Bisnis (Dewi Purnama)	20171130104952	\N	\N
ORG6001113	5715	3428	Tim Construction, QA/QC dan HSE Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Sopyan Zamhuri)	20171130104952	\N	\N
ORG6001114	5716	1285	Engineer, Instrument and Control Engineering (Ni Made DR)	20171130104952	\N	\N
ORG6001115	5717	1274	Koordinator Manajemen Konstruksi dan QA/QC (M. Andi Rahman)	20171130104952	\N	\N
ORG6001116	5718	5717	Sr. Engineer, Construction (Trio Dedy Kusuma)	20171130104952	\N	\N
ORG6001117	5719	5717	Jr. Engineer, Construction (Sundung J Silaban)	20171130104952	\N	\N
ORG6001118	5720	3769	Advisor, Corporate Sales and Customer Management (Afdal)	20171130104952	\N	\N
ORG6001119	5721	1269	Seketaris Group Head PMO (Anya Mayori)	20171130104952	\N	\N
ORG6001120	5722	4534	Jr. Analyst, Corporate Services (Riki Yazwardi)	20171130104952	\N	\N
ORG6001121	5723	4534	Jr. Analyst, Corporate Services (Kurniawan)	20171130104952	\N	\N
ORG6001122	5724	4534	Staff, Corporate Services (M. Punky)	20171130104952	\N	\N
ORG6001123	5725	4311	Sr. Analyst, Land And Building Management (Warkunah)	20171130104952	\N	\N
ORG6001124	5726	4311	Sr. Analyst, General Affairs Management (Achmad Mulyono)	20171130104952	\N	\N
ORG6001125	5727	4478	Staff, Corporate Communication (Sukardi)	20171130104952	\N	\N
ORG6001126	5728	4530	Sr. Analyst, Investor Relations (Meutia Prima)	20171130104952	\N	\N
ORG6001127	5729	4533	Sr. Advisor, Corporate Social Responsibility (Anak Agung Raka Haryana)	20171130104952	\N	0
ORG6001128	5730	4282	Sr. Officer, ICT Planning (Djoko Suripto)	20171130104952	\N	\N
ORG6001129	5731	3828	Division Head, Human Capital Business Partner and Services	20171130104952	\N	\N
ORG6001130	5732	5333	Jr. Engineer, Contract Engineering (Sudarmo)	20171130104952	\N	\N
ORG6001131	5733	3768	Analyst, Sales and Customer Management (Muhammad Farkhan Rizaputra)	20171130104952	\N	\N
ORG6001132	5734	3884	Jr. Analyst, Sales Area Lampung (Adam Smith El Jaber)	20171130104952	\N	\N
ORG6001133	5735	5731	Advisor, Group Synergy and Alignment (Joice)	20171130104952	\N	\N
ORG6001134	5736	4531	Advisor, Business Process and Change Management (Sri Wahyuni)	20171130104952	\N	\N
ORG6001135	5737	3804	Sr. Analyst, Customer Management Area Bogor (Damar Riyanti)	20171130104952	\N	\N
ORG6001136	5738	3898	Staff, Billing Area Jakarta (Rosdiana)	20171130104952	\N	\N
ORG6001137	5739	4467	Jr. Analyst, Government and Community Relations (Tengku Rifki Fauzan)	20171130104952	\N	\N
ORG6001138	5740	4282	Jr. Analyst, ICT Planning (Agus Cucu)	20171130104952	\N	\N
ORG6001139	5741	3837	Analyst, Career and Successsion Planning (Adelina)	20171130104952	\N	\N
ORG6001140	5742	3840	Sr. Staff, Workforce and Competence Management (Retno Wahyuning Astuti)	20171130104952	\N	\N
ORG6001141	5743	3846	Sr. Staff, Learning and Knowledge Management (Listya)	20171130104952	\N	\N
ORG6001142	5744	5735	Staff, Group Synergy and Alignment (Achmad Afandi)	20171130104952	\N	\N
ORG6001143	5746	4708	Sr. Staff, Revenue Management (Romario Drajad)	20171130104952	\N	\N
ORG6001144	5747	3464	Tim Engineering Pengembangan Infrastruktur dan kehandalan jaringan sumatera bagian tengah dan trasnmisi sumatera-Jawa (Devita Sari)	20171130104952	\N	\N
ORG6001145	5748	3428	Tim Construction, QA/QC dan HSE Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Charles P Bakara)	20171130104952	\N	\N
ORG6001146	5749	3428	Tim Construction, QA/QC dan HSE Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Achmad Syuhada)	20171130104952	\N	\N
ORG6001147	5750	3428	Tim Construction, QA/QC dan HSE Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Halid Syarif)	20171130104952	\N	\N
ORG6001148	5751	3428	Tim Project Controller Pengembangan Infrastruktur Jawa bagian barat dan sumatera bagian selatan (Mardeni)	20171130104952	\N	\N
ORG6001149	5752	4467	Sr. Staff, Goverment and Community Relations (Rauminar Estikasari)	20171130104952	\N	\N
ORG6001150	5754	5599	Advisor, Finance (Tri Setyo Utomo)	20171130104952	\N	\N
ORG6001151	5755	5754	Analyst, Finance (Harry Ruswandi)	20171130104952	\N	\N
ORG6001152	5756	5754	Staff, Finance (Nurdin)	20171130104952	\N	\N
ORG6001153	5757	5599	Advisor, Administration (Tri Setyo Utomo)	20171130104952	\N	\N
ORG6001154	5758	5757	Jr. Analyst, Administrasi (Heru Budi)	20171130104952	\N	\N
ORG6001155	5759	5597	Pejabat Pembuat Komitmen (M. Hardiansyah)	20171130104952	\N	\N
ORG6001156	5760	5759	Staff, Construction Proyek Musi Banyuasin (M. Safrin)	20171130104952	\N	\N
ORG6001157	5761	5759	Jr. Analyst, Procurement Proyek Musi Banyuasin (Agung Wicaksono)	20171130104952	\N	\N
ORG6001158	5762	5597	Pejabat Pembuat Komitmen (Lintong Silalahi)	20171130104952	\N	\N
ORG6001159	5763	5762	Sr. Engineer, Construction Proyek Lampung (Achmad Hidayat)	20171130104952	\N	\N
ORG6001160	5764	5762	Engineer, Construction Proyek Lampung (Suseno Salim)	20171130104952	\N	\N
ORG6001161	5765	5597	Pejabat Pembuat Komitmen (Timbul Aritonang)	20171130104952	\N	\N
ORG6001162	5766	5765	Sr. Engineer, Mechanical Engineering Proyek Mojokerto (Marlon Riolan)	20171130104952	\N	\N
ORG6001163	5767	5765	Jr. Analyst, Procurement Proyek Mojokerto (Indra Gunawan)	20171130104952	\N	\N
ORG6001164	5768	5597	Pejabat Pembuat Komitmen (Grace Theresia)	20171130104952	\N	\N
ORG6001165	5769	5768	Engineer, Contract Engineering Proyek Conventer Kit dan Rumah Susun (Ade Subhan)	20171130104952	\N	\N
ORG6001166	5770	5597	Pejabat Pembuat Komitmen (Pahala Baringbing)	20171130104952	\N	\N
ORG6001167	5771	5770	Analyst, Sales Representative Cirebon - Proyek Penetrasi (Endang Sofian)	20171130104952	\N	\N
ORG6001168	5772	5770	Staff, Sales Representative Batam - Proyek Penetrasi (Rommel Simanjuntak)	20171130104952	\N	\N
ORG6001169	5773	5770	Staff, Sales Representative Surabaya - Proyek Penetrasi (Sumarto)	20171130104952	\N	\N
ORG6001170	5774	5770	Section Head, Sales Administration Area Tarakan - Proyek Penetrasi (Bramantya P Saputra)	20171130104952	\N	\N
ORG6001171	5775	5770	Staff, Sales Representative  Jakarta (Bogor dan Depok) - Proyek Penetrasi (Ujang Ishak)	20171130104952	\N	\N
ORG6001172	5776	5597	Specialist, Engineering (Erwin Simanjuntak)	20171130104952	\N	\N
ORG6001173	5777	5597	Sr. Analyst, Procurement (Cahyo Sudarto)	20171130104952	\N	\N
ORG6001174	5778	5777	Jr. Analyst, Procurement (Jomaren)	20171130104952	\N	\N
ORG6001175	5779	5776	Sr. Engineer, Construction (Sentot Suhartono)	20171130104952	\N	\N
ORG6001176	5780	5776	Jr. Analyst, Planning and Engineering (Agung Rochman Solichi)	20171130104952	\N	\N
ORG6001177	5781	5776	Jr. Engineer, Mechanical Engineering (Findra Agustian Ardhi)	20171130104952	\N	\N
ORG6001178	5782	5776	Jr. Engineer, Instrument and Control Engineering (Galih Eko Ardiyanto)	20171130104952	\N	\N
ORG6001179	5783	5550	Sr. Specialist, Operation and Commerce (Daniel HS Hutahuruk)	20171130104952	\N	\N
ORG6001180	5784	5783	Advisor, Commerce (Asad)	20171130104952	\N	\N
ORG6001181	5785	5783	Specialist, Operation (Agung Prasetyo)	20171130104952	\N	\N
ORG6001182	5786	5784	Sr. Staff, Commerce (Hanief Fadhillah)	20171130104952	\N	\N
ORG6001183	5787	5784	Jr. Engineer, commerce (Ade Ihwana)	20171130104952	\N	\N
ORG6001184	5788	5784	Staff, Commerce (Nahrowi)	20171130104952	\N	\N
ORG6001185	5789	5784	Staff, Commerce (Hendri)	20171130104952	\N	\N
ORG6001186	5790	5784	Jr. Engineer, Commerce (Supriyono)	20171130104952	\N	\N
ORG6001187	5791	5785	Sr. Analyst, Operation (Dwi Maryono)	20171130104952	\N	\N
ORG6001188	5792	5785	Engineer, Operation (Ade Subhan)	20171130104952	\N	\N
ORG6001189	5793	5785	Staff, Operation (Supriatna)	20171130104952	\N	\N
ORG6001190	5794	5550	Analyst, Sales Representative Cirebon (Endang Sofian)	20171130104952	\N	\N
ORG6001191	5795	5703	Jr. Analyst, Sales Representative Surabaya (Endang Sri Rahayu)	20171130104952	\N	\N
ORG6001192	5796	3745	Sr. Staff, Product Development (Adwitiya N Wityasmoro)	20171130104952	\N	\N
ORG6001193	5797	5794	Sekretaris (Untuk ambil Nomor di ESMS)	20171130104952	\N	\N
ORG6001194	5798	5706	Sekretaris (Untuk ambil Nomor di ESMS Jargas Batam)	20171130104952	\N	\N
ORG6001195	5799	5707	Sekretaris (Untuk ambil Nomor di ESMS Jargas Jakarta)	20171130104952	\N	\N
ORG6001196	5800	5702	Sekretaris (Untuk ambil Nomor di ESMS Jargas Tangerang)	20171130104952	\N	\N
ORG6001197	5801	5701	Sekretaris (Untuk ambil Nomor di ESMS Jargas Bogor)	20171130104952	\N	\N
ORG6001198	5802	5708	Sekretaris (Untuk ambil Nomor di ESMS Jargas Semarang dan Blora)	20171130104952	\N	\N
ORG6001199	5803	4341	Pen test purpose	20171130104952	\N	\N
ORG6001200	5804	4708	Sr. Analyst, Revenue Management (Ichsan Priambodo)	20171130104952	\N	\N
ORG6001201	5805	3767	Staff, Gas Planning and Optimization Regional I (M. Adhenhari Musfaro)	20171130104952	\N	\N
ORG6001202	5806	4467	Staff, Goverment and Community Relations (Cut Nuremelia)	20171130104952	\N	\N
ORG6001203	5807	3876	Staff, Sales Administration Area Tangerang (Yumna Anindya Pangesti)	20171130104952	\N	\N
ORG6001204	5808	3742	Staff, Gas Supply (Rayvario Sultan)	20171130104952	\N	\N
ORG6001205	5809	3956	Staff, Sales Administration (Madina Annanisa)	20171130104952	\N	\N
ORG6001206	5810	5679	Staff, Strategic Stakeholder Management Representatives Medan (Edy Prianto)	20171130104952	\N	\N
\.


--
-- Data for Name: ms_program; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY ms_program (rowid, title, satker, content, create_date, create_by, update_by, update_date, tipe) FROM stdin;
PRG2	Program 1	["SATKER6001207","SATKER6001210"]	Pesan 1	2017-12-18 13:44:07.103427	\N	\N	\N	Replay
PRG3	Program 2	["SATKER6001207","SATKER6001210"]	Pesan 2	2017-12-18 13:46:37.645898	\N	\N	\N	Replay
PRG5	PRGRM PGN	["SATKER6001252"]	Bagaimana keadaan anda terhadap bencana [Nama_Bencana]? (1) Saya baik-baik saja  (2) Saya membutuhkan bantuan  \r\n \r\nBalas dengan format [NO_PILIHAN]#[NIPG] Contoh : 1#0012892715 \r\n \r\nJika anda membutuhkan bantuan, segera akses link berikut : http://locateme.pgn.co.id	2017-12-19 02:21:04.830577	\N	\N	\N	Replay
PRG6	Program 1	["SATKER6001237","SATKER6001240","SATKER6001243","SATKER6001246","SATKER6001249","SATKER6001252"]	Pesan testing	2017-12-20 11:21:35.088335	\N	\N	\N	Not Replay
\.


--
-- Data for Name: ms_project; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY ms_project (rowid, project_name, start_project, end_project, project_segment, project_owner, project_manager, project_status, last_activity, description, create_date, create_by, update_date, update_by) FROM stdin;
PROJECT3	Project 3	2017-11-01	2017-11-30	DEP10	Owner	Manager	Status			\N	\N	\N	\N
PROJECT4	Project 1	2017-11-01	2017-11-02	Segment 1						\N	\N	\N	\N
\.


--
-- Data for Name: ms_satker; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY ms_satker (rowid, refforgzid, satkerid, satker, createdate) FROM stdin;
SATKER6001207	\N	Commerce Directorate	Commerce Directorate	20171204094448
SATKER6001208	\N	Finance Directorate	Finance Directorate	20171204094448
SATKER6001209	\N	Infrastructure Business Management	Infrastructure Business Management	20171204094448
SATKER6001210	\N	HCM Division	HCM Division	20171204094448
SATKER6001211	\N	PMO Infrastructure	PMO Infrastructure	20171204094448
SATKER6001212	\N	Area Palembang	Area Palembang	20171204094448
SATKER6001213	\N	Business Unit Gas Product	Business Unit Gas Product	20171204094448
SATKER6001214	\N	Legal	Legal	20171204094448
SATKER6001215	\N	Area Medan	Area Medan	20171204094448
SATKER6001216	\N	Human Capital Management	Human Capital Management	20171204094448
SATKER6001217	\N	Human Capital Management 	Human Capital Management 	20171204094448
SATKER6001218	\N	Logistic and General Affairs	Logistic and General Affairs	20171204094448
SATKER6001219	\N	Treasury	Treasury	20171204094448
SATKER6001220	\N	Accounting	Accounting	20171204094448
SATKER6001221	\N	Area Bogor	Area Bogor	20171204094448
SATKER6001222	\N	Gas Distribution Management Regional II	Gas Distribution Management Regional II	20171204094448
SATKER6001223	\N	Area Jakarta	Area Jakarta	20171204094448
SATKER6001224	\N	Area Tangerang	Area Tangerang	20171204094448
SATKER6001225	\N	Area Cilegon	Area Cilegon	20171204094448
SATKER6001226	\N	Area Bekasi	Area Bekasi	20171204094448
SATKER6001227	\N	Area Surabaya	Area Surabaya	20171204094448
SATKER6001228	\N	Area Semarang	Area Semarang	20171204094448
SATKER6001229	\N	Government Relations	Government Relations	20171204094448
SATKER6001230	\N	Marketing and Product Development	Marketing and Product Development	20171204094448
SATKER6001231	\N	Strategy and Business Development Directorate	Strategy and Business Development Directorate	20171204094448
SATKER6001232	\N	Risk Management and GCG Division	Risk Management and GCG Division	20171204094448
SATKER6001233	\N	Investor Relations	Investor Relations	20171204094448
SATKER6001234	\N	Business Unit Infrastructure Operations	Business Unit Infrastructure Operations	20171204094448
SATKER6001235	\N	Area Karawang	Area Karawang	20171204094448
SATKER6001236	\N	Financial Control and Budget	Financial Control and Budget	20171204094448
SATKER6001237	\N	Area Lampung	Area Lampung	20171204094448
SATKER6001238	\N	Human Capital and General Services Directorate (Perbantuan PT PGAS Solution)	Human Capital and General Services Directorate (Perbantuan PT PGAS Solution)	20171204094448
SATKER6001239	\N	Infrastructure and Technology Directorate (Perbantuan PT PGAS Solution)	Infrastructure and Technology Directorate (Perbantuan PT PGAS Solution)	20171204094448
SATKER6001240	\N	Risk Management and GCG	Risk Management and GCG	20171204094448
SATKER6001241	\N	President Directors Office (Perbantuan Kementerian ESDM)	President Directors Office (Perbantuan Kementerian ESDM)	20171204094448
SATKER6001242	\N	President Directors Office (Perbantuan PT PGAS Solution)	President Directors Office (Perbantuan PT PGAS Solution)	20171204094448
SATKER6001243	\N	Gas Distribution Management Regional I	Gas Distribution Management Regional I	20171204094448
SATKER6001244	\N	Gas System Management	Gas System Management	20171204094448
SATKER6001245	\N	Area Cirebon	Area Cirebon	20171204094448
SATKER6001246	\N	Area Dumai	Area Dumai	20171204094448
SATKER6001247	\N	Strategic Management Division	Strategic Management Division	20171204094448
SATKER6001248	\N	Corporate Communication	Corporate Communication	20171204094448
SATKER6001249	\N	Gas Supply	Gas Supply	20171204094448
SATKER6001250	\N	Finance Directorate (Perbantuan PT Widar Mandripa Nusantara)	Finance Directorate (Perbantuan PT Widar Mandripa Nusantara)	20171204094448
SATKER6001251	\N	Information and Communication Technology	Information and Communication Technology	20171204094448
SATKER6001252	\N	Corporate Social Responsibility	Corporate Social Responsibility	20171204094448
SATKER6001253	\N	Center Of Technical Excellence	Center Of Technical Excellence	20171204094448
SATKER6001254	\N	Portfolio and Performance Management	Portfolio and Performance Management	20171204094448
SATKER6001255	\N	Area Sidoarjo	Area Sidoarjo	20171204094448
SATKER6001256	\N	Internal Audit	Internal Audit	20171204094448
SATKER6001257	\N	PT Transgasindo	PT Transgasindo	20171204094448
SATKER6001258	\N	Commerce Directorate (Perbantuan PT PGAS Solution)	Commerce Directorate (Perbantuan PT PGAS Solution)	20171204094448
SATKER6001259	\N	Finance Directorate (Perbantuan PT Gagas Energi Indonesia)	Finance Directorate (Perbantuan PT Gagas Energi Indonesia)	20171204094448
SATKER6001260	\N	PT Solusi Energi Nusantara 	PT Solusi Energi Nusantara 	20171204094448
SATKER6001261	\N	Infrastructure and Technology Directorate (Perbantuan  PT PGN LNG Indonesia)	Infrastructure and Technology Directorate (Perbantuan PT PGN LNG Indonesia)	20171204094448
SATKER6001262	\N	Human Capital and General Services Directorate (Perbantuan PT. Nusantara Regas)	Human Capital and General Services Directorate (Perbantuan PT. Nusantara Regas)	20171204094448
SATKER6001263	\N	Information and Communication Technology (Perbantuan PT. PGAS Telekomunikasi Nusantara) 	Information and Communication Technology (Perbantuan PT. PGAS Telekomunikasi Nusantara) 	20171204094448
SATKER6001264	\N	Human Capital and General Services Directorate (Perbantuan PT Nusantara Regas)	Human Capital and General Services Directorate (Perbantuan PT Nusantara Regas)	20171204094448
SATKER6001265	\N	Human Capital and General Services Directorate (Perbantuan PT PGN LNG Indonesia) 	Human Capital and General Services Directorate (Perbantuan PT PGN LNG Indonesia) 	20171204094448
SATKER6001266	\N	Infrastructure and Technology Directorate (Perbantuan PT Permata Graha Nusantara)	Infrastructure and Technology Directorate (Perbantuan PT Permata Graha Nusantara)	20171204094448
SATKER6001267	\N	Perbantuan PT PGAS Telekomunikasi Nusantara	Perbantuan PT PGAS Telekomunikasi Nusantara	20171204094448
SATKER6001268	\N	PT PGAS Solution	PT PGAS Solution	20171204094448
SATKER6001269	\N	Infrastructure and Technology Directorate (Perbantuan PT PGN LNG Indonesia)	Infrastructure and Technology Directorate (Perbantuan PT PGN LNG Indonesia)	20171204094448
SATKER6001270	\N	Human Capital and General Services Directorate (Perbantuan PT Kalimantan Jawa Gas)	Human Capital and General Services Directorate (Perbantuan PT Kalimantan Jawa Gas)	20171204094448
SATKER6001271	\N	Human Capital and General Services Directorate (Perbantuan PT Nusantara Regas) 	Human Capital and General Services Directorate (Perbantuan PT Nusantara Regas) 	20171204094448
SATKER6001272	\N	Commerce Directorate (Perbantuan PT Gagas Energi Indonesia)	Commerce Directorate (Perbantuan PT Gagas Energi Indonesia)	20171204094448
SATKER6001273	\N	Infrastructure and Technology Directorate (Perbantuan PT Kalimantan Jawa Gas)	Infrastructure and Technology Directorate (Perbantuan PT Kalimantan Jawa Gas)	20171204094448
\.


--
-- Data for Name: ms_segment; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY ms_segment (rowid, segment, code_segment, create_date, create_by, update_date, update_by) FROM stdin;
SEGMENT6000019	PGN	SE-01	\N	\N	\N	\N
SEGMENT6000020	TELCO	SE-02	\N	\N	\N	\N
\.


--
-- Data for Name: ms_workflow; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY ms_workflow (rowid, reffactivity, reffemp, createdate, createperson, updatedate, updateperson, status, priority, refforg, reffjobpos, reffeven, createbyt, nama_k) FROM stdin;
MSW16425	BROADCAST	EMP6001644	2017-12-19	system	\N	\N	\N	1	\N	4554	CREATE	4554	\N
MSW16426	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4554	\N
MSW16427	BROADCAST	EMP6001651	2017-12-19	system	\N	\N	\N	1	\N	4555	CREATE	4555	\N
MSW16428	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4555	\N
MSW16429	BROADCAST	EMP6002507	2017-12-19	system	\N	\N	\N	1	\N	4556	CREATE	4556	\N
MSW16430	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4556	\N
MSW16431	BROADCAST	EMP6002202	2017-12-19	system	\N	\N	\N	1	\N	4557	CREATE	4557	\N
MSW16432	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4557	\N
MSW16433	BROADCAST	EMP6002526	2017-12-19	system	\N	\N	\N	1	\N	4558	CREATE	4558	\N
MSW16434	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4558	\N
MSW16435	BROADCAST	EMP6001853	2017-12-19	system	\N	\N	\N	1	\N	4559	CREATE	4559	\N
MSW16436	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4559	\N
MSW16437	BROADCAST	EMP6001455	2017-12-19	system	\N	\N	\N	1	\N	4562	CREATE	4562	\N
MSW16438	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4562	\N
MSW16439	BROADCAST	EMP6002129	2017-12-19	system	\N	\N	\N	1	\N	4563	CREATE	4563	\N
MSW16440	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4563	\N
MSW16441	BROADCAST	EMP6001369	2017-12-19	system	\N	\N	\N	1	\N	4564	CREATE	4564	\N
MSW16442	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4564	\N
MSW16443	BROADCAST	EMP6002337	2017-12-19	system	\N	\N	\N	1	\N	4565	CREATE	4565	\N
MSW16444	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4565	\N
MSW16445	BROADCAST	EMP6002152	2017-12-19	system	\N	\N	\N	1	\N	4566	CREATE	4566	\N
MSW16446	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4566	\N
MSW16447	BROADCAST	EMP6001817	2017-12-19	system	\N	\N	\N	1	\N	4567	CREATE	4567	\N
MSW16448	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4567	\N
MSW16449	BROADCAST	EMP6002159	2017-12-19	system	\N	\N	\N	1	\N	4569	CREATE	4569	\N
MSW16450	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	4569	\N
MSW16451	BROADCAST	EMP6002001	2017-12-19	system	\N	\N	\N	1	\N	5032	CREATE	5032	\N
MSW16452	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	5032	\N
MSW16453	BROADCAST	EMP6002022	2017-12-19	system	\N	\N	\N	1	\N	5517	CREATE	5517	\N
MSW16454	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	5517	\N
MSW16455	BROADCAST	EMP6001382	2017-12-19	system	\N	\N	\N	1	\N	5546	CREATE	5546	\N
MSW16456	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	5546	\N
MSW16457	BROADCAST	EMP6001793	2017-12-19	system	\N	\N	\N	1	\N	5662	CREATE	5662	\N
MSW16458	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	5662	\N
MSW16459	BROADCAST	EMP6002180	2017-12-19	system	\N	\N	\N	1	\N	5663	CREATE	5663	\N
MSW16460	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	5663	\N
MSW16461	BROADCAST	EMP6001773	2017-12-19	system	\N	\N	\N	1	\N	5729	CREATE	5729	\N
MSW16462	BROADCAST	EMP6002148	2017-12-19	system	\N	\N	\N	2	\N	4533	FORWARD	5729	\N
\.


--
-- Data for Name: mskonversiberat; Type: TABLE DATA; Schema: public; Owner: syfawija
--

COPY mskonversiberat (rowid, items_id, delivery_number, start, "end", berat, uom, createby, createdate, updateby, updatedate, kandang, farms) FROM stdin;
konv6003075	MD49	91111	2018-01-29	2018-02-28	450	Gram	\N	2018-02-06 22:27:51.014153+07	\N	\N	Kandang 1	Farms Wijaya
konv6003074	MD49	131	2018-01-31	2018-01-10	400	Gram	\N	2018-02-06 22:25:51.715475+07	\N	\N	Kandang 2	Farms Wijaya
konv6003076	MD49	131	2018-02-10	2018-02-27	500	Gram	\N	2018-02-06 22:29:16.125659+07	\N	\N	Kandang 1	Farms Wijaya
\.


--
-- Name: penc_ayam_id_seq; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('penc_ayam_id_seq', 43, true);


--
-- Data for Name: permission; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY permission (menu_id, group_id, id) FROM stdin;
9	3717178	idpriv 3717206
3208980	3717178	idpriv 3717207
3209108	3717178	idpriv 3717208
3209222	3717178	idpriv 3717209
3209221	3717178	idpriv 3717210
3209110	3717178	idpriv 3717211
3209226	3717178	idpriv 3717212
3209225	3717178	idpriv 3717213
3209109	3717178	idpriv 3717214
3209223	3717178	idpriv 3717215
3514361	3717178	idpriv 3717216
115322	3717178	idpriv 3717217
3209077	3717178	idpriv 3717218
115323	3717178	idpriv 3717219
115324	3717178	idpriv 3717220
115325	3717178	idpriv 3717221
115326	3717178	idpriv 3717222
115327	3717178	idpriv 3717223
3209015	3717178	idpriv 3717224
3078328	3717178	idpriv 3717225
115328	3717178	idpriv 3717226
115329	3717178	idpriv 3717227
115330	3717178	idpriv 3717228
115332	3717178	idpriv 3717229
3078327	3717178	idpriv 3717230
3209144	3717178	idpriv 3717231
3209143	3717178	idpriv 3717232
7	5255700	idpriv 6003082
115321	5255700	idpriv 6003083
1	3447880	idpriv 4563968
115333	3447880	idpriv 4563969
115335	3447880	idpriv 4563970
3208983	3447880	idpriv 4563971
3505082	3447880	idpriv 4563972
3505081	3447880	idpriv 4563973
3505083	3447880	idpriv 4563974
3450409	3447880	idpriv 4563975
3208985	3447880	idpriv 4563976
3208986	3447880	idpriv 4563977
3208987	3447880	idpriv 4563978
6	3447880	idpriv 4563979
3208981	3447880	idpriv 4563980
3208982	3447880	idpriv 4563981
7	3447880	idpriv 4563982
115336	3447880	idpriv 4563983
115337	3447880	idpriv 4563984
115338	3447880	idpriv 4563985
115339	3447880	idpriv 4563986
115340	3447880	idpriv 4563987
115321	3447880	idpriv 4563988
3208988	3447880	idpriv 4563989
9	3447880	idpriv 4563990
3208980	3447880	idpriv 4563991
3209108	3447880	idpriv 4563992
3209110	3447880	idpriv 4563993
3209109	3447880	idpriv 4563994
3514361	3447880	idpriv 4563995
115322	3447880	idpriv 4563996
3209077	3447880	idpriv 4563997
115323	3447880	idpriv 4563998
115324	3447880	idpriv 4563999
115325	3447880	idpriv 4564000
115326	3447880	idpriv 4564001
115327	3447880	idpriv 4564002
3209015	3447880	idpriv 4564003
3078328	3447880	idpriv 4564004
115328	3447880	idpriv 4564005
3728990	3447880	idpriv 4564006
115329	3447880	idpriv 4564007
115330	3447880	idpriv 4564008
115332	3447880	idpriv 4564009
3078327	3447880	idpriv 4564010
3209143	3447880	idpriv 4564011
3729044	3447880	idpriv 4564012
3729045	3447880	idpriv 4564013
3973025	3447880	idpriv 4564014
6	3813779	idpriv 4564511
3208981	3813779	idpriv 4564512
3208982	3813779	idpriv 4564513
9	3813779	idpriv 4564514
3208980	3813779	idpriv 4564515
3209108	3813779	idpriv 4564516
3209222	3813779	idpriv 4564517
3209221	3813779	idpriv 4564518
3209110	3813779	idpriv 4564519
3209226	3813779	idpriv 4564520
3209225	3813779	idpriv 4564521
3209109	3813779	idpriv 4564522
3209224	3813779	idpriv 4564523
3209223	3813779	idpriv 4564524
3514361	3813779	idpriv 4564525
115322	3813779	idpriv 4564526
115323	3813779	idpriv 4564527
6002824	5255700	idpriv 6003084
6002825	5255700	idpriv 6003085
6002901	5255700	idpriv 6003086
6003077	5255700	idpriv 6003087
6003078	5255700	idpriv 6003088
6003079	5255700	idpriv 6003089
6003080	5255700	idpriv 6003090
6003081	5255700	idpriv 6003091
6002634	5255700	idpriv 6003092
6002635	5255700	idpriv 6003093
6002636	5255700	idpriv 6003094
6002663	5255700	idpriv 6003095
6002701	5255700	idpriv 6003096
6002702	5255700	idpriv 6003097
6002703	5255700	idpriv 6003098
6002788	5255700	idpriv 6003099
5337986	5255700	idpriv 6003100
5563314	5255700	idpriv 6003101
6000001	5255700	idpriv 6003102
115324	3813779	idpriv 4564528
115325	3813779	idpriv 4564529
115326	3813779	idpriv 4564530
115327	3813779	idpriv 4564531
3209015	3813779	idpriv 4564532
3078328	3813779	idpriv 4564533
115328	3813779	idpriv 4564534
3728990	3813779	idpriv 4564535
115329	3813779	idpriv 4564536
115330	3813779	idpriv 4564537
115332	3813779	idpriv 4564538
3078327	3813779	idpriv 4564539
3209144	3813779	idpriv 4564540
3209143	3813779	idpriv 4564541
3729044	3813779	idpriv 4564542
3729045	3813779	idpriv 4564543
3973025	3813779	idpriv 4564544
9	5045262	idpriv 5045263
3208980	5045262	idpriv 5045264
3209108	5045262	idpriv 5045265
3209222	5045262	idpriv 5045266
3209221	5045262	idpriv 5045267
3209110	5045262	idpriv 5045268
3209226	5045262	idpriv 5045269
3209225	5045262	idpriv 5045270
3209109	5045262	idpriv 5045271
3209224	5045262	idpriv 5045272
3209223	5045262	idpriv 5045273
115322	5045262	idpriv 5045274
115323	5045262	idpriv 5045275
115324	5045262	idpriv 5045276
115325	5045262	idpriv 5045277
115326	5045262	idpriv 5045278
115327	5045262	idpriv 5045279
3209015	5045262	idpriv 5045280
3078328	5045262	idpriv 5045281
115328	5045262	idpriv 5045282
115329	5045262	idpriv 5045283
115330	5045262	idpriv 5045284
115332	5045262	idpriv 5045285
3078327	5045262	idpriv 5045286
3729044	5045262	idpriv 5045287
3729045	5045262	idpriv 5045288
3973025	5045262	idpriv 5045289
6	5054372	idpriv 5122398
3208981	5054372	idpriv 5122399
3208982	5054372	idpriv 5122400
9	5054372	idpriv 5122401
3209149	5054372	idpriv 5122402
3208980	5054372	idpriv 5122403
3209108	5054372	idpriv 5122404
3209222	5054372	idpriv 5122405
3209110	5054372	idpriv 5122406
3209109	5054372	idpriv 5122407
3209224	5054372	idpriv 5122408
3514361	5054372	idpriv 5122409
115322	5054372	idpriv 5122410
115323	5054372	idpriv 5122411
115324	5054372	idpriv 5122412
115325	5054372	idpriv 5122413
115326	5054372	idpriv 5122414
115327	5054372	idpriv 5122415
3209015	5054372	idpriv 5122416
3078328	5054372	idpriv 5122417
115328	5054372	idpriv 5122418
3728990	5054372	idpriv 5122419
115329	5054372	idpriv 5122420
115332	5054372	idpriv 5122421
3078327	5054372	idpriv 5122422
3209143	5054372	idpriv 5122423
3729044	5054372	idpriv 5122424
3729045	5054372	idpriv 5122425
3973025	5054372	idpriv 5122426
6	3813781	idpriv 5242003
3208981	3813781	idpriv 5242004
3208982	3813781	idpriv 5242005
9	3813781	idpriv 5242006
3209149	3813781	idpriv 5242007
3208980	3813781	idpriv 5242008
3209108	3813781	idpriv 5242009
3209222	3813781	idpriv 5242010
3209221	3813781	idpriv 5242011
3209110	3813781	idpriv 5242012
3209226	3813781	idpriv 5242013
3209225	3813781	idpriv 5242014
3209109	3813781	idpriv 5242015
3209224	3813781	idpriv 5242016
3209223	3813781	idpriv 5242017
3514361	3813781	idpriv 5242018
115322	3813781	idpriv 5242019
115323	3813781	idpriv 5242020
115324	3813781	idpriv 5242021
115325	3813781	idpriv 5242022
115326	3813781	idpriv 5242023
115327	3813781	idpriv 5242024
3209015	3813781	idpriv 5242025
3078328	3813781	idpriv 5242026
115328	3813781	idpriv 5242027
3728990	3813781	idpriv 5242028
115329	3813781	idpriv 5242029
115330	3813781	idpriv 5242030
115332	3813781	idpriv 5242031
3078327	3813781	idpriv 5242032
3209143	3813781	idpriv 5242033
3729044	3813781	idpriv 5242034
3729045	3813781	idpriv 5242035
3973025	3813781	idpriv 5242036
6	3813780	idpriv 5242040
3208981	3813780	idpriv 5242041
3208982	3813780	idpriv 5242042
9	3813780	idpriv 5242043
3208980	3813780	idpriv 5242044
3209108	3813780	idpriv 5242045
3209222	3813780	idpriv 5242046
3209221	3813780	idpriv 5242047
3209110	3813780	idpriv 5242048
3209226	3813780	idpriv 5242049
3209225	3813780	idpriv 5242050
3209109	3813780	idpriv 5242051
3209224	3813780	idpriv 5242052
3209223	3813780	idpriv 5242053
3514361	3813780	idpriv 5242054
115322	3813780	idpriv 5242055
115323	3813780	idpriv 5242056
115324	3813780	idpriv 5242057
115325	3813780	idpriv 5242058
115326	3813780	idpriv 5242059
115327	3813780	idpriv 5242060
3209015	3813780	idpriv 5242061
3078328	3813780	idpriv 5242062
115328	3813780	idpriv 5242063
3728990	3813780	idpriv 5242064
115329	3813780	idpriv 5242065
115330	3813780	idpriv 5242066
115332	3813780	idpriv 5242067
3078327	3813780	idpriv 5242068
3209143	3813780	idpriv 5242069
3729044	3813780	idpriv 5242070
3729045	3813780	idpriv 5242071
3973025	3813780	idpriv 5242072
6	3813782	idpriv 5242079
3208981	3813782	idpriv 5242080
3208982	3813782	idpriv 5242081
9	3813782	idpriv 5242082
3208980	3813782	idpriv 5242083
3209108	3813782	idpriv 5242084
3209222	3813782	idpriv 5242085
3209221	3813782	idpriv 5242086
3209110	3813782	idpriv 5242087
3209226	3813782	idpriv 5242088
3209225	3813782	idpriv 5242089
3209109	3813782	idpriv 5242090
3209224	3813782	idpriv 5242091
3209223	3813782	idpriv 5242092
3514361	3813782	idpriv 5242093
115322	3813782	idpriv 5242094
115323	3813782	idpriv 5242095
115324	3813782	idpriv 5242096
115325	3813782	idpriv 5242097
115326	3813782	idpriv 5242098
115327	3813782	idpriv 5242099
3209015	3813782	idpriv 5242100
3078328	3813782	idpriv 5242101
115328	3813782	idpriv 5242102
3728990	3813782	idpriv 5242103
115329	3813782	idpriv 5242104
115330	3813782	idpriv 5242105
115332	3813782	idpriv 5242106
3078327	3813782	idpriv 5242107
3209143	3813782	idpriv 5242108
3729044	3813782	idpriv 5242109
3729045	3813782	idpriv 5242110
3973025	3813782	idpriv 5242111
6	3409849	idpriv 5282255
3208981	3409849	idpriv 5282256
3208982	3409849	idpriv 5282257
9	3409849	idpriv 5282258
3208980	3409849	idpriv 5282259
3209108	3409849	idpriv 5282260
3209222	3409849	idpriv 5282261
3209221	3409849	idpriv 5282262
3209110	3409849	idpriv 5282263
3209226	3409849	idpriv 5282264
3209225	3409849	idpriv 5282265
3209109	3409849	idpriv 5282266
3209224	3409849	idpriv 5282267
3209223	3409849	idpriv 5282268
3514361	3409849	idpriv 5282269
115322	3409849	idpriv 5282270
3209077	3409849	idpriv 5282271
115323	3409849	idpriv 5282272
115324	3409849	idpriv 5282273
115325	3409849	idpriv 5282274
115326	3409849	idpriv 5282275
115327	3409849	idpriv 5282276
3209015	3409849	idpriv 5282277
3078328	3409849	idpriv 5282278
115328	3409849	idpriv 5282279
3728990	3409849	idpriv 5282280
115329	3409849	idpriv 5282281
115330	3409849	idpriv 5282282
115332	3409849	idpriv 5282283
3078327	3409849	idpriv 5282284
3209143	3409849	idpriv 5282285
3729044	3409849	idpriv 5282286
3729045	3409849	idpriv 5282287
3973025	3409849	idpriv 5282288
6	115318	idpriv 5282289
3208981	115318	idpriv 5282290
3208982	115318	idpriv 5282291
115336	115318	idpriv 5282292
9	115318	idpriv 5282293
3208980	115318	idpriv 5282294
3209108	115318	idpriv 5282295
3209222	115318	idpriv 5282296
3209221	115318	idpriv 5282297
3209110	115318	idpriv 5282298
3209226	115318	idpriv 5282299
3209225	115318	idpriv 5282300
3209109	115318	idpriv 5282301
3209224	115318	idpriv 5282302
3209223	115318	idpriv 5282303
115322	115318	idpriv 5282304
115323	115318	idpriv 5282305
115324	115318	idpriv 5282306
115325	115318	idpriv 5282307
115326	115318	idpriv 5282308
115327	115318	idpriv 5282309
3209015	115318	idpriv 5282310
3078328	115318	idpriv 5282311
115328	115318	idpriv 5282312
3728990	115318	idpriv 5282313
115329	115318	idpriv 5282314
115330	115318	idpriv 5282315
115332	115318	idpriv 5282316
3078327	115318	idpriv 5282317
3209143	115318	idpriv 5282318
3729044	115318	idpriv 5282319
3729045	115318	idpriv 5282320
3973025	115318	idpriv 5282321
6	3409847	idpriv 5282322
3208981	3409847	idpriv 5282323
3208982	3409847	idpriv 5282324
9	3409847	idpriv 5282325
3209150	3409847	idpriv 5282326
3209148	3409847	idpriv 5282327
3209149	3409847	idpriv 5282328
3208980	3409847	idpriv 5282329
3209108	3409847	idpriv 5282330
3209222	3409847	idpriv 5282331
3209221	3409847	idpriv 5282332
3209110	3409847	idpriv 5282333
3209226	3409847	idpriv 5282334
3209225	3409847	idpriv 5282335
3209109	3409847	idpriv 5282336
3209224	3409847	idpriv 5282337
3209223	3409847	idpriv 5282338
115322	3409847	idpriv 5282339
115323	3409847	idpriv 5282340
115324	3409847	idpriv 5282341
115325	3409847	idpriv 5282342
115326	3409847	idpriv 5282343
115327	3409847	idpriv 5282344
3209015	3409847	idpriv 5282345
3078328	3409847	idpriv 5282346
115328	3409847	idpriv 5282347
3728990	3409847	idpriv 5282348
115329	3409847	idpriv 5282349
115330	3409847	idpriv 5282350
115332	3409847	idpriv 5282351
3078327	3409847	idpriv 5282352
3209143	3409847	idpriv 5282353
3729044	3409847	idpriv 5282354
3729045	3409847	idpriv 5282355
3973025	3409847	idpriv 5282356
1	3447879	idpriv 5282360
9	3447879	idpriv 5282361
3208980	3447879	idpriv 5282362
3209108	3447879	idpriv 5282363
3209222	3447879	idpriv 5282364
3209221	3447879	idpriv 5282365
3209110	3447879	idpriv 5282366
3209226	3447879	idpriv 5282367
3209225	3447879	idpriv 5282368
3209109	3447879	idpriv 5282369
3209224	3447879	idpriv 5282370
3209223	3447879	idpriv 5282371
3728990	3447879	idpriv 5282372
115329	3447879	idpriv 5282373
115330	3447879	idpriv 5282374
115332	3447879	idpriv 5282375
3078327	3447879	idpriv 5282376
3209144	3447879	idpriv 5282377
3209143	3447879	idpriv 5282378
3729044	3447879	idpriv 5282379
3729045	3447879	idpriv 5282380
3973025	3447879	idpriv 5282381
8	3447879	idpriv 5282382
1	3813778	idpriv 5337875
115333	3813778	idpriv 5337876
115335	3813778	idpriv 5337877
3208983	3813778	idpriv 5337878
3505082	3813778	idpriv 5337879
3505081	3813778	idpriv 5337880
3505083	3813778	idpriv 5337881
3208985	3813778	idpriv 5337882
3208986	3813778	idpriv 5337883
3208987	3813778	idpriv 5337884
6	3813778	idpriv 5337885
3208981	3813778	idpriv 5337886
3208982	3813778	idpriv 5337887
115336	3813778	idpriv 5337888
115338	3813778	idpriv 5337889
9	3813778	idpriv 5337890
3208980	3813778	idpriv 5337891
3209108	3813778	idpriv 5337892
3209222	3813778	idpriv 5337893
3209221	3813778	idpriv 5337894
3209110	3813778	idpriv 5337895
3209226	3813778	idpriv 5337896
3209225	3813778	idpriv 5337897
3209109	3813778	idpriv 5337898
3209224	3813778	idpriv 5337899
3209223	3813778	idpriv 5337900
3514361	3813778	idpriv 5337901
115322	3813778	idpriv 5337902
3209077	3813778	idpriv 5337903
115323	3813778	idpriv 5337904
115324	3813778	idpriv 5337905
115325	3813778	idpriv 5337906
115326	3813778	idpriv 5337907
115327	3813778	idpriv 5337908
3209015	3813778	idpriv 5337909
3078328	3813778	idpriv 5337910
115328	3813778	idpriv 5337911
3728990	3813778	idpriv 5337912
115329	3813778	idpriv 5337913
115330	3813778	idpriv 5337914
115332	3813778	idpriv 5337915
3078327	3813778	idpriv 5337916
3209144	3813778	idpriv 5337917
3209143	3813778	idpriv 5337918
3729044	3813778	idpriv 5337919
3984753	3813778	idpriv 5337920
3729045	3813778	idpriv 5337921
3973025	3813778	idpriv 5337922
8	3813778	idpriv 5337923
5255515	3813778	idpriv 5337924
5255514	3813778	idpriv 5337925
5255516	3813778	idpriv 5337926
5255518	3813778	idpriv 5337927
5263103	3813778	idpriv 5337928
5263104	3813778	idpriv 5337929
1	115317	idpriv 5337930
115333	115317	idpriv 5337931
115335	115317	idpriv 5337932
3208983	115317	idpriv 5337933
3505082	115317	idpriv 5337934
3505081	115317	idpriv 5337935
3505083	115317	idpriv 5337936
3450409	115317	idpriv 5337937
3208985	115317	idpriv 5337938
3208986	115317	idpriv 5337939
3208987	115317	idpriv 5337940
6	115317	idpriv 5337941
3208981	115317	idpriv 5337942
3208982	115317	idpriv 5337943
115336	115317	idpriv 5337944
115337	115317	idpriv 5337945
115338	115317	idpriv 5337946
115339	115317	idpriv 5337947
115340	115317	idpriv 5337948
115321	115317	idpriv 5337949
3208988	115317	idpriv 5337950
9	115317	idpriv 5337951
3208980	115317	idpriv 5337952
3209108	115317	idpriv 5337953
3209222	115317	idpriv 5337954
3209221	115317	idpriv 5337955
3209110	115317	idpriv 5337956
3209226	115317	idpriv 5337957
3209225	115317	idpriv 5337958
3209109	115317	idpriv 5337959
3209224	115317	idpriv 5337960
3209223	115317	idpriv 5337961
3514361	115317	idpriv 5337962
115322	115317	idpriv 5337963
3209077	115317	idpriv 5337964
115323	115317	idpriv 5337965
115324	115317	idpriv 5337966
115325	115317	idpriv 5337967
115326	115317	idpriv 5337968
115327	115317	idpriv 5337969
3209015	115317	idpriv 5337970
3078328	115317	idpriv 5337971
115328	115317	idpriv 5337972
3728990	115317	idpriv 5337973
115329	115317	idpriv 5337974
115330	115317	idpriv 5337975
115332	115317	idpriv 5337976
3078327	115317	idpriv 5337977
3209144	115317	idpriv 5337978
3209143	115317	idpriv 5337979
4427098	115317	idpriv 5337980
115320	115317	idpriv 5337981
3729044	115317	idpriv 5337982
3984753	115317	idpriv 5337983
3729045	115317	idpriv 5337984
3973025	115317	idpriv 5337985
8	5361134	idpriv 5361795
5255515	5361134	idpriv 5361796
5255514	5361134	idpriv 5361797
5255516	5361134	idpriv 5361798
5255518	5361134	idpriv 5361799
5263103	5361134	idpriv 5361800
5338061	5361134	idpriv 5361801
5263104	5361134	idpriv 5361802
5255517	5361134	idpriv 5361803
9	5385955	idpriv 5385962
115322	5385955	idpriv 5385963
115323	5385955	idpriv 5385964
115324	5385955	idpriv 5385965
115325	5385955	idpriv 5385966
115326	5385955	idpriv 5385967
115327	5385955	idpriv 5385968
3209015	5385955	idpriv 5385969
3078328	5385955	idpriv 5385970
115328	5385955	idpriv 5385971
3728990	5385955	idpriv 5385972
115329	5385955	idpriv 5385973
115330	5385955	idpriv 5385974
115332	5385955	idpriv 5385975
3078327	5385955	idpriv 5385976
3209144	5385955	idpriv 5385977
3209143	5385955	idpriv 5385978
4427098	5385955	idpriv 5385979
3729044	5385955	idpriv 5385980
3984753	5385955	idpriv 5385981
3729045	5385955	idpriv 5385982
3973025	5385955	idpriv 5385983
6002786	6002809	idpriv 6002813
6002788	6002809	idpriv 6002814
6002786	6002810	idpriv 6002815
6002788	6002810	idpriv 6002816
6002786	6002811	idpriv 6002817
6002788	6002811	idpriv 6002818
6002786	6002812	idpriv 6002819
6002788	6002812	idpriv 6002820
6002786	6002821	idpriv 6002822
6002788	6002821	idpriv 6002823
6000022	5255700	idpriv 6003103
6002827	5255700	idpriv 6003104
6002828	5255700	idpriv 6003105
6002864	5255700	idpriv 6003106
6002923	5255700	idpriv 6003107
6002945	5255700	idpriv 6003108
6002946	5255700	idpriv 6003109
6002947	5255700	idpriv 6003110
6002948	5255700	idpriv 6003111
6003025	5255700	idpriv 6003112
6002824	3450408	idpriv 6002974
6002825	3450408	idpriv 6002975
6002901	3450408	idpriv 6002976
6002827	3450408	idpriv 6002977
6002923	3450408	idpriv 6002978
6002945	3450408	idpriv 6002979
6002946	3450408	idpriv 6002980
6002947	3450408	idpriv 6002981
6002948	3450408	idpriv 6002982
\.


--
-- Name: project; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('project', 11, true);


--
-- Data for Name: rev_user; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY rev_user (user_id, username, password, nama, active, groupid, usernameldap, email) FROM stdin;
1	admin	admin1234	Administrator	Y	115317	admin	\N
2	fajar.permana	david	Fajar Permana	Y	6002811	fajar.permana	
3	AA.Bagus.Putra	david	A. A. Bagus Putra	Y	6002810	AA.Bagus.Putra	\N
4	Achmad.Hidayat	david	Achmad Hidayat	Y	\N	Achmad.Hidayat	\N
5	Ade.Iqbal	david	Moh Ade Iqbal	Y	3409847	Ade.Iqbal	
6	Ade.Rusmana	david	Ade Rusmana	Y	\N	Ade.Rusmana	\N
7	Adi.Saputra	david	Adi Saputra	Y	\N	Adi.Saputra	\N
8	Adil.Anwar	david	Adil Wahyudin Anwar	Y	\N	Adil.Anwar	\N
9	Aditya.Eka	david	Aditya Eka Wijaya	Y	\N	Aditya.Eka	\N
10	Agoeng.Noegroho	david	Agoeng Pratomo Noegroho	Y	\N	Agoeng.Noegroho	\N
11	Agung.Kurniansyah	david	Agung Kurniansyah	Y	\N	Agung.Kurniansyah	\N
12	Agus.Hartadi	david	Agus Hartadi	Y	\N	Agus.Hartadi	\N
13	Agus.Mufriadi	david	Agus Mufriadi	Y	\N	Agus.Mufriadi	\N
14	Agus.Riyanto	david	Agus Riyanto	Y	\N	Agus.Riyanto	\N
15	Ahmadtama.Fauzi	david	Ahmadtama Zamirudin Fauzi	Y	\N	Ahmadtama.Fauzi	\N
16	Aji.Darmawan	david	Aji Darmawan	Y	3409849	Aji.Darmawan	Aji.Darmawan@pgn.co.id
17	Aji.Purbomiluhu	david	Aji Tunggul Purbomiluhung	Y	\N	Aji.Purbomiluhu	\N
18	Akmaluddin	david	Akmaluddin	Y	\N	Akmaluddin	\N
19	Alhan.Rustiyana	david	Alhan Rustiyana	Y	\N	Alhan.Rustiyana	\N
20	Alwi.Huda	david	M. Alwi Huda	Y	\N	Alwi.Huda	\N
21	Am.Dimas	david	Am Dimas Prio Anggodo	Y	\N	Am.Dimas	\N
22	Anang.Kustanto	david	Anang Kustanto	Y	\N	Anang.Kustanto	\N
23	Anang.Susanto	david	Anang Susanto	Y	\N	Anang.Susanto	\N
24	andi.irawan	david	M. Andi Irawan	Y	\N	andi.irawan	\N
25	Andriansyah.Ginting	david	Andriansyah Ginting	Y	\N	Andriansyah.Ginting	\N
26	Annis.Sofia	david	Annis Sofia	Y	3447879	Annis.Sofia	Annis.Sofia@pgn.co.id
27	Arief.Dharmawan	david	Arief Mochamad Dharmawan	Y	\N	Arief.Dharmawan	\N
28	Arief.Mujiyanto	david	Arief Mujiyanto	Y	3813778	Arief.Mujiyanto	Arief.Mujiyanto@pgn.co.id
29	ariel.pasaribu	david	Ariel Sharon Pasaribu	Y	\N	ariel.pasaribu	\N
30	armand.wijaya	david	Armand Adhe Wijaya	Y	\N	armand.wijaya	\N
31	Armynas.Handyas	david	Armynas Handyas Wijayatma	Y	\N	Armynas.Handyas	\N
32	Asep.Bahri	david	Asep Bahri	Y	\N	Asep.Bahri	\N
33	Atang.Sudjani	david	Atang Sudjani	Y	\N	Atang.Sudjani	\N
34	Aulia.Kusumadewi	david	Aulia Nur'aini Kusumadewi	Y	\N	Aulia.Kusumadewi	\N
35	Azwar.Oktaviansyah	david	Azwar Oktaviansyah	Y	\N	Azwar.Oktaviansyah	\N
36	Azwardi	david	Azwardi	Y	\N	Azwardi	\N
37	Bambang.Purwanto	david	Bambang Purwanto	Y	\N	Bambang.Purwanto	\N
38	Baried.Nurcahyo	david	Baried Nurcahyo	Y	3409847	Baried.Nurcahyo	Baried.Nurcahyo@pgn.co.id
39	Barlian.Utomo	david	Barlian Kahuripan Utomo	Y	\N	Barlian.Utomo	\N
40	Bima.Agung	david	Bima Satria Agung	Y	3409847	Bima.Agung	Bima.Agung@pgn.co.id
41	Bimo.Amboro	david	Soesatyo Bimo Tri Amboro	Y	\N	Bimo.Amboro	\N
42	Boby.Susilo	david	Boby Susilo	Y	\N	Boby.Susilo	\N
43	Bondan.Christiandi	david	Bondan Christiandinata	Y	\N	Bondan.Christiandi	\N
44	Boyke.Tobing	david	Boyke Tobing	Y	\N	Boyke.Tobing	\N
45	Budi.Sinaga	david	Budi Junias Sinaga	Y	3447880	Budi.Sinaga	
46	Cecep.Prawira	david	Cecep Harry Prawira	Y	\N	Cecep.Prawira	\N
47	Chandra.Silaban	david	Chandra Nur Silaban	Y	\N	Chandra.Silaban	\N
48	Citra.Pranandar	david	Citra Pranandar	Y	\N	Citra.Pranandar	\N
49	Dalrusidi	david	Dalrusidi	Y	\N	Dalrusidi	\N
50	Damar.Riyanti	david	Damar Riyanti	Y	\N	Damar.Riyanti	\N
51	dani.permana	david	Dani Arief Permana	Y	\N	dani.permana	\N
52	David.Saputra	david	David Ade Saputra	Y	\N	David.Saputra	\N
53	dea.amelia	david	Dea Amelia	Y	\N	dea.amelia	\N
54	Dedi.Irawan	david	Dedi Irawan	Y	\N	Dedi.Irawan	\N
55	Dedy.Wibowo	david	Dedy Wibowo	Y	\N	Dedy.Wibowo	\N
56	Dian.Heryanti H	david	Dian Heryanti Handayani	Y	3409849	Dian.HeryantiH	Dian.HeryantiH@pgn.co.id
57	Didiet.Pradityo	david	Didiet Pradityo	Y	\N	Didiet.Pradityo	\N
58	Dimas.Dito	david	Dimas Dito	Y	\N	Dimas.Dito	\N
59	Dini.Mentari	david	Dini Mentari	Y	\N	Dini.Mentari	\N
60	Dirush	david	Dirush	Y	\N	Dirush	\N
61	Djanurianto	david	Djanurianto	Y	6002821	Djanurianto	\N
62	Dwi.Sandhi	david	Dwi Handoko Sandhi	Y	\N	Dwi.Sandhi	\N
63	Dwi.Subiyantoro	david	Moch Dwi Subiyantoro	Y	\N	Dwi.Subiyantoro	\N
64	Edi.Armawiria	david	Edi Armawiria	Y	\N	Edi.Armawiria	\N
65	Eka.Subandriani	david	Eka Subandriani	Y	\N	Eka.Subandriani	\N
66	Elvan.Achmadi	david	Elvan Achmadi	Y	\N	Elvan.Achmadi	\N
67	Emi.Hermanto	david	Emi Heru Hermanto	Y	\N	Emi.Hermanto	\N
68	Erwan.Mukhtar	david	Erwan Omar Mukhtar	Y	115318	Erwan.Mukhtar	Erwan.Mukhtar@pgn.co.i
69	Erwin.Gitarisyana	david	Erwin Gitarisyana	Y	\N	Erwin.Gitarisyana	\N
70	Etanto.Widjayanto	david	Etanto Widjayanto	Y	\N	Etanto.Widjayanto	\N
71	Eva.Daulay	david	Eva Marito Daulay	Y	\N	Eva.Daulay	\N
72	Fajar.Sidiq	david	Fajar Muhammad Sidiq	Y	\N	Fajar.Sidiq	\N
73	Fariz.Khoirudin	david	Mochammad Fariz Khoirudin	Y	\N	Fariz.Khoirudin	\N
74	Farkhan.Rizaputra	david	M. Farkhan Rizaputra	Y	\N	Farkhan.Rizaputra	\N
75	Fatah.Yasin	david	M Fatah Yasin	Y	\N	Fatah.Yasin	\N
76	Febrian.Ardiwinata	david	Febrian Nur Ardiwinata	Y	3409847	Febrian.Ardiwinata	Febrian.Ardiwinata@pgn.co.id
77	Febrian.Putra	david	Muhammad Febrian Dwi Utama Putra	Y	5385955	Febrian.Putra	
78	Ferman.Hakiki	david	Ferman  Hakiki	Y	\N	Ferman.Hakiki	\N
79	Ferry.Nurjaman	david	Ferry Ahmad Nurjaman	Y	\N	Ferry.Nurjaman	\N
80	Fikrie.Harahap	david	Fikrie Achriady Harahap	Y	\N	Fikrie.Harahap	\N
81	Fourikha.Budi	david	Fourikha Budi Sulistyo	Y	3409847	Fourikha.Budi	Fourikha.Budi@pgn.co.id
82	Fuad.Hamzah	david		Y	115318	Fuad.Hamzah	Fuad.Hamzah@pgn.co.id
83	Fuad.Hasan	david	Fuad Hasan	Y	\N	Fuad.Hasan	\N
84	Furqanul.Fikri	david	Furqanul Fikri	Y	\N	Furqanul.Fikri	\N
85	Gas.Control.TSJ	david	Gas Control TSJ	Y	\N	Gas.Control.TSJ	\N
86	Gayuh.Wulandari	david	Gayuh Wulandari	Y	115318	Gayuh.Wulandari	Gayuh.Wulandari@pgn.co.id
87	GMS	david	GMS	Y	\N	GMS	\N
88	Hapiz.Maulana	david	Hapiz Maulana	Y	\N	Hapiz.Maulana	\N
89	Hari.Aribowo	david	Hari Satria Aribowo	Y	3447879	Hari.Aribowo	Hari.Aribowo@pgn.co.id
90	Haris.Budiman	david	Haris Budiman	Y	115318	Haris.Budiman	Haris.Budiman@pgn.co.id
91	Harry.Tafly	david	Tengku Mhd. Harry Rizky Tafly	Y	\N	Harry.Tafly	\N
92	Haryo.Pramantyo	david	M. Haryo Pramantyo	Y	\N	Haryo.Pramantyo	\N
93	Havid.Noviastanto	david	Havid Noviastanto Wahyudi	Y	\N	Havid.Noviastanto	\N
94	Hendra.Saputra	david	Hendra Saputra Dunggio	Y	\N	Hendra.Saputra	\N
95	Hendro.Waskito	david	Hendro Waskito	Y	\N	Hendro.Waskito	\N
96	Hendry.Sumasaputra	david	Hendry Pramudipta Sumasaputra	Y	\N	Hendry.Sumasaputra	\N
97	Henry.Gunawan	david	Henry Gunawan	Y	\N	Henry.Gunawan	\N
98	Heny.Purwati	david	Heny Purwati	Y	\N	Heny.Purwati	\N
99	Herdi.Qoharrudin	david	Herdi Qoharrudin	Y	\N	Herdi.Qoharrudin	\N
100	Herlenika	david	Herlenika	Y	\N	Herlenika	\N
101	Herman.Hartanto	david	Herman Hartanto	Y	\N	Herman.Hartanto	\N
102	Hernita.Setyani	david	Hernita Pratiwi Setyani	Y	\N	Hernita.Setyani	\N
103	Herry.Rachmadi	david	Herry Rachmadi	Y	\N	Herry.Rachmadi	\N
104	Herry.Yusuf	david	Herry Yusuf	Y	3447880	Herry.Yusuf	Herry.Yusuf@pgn.co.id
105	Heru.Widodo	david	Heru Widodo	Y	\N	Heru.Widodo	\N
106	Hilmi.Fikri	david	Hilmi Fikri	Y	\N	Hilmi.Fikri	\N
107	Houstina.Anggraini	david	Houstina  Dewi Anggraini	Y	\N	Houstina.Anggraini	\N
108	Ibnu.Azka	david	Ibnu Azka	Y	\N	Ibnu.Azka	\N
109	Ida.Dewi	david	Ida Fortuna Dewi	Y	\N	Ida.Dewi	\N
110	Igung.Hermanu	david	Igung Aris Hermanu	Y	\N	Igung.Hermanu	\N
111	Iis.Ismail	david	Iis Ismail	Y	\N	Iis.Ismail	\N
112	Ikhsan.Aditya	david	Ikhsan Aditya	Y	\N	Ikhsan.Aditya	\N
113	Ilham.Luthfi	david	Ilham Luthfi Nasution	Y	\N	Ilham.Luthfi	\N
114	imam.supriyadi	david	Imam Supriyadi	Y	\N	imam.supriyadi	\N
115	Imron	david	Imron	Y	\N	Imron	\N
116	Indra.Praditya	david	Indra Praditya	Y	\N	Indra.Praditya	\N
117	Intan.Nurdiyanti	david	Intan Nurdiyanti	Y	\N	Intan.Nurdiyanti	\N
118	Irvan.Tobing	david	Irvan Panusunan Tobing	Y	\N	Irvan.Tobing	\N
119	Jauhar.Gama	david	Jauhar Gama Kurniawan	Y	\N	Jauhar.Gama	\N
120	Jauhari.Wicaksono	david	Jauhari Wicaksono	Y	\N	Jauhari.Wicaksono	\N
121	Johannes.Manurung	david	Johannes Manurung	Y	\N	Johannes.Manurung	\N
122	joice.juliana	david	Joice Juliana	Y	\N	joice.juliana	\N
123	Joko.Prasetyo	david	Joko Prasetyo	Y	\N	Joko.Prasetyo	\N
124	Kemas.Azhari	david	Kemas H. Azhari	Y	\N	Kemas.Azhari	\N
125	Kokoh.Parlindungan	david	Kokoh Parlindungan	Y	\N	Kokoh.Parlindungan	\N
126	Kristo.Kanaprio	david	Kristophorus Kanaprio Ola	Y	\N	Kristo.Kanaprio	\N
127	Kukuh.Bayu	david	Kukuh Bayu Prasetyo	Y	\N	Kukuh.Bayu	\N
128	Kurnia.Permasari	david	Kurnia Permasari	Y	\N	Kurnia.Permasari	\N
129	kusnasriawan.nugroho	david	Kusnasriawan Nugroho Santoso	Y	\N	kusnasriawan.nugroho	\N
130	Lala.Kumalawati	david	Lala Kumalawati	Y	\N	Lala.Kumalawati	\N
131	Lebinner.Sinaga	david	Lebinner Sinaga	Y	\N	Lebinner.Sinaga	\N
132	Lolah.Wiarsih	david	Lolah Wiarsih	Y	\N	Lolah.Wiarsih	\N
133	Luthfianto.Nugroho	david	Luthfianto Ardhi Nugroho	Y	\N	Luthfianto.Nugroho	\N
134	M.Waspin	david	M. Waspin	Y	\N	M.Waspin	\N
135	Maftukhin	david	Maftukhin	Y	\N	Maftukhin	\N
136	Magresa.Hendariawan	david	Magresa Hendariawan	Y	115318	Magresa.Hendariawan	Magresa.Hendariawan@pgn.co.id
137	Mahda.Andyka	david	Mahda Mega Andyka Hieguyta	Y	\N	Mahda.Andyka	\N
138	Makmuri	david	Makmuri	Y	\N	Makmuri	\N
139	Marchia.Legansi	david	Marchia Devi Aryatni Legansi	Y	\N	Marchia.Legansi	\N
140	Margiyanto	david	Margiyanto	Y	\N	Margiyanto	\N
141	Marlon.Riolan	david	Marlon Riolan	Y	\N	Marlon.Riolan	\N
142	Mhd.Maulana	david	Mhd. Ilham Maulana	Y	\N	Mhd.Maulana	\N
143	Michael.Edigia	david	Michael Edigia Wizard	Y	\N	Michael.Edigia	\N
144	Mikha.Asido	david	Mikha Marulitua Asido	Y	\N	Mikha.Asido	\N
145	Mira.Yusmita	david	Mira Yusmita	Y	\N	Mira.Yusmita	\N
146	Muhamad.Alifikri	david	Muhamad Ali Fikri	Y	\N	Muhamad.Alifikri	\N
147	Muhammad.Arifin	david	Muhammad Syaiful Arifin	Y	\N	Muhammad.Arifin	\N
148	Muhammad.Samhan	david	Muhammad Samhan	Y	3447880	Muhammad.Samhan	Muhammad.Samhan@gmail.co.id
149	Muhammad.Sanny	david	Muhammad Rusdy Sanny	Y	115318	Muhammad.Sanny	Muhammad.Sanny@pgn.co.id
150	Ninoy.Harahap	david	Ninoy Renato Harahap	Y	\N	Ninoy.Harahap	\N
151	Nismawati	david	Nismawati	Y	\N	Nismawati	\N
152	Noviyani	david	Noviyani	Y	\N	Noviyani	\N
153	Nur.Saidah	david	Nur Saidah	Y	\N	Nur.Saidah	\N
154	Nur.Yainatun	david	Nur Yainatun	Y	\N	Nur.Yainatun	\N
155	Nurdiansyah	david	Nurdiansyah	Y	\N	Nurdiansyah	\N
156	Nurhadi.Sujatmoko	david	Nurhadi Sujatmoko	Y	\N	Nurhadi.Sujatmoko	\N
157	Okky.Arganata	david	Okky Putra Arganata	Y	\N	Okky.Arganata	\N
158	Oktavianus.Ragawino	david	Oktavianus Ragawino	Y	\N	Oktavianus.Ragawino	\N
159	Pandu.Pradana	david	Pandu Pradana	Y	3447879	Pandu.Pradana	Pandu.Pradana@pgn.co.id
160	Panondang.Pernando	david	Panondang Pernando	Y	\N	Panondang.Pernando	\N
161	Patricia.Sakti	david	Patricia Dwi Putri Panca Sakti	Y	\N	Patricia.Sakti	\N
162	Pharamayuda.Wicakson	david	Pharamayuda Bayu Wicaksono	Y	\N	Pharamayuda.Wicakson	\N
163	Pravira.Notodisurjo	david	Pravira Sisyawan Notodisurjo	Y	\N	Pravira.Notodisurjo	\N
164	Pri.Endi	david	Pri Endi Ariawan	Y	3447880	Pri.Endi	Pri.Endi@pgn.co.id
165	Punky.Khoirrudin	david	M. Punky Khoirrudin	Y	\N	Punky.Khoirrudin	\N
166	Purwanto	david	Purwanto	Y	\N	Purwanto	\N
167	R.Brian.Dwiputranto	david	R. Brian Dwiputranto	Y	\N	R.Brian.Dwiputranto	\N
168	Rahmat.Muttaqin	david	Rahmat Akbar Muttaqin	Y	\N	Rahmat.Muttaqin	\N
169	Rahmat.Ranudigdo	david	Rahmat Ranudigdo	Y	\N	Rahmat.Ranudigdo	\N
170	Rangga.Radji	david	Rangga Radji	Y	\N	Rangga.Radji	\N
171	Ratna.Suminar	david	Ratna Dian Suminar	Y	3409847	Ratna.Suminar	Ratna.Suminar@pgn.co.id
172	Reza.Trisulistiawan	david	Reza Trisulistiawan	Y	\N	Reza.Trisulistiawan	\N
173	Ridian.Junata	david	Ridian Junata	Y	\N	Ridian.Junata	\N
174	Rommel.Manurung	david	Rommel Manurung	Y	\N	Rommel.Manurung	\N
175	Rony.Raharjo	david	Rony Prastyo Raharjo	Y	\N	Rony.Raharjo	\N
176	Rozani.Ismail	david	Rozani Ismail	Y	\N	Rozani.Ismail	\N
177	Ruli.Yusman	david	Ruli Yusman	Y	\N	Ruli.Yusman	\N
178	Rumwinarni	david	Rumwinarni	Y	\N	Rumwinarni	\N
179	Rusliman	david	Rusliman	Y	\N	Rusliman	\N
180	Rusnamiyati	david	Rusnamiyati	Y	\N	Rusnamiyati	\N
181	Sabda.Oing	david	Sabda Oing	Y	\N	Sabda.Oing	\N
182	Saefudin	david	Saefudin	Y	\N	Saefudin	\N
183	Said.Amdi	david	M. Said Setya Amdi	Y	\N	Said.Amdi	\N
184	Sari.Handayani	david	Sari Handayani	Y	\N	Sari.Handayani	\N
185	Sarnido	david	Sarnido	Y	\N	Sarnido	\N
186	Satori	david	Satori	Y	\N	Satori	\N
187	Septiaji.Salam	david	Septiaji Muhammad Ibnu Salam	Y	\N	Septiaji.Salam	\N
188	Sheila.Merlianty	david	Sheila Merlianty	Y	\N	Sheila.Merlianty	\N
189	Silfan.Anta	david		Y	3409849	Silfan.Anta	Silfan.Anta@pgn.co.id
190	Sonny.Abdi	david	Sonny Rahmawan Abdi	Y	\N	Sonny.Abdi	\N
191	Sony.Achmad	david	Sony Achmad	Y	\N	Sony.Achmad	\N
192	Subhan.Missuari	david	Muhammad Subhan Missuari	Y	\N	Subhan.Missuari	\N
193	Suharmat	david	Suharmat	Y	\N	Suharmat	\N
194	Sukiswanto	david		Y	3409847	Sukiswanto	Sukiswanto@pgn.co.id
195	Sulchan.Fadholi	david	Sulchan Fadholi	Y	\N	Sulchan.Fadholi	\N
196	Sunardi.1759	david	Sunardi.1759	Y	\N	Sunardi.1759	\N
197	Sutiah	david	Sutiah	Y	\N	Sutiah	\N
198	Syah.Pranayoga	david	Syah Dears Kinanthi Pranayoga	Y	3409849	Syah.Pranayoga	Syah.Pranayoga@pgn.co.id
199	Syahputra	david	Syahputra	Y	\N	Syahputra	\N
200	Syaifan.Fauzi	david	Syaifan Fauzi Nasution	Y	\N	Syaifan.Fauzi	\N
201	syukron.arisona	david	Syukron Arisona	Y	\N	syukron.arisona	\N
202	Taufik.Rahmat	david	Taufik Rahmat	Y	\N	Taufik.Rahmat	\N
203	Tegar.Nugraha	david	Tegar Kharisma Nugraha	Y	\N	Tegar.Nugraha	\N
204	Tia.Restyani	david	Tia Restyani	Y	\N	Tia.Restyani	\N
205	Tika.Iswardhani	david	Tika Rianna Iswardhani	Y	115318	Tika.Iswardhani	Tika.Iswardhani@pgn.co.id
206	Timbul.Aritonang	david	Timbul Aritonang	Y	\N	Timbul.Aritonang	\N
207	Tri.Hartanti	david	Tri Hartanti	Y	\N	Tri.Hartanti	\N
208	Tunggul.Wijayasakti	david	Tunggul  Wijayasakti	Y	\N	Tunggul.Wijayasakti	\N
209	Udi.Setiono	david	Udi Setiono	Y	\N	Udi.Setiono	\N
210	Victor.Leonardo	david	Viktor Leonardo Siahaan	Y	\N	Victor.Leonardo	\N
211	Wahyu.Reza	david	Wahyu Reza Prahara	Y	\N	Wahyu.Reza	\N
212	Wahyu.Wibowo	david	Wahyu  Dwi Agasta Wibowo	Y	\N	Wahyu.Wibowo	\N
213	Windi.Santoso	david	Windi Santoso	Y	\N	Windi.Santoso	\N
214	Yandi.Azhari	david	Yandi Azhari	Y	\N	Yandi.Azhari	\N
215	Yanto.Kusdamayanto	david	Yanto Kusdamayanto	Y	\N	Yanto.Kusdamayanto	\N
216	Yanto2	david	Yanto	Y	\N	Yanto2	\N
217	Yasir.Arafat	david	Yasir Arafat	Y	\N	Yasir.Arafat	\N
218	Yogi.Alex	david	Yogi Alex Prabowo	Y	\N	Yogi.Alex	\N
219	Yohanes.Chandra	david	Yohanes Chandra	Y	\N	Yohanes.Chandra	\N
220	Yosviandri	david	Yosviandri	Y	\N	Yosviandri	\N
221	Yudi.Ariyanto	david	Yudi Ariyanto	Y	\N	Yudi.Ariyanto	\N
222	Yusep.Mandani	david	Yusep Mandani	Y	\N	Yusep.Mandani	\N
223	Yusuf.Ramadhani	david	Yusuf Ramadhani	Y	\N	Yusuf.Ramadhani	\N
224	zaini.dahlan	david	M. Zaini Dahlan	Y	\N	zaini.dahlan	\N
225	Zanuar.Kriswanto	david	Zanuar  Kriswanto	Y	3409847	Zanuar.Kriswanto	
226	zulfikar.imran	david	Zulfikar Ali Imran	Y	\N	zulfikar.imran	\N
227	zulkarnaen.2633	david	Zulkarnaen	Y	\N	zulkarnaen.2633	\N
228	Asep.Saepulah	david	Asep Saepulah	Y	115317	Asep.Saepulah	
229	Dila.Damayanti	david	Dila Damayanti	Y	3813778	Dila.Damayanti	Dila.Damayanti@pgn.co.id
230	sekdiv1	david	admin	Y	3447880	sEkDiv1	sekdiv1@pgn.co.id
235	Dian.HeryantiH	david	Dian Heryanti Handayani	Y	3409849	Dian.HeryantiH	Dian.HeryantiH@pgn.co.id
236	dayman.em	david	dayman	N	3450408		dayman@gmail.com
237	Dwi.Wahyuni	david	Dwi Wahyuni	Y	3813780	Dwi.Wahyuni	Dwi.Wahyuni@pgn.co.id
238	Candra.Febrianita	david		Y	3813779	Candra.Febrianita	Candra.Febrianita@pgn.co.id
239	Haris.Fadhilah	david	Haris Fadhilah	Y	3813781	Haris.Fadhilah	Haris.Fadhilah@pgn.co.id
240	Fachan.Jadiyasmita	david	Fachan Jadiyasmita	Y	3813782	Fachan.Jadiyasmita	Fachan.Jadiyasmita@pgn.co.id
241	erwan.mukhtar	david		Y	115318	erwan.mukhtar	erwan.mukhtar@pgn.co.id
242	marchia.legansi	\N		Y	3717178	marchia.legansi	marchia.legansi@pgn.co.id
243	Emban.Triyana	david	Emban Triyana	Y	3813782	emban.triyana	emban.triyana@pgn.co.id
244	Luluk.Noorratri	david	Luluk Noorratri	Y	3813779	Luluk.Noorratri	Luluk.Noorratri@pgn.co.id
245	budi.sinaga	\N		Y	3447880	Budi.Sinaga	Budi.Sinaga@pgn.co.id
246	edi.purnomo	\N		Y	5045262	edi.purnomo	edi.purnomo@pgn.co.id
247	Moh.ali	moh.ali	Moh Ali	Y	115317	moh.ali	Moh.Ali@pgn.co.id
248	developer	develop1234	developer	Y	5255700	developer	develop@pgascom.co.iid
249	dev2	david		Y	5361134	dev2	
250	febrian.putra	\N		Y	5385955	febrian.putra	febrian.putra@pgn.co.id
\.


--
-- Name: rev_user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('rev_user_user_id_seq', 250, true);


--
-- Data for Name: role_group; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY role_group (role_menu_id, menu_id, group_id, is_active) FROM stdin;
115319	115316	115317	Y 
115319	115316	115317	Y 
\.


--
-- Data for Name: role_menu_event; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY role_menu_event (role_menu_event_id, menu_id, group_id, is_active, rowid) FROM stdin;
115357	115324	3447880	Y	3527401
115358	115324	3447880	Y	3527402
115359	115324	3447880	Y	3527403
115357	115324	3409849	Y	3527404
115358	115324	3409849	Y	3527405
115359	115324	3409849	Y	3527406
115357	115324	115318	Y	3527407
115359	115324	115318	Y	3527408
115358	115324	115318	Y	3527409
115357	115324	3409847	Y	3527410
115358	115324	3409847	Y	3527411
115359	115324	3409847	Y	3527412
115357	115324	3447879	Y	3527413
115358	115324	3447879	Y	3527414
115359	115324	3447879	Y	3527415
3504394	3078328	3447879	Y	3527420
3504395	3078328	3447879	Y	3527421
115357	115324	115317	Y	3534107
115359	115324	115317	Y	3534108
115358	115324	115317	Y	3534109
3504394	3078328	115317	Y	3535686
3531463	3078328	115317	Y	3535687
3504395	3078328	115317	Y	3535688
3504395	3078328	3447880	Y	3539708
3504394	3078328	3447880	Y	3539709
3531463	3078328	3447880	Y	3539710
3504394	3078328	3409847	Y	3539759
3531463	3078328	3409847	Y	3539760
3504395	3078328	3409847	Y	3539761
3504394	3078328	115318	Y	3670836
3504395	3078328	115318	Y	3670837
3531463	3078328	115318	Y	3670838
3504395	3078328	3409849	Y	3678393
3504394	3078328	3409849	Y	3678394
3531463	3078328	3409849	Y	3678395
115356	115323	3409849	Y	3806623
115356	115323	3447880	Y	3806630
3504393	115323	3447879	Y	3806647
115356	115323	3447879	Y	3806648
115363	115326	3447879	Y	3806649
115364	115326	3447879	Y	3806650
115365	115326	3447879	Y	3806651
3571968	115327	3447879	Y	3806652
3571969	115327	3447879	Y	3806653
3571970	115327	3447879	Y	3806654
115356	115323	3717178	Y	3806669
115356	115323	115317	Y	3812815
3504393	115323	115317	Y	3812816
115363	115326	115317	Y	3812825
115364	115326	115317	Y	3812826
115366	115326	115317	Y	3812827
115365	115326	115317	Y	3812828
115363	115326	3717178	Y	3812886
115364	115326	3717178	Y	3812887
115365	115326	3717178	Y	3812888
3571969	115327	3717178	Y	3812889
3571968	115327	3717178	Y	3812890
3571970	115327	3717178	Y	3812891
115363	115326	3447880	Y	3812892
115364	115326	3447880	Y	3812893
115365	115326	3447880	Y	3812894
3571968	115327	3447880	Y	3812895
3571969	115327	3447880	Y	3812896
3571970	115327	3447880	Y	3812897
115363	115326	3409849	Y	3812898
115364	115326	3409849	Y	3812899
115365	115326	3409849	Y	3812900
3571968	115327	3409849	Y	3812901
3571969	115327	3409849	Y	3812902
3571970	115327	3409849	Y	3812903
115357	115324	3813778	Y	3816002
115358	115324	3813778	Y	3816003
115359	115324	3813778	Y	3816004
115363	115326	3813778	Y	3816008
115364	115326	3813778	Y	3816009
115366	115326	3813778	Y	3816010
115365	115326	3813778	Y	3816011
3571968	115327	3813778	Y	3816012
3571969	115327	3813778	Y	3816013
3571970	115327	3813778	Y	3816014
3583968	115327	3813778	Y	3816015
3504394	3078328	3813778	Y	3816016
3504395	3078328	3813778	Y	3816017
3531463	3078328	3813778	Y	3816018
115363	115326	115318	Y	3820418
115364	115326	115318	Y	3820419
115365	115326	115318	Y	3820420
3571968	115327	115318	Y	3820425
3571969	115327	115318	Y	3820426
3571970	115327	115318	Y	3820427
115356	115323	115318	Y	3820429
115356	115323	3450408	Y	3821401
3504393	115323	3450408	Y	3821402
115357	115324	3450408	Y	3821403
115358	115324	3450408	Y	3821404
115359	115324	3450408	Y	3821405
115360	115325	115317	Y	3821504
115361	115325	115317	Y	3821505
115362	115325	115317	Y	3821506
3821495	115325	115317	Y	3821507
115357	115324	3813782	Y	3821916
115358	115324	3813782	Y	3821917
115359	115324	3813782	Y	3821918
115363	115326	3813782	Y	3821931
115364	115326	3813782	Y	3821932
115366	115326	3813782	Y	3821933
115365	115326	3813782	Y	3821934
3571968	115327	3813782	Y	3821939
3571969	115327	3813782	Y	3821940
3571970	115327	3813782	Y	3821941
3583968	115327	3813782	Y	3821942
3504394	3078328	3813782	Y	3821949
3504395	3078328	3813782	Y	3821950
3531463	3078328	3813782	Y	3821951
3505957	115330	3813782	Y	3821959
3505958	115330	3813782	Y	3821960
3505959	115330	3813782	Y	3821961
3505960	115330	3813782	Y	3821962
3505961	115330	3813782	Y	3821963
3505962	115330	3813782	Y	3821964
3505963	115330	3813782	Y	3821965
115356	115323	3813780	Y	3822130
3504393	115323	3813780	Y	3822131
115356	115323	3813779	Y	3822164
3504393	115323	3813779	Y	3822165
115356	115323	3813778	Y	3822166
3504393	115323	3813778	Y	3822167
115356	115323	3813781	Y	3822620
3504393	115323	3813781	Y	3822621
115357	115324	3813781	Y	3822622
115358	115324	3813781	Y	3822623
115359	115324	3813781	Y	3822624
115363	115326	3813781	Y	3822629
115364	115326	3813781	Y	3822630
115366	115326	3813781	Y	3822631
115365	115326	3813781	Y	3822632
3571968	115327	3813781	Y	3822633
3571970	115327	3813781	Y	3822634
3583968	115327	3813781	Y	3822635
3571969	115327	3813781	Y	3822636
3504395	3078328	3813781	Y	3822643
3504394	3078328	3813781	Y	3822644
3531463	3078328	3813781	Y	3822645
3505959	115330	3813781	Y	3822653
3505957	115330	3813781	Y	3822654
3505961	115330	3813781	Y	3822655
3505958	115330	3813781	Y	3822656
3505960	115330	3813781	Y	3822657
3505963	115330	3813781	Y	3822658
3505962	115330	3813781	Y	3822659
115356	115323	3813782	Y	3822692
3504393	115323	3813782	Y	3822693
115360	115325	3447880	Y	3822724
115361	115325	3447880	Y	3822725
115362	115325	3447880	Y	3822726
115360	115325	3813778	Y	3822727
115361	115325	3813778	Y	3822728
115362	115325	3813778	Y	3822729
3821495	115325	3813778	Y	3822730
115360	115325	3409847	Y	3822731
115361	115325	3409847	Y	3822732
115362	115325	3409847	Y	3822733
115360	115325	115318	Y	3822734
115361	115325	115318	Y	3822735
115362	115325	115318	Y	3822736
115360	115325	3409849	Y	3822737
115361	115325	3409849	Y	3822738
115362	115325	3409849	Y	3822739
3571968	115327	115317	Y	3827141
3571969	115327	115317	Y	3827142
3571970	115327	115317	Y	3827143
3583968	115327	115317	Y	3827144
115357	115324	3813780	Y	3856731
115358	115324	3813780	Y	3856732
115359	115324	3813780	Y	3856733
115363	115326	3813780	Y	3856742
115364	115326	3813780	Y	3856743
115366	115326	3813780	Y	3856744
115365	115326	3813780	Y	3856745
3571968	115327	3813780	Y	3856750
3571969	115327	3813780	Y	3856751
3571970	115327	3813780	Y	3856752
3583968	115327	3813780	Y	3856753
3505957	115330	3813780	Y	3856803
3505958	115330	3813780	Y	3856804
3505959	115330	3813780	Y	3856805
3505960	115330	3813780	Y	3856806
3505961	115330	3813780	Y	3856807
3505962	115330	3813780	Y	3856808
3505963	115330	3813780	Y	3856809
3504394	3078328	5054372	Y	5054477
3504395	3078328	5054372	Y	5054478
3531463	3078328	5054372	Y	5054479
115357	115324	5054372	Y	5058452
115358	115324	5054372	Y	5058453
115359	115324	5054372	Y	5058454
115361	115325	5054372	Y	5066549
115360	115325	5054372	Y	5066550
115362	115325	5054372	Y	5066551
115356	115323	5045262	Y	5085033
3504393	115323	5045262	Y	5085034
115357	115324	5045262	Y	5085035
115358	115324	5045262	Y	5085036
115359	115324	5045262	Y	5085037
115360	115325	5045262	Y	5085038
115361	115325	5045262	Y	5085039
115362	115325	5045262	Y	5085040
3821495	115325	5045262	Y	5085041
115363	115326	5045262	Y	5085042
115364	115326	5045262	Y	5085043
115366	115326	5045262	Y	5085044
115365	115326	5045262	Y	5085045
3571968	115327	5045262	Y	5085046
3571969	115327	5045262	Y	5085047
3571970	115327	5045262	Y	5085048
3583968	115327	5045262	Y	5085049
3504394	3078328	5045262	Y	5085050
3504395	3078328	5045262	Y	5085051
3531463	3078328	5045262	Y	5085052
3505957	115330	5045262	Y	5085053
3505959	115330	5045262	Y	5085054
3505958	115330	5045262	Y	5085055
3505960	115330	5045262	Y	5085056
3505962	115330	5045262	Y	5085057
3505963	115330	5045262	Y	5085058
3505961	115330	5045262	Y	5085059
115363	115326	3409847	Y	5120038
115364	115326	3409847	Y	5120039
115366	115326	3409847	Y	5120040
115365	115326	3409847	Y	5120041
3571968	115327	3409847	Y	5120042
3571969	115327	3409847	Y	5120043
3571970	115327	3409847	Y	5120044
3583968	115327	3409847	Y	5120045
115356	115323	5054372	Y	5122388
3504393	115323	5054372	Y	5122389
115363	115326	5054372	Y	5122390
115364	115326	5054372	Y	5122391
115366	115326	5054372	Y	5122392
115365	115326	5054372	Y	5122393
3571968	115327	5054372	Y	5122394
3571969	115327	5054372	Y	5122395
3571970	115327	5054372	Y	5122396
3583968	115327	5054372	Y	5122397
115357	115324	3813779	Y	5122427
115358	115324	3813779	Y	5122428
115359	115324	3813779	Y	5122429
115363	115326	3813779	Y	5122430
115364	115326	3813779	Y	5122431
115366	115326	3813779	Y	5122432
115365	115326	3813779	Y	5122433
3571968	115327	3813779	Y	5122434
3571969	115327	3813779	Y	5122435
3571970	115327	3813779	Y	5122436
3583968	115327	3813779	Y	5122437
3504394	3078328	3813779	Y	5122441
3504395	3078328	3813779	Y	5122442
3531463	3078328	3813779	Y	5122443
3504394	3078328	3813780	Y	5122444
3504395	3078328	3813780	Y	5122445
3531463	3078328	3813780	Y	5122446
115360	115325	3813781	Y	5242000
115361	115325	3813781	Y	5242001
115362	115325	3813781	Y	5242002
115360	115325	3813780	Y	5242037
115361	115325	3813780	Y	5242038
115362	115325	3813780	Y	5242039
115360	115325	3813779	Y	5242073
115361	115325	3813779	Y	5242074
115362	115325	3813779	Y	5242075
115360	115325	3813782	Y	5242076
115361	115325	3813782	Y	5242077
115362	115325	3813782	Y	5242078
115356	115323	5255700	Y	5255701
3504393	115323	5255700	Y	5255702
115357	115324	5255700	Y	5255703
115358	115324	5255700	Y	5255704
115359	115324	5255700	Y	5255705
115360	115325	5255700	Y	5255706
115361	115325	5255700	Y	5255707
115362	115325	5255700	Y	5255708
3821495	115325	5255700	Y	5255709
115363	115326	5255700	Y	5255710
115364	115326	5255700	Y	5255711
115366	115326	5255700	Y	5255712
115365	115326	5255700	Y	5255713
3571968	115327	5255700	Y	5255718
3571969	115327	5255700	Y	5255719
3571970	115327	5255700	Y	5255720
3583968	115327	5255700	Y	5255721
3504394	3078328	5255700	Y	5255722
3504395	3078328	5255700	Y	5255723
3531463	3078328	5255700	Y	5255724
3505957	115330	5255700	Y	5255725
3505958	115330	5255700	Y	5255726
3505959	115330	5255700	Y	5255727
3505960	115330	5255700	Y	5255728
3505961	115330	5255700	Y	5255729
3505962	115330	5255700	Y	5255730
3505963	115330	5255700	Y	5255731
5259543	5259476	5255700	Y	5259547
5259544	5259476	5255700	Y	5259548
5260743	5260675	5255700	Y	5260746
5260744	5260675	5255700	Y	5260747
5260745	5260675	5255700	Y	5260748
5260822	5260750	5255700	Y	5260824
5260823	5260750	5255700	Y	5260825
5260826	5260751	5255700	Y	5260829
5260827	5260751	5255700	Y	5260830
5260828	5260751	5255700	Y	5260831
115356	115323	3409847	Y	5282359
3504394	3078328	5385955	Y	5385956
3571970	115327	5385955	Y	5385957
115365	115326	5385955	Y	5385958
115362	115325	5385955	Y	5385959
115359	115324	5385955	Y	5385960
115356	115323	5385955	Y	5385961
\.


--
-- Data for Name: role_menu_event_group; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY role_menu_event_group (role_menu_event_id, role_id, group_id, is_active) FROM stdin;
\.


--
-- Name: role_menu_event_group_role_menu_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('role_menu_event_group_role_menu_event_id_seq', 1, false);


--
-- Data for Name: role_menu_group; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY role_menu_group (role_menu_id, menu_id, group_id, is_active) FROM stdin;
\.


--
-- Name: role_menu_group_role_menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('role_menu_group_role_menu_id_seq', 1, false);


--
-- Name: seq_attribute; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('seq_attribute', 2, true);


--
-- Name: serial; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('serial', 6003120, true);


--
-- Name: sq_program; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('sq_program', 6, true);


--
-- Name: srl_rjd; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('srl_rjd', 16462, true);


--
-- Data for Name: temp_inbox; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY temp_inbox (rowid, number, message, create_date, stat) FROM stdin;
inb6002725	08123456789	Pesan	2017-12-27 10:32:22.676145	\N
inb6002726	08123456789	Pesan	2017-12-27 10:32:22.676145	\N
inb6002727	0	0	2017-12-27 10:32:22.676145	\N
inb6002728	0815137898	Pesan Push	2017-12-27 10:32:22.676145	\N
inb6002729	081513674398	Pesan Push	2017-12-27 10:32:22.676145	\N
inb6002730	08118161167	1#1005832042	2017-12-27 10:32:22.676145	\N
inb6002731	08118161167	1#0005812084	2017-12-27 10:32:22.676145	\N
inb6002732	08118161167	1#0086621056	2017-12-27 10:32:22.676145	\N
inb6002733	08118161167	2#3097741716	2017-12-27 10:32:22.676145	\N
inb6002734	08118161167	2#0004631997	2017-12-27 10:32:22.676145	\N
inb6002735	08123456789	Pesan	2017-12-27 11:07:11.250512	\N
inb6002736	08123456789	Pesan	2017-12-27 11:07:11.250512	\N
inb6002737	0	0	2017-12-27 11:07:11.250512	\N
inb6002738	0815137898	Pesan Push	2017-12-27 11:07:11.250512	\N
inb6002739	081513674398	Pesan Push	2017-12-27 11:07:11.250512	\N
inb6002740	08118161167	1#1005832042	2017-12-27 11:07:11.250512	\N
inb6002741	08118161167	1#0005812084	2017-12-27 11:07:11.250512	\N
inb6002742	08118161167	1#0086621056	2017-12-27 11:07:11.250512	\N
inb6002743	08118161167	2#3097741716	2017-12-27 11:07:11.250512	\N
inb6002744	08118161167	2#0004631997	2017-12-27 11:07:11.250512	\N
inb6002745	6281513674297	1#0005812084	2017-12-27 11:07:11.250512	\N
inb6002746	6281513674297	5#0005812084	2017-12-27 11:07:11.250512	\N
inb6002747	08123456789	Pesan	2017-12-27 11:32:08.564085	\N
inb6002748	08123456789	Pesan	2017-12-27 11:32:08.564085	\N
inb6002749	0	0	2017-12-27 11:32:08.564085	\N
inb6002750	0815137898	Pesan Push	2017-12-27 11:32:08.564085	\N
inb6002751	081513674398	Pesan Push	2017-12-27 11:32:08.564085	\N
inb6002752	08118161167	1#1005832042	2017-12-27 11:32:08.564085	\N
inb6002753	08118161167	1#0005812084	2017-12-27 11:32:08.564085	\N
inb6002754	08118161167	1#0086621056	2017-12-27 11:32:08.564085	\N
inb6002755	08118161167	2#3097741716	2017-12-27 11:32:08.564085	\N
inb6002756	08118161167	2#0004631997	2017-12-27 11:32:08.564085	\N
inb6002757	6281513674297	1#0005812084	2017-12-27 11:32:08.564085	\N
inb6002758	6281513674297	5#0005812084	2017-12-27 11:32:08.564085	\N
inb6002759	6281513674297	2#0005812084	2017-12-27 11:32:08.564085	\N
inb6002760	08123456789	Pesan	2017-12-27 11:37:24.588774	\N
inb6002761	08123456789	Pesan	2017-12-27 11:37:24.588774	\N
inb6002762	0	0	2017-12-27 11:37:24.588774	\N
inb6002763	0815137898	Pesan Push	2017-12-27 11:37:24.588774	\N
inb6002764	081513674398	Pesan Push	2017-12-27 11:37:24.588774	\N
inb6002765	08118161167	1#1005832042	2017-12-27 11:37:24.588774	\N
inb6002766	08118161167	1#0005812084	2017-12-27 11:37:24.588774	\N
inb6002767	08118161167	1#0086621056	2017-12-27 11:37:24.588774	\N
inb6002768	08118161167	2#3097741716	2017-12-27 11:37:24.588774	\N
inb6002769	08118161167	2#0004631997	2017-12-27 11:37:24.588774	\N
inb6002770	6281513674297	1#0005812084	2017-12-27 11:37:24.588774	\N
inb6002771	6281513674297	5#0005812084	2017-12-27 11:37:24.588774	\N
inb6002772	6281513674297	2#0005812084	2017-12-27 11:37:24.588774	\N
inb6002773	08123456789	Pesan	2017-12-27 13:07:11.185705	\N
inb6002774	08123456789	Pesan	2017-12-27 13:07:11.185705	\N
inb6002775	0	0	2017-12-27 13:07:11.185705	\N
inb6002776	0815137898	Pesan Push	2017-12-27 13:07:11.185705	\N
inb6002777	081513674398	Pesan Push	2017-12-27 13:07:11.185705	\N
inb6002778	08118161167	1#1005832042	2017-12-27 13:07:11.185705	\N
inb6002779	08118161167	1#0005812084	2017-12-27 13:07:11.185705	\N
inb6002780	08118161167	1#0086621056	2017-12-27 13:07:11.185705	\N
inb6002781	08118161167	2#3097741716	2017-12-27 13:07:11.185705	\N
inb6002782	08118161167	2#0004631997	2017-12-27 13:07:11.185705	\N
inb6002783	6281513674297	1#0005812084	2017-12-27 13:07:11.185705	\N
inb6002784	6281513674297	5#0005812084	2017-12-27 13:07:11.185705	\N
inb6002785	6281513674297	2#0005812084	2017-12-27 13:07:11.185705	\N
\.


--
-- Data for Name: trans_pecatatanayam; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY trans_pecatatanayam (rowid, id_farm, id_kandang, item_id, delivery_no, delivery_date, jumlah, ayam, umur, ukuran, berat, uom, status_elemen, status_transaksi, create_by, create_date, update_by, update_date, id_angkatan) FROM stdin;
TPA39	MD2	MD3	0	0	0001-01-01	30	\N	0	8	3	MD46	MD37	MD34	\N	2018-01-29	\N	\N	MD50
TPA40	MD2	MD3	0	0	0001-01-01	1	\N	0	8	3	MD46	MD36	MD34	\N	2018-01-29	\N	\N	MD50
TPA41	MD2	MD3	0	0	0001-01-01	10	\N	0	100	1000	MD46	MD36	MD34	\N	2018-01-29	\N	\N	MD50
TPA38	MD2	MD3	MD49	91111	2018-01-29	20	\N	0	100	100	MD45	MD37	MD34	\N	2018-01-29	\N	\N	MD50
TPA42	MD2	MD4	MD49	131	2018-01-31	1000	\N	0	8	1	MD45	MD35	MD33	\N	2018-01-31	\N	\N	MD50
TPA43	MD2	MD4	MD49	131	2018-01-31	150	\N	0	5	1	MD45	MD36	MD34	\N	2018-01-31	\N	\N	MD50
TPA35	MD2	MD3	MD49	91111	2018-01-29	2000	\N	0	8	10	MD46	MD35	MD33	\N	2018-01-29	\N	\N	MD50
\.


--
-- Data for Name: user_group; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY user_group (group_id, group_name, group_description) FROM stdin;
\.


--
-- Name: user_group_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('user_group_group_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: syfawija_syfa
--

COPY users (user_id, user_name, group_id, real_name, last_login, count_login, date_created, user_password, is_active) FROM stdin;
1	admin	1	Administrator System	2015-11-26 17:49:30	245	2010-02-28 15:03:33	21232f297a57a5a743894a0e4a801fc3	t
\.


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: syfawija_syfa
--

SELECT pg_catalog.setval('users_user_id_seq', 1, true);


SET search_path = transform, pg_catalog;

--
-- Data for Name: ba_crm; Type: TABLE DATA; Schema: transform; Owner: syfawija
--

COPY ba_crm (row_id, acc_id, acc_name, no_ref, kd_area, asset_id, asset_serial, asset_type, asset_meas_id, asset_rdng_id, param_ukur, source, unit_ukur, stand_awal, stand_akhir, selisih, suhu, tekanan, fktr_koreksi, kalori, terukur_m3, terukur_mmbtu, terukur_mscf, sg, n2, co2, ghv, description, agree_id, pmn_agree_id, min_stand_awal, max_stand_akhir, max_fktr_koreksi, sum_vol_pemakaian, acc_id_period_for_link, akumulasi_m3, akumulasi_mmbtu, ghv_btu, kalori_btu, created, period_month, period, stg2_date_created) FROM stdin;
\.


--
-- Data for Name: get_profile_column; Type: TABLE DATA; Schema: transform; Owner: syfawija
--

COPY get_profile_column (rowid, id_grid, ptbl, create_date, kolom, search, source, submit_value) FROM stdin;
rw6002648	idgrid_employee_2	dup('80')	2017-12-07 10:41:10.672152	[{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"rowid","text":"Rowid","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"nipg","text":"Nipg","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"nama_karyawan","text":"Nama Karyawan","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"email","text":"Email","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"phone","text":"Phone","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"job_pos","text":"Job Pos","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"nama_jabatan","text":"Nama Jabatan","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"nama_satker","text":"Nama Satker","hidden":true,"autoSizeColumn":true}]	\N	\N	\N
rw6002649	idgrid_employee_3	dup('80')	2017-12-07 10:46:58.127725	[{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"rowid","text":"Rowid","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"nipg","text":"Nipg","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"nama_karyawan","text":"Nama Karyawan","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"email","text":"Email","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"phone","text":"Phone","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"job_pos","text":"Job Pos","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"nama_jabatan","text":"Nama Jabatan","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"nama_satker","text":"Nama Satker","hidden":false,"autoSizeColumn":true}]	\N	\N	\N
rw6002677	id_msprogram	ms_program	2017-12-13 15:11:18.215439	[{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"rowid","text":"Rowid","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"title","text":"Program","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"satker","text":"Satuan Kerja","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"content","text":"Content","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"create_date","text":"Create Date","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"create_by","text":"Create By","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"update_by","text":"Update By","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"update_date","text":"Update Date","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"tipe","text":"Tipe","hidden":false,"autoSizeColumn":true}]	\N	\N	\N
rw6002678	id_ms_program	ms_program	2017-12-13 15:18:43.382382	[{"xtype":"textfield","fieldLabel":"Nama Program","name":"title","allowBlank":false,"tooltip":"Enter your Nama Program"},{"xtype":"checkboxgroup","fieldLabel":"Satuan Kerja","columns":3,"allowBlank":false,"itemId":"mySports","items":[],"hidden":true,"v_source":"ms_satker","displayField":"satker","valueField":"satker","name":"satker"},{"xtype":"textareafield","fieldLabel":"Pesan","name":"content","allowBlank":false,"tooltip":"Enter your Pesan"},{"xtype":"combobox","fieldLabel":"Tipe","name":"tipe","displayField":"value","valueField":"value","queryMode":"local","v_source":"transform.fn_getglobalstat('stat_reply')"}]	\N	\N	\N
rw6002680	id_msautoreply	ms_autoreply	2017-12-19 01:26:56.245969	[{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"rowid","text":"Rowid","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"programid","text":"Programid","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"value","text":"Value","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"alias","text":"Alias","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"desc","text":"Desc","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"create_by","text":"Create By","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"create_date","text":"Create Date","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"update_by","text":"Update By1","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"update_date","text":"Update Date1","hidden":true,"autoSizeColumn":true}]	\N	\N	\N
rw6002721	id_v_forwardmessage	v_forwardmessage	2017-12-19 03:31:06.501305	[{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"nipg","text":"Nipg","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"nama_karyawan","text":"Nama Karyawan","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"phone","text":"Phone","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"tipe_message","text":"Tipe Message","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"satker","text":"Satuan Kerja","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"message","text":"Pesan","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"stat_message","text":"Status","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"title","text":"Nama Program","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"reff_nipg","text":"Reff NIPG","hidden":false,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"reff_karyawan","text":"Reff Karyawan","hidden":false,"autoSizeColumn":true}]	\N	\N	\N
rw6002722	id_vreply_message	vreply_message	2017-12-19 03:35:36.224117	[{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"nipg","text":"Nipg","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"nama_karyawan","text":"Nama Karyawan","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"phone","text":"Phone","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"tipe_message","text":"Tipe Message","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"satker","text":"Satuan kerja","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"message","text":"Pesan","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"stat_message","text":"Stat Message","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"title","text":"Title","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"stat_karyawan","text":"Status Karyawan","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"kode_stat_karyawan","text":"Kode Stat Karyawan","hidden":true,"autoSizeColumn":true}]	\N	\N	\N
rw6002723	id_get_msprogram()	get_msprogram()	2017-12-19 07:11:10.693153	[{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"rowid","text":"Rowid","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"title","text":"Nama Program","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"content","text":"Template","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"create_by","text":"Create By","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"create_date","text":"Create Date","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"satuan_kerja","text":"Satuan Kerja","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"}]	\N	\N	\N
rw6002830	id_formdata_type	data_type	2018-01-19 15:19:57.057391	[{"xtype":"textfield","fieldLabel":"Kode","name":"name","allowBlank":false,"tooltip":"Enter your Kode"},{"xtype":"textareafield","fieldLabel":"Deskripsi","name":"kode","allowBlank":false,"tooltip":"Enter your Deskripsi"}]	\N	\N	\N
rw6002826	id_msadata_type	data_type	2018-01-19 15:08:42.178986	[{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"rowid","text":"Kode","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"name","text":"Nama Data","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"kode","text":"Deskripsi","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"create_by","text":"Create By","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"create_date","text":"Create Date","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"update_by","text":"Update By","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"update_date","text":"Update Date","hidden":true,"autoSizeColumn":true}]	\N	\N	\N
rw6002833	id_formdmaster_data	master_data	2018-01-19 16:55:20.464466	[{"xtype":"combobox","fieldLabel":"Parent","name":"parent_id","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamaster()"},{"xtype":"textareafield","fieldLabel":"Deskripsi","name":"description","allowBlank":false,"tooltip":"Enter your Deskripsi"},{"xtype":"combobox","fieldLabel":"Jenis Data","name":"type_id","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_typeofdata()"},{"xtype":"textfield","fieldLabel":"Nama Data","name":"name","allowBlank":false,"tooltip":"Enter your Nama Data"}]	\N	\N	\N
rw6002834	id_master_datagrid	fn_getdatamastertype('TOD2')	2018-01-19 17:51:44.055235	[{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"vid","text":"ID","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"parent","text":"Parent","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"desk","text":"Desk","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"nama","text":"Nama Data","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"jenis_data","text":"Jenis Data","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"parent_name","text":"Parent","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"}]	\N	\N	\N
rw6002835	id_master_datagridmaster	master_data	2018-01-19 18:10:38.42239	[{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"rowid","text":"KODE","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"parent_id","text":"Parent Id","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"description","text":"Deskripsi","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"type_id","text":"Type Id","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"create_by","text":"Create By","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"create_date","text":"Create Date","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"update_by","text":"Update By0","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"update_date","text":"Update Date","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"name","text":"Parent","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"}]	\N	\N	\N
rw6002837	id_trans_pecatatanayamgrid	trans_pecatatanayam	2018-01-19 22:03:04.315097	[{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"rowid","text":"Rowid","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"id_farm","text":"Id Farm","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"id_kandang","text":"Id Kandang","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"item_id","text":"Item Id","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"delivery_no","text":"Delivery No","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"delivery_date","text":"Delivery Date","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"jumlah","text":"Jumlah","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"ayam","text":"Ayam","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"umur","text":"Umur","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"ukuran","text":"Ukuran","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"berat","text":"Berat","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"uom","text":"Uom","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"status_elemen","text":"Status Elemen","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"status_transaksi","text":"Status Transaksi","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"create_by","text":"Create By","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"create_date","text":"Create Date","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"update_by","text":"Update By","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"update_date","text":"Update Date","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"id_angkatan","text":"Id Angkatan","hidden":true,"autoSizeColumn":true}]	\N	\N	\N
rw6002836	id_formtrans_pecatatanayam	trans_pecatatanayam	2018-01-19 21:45:22.344643	[{"xtype":"combobox","fieldLabel":"Farms","name":"id_farm","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamastertype('TOD2')"},{"xtype":"combobox","fieldLabel":"Id Kandang","name":"id_kandang","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamastertype('TOD3')"},{"xtype":"textfield","fieldLabel":"Item","name":"item_id","allowBlank":false,"tooltip":"Enter your Item"},{"xtype":"textfield","fieldLabel":"Delivery No","name":"delivery_no","allowBlank":false,"tooltip":"Enter your Delivery No"},{"xtype":"textfield","fieldLabel":"Delivery Date","name":"delivery_date","allowBlank":false,"tooltip":"Enter your Delivery Date"},{"xtype":"textfield","fieldLabel":"Jumlah","name":"jumlah","allowBlank":false,"tooltip":"Enter your Jumlah"},{"xtype":"textfield","fieldLabel":"Ayam","name":"ayam","allowBlank":false,"tooltip":"Enter your Ayam"},{"xtype":"textfield","fieldLabel":"Umur","name":"umur","allowBlank":false,"tooltip":"Enter your Umur"},{"xtype":"textfield","fieldLabel":"Ukuran","name":"ukuran","allowBlank":false,"tooltip":"Enter your Ukuran"},{"xtype":"textfield","fieldLabel":"Berat","name":"berat","allowBlank":false,"tooltip":"Enter your Berat"},{"xtype":"textfield","fieldLabel":"Uom","name":"uom","allowBlank":false,"tooltip":"Enter your Uom"},{"xtype":"combobox","fieldLabel":"Status Elemen","name":"status_elemen","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamastertype('TOD19')"},{"xtype":"combobox","fieldLabel":"Status Transaksi","name":"status_transaksi","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamastertype('TOD17')"}]	\N	\N	\N
rw6002838	id_formtrans_pecatatanayampengembangan	trans_pecatatanayam	2018-01-20 01:49:48.958472	[{"xtype":"combobox","fieldLabel":"Farm","name":"id_farm","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamastertype('TOD2')"},{"xtype":"combobox","fieldLabel":"Kandang","name":"id_kandang","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamastertype('TOD3')"},{"xtype":"combobox","fieldLabel":"Item","name":"item_id","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamastertype('TOD21')"},{"xtype":"numberfield","fieldLabel":"Jumlah","name":"jumlah","allowBlank":false,"tooltip":"Enter your Jumlah"},{"xtype":"textfield","fieldLabel":"Ayam","name":"ayam","allowBlank":false,"tooltip":"Enter your Ayam"},{"xtype":"numberfield","fieldLabel":"Umur","name":"umur","allowBlank":false,"tooltip":"Enter your Umur"},{"xtype":"numberfield","fieldLabel":"Ukuran","name":"ukuran","allowBlank":false,"tooltip":"Enter your Ukuran"},{"xtype":"numberfield","fieldLabel":"Berat","name":"berat","allowBlank":false,"tooltip":"Enter your Berat"},{"xtype":"numberfield","fieldLabel":"Uom","name":"uom","allowBlank":false,"tooltip":"Enter your Uom"},{"xtype":"combobox","fieldLabel":"Status Elemen","name":"status_elemen","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamastertype('TOD19')"},{"xtype":"combobox","fieldLabel":"Status Transaksi","name":"status_transaksi","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamastertype('TOD17')"}]	\N	\N	\N
rw6002839	id_formmskonversiberat	mskonversiberat	2018-02-06 22:16:48.600205	[{"xtype":"textfield","fieldLabel":"Delivery Number","name":"delivery_number","allowBlank":false,"tooltip":"Enter your Delivery Number"},{"xtype":"combobox","fieldLabel":"Farms","name":"farms","displayField":"nama","valueField":"nama","queryMode":"local","v_source":"fn_getdatamastertype('TOD2')"},{"xtype":"combobox","fieldLabel":"Kandang","name":"kandang","displayField":"nama","valueField":"nama","queryMode":"local","v_source":"fn_getdatamastertype('TOD3')"},{"xtype":"combobox","fieldLabel":"Items Id","name":"items_id","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamastertype('TOD21')"},{"xtype":"datefield","format":"Y-m-d","fieldLabel":"Start","name":"start","allowBlank":false,"tooltip":"Enter your Start"},{"xtype":"datefield","format":"Y-m-d","fieldLabel":"End","name":"end","allowBlank":false,"tooltip":"Enter your End"},{"xtype":"numberfield","fieldLabel":"Berat","name":"berat","allowBlank":false,"tooltip":"Enter your Berat"},{"xtype":"combobox","fieldLabel":"Uom","name":"uom","displayField":"nama","valueField":"nama","queryMode":"local","v_source":"fn_getdatamastertype('TOD16')"}]	\N	\N	\N
rw6002840	idv_konversiberat	v_konversiberat	2018-02-06 22:58:18.044556	[{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"rowid","text":"Rowid","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"items_id","text":"Items Id","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"delivery_number","text":"Delivery Number","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"start","text":"Start","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"end","text":"End","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"berat","text":"Berat","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"uom","text":"Uom","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"createby","text":"Createby","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"createdate","text":"Createdate","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"updateby","text":"Updateby","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"updatedate","text":"Updatedate","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"kandang","text":"Kandang","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"farms","text":"Farms","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"nama_item","text":"Nama Item","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"}]	\N	\N	\N
rw6002841	id_formms_items	ms_items	2018-02-07 00:08:11.904549	[{"xtype":"textfield","fieldLabel":"Item Number","name":"item_number","allowBlank":false,"tooltip":"Enter your Item Number"},{"xtype":"textfield","fieldLabel":"Item Category","name":"item_category","allowBlank":false,"tooltip":"Enter your Item Category"},{"xtype":"textfield","fieldLabel":"Item Typeid","name":"item_typeid","allowBlank":false,"tooltip":"Enter your Item Typeid"},{"xtype":"combobox","fieldLabel":"Farms","name":"farms","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamastertype('TOD2')"},{"xtype":"combobox","fieldLabel":"Kandang","name":"kandang","displayField":"nama","valueField":"id","queryMode":"local","v_source":"fn_getdatamastertype('TOD3')"},{"xtype":"combobox","fieldLabel":"Status","name":"status","displayField":"nama","valueField":"nama","queryMode":"local","v_source":"fn_getdatamastertype('TOD23')"},{"xtype":"numberfield","fieldLabel":"Qty","name":"qty","allowBlank":false,"tooltip":"Enter your Qty"},{"xtype":"combobox","fieldLabel":"Uom","name":"uom","displayField":"nama","valueField":"nama","queryMode":"local","v_source":"fn_getdatamastertype('TOD16')"},{"xtype":"textfield","fieldLabel":"Item Name","name":"item_name","allowBlank":false,"tooltip":"Enter your Item Name"}]	\N	\N	\N
rw6002842	idgridv_masteritems	v_masteritems	2018-02-08 09:54:34.765564	[{"cls":"header-cell","dataIndex":"item_number","text":"Kode Barang","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"item_name","text":"Nama Barang","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"tipe_barang","text":"Tipe Barang","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"kategoi_barang","text":"Kategoi Barang","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"lokasi_farms","text":"Lokasi Farms","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},\n{"cls":"header-cell","dataIndex":"lokasi_kandang","text":"Lokasi Kandang","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"qty","text":"Qty","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"uom","text":"Uom","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"","text":"","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"rowid","text":"Rowid","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"item_category","text":"Item Category","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"item_typeid","text":"Item Typeid","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"farms","text":"Farms","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"kandang","text":"Kandang","hidden":true,"autoSizeColumn":true},{"cls":"header-cell","dataIndex":"status","text":"Status","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"craeteby","text":"Craeteby","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"createdate","text":"Createdate","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"updateby","text":"Updateby","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"},{"cls":"header-cell","dataIndex":"updatedate","text":"Updatedate","flex":1,"hidden":false,"autoSizeColumn":true,"tdCls":"wrap-text"}]	\N	\N	\N
\.


--
-- Data for Name: mdepartements; Type: TABLE DATA; Schema: transform; Owner: syfawija
--

COPY mdepartements (rowid, name_value, refhusid, delflag, created_by, updated_by, deleted_by, updcnt, credate, upddate) FROM stdin;
DEP10	Kepegawaian	HUS5	1	\N	\N	\N	\N	20171115130000	1
DEP11	Registrasi	HUS6	1	\N	\N	\N	\N	20171115130000	1
DEP8	Pelayanan	HUS5	1	\N	\N	\N	\N	20171115130000	1
DEP9	Perawat	HUS5	1	\N	\N	\N	\N	20171115130000	1
\.


--
-- Data for Name: ref_hus; Type: TABLE DATA; Schema: transform; Owner: syfawija
--

COPY ref_hus (rowid, name_value, code_value, code_business, delflag, credate, created_by, upddate, updated_by, updcnt) FROM stdin;
HUS5	RSUD-Brebes	RSUD0001	101	1	20171115130000	\N	\N	\N	1
HUS6	RSUD-Medan	RSUD0002	102	1	20171115130000	\N	\N	\N	1
\.


--
-- Name: srl_dep; Type: SEQUENCE SET; Schema: transform; Owner: syfawija
--

SELECT pg_catalog.setval('srl_dep', 6002824, true);


--
-- Name: srl_hus; Type: SEQUENCE SET; Schema: transform; Owner: syfawija
--

SELECT pg_catalog.setval('srl_hus', 2, false);


--
-- Name: srl_po; Type: SEQUENCE SET; Schema: transform; Owner: syfawija
--

SELECT pg_catalog.setval('srl_po', 6002842, true);


--
-- Data for Name: table_test; Type: TABLE DATA; Schema: transform; Owner: syfawija
--

COPY table_test (rowid, reffidamrdaily, idrefpelanggan, noref, id_unit_usaha, fcustomerid, fstreamid, fdatetime, fdate, fmonth, fyear, fhour, fminute, fsecond, fsector, fperiod, fdvm, fdvc, fp, ft, fvm, fvc, fcf, fmc, fmn, fsg, fgv, fen, fvctime, fvcstatus, pbase, tbase, pmax, pmin, qmax, qmin, tmax, tmin, qbase_max, qbase_min, bbtu, attribute1, attribute2, approved_status, approved_by, approved_date, reffcreated_date, reffcreated_by, reffupdated_date, reffupdated_by, feeddate, delflag, credate, creperson, upddate, updperson, updcnt) FROM stdin;
\.


SET search_path = public, pg_catalog;

--
-- Name: attributedetails attributedetails_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY attributedetails
    ADD CONSTRAINT attributedetails_pkey PRIMARY KEY (rowid);


--
-- Name: dok_orkom dok_orkom_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY dok_orkom
    ADD CONSTRAINT dok_orkom_pkey PRIMARY KEY (rowid);


--
-- Name: eventmenu eventmenu_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY eventmenu
    ADD CONSTRAINT eventmenu_pkey PRIMARY KEY (event_id);


--
-- Name: iconcls iconcls_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY iconcls
    ADD CONSTRAINT iconcls_pkey PRIMARY KEY (id);


--
-- Name: menu_event menu_event_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY menu_event
    ADD CONSTRAINT menu_event_pkey PRIMARY KEY (id);


--
-- Name: ms_autoreply ms_autoreply_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY ms_autoreply
    ADD CONSTRAINT ms_autoreply_pkey PRIMARY KEY (rowid);


--
-- Name: ms_employee ms_employee_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY ms_employee
    ADD CONSTRAINT ms_employee_pkey PRIMARY KEY (rowid);


--
-- Name: ms_orkom ms_orkom_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY ms_orkom
    ADD CONSTRAINT ms_orkom_pkey PRIMARY KEY (rowid);


--
-- Name: ms_program ms_program_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY ms_program
    ADD CONSTRAINT ms_program_pkey PRIMARY KEY (rowid);


--
-- Name: ms_project ms_project_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY ms_project
    ADD CONSTRAINT ms_project_pkey PRIMARY KEY (rowid);


--
-- Name: ms_satker ms_satker_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY ms_satker
    ADD CONSTRAINT ms_satker_pkey PRIMARY KEY (rowid);


--
-- Name: ms_segment ms_segment_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY ms_segment
    ADD CONSTRAINT ms_segment_pkey PRIMARY KEY (rowid);


--
-- Name: ms_workflow ms_workflow_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY ms_workflow
    ADD CONSTRAINT ms_workflow_pkey PRIMARY KEY (rowid);


--
-- Name: mskonversiberat mskonversiberat_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija
--

ALTER TABLE ONLY mskonversiberat
    ADD CONSTRAINT mskonversiberat_pkey PRIMARY KEY (rowid);


--
-- Name: permission permission_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (id);


--
-- Name: role_menu_event_group role_menu_event_group_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY role_menu_event_group
    ADD CONSTRAINT role_menu_event_group_pkey PRIMARY KEY (role_menu_event_id);


--
-- Name: role_menu_event role_menu_event_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY role_menu_event
    ADD CONSTRAINT role_menu_event_pkey PRIMARY KEY (rowid);


--
-- Name: role_menu_group role_menu_group_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY role_menu_group
    ADD CONSTRAINT role_menu_group_pkey PRIMARY KEY (role_menu_id);


--
-- Name: temp_inbox temp_inbox_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY temp_inbox
    ADD CONSTRAINT temp_inbox_pkey PRIMARY KEY (rowid);


--
-- Name: user_group user_group_group_name_key; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY user_group
    ADD CONSTRAINT user_group_group_name_key UNIQUE (group_name);


--
-- Name: user_group user_group_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY user_group
    ADD CONSTRAINT user_group_pkey PRIMARY KEY (group_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_user_name_key; Type: CONSTRAINT; Schema: public; Owner: syfawija_syfa
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_user_name_key UNIQUE (user_name);


SET search_path = transform, pg_catalog;

--
-- Name: get_profile_column get_profile_column_pkey; Type: CONSTRAINT; Schema: transform; Owner: syfawija
--

ALTER TABLE ONLY get_profile_column
    ADD CONSTRAINT get_profile_column_pkey PRIMARY KEY (rowid);


--
-- Name: ref_hus ref_hus_rowid_key; Type: CONSTRAINT; Schema: transform; Owner: syfawija
--

ALTER TABLE ONLY ref_hus
    ADD CONSTRAINT ref_hus_rowid_key UNIQUE (rowid);


SET search_path = public, pg_catalog;

--
-- Name: asc; Type: INDEX; Schema: public; Owner: syfawija_syfa
--

CREATE INDEX "asc" ON ms_workflow USING btree (rowid, createbyt);


--
-- Name: transform; Type: ACL; Schema: -; Owner: syfawija
--

GRANT ALL ON SCHEMA transform TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: serial; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE serial TO syfawija_root;


--
-- Name: v_employee; Type: ACL; Schema: public; Owner: syfawija_syfa
--

REVOKE ALL ON TABLE v_employee FROM syfawija_syfa;
GRANT ALL ON TABLE v_employee TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: fn_getdatamastertype_ms(character varying, character varying); Type: ACL; Schema: public; Owner: syfawija
--

GRANT ALL ON FUNCTION fn_getdatamastertype_ms(ptype_id character varying, p_id2 character varying) TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: data_type_user_id_seq; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE data_type_user_id_seq TO syfawija_root;


--
-- Name: data_type; Type: ACL; Schema: public; Owner: syfawija_syfa
--

REVOKE ALL ON TABLE data_type FROM syfawija_syfa;
GRANT ALL ON TABLE data_type TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: group_permission; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT ALL ON TABLE group_permission TO PUBLIC;


--
-- Name: iconcls_id_seq; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE iconcls_id_seq TO syfawija_root;


--
-- Name: master_data_user_id_seq; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE master_data_user_id_seq TO syfawija_root;


--
-- Name: master_data; Type: ACL; Schema: public; Owner: syfawija_syfa
--

REVOKE ALL ON TABLE master_data FROM syfawija_syfa;
GRANT ALL ON TABLE master_data TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: menu; Type: ACL; Schema: public; Owner: syfawija_syfa
--

REVOKE ALL ON TABLE menu FROM syfawija_syfa;
GRANT ALL ON TABLE menu TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: menu_event_id_seq; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE menu_event_id_seq TO syfawija_root;


--
-- Name: message; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE message TO syfawija_root;


--
-- Name: ms_items; Type: ACL; Schema: public; Owner: syfawija
--

GRANT ALL ON TABLE ms_items TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: sq_program; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE sq_program TO syfawija_root;


--
-- Name: project; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE project TO syfawija_root;


--
-- Name: srl_rjd; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE srl_rjd TO syfawija_root;


--
-- Name: mskonversiberat; Type: ACL; Schema: public; Owner: syfawija
--

GRANT ALL ON TABLE mskonversiberat TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: penc_ayam_id_seq; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT ALL ON SEQUENCE penc_ayam_id_seq TO PUBLIC;
GRANT SELECT,USAGE ON SEQUENCE penc_ayam_id_seq TO syfawija_root;


--
-- Name: rev_user_user_id_seq; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE rev_user_user_id_seq TO syfawija_root;


--
-- Name: rev_user; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT ALL ON TABLE rev_user TO PUBLIC;


--
-- Name: role_menu_event_group_role_menu_event_id_seq; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE role_menu_event_group_role_menu_event_id_seq TO syfawija_root;


--
-- Name: role_menu_group_role_menu_id_seq; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE role_menu_group_role_menu_id_seq TO syfawija_root;


--
-- Name: showmenu; Type: ACL; Schema: public; Owner: syfawija_syfa
--

REVOKE ALL ON TABLE showmenu FROM syfawija_syfa;
GRANT ALL ON TABLE showmenu TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: user_group_group_id_seq; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE user_group_group_id_seq TO syfawija_root;


--
-- Name: users_user_id_seq; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT SELECT,USAGE ON SEQUENCE users_user_id_seq TO syfawija_root;


--
-- Name: v_datatype; Type: ACL; Schema: public; Owner: syfawija
--

GRANT ALL ON TABLE v_datatype TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: v_kandangunion; Type: ACL; Schema: public; Owner: syfawija_syfa
--

REVOKE ALL ON TABLE v_kandangunion FROM syfawija_syfa;
GRANT ALL ON TABLE v_kandangunion TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: v_konversiberat; Type: ACL; Schema: public; Owner: syfawija
--

GRANT ALL ON TABLE v_konversiberat TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: v_masteritems; Type: ACL; Schema: public; Owner: syfawija
--

GRANT ALL ON TABLE v_masteritems TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: v_pencatatan; Type: ACL; Schema: public; Owner: syfawija
--

GRANT ALL ON TABLE v_pencatatan TO PUBLIC;
GRANT ALL ON TABLE v_pencatatan TO syfawija_syfa;


--
-- Name: v_revuser; Type: ACL; Schema: public; Owner: syfawija_syfa
--

GRANT ALL ON TABLE v_revuser TO PUBLIC;
GRANT ALL ON TABLE v_revuser TO syfawija_root;


--
-- Name: vreply_message; Type: ACL; Schema: public; Owner: syfawija_syfa
--

REVOKE ALL ON TABLE vreply_message FROM syfawija_syfa;
GRANT ALL ON TABLE vreply_message TO syfawija_syfa WITH GRANT OPTION;


SET search_path = transform, pg_catalog;

--
-- Name: ba_crm; Type: ACL; Schema: transform; Owner: syfawija
--

GRANT ALL ON TABLE ba_crm TO syfawija_syfa;


--
-- Name: srl_po; Type: ACL; Schema: transform; Owner: syfawija
--

GRANT SELECT,USAGE ON SEQUENCE srl_po TO syfawija_root;


--
-- Name: get_profile_column; Type: ACL; Schema: transform; Owner: syfawija
--

GRANT ALL ON TABLE get_profile_column TO syfawija_syfa WITH GRANT OPTION;


--
-- Name: srl_dep; Type: ACL; Schema: transform; Owner: syfawija
--

GRANT SELECT,USAGE ON SEQUENCE srl_dep TO syfawija_root;


--
-- Name: mdepartements; Type: ACL; Schema: transform; Owner: syfawija
--

GRANT ALL ON TABLE mdepartements TO syfawija_syfa;


--
-- Name: srl_hus; Type: ACL; Schema: transform; Owner: syfawija
--

GRANT SELECT,USAGE ON SEQUENCE srl_hus TO syfawija_root;


--
-- Name: ref_hus; Type: ACL; Schema: transform; Owner: syfawija
--

GRANT ALL ON TABLE ref_hus TO syfawija_syfa;


--
-- Name: table_test; Type: ACL; Schema: transform; Owner: syfawija
--

GRANT ALL ON TABLE table_test TO syfawija_syfa;


--
-- PostgreSQL database dump complete
--


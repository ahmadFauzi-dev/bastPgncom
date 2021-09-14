<?php if( ! defined('BASEPATH')) exit('No direct script access allowed');

class B_model extends CI_Model{	
	
	/* function __construct(){
		$this->db	= $this->load->database('default',TRUE);
		parent::__construct();	
	}
	cari-cari */
	
	public function get_all($table, $where){
		if(isset($where) && $where != NULL){
			$this->db->where($where);
		}
		return $this->db->get($table)->result();
	}
	
	public function update_all($table, $where ,$data){  		
		$this->db->where($where);
		$this->db->update($table, $data);
		if($this->db->affected_rows() == 1){
			return true;
		} else{
			return false;
		}
	}
	
	public function delete_all($table, $where){ 			
		$this->db->where($where);
		$this->db->delete($table);

		if($this->db->affected_rows() > 0){
			return true;
		} else{
			return false;
		}
	}

	
	public function find_amr_data($table, $startt, $endd, $sbu, $area, $idpel, $namapel , $filter = array() , $limit = '25', $offset = '0', $order = '')
	{
		
		if(!empty($startt) && !empty($endd) ){
		$arr = array('tanggal > ' => $startt, 'tanggal <= ' => $endd );			
		$this->db->where($arr);
		// $this->db->where('tanggal >', intval($startt) );
		// $this->db->where('tanggal <=', intval($endd) );
		}
		if(!empty($sbu)){
			$arsbu = array('sbu' => $sbu);
			$this->db->where($arsbu);
		}
		if(!empty($area)){
			$arare = array('area' => $area);
			$this->db->where($arare);
		}
		if(!empty($idpel)){
			$aridpel = array('id_pel' => $idpel);
			$this->db->where($aridpel);
		}
		if(!empty($namapel)){
			$arnamapel = array('namapel' => $namapel);
			$this->db->where($arnamapel);
		}		
		if (is_array($filter) && count($filter) > 0) generate_filter($filter);

		if($order > ''){
			$this->db->order_by($order);
		}

		$this->db->limit($limit, $offset);
		$news_db_query= $this->db->get($table);	
		if($news_db_query->num_rows > 0){
			return $news_db_query->result();
		} else{
			return false;
		}
		
		
	}	

	/* for all controllers */
	
	public function get_all_data($table, $filter = array() , $limit = '25', $offset = '0', $order = ''){	
		//var_dump($filter);
		if (is_array($filter) && count($filter) > 0 ) generate_filter($filter);
		$as = generate_filter($filter);
		
		echo generate_filter($filter);
		if($order > ''){
			$this->db->order_by($order);
		}
		/*if(!empty($where)){
			$this->db->where($where);
		}*/
		
		if($limit != 'All')
		{
			$this->db->limit($limit, $offset);
		}
		
		$news_db_query= $this->db->get($table);	
		if($news_db_query->num_rows > 0){
			return $news_db_query->result();
		} else{
			return false;
		}			
	}
	public function get_all_dataquery($table, $limit = '25', $offset = '0', $order = '')
	{
		$bridge = $this->load->database('bridge', TRUE);
		//if (is_array($filter) && count($filter) > 0 ) generate_filter($filter);
		//$as = generate_filter($filter);
		
		//echo generate_filter($filter);
		if($order > ''){
			$bridge->order_by($order);
		}
		/*if(!empty($where)){
			$this->db->where($where);
		}*/
		
		if($limit != 'All')
		{
			$bridge->limit($limit, $offset);
		}
		
		//$news_db_query= $bridge->get($table);	
		$query = "SELECT * FROM (select inner_query.*, rownum rnum FROM (SELECT * FROM usr_amr_pgasol.alert_daily) 
					inner_query WHERE rownum < 25)";
		$news_db_query  = $bridge->query($query);
		
		if($news_db_query->num_rows > 0){
			return $news_db_query->result();
		} else{
			return false;
		}
		/*
		if($order > ''){
			$bridge>order_by($order);
		}
		/*if(!empty($where)){
			$this->db->where($where);
		}*/
		/*
		if($limit != 'All')
		{
			$bridge->limit($limit, $offset);
		}
		//$query = "select * from (".$pquery.") a  where rownum = 25";
		//$query = "select * from (".$pquery.") a  where rownum = 25";
		$news_db_query	= $bridge->query($pquery)->result_array();
		
		//$news_db_query= $this->db->query($query." OFFSET ".$offset." LIMIT ".$limit.""); 
		//$news_db_query= $this->db->query($query,array($this->db->limit($limit, $offset)); 
		
		//$this->db->get($table);	
		
		/*if($news_db_query->num_rows > 0){
			return $news_db_query->result();
		} else{
			return false;
		}*/	
		/*
		return $news_db_query;
		*/
		
	}
	
	public function insert_data($table, $data)
	{
		$this->db->trans_begin();
		$this->db->insert($table, $data);
		if($this->db->trans_status() === FALSE ){
			$this->db->trans_rollback();
			return false;
		} else{
			$this->db->trans_commit();
			return $this->db->insert_id();
			return true;
		}
		
	}
	
	public function insert_batch($table, $data)
	{
		$this->db->trans_begin();
		if(empty($data) == false)
		{
			$this->db->insert_batch($table, $data);
		}
		if($this->db->affected_rows() == 1){
			$this->db->trans_commit();
			return $this->db->insert_id();
		} else{
			$this->db->trans_rollback();	
			return false;
		}
	}
 
	public function update_data($table, $filter = array() , $data)
	{ 
		$this->db->trans_begin();
 		if (is_array($filter)  && count($filter) > 0 ) generate_filter($filter);
		// $this->db->where($where);
		$this->db->update($table, $data);
		if ($this->db->trans_status() === FALSE)
		{
			$this->db->trans_rollback();
			return false;
		}
		else
		{
			$this->db->trans_commit();
			return true;
		}
	}

	public function delete_data($table, $filter = array()){ 
		if (is_array($filter) && count($filter) > 0 ) generate_filter($filter);		
		// $this->db->where($where);
		$this->db->delete($table);

		if($this->db->affected_rows() > 0){
			return true;
		} else{
			return false;
		}
	}
 
	
	public function count_all_data($table, $filter = array()){
		$this->db->from($table);
		/*if(!empty($where)){
			$this->db->where($where);
		}*/   

		if (is_array($filter) && count($filter) > 0 ) generate_filter($filter);
		return $this->db->count_all_results();
	}
	public function count_amr_data ($table, $startt, $endd, $sbu, $area, $idpel, $namapel , $filter = array()){
		
		$this->db->from($table);
		
		if(!empty($startt) && !empty($endd) ){
		$arr = array('tanggal >= ' => $startt, 'tanggal <= ' => $endd );			
		$this->db->where($arr);
		// $this->db->where('tanggal >', intval($startt) );
		// $this->db->where('tanggal <=', intval($endd) );
		}
		if(!empty($sbu)){
			$arsbu = array('sbu' => $sbu);
			$this->db->where($arsbu);
		}
		if(!empty($area)){
			$arare = array('area' => $area);
			$this->db->where($arare);
		}
		if(!empty($idpel)){
			$aridpel = array('id_pel' => $idpel);
			$this->db->where($aridpel);
		}
		if(!empty($namapel)){
			$arnamapel = array('namapel' => $namapel);
			$this->db->where($arnamapel);
		}			
		if (is_array($filter) && count($filter) > 0 ) generate_filter($filter);
		return $this->db->count_all_results();
		
	}
	public function getdataparameterinputdaily($datainput,$databefore)
	{
		if(floatval($databefore[0]->volume) == 0 OR ($datainput['volume'] != $databefore[0]->volume))
		{
			$data[0] = array("tbl_parameter"	=> 'volume',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> $datainput['volume'],
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}else
		{
			$data[0] = array("tbl_parameter"	=> 'volume',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> 0,
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}
		
		if(floatval($databefore[0]->energy) == 0 OR ($datainput['energy'] != $databefore[0]->energy))
		{
			$data[1] = array("tbl_parameter"	=> 'energy',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> $datainput['energy'],
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}else
		{
			$data[1] = array("tbl_parameter"	=> 'energy',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> 0,
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}
		
		if(floatval($databefore[0]->ghv) == 0 OR ($datainput['ghv'] != $databefore[0]->ghv))
		{
			$data[2] = array("tbl_parameter"	=> 'ghv',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> $datainput['ghv'],
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');	
		}else
		{
			$data[2] = array("tbl_parameter"	=> 'ghv',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> 0,
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');	
		}
		
		if(floatval($databefore[0]->pin) == 0 OR ($datainput['pin'] != $databefore[0]->pin))
		{
			$data[3] = array("tbl_parameter"	=> 'pin',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> $datainput['pin'],
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}else
		{
			$data[3] = array("tbl_parameter"	=> 'pin',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> 0,
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}
		
		if(floatval($databefore[0]->pout) == 0 OR ($datainput['pout'] != $databefore[0]->pout))
		{
			$data[4] = array("tbl_parameter"	=> 'pout',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> $datainput['pout'],
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}else
		{
			$data[4] = array("tbl_parameter"	=> 'pout',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> 0,
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}
		
		if(floatval($databefore[0]->temperature) == 0 OR ($datainput['temperature'] != $databefore[0]->temperature))
		{
			$data[5] = array("tbl_parameter"	=> 'temperature',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> $datainput['temperature'],
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}else
		{
			$data[5] = array("tbl_parameter"	=> 'temperature',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> 0,
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}
		
		if(floatval($databefore[0]->counter_volume) == 0 OR ($datainput['counter_volume'] != $databefore[0]->counter_volume))
		{
			$data[6] = array("tbl_parameter"	=> 'counter_volume',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> $datainput['counter_volume'],
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}else
		{
			$data[6] = array("tbl_parameter"	=> 'counter_volume',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> 0,
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}
		
		if(floatval($databefore[0]->counter_energy) == 0 OR ($datainput['counter_energy'] != $databefore[0]->counter_energy))
		{
			$data[7] = array("tbl_parameter"	=> 'counter_energy',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> $datainput['counter_energy'],
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}else
		{
			$data[7] = array("tbl_parameter"	=> 'counter_energy',
						"tgl_pengukuran"		=> $datainput['tanggalpengukuran'],
						"parameter_periode"		=> 'daily',
						"tbl_parametervalue"	=> 0,
						"tbl_station_id"		=> $datainput['tbl_station_id'],
						"statusdata"			=> 'manualinput');
		}

		return $data;	
							
	}
	public function getmodel($view)
	{
		$query = "Select * from ".$view." limit 1";
		$hasil_query	= $this->db->query($query);
		foreach($hasil_query->list_fields() as $field)
		{
			$data[] = $field;
		}
		//$modelfields = array("fields"	=> $data); 
		
		return json_encode($data);
	}
	public function getmodelquery($pquery)
	{
		$bridge = $this->load->database('bridge', TRUE);
		
		$query = "select * from (".$pquery.")  where rownum = 1";
		$hasil_query	= $bridge->query($query);
		foreach($hasil_query->list_fields() as $field)
		{
			$data[] = $field;
		}
		//$modelfields = array("fields"	=> $data); 
		
		return json_encode($data);
	}
	public function getcolumn($tbl)
	{
		$query = "Select * from ".$tbl." limit 1";
		$hasil_query	= $this->db->query($query);
		$columngrid = array();
		
		
		$columngrid[0] = array("xtype"	=> 'rownumberer', "header" => 'No');
		$n=1;
		foreach($hasil_query->list_fields() as $field)
		{
			//$data[] = $field;
			$columngrid[$n] = array("dataIndex"	=> $field,"text" => $field,"cls" => "header-cell");
			$n++;	
		}
		
		
		return json_encode($columngrid);
	}
	public function getcolumnquery($pquery)
	{
		$bridge = $this->load->database('bridge', TRUE);
		//$query = "".$pquery." limit 1";
		$query = "select * from (".$pquery.")  where rownum = 1";
		$hasil_query	= $bridge->query($query);
		//$hasil_query	= $this->db->query($query);
		
		$columngrid = array();
		
		
		$columngrid[0] = array("xtype"	=> 'rownumberer', "header" => 'No');
		$n=1;
		foreach($hasil_query->list_fields() as $field)
		{
			//$data[] = $field;
			
			$columngrid[$n] = array("dataIndex"	=> $field,"text" => $field,"cls" => "header-cell");
			$n++;	
		}
		return json_encode($columngrid);
	}
	
	public function count_all($table, $where){
		$this->db->from($table);

		if(isset($where) && $where != NULL){
			$this->db->where($where);
		}
		return $this->db->count_all_results();
	}
	
	public function get_func ($satu, $dua, $tiga, $empat, $lima)
	{	 
		$sql = $this->db->query("select * from getdata_alert_pengukuran('$satu', '$dua', '$tiga', '$empat' , '$lima')");
		
		if($sql->num_rows > 0){
			return $sql->result();
		} else{
			return false;
		}			
	}
	
	public function total_func ($satu, $dua, $tiga, $empat, $lima)
	{	 
		$sql = $this->db->query("select * from getdata_alert_pengukuran('$satu', '$dua', '$tiga', '$empat' , '$lima')");		
		return $sql->num_rows();					
	}
	
	public function get_func_chart ($satu, $dua, $tiga )
	{	 
		$sql = $this->db->query("select * from getprofile_pengukuran_daily('$satu', '$dua', '$tiga')");
		
		if($sql->num_rows > 0){
			return $sql->result();
		} else{
			return false;
		}			
	}
	
	public function total_func_chart ($satu, $dua, $tiga )
	{	 
		$sql = $this->db->query("select * from getprofile_pengukuran_daily('$satu', '$dua', '$tiga')");		
		return $sql->num_rows();					
	}

	
}
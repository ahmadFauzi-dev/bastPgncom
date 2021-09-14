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

		if (is_array($filter) && count($filter) > 0 ) generate_filter($filter);

		if($order > ''){
			$this->db->order_by($order);
		}
		/*if(!empty($where)){
			$this->db->where($where);
		}*/
		$this->db->limit($limit, $offset);
		$news_db_query= $this->db->get($table);	
		if($news_db_query->num_rows > 0){
			return $news_db_query->result();
		} else{
			return false;
		}			
	}
	
	public function insert_data($table, $data){
		
		$this->db->insert($table, $data);
		if($this->db->affected_rows() == 1){
			return $this->db->insert_id();
		} else{
			return false;
		}
	}
 
	public function update_data($table, $filter = array() ,$data){ 
 		if (is_array($filter)  && count($filter) > 0 ) generate_filter($filter);
		// $this->db->where($where);
		$this->db->update($table, $data);
		if($this->db->affected_rows() == 1){
			return true;
		} else{
			return false;
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
	
}
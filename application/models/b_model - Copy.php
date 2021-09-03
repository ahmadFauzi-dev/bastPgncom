<?php if( ! defined('BASEPATH')) exit('No direct script access allowed');

class B_model extends CI_Model{	
	/* 
	function __construct(){
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
	
}
<?php if( ! defined('BASEPATH')) exit('No direct script access allowed');

class B_model extends CI_Model{	
	
	 function __construct(){
		$this->db	= $this->load->database('default',TRUE);
		parent::__construct();	
	}
	
	/*cari-cari */
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
	
	public function action_workflow($rowid,$refftransaction,$action,$data,$filename)
	{
		$query = "select
								(select max(priority) from ms_workflowdetail where refftransaction = '".$refftransaction."') as last_priority,
								(select min(priority) from ms_workflowdetail where refftransaction = '".$refftransaction."') as min_priority,
								(select priority from ms_workflowdetail where rowid = '".$rowid."') as priority,
								(select rowid from ms_workflowdetail where refftransaction = '".$refftransaction."' and priority = ((select priority from ms_workflowdetail where rowid = '".$rowid."') + 1)) as rowid_approve";
		
		$hasil_activity	= $this->db->query($query);
		$hasil = $hasil_activity->result();
		
		$last_priority 	= $hasil[0]->last_priority;
		$min_priority 	= $hasil[0]->min_priority;
		$priority 			= $hasil[0]->priority;
		$rowid_approve	= $hasil[0]->rowid_approve;
		
		switch ($action){
			
			//APPROVED
			case 'MD320':			
				if($last_priority == $priority){			
					//untuk form cuti
					$data1 = array(
						'reffstatus' => $action
					);
					
					$filter1[0]['field'] = "rowid";
					$filter1[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $rowid);
					$this->update_data('ms_workflowdetail',$filter1, $data);
					
					$filter2[0]['field'] = "rowid";
					$filter2[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $refftransaction);
					$this->update_data('tbl_suratkeluar',$filter2, $data1);					
					
					$return = array (
						'status' => 'Y',
						'data_user' => array(),
					);
					return $return;
				}
				else{
					
					$data1 = array(
						'reffstatus' => $action
					);
					
					$data2 = array(
						'reffstatus' => 'MD341'
					);
										
					$filter1[0]['field'] = "rowid";
					$filter1[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $rowid);
										   
					$filter2[0]['field'] = "rowid";
					$filter2[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $rowid_approve);
										   
					
					$this->update_data('ms_workflowdetail',$filter1, $data1);
					$this->update_data('ms_workflowdetail',$filter2, $data2);
					
					$bdata = $this->get_all_data('v_workflowdetail', $filter2 ,1, '', '');	
					
					$filterus[0]['field'] = "user_id";
					$filterus[0]['data'] = array(
											   "type"		=> "string",
											   "comparison"	=> "eq",
											   "value"		=> $bdata[0]->user_id);							
					$datauser = $this->get_all_data('v_revuser', $filterus,1, '', '');	
							
					$return = array (
						'status' => 'N',
						'data_user' => $datauser
					);
					return $return;
				}
			break;
			
			
			case 'MD322':
					$data = array(
						'reffstatus' => $action
					);
					
					$filter2[0]['field'] = "rowid";
					$filter2[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $refftransaction);
					$this->update_data('tbl_suratkeluar',$filter2, $data);		
					
					$filter1[0]['field'] = "rowid";
					$filter1[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $rowid);										   
					$this->update_data('ms_workflowdetail',$filter1, $data);					
					$return = array (
						'status' => 'N',
						'data_user' => $datauser
					);
					
					return $return;
			break;
			
			default :						
					$data = array(
						'reffstatus' => $action
					);
					
					
					$filter2[0]['field'] = "rowid";
					$filter2[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $refftransaction);
					$this->update_data('tbl_suratkeluar',$filter2, $data);		
					
					$filter1[0]['field'] = "refftransaction";
					$filter1[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $refftransaction);										   
					$this->update_data('ms_workflowdetail',$filter1, $data);					
					$return = array (
						'status' => 'N',
						'data_user' => $datauser
					);
					
					return $return;
					
			break;
		}
	}
	
	public function get_all_data($table, $filter = array() , $limit = '25', $offset = '0', $order = ''){	
		//die();
		if (is_array($filter) && count($filter) > 0 ) generate_filter($filter);
		$where = generate_filter($filter);
	
		//echo generate_filter($filter);
		//die();
		if($order > ''){
			$this->db->order_by($order);
		}
		if(!empty($where)){
			$this->db->where($where);
		}
		
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
	public function get_all_datafunc($table, $filter = array() , $limit = '25', $offset = '0', $order = ''){	
		//var_dump($filter);
		if (is_array($filter) && count($filter) > 0 ) $where = generate_filter($filter, 'okeh');
		
		if($order > '' ){
			$orderby = " ORDER BY ". $order ;
		} 

		if($limit != 'All')
		{
			$limitnya = " LIMIT ".$limit;

			if ($offset > 0)
			{
				$limitnya .= " OFFSET ".$offset;
			}
		}
		if($where == '')
		{
			$query = "select * from ".$table." ".$orderby." ".$limitnya."";
		}else
		{
			$query = "select * from ".$table." where ".$where." ".$orderby." ".$limitnya."";
		}
		
		
		//$query = 'select * from data_type LIMIT 25';
		$news_db_query = $this->db->query($query);
		//$news_db_query= $this->db->get($table);	
		if($news_db_query->num_rows > 0){
			return $news_db_query->result();
		} else{
			return false;
		}			
	}
	
	public function count_all_data_func($table, $filter = array()){
		if (is_array($filter) && count($filter) > 0 ) generate_filter($filter, 'okeh');
		$where = generate_filter($filter, 'okeh');
		if($where == '')
		{
			$query = "select * from ".$table."  ";
		}else
		{
			$query = "select * from ".$table." where ".generate_filter($filter, 'okeh');
		}
		
		//$query = "select * from ".$table." where ".generate_filter($filter, 'okeh');
		//var_dump($filter);
		//echo $query;
		//die();
		$news_db_query = $this->db->query($query);
		
		return $news_db_query->num_rows();
	}	
	
	
	public function get_all_dataquery($pquery, $limit = '25', $offset = '0', $order = '')
	{
		$bridge = $this->load->database('bridge', TRUE);
		
		
		if($order > ''){
			$bridge>order_by($order);
		}
		/*if(!empty($where)){
			$this->db->where($where);
		}*/
		
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
		return $news_db_query;
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
	
	public function update_data($table, $filter = array() , $data)
	{ 
		$this->db->trans_begin();
 		if (is_array($filter)  && count($filter) > 0 ) $where = generate_filter($filter);
		 
		$this->db->where($where);
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

	public function delete_data($table, $filter = array())
	{ 
		if (is_array($filter) && count($filter) > 0 ) $where = generate_filter($filter);		
		
		$this->db->where($where);
		$this->db->delete($table);

		if($this->db->affected_rows() > 0){
			return true;
		} else{
			return false;
		}
	}
 
	public function count_all_data($table, $filter = array())
	{
		$where = generate_filter($filter);
		$this->db->from($table);
		if(!empty($where)){
			$this->db->where($where);
		}  

		//if (is_array($filter) && count($filter) > 0 ) generate_filter($filter);
		return $this->db->count_all_results();
	}
	
	public function getmodel($view)
	{
		$query = "Select * from ".$view." limit 1";
		$hasil_query	= $this->db->query($query);
		foreach($hasil_query->field_data() as $field)
		{
			switch ($field->type) {
				case "numeric":
					$data[]  = array("name"	=> $field->name, "type"	=> "NUMBER");
					break;
				case "date":
					$data[]  = array("name"	=> $field->name, "type"	=> "string");
					break;
				default:
					$data[]  = array("name"	=> $field->name, "type"	=> $field->type );
			}
		}
		
		return json_encode($data);
	}
	public function getmodelquery($pquery)
	{
		$bridge = $this->load->database('bridge', TRUE);
		
		$query = "select * from (".$pquery.")  where rownum = 1";
		$hasil_query	= $bridge->query($query);
		foreach($hasil_query->field_data() as $field)
		{
			if($field->type == 'numeric') 
			{
				$data[]  = array("name"	=> $field->name, "type"	=> "number");
			}else
			{
				$data[]  = array("name"	=> $field->name, "type"	=> $field->type);
			}
		}
		//$modelfields = array("fields"	=> $data); 
		
		return json_encode($data);
	}
	public function getcolumn($tbl,$id_grid = null)
	{
		if($id_grid == null)
		{
			$id_grid = '-';
		}
		
		$filterup[0]['field'] = "id_grid";
		$filterup[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"			=> "".$id_grid."");
								   
		
		$count = $this->count_all_data_func('transform.get_profile_column',$filterup);
		//var_dump ($count); 
		//echo $count;
		//var_dump($filterup);
		//die();
		//var_dump($count);
		//$count = 0;
		if($count == 0)
		{
			$query = "Select * from ".$tbl." limit 1";
			//echo $query;
			$hasil_query	= $this->db->query($query);
			$columngrid = array();
			
			
			
			$columngrid[0] = array("xtype"	=> 'rownumberer', "header" => 'No', "width" => '40');
			$n=1;
			foreach($hasil_query->list_fields() as $field)
			{
				//$data[] = $field;
				$columngrid[$n] = array("autoSizeColumn"	=> true,"dataIndex"	=> $field,"text" => ucwords( str_replace("_"," ",$field) ),"cls" => "header-cell");
				$n++;	
			}
			
			
			return json_encode($columngrid);
		}else
		{
			
			$filter[0]['field'] = "id_grid";
			$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"			=> "string",
								   "value"			=> $id_grid);
								   
								   
			$data = $this->get_all_data('transform.get_profile_column', $filter , 25,0, $order_by);
			//var_dump();
			return $data[0]->kolom;
		}
		
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
	public function insert_update_data($table,$data,$filter = array())
	{
		
		$count = $this->count_all_data($table,$filter);
		
		if($count == 0)
		{
			$this->insert_data($table,$data);
		}else
		{
			$this->update_data($table, $filter, $data);
		}
		
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
		$sql = $this->db->query("select * from getdata_alert_pengukuran2('$satu', '$dua', '$tiga', '$empat' , '$lima')");
		
		if($sql->num_rows > 0){
			return $sql->result();
		} else{
			return false;
		}			
	}
	
	public function total_func ($satu, $dua, $tiga, $empat, $lima)
	{	 
		$sql = $this->db->query("select * from getdata_alert_pengukuran2('$satu', '$dua', '$tiga', '$empat' , '$lima')");		
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

	public function get_tgid($table,$column,$whereid)
	{
		
		$hasil_query = $this->db->query("select ".$column." from ".$table." where rowid  = ".$whereid);
		
		$hasil = $hasil_query->result();
		$data	= array(
					"get_id"	 => $hasil[0]->$column
		);
		return $data;
	}
	
	public function getmodeltype($view)
	{
		$query = $this->db->query($view);
		$n=0;
		foreach($query->field_data() as $field)
		{
			//$data[]['name'] = $field->name;
			if($field->type == 'numeric') 
			{
				$data[$n]  = array("name"	=> $field->name, "type"	=> "number");
			}else
			{
				$data[$n]  = array("name"	=> $field->name, "type"	=> $field->type);
			}
			if($field->type == 'date')
			{
				$data[$n]  = array("name"	=> $field->name
							, "type"	=> $field->type
							,"dateFormat"	=> 'Y-m-d');
			}
			
			//$data[]['type'] = $field->type;
			$n++;
		}
		return json_encode($data);
	}
	
	
}
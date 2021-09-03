<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Masterdata extends MY_Controller {
	function __construct()
       {
        parent::__construct();
		$this->load->model('b_model');
       }
	   
	public	function index()
	{
		vd::dump('OK');
	}
	
	public function create()
	{		
		$rowid = $this->input->post('rowid',true);
		if( !empty($rowid) )
		{
			$this->update();
		} else
		{
			$data = array
			(
				'description' => $this->input->post('description',true),
				'email'		=> $this->input->post('email',true),
				'isinfo'	=> $this->input->post('isinfo',true),
				'subject'	=> $this->input->post('subject',true),
				'template'	=> $this->input->post('template',true)				
			);
	
			$this->b_model->insert_data('general_info', $data);	
			// vd::dump($data);		}	} 
	
	public function update_email()
	{
		$username =  $this->session->userdata('username');						$user_id =  $this->session->userdata('user_id');						$nama =  $this->session->userdata('nama');						$date_now = date('Y-m-d h:i:s');			
		$rowid = $this->input->post('rowid',true);
		$user_by  = ($rowid == '0' ? 'create_by' : 'update_by');		$user_date = ($rowid == '0' ? 'create_date' : 'update_date');				if($rowid == '0'){			
			$data = array(							'name'	=> $this->input->post('name',true),							'active'	=> $this->input->post('active',true),							'subject'	=> $this->input->post('subject',true),							'reffevent'	=> $this->input->post('reffevent',true),							'refftipesurat'	=> $this->input->post('refftipesurat',true),
							'reffstatus'	=> $this->input->post('reffstatus',true),							$user_by => $username,							$user_date => $date_now						);			$this->b_model->insert_data('email_template',$data);		}		else{			$data = array(							'name'	=> $this->input->post('name',true),							'active'	=> $this->input->post('active',true),							'subject'	=> $this->input->post('subject',true),							'reffevent'	=> $this->input->post('reffevent',true),							'refftipesurat'	=> $this->input->post('refftipesurat',true),
							'reffstatus'	=> $this->input->post('reffstatus',true),							$user_by => $username,							$user_date => $date_now			);									$filter[0]['field'] = "rowid";			$filter[0]['data'] = array("comparison"	=> "eq",								   "type"		=> "string",								   "value"		=> $this->input->post('rowid'));			$this->b_model->update_data('email_template', $filter ,$data);		}
		}
	
	public function update_template()
	{
		$username =  $this->session->userdata('username');				
		$user_id =  $this->session->userdata('user_id');				
		$nama =  $this->session->userdata('nama');				
		$date_now = date('Y-m-d h:i:s');
			
			$data = array(
							'template'	=> $this->input->post('template',true),
							'update_by' => $username,
							'update_date' => $date_now
						);
						
			$filter[0]['field'] = "rowid";
			$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $this->input->post('rowid'));
			$this->b_model->update_data('email_template', $filter ,$data);
		
	
	}
	
	public function deletedata()
	{
		$this->load->model('b_model');
		$this->load->helper('security');
					
		$filter = $this->input->post('filter', TRUE) > '' ? $this->input->post('filter', TRUE) : array();
		$table = $this->input->post('tbl');
		$log = $this->b_model->delete_data($table, $filter);
		
		$json   = array( 'success' => $log
		);					
		echo json_encode($json);
	}
	
	public function insert_vendor()
	{
		$username =  $this->session->userdata('username');				
		$user_id =  $this->session->userdata('user_id');				
		$nama =  $this->session->userdata('nama');				
		$date_now = date('Y-m-d h:i:s');
			
		$rowid = $this->input->post('rowid',true);
		$user_by  = ($rowid == '0' ? 'create_by' : 'update_by');
		$user_date = ($rowid == '0' ? 'create_date' : 'update_date');
		
		if($rowid == null){
			
			$data = array(
							'nama_vendor'	=> $this->input->post('nama_vendor',true),
							'npwp'	=> $this->input->post('npwp',true),
							'alamat'	=> $this->input->post('alamat',true),
							$user_by => $username,
							$user_date => $date_now
						);
			$this->b_model->insert_data('tb_vendor',$data);
		}
		else{
			$data = array(
							'nama_vendor'	=> $this->input->post('nama_vendor',true),
							'npwp'	=> $this->input->post('npwp',true),
							'alamat'	=> $this->input->post('alamat',true),
							$user_by => $username,
							$user_date => $date_now
			);
						
			$filter[0]['field'] = "rowid";
			$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $rowid);
			$this->b_model->update_data('tb_vendor', $filter ,$data);
		}
	
	}
	public function insert_pic()
	{
		$username =  $this->session->userdata('username');				
		$user_id =  $this->session->userdata('user_id');				
		$nama =  $this->session->userdata('nama');				
		$date_now = date('Y-m-d h:i:s');
			
		$rowid = $this->input->post('rowid',true);
		$user_by  = ($rowid == '0' ? 'create_by' : 'update_by');
		$user_date = ($rowid == '0' ? 'create_date' : 'update_date');
		
		if($rowid == null){
			
			$data = array(
							'nama'	=> $this->input->post('nama',true),
							'jabatan'	=> $this->input->post('jabatan',true),
							'reffvendor'	=> $this->input->post('reffvendor',true),
							$user_by => $username,
							$user_date => $date_now
						);
			$this->b_model->insert_data('tb_vendordir',$data);
		}
		else{
			$data = array(
							'nama'	=> $this->input->post('nama',true),
							'jabatan'	=> $this->input->post('jabatan',true),
							'reffvendor'	=> $this->input->post('reffvendor',true),
							$user_by => $username,
							$user_date => $date_now
			);
						
			$filter[0]['field'] = "rowid";
			$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $rowid);
			$this->b_model->update_data('tb_vendordir', $filter ,$data);
		}
	
	}
}
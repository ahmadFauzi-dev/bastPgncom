<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Settings extends MY_Controller {
	function __construct()
       {
            parent::__construct();
			$this->output->set_header("HTTP/1.0 200 OK");
			$this->output->set_header("HTTP/1.1 200 OK");
			$this->output->set_header('Last-Modified: '.gmdate('D, d M Y H:i:s', $last_update).' GMT');
			$this->output->set_header("Cache-Control: no-store, no-cache, must-revalidate");
			$this->output->set_header("Cache-Control: post-check=0, pre-check=0");
			 $this->output->set_header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); 
			$this->output->set_header("Pragma: no-cache");
            // Your own constructor code
		$this->load->model('b_model');
		$this->load->helper('path');
       }
	public	function index()
	{
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
		$node = $this->input->get('node');
		$groupid = $this->input->get('group_id');
	  
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'sort desc';
	    }
		if($node == 'root')
		{
			//var_dump($node);
			$filter[0]['field'] = "parent";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> "0");									   //var_dump($filter);						   
		}else
		{
			$filter[0]['field'] = "parent";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> intval(substr($node,3)));		
		}
		$dataas = $this->b_model->get_all_data('showmenu', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('showmenu', $filter);
		$n=0;
		//var_dump($dataas);
		foreach ($dataas as $row) {
		
			$data[$n] = new stdClass();
			$filteras[0]['field'] = "parent";
			$filteras[0]['data']  = array("comparison"		=> "eq",
										"type"				=> "numeric",
										"value"				=> intval($row->id));
									 
			$count		 = $this->b_model->count_all_data('showmenu', $filteras);
			//var_dump($count);
			if($count > 0 )
			{		
				$data[$n]->leaf = false;
				$data[$n]->expanded = true;
				//$data[$n]->children = $this->getchild('v_sbuarea',$filteras);
			}else
			{
				$data[$n]->leaf = true;
				//$data[$n]->expanded = true;
			}			
			$data[$n]->id = "sid".$row->id;
			$data[$n]->text	= $row->text;
			$data[$n]->act	= $row->act;
			$data[$n]->iconCls = $row->iconcls;
			$data[$n]->path = $row->path;
			//$dataleaf = $row->leaf === 'True'? True: False;
			$filtermenupriv[0]['field'] = "group_id";
			$filtermenupriv[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> $groupid );
			
			$filtermenupriv[1]['field'] = "menu_id";
			$filtermenupriv[1]['data']  = array("comparison"	=> "eq",
												"type"			=> "numeric",
												"value"			=> intval($row->id));
			$count = $this->b_model->count_all_data('permission', $filtermenupriv);
			
			if($count > 0)
			{
				$data[$n]->checked = true;
			}else
			{
				$data[$n]->checked = false;
			}
			
			//var_dump($row->leaf);
			//if($row->leaf == "TRUE")
			
			$data[$n]->parent = $row->parent;
			$n++;
		}
		
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			'total'     => $count,
			'data'      => $data
		);
		echo json_encode($json);
	}
	public function showgroup()
	{
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
		$node = $this->input->get('node');
	    //var_dump($node);
		
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'sort desc';
	    }
		
		$filter = array();
		
		
		
		$dataas = $this->b_model->get_all_data('v_group_permission', $filter , $limit, $offset, '');
		//$datasbu = $this->b_model->get_all_data('');
		$count = $this->b_model->count_all_data('v_group_permission', $filter);
		$n=0;
		//var_dump($dataas);
		foreach ($dataas as $row) {
			$data[] = $row;
			$n++;
		}
		
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			'total'     => $count,
			'data'      => $data
		);
		
		echo json_encode($json);
	}
	public function showaccarea()
	{
	
		//echo "OK";
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
		$node = $this->input->get('node');
	   
		
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'id desc';
	    }
		
		$filter = array();
		
		if($node == 'root')
		{
		
			$filter[0]['field'] = "parent";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> '0');
							   
		}else
		{
			$filter[0]['field'] = "parent";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> $node);
		}
				   
		$dataas = $this->b_model->get_all_data('v_sbuarea', $filter , $limit, $offset, '');
		
		$count = $this->b_model->count_all_data('v_sbuarea', $filter);
		$n=0;
		$filtersbu	= $this->input->get('filtersbu', TRUE);
		$datasbu 	= $this->b_model->get_all_data('group_permission', $filtersbu , $limit, $offset, '');
		$rd 		= json_decode($datasbu[0]->canrd);
		$area 		= json_decode($datasbu[0]->canarea);
		
		foreach ($dataas as $row) {
			$data[] = $row;
			$data[$n]->checked = false;
			$filteras[0]['field'] = "parent";
			$filteras[0]['data']  = array("comparison"		=> "eq",
									    "type"				=> "numeric",
									    "value"				=> $row->id);
									 
			$count		 = $this->b_model->count_all_data('v_sbuarea', $filteras);
			if($count > 0 )
			{
				$data[$n]->leaf = false;
				$data[$n]->expanded = true;
				//$data[$n]->children = $this->getchild('v_sbuarea',$filteras);
			}else
			{
				$data[$n]->leaf = true;
				//$data[$n]->expanded = true;
			}
			
			if($row->parent == '0')
			{
				foreach($rd as $rdrow)
				{
					
					if($row->id == $rdrow->id)
					{
						$data[$n]->checked = true;
					}
				}
				//$key = array_search($row->id, array_column($rd, 'id'));	
				//var_dump($key);
			}else
			{
				
				foreach($area as $arearow)
				{
					
					
					if($row->id == $arearow->id)
					{
						$data[$n]->checked = true;
					}
				}
				
			}
			
			
			$n++;
		}
		
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			//'total'     => $count,
			'data'      => $data
		);
		
		echo json_encode($json);
	}
	function getchild($tbl,$filter)
	{
		$child		 = $this->b_model->get_all_data($tbl, $filter , 1000, 0, '');
		$data 		 = array();
		$n 			 = 0;
		//var_dump($filter);
		//die();
		foreach($child as $row)
		{
				$filterchild[0]['field'] = "parent";
				$filterchild[0]['data']  = array("comparison"	=> "eq",
												 "type"			=> "numeric",
												 "value"		=> $row->id);
				$count		 = $this->b_model->count_all_data($tbl, $filterchild);
				if($count > 0)
				{	
					$child[$n]->leaf = false;
					$child[$n]->expanded = true;
					$child[$n]->children = $this->getchild($tbl,$filterchild);
				}else
				{
					$child[$n]->leaf = true;
				}
			$n++;
		}
		return $child;
		
	}
	public function cekrecursive()
	{
		 $this->load->model('b_model');
		 $filter = array();
		 $filter[0]['field'] = "parent";
		 $filter[0]['data']  = array("comparison"	=> "eq",
									 "type"				=> "string",
									 "value"				=> '0');
									 
		 $dataas = $this->b_model->get_all_data('menu', $filter , 1000, 0, '');
		 $n=0;
		 foreach ($dataas as $row) {
			//echo "okok";
			$data[$n]->text = $row->name;
			$data[$n]->count = $count;
			$filter[0]['field'] = "parent";
			$filter[0]['data']  = array("comparison"	=> "eq",
									 "type"				=> "string",
									 "value"				=> $row->idmenu);
									 
			$count		 = $this->b_model->count_all_data('menu', $filter);
			
			if($count > 0 )
			{
				$data[$n]->leaf = false;
				$data[$n]->children = $this->getchild('menu',$filter);
			}else
			{
				$data[$n]->leaf = true;
			}
			
			$n++;
		 }
		 
	}
	public function showevent()
	{
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
		$node = $this->input->get('node');
		$groupid 		= $this->input->get('group_id');
		//echo $groupid;
	    //var_dump($node);
		
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'id desc';
	    }
		if($filter == false)
		{
			$filter = array();
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		
		
		$dataas = $this->b_model->get_all_data('eventmenu', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('eventmenu', $filter);
		$n=0;
		//var_dump($dataas);
		foreach ($dataas as $row) {
			$data[] = $row;
			$data[$n]->checked = false;
			
			$data[$n]->checked = false;
			$filtercountacc[0]['field'] = "group_id";
			$filtercountacc[0]['data']  = array("comparison"		=> "eq",
									    "type"				=> "numeric",
									    "value"				=> $groupid);
			
			$filtercountacc[1]['field'] = "menu_id";
			$filtercountacc[1]['data']  = array("comparison"		=> "eq",
									    "type"				=> "numeric",
									    "value"				=> $row->menu_id);
			
			$filtercountacc[2]['field'] = "role_menu_event_id";
			$filtercountacc[2]['data']  = array("comparison"		=> "eq",
									    "type"				=> "numeric",
									    "value"				=> $row->event_id);	
									 
			$count		 = $this->b_model->count_all_data('role_menu_event', $filtercountacc);
			
			
			if($count > 0 )
			{
				$data[$n]->checked = true;	
			}
			$n++;
		}
		
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			'total'     => $count,
			'data'      => $data
		);
		
		echo json_encode($json);
	}
	public function showeventmenustat()
	{
		$this->load->model('b_model');
		$limit 			= $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset 		= $this->input->get('start', TRUE);
	    $filter 		= $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts 			= json_decode($this->input->get('sort', TRUE));
		$node 			= $this->input->get('node');
		$idmenu 		= $this->input->post('id');
		$groupid 		= $this->session->userdata('id_group');
		
		//$group = 
	   
		
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'id desc';
	    }
		
		$filter[0]['field'] 	= "menu_id";
		$filter[0]['data'] 		= array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> intval($idmenu));
								   
		$filter[1]['field'] 	= "group_id";
		$filter[1]['data'] 		= array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> intval($groupid));						   
		
		
	   
		$dataas = $this->b_model->get_all_data('v_role_menu_event', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('v_role_menu_event', $filter);
		$n=0;
		
		//var_dump($dataas);
		$data = '{';
		foreach ($dataas as $row) {
			$filterrole[0]['field'] 	= "menu_id";
			$filterrole[0]['data'] 		= array("comparison"	=> "eq",
												"type"		=> "numeric",
												"value"		=> intval($idmenu));
								   
			$filterrole[1]['field'] 	= "group_id";
			$filterrole[1]['data'] 		= array("comparison"	=> "eq",
												"type"		=> "numeric",
												"value"		=> intval($groupid));

			$filterrole[2]['field'] 	= "role_menu_event_id";
			$filterrole[2]['data'] 		= array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> intval($row->role_menu_event_id));						
			
			$count = $this->b_model->count_all_data('role_menu_event', $filterrole);
			
			if($count == 0)
			{
				$data .= '"'.$row->event_name.'" : true,';
			}else
			{
				$data .= '"'.$row->event_name.'" : false,';
			}
			$n++;
		}
		
		$data = substr($data,0,-1);
		$data .= '}';
		
		/*
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			'total'     => $count,
			'data'      => $data
		);
		*/
		echo json_encode($data);
		//echo $data;
	}
	public function showuser()
	{
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
		$node = $this->input->get('node');
	    //var_dump($node);
		
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'id desc';
	    }
		if($filter == false)
		{
			$filter = array();
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		
		
		$dataas = $this->b_model->get_all_data('rev_user', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('rev_user', $filter);
		$n=0;
		//var_dump($dataas);
		foreach ($dataas as $row) {
			$data[] = $row;
			//$data[$n]->checked = false;
			$n++;
		}
		
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			'total'     => $count,
			'data'      => $data
		);
		
		echo json_encode($json);
	}
	public function insertevent()
	{
		$this->load->model('b_model');
		$data = array("event_name"	=> $this->input->post('event_name'),
					 "menu_id"		=> intval(substr($this->input->post('menu_id'),3)));
					 
		//var_dump($data);			 
		$res = $this->b_model->insert_data('eventmenu', $data);			 
		//echo "OKOKOK";
		echo $res;
	}
	public function addmenu()
	{
		$this->load->model('b_model');
		$data = array("name"	=> $this->input->post('name'),
					 "act"		=> $this->input->post('act'),
					 "parent"	=> intval(substr($this->input->post('parent'),3)),
					 "iconcls"	=> $this->input->post('iconcls'),
					 "path"		=> $this->input->post('path'),
					 "leaf"		=> 'FALSE');
		//var_dump($data);			 
		$res = $this->b_model->insert_data('menu', $data);			 
		//echo "OKOKOK";
		echo $res;
	}
	public function insertevenmenuevent()
	{
		$this->load->model('b_model');
		$data = json_decode($this->input->post('data'));
		
		
		$filter[0]['field'] = "role_menu_event_id";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> $data[0]->role_menu_event_id);
		
		$filter[1]['field'] 	= "menu_id";
		$filter[1]['data'] 		= array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> $data[0]->menu_id);
		
		$filter[2]['field'] 	= "group_id";
		$filter[2]['data'] 		= array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> $data[0]->group_id);	
		$this->b_model->delete_data('role_menu_event', $filter);
		
		//$this->b_model->insert_batch('permission',);
		
		
		if($this->input->post('dataopts') == "true")
		{
			
			foreach($data as $row)
			{
				
				$this->b_model->insert_data('role_menu_event', $row);
			}
		}
	}
	public function getmodel()
	{
		$view = $this->input->post('view');
		$this->load->model('b_model');
		$res = $this->b_model->getmodel($view);			
		echo $res;
		//var_dump($res);
		
	}
	public function getmodelquery()
	{
		$view = $this->input->post('view');
		$this->load->model('b_model');
		$res = $this->b_model->getmodelquery($view);			
		echo $res;
	}
	public function getcolumnquery()
	{
		$view = $this->input->post('view');
		$this->load->model('b_model');
		$res = $this->b_model->getcolumnquery($view);	
		//echo $view;
		echo $res;
	}
	public function getcolumn()
	{
		$view = $this->input->post('view');
		$id_grid = $this->input->post('id_grid');
		
		$this->load->model('b_model');
		$res = $this->b_model->getcolumn($view,$id_grid);			
		echo $res;
	}
	public function cekdata()
	{
		$path = substr(BASEPATH,0,-7);
		$path2 = FCPATH;
		var_dump($path);
		var_dump($path2);
	}
	public function updategroup()
	{
		var_dump($this->input->post('group_id',true));
		//die();
		if($this->input->post('group_id',true))
		{
			$filter[0]['field'] = "group_id";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $this->input->post('group_id'));
			
			$dataupdate = array("name"			=> $this->input->post('name'),
						 "koordinatoruser"	=> $this->input->post('koordinatoruser'),						 "id_perusahaan"	=> $this->input->post('id_perusahaan')			);
			
			$this->b_model->update_data('group_permission', $filter ,$dataupdate);
		}else
		{
			
			$data = array("name"			=> $this->input->post('name'),
						 "koordinatoruser"	=> $this->input->post('koordinatoruser'));
			$this->b_model->insert_data('group_permission', $data);	
		}
	}
	public function updateusergroup()
	{		$filter[1]['field'] = "username";
		$filter[1]['data']  = array("comparison"		=> "eq",
								 "type"					=> "string",
								 "value"				=> $this->input->post('username'));						 
								 
		$count		 = $this->b_model->count_all_data('v_revuser', $filter);
				$passx = $this->input->post('passx',true);		$pass	  = sha1(sha1(md5($passx)));				$user_id = $this->input->post('user_id',true);								if($user_id == null)
		{			$data_insert = array("username"	=> $this->input->post('username'),							 "usernameldap"	=> $this->input->post('usernameldap'),								 "nama"			=> $this->input->post('nama'),												 "password"			=> $pass,												 "groupid"		=> $this->input->post('groupid'),								 "email"		=> $this->input->post('email'),								 "active"		=> $this->input->post('active'),								 "reffjabatan"		=> $this->input->post('reffjabatan')			);			
			$this->b_model->insert_data('rev_users', $data_insert);						 
		}else
		{
			if($passx == null){				$data_update = array("username"	=> $this->input->post('username'),									"usernameldap"	=> $this->input->post('usernameldap'),									"nama"			=> $this->input->post('nama'),									"groupid"		=> $this->input->post('groupid'),									"email"		=> $this->input->post('email'),									"active"		=> $this->input->post('active')
				);			}			else{				$data_update = array("username"	=> $this->input->post('username'),									"usernameldap"	=> $this->input->post('usernameldap'),									"nama"			=> $this->input->post('nama'),									"password"			=> $pass,									"groupid"		=> $this->input->post('groupid'),									"email"		=> $this->input->post('email'),									"active"		=> $this->input->post('active')				);			}						$filterupd[0]['field'] = "user_id";			$filterupd[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $user_id);			
			$this->b_model->update_data('rev_users', $filterupd ,$data_update);					 
		}
		$json   = array(			'success'   => TRUE,			'message'   => "Loaded data",		);		echo json_encode($json);
	}
	public function getticket2()	{
		
		$server = '192.168.104.167:8000';
		$url = 'http://'.$server.'/trusted';
		$fields_string ='username=user';

		$ch = curl_init();      
		curl_setopt($ch,CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_HTTPHEADER, array('Accept-Encoding: gzip'));
		curl_setopt($ch,CURLOPT_POST, 1);
		curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);
		curl_exec($ch);
		
		curl_close($ch);
	}
	public function savecolumn()
	{
		$params = array("id_grid"	=> $this->input->post('id')
						,"ptbl"		=> $this->input->post('view')
						,"kolom"	=> $this->input->post('columns')
		);
		$filterup[0]['field'] = "id_grid";
		$filterup[0]['data'] = array("comparison"	=> "eq",
								   "type"			=> "string",
								   "value"			=> $this->input->post('id'));
		
								   
		$this->b_model->insert_update_data('transform.get_profile_column', $params,$filterup);		
	}
}
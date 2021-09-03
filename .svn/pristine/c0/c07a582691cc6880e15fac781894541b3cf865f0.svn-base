<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Admin extends MY_Controller {
	public function __construct()
       {
            parent::__construct();
			$this->output->set_header("HTTP/1.0 200 OK");
			$this->output->set_header("HTTP/1.1 200 OK");
			// $this->output->set_header('Last-Modified: '.gmdate('D, d M Y H:i:s', $last_update).' GMT');
			$this->output->set_header("Cache-Control: no-store, no-cache, must-revalidate");
			$this->output->set_header("Cache-Control: post-check=0, pre-check=0");
			 $this->output->set_header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); 
			$this->output->set_header("Pragma: no-cache");
            // Your own constructor code
       }
	
public function index()
	{
		$user_id = $this->session->userdata('user_id');	
		$username = $this->session->userdata('username');	
		$nama_karyawan = $this->session->userdata('nama');	
		
		$data	= array(
			"user_id"		=> $user_id,
			"username"		=> $username,
			'nama_karyawan' => $nama_karyawan
		);
		
		 if($username!=''){
		 	$this->load->view('admin',$data);
		 }
		 else {
			redirect('login');	
		 }
	}
	function cekanomalidailyf($sts,$tgl)
	{
		$this->load->model('m_admin');	
		$role 		 = $this->m_admin->listrolems();
		$stations	 = $this->m_admin->checkstation();
		
		$cek_data;
		$n			 = 0;
		
		//$tgl = '2016-04-01';
		
		//foreach($stations as $st)
		//{
			$str2 = '';
			$sts = $sts;
			//$sts = 27;
			
			$data 	     = $this->m_admin->listGridDailycek($sts,$tgl);
			$role 		 = $this->m_admin->listrolems();
			$res;
			foreach($role as $role_id)
			{
				$cek_data2 = $this->m_admin->showdetailrole($role_id->id);
				$cek_data[$n]->formula = $cek_data2;
				$cek_data[$n]->role_id = $role_id->id;
				
				$jumlah = count($cek_data2);
				
				$n++;
			}
			
			$a=0;
			$b=0;
			//$data_before;
			//$data = array();
			$datares = array();
			foreach($data as $row)
			{
				$data_before;
				$str = '';
				$str2 = '';
				$jml_before = count($data_before);
				$sum = $this->m_admin->ceksum($sts,$tgl);
				$dp  = $this->m_admin->cekdup($sts,$tgl);
				$c = (floatval($row->temperature) - 32) * (5/9);
				
				$sumdailyvol = floatval($sum[0]->totalizer_volume);
				//$datares = array("id_station" => $row->stationid);
				foreach($cek_data as $cek)
				{
					$jumlah = count($cek);
					//$datares['id_station'] = array ($cek->role_id);
					foreach($cek->formula as $var)
					{
						$data_parameter = trim($var->formula);
						var_dump($data_parameter);
						$data_parameter = str_replace("Flow_Rateduplicate",$dp[0]->volume,$data_parameter);
						$data_parameter = str_replace("Rate_Energyduplicate",$dp[0]->energy,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Totalizerduplicate",$dp[0]->counter_volume,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Energyduplicate",$dp[0]->counter_energy,$data_parameter);
						$data_parameter = str_replace("Pressure_Outletduplicate",$dp[0]->pout,$data_parameter);
						$data_parameter = str_replace("Tempratureduplicate",$dp[0]->temperature,$data_parameter);
						$data_parameter = str_replace("Prev_Day_GHVduplicate",$dp[0]->ghv,$data_parameter);
						$data_parameter = str_replace("Volume_Daily","". number_format((floatval($row->volume) / 1000) , 2)."","".$data_parameter."");
						$data_parameter = str_replace("SUM_Daily","".number_format((floatval($sumdailyvol)),2)."","".$data_parameter."");
						$data_parameter = str_replace("Temprature",$c,"".$data_parameter."");
						$data_parameter = str_replace("Flow_Rate","".$row->volume."","".$data_parameter."");
						$data_parameter = str_replace("Rate_Energy",$row->energy,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Totalizer",$row->counter_volume,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Energy",$row->counter_energy,$data_parameter);
						$data_parameter = str_replace("Pressure_Outlet",$row->pout,$data_parameter);
						$data_parameter = str_replace("Temprature",$row->temperature,$data_parameter);
						$data_parameter = str_replace("Prev_Day_GHV",$row->ghv,$data_parameter);
						
						//$datares = array($row->stationid => array ($cek->role_id => true));
						if(eval($data_parameter) == true)
						{
							//$datares[$row->stationid][$cek->role_id] = array ("val" => 1,
							//								   "bolval" => eval($data_parameter));
															   
							$datares[$row->rowid][$cek->role_id] = 1;								   
						}else
						{
							
							$datares[$row->rowid][$cek->role_id] = 0;								   
						
						}
						
						$datares[$row->rowid]['115107'] = 1;	
						$datares[$row->rowid]['115111'] = 1;	
						
					}
					$b++;	
				}
				
				$a++;
				$data_before = $row;
				$juml = 0;
				
			}
			
			foreach($datares as $upd)
			{
				//var_dump($upd);
				
				$a = array_keys($datares);
				$b = array_keys($upd);
				//var_dump($upd['115107']);
				
				$juml = 0;
				$n=0;
				$filter[0]['field'] = "reffrowid";
				$filter[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $a[0]);
										   
				$this->b_model->delete_data('tbl_detailerrormessage', $filter);
				
				
				$data_input = array ("reffrowid"	=> $a[0],
									 "reffroleid"	=> '115106',
									 "value"		=> $upd['115106']);
									 
				$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
				
				$data_input = array ("reffrowid"	=> $a[0],
									 "reffroleid"	=> '115107',
									 "value"		=> $upd['115107']);
									 
				$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
				
				$data_input = array ("reffrowid"	=> $a[0],
									 "reffroleid"	=> '115111',
									 "value"		=> $upd['115111']);
									 
				$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
				
				$data_input = array ("reffrowid"	=> $a[0],
									 "reffroleid"	=> '115110',
									 "value"		=> $upd['115110']);
									 
				$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
				
				
				$data_input = array ("reffrowid"	=> $a[0],
									 "reffroleid"	=> '115112',
									 "value"		=> $upd['115112']);
									 
				$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
				
				$data_input = array ("reffrowid"	=> $a[0],
									 "reffroleid"	=> '115113',
									 "value"		=> $upd['115113']);
									 
				$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
				foreach($upd as $r)
				{
					
					//$r = $r + $r;
					$juml = $r+$juml;
					//var_dump($r);
					$n++;
				}
				$jc = $juml/$n;
				if($juml/$n == 1 )
				{
					$jc = 1;
				}else
				{
					$jc = 0;
				}
				
				$filter[0]['field'] = "rowid";
				$filter[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $a[0]);
				$data = array("statusdata"	=> $jc);		
							 
				$this->b_model->update_data('realisasipenyaluranstationdaily', $filter ,$data);
				
				
			}
			
		//}
	}
	
	function cekanomalihourlyf($sts,$tgl)
	{
		//echo "OK";
		$this->load->model('m_admin');	
		$this->load->model('b_model');	
		$role 		 = $this->m_admin->listrolems();
		
		$cek_data;
		$n			 = 0;
		$stations	 = $this->m_admin->checkstation();
		//$tgl = '2016-05-09';
		//echo $tgl;
		$n			 = 0;
		$datares = array();
		
			
			//$sts = $sts->reffidstation;
			$sts;
			
			$data 	     = $this->m_admin->listGridHourlycek($sts,$tgl);
			$role 		 = $this->m_admin->listrolems();
			//$datares = array();
			foreach($role as $role_id)
			{
				$cek_data2 = $this->m_admin->showdetailrole($role_id->id);
				$cek_data[$n]->formula = $cek_data2;
				$cek_data[$n]->role_id = $role_id->id;
				
				$jumlah = count($cek_data2);
				
				$n++;
			}
			
			
			foreach($data as $row)
			{
				$filter[0]['field'] = "reffrowid";
				$filter[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $row->rowid);
										   
				$this->b_model->delete_data('tbl_detailerrormessage', $filter);
				
				//$sum = $this->m_admin->ceksum($sts,$tgl);
				
				$dp  = $this->m_admin->cekduphourly($row->stationid,$row->tanggal_pengukuran);
				$c = (floatval($row->temperature) - 32) * (5/9);
				//$j=0;
				foreach($cek_data as $cek)
				{
					
					foreach($cek->formula as $var)
					{
						$data_parameter = trim($var->formula);
						$data_parameter = str_replace("Flow_Rateduplicate","".$dp[0]->mmscfd."","".$data_parameter."");
						$data_parameter = str_replace("Rate_Energyduplicate","".$dp[0]->totalizer_mmbtu."","".$data_parameter."");
						$data_parameter = str_replace("Previous_Hourly_Net_Totalizerduplicate","".$dp[0]->totalizer_volume."","".$data_parameter."");
						$data_parameter = str_replace("Previous_Hourly_Net_Energyduplicate","".$dp[0]->totalizer_energy."","".$data_parameter."");
						$data_parameter = str_replace("Pressure_Outletduplicate","".$dp[0]->pressureoutlet."","".$data_parameter."");
						$data_parameter = str_replace("Tempratureduplicate","".$dp[0]->temperature."","".$data_parameter."");
						//$data_parameter = str_replace("Prev_Day_GHVduplicate","".$dp->prevdayghv."","".$data_parameter."");
						$data_parameter = str_replace("Temprature",$c,"".$data_parameter."");
						$data_parameter = str_replace("Flow_Rate","".$row->mmscfd."","".$data_parameter."");
						$data_parameter = str_replace("Rate_Energy",$row->totalizer_mmbtu,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Totalizer",$row->totalizer_volume,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Energy",$row->totalizer_energy,$data_parameter);
						$data_parameter = str_replace("Pressure_Outlet",$row->pressureoutlet,$data_parameter);
						$data_parameter = str_replace("Temprature",$row->temperature,$data_parameter);
						$data_parameter = str_replace("Prev_Day_GHV",$row->prevdayghv,$data_parameter);
						$data_parameter = str_replace($row->prevdayghv."duplicate",$row->prevdayghv."1",$data_parameter);
						
						if(eval($data_parameter) == true)
						{
							
							$datares[$row->rowid][$cek->role_id] = 1;
							
							$data_input = array ("reffrowid"	=> $row->rowid,
												"reffroleid"		=> $cek->role_id,
												"value"			=> 1);
									 
							//$this->b_model->insert_data('tbl_detailerrormessage', $data_input);	
											
						}else
						{
							
							if($cek->role_id == "115106")
							{
								
							}
							$datares[$row->rowid][$cek->role_id] = 0;
								
							
									 
							//$this->b_model->insert_data('tbl_detailerrormessage', $data_input);	
						
						}
						
						$datares[$row->rowid]['115106'] = 1;
						$datares[$row->rowid]['115107'] = 1;
						$datares[$row->rowid]['115111'] = 1;
						
						$data_input = array ("reffrowid"	=> $row->rowid,
											"reffroleid"	=> '115107',
											 "value"		=> 1);
									 
						//$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
						
						$data_input = array ("reffrowid"	=> $row->rowid,
											"reffroleid"	=> '115111',
											 "value"		=> 1);
									 
						//$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
						
						$data_input = array ("reffrowid"	=> $row->rowid,
											"reffroleid"	=> '115106',
											 "value"		=> 1);
									 
						//$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
						
						$n++;
						$j++;
					}
					if($datares[$row->rowid][$cek->role_id] !== null)
					{
						$data_input = array ("reffrowid"	=> $row->rowid,
											"reffroleid"	=> $cek->role_id,
											 "value"		=> $datares[$row->rowid][$cek->role_id]);
									 
						$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
						
					}
					
					
				}
				$dataupdate = 0;
				$hit = 0;
				
				foreach($datares[$row->rowid] as $rowdata)
				{
					
					$dataupdate = $dataupdate+$rowdata;
					$hit++;
				}
				
				$dataupdate = $dataupdate/$hit;
				
				if($dataupdate == 1)
				{
					$dataupdate = 1;
				}else
				{
					$dataupdate = 0;
				}
				
				$filter[0]['field'] = "rowid";
				$filter[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $row->rowid);
				$data = array("statusdata"	=> $dataupdate);		
							 
				$this->b_model->update_data('realisasipenyaluranstationhourly', $filter ,$data);
				//echo $dataupdate."------------------------------------";
				
			}
			$n=0;
			
			 
			
			
		//}
	
		
	}
	public function listParent()
	{
		$this->load->model('m_admin');
		$this->m_admin->listParent();	
	}
	
	public function listMenu()
	{
		$username = $this->session->userdata('username');
		$level 	  = $this->session->userdata('level');
		$node 	  = $_GET['node'];
		$this->load->model('m_admin');
		$this->m_admin->listMenu($node,$username);
	}
	
	public function showMenu()
	{
		$groupid = $this->session->userdata('id_group');
		
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
		//
		
		if($node == 'root')
		{
			//var_dump($node);
			$filter[0]['field'] = "parent";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> "0");
									   
								   
			//var_dump($filter);						   
		}else
		{
			$filter[0]['field'] = "parent";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> intval($this->input->post('node')));
			
		}
		
		$filter[1]['field'] = "group_id";
		$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> $groupid);	
									   
		$dataas = $this->b_model->get_all_data('v_menu', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('v_menu', $filter);
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
				//$data[$n]->expanded = true;
				//$data[$n]->children = $this->getchild('v_sbuarea',$filteras);
			}else
			{
				$data[$n]->leaf = true;
				//$data[$n]->expanded = true;
			}
			//$data[] = $row;
			
			
			$data[$n]->id = $row->idmenu;
			$data[$n]->text	= $row->name;
			$data[$n]->act	= $row->act;
			$data[$n]->iconCls = $row->iconcls;
			$data[$n]->path = $row->path;
			//$dataleaf = $row->leaf === 'True'? True: False;
			$data[$n]->checked = false;
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
		
		//$this->m_admin->showMenu($node,$username,$groupid);
	}
	
	public function showmenutree()
	{
		//$groupid = $this->session->userdata();
		$idMenu = $_GET['accp'];
		
		if($_GET['node']=='root'){			
			$node = 0;
		}
		else{
			$node = $_GET['node'];
		}
		
		$this->load->model('m_admin');
		$this->m_admin->showmenutree($node,$username,$idMenu);
		
	}
	
	public function listRoleType1()
	{
		$id = $_GET['id'];
		$this->load->model('m_admin');
		$this->m_admin->listRoleType1();
	}
	
	public function listRoleType()
	{
		$id = $_GET['id'];
		$this->load->model('m_admin');
		$this->m_admin->listRoleType($id);
	}
	
	public function listRoleBillType()
	{
		$start = $_GET['start'];
		$limit = $_GET['limit'];
		$role_id = $_GET['role_id'];
		$this->load->model('m_admin');
		$this->m_admin->listRoleBillType($role_id,$start,$limit);
	}
	
	public function add_role_bill()
	{
		$role_id = $_POST['id1'];
		$type_id = $_POST['id2'];
		$this->load->model('m_admin');
		$this->m_admin->add_role_bill($role_id,$type_id);
	}
	
	public function listRoleBill()
	{
		$start = $_GET['start'];
		$limit = $_GET['limit'];
		$this->load->model('m_admin');
		$this->m_admin->listRoleBill($start,$limit);
	}
	
	public function update_master()
	{
		$id = $_GET['id'];
		$tb = $_GET['tb'];
		$wr = $_GET['wr'];

		$data = array("type_name"			=> $this->input->post('type_name'),
					 "limit_code"			=> $this->input->post('limit_code'),
					 "detail_limit_code"	=> $this->input->post('detail_limit_code'),
					 "is_kontrak"			=> $this->input->post('is_kontrak'),
					 "formula"	    		=> $this->input->post('formula')
					 );
		
		$this->load->model('m_admin');
		
		if($id == 'undefined'){
			$this->m_admin->add_entry($data,$tb);
		}
		else{
			$this->m_admin->update_entry($data,$id,$tb,$wr);
		}
	}
	
	public function update_master_bill()
	{
		$id = $_GET['id'];
		$tb = $_GET['tb'];
		$wr = $_GET['wr'];

		$data = array("rule_code"			=> $this->input->post('rule_code'),
					 "description"			=> $this->input->post('description')
					 );
		
		$this->load->model('m_admin');
		
		if($id == 'undefined'){
			$this->m_admin->add_entry($data,$tb);
		}
		else{
			$this->m_admin->update_entry($data,$id,$tb,$wr);
		}
	}
	
	public function update_isaktif()
	{
		$id = $_GET['id'];
		$tb = $_GET['tb'];
		$wr = $_GET['wr'];

		$data = array("isaktif"	=> $this->input->post('isaktif'));
		
		$this->load->model('m_admin');
		$this->m_admin->update_entry($data,$id,$tb,$wr);
		
	}
	
	public function delete_entry()
	{
		//parametre
		$id		= $_GET['id'];
		$tb		= $_GET['tb'];
		$wr		= $_GET['wr'];
		$this->load->model('m_admin');	
		$this->m_admin->delete_entry($id,$tb,$wr);	
	}
	public function logout()
	{
		$this->session->unset_userdata('data_one');
		$this->session->unset_userdata('data_two');
		$this->session->unset_userdata('data_three');
		$this->session->sess_destroy();
		redirect('login');
	}
	public function listGridDaily()
	{
		$this->load->model('m_admin');	
		$this->m_admin->listGridDaily();	
	}
	public function listChartDaily()
	{
		ini_set('precision', '14');
		$this->load->model('m_admin');	
		$this->m_admin->listChartDaily();
	}
	public function listGridHourly()
	{
		$this->load->model('m_admin');	
		$role = $this->m_admin->listrolems();
		$data = $this->m_admin->listGridHourly();
	}
	
	public function insertEstimate()
	{
		foreach($this->input->post('parameter') as $row)
		{
			$data = array("rulename"	=> $this->input->post('rulename'),
					 "parameter"		=> $row,
					 "last"				=> $this->input->post('last'),
					 "timevalue"		=> $this->input->post('timevalue'),
					 "periodeparameter"	=> $this->input->post('periodeparameter'));
			$this->load->model('m_admin');	
			$this->m_admin->insertEstimate($data);		 
		};
		
					 
	}
	public function listRows()
	{
		$this->load->model('m_admin');	
		$this->m_admin->listRows();			 
	}
	public function genGridquery()
	{
		$this->load->model('m_admin');
		$path = $this->input->post('path');
		$contstore	= $this->input->post('contstore');
		$query 		= $this->input->post('query');
		$name		= $this->input->post('name');
		
		$col = $this->m_admin->genGrid($query);
		$columngrid = array();
		$n = 0;
		foreach($col as $datacol)
		{
			$columngrid[$n] = array("dataIndex"	=> $datacol,"text" => $datacol);
			$n++;	
		}
		
		$nama_model = "m".time()."grid";
		$store_grid = "s".time()."grid";
		
		//$path = substr(BASEPATH,0,-7)."asset/js/".$path."";
		$path = substr(BASEPATH,0,-7)."asset/js/content/master/view/gridlibmessageanomali";
		//echo $path;
		//var_dump($columngrid);
		//die();
		unlink($path);
		
		$str = "Ext.define('EM.tools.view.grid' ,{
				extend: 'Ext.grid.Panel',
				//alias : 'widget.formco',
				initComponent	: function()
				{
				Ext.define('".$nama_model."',{
					extend	: 'Ext.data.Model',
					fields	: ".json_encode($col)."
				});
	
			var ".$store_grid." = Ext.create('Ext.data.JsonStore',{
				model	: '".$nama_model."',
				proxy	: {
				type	: 'ajax',
				url		: base_url+'admin/".$store_grid."',
				reader: {
					type: 'json',
					root: 'data'
				}
				}
			});
			".$store_grid.".load();
			Ext.apply(this,{
				store		: ".$store_grid.",
				id			: 'gridDaily',
				columns		: ".json_encode($columngrid)."
			});
			this.callParent(arguments);
			}
		})";
		file_put_contents ($path, $str."\n", FILE_APPEND);
		
		
		$pathc = substr(BASEPATH,0,-7)."asset/js/content/master/gridlibmessageanomali.js";
		$strc = "function apps(name,iconCls)
				{
					Ext.require([
					'Ext.grid.*',
					'Ext.data.*',
					'Ext.util.*',
					'Ext.state.*'
					]);
					
					Ext.Loader.setConfig({
						enabled : true,
						paths: {
							'master'    : ''+base_url+'asset/js/content/master/'
						}
					
					});
					
					var grid = Ext.create('master.view.gridlibmessageanomali');
					
					var tabPanel = Ext.getCmp('contentcenter');
					var items = tabPanel.items.items;
					var exist = false;
					
					for(var i = 0; i < items.length; i++)
					{
						if(items[i].id == name){
								tabPanel.setActiveTab(name);
								exist = true;
						}
					}
					
					if(!exist){
							Ext.getCmp('contentcenter').add({
								title		: 'Estimasi Bulk Customer',
								id			: name,
								xtype		: 'panel',
								iconCls		: iconCls,
								closable	: true,
								overflowY	: 'scroll',
								bodyPadding: '5 5 0',
								items		: [{
									xtype 		: 'panel',
									title		: 'Jenis Station',
									bodyPadding	: 5,
									//width		: 600,
									margins		: '10',
									items		: grid
									//items		: []
								}]
							});
						tabPanel.setActiveTab(name);	
					}
				}";
		file_put_contents ($pathc, $strc."\n", FILE_APPEND);		
		//echo "OKO";
	}
	public function s453402284()
	{
		$this->load->model('m_admin');
		$query = "SELECT sbu from idx_sbu";
		$this->m_admin->listRows($query);	
	}
	public function s1453403912grid()
	{
		$this->load->model('m_admin');
		$query = 'SELECT name as Area, sbu  
					from idx_area
					join idx_sbu on idx_area.idx_sbu_id = idx_sbu.id';
		$this->m_admin->listRows($query);	
	}
	public function genGrid()
	{
		//echo "OKOK";
		$this->load->model('m_admin');	
		$col = $this->m_admin->genGrid();
		$columngrid = array();
		$n = 0;
		foreach($col as $datacol)
		{
			$columngrid[$n] = array("dataIndex"	=> $datacol,"text" => $datacol);
			$n++;	
		}
		json_encode($columngrid);
		//var_dump($columngrid);
		
		//var model = 
		//$model = "Ext.define"
		
		$nama_model = "m_grid";
		$store_grid = "s_grid";
		$path = substr(BASEPATH,0,-7)."asset/js/content/tools/view/test.js";
		unlink($path);
		$str = "Ext.define('EM.tools.view.grid' ,{
				extend: 'Ext.grid.Panel',
				//alias : 'widget.formco',
				initComponent	: function()
				{
				Ext.define('".$nama_model."',{
					extend	: 'Ext.data.Model',
					fields	: ".json_encode($col)."
				});
	
			var ".$store_grid." = Ext.create('Ext.data.JsonStore',{
			model	: '".$nama_model."',
			proxy	: {
			type	: 'ajax',
			url		: base_url+'admin/listRows',
			reader: {
				type: 'json',
				root: 'data'
			}
			}
			});
			".$store_grid.".load();
			Ext.apply(this,{
				store		: ".$store_grid.",
				id			: 'gridDaily',
				columns		: ".json_encode($columngrid)."
			});
			this.callParent(arguments);
			}
		})";
		file_put_contents ($path, $str."\n", FILE_APPEND);	
		var_dump($path);	
		//$rows = $this->m_admin->genrowsData();
	}
	public function srenderestimasi()
	{
		$this->load->model('m_admin');
		$this->m_admin->storeestimasirend();	
	}
	public function insertlibmessage()
	{
		$this->load->model('m_admin');
		$data = array("code_id"	=> $this->input->post('id'),
					 "Description"	=> $this->input->post('desc'),
					 "flaging"		=> $this->input->post('flaging'));
					 
		$this->m_admin->inserttb('ms_liberrorcode',$data);	
	}
	public function s1454310608grid()
	{
		$this->load->model('m_admin');
		$query = "SELECT * from ms_liberrorcode";
		$this->m_admin->listRows($query);	
	}
	public function addroledetail()
	{
		$this->load->model('m_admin');
		$data = array("id_ms_liberrorcode"	=> $this->input->post('idrole'),
					 "formula"		=> $this->input->post('formula'));
		$this->m_admin->inserttb('dt_msliberrcode',$data);				 
	}
	public function listDetailRole()
	{
		$this->load->model('m_admin');
		$id = $_GET['id_ms_liberrorcode'];
		
		$query = "select * from dt_msliberrcode where id_ms_liberrorcode = '".$id."'";
		$this->m_admin->listRows($query);
	}
	public function checkeval()
	{
		$string = "IF (9 == 5) {
				return TRUE;
		}else
		{
			return FALSE;
		}";
		$as = eval($string);
		
		//var_dump($as);
	}
	
	public function cekanomalihourly()
	{
		//echo "OK";
		$this->load->model('m_admin');	
		$this->load->model('b_model');	
		$role 		 = $this->m_admin->listrolems();
		
		$cek_data;
		$n			 = 0;
		$stations	 = $this->m_admin->checkstation();

		echo $tgl;
		$n			 = 0;
		$datares = array();
		foreach($stations as $sts)
		{
			
			$sts = $sts->reffidstation;
			$data 	     = $this->m_admin->listGridHourlycek($sts,$tgl);
			$role 		 = $this->m_admin->listrolems();
			//$datares = array();
			foreach($role as $role_id)
			{
				$cek_data2 = $this->m_admin->showdetailrole($role_id->id);
				$cek_data[$n]->formula = $cek_data2;
				$cek_data[$n]->role_id = $role_id->id;
				
				$jumlah = count($cek_data2);
				
				$n++;
			}
			
			
			foreach($data as $row)
			{
				$filter[0]['field'] = "reffrowid";
				$filter[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $row->rowid);
										   
				$this->b_model->delete_data('tbl_detailerrormessage', $filter);
				
				//$sum = $this->m_admin->ceksum($sts,$tgl);
				
				$dp  = $this->m_admin->cekduphourly($row->stationid,$row->tanggal_pengukuran);
				$c = (floatval($row->temperature) - 32) * (5/9);
				//$j=0;
				foreach($cek_data as $cek)
				{
					
					foreach($cek->formula as $var)
					{
						$data_parameter = trim($var->formula);
						$data_parameter = str_replace("Flow_Rateduplicate","".$dp[0]->mmscfd."","".$data_parameter."");
						$data_parameter = str_replace("Rate_Energyduplicate","".$dp[0]->totalizer_mmbtu."","".$data_parameter."");
						$data_parameter = str_replace("Previous_Hourly_Net_Totalizerduplicate","".$dp[0]->totalizer_volume."","".$data_parameter."");
						$data_parameter = str_replace("Previous_Hourly_Net_Energyduplicate","".$dp[0]->totalizer_energy."","".$data_parameter."");
						$data_parameter = str_replace("Pressure_Outletduplicate","".$dp[0]->pressureoutlet."","".$data_parameter."");
						$data_parameter = str_replace("Tempratureduplicate","".$dp[0]->temperature."","".$data_parameter."");
						//$data_parameter = str_replace("Prev_Day_GHVduplicate","".$dp->prevdayghv."","".$data_parameter."");
						$data_parameter = str_replace("Temprature",$c,"".$data_parameter."");
						$data_parameter = str_replace("Flow_Rate","".$row->mmscfd."","".$data_parameter."");
						$data_parameter = str_replace("Rate_Energy",$row->totalizer_mmbtu,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Totalizer",$row->totalizer_volume,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Energy",$row->totalizer_energy,$data_parameter);
						$data_parameter = str_replace("Pressure_Outlet",$row->pressureoutlet,$data_parameter);
						$data_parameter = str_replace("Temprature",$row->temperature,$data_parameter);
						$data_parameter = str_replace("Prev_Day_GHV",$row->prevdayghv,$data_parameter);
						$data_parameter = str_replace($row->prevdayghv."duplicate",$row->prevdayghv."1",$data_parameter);
						
						if(eval($data_parameter) == true)
						{
							
							$datares[$row->rowid][$cek->role_id] = 1;
							
							$data_input = array ("reffrowid"	=> $row->rowid,
												"reffroleid"		=> $cek->role_id,
												"value"			=> 1);
									 
							//$this->b_model->insert_data('tbl_detailerrormessage', $data_input);	
											
						}else
						{
							
							if($cek->role_id == "115106")
							{
								
							}
							/*
							switch ($cek->role_id)
							{
								case "115106":
									$data_input = array ("reffrowid"		=> $row->rowid,
												"reffroleid"		=> $cek->role_id,
												"value"				=> 1);
								break;
								case "115107":
									$data_input = array ("reffrowid"		=> $row->rowid,
												"reffroleid"		=> $cek->role_id,
												"value"				=> 1);
								break;
								
								case "115111":
									$data_input = array ("reffrowid"		=> $row->rowid,
												"reffroleid"		=> $cek->role_id,
												"value"				=> 1);
								break;
								default:
								$data_input = array ("reffrowid"		=> $row->rowid,
												"reffroleid"		=> $cek->role_id,
												"value"				=> 0);
							}
							*/
							$datares[$row->rowid][$cek->role_id] = 0;
								
							
									 
							//$this->b_model->insert_data('tbl_detailerrormessage', $data_input);	
						
						}
						
						$datares[$row->rowid]['115106'] = 1;
						$datares[$row->rowid]['115107'] = 1;
						$datares[$row->rowid]['115111'] = 1;
						
						$data_input = array ("reffrowid"	=> $row->rowid,
											"reffroleid"	=> '115107',
											 "value"		=> 1);
									 
						//$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
						
						$data_input = array ("reffrowid"	=> $row->rowid,
											"reffroleid"	=> '115111',
											 "value"		=> 1);
									 
						//$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
						
						$data_input = array ("reffrowid"	=> $row->rowid,
											"reffroleid"	=> '115106',
											 "value"		=> 1);
									 
						//$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
						
						$n++;
						$j++;
					}
					if($datares[$row->rowid][$cek->role_id] !== null)
					{
						$data_input = array ("reffrowid"	=> $row->rowid,
											"reffroleid"	=> $cek->role_id,
											 "value"		=> $datares[$row->rowid][$cek->role_id]);
									 
						$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
						
					}
					
					
				}
				$dataupdate = 0;
				$hit = 0;
				
				foreach($datares[$row->rowid] as $rowdata)
				{
					
					$dataupdate = $dataupdate+$rowdata;
					$hit++;
				}
				
				$dataupdate = $dataupdate/$hit;
				
				if($dataupdate == 1)
				{
					$dataupdate = 1;
				}else
				{
					$dataupdate = 0;
				}
				
				$filter[0]['field'] = "rowid";
				$filter[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $row->rowid);
				$data = array("statusdata"	=> $dataupdate);		
							 
				$this->b_model->update_data('realisasipenyaluranstationhourly', $filter ,$data);
				echo $dataupdate."------------------------------------";
				
			}
			$n=0;
			
			 
			
			
		}
	
		/*
		$data 	     = $this->m_admin->listGridHourlycek($sts,$tgl);
		
		$res;
		
		
		foreach($role as $role_id)
		{
			$cek_data2 = $this->m_admin->showdetailrole($role_id->id);
			$cek_data[$n]->formula = $cek_data2;
			$cek_data[$n]->role_id = $role_id->id;
			
			$jumlah = count($cek_data2);
			
			$n++;
		}
		//var_dump($role);
		$a=0;
		$b=0;
		//$data_before;
		var_dump($data);
		foreach($data as $row)
		{
			$data_before;
			$str = '';
			$str2 = '';
			$jml_before = count($data_before);
			
			foreach($cek_data as $cek)
			{
				$jumlah = count($cek);
				if($jumlah > 0 )
				{
					foreach($cek->formula as $var)
					{
						
						
						$data_parameter = trim($var->formula);
						$data_parameter = str_replace("Flow_Rate","".$row->mmscfd."","".$data_parameter."");
						$data_parameter = str_replace("Rate_Energy",$row->totalizer_mmbtu,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Totalizer",$row->totalizer_volume,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Energy",$row->totalizer_energy,$data_parameter);
						$data_parameter = str_replace("Pressure_Outlet",$row->tekanan_out_psig,$data_parameter);
						$data_parameter = str_replace("Temprature",$row->temp_f,$data_parameter);
						$data_parameter = str_replace("Prev_Day_GHV",$row->ghv,$data_parameter);
						$ex1 = explode("=",$data_parameter);
						
						
						if($ex1[1] == "duplicate")
						{
							if($jml_before > 0)
							{
								$data_parameter = trim($var->formula);
								$ex2 = explode("=",$data_parameter);
								//var_dump();
								switch($ex2[0])
								{
									case "Flow_Rate":
										$data_parameter = str_replace("duplicate","".$data_before->mmscfd."","".$data_parameter."");
									break;
									case "Rate_Energy":
										$data_parameter = str_replace("duplicate",$data_before->totalizer_mmbtu,$data_parameter);
									break;
									case "Previous_Hourly_Net_Totalizer":
										$data_parameter = str_replace("duplicate",$data_before->totalizer_volume,$data_parameter);
									break;
									case "Previous_Hourly_Net_Energy":
										$data_parameter = str_replace("duplicate",$data_before->totalizer_energy,$data_parameter);
									break;
									case "Pressure_Outlet":
										$data_parameter = str_replace("duplicate",$data_before->tekanan_out_psig,$data_parameter);
									break;
									case "Temprature":
										$data_parameter = str_replace("duplicate",$data_before->temp_f,$data_parameter);
									break;
									case "Prev_Day_GHV":
										$data_parameter = str_replace("duplicate",$data_before->ghv,$data_parameter);
									break;
									
								}
								
								$data_parameter = str_replace("Flow_Rate","".$row->mmscfd."","".$data_parameter."");
								$data_parameter = str_replace("Rate_Energy",$row->totalizer_mmbtu,$data_parameter);
								$data_parameter = str_replace("Previous_Hourly_Net_Totalizer",$row->totalizer_volume,$data_parameter);
								$data_parameter = str_replace("Previous_Hourly_Net_Energy",$row->totalizer_energy,$data_parameter);
								$data_parameter = str_replace("Pressure_Outlet",$row->tekanan_out_psig,$data_parameter);
								$data_parameter = str_replace("Temprature",$row->temp_f,$data_parameter);
								$data_parameter = str_replace("Prev_Day_GHV",$row->ghv,$data_parameter);
								$ex3 = explode("=",$data_parameter);
								
								$stat = ($ex3[0] == $ex3[1]);
								if($stat == false)
								{
									$str .= 1;
								}else
								{
									$str .= 0;
								}
								$res[$a][$cek->role_id] = $str;
							}else
							{
								$str .= 1;
								$res[$a][$cek->role_id] = $str;
							}
							
						}else
						{
							$ex3 = explode("=",$data_parameter);
							$stat = ($ex3[0] == $ex3[1]);
							//$stat = eval($data_parameter);
							if($stat == false)
							{
								$str2 .= 1;
							}else
							{
								$str2 .= 0;
							}
							$res[$a][$cek->role_id] = $str2;
						}
						
						//var_dump($str);
						
						
					}
				}
				$b++;	
			}
			$a++;
			$data_before = $row;
			
		}
		*/
		
	}
	
	public function cekanomalidaily()
	{
		$this->load->model('m_admin');	
		$role 		 = $this->m_admin->listrolems();
		$stations	 = $this->m_admin->checkstation();
		
		$cek_data;
		$n			 = 0;
		

		echo $tgl;
		foreach($stations as $st)
		{
			$str2 = '';
			$sts = $st->reffidstation;
			//$sts = 27;
			
			$data 	     = $this->m_admin->listGridDailycek($sts,$tgl);
			$role 		 = $this->m_admin->listrolems();
			$res;
			foreach($role as $role_id)
			{
				$cek_data2 = $this->m_admin->showdetailrole($role_id->id);
				$cek_data[$n]->formula = $cek_data2;
				$cek_data[$n]->role_id = $role_id->id;
				
				$jumlah = count($cek_data2);
				
				$n++;
			}
			
			$a=0;
			$b=0;
			//$data_before;
			//$data = array();
			$datares = array();
			foreach($data as $row)
			{
				$data_before;
				$str = '';
				$str2 = '';
				$jml_before = count($data_before);
				$sum = $this->m_admin->ceksum($sts,$tgl);
				$dp  = $this->m_admin->cekdup($sts,$tgl);
				$c = (floatval($row->temperature) - 32) * (5/9);
				
				$sumdailyvol = floatval($sum[0]->totalizer_volume);
				//$datares = array("id_station" => $row->stationid);
				foreach($cek_data as $cek)
				{
					$jumlah = count($cek);
					//$datares['id_station'] = array ($cek->role_id);
					foreach($cek->formula as $var)
					{
						$data_parameter = trim($var->formula);
						$data_parameter = str_replace("Flow_Rateduplicate",$dp[0]->volume,$data_parameter);
						$data_parameter = str_replace("Rate_Energyduplicate",$dp[0]->energy,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Totalizerduplicate",$dp[0]->counter_volume,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Energyduplicate",$dp[0]->counter_energy,$data_parameter);
						$data_parameter = str_replace("Pressure_Outletduplicate",$dp[0]->pout,$data_parameter);
						$data_parameter = str_replace("Tempratureduplicate",$dp[0]->temperature,$data_parameter);
						$data_parameter = str_replace("Prev_Day_GHVduplicate",$dp[0]->ghv,$data_parameter);
						$data_parameter = str_replace("Volume_Daily","". number_format((floatval($row->volume) / 1000) , 2)."","".$data_parameter."");
						$data_parameter = str_replace("SUM_Daily","".number_format((floatval($sumdailyvol)),2)."","".$data_parameter."");
						$data_parameter = str_replace("Temprature",$c,"".$data_parameter."");
						$data_parameter = str_replace("Flow_Rate","".$row->volume."","".$data_parameter."");
						$data_parameter = str_replace("Rate_Energy",$row->energy,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Totalizer",$row->counter_volume,$data_parameter);
						$data_parameter = str_replace("Previous_Hourly_Net_Energy",$row->counter_energy,$data_parameter);
						$data_parameter = str_replace("Pressure_Outlet",$row->pout,$data_parameter);
						$data_parameter = str_replace("Temprature",$row->temperature,$data_parameter);
						$data_parameter = str_replace("Prev_Day_GHV",$row->ghv,$data_parameter);
						
						//$datares = array($row->stationid => array ($cek->role_id => true));
						if(eval($data_parameter) == true)
						{
							//$datares[$row->stationid][$cek->role_id] = array ("val" => 1,
							//								   "bolval" => eval($data_parameter));
															   
							$datares[$row->rowid][$cek->role_id] = 1;								   
						}else
						{
							
							$datares[$row->rowid][$cek->role_id] = 0;								   
						
						}
						
						$datares[$row->rowid]['115107'] = 1;	
						$datares[$row->rowid]['115111'] = 1;	
						
					}
					$b++;	
				}
				
				$a++;
				$data_before = $row;
				$juml = 0;
				
			}
			
			foreach($datares as $upd)
			{
				//var_dump($upd);
				
				$a = array_keys($datares);
				$b = array_keys($upd);
				//var_dump($upd['115107']);
				
				$juml = 0;
				$n=0;
				
				$filter[0]['field'] = "reffrowid";
				$filter[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $a[0]);
										   
				$this->b_model->delete_data('tbl_detailerrormessage', $filter);
				
				$data_input = array ("reffrowid"	=> $a[0],
									 "reffroleid"	=> '115106',
									 "value"		=> $upd['115106']);
									 
				$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
				
				$data_input = array ("reffrowid"	=> $a[0],
									 "reffroleid"	=> '115107',
									 "value"		=> $upd['115107']);
									 
				$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
				
				$data_input = array ("reffrowid"	=> $a[0],
									 "reffroleid"	=> '115111',
									 "value"		=> $upd['115111']);
									 
				$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
				
				$data_input = array ("reffrowid"	=> $a[0],
									 "reffroleid"	=> '115110',
									 "value"		=> $upd['115110']);
									 
				$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
				
				
				$data_input = array ("reffrowid"	=> $a[0],
									 "reffroleid"	=> '115112',
									 "value"		=> $upd['115112']);
									 
				$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
				
				$data_input = array ("reffrowid"	=> $a[0],
									 "reffroleid"	=> '115113',
									 "value"		=> $upd['115113']);
									 
				$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
				foreach($upd as $r)
				{
					
					//$r = $r + $r;
					$juml = $r+$juml;
					//var_dump($r);
					$n++;
				}
				$jc = $juml/$n;
				if($juml/$n == 1 )
				{
					$jc = 1;
				}else
				{
					$jc = 0;
				}
				$filter[0]['field'] = "rowid";
				$filter[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $a[0]);
				$data = array("statusdata"	=> $jc);		
							 
				$this->b_model->update_data('realisasipenyaluranstationdaily', $filter ,$data);
				
				
			}
			
		}
	}
	public function showstationconfig()
	{
		$this->load->model('m_admin');	
		$query = "select * 
				  from mstation WHERE stationtype = '115186'";
		$this->m_admin->listRows($query);
	}
	public function showdetailconfig()
	{
		$id = $_GET['id'];
		$this->load->model('m_admin');	
		//var_dump($_GET['id']);
		$query = "SELECT * from stationdetailconfig
				   WHERE refrowidstation = '".$id."'";
		$this->m_admin->listRows($query);
		//$this->m_admin->listRows($query);
	}
	public function showmappingcol()
	{
		$this->load->model('m_admin');	
		//var_dump($_GET['id']);
		$query = "SELECT * from mappingcolumn";
		$this->m_admin->listRows($query);
	}
	
	public function submitconfig()
	{
		$this->load->model('m_admin');
		$id = $this->input->post('id');
		$refid = $this->input->post('refid');
		$confName = $this->input->post('confname');
		$value = $this->input->post('value');
		
		$data_input = array("reffidstation"	=> $refid,
							"refrowidstation"	=> $id,
							"stationname"	=> $this->input->post('stationname'),
							"confname"		=> $confName,
							"value"			=> $value);
		
		$this->m_admin->add_entry($data_input,'stationdetailconfig');
	}
	public function updatemappcol()
	{
		$this->load->model('m_admin');
		
		$data	= array("fromtable"	=> $this->input->post('fromtable'),
						"streamfield"	=> $this->input->post('streamfield'),
						"variable"		=> $this->input->post('variable'),
						"formula"		=> $this->input->post('formula'),
						"typeperiod"	=> $this->input->post('typeperiod'));
						
		$this->m_admin->add_entry($data,'mappingcolumn');
	}
	public function downloadpenyaluran()
	{
		
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
	    //var_dump($filter);
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'tanggal desc';
	    }	    
		if($filter == false)
		{
			$filter[0]['field'] = "tglpenyalurandate";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "date",
									   "value"		=> "2015-12-11");
			
		}else
		{
			$filter = $this->input->get('filter', TRUE);
			
			//var_dump($filter);
		}
		
		//wheretofilter($arrFilter);
			
		$dataas = $this->b_model->get_all_data('viewpenyalurandaily', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('viewpenyalurandaily', $filter);
		$n=0;
		foreach ($dataas as $row) {
			$data[] = $row;
			$stat = unserialize($row->error);
			
			//$statfin = ($stat['115113'] + $stat['115112']) / 2;
			$statfin = ($stat['115113']);
			
			if($statfin < 1)
			{
				$error = 0;
			}else
			{
				$error	= 1;
			}
			
			$data[$n]->error = $error;
			
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
	public function listkelengkapandatahourly()
	{
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
	    //var_dump($filter);
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'tanggal desc';
	    }	    
		if($filter == false)
		{
			$filter[0]['field'] = "tgl_pengukuran";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "date",
									   "value"		=> "2015-12-11");
			
			
			$filter[1]['field'] = "tbl_station_id";
			$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> 116);
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		//var_dump($filter);
		//wheretofilter($arrFilter);
			
		$dataas = $this->b_model->get_all_data('viewpenylauranhourly', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('viewpenylauranhourly', $filter);
		$n=0;
		foreach ($dataas as $row) {
			$data[] = $row;
			$data[$n]->selectopts = false; 
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
	
	/*---
	
	*/
	
	public function type_source_pelanggan ()
	{
		$this->load->model('m_admin');
		$query = "SELECT * from type_source_pelanggan";
		$this->m_admin->listRows($query);	
		
	}
	
	public function pelanggan ()
	{
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
	    //var_dump($filter);
		
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'pelname ,tanggal_mapping desc';
	    }	    
		if($filter == false)
		{
			
			//$filter = array();						   
			$filter[0]['field'] = "sbu";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "list",
									   "value"		=> $this->session->userdata('rd'));
									   
									   
			//var_dump($this->session->userdata('rd'));						   
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		
		$filter = array();
		$dataas = $this->b_model->get_all_data('mappingpelanggansource', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('mappingpelanggansource', $filter);
		$n=0;
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

	public function findamr ()
	{
		$this->load->model('b_model');
	    
		$filter = $this->input->get('filter', TRUE) > ''? $this->input->get('filter', TRUE) : array();		
		
		
		$startt = $this->input->get('startt',true) >'' ? whereTofilter('tanggal', $this->input->get('startt',true) , 'date' , 'lt') : '' ;
		$endd = $this->input->get('endd',true) > '' ? whereTofilter('tanggal', $this->input->get('endd',true) , 'date' , 'gt') : '' ;		
		$sbu = $this->input->get('sbu',true) > '' ? whereTofilter('sbu', $this->input->get('sbu',true) , 'string' , '') : '' ;
		$area = $this->input->get('area',true) > '' ? whereTofilter('area', $this->input->get('area',true) , 'string' , '') : '' ;
		$id_pel = $this->input->get('id_pel',true) > '' ? whereTofilter('id_pel', $this->input->get('id_pel',true) , 'string' , '') : '' ;
		$namapel = $this->input->get('namapel',true) > '' ? whereTofilter('namapel', $this->input->get('namapel',true) , 'string' , '') : '' ;		
		
		array_push($filter, $startt, $endd, $sbu, $area, $id_pel, $namapel);
		// vd::dump($filter); 		
		
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	
	    
	    $sorts = json_decode($this->input->get('sort', TRUE));
	    if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'tanggal desc';
	
	    }
		


	    $total_entries = $this->b_model->count_all_data('v_amr_bridge_daily', $filter);
		$entries = $this->b_model->get_all_data('v_amr_bridge_daily', $filter , $limit, $offset, $order_by);		
		
	    $data['success'] = true;
	    $data['total'] = $total_entries;
	    $data['data'] = $entries;    
		
	    // vd::dump($data); 
	    extjs_output($data);
	}
	
	public function findamrhr ()
	{ 
		$this->load->model('b_model');
		$filter = $this->input->get('filter', TRUE) > ''? $this->input->get('filter', TRUE) : array();	
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $sorts = json_decode($this->input->get('sort', TRUE));
	    if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'jam asc';
	    }	
		
		$id_pel = $this->input->get('id_pel',true) > '' ? whereTofilter('id_pel', $this->input->get('id_pel',true) , 'boolean' , '') : '' ;
		
		$stream = $this->input->get('stream',true) > '' ? whereTofilter('stream', $this->input->get('stream',true) , 'boolean' , '') : '' ;
		
		array_push($filter, $id_pel, $stream);			
		
		$entries = $this->b_model->get_all_data('v_amr_bridge_hr', $filter , $limit, $offset, $order_by);		
		$total_entries = $this->b_model->count_all_data('v_amr_bridge_hr' , $filter);		
		 
		$data['success'] = true;
	    $data['total'] = $total_entries;
	    $data['data'] = $entries;

	   
	    //vd::dump($data); 
	    extjs_output($data); 
			
	}
	


	public function insertdatamanualbulk()
	{
		$this->load->model('b_model');
		
		$data_input = $this->input->post();
		/*
		$filter[0]['field'] = "tglpenyalurandate";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "date",
								   "value"		=> $data_input['']);
		
		$filter[1]['field'] = "tbl_station_id";
		$filter[1]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> intval($data_input['tbl_station_id']));	
		
		$cekdatabefore = $this->b_model->get_all_data('viewpenyalurandaily', $filter , $limit = '25', $offset = '0', $order = '');
		
		
		
		
		$dataParameterInput = $this->b_model->getdataparameterinputdaily($data_input,$cekdatabefore);
		foreach($dataParameterInput as $row)
		{
			
			if($row['tbl_parametervalue'] > 0)
			{
				$this->b_model->insert_data('tbl_parametervaluehist',$row);
			}
		}
		*/
		$data_update = array("volume"	=> $data_input['volume'],
							"energy"	=> floatval($data_input['energy']),
							"ghv"		=> floatval($data_input['ghv']),
							"pressureinlet"		=> floatval($data_input['pressureinlet']),
							"pressureoutlet"	=> floatval($data_input['pressureoutlet']),
							"temperature"		=> floatval($data_input['temperature']),
							"counter_volume"		=> floatval($data_input['counter_volume']),
							"counter_energy"		=> floatval($data_input['counter_energy']),
							"updperson"		=> $this->session->userdata('username'),
							"upddate"		=> dateTonum(date('Y-m-d h:i:s')),
							);
		
		$filter[0]['field'] = "rowid";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $this->input->post('rowid'));
		
								   
		$this->b_model->update_data('realisasipenyaluranstationdaily', $filter ,$data_update);
		$this->cekanomalidailyf($data_input['stationid'],$data_input['tanggal_pengukuran']);
		
		//$data[] = array("tbl_parameter"	=> '',
					  //"tgl_pengukuran"	=> '',
					  //"parameter_periode"	=> '',
					  //"tbl_parametervalue"	=> '',
					  //"tbl_station_id"		=> '');
						
		//$this->b_model->find_amr_data('tbl_penyalurandaily',$data);
		
	}
	public function updatedatabulkhourly()
	{
		$data_update = array("mmscfd"	=> floatval($this->input->post('mmscfd')),
					 "totalizer_mmbtu"			=> floatval($this->input->post('totalizer_mmbtu')),
					 "totalizer_mscf"			=> floatval($this->input->post('totalizer_mscf')),
					 "totalizer_energy"			=> floatval($this->input->post('totalizer_energy')),
					 "totalizer_volume"			=> floatval($this->input->post('totalizer_volume')),
					 "pressureinlet"			=> floatval($this->input->post('pressureinlet')),
					 "pressureoutlet"			=> floatval($this->input->post('pressureoutlet')),
					 "temperature"				=> floatval($this->input->post('temperature')),
					 "prevdayghv"				=> floatval($this->input->post('prevdayghv')),
					 "upddate"					=> floatval(dateTonum(date('Y-m-d H:i:s'))),
					 "updperson"				=> $this->session->userdata('username')
					 //"counter_energy"			=> $this->input->post('counter_energy'),
					 //"approvedate"				=> 'now()',
					 //"approveby"				=> $this->session->userdata('username'),
					 //"reffrowid"				=> $this->input->post('rowid')
					 );
					 
		$filter[0]['field'] = "rowid";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $this->input->post('rowid'));
		
		$this->b_model->update_data('realisasipenyaluranstationhourly', $filter ,$data_update);
		
		$data_log = array(
						 "stationid"			=> $this->input->post('stationid'),
						 "mstationrowid"		=> $this->input->post('mstationrowid'),
						 "realisasipenyaluranstationhourlyrowid"	=> $this->input->post('rowid'),
						 //"realisasipenyaluranstationhourlyfinalrowid"	=> $idapprove,
						 "tglpengukuran"	=> dateTonum($this->input->post('tanggal_pengukuran')),
						 "mmscfd"			=> $this->input->post('mmscfd'),
						 "totalizer_mmbtu"	=> floatval($this->input->post('totalizer_mmbtu')),
						 "totalizer_mscf"	=> floatval($this->input->post('totalizer_mscf')),
						 "totalizer_energy"	=> floatval($this->input->post('totalizer_energy')),
						 "totalizer_volume"	=> floatval($this->input->post('totalizer_volume')),
						 "pressureinlet"	=> floatval($this->input->post('pressureinlet')),
						 "pressureoutlet"	=> floatval($this->input->post('pressureoutlet')),
						 "temperature"		=> floatval($this->input->post('temperature')),
						 "prevdayghv"		=> floatval($this->input->post('prevdayghv')),
						 "credate"			=> dateTonum(date('Y-m-d H:i:s')),
						 "creperson"		=> $this->session->userdata('username'),
						 //"reffrowid"		=> $this->input->post('rowid'),
						 "idx_perioderowid"	=> $this->input->post('idx_perioderowid'),
						 "periodecd"		=> $this->input->post('jam_pengukuran'),
						 "status"			=> 2
						 //"typeapproval"		=> $datatypeapprove,
						 //"isapproval"		=> 1
		);	
				 
		$this->b_model->insert_data('h_realisasipenyaluranstationhourly', $data_log);	
								   
		
		$this->cekanomalihourlyf($this->input->post('stationid'),$this->input->post('tanggal_pengukuran'));
		
	}
	public function inserttofin()
	{
		$tanggal = $this->input->post('tanggal_pengukuran');
		$tahun = intval(substr($tanggal,0,4));
		$bulan = substr($tanggal,5,2);
		$tgl = substr($tanggal,8,2);
		
		$this->load->model('b_model');
		//$pressin = floatval($this->input->post('pressureinlet'));
		
		$data = array("realisasipenyaluranstationdailyrowid"	=> $this->input->post('rowid'),
					 "mstationrowid"							=> $this->input->post('mstationrowid'),
					 "stationid"								=> $this->input->post('stationid'),
					 "tglpengukuran"							=> dateTonum($this->input->post('tanggal_pengukuran')),
					 "volume"									=> floatval($this->input->post('volume')),
					 "energy"									=> floatval($this->input->post('energy')),
					 "ghv"										=> floatval($this->input->post('ghv')),
					 "pressureinlet"							=> floatval($this->input->post('pressureinlet')),
					 "pressureoutlet"							=> floatval($this->input->post('pressureoutlet')),
					 "temperature"								=> floatval($this->input->post('temperature')),
					 "pressureoutlet"							=> floatval($this->input->post('pressureoutlet')),
					 "counter_volume"							=> floatval($this->input->post('counter_volume')),
					 "counter_energy"							=> floatval($this->input->post('counter_energy')),
					 "isapproval"								=> 1,
					 "typeapproval"								=> 2,
					 "creperson"								=> $this->session->userdata('username'),
					 "credate"									=> dateTonum(date('Y-m-d H:i:s'))
					 );
					 
		
		$data_id = $this->b_model->insert_data('realisasipenyaluranstationdailyfinal', $data);
		
		$filter[0]['field'] = "rowid";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $this->input->post('rowid'));
								   
		
		$data_update = array("statusapproval"	=> "Approve",
							 "updperson"		=> $this->session->userdata('username'),
							 "upddate"			=> dateTonum(date('Y-m-d h:i:s'))
							);
							
		$this->b_model->update_data('realisasipenyaluranstationdaily', $filter ,$data_update);
		
		$data = array(
					"realisasipenyaluranstationdailyfinalrowid"	=> "PDFH".$data_id,
					"realisasipenyaluranstationdailyrowid"	=> $this->input->post('rowid'),
					 "mstationrowid"							=> $this->input->post('mstationrowid'),
					 "stationid"								=> $this->input->post('stationid'),
					 "tglpengukuran"							=> dateTonum($this->input->post('tanggal_pengukuran')),
					 "volume"									=> floatval($this->input->post('volume')),
					 "energy"									=> floatval($this->input->post('energy')),
					 "ghv"										=> floatval($this->input->post('ghv')),
					 "pressureinlet"							=> floatval($this->input->post('pressureinlet')),
					 "pressureoutlet"							=> floatval($this->input->post('pressureoutlet')),
					 "temperature"								=> floatval($this->input->post('temperature')),
					 "pressureoutlet"							=> floatval($this->input->post('pressureoutlet')),
					 "counter_volume"							=> floatval($this->input->post('counter_volume')),
					 "counter_energy"							=> floatval($this->input->post('counter_energy')),
					 "isapproval"								=> 1,
					 "typeapproval"								=> 2,
					 "creperson"								=> $this->session->userdata('username'),
					 "credate"									=> dateTonum(date('Y-m-d H:i:s'))
					 );
					 
		$this->b_model->insert_data('h_realisasipenyaluranstationdaily', $data);			 
	}
	public function savetaxbulk()
	{
		//echo "OKOKOK";
		$data = json_decode($this->input->post('data'));
		foreach($data as $row)
		{
			var_dump($row);
			
			$data = array("reffpengukuranrealisasi"	=> $row->rowid,
					 "mstationrowid"			=> $row->mstationrowid,
					 "nama_station"				=> $row->nama_station,
					 "stationid"				=> $row->stationid,
					 "tglpengukuran"			=> dateTonum($row->tanggal_pengukuran),
					 "tgltaxation"				=> dateTonum(date('Y-m-d H:i:s')),
					 "volume"					=> $row->volume,
					 "energy"					=> $row->energy,
					 "ghv"						=> $row->ghv,
					 "pressureinlet"			=> $row->pressureinlet,
					 "pressureoutlet"			=> $row->pressureoutlet,
					 "temperature"				=> $row->temperature,
					 "pressureoutlet"			=> $row->pressureoutlet,
					 "counter_volume"			=> $row->counter_volume,
					 "counter_energy"			=> $row->counter_energy,
					 //"isapproval"				=> 1,
					 //"typeapproval"				=> 2,
					 "creperson"				=> $this->session->userdata('username'),
					 "credate"					=> dateTonum(date('Y-m-d H:i:s'))
					 );
					 
			$data_id = $this->b_model->insert_data('taxation_bulk', $data);
			
			$filter[0]['field'] = "rowid";
			$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $row->rowid);
								   
			$data_update = array("statusapproval"	=> "Taksasi",
								"updperson"		=> $this->session->userdata('username'),
								"upddate"		=> dateTonum(date('Y-m-d h:i:s'))
							);
							
			$this->b_model->update_data('realisasipenyaluranstationdaily', $filter ,$data_update);
		}
		
					 
		
	}
	public function inserttofinhourly()
	{
		$tanggal = $this->input->post('tanggal_pengukuran');
		$this->load->model('b_model');
		
		if($this->input->post(statusdata) == 1)
		{
			$datatypeapprove = 2;
		}elseif($this->input->post(statusdata) == 0)
		{
			$datatypeapprove = 1;
		}
		
		$data = array(
				 "stationid"			=> $this->input->post('stationid'),
				 "mstationrowid"		=> $this->input->post('mstationrowid'),
				 "realisasipenyaluranstationhourlyrowid"	=> $this->input->post('rowid'),
				 "tglpengukuran"	=> dateTonum($this->input->post('tanggal_pengukuran')),
				 "mmscfd"			=> $this->input->post('mmscfd'),
				 "totalizer_mmbtu"	=> floatval($this->input->post('totalizer_mmbtu')),
				 "totalizer_mscf"	=> floatval($this->input->post('totalizer_mscf')),
				 "totalizer_energy"	=> floatval($this->input->post('totalizer_energy')),
				 "totalizer_volume"	=> floatval($this->input->post('totalizer_volume')),
				 "pressureinlet"	=> floatval($this->input->post('pressureinlet')),
				 "pressureoutlet"	=> floatval($this->input->post('pressureoutlet')),
				 "temperature"		=> floatval($this->input->post('temperature')),
				 "prevdayghv"		=> floatval($this->input->post('prevdayghv')),
				 "credate"			=> dateTonum(date('Y-m-d H:i:s')),
				 "creperson"		=> $this->session->userdata('username'),
				 //"reffrowid"		=> $this->input->post('rowid'),
				 "idx_perioderowid"	=> $this->input->post('idx_perioderowid'),
				 "periodecd"		=> $this->input->post('jam_pengukuran'),
				 "typeapproval"		=> $datatypeapprove,
				 "isapproval"		=> 1,
				 
				 );
				 
		$data_id = $this->b_model->insert_data('realisasipenyaluranstationhourlyfinal', $data);	
		
		
		
		$filter[0]['field'] = "rowid";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $this->input->post('rowid'));
								   
		$data_update = array("statusapproval"	=> "Approve",
							 "updperson"		=> $this->session->userdata('username'),
							 "upddate"			=> dateTonum(date('Y-m-d h:i:s'))
							);
							
		$this->b_model->update_data('realisasipenyaluranstationhourly', $filter ,$data_update);	
		$idapprove = "PHF".$data_id;
		//var_dump($idapprove);
		$data_log = array(
						 "stationid"			=> $this->input->post('stationid'),
						 "mstationrowid"		=> $this->input->post('mstationrowid'),
						 "realisasipenyaluranstationhourlyrowid"	=> $this->input->post('rowid'),
						 "realisasipenyaluranstationhourlyfinalrowid"	=> $idapprove,
						 "tglpengukuran"	=> dateTonum($this->input->post('tanggal_pengukuran')),
						 "mmscfd"			=> $this->input->post('mmscfd'),
						 "totalizer_mmbtu"	=> floatval($this->input->post('totalizer_mmbtu')),
						 "totalizer_mscf"	=> floatval($this->input->post('totalizer_mscf')),
						 "totalizer_energy"	=> floatval($this->input->post('totalizer_energy')),
						 "totalizer_volume"	=> floatval($this->input->post('totalizer_volume')),
						 "pressureinlet"	=> floatval($this->input->post('pressureinlet')),
						 "pressureoutlet"	=> floatval($this->input->post('pressureoutlet')),
						 "temperature"		=> floatval($this->input->post('temperature')),
						 "prevdayghv"		=> floatval($this->input->post('prevdayghv')),
						 "credate"			=> dateTonum(date('Y-m-d H:i:s')),
						 "creperson"		=> $this->session->userdata('username'),
						 //"reffrowid"		=> $this->input->post('rowid'),
						 "idx_perioderowid"	=> $this->input->post('idx_perioderowid'),
						 "periodecd"		=> $this->input->post('jam_pengukuran'),
						 "typeapproval"		=> $datatypeapprove,
						 "isapproval"		=> 1
				 );	
				 
		$this->b_model->insert_data('h_realisasipenyaluranstationhourly', $data_log);			 
		
	}
	public function downloadpenyaluranfinal()
	{
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
	    //var_dump($filter);
		
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'tanggal desc';
	    }	    
		if($filter == false)
		{
			$filter[0]['field'] = "tglpenyalurandate";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "date",
									   "value"		=> "2015-12-11");
			
			
		}else
		{
			$filter = $this->input->get('filter', TRUE);
			//var_dump($filter);
		}
		
		//wheretofilter($arrFilter);
			
		$dataas = $this->b_model->get_all_data('viewpenyalurandailyfinal', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('viewpenyalurandailyfinal', $filter);
		$n=0;
		foreach ($dataas as $row) {
			$data[] = $row;
			$stat = unserialize($row->error);
			
			//$statfin = ($stat['115113'] + $stat['115112']) / 2;
			$statfin = ($stat['115113']);
			
			if($statfin < 1)
			{
				$error = 0;
			}else
			{
				$error	= 1;
			}
			
			$data[$n]->error = $error;
			
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
	public function showpelangganindustri()
	{
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
	    //var_dump($filter);
		
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'pelname desc';
	    }	    
		if($filter == false)
		{
			//$filter[0]['field'] = "tglpenyalurandate";
			//$filter[0]['data'] = array("comparison"	=> "eq",
									  // "type"		=> "date",
									   //"value"		=> "2015-12-11");
			$filter = array();
			
		}else
		{
			$filter = $this->input->get('filter', TRUE);
			//var_dump($filter);
		}
		
		//wheretofilter($arrFilter);
			
		$dataas = $this->b_model->get_all_data('v_pelangganindustri', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('v_pelangganindustri', $filter);
		$n=0;
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
	public function showmstation()
	{
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
	    //var_dump($filter);
		
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'pelname desc';
	    }	    
		if($filter == false)
		{
			//$filter[0]['field'] = "tglpenyalurandate";
			//$filter[0]['data'] = array("comparison"	=> "eq",
									  // "type"		=> "date",
									   //"value"		=> "2015-12-11");
			$filter = array();
			
		}else
		{
			$filter = $this->input->get('filter', TRUE);
			//var_dump($filter);
		}
		
		//wheretofilter($arrFilter);
		$limit = 200;
		
		$dataas = $this->b_model->get_all_data('mstationnotbulk', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('mstationnotbulk', $filter);
		$n=0;
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
	public function updaterejectanomali()
	{
		echo "OKOK";
	}
	public function cekanomalidailygaskomp()
	{
		$this->load->model('m_admin');	
		$cek_data;
		$n			 = 0;
		
		$tgl = '2016-05-01';
		echo $tgl;
		
		$limit = 'All';
		
	    $offset = $this->input->get('start', TRUE);
		$filter[0]['field'] = "typeofrole";
		$filter[0]['data']  = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> "gaskomp");
								   
		$role = $this->b_model->get_all_data('ms_liberrorcode', $filter , $limit, $offset, '');
		
		$filter[0]['field'] = "typeofrole";
		$filter[0]['data']  = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> "gaskomp");
								   
		
		
		
		$stations = $this->m_admin->checkstation();
		
		
		
		foreach($stations as $st)
		{
			$sts = $st->reffidstation;
			
			$filter[0]['field'] = "stationid";
			$filter[0]['data']  = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $sts);
								   
			
			$filter[1]['field'] = "tanggal_pencatatan";
			$filter[1]['data']  = array("comparison"	=> "eq",
								   "type"		=> "date",
								   "value"		=> $tgl);
								   
			$data 		 = $this->b_model->get_all_data('v_gaskomposisidaily', $filter , $limit, $offset, '');
			//$data 	     = $this->m_admin->listGridDailycek($sts,$tgl);
			//$data = 
			//var_dump($data);
			$jmlh = count($data);
			if(!empty($data))
			{
				$res;
				foreach($role as $role_id)
				{
					$filterrole[0]['field'] = "id_ms_liberrorcode";
					$filterrole[0]['data']  = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $role_id->id);
								   
					$cek_data2 		 = $this->b_model->get_all_data('dt_msliberrcode', $filterrole , $limit, $offset, '');
					//$cek_data2 = $this->m_admin->showdetailrole($role_id->id);
					$cek_data[$n]->formula = $cek_data2;
					$cek_data[$n]->role_id = $role_id->id;
					$cek_data[$n]->flaging = $role_id->flaging;
					
					
					$n++;
				}
				$datares = array();
				foreach($data as $row){
					$data_before;
					$str = '';
					$str2 = '';
					$tgl_before = date('Y-m-d',strtotime($tgl . "-1 days"));
					//$filterdup = 
					$filterdup[0]['field'] = "stationid";
					$filterdup[0]['data']  = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $sts);
										   
					
					$filterdup[1]['field'] = "tanggal_pencatatan";
					$filterdup[1]['data']  = array("comparison"	=> "eq",
										   "type"		=> "date",
										   "value"		=> $tgl_before);
					$dp  = $this->b_model->get_all_data('v_gaskomposisidaily', $filterdup , $limit, $offset, '');
					//$dp  = $this->m_admin->cekdup($sts,$tgl);
					echo $tgl_before;
					foreach($cek_data as $cek)
					{
						foreach($cek->formula as $var)
						{
							$data_parameter = trim($var->formula);
							$data_parameter = str_replace("sgdp",$dp[0]->sg,$data_parameter);
							$data_parameter = str_replace("ch4dp",$dp[0]->ch4,$data_parameter);
							$data_parameter = str_replace("c2h6dp",$dp[0]->c2h6,$data_parameter);
							$data_parameter = str_replace("c3h8dp",$dp[0]->c3h8,$data_parameter);
							$data_parameter = str_replace("n_c4h10dp",$dp[0]->n_c4h10,$data_parameter);
							$data_parameter = str_replace("i_c4h10dp",$dp[0]->i_c4h10,$data_parameter);
							$data_parameter = str_replace("n_c5h12dp",$dp[0]->n_c5h12,$data_parameter);
							$data_parameter = str_replace("i_c5h12dp",$dp[0]->i_c5h12,$data_parameter);
							$data_parameter = str_replace("c6h14dp",$dp[0]->c6h14,$data_parameter);
							$data_parameter = str_replace("n2dp",$dp[0]->n2,$data_parameter);
							$data_parameter = str_replace("co2dp",$dp[0]->co2,$data_parameter);
							
							$data_parameter = str_replace("sg",empty($row->sg) ? 0 : $row->sg,$data_parameter);
							$data_parameter = str_replace("ch4",empty($row->ch4) ? 0 : $row->ch4,$data_parameter);
							$data_parameter = str_replace("c2h6",empty($row->c2h6) ? 0 : $row->c2h6,$data_parameter);
							$data_parameter = str_replace("c3h8",empty($row->c3h8) ? 0 : $row->c3h8,$data_parameter);
							$data_parameter = str_replace("n_c4h10",empty($row->n_c4h10) ? 0 : $row->n_c4h10,$data_parameter);
							$data_parameter = str_replace("i_c4h10",empty($row->i_c4h10) ? 0 : $row->i_c4h10,$data_parameter);
							$data_parameter = str_replace("n_c5h12",empty($row->n_c5h12) ? 0 : $row->n_c5h12,$data_parameter);
							$data_parameter = str_replace("i_c5h12",empty($row->i_c5h12) ? 0 : $row->i_c5h12,$data_parameter);
							$data_parameter = str_replace("c6h14",empty($row->c6h14) ? 0 : $row->c6h14,$data_parameter);
							$data_parameter = str_replace("n2",empty($row->n2) ? 0 : $row->n2,$data_parameter);
							$data_parameter = str_replace("co2",empty($row->co2) ? 0 : $row->co2,$data_parameter);
							
							echo "<pre>";
								var_dump($data_parameter);
							echo "</pre>";
							echo "<pre>";
								var_dump(eval($data_parameter));
							echo "</pre>";
							if(eval($data_parameter) == true)
							{
								//$datares[$row->stationid][$cek->role_id] = array ("val" => 1,
								//								   "bolval" => eval($data_parameter));
																   
								$datares[$row->rowid][$cek->role_id] = 1;								   
							}else
							{
								
								$datares[$row->rowid][$cek->role_id] = 0;								   
							
							}
							
						}
						
					}
				}
				
		foreach($datares as $rarea)
		{
			
			$juml = 0;
			$n=0;
			$a = array_keys($datares);
			
			foreach($datares as $keyrow=>$value) 
			{
				
					$filterde[0]['field'] = "reffrowid";
					$filterde[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $keyrow);
					$this->b_model->delete_data('tbl_detailerrormessage', $filterde);
					
					foreach($rarea as $key=>$valuea) 
					{
						
						
						$data_input = array ("reffrowid"	=> $keyrow,
								 "reffroleid"	=> $key,
								 "value"		=> $valuea);
											
						$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
					
					}
					
					foreach($rarea as $rv)
					{
						$juml = $rv+$juml;
						//var_dump($r);
						$n++;
					}
					
					$jc = $juml/$n;
					if($juml/$n == 1 )
					{
						$jc = 1;
					}else
					{
						$jc = 0;
					}
					
					$filterup[0]['field'] = "rowid";
					$filterup[0]['data'] = array("comparison"	=> "eq",
											   "type"			=> "string",
											   "value"			=> $keyrow);
					$data = array("statusdata"	=> $jc);		
							
					$this->b_model->update_data('gaskomposisidaily', $filterup ,$data);
				}
				/*
				
									   
				$this->b_model->delete_data('tbl_detailerrormessage', $filterde);
				
				foreach($rarea as $key=>$value) 
				{
					$data_input = array ("reffrowid"	=> $a[0],
								 "reffroleid"	=> $key,
								 "value"		=> $value);
								 
					$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
					//var_dump("Param : ".$key, "Value : ".$value);
				}
				foreach($rarea as $rv)
				{
					$juml = $r+$juml;
					//var_dump($r);
					$n++;
				}
				$jc = $juml/$n;
				if($juml/$n == 1 )
				{
					$jc = 1;
				}else
				{
					$jc = 0;
				}
				
				$filterup[0]['field'] = "rowid";
				$filterup[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $a[0]);
				$data = array("statusdata"	=> $jc);		
							 
				$this->b_model->update_data('gaskomposisidaily', $filterup ,$data);
				*/
				
			}
				//die();
				
				
			}
			
			
		}
		
		//$role = $this->b_model->delete_data('ms_liberrorcode', $filter);
		
		
		//$role 		 = $this->m_admin->listrolems();
		//$stations	 = $this->m_admin->checkstation();
	}
	public function inserttofingaskomp()
	{
		$data = array("gaskomposisidailyrowid"	=> $this->input->post('rowid'),
					  "mstationrowid"			=> $this->input->post('stationcd'),
					  "tbl_station_id"			=> $this->input->post('stationid'),
					  "tgl_pencatatan"			=> dateTonum($this->input->post('tanggal_pencatatan')),
					  "pressure"				=> floatval($this->input->post('pressure')),
					  "temperatur"				=> floatval($this->input->post('temperatur')),
					  "kalori"					=> floatval($this->input->post('kalori')),
					  "isdaily"					=> 1,
					  "wobbe_index"				=> floatval($this->input->post('wobbe_index')),
					  "sg"						=> floatval($this->input->post('sg')),
					  "ch4"						=> floatval($this->input->post('ch4')),
					  "c2h6"					=> floatval($this->input->post('c2h6')),
					  "c3h8"					=> floatval($this->input->post('c3h8')),
					  "n_c4h10"					=> floatval($this->input->post('n_c4h10')),
					  "i_c4h10"					=> floatval($this->input->post('i_c4h10')),
					  "n_c5h12"					=> floatval($this->input->post('n_c5h12')),
					  "i_c5h12"					=> floatval($this->input->post('i_c5h12')),
					  "c6h14"					=> floatval($this->input->post('c6h14')),
					  "n2"						=> floatval($this->input->post('n2')),
					  "co2"						=> floatval($this->input->post('co2')),
					  "h2s"						=> floatval($this->input->post('h2s')),
					  "h2o"						=> floatval($this->input->post('h2o')),
					  "s"						=> floatval($this->input->post('s')),
					  "sodium_potassium"		=> floatval($this->input->post('sodium_potassium')),
					  "inerts"					=> floatval($this->input->post('inerts')),
					  "o2"						=> floatval($this->input->post('o2')),
					  "lead"					=> floatval($this->input->post('lead')),
					  "mg"						=> floatval($this->input->post('mg')),
					  "partikel"				=> floatval($this->input->post('partikel')),
					  "partikel_size"			=> floatval($this->input->post('partikel_size')),
					  "partikel_size"			=> floatval(),
					  "isapproval"				=> 1,
					  "typeapproval"			=> 2,
					  "credate"					=> dateTonum(date('Y-m-d H:i:s')),
					  "creperson"				=> $this->session->userdata('username')
					);
		$data_id = $this->b_model->insert_data('penygaskomposisifinal', $data);			
		
		$filter[0]['field'] = "rowid";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $this->input->post('rowid'));
								   
		
		$data_update = array("statusapproval"	=> "Approve",
							 "updperson"		=> $this->session->userdata('username'),
							 "upddate"			=> dateTonum(date('Y-m-d h:i:s'))
							);
							
		$this->b_model->update_data('gaskomposisidaily', $filter ,$data_update);
		
		$dataupd = array(
					  "penygaskomposisifinalrowid"	=> "PGK".$data_id,
					  "gaskomposisidailyrowid"	=> $this->input->post('rowid'),
					  "mstationrowid"			=> $this->input->post('stationcd'),
					  "tbl_station_id"			=> $this->input->post('stationid'),
					  "tgl_pencatatan"			=> dateTonum($this->input->post('tanggal_pencatatan')),
					  "pressure"				=> floatval($this->input->post('pressure')),
					  "temperatur"				=> floatval($this->input->post('temperatur')),
					  "kalori"					=> floatval($this->input->post('kalori')),
					  "isdaily"					=> 1,
					  "wobbe_index"				=> floatval($this->input->post('wobbe_index')),
					  "sg"						=> floatval($this->input->post('sg')),
					  "ch4"						=> floatval($this->input->post('ch4')),
					  "c2h6"					=> floatval($this->input->post('c2h6')),
					  "c3h8"					=> floatval($this->input->post('c3h8')),
					  "n_c4h10"					=> floatval($this->input->post('n_c4h10')),
					  "i_c4h10"					=> floatval($this->input->post('i_c4h10')),
					  "n_c5h12"					=> floatval($this->input->post('n_c5h12')),
					  "i_c5h12"					=> floatval($this->input->post('i_c5h12')),
					  "c6h14"					=> floatval($this->input->post('c6h14')),
					  "n2"						=> floatval($this->input->post('n2')),
					  "co2"						=> floatval($this->input->post('co2')),
					  "h2s"						=> floatval($this->input->post('h2s')),
					  "h2o"						=> floatval($this->input->post('h2o')),
					  "s"						=> floatval($this->input->post('s')),
					  "sodium_potassium"		=> floatval($this->input->post('sodium_potassium')),
					  "inerts"					=> floatval($this->input->post('inerts')),
					  "o2"						=> floatval($this->input->post('o2')),
					  "lead"					=> floatval($this->input->post('lead')),
					  "mg"						=> floatval($this->input->post('mg')),
					  "partikel"				=> floatval($this->input->post('partikel')),
					  "partikel_size"			=> floatval($this->input->post('partikel_size')),
					  "partikel_size"			=> floatval($this->input->post('partikel_size')),
					  "isapproval"				=> 1,
					  "typeapproval"			=> 2,
					  "status"					=> 2,
					  "credate"					=> dateTonum(date('Y-m-d H:i:s')),
					  "creperson"				=> $this->session->userdata('username')
					);
		$this->b_model->insert_data('h_penygaskomposisifinal', $dataupd);				
	}
	public function updategaskomdaily($reffidstation,$tgl)
	{
		$this->load->model('m_admin');	
		$cek_data;
		$n			 = 0;
		
		//$tgl = '2016-05-01';
		echo $tgl;
		
		$limit = 'All';
		
	    $offset = $this->input->get('start', TRUE);
		$filter[0]['field'] = "typeofrole";
		$filter[0]['data']  = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> "gaskomp");
								   
		$role = $this->b_model->get_all_data('ms_liberrorcode', $filter , $limit, $offset, '');
		
		$filter[0]['field'] = "typeofrole";
		$filter[0]['data']  = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> "gaskomp");
								   
		
		
		
		$stations = $this->m_admin->checkstation();
		
		
		
		//foreach($stations as $st)
		//{
			$sts = $reffidstation;
			
			$filter[0]['field'] = "stationid";
			$filter[0]['data']  = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $sts);
								   
			
			$filter[1]['field'] = "tanggal_pencatatan";
			$filter[1]['data']  = array("comparison"	=> "eq",
								   "type"		=> "date",
								   "value"		=> $tgl);
								   
			$data 		 = $this->b_model->get_all_data('v_gaskomposisidaily', $filter , $limit, $offset, '');
			//$data 	     = $this->m_admin->listGridDailycek($sts,$tgl);
			//$data = 
			//var_dump($data);
			$jmlh = count($data);
			if(!empty($data))
			{
				$res;
				foreach($role as $role_id)
				{
					$filterrole[0]['field'] = "id_ms_liberrorcode";
					$filterrole[0]['data']  = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $role_id->id);
								   
					$cek_data2 		 = $this->b_model->get_all_data('dt_msliberrcode', $filterrole , $limit, $offset, '');
					//$cek_data2 = $this->m_admin->showdetailrole($role_id->id);
					$cek_data[$n]->formula = $cek_data2;
					$cek_data[$n]->role_id = $role_id->id;
					$cek_data[$n]->flaging = $role_id->flaging;
					
					
					$n++;
				}
				$datares = array();
				foreach($data as $row){
					$data_before;
					$str = '';
					$str2 = '';
					$tgl_before = date('Y-m-d',strtotime($tgl . "-1 days"));
					//$filterdup = 
					$filterdup[0]['field'] = "stationid";
					$filterdup[0]['data']  = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $sts);
										   
					
					$filterdup[1]['field'] = "tanggal_pencatatan";
					$filterdup[1]['data']  = array("comparison"	=> "eq",
										   "type"		=> "date",
										   "value"		=> $tgl_before);
					$dp  = $this->b_model->get_all_data('v_gaskomposisidaily', $filterdup , $limit, $offset, '');
					//$dp  = $this->m_admin->cekdup($sts,$tgl);
					echo $tgl_before;
					foreach($cek_data as $cek)
					{
						foreach($cek->formula as $var)
						{
							$data_parameter = trim($var->formula);
							$data_parameter = str_replace("sgdp",$dp[0]->sg,$data_parameter);
							$data_parameter = str_replace("ch4dp",$dp[0]->ch4,$data_parameter);
							$data_parameter = str_replace("c2h6dp",$dp[0]->c2h6,$data_parameter);
							$data_parameter = str_replace("c3h8dp",$dp[0]->c3h8,$data_parameter);
							$data_parameter = str_replace("n_c4h10dp",$dp[0]->n_c4h10,$data_parameter);
							$data_parameter = str_replace("i_c4h10dp",$dp[0]->i_c4h10,$data_parameter);
							$data_parameter = str_replace("n_c5h12dp",$dp[0]->n_c5h12,$data_parameter);
							$data_parameter = str_replace("i_c5h12dp",$dp[0]->i_c5h12,$data_parameter);
							$data_parameter = str_replace("c6h14dp",$dp[0]->c6h14,$data_parameter);
							$data_parameter = str_replace("n2dp",$dp[0]->n2,$data_parameter);
							$data_parameter = str_replace("co2dp",$dp[0]->co2,$data_parameter);
							
							$data_parameter = str_replace("sg",empty($row->sg) ? 0 : $row->sg,$data_parameter);
							$data_parameter = str_replace("ch4",empty($row->ch4) ? 0 : $row->ch4,$data_parameter);
							$data_parameter = str_replace("c2h6",empty($row->c2h6) ? 0 : $row->c2h6,$data_parameter);
							$data_parameter = str_replace("c3h8",empty($row->c3h8) ? 0 : $row->c3h8,$data_parameter);
							$data_parameter = str_replace("n_c4h10",empty($row->n_c4h10) ? 0 : $row->n_c4h10,$data_parameter);
							$data_parameter = str_replace("i_c4h10",empty($row->i_c4h10) ? 0 : $row->i_c4h10,$data_parameter);
							$data_parameter = str_replace("n_c5h12",empty($row->n_c5h12) ? 0 : $row->n_c5h12,$data_parameter);
							$data_parameter = str_replace("i_c5h12",empty($row->i_c5h12) ? 0 : $row->i_c5h12,$data_parameter);
							$data_parameter = str_replace("c6h14",empty($row->c6h14) ? 0 : $row->c6h14,$data_parameter);
							$data_parameter = str_replace("n2",empty($row->n2) ? 0 : $row->n2,$data_parameter);
							$data_parameter = str_replace("co2",empty($row->co2) ? 0 : $row->co2,$data_parameter);
							
							echo "<pre>";
								var_dump($data_parameter);
							echo "</pre>";
							echo "<pre>";
								var_dump(eval($data_parameter));
							echo "</pre>";
							if(eval($data_parameter) == true)
							{
								//$datares[$row->stationid][$cek->role_id] = array ("val" => 1,
								//								   "bolval" => eval($data_parameter));
																   
								$datares[$row->rowid][$cek->role_id] = 1;								   
							}else
							{
								
								$datares[$row->rowid][$cek->role_id] = 0;								   
							
							}
							
						}
						
					}
				}
				
		foreach($datares as $rarea)
		{
			
			$juml = 0;
			$n=0;
			$a = array_keys($datares);
			
			foreach($datares as $keyrow=>$value) 
			{
				
					$filterde[0]['field'] = "reffrowid";
					$filterde[0]['data'] = array("comparison"	=> "eq",
										   "type"		=> "string",
										   "value"		=> $keyrow);
					$this->b_model->delete_data('tbl_detailerrormessage', $filterde);
					
					foreach($rarea as $key=>$valuea) 
					{
						
						
						$data_input = array ("reffrowid"	=> $keyrow,
								 "reffroleid"	=> $key,
								 "value"		=> $valuea);
											
						$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
					
					}
					
					foreach($rarea as $rv)
					{
						$juml = $rv+$juml;
						//var_dump($r);
						$n++;
					}
					
					$jc = $juml/$n;
					if($juml/$n == 1 )
					{
						$jc = 1;
					}else
					{
						$jc = 0;
					}
					
					$filterup[0]['field'] = "rowid";
					$filterup[0]['data'] = array("comparison"	=> "eq",
											   "type"			=> "string",
											   "value"			=> $keyrow);
					$data = array("statusdata"	=> $jc);		
							
					$this->b_model->update_data('gaskomposisidaily', $filterup ,$data);
				}
				
			}	
		}
			
	}
	public function updategaskomp()
	{
		$data = array(
					  //"gaskomposisidailyrowid"	=> $this->input->post('rowid'),
					  //"mstationrowid"			=> $this->input->post('stationcd'),
					  //"tbl_station_id"			=> $this->input->post('stationid'),
					  //"tgl_pencatatan"			=> dateTonum($this->input->post('tanggal_pencatatan')),
					  //"pressure"				=> floatval($this->input->post('pressure')),
					  //"temperatur"				=> floatval($this->input->post('temperatur')),
					  //"kalori"					=> floatval($this->input->post('kalori')),
					  //"isdaily"					=> 1,
					  "wobbe_index"				=> floatval($this->input->post('wobbe_index')),
					  "sg"						=> floatval($this->input->post('sg')),
					  "ch4"						=> floatval($this->input->post('ch4')),
					  "c2h6"					=> floatval($this->input->post('c2h6')),
					  "c3h8"					=> floatval($this->input->post('c3h8')),
					  "n_c4h10"					=> floatval($this->input->post('n_c4h10')),
					  "i_c4h10"					=> floatval($this->input->post('i_c4h10')),
					  "n_c5h12"					=> floatval($this->input->post('n_c5h12')),
					  "i_c5h12"					=> floatval($this->input->post('i_c5h12')),
					  "c6h14"					=> floatval($this->input->post('c6h14')),
					  "n2"						=> floatval($this->input->post('n2')),
					  "co2"						=> floatval($this->input->post('co2')),
					  //"h2s"						=> floatval($this->input->post('h2s')),
					  //"h2o"						=> floatval($this->input->post('h2o')),
					  //"s"						=> floatval($this->input->post('s')),
					  //"sodium_potassium"		=> floatval($this->input->post('sodium_potassium')),
					  //"inerts"					=> floatval($this->input->post('inerts')),
					  //"o2"						=> floatval($this->input->post('o2')),
					  //"lead"					=> floatval($this->input->post('lead')),
					  //"mg"						=> floatval($this->input->post('mg')),
					  //"partikel"				=> floatval($this->input->post('partikel')),
					  //"partikel_size"			=> floatval($this->input->post('partikel_size')),
					  //"partikel_size"			=> floatval(),
					  //"isapproval"				=> 1,
					  //"typeapproval"			=> 2,
					  "upddate"					=> dateTonum(date('Y-m-d H:i:s')),
					  "updperson"				=> $this->session->userdata('username')
					);
		$filter[0]['field'] = "rowid";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $this->input->post('rowid'));
							
		$this->b_model->update_data('gaskomposisidaily', $filter ,$data);	
		
		$this->updategaskomdaily($this->input->post('stationid'),$this->input->post('tanggal_pencatatan'));	
		
		$dataupd = array(
					  //"penygaskomposisifinalrowid"	=> "PGK".$data_id,
					  "gaskomposisidailyrowid"	=> $this->input->post('rowid'),
					  "mstationrowid"			=> $this->input->post('stationcd'),
					  "tbl_station_id"			=> $this->input->post('stationid'),
					  "tgl_pencatatan"			=> dateTonum($this->input->post('tanggal_pencatatan')),
					  "pressure"				=> floatval($this->input->post('pressure')),
					  "temperatur"				=> floatval($this->input->post('temperatur')),
					  "kalori"					=> floatval($this->input->post('kalori')),
					  "isdaily"					=> 1,
					  "wobbe_index"				=> floatval($this->input->post('wobbe_index')),
					  "sg"						=> floatval($this->input->post('sg')),
					  "ch4"						=> floatval($this->input->post('ch4')),
					  "c2h6"					=> floatval($this->input->post('c2h6')),
					  "c3h8"					=> floatval($this->input->post('c3h8')),
					  "n_c4h10"					=> floatval($this->input->post('n_c4h10')),
					  "i_c4h10"					=> floatval($this->input->post('i_c4h10')),
					  "n_c5h12"					=> floatval($this->input->post('n_c5h12')),
					  "i_c5h12"					=> floatval($this->input->post('i_c5h12')),
					  "c6h14"					=> floatval($this->input->post('c6h14')),
					  "n2"						=> floatval($this->input->post('n2')),
					  "co2"						=> floatval($this->input->post('co2')),
					  "h2s"						=> floatval($this->input->post('h2s')),
					  "h2o"						=> floatval($this->input->post('h2o')),
					  "s"						=> floatval($this->input->post('s')),
					  "sodium_potassium"		=> floatval($this->input->post('sodium_potassium')),
					  "inerts"					=> floatval($this->input->post('inerts')),
					  "o2"						=> floatval($this->input->post('o2')),
					  "lead"					=> floatval($this->input->post('lead')),
					  "mg"						=> floatval($this->input->post('mg')),
					  "partikel"				=> floatval($this->input->post('partikel')),
					  "partikel_size"			=> floatval($this->input->post('partikel_size')),
					  "partikel_size"			=> floatval($this->input->post('partikel_size')),
					  "isapproval"				=> 1,
					  "typeapproval"			=> 2,
					  "status"					=> 2,
					  "credate"					=> dateTonum(date('Y-m-d H:i:s')),
					  "creperson"				=> $this->session->userdata('username')
		);
		$this->b_model->insert_data('h_penygaskomposisifinal', $dataupd);
	}
	public function cekang()
	{
		//IF(Flow_Rate!= 0){RETURN TRUE;}ELSE{RETURN FALSE;}
		$c = eval('IF(81!=0){RETURN TRUE;}else{RETURN FALSE;}');
		
		//$d = 81.33 +  3.28 +  2.53 +  0.57 +  0.51 +  0.15 +  0 + 0.54 +  4.7 +  6.18;
		var_dump($c);
	}
	
	
	
}
<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Admin extends CI_Controller {
	public function __construct()
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
		if($_GET['node']=='root'){			
			$node = 0;
		}
		else{
			$node = $_GET['node'];
		}
		
		$this->load->model('m_admin');
		$this->m_admin->showMenu($node,$username);
	}
	
	public function showmenutree()
	{
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
		$columngrid = [];
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
		$columngrid = [];
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
		
		var_dump($as);
	}
	public function cekanomalihourly()
	{
		//echo "OK";
		$this->load->model('m_admin');	
		$role 		 = $this->m_admin->listrolems();
		
		$cek_data;
		$n			 = 0;
		$data 	     = $this->m_admin->listGridHourlycek();
		
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
		echo "<pre>";
			var_dump($res);
		echo "<pre>";
	}
	public function cekanomalidaily()
	{
		$this->load->model('m_admin');	
		$role 		 = $this->m_admin->listrolems();
		$stations	 = $this->m_admin->checkstation();
		
		$cek_data;
		$n			 = 0;
		
		$station     = 27;
		$tgl 		 = 12;
		$bulan		 = 12;
		$tahun		 = 2015;
		
		
		foreach($stations as $st)
		{
			$sts = $st->reffidstation;
			//$sts = 24;
			
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
			//var_dump($data);
			foreach($data as $row)
			{
				$data_before;
				$str = '';
				$str2 = '';
				$jml_before = count($data_before);
				
				foreach($cek_data as $cek)
				{
					$jumlah = count($cek);
					if($jumlah > 0 and ($cek->role_id == '115112' or $cek->role_id == '115113'))
					{
						$str2 = '';
						foreach($cek->formula as $var)
						{
							$data_parameter = trim($var->formula);
							$str4 == false;
							if (strpos($data_parameter, 'duplicate') !== FALSE)
							{
								$str4 = true;
								if(strpos($data_parameter, 'Flow_Rate') !== FALSE)
								{
									$data_parameter = str_replace("duplicate","".$data_before->volume."","".$data_parameter."");
								}
								if(strpos($data_parameter, 'Rate_Energy') !== FALSE)
								{
									$data_parameter = str_replace("duplicate","".$data_before->energy."","".$data_parameter."");
								}
								if(strpos($data_parameter, 'Previous_Hourly_Net_Totalizer') !== FALSE)
								{
									$data_parameter = str_replace("duplicate","".$data_before->counter_volume."","".$data_parameter."");
								}
								if(strpos($data_parameter, 'Previous_Hourly_Net_Energy') !== FALSE)
								{
									$data_parameter = str_replace("duplicate","".$data_before->counter_energy."","".$data_parameter."");
								}
								if(strpos($data_parameter, 'Pressure_Outlet') !== FALSE)
								{
									$data_parameter = str_replace("duplicate","".$data_before->pout."","".$data_parameter."");
								}
								if(strpos($data_parameter, 'Temprature') !== FALSE)
								{
									$data_parameter = str_replace("duplicate","".$data_before->temperature."","".$data_parameter."");
								}
								if(strpos($data_parameter, 'Prev_Day_GHV') !== FALSE)
								{
									$data_parameter = str_replace("duplicate","".$data_before->ghv."","".$data_parameter."");
								}
								
								
							}else
							{
								$str4 = false;
							}
							
							
							
							$data_parameter = str_replace("Flow_Rate","".$row->volume."","".$data_parameter."");
							$data_parameter = str_replace("Rate_Energy",$row->energy,$data_parameter);
							$data_parameter = str_replace("Previous_Hourly_Net_Totalizer",$row->counter_volume,$data_parameter);
							$data_parameter = str_replace("Previous_Hourly_Net_Energy",$row->counter_energy,$data_parameter);
							$data_parameter = str_replace("Pressure_Outlet",$row->pout,$data_parameter);
							$data_parameter = str_replace("Temprature",$row->temperature,$data_parameter);
							$data_parameter = str_replace("Prev_Day_GHV",$row->ghv,$data_parameter);
							$ex1 = strpos("=",$data_parameter);
							
							$param = trim($data_parameter);
							$stat = eval($param);
								
								if($stat == false)
								{
									$str2 .= 0;
								}else
								{
									$str2 .= 1;
								}
								
								if (strpos($str2, '0') !== FALSE)
								{
									$str3 = 0;
								}else
								{
									$str3 = 1;
								}	
										
								$res[$a][$cek->role_id] = $str3;
								$res[$a][$cek->role_id.'d'] = $str2;
							
							
							//$statfin = $res[$a][$cek->role_id];
							//var_dump($statfin);
							
						}
					}
					$b++;	
				}
				
				$a++;
				$data_before = $row;
				
			}
			echo "<pre>";
				var_dump($res[1]);
			echo "</pre>";
			$data_update = $this->m_admin->updatepenyalurandaily($sts,$tgl,serialize($res[0]));
			
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
			$filter[0]['data'] = array("comparison"	=> "lt",
									   "type"		=> "date",
									   "value"		=> "2015-12-12");
			
			$filter[1]['field'] = "tglpenyalurandate";
			$filter[1]['data'] = array("comparison"	=> "gt",
									   "type"		=> "date",
									   "value"		=> "2015-12-10");
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		
		//wheretofilter($arrFilter);
			
		$dataas = $this->b_model->get_all_data('viewpenyalurandaily', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('viewpenyalurandaily', $filter);
		
		foreach ($dataas as $row) {
			$data[] = $row;
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
		
		foreach ($dataas as $row) {
			$data[] = $row;
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
	
	public function pelanggan()
	{
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 45;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);

	    $sorts = json_decode($this->input->get('sort', TRUE));
	    if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'tanggal_mapping_source desc';
	    }	    

	    $total_entries = $this->b_model->count_all_data('v_mappelsource', $filter = array());
	    $entries = $this->b_model->get_all_data('v_mappelsource', $filter = array(), $limit, $offset, $order_by);
	    $n = 0;
	    foreach ($entries as $row) {
	    	$ass[$n] = new stdClass();
	     	$ass[$n]->idpel 					= $row->idpel;
	     	$ass[$n]->accid 					= $row->accid;
	     	$ass[$n]->pelname 					= $row->pelname;
	     	$ass[$n]->jenispel 					= $row->jenispel;
	     	$ass[$n]->source_nama 				= $row->source_nama;
	     	$ass[$n]->tanggal 	 				= $row->tanggal_mapping_source;
	     	$ass[$n]->tanggal_mapping_source 	= numTodate($row->tanggal_mapping_source);
	     	$ass[$n]->jenis_station			 	= $row->jenis_station;
	     	$ass[$n]->sbu			 			= $row->sbu;
	     	$ass[$n]->jenis_sbu			 		= $row->jenis_sbu;
	     	$ass[$n]->area_		 				= $row->area_;
	     	$ass[$n]->stationname		 		= $row->stationname;
	     	$n++;

	     	// vd::dump($row->tanggal_mapping_source);
	    }

	    $data['success'] = true;
	    $data['total'] = $total_entries;
	    $data['data'] = $ass;
	    // $data['data'] = $entries;
	    // vd::dump($ass); 
	    extjs_output($data);
	}

	public function findamr ()
	{
		$this->load->model('b_model');
		
		$startt = $this->input->get('startt',true);
	    $endd = $this->input->get('endd',true);
		$sbu = $this->input->get('sbu',true);
	    $area = $this->input->get('area',true);
	    $id_pel = $this->input->get('id_pel',true);
	    $namapel = $this->input->get('namapel',true);			

		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);

	    $sorts = json_decode($this->input->get('sort', TRUE));
	    if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'tanggal desc';
	    }	    

	    $total_entries = $this->b_model->count_all_data('v_amr_bridge', $filter = array());
		$entries = $this->b_model->find_amr_data('v_amr_bridge',
		$startt, $endd, $sbu, $area, $id_pel, $namapel,
		$filter = array(), $limit, $offset, $order_by
		);
		
	    $data['success'] = true;
	    $data['total'] = $total_entries;
	    $data['data'] = $entries;
	    // $data['data'] = $entries;
	    // vd::dump($ass); 
	    extjs_output($data);

	}
	public function insertdatamanualbulk()
	{
		$this->load->model('b_model');
		
		$data_input = $this->input->post();
		
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
		$data_update = array("volume"	=> $data_input['volume'],
							"energy"	=> $data_input['energy'],
							"ghv"		=> $data_input['ghv'],
							"pin"		=> $data_input['pin'],
							"pout"		=> $data_input['pout'],
							"pout"		=> $data_input['pout'],
							"temperature"		=> $data_input['temperature'],
							"counter_volume"		=> $data_input['counter_volume'],
							"counter_energy"		=> $data_input['counter_energy']);
							
		$this->b_model->update_data('tbl_penyalurandaily', $filter ,$data_update);
		
		//$data[] = array("tbl_parameter"	=> '',
					  //"tgl_pengukuran"	=> '',
					  //"parameter_periode"	=> '',
					  //"tbl_parametervalue"	=> '',
					  //"tbl_station_id"		=> '');
						
		//$this->b_model->find_amr_data('tbl_penyalurandaily',$data);
		
	}
	public function updatedatabulkhourly()
	{
		
	}
	
}
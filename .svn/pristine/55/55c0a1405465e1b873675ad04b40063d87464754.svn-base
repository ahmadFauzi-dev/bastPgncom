<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Cekanomali extends CI_Controller {
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
	   public function index()
	   {
			
			$this->load->model('m_admin');	
			$role 		 = $this->m_admin->listrolems();
			$stations	 = $this->m_admin->checkstation();
			
			$cek_data;
			$n			 = 0;
			
			$kemarin = date("Y-m-d", time() - 86400);
			$kemarinlusa = date("Y-m-d", time() - 172800);
			
			//$kemarin = '2016-07-31';
			//$kemarinlusa = '2016-07-30';
			
			$tgl = $kemarin;
			echo $tgl;
			//die();
			foreach($stations as $st)
			{
				$str2 = '';
				$sts = $st->reffidstation;
				//$sts = 23;
				
				$data 	     = $this->m_admin->listGridDailycek($sts,$tgl);
				$role 		 = $this->m_admin->listrolems();
				$res;
				echo "<pre>";
					var_dump($data);
				echo "</pre>";
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
						
						$juml = 0;
						$n = 0;
						$jc = 0;
						foreach($rarea as $key=>$valuea) 
						{
							
							
							
							$juml = $juml + $valuea;
							$n++;
							$data_input 	= array ("reffrowid"	=> $keyrow,
													"reffroleid"	=> $key,
													 "value"		=> $valuea);
												
							$this->b_model->insert_data('tbl_detailerrormessage', $data_input);
						
						}
						
						/*
						foreach($upd as $r)
						{
							
							$juml = $r+$juml;
							$n++;
						}
						*/
						
						
						$jc = $juml/$n;
						
						if($jc < 1 )
						{
							$jc = 0;
						}
						
						$filterup[0]['field'] = "rowid";
						$filterup[0]['data'] = array("comparison"	=> "eq",
												   "type"			=> "string",
												   "value"			=> $keyrow);
						
						$data = array("statusdata"	=> $jc);		
								
						$this->b_model->update_data('realisasipenyaluranstationdaily', $filterup ,$data);
				}
					
			}	
				
				
			}
	   }
	   public function gaskomp()
	   {
			
			$this->load->model('m_admin');	
			$cek_data;
			$n			 = 0;
			$kemarin = date("Y-m-d", time() - 86400);
			$kemarinlusa = date("Y-m-d", time() - 172800);
			$tgl = $kemarin;
			echo $tgl;
			
			$limit = 'All';
			
			$offset = $this->input->get('start', TRUE);
			$filter[0]['field'] = "typeofrole";
			$filter[0]['data']  = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> "gaskomp");
									   
			$role = $this->b_model->get_all_data('ms_liberrorcode', $filter , $limit, $offset, '');
			
			
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
	public function cekphptest()
	{
		echo "OK";
	}
	public function importmapelsourcebatch()
	{
		
		//echo $this->uri->segment(4);
		
		//die();
		$start = $this->uri->segment(5);
		$end   = $this->uri->segment(6);
		
		
		$start = $this->uri->segment(5);
		$end   = $this->uri->segment(6);
		
		$path = substr(BASEPATH,0,-7).'document/import/';
		$nama_file = $this->uri->segment(4);
		
		$inputFileName = $path.''.$nama_file.'';
		
		try {
			$inputFileType = PHPExcel_IOFactory::identify($inputFileName);
			$objReader = PHPExcel_IOFactory::createReader($inputFileType);
			$objPHPExcel = $objReader->load($inputFileName);
		} catch(Exception $e) {
			die('Error loading file "'.pathinfo($inputFileName,PATHINFO_BASENAME).'": '.$e->getMessage());
		}

		//  Get worksheet dimensions
		$sheet = $objPHPExcel->getSheet(0); 
		$highestRow = $sheet->getHighestRow(); 
		$highestColumn = $sheet->getHighestColumn();

		//  Loop through each row of the worksheet in turn
		$data = array();
		$dataupdate = array();
		$n=0;
		
		for ($row = 6; $row <= $highestRow; $row++){ 
			
			$rowData = $sheet->rangeToArray('A' . $row . ':' . $highestColumn . $row,
											NULL,
											TRUE,
											FALSE);
			
			$dexplode = explode("|", $rowData[0][3]);
			$mstationrowid = $dexplode[0];
			$stationid	   = $dexplode[1];
			IF($rowData[0][0] != NULL){
			$data[$n] = array("idrefpelanggan"	=> $rowData[0][0],
									"Namapelanggan"		=> $rowData[0][1],
									"Stationghv"		=> $rowData[0][2],
									"ghvid"				=> $rowData[0][3],
									"mstationrowid"		=> $mstationrowid,
									"stationid"			=> $stationid);
			}						
							  	
			$n++;
		}
		
		$startTime = strtotime($start);
		$endTime = strtotime($end);
		
		for ( $i = $startTime; $i <= $endTime; $i = $i + 86400 )
		{
			 $thisDate = date( 'Y-m-d 00:00:00', $i );
			  foreach($data as $row)
			  {
				
				
				$filteras[0]['field'] = "idrefpelanggan";
				$filteras[0]['data']  = array("comparison"		=> "eq",
											"type"				=> "string",
											"value"				=> substr($row['idrefpelanggan'],1));
				$filteras[1]['field'] = "tanggal";
				$filteras[1]['data']  = array("comparison"		=> "eq",
											"type"				=> "numeric",
											"value"				=> dateTonum($thisDate));
											
				$count		 = $this->b_model->count_all_data('mapmultisource', $filteras);
				
				if($count > 0)
				{
					$this->b_model->delete_data('mapmultisource', $filteras);
					$data_input = array("idrefpelanggan"	=> substr($row['idrefpelanggan'],1),
										"tanggal"			=> dateTonum($thisDate),
										"mstationrowid"		=> $row['mstationrowid'],
										"stationid"			=> $row['stationid'],
										//"ismultisource"		=> $this->input->post('ismulti'),
										"creperson"			=> $this->session->userdata('username'),
										"credate"			=> dateTonum(date('Y-m-d h:i:s'))
					);
					
					
					$this->b_model->insert_data('mapmultisource', $data_input);
					
				}else
				{
					$data_input = array("idrefpelanggan"	=> substr($row['idrefpelanggan'],1),
										"tanggal"			=> dateTonum($thisDate),
										"mstationrowid"		=> $row['mstationrowid'],
										"stationid"			=> $row['stationid'],
										//"ismultisource"		=> $this->input->post('ismulti'),
										"creperson"			=> $this->session->userdata('username'),
										"credate"			=> dateTonum(date('Y-m-d h:i:s'))
					);
					
					
					$this->b_model->insert_data('mapmultisource', $data_input);
					
				}
				
			  }
		}
	}
	
	public function downloaddok()
	{
		
		//$kemarin = date("Ymd", time() - 86400);
		//$kemarin = '20160801';
		//$kemarin = date("Ymd");
		//$kemarin = "20160703";
		//echo $kemarin;
		$limit = 'All';
		$offset = 0;
		$this->load->model('b_model');
		$filter = array();
		/*
		$filter[0]['field'] = "credatenum";
		$filter[0]['data']  = array("comparison"	=> "eq",
							   "type"		=> "numeric",
							   "value"		=> intval($kemarin));
							   
		
		*/
		$dp  = $this->b_model->get_all_data('v_docreff_mastercekdok', $filter , $limit, $offset, '');
	
		//die();
		foreach($dp as $row)
		{
			$prot = "https://";
			$url  = $prot."gms.pgn.co.id/api/services/files/realisasi_station/download/".$row->docpath."";
			$params = "token=S1PG4sEMb3rsAtu";
			
			$urlexec = $url."".$params;
			
			//$url  = "".$prot."smsblast.id/api/sendsingle?user=pgnjkt&password=pgnjkt123&senderid=PGN&message=".$pesans."&msisdn=".$row."";
			
			$options = array(
				CURLOPT_URL			   => $url,
				CURLOPT_RETURNTRANSFER => true,     // return web page
				CURLOPT_HEADER         => false,    // don't return headers
				CURLOPT_FOLLOWLOCATION => true,     // follow redirects
				CURLOPT_ENCODING       => "",       // handle all encodings
				CURLOPT_USERAGENT      => "EM REQUEST", // who am i
				CURLOPT_AUTOREFERER    => true,     // set referer on redirect
				CURLOPT_CONNECTTIMEOUT => 120,      // timeout on connect
				CURLOPT_TIMEOUT        => 120,      // timeout on response
				CURLOPT_MAXREDIRS      => 10,       // stop after 10 redirects
				CURLOPT_SSL_VERIFYPEER => false ,
				CURLOPT_POST		   =>  TRUE,
				CURLOPT_POSTFIELDS	   => $params
			);

			$ch      = curl_init( $url );
			curl_setopt_array( $ch, $options );
			$resp = curl_exec( $ch );
			$err     = curl_errno( $ch );
			$errmsg  = curl_error( $ch );
			$header  = curl_getinfo( $ch );
			
			//$destination = "./files/test.pdf";
			//$file = fopen($destination, "w+");
			//fputs($file, $data);
			//fclose($file);
			
			//$resp = curl_exec($curl);
			$path = substr(BASEPATH,0,-7).'document/upload/'.$row->docname.'';
			//$destination = "./files/test.pdf";
			$file = fopen($path, "w+");
			fputs($file, $resp);
			fclose($file);
			
			$filterup[0]['field'] = "rowid";
			$filterup[0]['data'] = array("comparison"	=> "eq",
									   "type"			=> "string",
									   "value"			=> $row->rowid);
									   
			$data = array("docpath"	=> 'document/upload/'.$row->docname.'',
						  "updperson"	=> 'system',
						  "upddate"		=> dateTonum(date('Y-m-d H:i:s'))
						  );		
			echo "<pre>";
				var_dump($row->rowid);
			echo "</pre>";
			
			echo "<pre>";
				var_dump($data);
			echo "</pre>";
			$this->b_model->update_data('doc_refference', $filterup ,$data);
			
		}
		
		//header("Location: ".base_url()."document/upload/test.pdf");
		
	}
	public function kelengkapan_data_sla()
	{
		$rd = $this->uri->segment(4);
		$to = array();
		//echo $rd;
		
		$filter[0]['field'] = "isinfo";
		$filter[0]['data']  = array("comparison"	=> "eq",
								   "type"			=> "numeric",
								   "value"			=> 8);
		
		$filter[1]['field'] 	= "areacode";
		$filter[1]['data']  	= array("comparison"	=> "eq",
								   "type"			=> "string",
								   "value"			=> $rd);
								   
		$datatemplate = $this->b_model->get_all_data('general_info', $filter , 2 , 0 , '');
		echo $rd;
		
		$email_temp   = $datatemplate[0]->email;
		$email_exp	  = explode(';',$email_temp);

		foreach($email_exp as $emp)
		{
			array_push($to,$emp);
		}
		
		$subject 	= $datatemplate[0]->subject;
		$pesan 		= $datatemplate[0]->template;	
		$this->load->model('b_model');
		
		$kemarin = whereTofilter('tanggal', date("Y-m-d", time() - 86400) , 'date' , 'lt');
		$kemarinlusa = whereTofilter('tanggal', date("Y-m-d", time() - 86400) , 'date' , 'gt');
		
		$tanggalnya = date("Y-m-d", time() - 86400);
		
		$filter = array();		
		
		$startt = $this->input->get('startt',true) > '' ? whereTofilter('tanggal', $this->input->get('startt',true) , 'date' , 'gt') : $kemarinlusa ;
		$endd = $this->input->get('endd',true) > '' ? whereTofilter('tanggal', $this->input->get('endd',true) , 'date' , 'lt') : $kemarin ;	
		$sbu = whereTofilter('rdcode', $rd , 'string' , 'eq');
		array_push($filter, $startt, $endd, $sbu);
		
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
		
	    $total_entries  = $this->b_model->count_all_data('v_summary_kelengkapan_data', $filter);
		$entries 		= $this->b_model->get_all_data('v_summary_kelengkapan_data', $filter , $limit, $offset, $order_by);
		
		$path = substr(BASEPATH,0,-7).'asset/xls/';	
		$topath = substr(BASEPATH,0,-7).'asset/tmp/';	
		$objReader = PHPExcel_IOFactory::createReader('Excel5');
		$objPHPExcel = $objReader->load($path.'kelengkapan_data_sla.xls');
		
		$objPHPExcel->getActiveSheet()->setCellValue('A1', 'Kelengkapan Data '. $tanggalnya );
		$objPHPExcel->getActiveSheet()->getColumnDimension('F')->setAutoSize(true);
		
		
		
		$baseRow = 4;
		
		foreach ($entries as $datarow) {
			$row = $baseRow + $n;
			//foreach($datarow as $key=>$value)
			
			$objPHPExcel->getActiveSheet()->setCellValue('A'.$row, $n+1)
										  ->setCellValue('B'.$row, $datarow->tanggal)
										  ->setCellValue('C'.$row, $datarow->sbu)
										  ->setCellValue('D'.$row, $datarow->area)
										  ->setCellValue('E'.$row, $datarow->jmlh_data_alert)
										  ->setCellValue('F'.$row, $datarow->total_crm)
										  ->setCellValue('G'.$row, $datarow->jmlh_data_daily)
										  ->setCellValue('H'.$row, $datarow->missing_crm)
										  ->setCellValue('I'.$row, $datarow->missing_amrboard)
										  ->setCellValue('J'.$row, $datarow->completed)
										  ->setCellValue('K'.$row, $datarow->incompleted)
										  ->setCellValue('L'.$row, $datarow->empty_hourly)
										  ->setCellValue('M'.$row, $datarow->good)
										  ->setCellValue('N'.$row, $datarow->warning)
										  ->setCellValue('O'.$row, $datarow->anomali);										 
										   
			$n++;
		}
		
		$conditional = new PHPExcel_Style_Conditional();
		$conditional->setConditionType(PHPExcel_Style_Conditional::CONDITION_CELLIS)
				->setOperatorType(PHPExcel_Style_Conditional::OPERATOR_EQUAL)
				->addCondition('"-"');
		$conditional->getStyle()->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getEndColor()->setARGB('ffa7a7');		
		$conditional2 = new PHPExcel_Style_Conditional();
		$conditional2->setConditionType(PHPExcel_Style_Conditional::CONDITION_CELLIS)
				->setOperatorType(PHPExcel_Style_Conditional::OPERATOR_NOTEQUAL)
				->addCondition('"-"');
		$conditional2->getStyle()->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getEndColor()->setARGB('98fb98');		
		$conditionalStyles = $objPHPExcel->getActiveSheet()->getStyle('A3')->getConditionalStyles();
		array_push($conditionalStyles, $conditional, $conditional2 );               
		$objPHPExcel->getActiveSheet()->getStyle('A$3:AG$'.$row)->setConditionalStyles($conditionalStyles);		
		
		$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
		$file = "".$topath."kelengkapan_data_sla". $tanggalnya. ".xlsx";
		$objWriter->save($file);
		
		
		$mail = new PHPMailer();		
		$mail->isSMTP();
		$mail->Headers = 'Content-type: text/html; charset=iso-8859-1';
		$mail->Host = 'mail.pgn.co.id';
        $mail->Port = '25'; 
        $mail->SMTPAuth = true;
	    $mail->Username = 'corp\mng1';
        $mail->Password = 'corp.PGN';
        $mail->From = 'mng1@pgn.co.id';
		$mail->FromName = 'SPG-EM';
		$mail->SMTPSecure = "tls";
		$mail->WordWrap = 50; 
       
		//$mail->AddAddress('person1@domain.com', 'Person One');
		//$mail->AddAddress('person2@domain.com', 'Person Two');
		
		foreach($to as $r)
		{
			
			if(!empty($r))
			{
				$mail->addAddress($r);
			}
			//$mail->addAddress($r);
		}
		$mail->Subject = $subject;
		$mail->Body 	= $pesan;
		$mail->IsHTML(true);		
		$mail->AddAttachment($file);
        $mail->send();
		//$this->send_emailmultiaddress($to, $subject, $pesan, $file);
		//delete_files( $topath );
		
		
	}
}
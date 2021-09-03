<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Siangsa extends MY_Controller {
function __construct() {		
        parent::__construct();        
    }
		public function index()
		{
			vd::dump($this->session->userdata('username'));
		}
		public function listOrganization()
		{
			$username =  $this->session->userdata('username');				
			$user_id =  $this->session->userdata('user_id');	
			$node = $this->input->get('node');
			$this->load->model('m_admin');
			//$this->m_admin->listOrganization($node,$username);
		}
		public function listJabatan()
		{
			$username =  $this->session->userdata('username');				
			$user_id =  $this->session->userdata('user_id');	
			$node = $this->input->get('node');
			$this->load->model('m_admin');
			//$this->m_admin->listJabatan($node,$username);
		}
		public function dragdrop()
		{
			$tb	= $this->input->post('tb');
			$wr	= $this->input->post('wr');
			$drop_id	= $this->input->post('drop_id');
			$target_id	= $this->input->post('target_id');
			
			$where = array(
				$wr => $drop_id
			); 
			
			$data = array("parent" => $this->input->post('target_id'));
			$this->load->model('b_model');
			$this->b_model->update_all($tb,$where,$data);
		}
		public function add_draft()
		{
			
			$this->load->model('b_model');
			$this->load->helper('security');
			
			$username =  $this->session->userdata('username');				
			$user_id =  $this->session->userdata('user_id');				
			$myname =  $this->session->userdata('nama');
			$divisi_id =  $this->session->userdata('divisi_id');				
			$nama_divisi =  $this->session->userdata('nama_divisi');				
			$date_now = date('Y-m-d h:i:s');
			
			$rowid = $this->input->post('rowid',true);
			$no_surat = $this->input->post('no_surat',true);			
			$str_satuankerja = $this->input->post('str_satuankerja',true);
			$reffperusahaan = $this->input->post('reffperusahaan',true);
			//$nama_perusahaan = $this->input->post('nama_perusahaan',true);
			$reffjenissurat = $this->input->post('reffjenissurat',true);
			$str_jenissurat = $this->input->post('str_jenissurat',true);
			$tanggal_surat = $this->input->post('tanggal_surat',true);
			$judul_bast = $this->input->post('judul_bast',true);
			$persen_pembayaran = $this->input->post('persen_pembayaran',true);
			$nominal_projek = $this->input->post('nominal_projek',true);
			$termin = $this->input->post('termin',true);
			$denda = $this->input->post('denda',true);
			$reffapprovalph2 = $this->input->post('reffapprovalph2',true);
			$kerja_tambah = $this->input->post('kerja_tambah',true);
			$nominal_pembayaran=round($nominal_projek*$persen_pembayaran / 100,2);
			
			$tujuan_surat = $this->input->post('tujuan_surat',true);
			$refflokasi = $this->input->post('refflokasi',true);
			$reffph2 = $this->input->post('reffph2',true);
			
			$lokasi = $this->input->post('lokasi',true);
			         
			$user_by 	  = ($rowid == '0' ? 'create_by' : 'update_by');
			$user_date = ($rowid == '0' ? 'create_date' : 'update_date');
			
			
			$dataWorkflow 		= $this->input->post('dataWorkflow', TRUE);
			$dataWorkflow 		= json_decode($dataWorkflow);
			
			$dataBiayatambah 		= $this->input->post('dataBiayatambah', TRUE);
			$dataBiayatambah 		= json_decode($dataBiayatambah);
			
			if ($rowid == '0'){						
				
				$dataDraft = array(
								'no_bast' => $no_surat,
								'reffjenissurat' => $reffjenissurat,
								//'tanggal_surat' => $tanggal_surat,
								'judul_bast' => $judul_bast,
								'persen_pembayaran' => $persen_pembayaran,
								'nominal_projek' => $nominal_projek,
								'termin' => $termin,
								'nominal_pembayaran' => $nominal_pembayaran,
								'reffph2' => $reffph2,
								'reffapprovalph2' => $reffapprovalph2,
								'lokasi' => $lokasi,
								'denda' => $denda,
								'kerja_tambah' => $kerja_tambah,
								$user_by => $username,
								$user_date => $date_now
				);
				$surat_id = $this->b_model->insert_data('tb_bast',$dataDraft);
				$refftransaction = $surat_id;			
				
				
					foreach ($dataWorkflow as $itemsWorkflow)
					{
						$dataaWorkflow = array(				
									'reffjobpos' => $itemsWorkflow->reffjabatan,
									'status_jabatan' => $itemsWorkflow->status_jabatan,
									'refftransaction' =>$refftransaction,
									'str_jobpos' => $itemsWorkflow->str_jobpos,
									'description' => $itemsWorkflow->description,
									'create_by' => $username,
									'create_date' => $date_now
						);
						
						$this->b_model->insert_data('ms_workflowdetail', $dataaWorkflow);
					}
				
				foreach ($dataBiayatambah as $itemsBiayatambah)
				{
					$dataaBiayatambah = array(				
								'reffjenis' => $itemsBiayatambah->reffjenis,
								'nominal' => $itemsBiayatambah->nominal,
								'refftransaction' =>$refftransaction,
								'keterangan' => $itemsBiayatambah->keterangan,
								'create_by' => $username,
								'create_date' => $date_now
					);
					
					$this->b_model->insert_data('tb_biayatambahan', $dataaBiayatambah);
					//$nominal_pembayaran += floor($nominal_pembayaran.' '.$itemsBiayatambah->mvalue.' '.$itemsBiayatambah->nominal);
				}
				

			}
			else{			
				
				$dataDraft = array(
								'no_bast' => $no_surat,
								'reffjenissurat' => $reffjenissurat,
								//'tanggal_surat' => $tanggal_surat,
								'judul_bast' => $judul_bast,
								'persen_pembayaran' => $persen_pembayaran,
								'nominal_projek' => $nominal_projek,
								'termin' => $termin,
								'nominal_pembayaran' => $nominal_pembayaran,
								'reffapprovalph2' => $reffapprovalph2,
								'reffstatus' => 'MD415',
								'reffph2' => $reffph2,
								'denda' => $denda,
								'kerja_tambah' => $kerja_tambah,
								$user_by => $username,
								$user_date => $date_now
				);
				
				$whered = array('rowid' =>  $rowid);
				$this->b_model->update_all('tb_bast', $whered,$dataDraft);		
				
				//print_r($dataWorkflow);
				//die();
				if (!empty($dataWorkflow)){
					$dfilteras1[0]['field'] = "refftransaction";
					$dfilteras1[0]['data'] = array(
												   "type"		=> "string",
												   "comparison"	=> "eq",
												   "value"		=> $rowid); 
					$this->b_model->delete_data('ms_workflowdetail', $dfilteras1);
					
					foreach ($dataWorkflow as $itemsWorkflow)
					{
						$dataaWorkflow = array(				
									'reffjobpos' => $itemsWorkflow->reffjobpos,
									'status_jabatan' => $itemsWorkflow->status_jabatan,
									'refftransaction' =>$rowid,
									'str_jobpos' => $itemsWorkflow->str_jobpos,
									'description' => $itemsWorkflow->description,
									'create_by' => $username,
									'create_date' => $date_now
						);
						
						$this->b_model->insert_data('ms_workflowdetail', $dataaWorkflow);
					}
				}
				
				$dfilteras2[0]['field'] = "reffsurat";
				$dfilteras2[0]['data'] = array(
											   "type"		=> "string",
											   "comparison"	=> "eq",
											   "value"		=> $rowid); 
				$this->b_model->delete_data('tbl_attdokumen', $dfilteras2);
				
				$refftransaction = $rowid;
				
				
				$dfilteras3[0]['field'] = "refftransaction";
				$dfilteras3[0]['data'] = array(
											   "type"		=> "string",
											   "comparison"	=> "eq",
											   "value"		=> $rowid); 
				$this->b_model->delete_data('tb_biayatambahan', $dfilteras3);
				
				foreach ($dataBiayatambah as $itemsBiayatambah)
				{
					$dataaBiayatambah = array(				
								'reffjenis' => $itemsBiayatambah->reffjenis,
								'nominal' => $itemsBiayatambah->nominal,
								'refftransaction' =>$rowid,
								'keterangan' => $itemsBiayatambah->keterangan,
								'create_by' => $username,
								'create_date' => $date_now
					);
					
					$this->b_model->insert_data('tb_biayatambahan', $dataaBiayatambah);
					//$nominal_pembayaran += floor($nominal_pembayaran.' '.$itemsBiayatambah->mvalue.' '.$itemsBiayatambah->nominal);
				}
				
			}
			
			$dataAttdokumen 		= $this->input->post('dataAttdokumen', TRUE);
			$dataAttdokumen 		= json_decode($dataAttdokumen);		
			
			foreach ($dataAttdokumen as $itemsAttdokumen)
			{
				$dataaAttdokumen = array(				
							'name' => $itemsAttdokumen->name,
							'reffsurat' => $refftransaction,
							'url_document' => $itemsAttdokumen->url_document,
							'nomor' => $itemsAttdokumen->nomor,
							'tanggal' => $itemsAttdokumen->tanggal,
							'jenis_dokumen' => $itemsAttdokumen->jenis_dokumen,
							'create_by' => $username,
							'create_date' => $date_now
				);
				$this->b_model->insert_data('tbl_attdokumen', $dataaAttdokumen);
			}
			

			if ($rowid != '0'){
				$filtere[0]['field'] = "refftransaction";
				$filtere[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $refftransaction);
				$bdata = $this->b_model->get_all_data('v_workflowdetail', $filtere ,10, '', '');		
				
				foreach($bdata as $bd){
					$filterus[0]['field'] = "reffjabatan";
					$filterus[0]['data'] = array(
											   "type"		=> "string",
											   "comparison"	=> "eq",
											   "value"		=> $bd->reffjobpos);							
					$datauser = $this->b_model->get_all_data('v_revuser', $filterus ,1, '', '');					
					$emailtemplate = $this->email_temp('MD336','MD297',$refftransaction,'MD319',$bd->description);
					
					$dataelog = array (
										'from' => 'fauzzi95@gmail.com',
										'refftransaction' => $refftransaction,
										'created_by' =>$username,
										'created_on' => $date_now,
										'to' => $datauser[0]->email,
										'text_email' => $emailtemplate['template'],
										'subject' => $emailtemplate['subject']
					);
					$this->b_model->insert_data('email_log', $dataelog);
				}
			}else
			{
				$filtere[0]['field'] = "refftransaction";
				$filtere[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $refftransaction);
				$bdata = $this->b_model->get_all_data('v_workflowdetail', $filtere ,10, '', '');		
				
				foreach($bdata as $bd){
					$filterus[0]['field'] = "reffjabatan";
					$filterus[0]['data'] = array(
											   "type"		=> "string",
											   "comparison"	=> "eq",
											   "value"		=> $bd->reffjobpos);							
					$datauser = $this->b_model->get_all_data('v_revuser', $filterus ,1, '', '');					
					$emailtemplate = $this->email_temp('MD425','MD296',$refftransaction,'MD319',$bd->description);
					
					$dataelog = array (
										'from' => 'fauzzi95@gmail.com',
										'refftransaction' => $refftransaction,
										'created_by' =>$username,
										'created_on' => $date_now,
										'to' => $datauser[0]->email,
										'text_email' => $emailtemplate['template'],
										'subject' => $emailtemplate['subject']
					);
					$this->b_model->insert_data('email_log', $dataelog);
				}
			}
			//var_dump($filename);
			/* if ($action == 'kirim'){
				$this->email_send($refftransaction);
			} */
			
			$json   = array( 'success' => TRUE);
			echo json_encode($json);
		}
		public function add_bast()
		{
			
			$this->load->model('b_model');
			$this->load->helper('security');
			
			$username =  $this->session->userdata('username');				
			$user_id =  $this->session->userdata('user_id');				
			$myname =  $this->session->userdata('nama');
			$divisi_id =  $this->session->userdata('divisi_id');				
			$nama_divisi =  $this->session->userdata('nama_divisi');				
			$date_now = date('Y-m-d h:i:s');
			
			$rowid = $this->input->post('rowid',true);
			$tanggal_surat = $this->input->post('tanggal_surat',true);			
			$no_surat = $this->input->post('no_surat',true);			
			$reffph1 = $this->input->post('reffph1',true);
			$nama_pejabat = $this->input->post('nama_pejabat',true);
			$nama_jabatan = $this->input->post('nama_jabatan',true);
						
			$dataDraft = array(
								'no_bast' => $no_surat,
								'tanggal_surat' => $tanggal_surat,
								'reffph1' => $reffph1,
								'nama_ph1' => $nama_pejabat,
								'jabatan_ph1' => $nama_jabatan,
								'reffstatus' => 'MD414',
								'update_by' => $username,
								'update_date' => $date_now
			);
			/* var_dump($dataDraft);
			die();	 */		
						
			$whered = array('rowid' =>  $rowid);
			$this->b_model->update_all('tb_bast', $whered,$dataDraft);
			
			//email
			/* $filterus[0]['field'] = "rowid";
			$filterus[0]['data'] = array(
									   "type"		=> "string",
									   "comparison"	=> "eq",
									   "value"		=> $rowid);							
			$datauser = $this->b_model->get_all_data('v_userbast', $filterus ,1, '', '');					
			$emailtemplate = $this->email_temp('MD336','MD297',$refftransaction,'MD320',$description);
			
			$dataelog = array (
								'from' => 'fauzzi95@gmail.com',
								'refftransaction' => $rowid,
								'created_by' =>$username,
								'created_on' => $date_now,
								'to' => $datauser[0]->email,
								'text_email' => $emailtemplate['template'],
								'subject' => $emailtemplate['subject']
			);
			$this->b_model->insert_data('email_log', $dataelog); */								
			$json   = array( 'success' => TRUE);
			echo json_encode($json);
		}
		public function html2pdf_disposisi($filename,$data)
		{
			
			//Load the library
			$this->load->library('html2pdf');
			
			//Set folder to save PDF to
			$this->html2pdf->folder('./asset/pdfs/');
			
			//Set the filename to save/download as
			
			$this->html2pdf->filename($filename);
			
			//Set the paper defaults
			$this->html2pdf->paper('a4', 'portrait');
			//$image = str_replace('<img src="','<img src="'.base_url().'/document',$img);
			//Load html view
			$this->html2pdf->html($this->load->view('admin/template_disposisi', $data, true));
			//$this->load->view('admin/template_disposisi', $data, true);
			if($this->html2pdf->create('save')) {
				//PDF was successfully saved or downloaded
				//echo 'PDF saved';
			}
		}
		public function html2pdf($filename,$data,$ukurankertas,$template)
		{		
			//Load the library
			$this->load->library('html2pdf');
			
			//Set folder to save PDF to
			$this->html2pdf->folder('./asset/pdfs/');
			
			//Set the filename to save/download as
			
			$this->html2pdf->filename($filename);
			
			//Set the paper defaults
			$this->html2pdf->paper('A4', 'portrait');
			//Load html view
		   $this->html2pdf->html($this->load->view('admin/template_suratkeluar.php', $data, true));
			
			if($this->html2pdf->create('save')) {
				//PDF was successfully saved or downloaded
				//echo 'PDF saved';
			}
		}
		public function update_identitas()
		{							
						$this->load->model('b_model');
						$this->load->helper('security');
						
						$username =  $this->session->userdata('username');				
						$user_id =  $this->session->userdata('user_id');				
						$date_now = date('Y-m-d');
														
						$rowid = $this->input->post('rowid');
						$name = $this->input->post('name');
						
						$user_by 	  = ($rowid == '' ? 'created_by' : 'updated_by');
						$user_date = ($rowid == '' ? 'created_date' : 'updated_date');
						
						$data = array(						
								'name' => $name,
								$user_by => $user_id,
								$user_date => $date_now
						);
						
						if ($rowid == ''){
							$id = $this->b_model->insert_data('mst_identitas', $data);
						}
						else{
							$where = array('rowid' =>  $rowid);
							$this->b_model->update_all('mst_identitas', $where,$data);
						}
						
						$log = array();	
						array_push($log, $data);
							
						$json   = array( 'success' => TRUE,
													'log' => $log,
						);
						
						echo json_encode($json);
		}
		public function update_pangkat()
		{
									
						$this->load->model('b_model');
						$this->load->helper('security');
						
						$username =  $this->session->userdata('username');				
						$user_id =  $this->session->userdata('user_id');				
						$date_now = date('Y-m-d');
														
						$rowid = $this->input->post('rowid');
						$name = $this->input->post('name');
						
						$user_by 	  = ($rowid == '' ? 'create_by' : 'update_by');
						$user_date = ($rowid == '' ? 'create_date' : 'update_date');
						
						$data = array(						
								'name' => $name,
								$user_by => $user_id,
								$user_date => $date_now
						);
						
						if ($rowid == ''){
							$id = $this->b_model->insert_data('hrd_pangkat', $data);
						}
						else{
							$where = array('rowid' =>  $rowid);
							$this->b_model->update_all('hrd_pangkat', $where,$data);
						}
						
						$log = array();	
						array_push($log, $data);
							
						$json   = array( 'success' => TRUE,
													'log' => $log,
						);
						
						echo json_encode($json);
		}
		public function act_klasifikasi()
		{
									
						$this->load->model('b_model');
						$this->load->helper('security');
						
						$username =  $this->session->userdata('username');				
						$user_id =  $this->session->userdata('user_id');				
						$date_now = date('Y-m-d');
														
						$rowid = $this->input->post('rowid');
						$parent = $this->input->post('parent');
						$name = $this->input->post('name');
						$code1 = $this->input->post('code1',true);
						$code2 = $this->input->post('code2',true);
						$codenya = $code1.'.'.$code2;
						
						$id_perusahaan = $this->input->post('id_perusahaan');
						
						$code 	  = ($code1 == '' ? $code2 : $codenya);
						
						$user_by 	  = ($rowid == '' ? 'create_by' : 'update_by');
						$user_date = ($rowid == '' ? 'create_date' : 'update_date');
						
						$data = array(						
								'name' => $name,
								'parent' => $parent,
								'id_perusahaan' => $id_perusahaan,
								'code' => $code,
								$user_by => $username,
								$user_date => $date_now
						);
						
						if ($rowid == ''){
							$id = $this->b_model->insert_data('klasifikasi', $data);
						}
						else{
							$where = array('rowid' =>  $rowid);
							$this->b_model->update_all('klasifikasi', $where,$data);
						}
						
						$log = array();	
						array_push($log, $data);
							
						$json   = array( 'success' => TRUE,
													'log' => $log,
						);
						
						echo json_encode($json);
						
		}		
		public function update_status()
		{
									
						$this->load->model('b_model');
						$this->load->helper('security');
						
						$username =  $this->session->userdata('username');				
						$user_id =  $this->session->userdata('user_id');				
						$date_now = date('Y-m-d');
														
						$rowid = $this->input->post('rowid');
						$name = $this->input->post('name');
						$status = $this->input->post('status');
						
						$user_by 	  = ($rowid == '' ? 'create_by' : 'update_by');
						$user_date = ($rowid == '' ? 'create_date' : 'update_date');
						
						$data = array(						
								'name' => $name,
								'status' => $status,
								'create_by' => $user_id,
								'create_date' => $date_now
						);
						
						if ($rowid == ''){
							$id = $this->b_model->insert_data('mst_karyawan_status', $data);
						}
						else{
							$where = array('rowid' =>  $rowid);
							$this->b_model->update_all('mst_karyawan_status', $where,$data);
						}
						
						$log = array();	
						array_push($log, $data);
							
						$json   = array( 'success' => TRUE,
													'log' => $log,
						);
						
						echo json_encode($json);
						
		}		
		public function form_action()
		{									
			$this->load->model('b_model');
			$this->load->helper('security');
			
			$username =  $this->session->userdata('username');				
			$user_id =  $this->session->userdata('user_id');				
			$date_now = date('Y-m-d');
											
			$rowid = $this->input->post('rowid',NULL);
			$column = $this->input->post('column',NULL);
			$description = $this->input->post('description',NULL);
			$table = $this->input->post('table',NULL);
			
			$rowid = $this->input->post('rowid',NULL);
			$status = $this->input->post($column,NULL);
			
			$user_by 	  = ($rowid == '' ? 'create_by' : 'update_by');
			$user_date = ($rowid == '' ? 'create_date' : 'update_date');
			
			$data_log = array(						
					'refftransaction' => $rowid,
					'reffstatus' => $status,
					'description' => $description,
					$user_by => $user_id,
					$user_date => $date_now
			);
			
			$this->b_model->insert_data('tb_log', $data_log);
			
			$data = array(						
					$column => $status,
					$user_by => $user_id,
					$user_date => $date_now
			);
			
			if ($rowid == null){
				$id = $this->b_model->insert_data($table, $data);
			}
			else{
				$where = array('rowid' => $rowid);
				$this->b_model->update_all($table, $where,$data);
			}
			
			$filterus[0]['field'] = "rowid";
			$filterus[0]['data'] = array(
									   "type"		=> "string",
									   "comparison"	=> "eq",
									   "value"		=> $rowid);							
			$datauser = $this->b_model->get_all_data('v_userbast', $filterus ,1, '', '');					
			$emailtemplate = $this->email_temp('MD338','MD296',$rowid,'MD319',$description);
			
			$dataelog = array (
								'from' => 'fauzzi95@gmail.com',
								'refftransaction' => $rowid,
								'created_by' =>$username,
								'created_on' => $date_now,
								'to' => $datauser[0]->email,
								'text_email' => $emailtemplate['template'],
								'subject' => $emailtemplate['subject']
			);
			$this->b_model->insert_data('email_log', $dataelog);
			
			//var_dump($filename);
			/*if ($action == 'kirim'){
				$this->email_send($rowid);
			} */

			$json   = array( 'success' => TRUE);						
			echo json_encode($json);						
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
		public function form_cancel()
		{
			$this->load->model('b_model');
			$this->load->helper('security');
						
			$username =  $this->session->userdata('username');				
			$user_id =  $this->session->userdata('user_id');				
			$date_now = date('Y-m-d');
			$rowid = $this->input->post('rowid');
						
			$data = array(						
					'reffstatus' => 'MD411',
					'update_by' => $username,
					'update_date' => $date_now
			);
			
			$wheresk = array('rowid' =>  $rowid);
			$this->b_model->update_all('tbl_suratkeluar', $wheresk,$data);
			
			$filteras4[0]['field'] = "reffsuratkeluar";
			$filteras4[0]['data'] = array(
									   "type"		=> "string",
									   "comparison"	=> "eq",
									   "value"		=> $rowid);
									   
			$dataz  = $this->b_model->get_all_datafunc('v_suratmasuk' ,$filteras4, 100, '', '');
			
			$wheresm = array('reffsurat' =>  $dataz[0]->rowid);
			$this->b_model->update_all('tbl_tasksuratmasuk', $wheresm,$data);

			$json   = array('success' => true);						
			echo json_encode($json);
		}
		public function form_ttdupload()
		{
					$this->load->model('b_model');
					$this->load->helper('security');
					$username =  $this->session->userdata('username');				
					$user_id =  $this->session->userdata('user_id');				
					
					//$rowid = $this->input->post('rowid');
					$url_ttd = $this->input->post('url_ttd');
					$id = $this->input->post('user_id');
					
					$filename = $_FILES['url_ttd']['name'];
					
					$ext = date('YmdHisu');
					$direktori = 'signature/';
					$config['upload_path'] = $direktori;
					$config['file_name'] = $ext."_".str_replace(' ','_',$filename);
					$config['allowed_types'] = 'png|jpg|gif';

					$this->load->library('upload', $config);				 
					
					if (!$this->upload->do_upload("url_ttd")) {
						$error = array('error' => $this->upload->display_errors());
						//json_encode($error);
					}
					else {
						$this->upload->data();
						$data = array(			
										"url_ttd" => str_replace(' ','_',$ext."_".$filename),
										"nama_ttd" => str_replace(' ','_',$filename)
						);
						
						$where = array('user_id' =>  $id);
						$this->b_model->update_all('rev_user', $where,$data);
						
						$json   = array( 'success' => TRUE,
												'data' => $data,
						);					
						echo json_encode($json);
					}
		}
		public function form_dupload()
		{
					$this->load->model('b_model'); 
					$this->load->helper('security');
					$username =  $this->session->userdata('username');				
					$user_id =  $this->session->userdata('user_id');				
					
					//$rowid = $this->input->post('rowid');
					$url_document = $this->input->post('url_document');
					$jenis_dokumen = $this->input->post('jenis_dokumen');
					$nomor = $this->input->post('nomor');
					$tanggal = $this->input->post('tanggal');
					$nama_jenis = $this->input->post('nama_jenis');
					$user_by 	  = ($rowid == '' ? 'create_by' : 'update_by');
					$user_date = ($rowid == '' ? 'create_date' : 'update_date');
					
					$filename = $_FILES['url_document']['name'];
					
					$ext = date('YmdHisu');
					$direktori = 'document/upload/';
					$config['upload_path'] = $direktori;
					$config['file_name'] = str_replace(' ','_',$ext."_".$filename);
					$config['allowed_types'] = 'gif|jpg|png|xls|xlsx|doc|docx|pdf';

					$this->load->library('upload', $config);				 
					
					if (!$this->upload->do_upload("url_document")) {
						$error = array('error' => $this->upload->display_errors());
						//json_encode($error);
					}
					else {
						$this->upload->data();
						$data = array(
                                        "name"	=> $filename,					
                                        "jenis_dokumen"	=> $jenis_dokumen,			
                                        "nomor"	=> $nomor,					
                                        "tanggal"	=> $tanggal,					
                                        "nama_jenis"	=> $nama_jenis,					
										"url_document" => str_replace(' ','_',$ext."_".$filename),
										$user_by => $username,
										$user_date => $date_now
						);
						//$this->b_model->insert_data('tbl_attdokumen', $data);
						$json   = array( 'success' => TRUE,
												'data' => $data,
						);					
						echo json_encode($json);
					}
		}
		public function form_uploadbast()
		{
					$this->load->model('b_model'); 
					$this->load->helper('security');
					$username =  $this->session->userdata('username');				
					$user_id =  $this->session->userdata('user_id');				
					$date_now = date('Y-m-d h:i:s');
					
					$rowid = $this->input->post('rowid');
					$url_document = $this->input->post('url_document');
					$user_by 	  = ($rowid == '' ? 'create_by' : 'update_by');
					$user_date = ($rowid == '' ? 'create_date' : 'update_date');
					$filename = $_FILES['url_document']['name'];
					$ext = date('YmdHisu');
					$direktori = 'document/upload/';
					$config['upload_path'] = $direktori;
					$config['file_name'] = str_replace(' ','_',$ext."_".$filename);
					$config['allowed_types'] = 'gif|jpg|png|xls|xlsx|doc|docx|pdf';

					$this->load->library('upload', $config);				 
					
					if (!$this->upload->do_upload("url_document")) {
						$error = array('error' => $this->upload->display_errors());
						//json_encode($error);
					}
					else {
						$this->upload->data();
						$data = array(
                        				"bast_url" => str_replace(' ','_',$ext."_".$filename),
										$user_by => $username,
										$user_date => $date_now
						);
						
						$where = array('rowid' =>  $rowid);
						$this->b_model->update_all('tb_bast', $where,$data);
						
						
						$filterus[0]['field'] = "rowid";
						$filterus[0]['data'] = array(
												   "type"		=> "string",
												   "comparison"	=> "eq",
												   "value"		=> $rowid);							
						$datauser = $this->b_model->get_all_data('v_fuserbast', $filterus ,1, '', '');					

						$emailtemplate = $this->email_temp('MD336','MD297',$rowid,'MD320','');
						
						$dataelog = array (
											'from' => 'fauzzi95@gmail.com',
											'refftransaction' => $rowid,
											'created_by' =>$username,
											'created_on' => $date_now,
											'to' => $datauser[0]->email,
											'text_email' => $emailtemplate['template'],
											'subject' => $emailtemplate['subject']
						);
						$this->b_model->insert_data('email_log', $dataelog);
						
						$json   = array( 'success' => TRUE,
												'data' => $data,
						);					
						echo json_encode($json);
					}
		}
		public function update_divisi()
		{									
						$this->load->model('b_model');
						$this->load->helper('security');
						
						$username =  $this->session->userdata('username');				
						$user_id =  $this->session->userdata('user_id');				
						$date_now = date('Y-m-d');
														
						$rowid = $this->input->post('rowid');
						$parent = $this->input->post('parent');
						$name = $this->input->post('name');
						$code = $this->input->post('code');
						$id_typedivisi = $this->input->post('id_typedivisi');
						$id_perusahaan = $this->input->post('id_perusahaan');
						$reffkepala = $this->input->post('reffkepala');
						$reffsekertaris = $this->input->post('reffsekertaris');
						$last_numbersk = $this->input->post('last_numbersk');
						$last_numberdispo = $this->input->post('last_numberdispo');
						$status_kepala = $this->input->post('status_kepala');
						
						$user_by 	  = ($rowid == '' ? 'create_by' : 'update_by');
						$user_date = ($rowid == '' ? 'create_date' : 'update_date');
						
						if ($rowid == ''){
							
							$nourut_seq =  'seq_'.strtolower(str_replace(' ','_',$name));
							$nourut_seq =  str_replace('_&_','_',$nourut_seq);
							
							$nourut_seqdispo =  'seq_'.strtolower(str_replace(' ','_',$name)).'_dispo';
							$nourut_seqdispo =  str_replace('_&_','_',$nourut_seqdispo);
							
							$data = array(						
									'name' => $name,
									'parent' => $parent,
									'id_typedivisi' => $id_typedivisi,
									'code' => $code,
									'id_perusahaan' => $id_perusahaan,
									'reffkepala' => $reffkepala,			
									'reffsekertaris' => $reffsekertaris,
									'nourut_seq' => $nourut_seq,
									'last_numbersk'=> '1',
									'nourut_seqdispo' => $nourut_seqdispo,
									'last_numberdispo' => '1',
									'status_kepala' => $status_kepala,
									$user_by => $user_id,
									$user_date => $date_now
							);
						
							$id = $this->b_model->insert_data('mst_divisi', $data);
												
						}
						else{
							
							$data = array(						
									'name' => $name,
									'parent' => $parent,
									'id_typedivisi' => $id_typedivisi,
									'code' => $code,
									'id_perusahaan' => $id_perusahaan,
									'reffkepala' => $reffkepala,			
									'reffsekertaris' => $reffsekertaris,
									'last_numbersk'=> $last_numbersk,
									'last_numberdispo' => $last_numberdispo,
									'status_kepala' => $status_kepala,
									$user_by => $user_id,
									$user_date => $date_now
							);
							
							$where = array('rowid' =>  $rowid);
							$this->b_model->update_all('mst_divisi', $where,$data);
						}
						
						$log = array();	
						array_push($log, $data);
							
						$json   = array( 'success' => TRUE,
													'log' => $log,
						);
						
						echo json_encode($json);
						
		}
		public function update_jabatan()
		{
									
						$this->load->model('b_model');
						$this->load->helper('security');
						
						$username =  $this->session->userdata('username');				
						$user_id =  $this->session->userdata('user_id');				
						$date_now = date('Y-m-d');
														
						$rowid = $this->input->post('rowid', TRUE);
						$parent = $this->input->post('parent', TRUE);
						$name = $this->input->post('name', TRUE);
						$divisi_id = $this->input->post('divisi_id', TRUE);
						$pangkat_id = $this->input->post('pangkat_id', TRUE);
						$id_perusahaan = $this->input->post('id_perusahaan', TRUE);
						$user_by 	  = ($rowid == '' ? 'create_by' : 'update_by');
						$user_date = ($rowid == '' ? 'create_date' : 'update_date');
						
						$data = array(						
								'name' => $name,
								'parent' => $parent,
								'divisi_id' => $divisi_id,
								'pangkat_id' => $pangkat_id,
								'id_perusahaan' => $id_perusahaan,								
								$user_by => $user_id,
								$user_date => $date_now
						);
						
						if ($rowid == ''){
							$log = $this->b_model->insert_data('mst_jabatan', $data);
						}
						else{
							$where = array('rowid' =>  $rowid);
							$log = $this->b_model->update_all('mst_jabatan', $where,$data);
							//echo "disini";
						}
						
						$log = array();	 
						array_push($log, $data);
							
						$json   = array( 'success' => TRUE);
						
						echo json_encode($json);
		}
		public function terima_tembusan()
		{
				$this->load->model('b_model');
				$this->load->helper('security');
				
				$username =  $this->session->userdata('username');				
				$user_id =  $this->session->userdata('user_id');				
				$date_now = date('Y-m-d');
				$rowid = $this->input->post('rowid', TRUE);
				
				$data = array(						
						'reffstatus' => 'MD395',								
						'update_by' => $user_id,
						'update_date' => $date_now
				);
				
				$where = array('rowid' =>  $rowid);
				$this->b_model->update_all('tbl_tasksuratmasuk', $where,$data);
					
				$json   = array( 'success' => TRUE);
				echo json_encode($json);
		}
		public function email_temp($preffevent,$prefftipesurat,$prefftransaction,$preffstatus,$commet)
		{
					//echo $prefftransaction;
					
    					
					$filter[0]['field'] = "reffevent";
					$filter[0]['data'] = array(
											   "type"		=> "string",
											   "comparison"	=> "eq",
											   "value"		=> $preffevent);
					$filter[1]['field'] = "refftipesurat";
					$filter[1]['data'] = array(
											   "type"		=> "string",
											   "comparison"	=> "eq",
											   "value"		=> $prefftipesurat);
											   
					$filter[2]['field'] = "reffstatus";
					$filter[2]['data'] = array(
											   "type"		=> "string",
											   "comparison"	=> "eq",
											   "value"		=> $preffstatus); 
											   
					$dataemail = $this->b_model->get_all_data("v_emailtemplate", $filter ,1, '', '');
					
					$komentar = $commet;
					
					$template = $dataemail[0]->template.$komentar;
					$subject = $dataemail[0]->subject;
					
					$dbemail = $this->b_model->get_all_data("tbl_dbemail", array() ,100, '', '');
					
					
												   
					foreach ($dbemail as $vidbemail)
					{						
						
						
						$vdesc = str_replace('{','',str_replace('}','',$vidbemail->description));
						$vtable  = "fn_dbemailvalue('".$vdesc."')";
						$dataas = $this->b_model->get_all_datafunc($vtable ,array(), 1, '', '');			
						$values = $dataas[0]->column_namee;
						
						
						
						$filteras[0]['field'] = $dataas[0]->keycolumn;
						$filteras[0]['data'] = array(
												   "type"		=> "string",
												   "comparison"	=> "eq",
												   "value" => $prefftransaction);
                    
					
						$dataview = $this->b_model->get_all_data($vidbemail->vtable,$filteras ,1, '', '');
						
						$template = str_replace('}','',str_replace('{','',str_replace($vidbemail->description,$dataview[0]->$values,$template)));
						
						//var_dump($filteras);
						//$pk = $dataview[0]->$values;
						
					}
					/* echo '<pre>';
							var_dump($template);
						echo '</pre>'; */
					//print_r($prefftransaction);
					
					$emailtemplate =  array(
						'template' => $template,
						'subject' => $subject
					);
					
					return  $emailtemplate;
		}	
		public function email_config($data)
		{
		
			$this->load->library('PHPMailerAutoload');
			$mail = new PHPMailer();
			//$mail->SMTPDebug = 2;
			
			$mail->isSMTP();
			//$mail->Debugoutput = 'html';
			//var_dump();
			// set smtp
			//$mail->SMTPDebug = 2;
			//Set the hostname of the mail server
			$mail->Host = 'mail.pgascom.co.id';
			$mail->Debugoutput = 'html';
			$mail->Host = 'mail.pgascom.co.id';
			$mail->SMTPSecure = 'ssl';
			$mail->SMTPAuth = true;
			$mail->Username = 'no_reply@pgnlng.co.id';
			$mail->Password = 'April2017';
			$mail->Port = 465;
			$mail->addAddress($data['to'], 'BAST- PEGASCOM');
			$mail->Subject = $data['subject'];
			$mail->Body 	= $data['text_email']; 
			
			if (!$mail->send()) {
				return "Mailer Error: " . $mail->ErrorInfo;
			}
			else {
				return "Message sent!";
			}
		
		}
		public function email_send($refftransaction)
		{
			
			$filteremd[0]['field'] = "email_status";
			$filteremd[0]['data'] = array(
									   "type"		=> "string",
									   "comparison"	=> "eq",
									   "value"		=> '0');
			$filteremd[1]['field'] = "refftransaction";
			$filteremd[1]['data'] = array(
									   "type"		=> "string",
									   "comparison"	=> "eq",
									   "value"		=> $refftransaction); 
				
			$emdata = $this->b_model->get_all_data('email_log', $filteremd, 50, '', '');
			
			foreach($emdata as $emdat){
				
				$datasemail =  array(
					'from' => $emdat->from,
					'to'  => $emdat->to,
					'text_email' => $emdat->text_email,
					'attachment_file1' => $emdat->attachment_file1,
					'attachment_file2' => $emdat->attachment_file2,
					'subject' => $emdat->subject
				);
				$logstatus = $this->email_config($datasemail);
				
				$dataSem = array(
					'email_status' =>'1',
					'logstatus' =>$logstatus		
				);
				
				$whersem = array('rowid' =>  $emdat->rowid);
				$this->b_model->update_all('email_log', $whersem,$dataSem);
			}
			
			/* $json   = array( 'success' => TRUE);
			echo json_encode($json); */
		}
}

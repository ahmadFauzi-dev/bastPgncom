<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Mapping extends MY_Controller {
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
		
		
	}
	public function insertmapping()
	{
		$data = $this->input->post('data');
		
		$data_input = json_decode($data,true);
		$data2 = (array) $data_input;
		
		//var_dump($data2);
		$this->b_model->insert_batch('mapmultisource',$data2);
	}
	public function getismulti()
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
			$filter[0]['field'] = "typeof";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> 4);
			//$filter = array();						   
			
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		
		
		$dataas = $this->b_model->get_all_data('idx_configuration', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('idx_configuration', $filter);
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
	public function testsoapserver()
	{
		$this->load->library("nusoap"); //load the library here
        $server  = new soap_server();
        $server->configureWSDL("MySoapServer", "urn:MySoapServer");
        
		$server->register(
                "echoTest", array("tmp" => "xsd:string")
				, array("return" => "xsd:string"), "urn:MySoapServer", "urn:MySoapServer#echoTest", "rpc", "encoded", "Echo test"
        );
		$server->register('jumlahkan');
		$server->register('echoTest');
        /**
         * To test whether SOAP server/client is working properly
         * Just echos the input parameter
         * @param string $tmp anything as input parameter
         * @return string returns the input parameter
         */
		function jumlahkan($x, $y) {
			return $x + $y;
		}
		
        function echoTest($tmp) {
            if (!$tmp) {
                return new soap_fault('-1', 'Server', 'Parameters missing for echoTest().', 'Please refer documentation.');
            } else {
                return "from MySoapServer() : $tmp";
            }
        }
		$server->service(file_get_contents("php://input")); 
		//$this->nusoap->service
	}
	public function getghvpelanggan()
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
		
		
		$dataas = $this->b_model->get_all_data('tmappingpelanggansource', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('tmappingpelanggansource', $filter);
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
	public function getpenyaluranindustri()
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
			
			$filter = array();						   
			
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		
		
		$dataas = $this->b_model->get_all_data('penyaluranindustri', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('penyaluranindustri', $filter);
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
	public function getpenyaluranstation()
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
			
			$filter = array();						   
			
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		
		
		$dataas = $this->b_model->get_all_data('v_penyaluranstationdaily', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('v_penyaluranstationdaily', $filter);
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
	public function testsoapclient()
	{
		$this->load->library("nusoap");
        // instansiasi obyek untuk class nusoap client
		$client = new nusoap_client('http://192.168.104.50:9784/services/apps_get_budget?wsdl');
		$bil1 = '1346';
		//$bil2 = 12;
		
		$result = $client->call('_getget_budget', array('p_ccid' => $bil1));
		//echo "<p>Hasil penjumlahan ".$bil1." dan ".$bil2." adalah ".$result."</p>";
		echo $client->request;
		echo $client->response;
		// menampilkan format XML hasil response
		echo "<pre>";
			var_dump($result);
			//echo $client->response;
		echo "</pre>";
	}
	public function mappingpelanggansource()
	{
		//echo "OK";
		$start = $this->input->post('startt');
		$end = $this->input->post('endd');
		//$end = '2012-01-01';
		$data = $this->input->post('data');
		$datainput = json_decode($data);
		
		$startTime = strtotime($start);
		$endTime = strtotime($end);
		
		// Loop between timestamps, 24 hours at a time
		
		for ( $i = $startTime; $i <= $endTime; $i = $i + 86400 ) {
		  $thisDate = date( 'Y-m-d 00:00:00', $i ); // 2010-05-01, 2010-05-02, etc
		  //echo $thisDate."<br/>";
		  foreach($datainput as $row)
		  {
			$filteras[0]['field'] = "idrefpelanggan";
			$filteras[0]['data']  = array("comparison"		=> "eq",
										"type"				=> "string",
										"value"				=> $row->idrefpelanggan);
			$filteras[1]['field'] = "tanggal";
			$filteras[1]['data']  = array("comparison"		=> "eq",
										"type"				=> "numeric",
										"value"				=> dateTonum($thisDate));
			
			//die();							
			$count		 = $this->b_model->count_all_data('mapmultisource', $filteras);
			
			if($count > 0)
			{
				$data_up = array("updperson" => $this->session->userdata('username'),
								 "upddate" => dateTonum(date('Y-m-d h:i:s')),
								 "mstationrowid"		=> $this->input->post('stationname'),
								 "stationid"		=> $this->input->post('station_id'),
								 "ismultisource"		=> $this->input->post('ismulti'),
								 "delflag"			=> 1
				);
				
				$this->b_model->update_data('mapmultisource', $filteras, $data_up);
			}else
			{
				$data_input = array("idrefpelanggan"	=> $row->idrefpelanggan,
									"tanggal"			=> dateTonum($thisDate),
									"mstationrowid"		=> $this->input->post('stationname'),
									"ismultisource"		=> $this->input->post('ismulti'),
									"stationid"		=> $this->input->post('station_id'),
									"creperson"			=> $this->session->userdata('username'),
									"credate"			=> dateTonum(date('Y-m-d h:i:s')),
									"delflag"			=> 1
				);
				//($table, $data)
				
				//$this->b_model->insert_data('mapmultisource', $data_input);
				
			}
			
		  }
		  
		}
	}
	public function cekpermission()
	{
		$rd = $this->session->userdata('rd');
		//echo "OK";
		var_dump($rd);
	}
	public function cekexcell()
	{
		//$objPHPExcel = $this->excel;

		// Set document properties
		$this->lphpexcel->getProperties()->setCreator("Maarten Balliauw")
									 ->setLastModifiedBy("Maarten Balliauw")
									 ->setTitle("Office 2007 XLSX Test Document")
									 ->setSubject("Office 2007 XLSX Test Document")
									 ->setDescription("Test document for Office 2007 XLSX, generated using PHP classes.")
									 ->setKeywords("office 2007 openxml php")
									 ->setCategory("Test result file");


		// Add some data
		$this->lphpexcel->setActiveSheetIndex(0)
					->setCellValue('A1', 'Hello')
					->setCellValue('B2', 'world!')
					->setCellValue('C1', 'Hello')
					->setCellValue('D2', 'world!');

		// Miscellaneous glyphs, UTF-8
		$this->lphpexcel->setActiveSheetIndex(0)
					->setCellValue('A4', 'Miscellaneous glyphs')
					->setCellValue('A5', 'asdasd');

		// Rename worksheet
		$this->lphpexcel->getActiveSheet()->setTitle('Simple');


		// Set active sheet index to the first sheet, so Excel opens this as the first sheet
		$this->lphpexcel->setActiveSheetIndex(0);


		// Redirect output to a client’s web browser (Excel5)
		header('Content-Type: application/vnd.ms-excel');
		header('Content-Disposition: attachment;filename="02simple.xls"');
		header('Cache-Control: max-age=0');
		// If you're serving to IE 9, then the following may be needed
		header('Cache-Control: max-age=1');

		// If you're serving to IE over SSL, then the following may be needed
		header ('Expires: Mon, 26 Jul 1997 05:00:00 GMT'); // Date in the past
		header ('Last-Modified: '.gmdate('D, d M Y H:i:s').' GMT'); // always modified
		header ('Cache-Control: cache, must-revalidate'); // HTTP/1.1
		header ('Pragma: public'); // HTTP/1.0

		$objWriter = PHPExcel_IOFactory::createWriter($this->lphpexcel, 'Excel5');
		$objWriter->save('php://output');
	}
	public function gentemplate()
	{
		$path = substr(BASEPATH,0,-7).'template/';
		$objReader = PHPExcel_IOFactory::createReader('Excel5');
		$objPHPExcel = $objReader->load($path."30template.xls");




		echo date('H:i:s') , " Add new data to the template" , EOL;
		$data = array(array('title'		=> 'Excel for dummies',
							'price'		=> 17.99,
							'quantity'	=> 2
						   ),
					  array('title'		=> 'PHP for dummies',
							'price'		=> 15.99,
							'quantity'	=> 1
						   ),
					  array('title'		=> 'Inside OOP',
							'price'		=> 12.95,
							'quantity'	=> 1
						   )
					 );

		$this->lphpexcel->getActiveSheet()->setCellValue('D1', PHPExcel_Shared_Date::PHPToExcel(time()));

		$baseRow = 5;
		foreach($data as $r => $dataRow) {
			$row = $baseRow + $r;
			$objPHPExcel->getActiveSheet()->insertNewRowBefore($row,1);

			$objPHPExcel->getActiveSheet()->setCellValue('A'.$row, $r+1)
										  ->setCellValue('B'.$row, $dataRow['title'])
										  ->setCellValue('C'.$row, $dataRow['price'])
										  ->setCellValue('D'.$row, $dataRow['quantity'])
										  ->setCellValue('E'.$row, '=C'.$row.'*D'.$row);
		}
		$objPHPExcel->getActiveSheet()->removeRow($baseRow-1,1);


		//echo date('H:i:s') , " Write to Excel5 format" , EOL;
		
		$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
		$objWriter->save("file.xls");
		//echo date('H:i:s') , " File written to " , str_replace('.php', '.xls', pathinfo(__FILE__, PATHINFO_BASENAME)) , EOL;


		// Echo memory peak usage
		//echo date('H:i:s') , " Peak memory usage: " , (memory_get_peak_usage(true) / 1024 / 1024) , " MB" , EOL;

		// Echo done
		//echo date('H:i:s') , " Done writing file" , EOL;
		echo 'File has been created in ' , getcwd() , EOL;
		/*
			require_once 'PHPExcel/IOFactory.php';
			$objPHPExcel = PHPExcel_IOFactory::load("MyExcel.xlsx");
			foreach ($objPHPExcel->getWorksheetIterator() as $worksheet) {
			$worksheetTitle     = $worksheet->getTitle();
			$highestRow         = $worksheet->getHighestRow(); // e.g. 10
			$highestColumn      = $worksheet->getHighestColumn(); // e.g 'F'
			$highestColumnIndex = PHPExcel_Cell::columnIndexFromString($highestColumn);
			$nrColumns = ord($highestColumn) - 64;
			echo "<br>The worksheet ".$worksheetTitle." has ";
			echo $nrColumns . ' columns (A-' . $highestColumn . ') ';
			echo ' and ' . $highestRow . ' row.';
			echo '<br>Data: <table border="1"><tr>';
			for ($row = 1; $row <= $highestRow; ++ $row) {
				echo '<tr>';
				for ($col = 0; $col < $highestColumnIndex; ++ $col) {
					$cell = $worksheet->getCellByColumnAndRow($col, $row);
					$val = $cell->getValue();
					$dataType = PHPExcel_Cell_DataType::dataTypeForValue($val);
					echo '<td>' . $val . '<br>(Typ ' . $dataType . ')</td>';
				}
				echo '</tr>';
			}
			echo '</table>';
		}
		*/
	}
	public function exportrevghv()
	{
		//echo "OK";
		
		$this->load->model('b_model');
		
		$limit = 'All';
	    $offset = 0;
	    //$filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    
		$sorts = json_decode($this->input->get('sort', TRUE));
		
		$view = $this->input->get('view');
		$filter = json_decode($this->input->get('search'),true);
	    
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'sort desc';
	    }
		
		$dataas = $this->b_model->get_all_data($view, $filter , $limit, $offset, '');
		$count  = $this->b_model->count_all_data($view, $filter);
		$n=0;
		
		
		$path = substr(BASEPATH,0,-7).'template/';
		$objReader = PHPExcel_IOFactory::createReader('Excel2007');
		$objPHPExcel = $objReader->load($path."ghvref.xlsx");

		$objPHPExcel->getActiveSheet()->setCellValue('A1', 'Data Pelanggan');

		//$this->lphpexcel->getActiveSheet()->setCellValue('D1', PHPExcel_Shared_Date::PHPToExcel(time()));

		$baseRow = 6;
		foreach ($dataas as $datarow) {
			$row = $baseRow + $n;
			//$objPHPExcel->getActiveSheet()->insertNewRowBefore($row,1);
			
			$objPHPExcel->getActiveSheet()->setCellValue('A'.$row, "'".$datarow->idrefpelanggan)
										  ->setCellValue('B'.$row, $datarow->pelname);	
			//$data[] = $row;
			$n++;
		}
		$objPHPExcel->getActiveSheet()->setCellValue('D1', "Didownload Oleh : ".$this->session->userdata('username')." Tanggal ".date('Y-m-d H:i:s')."");
		//$objPHPExcel->getActiveSheet()->removeRow($baseRow-1,1);
		// Redirect output to a client’s web browser (Excel2007)
		
		header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
		header('Content-Disposition: attachment;filename="'.date('Y-m-d H:i:s').'.xlsx"');
		header('Cache-Control: max-age=0');
		// If you're serving to IE 9, then the following may be needed
		header('Cache-Control: max-age=1');

		// If you're serving to IE over SSL, then the following may be needed
		header ('Expires: Mon, 26 Jul 1997 05:00:00 GMT'); // Date in the past
		header ('Last-Modified: '.gmdate('D, d M Y H:i:s').' GMT'); // always modified
		header ('Cache-Control: cache, must-revalidate'); // HTTP/1.1
		header ('Pragma: public'); // HTTP/1.0
		$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
		$objWriter->save('php://output');
		
		//End
	}
	
	public function importmapelsource()
	{
		$start = $this->input->post('startt');
		$end = $this->input->post('endd');
		$createdby = $this->session->userdata('username');
		$file_n     				 = $_FILES['dok']['name'];	
		$direktori 			  		 = 'document/import/';
		$path = substr(BASEPATH,0,-7).'document/import/';
		$config['upload_path'] 		 = $direktori;
		$config['allowed_types'] 	 = 'xls|xlsx';
		$this->load->library('upload', $config);
		
		$out = array();
		if (!$this->upload->do_upload("dok")) {
			$error = array('error' => $this->upload->display_errors());
			json_encode($error);
		}else {
			$data	= $this->upload->data();
			$nama_file	= $data['file_name'];
			$inputFileName = $path.''.$nama_file.'';
		}
		
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
			$data = array();	
				$data = array(
				"idrefpelanggan"	=> substr($rowData[0][0], 1) ,
									// "namapelanggan"		=> $rowData[0][1],
									// "stationghv"		=> $rowData[0][2],
									// "ghvid"				=> $rowData[0][3],
				"mstationrowid"		=> $mstationrowid,
				"stationid"			=> $stationid,
				"tanggalawal" => dateTonumlengkap($start),
				"tanggalakhir" => dateTonumlengkap($end),
				"creperson" => $createdby,
				"credate" => dateTonumlengkap(date('Y-m-d h:i:s'))
				);
				$this->b_model->insert_data('staging_mapping_ghv', $data);	
			}		
			 
			//$gdate[$n] =
			$n++;
			
		}
		// vd::dump($data);
		if ($n > 0){
			echo '{"success":"TRUE"}';
			$this->db->query("select stgmappghv('$start', '$end')");
		}
		//$sql = 
		//$out = shell_exec('C:\\xampp\\htdocs\\sipgem\\exec\\importmapelsource.bat '.$nama_file. ' '. $start. ' '. $end.' '.$createdby.'');
		// $out = shell_exec('C:\\roothtdocs\\SPGEM_167\\exec\\importmapelsource.bat '.$nama_file. ' '. $start. ' '. $end.' '.$createdby.'');		
	}
	
	public function importmapelsourcetestupload()
	{
		$start 	   = "2016-01-01";
		$end 	   = "2016-01-02";
		$nama_file = "Tangerang111.xlsx";
		echo '{"success":"'.$nama_file.'"}';
		$out = shell_exec('C:\\xampp\\htdocs\\sipgem\\exec\\importmapelsource.bat '.$nama_file. ' '. $start. ' '. $end.'');
		
		//exec('C:\\xampp\\htdocs\\sipgem\\exec\\importmapelsource.bat '.$nama_file. ' '. $start. ' '. $end.'' ,$out, $exitcode);	
		echo "<pre>";
			var_dump($out);
		echo "</pre>";
	}
	
	public function uploaddok()
	{
		$this->load->helper('security');
		//$str = do_hash($str);
		//$file_n     				 = do_hash($_FILES['dok']['name']);	
		$direktori 			  		 = 'document/upload/';
		$config['upload_path'] 		 = $direktori;
		$config['file_name']		 = do_hash($_FILES['dok']['name']);
		$config['allowed_types'] 	 = 'gif|jpg|png|xls|xlsx|doc|docx|pdf';
		$this->load->library('upload', $config);
		
		
		if (!$this->upload->do_upload("dok")) {
			$error = array('error' => $this->upload->display_errors());
			json_encode($error);
		}else {
			$data		= $this->upload->data();
			$datagrid 	= json_decode($this->input->post('datagrid'));
			foreach($datagrid as $row)
			{
				$data_input = array("reffidpengukuran"	=> $row->rowid,
									"jenispengukuran"	=> 1,
									"docname"			=> $_FILES['dok']['name'],
									"docaliasname"		=> $config['file_name']."".$data['file_ext'],
									"docpath"			=> $direktori."".$config['file_name']."".$data['file_ext'],
									"creperson"			=> $this->session->userdata('username'),
									"credate"			=> dateTonum(date('Y-m-d h:i:s'))
									);
									
				$this->b_model->insert_data('doc_refference', $data_input);
				
			}
			//$data_input = array("reffidpengukuran"	=> )
			//$nama_file	= $data['file_name'];
			//echo '{"success":"'.$nama_file.'"}';
		}
	}
	
	function numtoalpha($number)
	{
		//case $number
		switch ($number)
		{
			case 1:
				return "A";
			break;
			case 2: 
				return "B";
			break;
			case 3:
				return "C";
			break;
			case 4:
				return "D";
			break;
			case 5:
				return "E";
			break;
			case 6:
				return "F";
			break;
			case 7:
				return "G";
			break;
			case 8:
				return "H";
			break;
			case 9:
				return "I";
			break;
			case 10:
				return "J";
			break;
			case 11:
				return "K";
			break;
			case 12:
				return "L";
			break;
			case 13:
				return "M";
			break;
			case 14:
				return "N";
			break;
			case 15:
				return "O";
			break;
			case 16:
				return "P";
			break;
			case 17:
				return "Q";
			break;
			case 18:
				return "R";
			break;
			case 19:
				return "S";
			break;
			case 20:
				return "T";
			break;
			case 21:
				return "U";
			break;
			case 22:
				return "V";
			break;
			case 23:
				return "W";
			break;
			case 24:
				return "C";
			break;
			case 25:
				return "Y";
			break;
			case 26:
				return "Z";
			break;
		}
	}
	public function exportdatadyn()
	{
		

		$limit 			= 'All';
	    $offset 		= 0;
	    $filter 		= $this->input->post('filter', TRUE);
		$jumlahfilter 	= count($filter);
	    $view 			= $this->input->get('view');
		
		//$view = $this->input->get('view');
		//$filter = json_decode($this->input->get('search'),true);
	    
		//var_dump($node);
		
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = 'sort desc';
	    } 
		
		$view = $this->input->get('view');
		$filter = json_decode($this->input->get('search'),true);
		
		
		$dataas = $this->b_model->get_all_data($view, $filter , $limit, $offset, '');
		
		$count  = $this->b_model->count_all_data($view, $filter);
		$n=0;
		$data = json_decode($this->input->get('datainput'));
		$items = array();
		//var_dump($data);
		
		
		//die();
		//die();
		foreach($dataas as $row)
		{
			foreach($row as $key=>$value) {
				//var_dump($key, $value);
				foreach($data as $rkey)
				{
						if($rkey->dataIndex == $key)
						{
							$items[$n][$rkey->pos] = $value;
							$items[$n][0]	= $n+1;
						}
				}
			}
			$n++;
		}
		
		
		// Miscellaneous glyphs, UTF-8
	
		
		
		$current_col = 0;
		$current_row = 1;
		//$this->lphpexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($current_col, $current_row,"OKOKOK");
		// Rename worksheet
		$n=0;
		foreach($data as $row)
		{
			$this->lphpexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($current_col, 2,strip_tags($row->text));
			$current_col++;
			$n++;
		}
		
		$rowd = 3;
		$lim = $this->numtoalpha($n);
		//$n = 82;
		$n = $n+1;
		If($n < 26)
		{
			$lim = $this->numtoalpha($n);
		}else
		{
			$ht1 = floor(($n/26));
			$ht2 = $n % 26;
			$lim1 = $this->numtoalpha($ht1);
			$lim2 = $this->numtoalpha($ht2);
			$lim  = $lim1.$lim2;
		}
		//$autosi
		
		for ($a = 1; $a < $n;$a++)
		{
			If($a < 26)
			{
				$lim = $this->numtoalpha($a);
			}else
			{
				$ht1 = floor(($a/26));
				$ht2 = $a % 26;
				$lim1 = $this->numtoalpha($ht1);
				$lim2 = $this->numtoalpha($ht2);
				$lim  = $lim1.$lim2;
			}
			//var_dump($lim);
			$this->lphpexcel->getActiveSheet()->getColumnDimension($lim)->setAutoSize(true);
			//echo '$this->lphpexcel->getActiveSheet()->getColumnDimension('.$lim.')->setAutoSize(true)';
		}
		//$conditionalStyles = $this->lphpexcel->getActiveSheet()->getStyle('C2')->getConditionalStyles();
		//die();
		//die();
		//foreach($)
		//$this->lphpexcel->getActiveSheet()->getColumnDimension('B')->setAutoSize(true);
		//$this->lphpexcel->getActiveSheet()->getColumnDimension('C')->setAutoSize(true);
		$this->lphpexcel->getActiveSheet()->getRowDimension('1')->setRowHeight(40);
		$this->lphpexcel->getActiveSheet()->getColumnDimension('A:'.$lim.'')->setAutoSize(true);
		$this->lphpexcel->getActiveSheet()->mergeCells('A1:'.$lim.'1');
		
		//$this->lphpexcel->getActiveSheet()->mergeCells('A18:E22');
		$this->lphpexcel->getActiveSheet()->getStyle('A1:'.$lim.'1')->getFont()->setName('Candara');
		$this->lphpexcel->getActiveSheet()->getStyle('A1:'.$lim.'1')->getFont()->setSize(20);
		$this->lphpexcel->getActiveSheet()->getStyle('A1:'.$lim.'1')->getFont()->setBold(true);
		$this->lphpexcel->getActiveSheet()->getStyle('A1:'.$lim.'1')->getFont()->setUnderline(PHPExcel_Style_Font::UNDERLINE_SINGLE);
		
		$this->lphpexcel->getActiveSheet()->getStyle('A1:'.$lim.'1')->getFont()->setName('Arial')
                                          ->setSize(11);
										  
		
		
		//$this->lphpexcel->getActiveSheet()->setCellValue('A1', 'Anomali Bulk');
		
		
		$this->lphpexcel->getActiveSheet()->getStyle('A2:'.$lim.'2')->applyFromArray(
			array(
				'font'    => array(
					'bold'      => true,
					'color'		=> array (
						'rgb' => '#0000FF'
					)
				),
				'alignment' => array(
					'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
					'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
				),
				'borders' => array(
					'outline'     => array(
						'style' => PHPExcel_Style_Border::BORDER_THIN
					)
				),
				'fill' 	=> array(
								'type'		=> PHPExcel_Style_Fill::FILL_SOLID,
								'color'		=> array('argb' => '0085ff')
				)
			)
		);
		//$conditional = new PHPExcel_Style_Conditional();
		//$conditional->setConditionType(PHPExcel_Style_Conditional::CONDITION_CELLIS)
			//->setOperatorType(PHPExcel_Style_Conditional::OPERATOR_EQUAL)
			//->addCondition('PLN');
		//$conditional->getStyle()->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getEndColor()->setARGB(PHPExcel_Style_Color::COLOR_DARKRED);
		//array_push($conditionalStyles, $conditional);
		/*
		$objConditional3 = new PHPExcel_Style_Conditional();
		$objConditional3->setConditionType(PHPExcel_Style_Conditional::CONDITION_CELLIS)
                ->setOperatorType(PHPExcel_Style_Conditional::OPERATOR_EQUAL)
                ->addCondition('-');
		$objConditional3->getStyle()->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_RED);
		$objConditional3->getStyle()->getFont()->setItalic(true);
		array_push($conditionalStyles, $objConditional3);
		*/
		
		//$objConditional3->getStyle()->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_CURRENCY_EUR_SIMPLE);
		/*
		$this->lphpexcel->getActiveSheet()->getStyle('A2:'.$lim.'2')->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
		$this->lphpexcel->getActiveSheet()->getStyle('A2:'.$lim.'2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		//$this->lphpexcel->getActiveSheet()->getStyle('A2:'.$lim.'2') -> getAlignment() -> setWrapText(true);
		$this->lphpexcel->getActiveSheet()->getStyle('A2:'.$lim.'2')->getFont()->setBold(true);
		//$this->lphpexcel->getActiveSheet()->getRowDimension(8)->setRowHeight(-1);
		$this->lphpexcel->getActiveSheet()->getStyle('A2:'.$lim.'2')->getFont()->setName('Arial')
                                          ->setSize(10);
		$this->lphpexcel->getActiveSheet()->getStyle('A2:'.$lim.'2')->getFont()->setColor( new PHPExcel_Style_Color( PHPExcel_Style_Color::COLOR_DARKGREEN ) );
		//$this->lphpexcel->getActiveSheet()->getStyle('A1:'.$lim.'1')->getFont()->setColor( new PHPExcel_Style_Color( PHPExcel_Style_Color::COLOR_DARKGREEN ) );
		
		*/
		$this->lphpexcel->setActiveSheetIndex(0)->setCellValue('A1', $this->input->get('title'));
		
		foreach($items as $rdetail)
		{
			foreach($rdetail as $key=>$value)
			{
				$this->lphpexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($key, $rowd,strip_tags($value));
			}
			$rowd++;	
		}
		$objConditionalStyle = new PHPExcel_Style_Conditional();
		$objConditionalStyle->setConditionType(PHPExcel_Style_Conditional::CONDITION_CELLIS)
			->setOperatorType(PHPExcel_Style_Conditional::OPERATOR_EQUAL)
			->addCondition('""');

		$objConditionalStyle->getStyle()->getFont()->getColor()->setRGB('FF0000');
		$objConditionalStyle->getStyle()->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getEndColor()->setARGB('ffa7a7');
		//$objConditionalStyle->getStyle()->getFont()->getColor()->setRGB('FF0000');
		
		$objConditionalStyle->getStyle()->getFont()->setBold(true);
		
		/*
		$objConditionalStyle2 = new PHPExcel_Style_Conditional();
		$objConditionalStyle2->setConditionType(PHPExcel_Style_Conditional::CONDITION_CELLIS)
			->setOperatorType(PHPExcel_Style_Conditional::OPERATOR_NOTEQUAL)
			->addCondition('""');

		$objConditionalStyle2->getStyle()->getFont()->getColor()->setRGB('FF0000');
		$objConditionalStyle2->getStyle()->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getEndColor()->setARGB('98FB98');
		//$objConditionalStyle->getStyle()->getFont()->getColor()->setRGB('FF0000');
		
		$objConditionalStyle2->getStyle()->getFont()->setBold(true);
		*/
		$conditionalStyles = $this->lphpexcel->getActiveSheet()->getStyle('A1:'.$lim.''.$rowd.'')
							->getConditionalStyles();
		array_push($conditionalStyles, $objConditionalStyle);
		//array_push($conditionalStyles, $objConditionalStyle2);
		$this->lphpexcel->getActiveSheet()->getStyle('A1:'.$lim.''.$rowd.'')
			->setConditionalStyles($conditionalStyles);
		//$this->lphpexcel->getActiveSheet()->getStyle('A1:'.$lim.''.$rowd.'')->setConditionalStyles($conditionalStyles);
		$this->lphpexcel->getActiveSheet()->setTitle('Simple');


		// Set active sheet index to the first sheet, so Excel opens this as the first sheet
		$this->lphpexcel->setActiveSheetIndex(0);
		
		
		// Redirect output to a client’s web browser (Excel2007)
		header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
		header('Content-Disposition: attachment;filename="'.date('YmdHis').'.xlsx"');
		header('Cache-Control: max-age=0');
		// If you're serving to IE 9, then the following may be needed
		// header('Cache-Control: max-age=1');

		// If you're serving to IE over SSL, then the following may be needed
		header ('Expires: Mon, 26 Jul 1997 05:00:00 GMT'); // Date in the past
		header ('Last-Modified: '.gmdate('D, d M Y H:i:s').' GMT'); // always modified
		header ('Cache-Control: cache, must-revalidate'); // HTTP/1.1
		header ('Pragma: public'); // HTTP/1.0

		$objWriter = PHPExcel_IOFactory::createWriter($this->lphpexcel, 'Excel2007');
		$objWriter->save('php://output');
	}
	
	
	public function getghvperiode_mapping ($satu, $dua, $tiga, $empat, $filter = array() , $limit = '25', $offset = '0', $order = '' )
	{	
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
		if (is_array($filter) && count($filter) > 0 ) {
			$wherenya  = generate_filter($filter,'ok');
			// $wherenya = " WHERE ". implode(" AND ", $where);
			}
		$query = "select * from getghvsummary_mapping('". $satu ."' , '".$dua."', '".$tiga."' , '".$empat."' ) ".$wherenya." ".$orderby." ".$limitnya;
		$sql = $this->db->query($query);
		
		if($sql->num_rows > 0){
			return $sql->result();
		} else{
			return false;
		}	
	}
	
	public function total_getghvperiode_mapping ($satu, $dua, $tiga, $filter = array() )
	{	 
		if (is_array($filter) && count($filter) > 0 ) {			
			$wherenya = generate_filter($filter,'ok');
			// $wherenya = " WHERE ". implode(" AND ", $where);
			}
		$sql = $this->db->query("select * from getghvsummary_mapping('$satu', '$dua', '$tiga', '$empat') " .$wherenya  );		
		return $sql->num_rows();					
	}
	
	public function findmappingghv(){
		
		$kemarin = date("Y-m-d", time() - 86400) ;
		$kemarinlusa = date("Y-m-d", time() - 172800);
		
		
		$tahunbulan = substr($kemarinlusa, 0, 7); 
		$awaltanggal = "01";
		$starttt = $tahunbulan."-".$awaltanggal;		
		
		$filter = $this->input->get('filter', TRUE) > ''? $this->input->get('filter', TRUE) : array();	
		
		$canrd = whereTofilter('sbu', $this->session->userdata('rd') , 'list' , '');
		$canarea = whereTofilter('area', $this->session->userdata('area') , 'list' , '');

		$satu = $this->input->get('startt',true) > '' ? $this->input->get('startt',true)."-01" : $starttt ;
		$dua = $this->input->get('endd',true) > '' ? $this->input->get('endd',true)."-01" : $kemarin ;
		
		$enam = $this->input->get('area',true) > '' ? whereTofilter('area', $this->input->get('area',true) , 'string' , '') : $canarea ;
		
		$lima = $this->input->get('sbu',true) > '' ? whereTofilter('sbu', $this->input->get('sbu',true) , 'string' , '') : $canrd;
		$tiga = $this->input->get('id_pel',true) > '' ?  $this->input->get('id_pel',true)  : '' ;
		
		$empat = $this->input->get('namapel',true) > '' ? $this->input->get('namapel',true) : '' ;		
		
		// $tujuh =  $this->input->get('station',true) > '' ? whereTofilter('stationname', $this->input->get('station',true) , 'string' , '') : '' ;
		
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    
	    $sorts = json_decode($this->input->get('sort', TRUE));
	    if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = "total_periode DESC";
	    }	
		
		array_push($filter, $lima, $enam );
		
		// $filters = generate_filter($filter, 'okeh');
		
		$vtable = "getghvsummary_mapping('". $satu ."' , last_day('".$dua."'), '".$tiga."' , '".$empat."' )";
		$total_entries = $this->b_model->count_all_data_func($vtable, $filter);
		$entries  = $this->b_model->get_all_datafunc ($vtable ,$filter, $limit, $offset, $order_by);
		
		$data['success'] = true;
	    $data['total'] = $total_entries;
	    $data['data'] = $entries;  
		
	    extjs_output($data);
		
		
	}
	
	public function getghvperiode_penyaluran ($satu, $dua, $tiga, $filter = array() , $limit = '25', $offset = '0', $order = '' )
	{	
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
		if (is_array($filter) && count($filter) > 0 ) {
			$wherenya  = generate_filter($filter,'ok');
			// $wherenya = " WHERE ". implode(" AND ", $where);
			}
		$query = "select * from getghvperiode_penyaluran('". $satu ."' , '".$dua."', '".$tiga."') ".$wherenya." ".$orderby." ".$limitnya;
		$sql = $this->db->query($query);
		
		if($sql->num_rows > 0){
			return $sql->result();
		} else{
			return false;
		}	
	}
	
	public function total_getghvperiode_penyaluran ($satu, $dua, $tiga, $filter = array() )
	{	 
		if (is_array($filter) && count($filter) > 0 ) {			
			$wherenya = generate_filter($filter,'ok');
			// $wherenya = " WHERE ". implode(" AND ", $where);
			}
		$sql = $this->db->query("select * from getghvperiode_penyaluran('$satu', '$dua', '$tiga') " .$wherenya  );		
		return $sql->num_rows();					
	}
	
	public function findreffghv(){
		
		$kemarin = date("Y-m-d", time() - 86400);
		// $kemarin = '20161130000000';
		// $kemarinlusa = '20161101000000';
		$kemarinlusa = date("Y-m-d", time() - 172800);
		
		$filter = $this->input->get('filter', TRUE) > ''? $this->input->get('filter', TRUE) : array();	
		
		// $canrd = $this->session->userdata('rd');	
		$canarea = $this->session->userdata('area');		
		// $canarea = 'Tangerang';		

		$satu = $this->input->get('startt',true) > '' ? $this->input->get('startt',true)."" : $kemarinlusa ;
		$dua = $this->input->get('endd',true) > '' ? $this->input->get('endd',true)."" : $kemarin ;	
		
		$tiga = $this->input->get('area',true) > '' ? $this->input->get('area',true) : $canarea ;
		
		$empat = $this->input->get('sbu');
		$lima = $this->input->get('id_pel',true) > '' ? whereTofilter('id_pel', $this->input->get('id_pel',true) , 'string' , 'eq') : '' ;
		
		$enam = $this->input->get('namapel',true) > '' ? whereTofilter('nama_pel', $this->input->get('namapel',true) , 'string' , '') : '' ;
		$tujuh =  $this->input->get('station',true) > '' ? whereTofilter('station', $this->input->get('station',true) , 'string' , '') : '' ;
		
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    
	    $sorts = json_decode($this->input->get('sort', TRUE));
	    if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	$order_by = "rowid asc";
	    }	
		
		array_push($filter, $lima, $enam , $tujuh);
		
		$total_entries = $this->total_getghvperiode_penyaluran ($satu, $dua, $tiga, $filter);
		$entries  = $this->getghvperiode_penyaluran ($satu, $dua, $tiga, $filter, $limit, $offset, $order_by);
		
		$data['success'] = true;
	    $data['total'] = $total_entries;
	    $data['data'] = $entries;  
		
	    extjs_output($data);	
		
		
	}
	
	function carilegend()
	{
		
		$kemarin = date("Y-m-d", time() - 86400) ;
		$kemarinlusa = date("Y-m-d", time() - 172800);
		
		$tahunbulan = substr($kemarinlusa, 0, 7); $awaltanggal = "01";
		$starttt = $tahunbulan."-".$awaltanggal;		

		$canrd = $this->session->userdata('rd');	
		$canarea = $this->session->userdata('area');		

		$satu = $this->input->get('startt',true) > '' ? $this->input->get('startt',true)."-01" : $starttt ;
		$dua = $this->input->get('endd',true) > '' ? $this->input->get('endd',true)."-01" : $kemarin ;
		
		$tiga = $this->input->get('id_pel',true) > '' ? $this->input->get('id_pel',true) : '' ;
		
		$empat = $this->input->get('namapel',true) > '' ? $this->input->get('namapel',true) : '' ;
		$filter = json_decode($this->input->get('search'),true);
		$cari = generate_filter($filter, 'okeh');
		$cari = str_replace("WHERE","AND",$cari);
		
		$sql = $this->db->query(" select DISTINCT splitdata(station,'|', 3) as kode, splitdata(station,'|', 2) as nm_station from getghv_mapping2('".$satu."',last_day('".$dua."'), '".$tiga."', '".$empat."', 0 ) where station is not null ".$cari."");	
		//echo $sql;
		//die();
		$data['success'] = true;
	    $data['total'] = $sql->num_rows();
	    $data['data'] =   $sql->result();
		
	    extjs_output($data);
		
	}
	
	
}
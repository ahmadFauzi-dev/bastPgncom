<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Master extends CI_Controller {
	function __construct()
       {
			
           
			parent::__construct();
			$this->output->set_header("HTTP/1.0 200 OK");
			$this->output->set_header("Access-Control-Allow-Origin: *");
			$this->output->set_header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
			//header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
			$this->output->set_header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE");
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
	public function getjenisstaion()
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
		
		if($filter == false)
		{
			$filter = array();
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		
		
		
		$dataas = $this->b_model->get_all_data('v_mstation', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('v_mstation', $filter);
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
	public function getpointtype()
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
		
		if($filter == false)
		{
			$filter = array();
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		
		
		
		$dataas = $this->b_model->get_all_data('pointtypedesc', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('pointtypedesc', $filter);
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
	
	public function getpointalias()
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
		
		if($filter == false)
		{
			$filter = array();
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		
		
		
		$dataas = $this->b_model->get_all_data('pointalias', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('pointalias', $filter);
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
	public function getpelanggan()
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
		
		if($filter == false)
		{
			$filter = array();
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		
		
		
		$dataas = $this->b_model->get_all_data('v_pelangganindustri', $filter , $limit, $offset, '');
		$count = $this->b_model->count_all_data('v_pelangganindustri', $filter);
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
	public function getloaddata()
	{
		header('Access-Control-Allow-Origin: *');  
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
		$node = $this->input->get('node');
		$view = $this->input->get('view');
	    
		//var_dump($node);
		
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	//$order_by = 'rowid desc';
	    }
		
		if($filter == false)
		{
			$filter = array();
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		//$filter[6]['data']['value'] = "(NULL OR statusapproval = 'Reject')";
		$filter[6]['data']['tipe'] = '2kondisi';
		$filter[6]['data']['value2'] = 'Reject';
		$dataas = $this->b_model->get_all_datafunc($view, $filter , $limit, $offset, $order_by);
		$count  = $this->b_model->count_all_data_func($view, $filter);
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
	public function getloaddataquery()
	{
		
		
		$this->load->model('b_model');
		$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
		$node = $this->input->get('node');
		$view = $this->input->get('view');
	    
		//var_dump($node);
		
		if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else {
	    	//$order_by = 'rowid desc';
	    }
		
		if($filter == false)
		{
			$filter = array();
		}else
		{
			$filter = $this->input->get('filter', TRUE);
		}
		//$view = "SELECT * FROM usr_amr_pgasol.alert_daily";
		
		$dataas = $this->b_model->get_all_dataquery($view , $limit, $offset, $order_by);
		$count  = $this->b_model->count_all_data_query($view);
		$n=0;
		// var_dump($dataas);
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
	public function updateprivsbu()
	{
		$this->load->model('b_model');
		$group = $this->input->post('group');
		$area  = $this->input->post('area');
		$sbu   = $this->input->post('sbu');
		
		$filter[0]['field'] = "group_id";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> $group);
		$data = array("canrd"	=> $sbu,
					 "canarea"	=> $area);		
					 
		$this->b_model->update_data('group_permission', $filter ,$data);
	}
	public function updatemenupriv()
	{
		$this->load->model('b_model');
		$data = json_decode($this->input->post('data'));
		$idgroup = $data[0]->group_id;
		
		$filter[0]['field'] = "group_id";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> $idgroup);
		$this->b_model->delete_data('permission', $filter);
		
		//$this->b_model->insert_batch('permission',);
		foreach($data as $row)
		{	
			$this->b_model->insert_data('permission', $row);
		}
	}
	public function gendate()
	{
		$startTime = strtotime( '2010-05-01' );
		$endTime = strtotime( '2010-05-10' );

		// Loop between timestamps, 24 hours at a time
		for ( $i = $startTime; $i <= $endTime; $i = $i + 86400 ) {
		  $thisDate = date( 'Y-m-d', $i ); // 2010-05-01, 2010-05-02, etc
		  echo $thisDate."<br/>";
		}
		//echo "OK";
	}
	public function rebatchsipgas()
	{
		$prot = "https://";
		$tgl  = '2016-05-01';
		$area = '011';
		$noref = '';
		$amr = 'daily';
		$url  = $prot."gms.pgn.co.id/api/services/batch_amr";
		$params = "token=S1PG4sEMb3rsAtu&amr=".$amr."&fdatetime=".$tgl."&area=".$area."&noref=".$noref."";
		
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
		echo "<pre>";
			var_dump($err);
		echo "</pre>";
		echo "<pre>";
			var_dump($header);
		echo "</pre>";
		echo "<pre>";
			var_dump($errmsg);
		echo "</pre>";
		curl_close( $ch );
		
		//$resp = curl_exec($curl);
		echo $resp;
	}
	public function rebatchalert()
	{
		$prot = "https://";
		$tgl  = '2016-05-13';
		$area = '';
		$noref = '';
		$amr = 'daily';
		$url  = $prot."gms.pgn.co.id/api/services/batch_alert";
		$params = "token=S1PG4sEMb3rsAtu&alert_date=".$tgl."&area=".$area."&noref=".$noref."";
		
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
		echo "<pre>";
			var_dump($err);
		echo "</pre>";
		echo "<pre>";
			var_dump($header);
		echo "</pre>";
		echo "<pre>";
			var_dump($errmsg);
		echo "</pre>";
		curl_close( $ch );
		
		//$resp = curl_exec($curl);
		echo $resp;
	}
	public function rebatchtax()
	{
		$prot = "https://";
		$tgl  = '2016-05-13';
		$area = '013';
		$noref = '';
		$amr = 'daily';
		$url  = $prot."gms.pgn.co.id/api/services/batch_alert";
		$params = "token=S1PG4sEMb3rsAtu&taxation_date=".$tgl."&area=".$area."&noref=".$noref."";
		
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
		echo "<pre>";
			var_dump($err);
		echo "</pre>";
		echo "<pre>";
			var_dump($header);
		echo "</pre>";
		echo "<pre>";
			var_dump($errmsg);
		echo "</pre>";
		curl_close( $ch );
		
		//$resp = curl_exec($curl);
		echo $resp;
	}
	public function encodeurl()
	{
		$filter = $this->input->post('filter');
		echo json_encode($filter);
		
	}
	public function downloaddok()
	{
		
		//$kemarin = date("Ymd", time() - 86400);
		//$kemarin = '20160701';
		$kemarin = date("Ymd");
		
		$limit = 'All';
		$offset = 0;
		$this->load->model('b_model');
		$filter = array();
		$filter[0]['field'] = "credatenum";
		$filter[0]['data']  = array("comparison"	=> "eq",
							   "type"		=> "numeric",
							   "value"		=> intval($kemarin));
							   
		
		
		$dp  = $this->b_model->get_all_data('v_docreff_master', $filter , $limit, $offset, '');
		var_dump($dp);
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
					
			$this->b_model->update_data('doc_refference', $filterup ,$data);
			
		}
		
		//header("Location: ".base_url()."document/upload/test.pdf");
		
	}
	public function cekvalidasi()
	{
		$filter = array();
		$limit = 5;
		$dp  = $this->b_model->get_all_data('v_realtimevalidasi', $filter , $limit, $offset, '');
		echo json_encode($dp);
		
	}
	public function getloaddatatree()
	{
		$this->load->model('b_model');
		//$limit = $this->input->get('limit', TRUE) > '' ? $this->input->get('limit', TRUE) : 25;
		$limit = 'All';
	    $offset = $this->input->get('start', TRUE);
	    $filter = $this->input->get('filter', TRUE);		
		$jumlahfilter = count($filter);
	    $sorts = json_decode($this->input->get('sort', TRUE));
		$node = $this->input->get('node');
		$view = $this->input->get('view');
		//$node = $this->input->get('node');
	   if ($sorts) {
		    foreach ($sorts as $sort) {
		        $orders[] = $sort->property.' '.$sort->direction;
		    }
		    $order_by = implode(', ', $orders);
	    } else 		{
	    	$order_by = 'id desc';
	    }
		//$filter = array();
		if($node == 'root')
		{			if($filter[1]['data']['value'] == ''){
				$filter[2]['field'] = "parent";
				$filter[2]['data'] = array("comparison"	=> "eq",
										   "type"		=> "numeric",
										   "value"		=> '0');
			}						if($filter[0]['data']['value'] == ''){
				$filter[2]['field'] = "parent";
				$filter[2]['data'] = array("comparison"	=> "eq",
										   "type"		=> "numeric",
										   "value"		=> '0');
			}		}else
		{
			$filter[2]['field'] = "parent";
			$filter[2]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> $node);
		}				
		$dataas = $this->b_model->get_all_datafunc($view, $filter , $limit, $offset, '');		$count = $this->b_model->count_all_data_func($view, $filter);
		$n=0;		
		foreach ($dataas as $row) {
			$data[] = $row;
			//$data[$n]->checked = false;
			$data[$n]->iconCls = "false";
			$filteras[2]['field'] = "parent";
			$filteras[2]['data']  = array("comparison"		=> "eq",
									    "type"				=> "numeric",
									    "value"				=> $row->id);
			$count		 = $this->b_model->count_all_data_func($view, $filteras);
			if($count > 0 )
			{
				$data[$n]->leaf = false;
				//$data[$n]->expanded = true;
			}else
			{
				$data[$n]->leaf = true;
			}
			$n++;
		}
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			'data'      => $data
		);		echo json_encode($json);
	}
	public function savereceipt()
	{
		//echo "OKOKOK";
		header('Access-Control-Allow-Origin: *');
		$postdata = file_get_contents("php://input");
		//$data->status_elemen = "MD294";
		$data = json_decode($postdata);
		$table = 'ms_items';
		$filter[0]['field'] = "rowid";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $data->kode_barang);
		$dp  = $this->b_model->get_all_data('ms_items', $filter , 1, 0, '');	
		$data->item_typeid = $dp[0]->item_typeid;
		$data->item_category = $dp[0]->item_category;
		$data->item_number = $dp[0]->item_number;
		$data->item_name = $dp[0]->item_name;
		$data->reffrekanan = $dp[0]->reffrekanan;
		$filter[0]['field'] = "farms";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $data->farms);
								   
		$filter[1]['field'] = "item_typeid";
		$filter[1]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $data->item_typeid);
		
		$filter[2]['field'] = "item_category";
		$filter[2]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $data->item_category);

		$filter[3]['field'] = "item_number";
		$filter[3]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $data->item_number);	

								   
		$filter[4]['field'] = "type_items";
		$filter[4]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> 1);
		$count = $this->b_model->count_all_data('ms_items', $filter);
		
		if($count == 0)
		{
			
			//$data->total_stock = $data->jumlah;
			
			$data_insert = array(
				"item_number"			=> $data->item_number,
				"item_category"			=> $data->item_category,
				"item_typeid"			=> $data->item_typeid,
				"farms"					=> $data->farms,
				"kandang"				=> $data->kandang,
				"status"				=> 'Active',
				"qty"					=> $data->jumlah,
				"uom"					=> $data->satuan,
				"item_name"				=> $data->item_name,
				"status_transaski"		=> 	"IN",
				"type_items"			=> 1,
				"reffrekanan"			=> 	$data->suplier,
				"total_stock"			=> $data->jumlah,
				"status_elemen"			=> $data->status_elemen,
				"keterangan"			=> $data->keterangan
			);
			$table = 'ms_items';
			$this->b_model->insert_data($table, $data_insert);
			$data_insert['type_items'] = 2;
			$this->b_model->insert_data($table, $data_insert);
		}else
		{
			$dpas  = $this->b_model->get_all_data('ms_items', $filter , 1, 0, '');	
			$total_stockold = $dp[0]->total_stock;
			
			IF(strtoupper($data->status_transaski) == 'IN')
			{
				$total_stock = $total_stockold + $data->jumlah;
				
			}
			else
			{
				$total_stock = $total_stockold - $data->jumlah;
			}
			
			$data->type_items = 2;
			$data->total_stock = $total_stock;
			$data_insert = array(
				"item_number"			=> $data->item_number,
				"item_category"			=> $data->item_category,
				"item_typeid"			=> $data->item_typeid,
				"farms"					=> 	$data->farms,
				"kandang"				=> 	$data->kandang,
				"status"				=> 	'Active',
				"qty"					=> 	$data->jumlah,
				"uom"					=> 	$data->satuan,
				"item_name"				=> 	$data->item_name,
				"status_transaski"		=> 	$data->status_transaski,
				"reffrekanan"			=> 	$data->reffrekanan,
				"type_items"			=> $data->type_items,
				"reffrekanan"			=> $data->suplier,
				"total_stock"			=> $total_stock,
				"status_elemen"			=> $data->status_elemen,
				"keterangan"			=> $data->keterangan
			);
			$this->b_model->insert_data('ms_items', $data_insert);
			$data_update = array("total_stock"	=> $total_stock,
								"updatedate"	=> 'now()');
			$this->b_model->update_data('ms_items', $filter ,$data_update);
		}
		
	}
	public function savepencatatan()
	{ 
		
		$postdata = file_get_contents("php://input");
		$request = json_decode($postdata);
		$filter[0]['field'] = "refffarms";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $request->kode_farms);
								   
		$filter[1]['field'] = "type_items";
		$filter[1]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> 1);
								   
		$filter[2]['field'] = "reffkandang";
		$filter[2]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $request->kode_kandang);
								   
		$count = $this->b_model->count_all_data('trans_pengembangan', $filter);
		
		if($count == 0 and $request->kode_farms != '')
		{
			$data->total_stock = $data->qty;
			$data = array("refffarms"	=> $request->kode_farms,
						  "reffkandang"	=> $request->kode_kandang,
						  "jumlah"		=> $request->jumlah,
						  "sisa"		=> $request->jumlah,
						  "type_items"	=> 1);			  
			$this->b_model->insert_data('trans_pengembangan', $data);
			$dp  = $this->b_model->get_all_data('trans_pengembangan', $filter , 1, 0, '');	
			$total_stockold = 0 ;
			
			IF( $request->status_transaski == 'MD33')
			{
				$total_stock = $total_stockold + $request->jumlah;
				
			}
			if($request->status_transaski == 'MD34')
			{
				$total_stock = $total_stockold - $request->jumlah;
			}
			$data_insert = array("refffarms"	=> $request->kode_farms,
						  "reffkandang"	=> $request->kode_kandang,
						  "jumlah"		=> $request->jumlah,
						  "sisa"		=> $total_stock,
						  "type_items"	=> 2,
						  "status_transaksi"	=> $request->status_transaski,
						  "status_elemen"		=> $request->status_elemen);		
			$this->b_model->insert_data('trans_pengembangan', $data_insert);
			$data_update = array("sisa"	=> $total_stock,
								"update_date"	=> 'now()');
			$filter[0]['field'] = "refffarms";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $request->kode_farms);
									   
			$filter[1]['field'] = "type_items";
			$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> 1);	
									   
			$filter[2]['field'] = "reffkandang";
			$filter[2]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $request->kode_kandang);							
			$this->b_model->update_data('trans_pengembangan', $filter ,$data_update);
			
		}else if($count > 0 and $request->kode_farms != '')
		{
			$filter[0]['field'] = "refffarms";
			$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $request->kode_farms);
								   
			$filter[1]['field'] = "type_items";
			$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> 1);
									   
			$filter[2]['field'] = "reffkandang";
			$filter[2]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $request->kode_kandang);
									   
			$dp  = $this->b_model->get_all_data('trans_pengembangan', $filter , 1, 0, '');	
			$total_stockold = $dp[0]->sisa;
			
			IF( $request->status_transaski == 'MD33')
			{
				$total_stock = $total_stockold + $request->jumlah;
				
			}
			if($request->status_transaski == 'MD34')
			{
				$total_stock = $total_stockold - $request->jumlah;
			}
			$data_insert = array("refffarms"	=> $request->kode_farms,
						  "reffkandang"	=> $request->kode_kandang,
						  "jumlah"		=> $request->jumlah,
						  "sisa"		=> $total_stock,
						  "type_items"	=> 2,
						  "status_transaksi"	=> $request->status_transaski,
						  "status_elemen"		=> $request->status_elemen);		
			$this->b_model->insert_data('trans_pengembangan', $data_insert);
			$data_update = array("sisa"	=> $total_stock,
								"update_date"	=> 'now()');
			
			$filter[0]['field'] = "refffarms";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $request->kode_farms);
									   
			$filter[1]['field'] = "type_items";
			$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> 1);
									   
			$filter[2]['field'] = "reffkandang";
			$filter[2]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $request->kode_kandang);				
			$this->b_model->update_data('trans_pengembangan', $filter ,$data_update);
			
		}
	}
	public function savepencatatanjual()
	{
		$postdata = file_get_contents("php://input");
		$request = json_decode($postdata);
		$filter[0]['field'] = "refffarms";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $request->kode_farms);
								   
		$filter[1]['field'] = "type_items";
		$filter[1]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> 1);
								   
		$filter[2]['field'] = "reffkandang";
		$filter[2]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $request->kode_kandang);
								   
		$count = $this->b_model->count_all_data('trans_pengembangan', $filter);
		
		if($count == 0 and $request->kode_farms != '')
		{
			$data->total_stock = $data->qty;
			$data = array("refffarms"	=> $request->kode_farms,
						  "reffkandang"	=> $request->kode_kandang,
						  "jumlah"		=> $request->jumlah,
						  "sisa"		=> $request->jumlah,
						  "type_items"	=> 1);			  
			$this->b_model->insert_data('trans_pengembangan', $data);
			$dp  = $this->b_model->get_all_data('trans_pengembangan', $filter , 1, 0, '');	
			$total_stockold = 0 ;
			
			IF( $request->status_transaski == 'MD33')
			{
				$total_stock = $total_stockold + $request->jumlah;
				
			}
			if($request->status_transaski == 'MD34')
			{
				$total_stock = $total_stockold - $request->jumlah;
			}
			$data_insert = array("refffarms"	=> $request->kode_farms,
						  "reffkandang"	=> $request->kode_kandang,
						  "jumlah"		=> $request->jumlah,
						  "sisa"		=> $total_stock,
						  "type_items"	=> 2,
						  "status_transaksi"	=> $request->status_transaski,
						  "status_elemen"		=> $request->status_elemen
						  //"total_berat"			=> $request->berat
						  );		
			$this->b_model->insert_data('trans_pengembangan', $data_insert);
			$data_update = array("sisa"	=> $total_stock,
								"update_date"	=> 'now()');
			$filter[0]['field'] = "refffarms";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $request->kode_farms);
									   
			$filter[1]['field'] = "type_items";
			$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> 1);	
									   
			$filter[2]['field'] = "reffkandang";
			$filter[2]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $request->kode_kandang);							
			$this->b_model->update_data('trans_pengembangan', $filter ,$data_update);
			
		}else if($count > 0 and $request->kode_farms != '')
		{
			$filter[0]['field'] = "refffarms";
			$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $request->kode_farms);
								   
			$filter[1]['field'] = "type_items";
			$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> 1);
									   
			$filter[2]['field'] = "reffkandang";
			$filter[2]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $request->kode_kandang);
									   
			$dp  = $this->b_model->get_all_data('trans_pengembangan', $filter , 1, 0, '');	
			$total_stockold = $dp[0]->sisa;
			
			IF( $request->status_transaski == 'MD33')
			{
				$total_stock = $total_stockold + $request->jumlah;
				
			}
			if($request->status_transaski == 'MD34')
			{
				$total_stock = $total_stockold - $request->jumlah;
			}
			$data_insert = array("refffarms"	=> $request->kode_farms,
						  "reffkandang"	=> $request->kode_kandang,
						  "jumlah"		=> $request->jumlah,
						  "sisa"		=> $total_stock,
						  "type_items"	=> 2,
						  "status_transaksi"	=> $request->status_transaski,
						  "status_elemen"		=> $request->status_elemen,
						  "reffpenjualan"		=> $request->reffjual,
						  "total_berat"			=> $request->berat);		
			$this->b_model->insert_data('trans_pengembangan', $data_insert);
			$data_update = array("sisa"	=> $total_stock,
								"update_date"	=> 'now()');
			
			$filter[0]['field'] = "refffarms";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $request->kode_farms);
									   
			$filter[1]['field'] = "type_items";
			$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> 1);
									   
			$filter[2]['field'] = "reffkandang";
			$filter[2]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $request->kode_kandang);				
			$this->b_model->update_data('trans_pengembangan', $filter ,$data_update);
			
		}
	}
	public function savetimbang()
	{
		header('Access-Control-Allow-Origin: *');
		header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
		header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE");
		$postdata = file_get_contents("php://input");
		$request = json_decode($postdata);
		if($request->kode_kandang !=''){
		$data_insert = array(
			"items_id"	=> "MD49",
			"berat"		=> $request->jumlah,
			"uom"		=> "Gram",
			"kandang"	=> $request->kode_kandang,
			"farms"		=> $request->kode_farms
		);
		$this->b_model->insert_data('mskonversiberat', $data_insert);
		}
	}
	public function saveitems()
	{
		
		
		die();
		$filter[0]['field'] = "farms";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $data->farms);
								   
		$filter[1]['field'] = "item_typeid";
		$filter[1]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $data->item_typeid);
		
		$filter[2]['field'] = "item_category";
		$filter[2]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $data->item_category);

		$filter[3]['field'] = "item_number";
		$filter[3]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $data->item_number);	

								   
		$filter[4]['field'] = "type_items";
		$filter[4]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> $data->type_items);							   
								   
								   
								   	
		$count = $this->b_model->count_all_data($this->input->post('tbl'), $filter);
		if($count == 0)
		{
			$data->total_stock = $data->qty;
			$this->b_model->insert_data($table, (array) $data);
			$data->type_items = 2;
			$this->b_model->insert_data($table, (array) $data);
		}else
		{
			$filter[0]['field'] = "farms";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $data->farms);
									   
			$filter[1]['field'] = "item_typeid";
			$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $data->item_typeid);
			
			$filter[2]['field'] = "item_category";
			$filter[2]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $data->item_category);

			$filter[3]['field'] = "item_number";
			$filter[3]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $data->item_number);	

									   
			$filter[4]['field'] = "type_items";
			$filter[4]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> 1);
									   
			$dp  = $this->b_model->get_all_data($this->input->post('tbl'), $filter , 1, 0, '');	
			$total_stockold = $dp[0]->total_stock;
			IF($data->status_transaski == 'IN')
			{
				$total_stock = $total_stockold + $data->qty;
				
			} 
			if(strtolower($data->status_transaski) == 'out')
			{
				$total_stock = $total_stockold - $data->qty;
			}
			$data->type_items = 2;
			$data->total_stock = $total_stock;
			
			$this->b_model->insert_data($table, (array) $data);
			$data_update = array("total_stock"	=> $total_stock,
								"updatedate"	=> 'now()');
			$this->b_model->update_data($table, $filter ,$data_update);
			
		}
	}
	
}
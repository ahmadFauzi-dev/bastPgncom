<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Master extends MY_Controller {
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
		$dataas = $this->b_model->get_all_data($view, $filter , $limit, $offset, $order_by);
		$count  = $this->b_model->count_all_data($view, $filter);
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
		$view = 'usr_amr_pgasol.alert_daily';
		//echo $view;
		$dataas = $this->b_model->get_all_dataquery($view , $limit, $offset, $order_by);
		//$count  = $this->b_model->count_all_dataquery($view);
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
	
}
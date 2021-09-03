<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Test extends CI_Controller {
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
		echo "Hello ".PHP_EOL;
	}
	public function tiket()
	{
		/*
		$wgserver = "http://192.168.105.46:8080";	
		$params = array(
			'username' => "user2",
			'client_ip' => $_SERVER['REMOTE_ADDR']
		  );

		$ticket =  do_post_request("http://$wgserver/trusted", $params);
			
		 var_dump($params);
		//var_dump($_SERVER['REMOTE_ADDR']);
		*/
		$this->load->view('tiket');
	}
	public function loginapi()
	{
		$URL = "syam.pgn.co.id";
		
		$payload = '<tsRequest>
					  <credentials name="admPgn" password="@dmin123" >
						<site contentUrl="" />
					  </credentials>
					</tsRequest>';
					
		$ch = curl_init($URL."/api/2.0/auth/signin");
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: text/xml'));
		curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		$output = curl_exec($ch);
		curl_close($ch);

		$xml = simplexml_load_string($output);
		$token = $xml->credentials->attributes()->token;
		echo "<pre>";
			var_dump($xml);
		echo "</pre>";
		return $token;
	}
	public function cekquery()
	{
		//$bridge = "OK";
		//dl('php_oci8.dll');
		$this->db2  = $this->load->database('toni', TRUE);
		var_dump($this->db2);
		
	}
	
}
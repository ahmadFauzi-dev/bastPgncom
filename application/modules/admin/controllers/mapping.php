<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Mapping extends MY_Controller {
   function __construct()
   {
		parent::__construct();
		$this->output->set_header("HTTP/1.0 200 OK");
		$this->output->set_header("HTTP/1.1 200 OK");
		//$this->output->set_header('Last-Modified: '.gmdate('D, d M Y H:i:s', $last_update).' GMT');
		$this->output->set_header("Cache-Control: no-store, no-cache, must-revalidate");
		$this->output->set_header("Cache-Control: post-check=0, pre-check=0");
		 $this->output->set_header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); 
		$this->output->set_header("Pragma: no-cache");
		// Your own constructor code
	$this->load->model('b_model');
	$this->load->helper('path');
   }
	public	function index(){}	
}
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
	public	function index(){}		public function towordbapp()	{		$limit 			= 'All';	    $offset 		= 0;		//$view 			= $this->input->get('view');	    $view 			= 'v_bastreport';		$path = substr(BASEPATH,0,-7).'asset/docx/';		$filename = date('YmdHisu').'____'.'BAST.docx';		$filter = json_decode($this->input->get('search'),true);		$this->load->library('docxtemplate',$path.'template_bast.docx');		$dataas = $this->b_model->get_all_data($view, $filter , $limit, $offset);		$datac = $this->b_model->get_all_data('v_selectcolumnreportbast', array() , $limit, $offset);		$datac = $this->b_model->get_all_data('v_selectcolumnreportbast', array() , $limit, $offset);				foreach ($datac as $datacs) {			$cname = $datacs->column_name;			$values = $dataas[0]->$cname;			$this->docxtemplate->set($cname,$values);		}		$rowids = $filter[0]['data']['value'];		$vtable2 = "fn_rberdasarkan('".$rowids."')";		$datar  = $this->b_model->get_all_datafunc($vtable2 ,array(), 10, '', '');				$no = 1;				foreach ($datar as $datasr) {			$this->docxtemplate->set('berdasarkan'.$no,$datasr->isi);					$no++;		}		$this->docxtemplate->saveAs($filename);				header('Content-Type:application/msword');			header('Content-Disposition:attachment;filename=" '.$filename.'"');         header('Cache-Control: max-age=0'); //no cache		readfile($filename);	}
}
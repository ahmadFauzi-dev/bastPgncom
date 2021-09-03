<?php if( ! defined('BASEPATH')) exit('No direct script access allowed');

class Goblok extends CI_Controller{

	function __construct(){
		parent::__construct();
	}
	
	public function index ()
	{

		$start 		 = $this->input->get('startt',true);
		$end 		 = $this->input->get('endd',true);
		$area  		 = $this->input->get('areacode',true);
		$startTime   = strtotime($start);
		$endTime 	 = strtotime($end);
		$kemarin 	 = date("Y-m-d", time() - 86400);
		$kemarinlusa = date("Y-m-d", time() - 172800);
		$startt = $start > '' ? $start : $kemarinlusa;
		$endd 	= $end > '' ? $end : $kemarin;
		$out = array();
		
		exec('C:\\xampp\\htdocs\\sipgem\\exec\\rebatch2.bat '.$area. ' '. $startt. ' '. $endd.'' ,$out, $exitcode);
		// echo 'C:\xampp\htdocs\sipgem\exec\data_integration\pan.bat -file:C:\\ETL_EMS\\manual\\etl_manual_amr_bridge_daily_upd.ktr "-param:area='.$area.'" "-param:tanggal1='.$startt.'" "-param:tanggal2='.$endd.'"' ;
		
		

		
		echo "<br />EXEC: ( exitcode : $exitcode )";
		echo "<hr /><pre>";
		print_r($out);
		echo "</pre>";	
		
	}
}
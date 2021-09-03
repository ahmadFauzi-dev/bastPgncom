<?php if( ! defined('BASEPATH')) exit('No direct script access allowed');

class Integrasi extends CI_Controller{

	function __construct(){
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
	
	public function index ()
	{
		$this->load->model('b_model');
		$this->load->library("nusoap");
		$this->nusoap_server = new soap_server();
        $this->nusoap_server->configureWSDL("emintegrasi", "urn:emintegrasi");
        $this->nusoap_server->wsdl->schemaTargetNamespace = 'urn:emintegrasi';
		
		
		//Data TYPES
		$this->nusoap_server->wsdl->addComplexType(
            "dt_getinfopel",
            "complexType",
            "array",
            "",
            "SOAP-ENC:Array",
            array(
                'rowid' 		=> array('name' => 'rowid', 'type' => 'xsd:string'),
				'data'			=> array('name'	=> 'limitv', 'type'	=> 'xsd:integer'),
				'start'			=> array('name'	=> 'start', 'type'	=> 'xsd:integer'),
				'period_month'	=> array('name'	=> 'period_month', 'type'	=> 'xsd:date'),
				'area'			=> array('name'	=> 'area', 'type'	=> 'xsd:string'),
				'assettype'		=> array('name'	=> 'assettype', 'type'	=> 'xsd:string'),
				'data'			=> array('name'	=> 'data', 'type'	=> 'xsd:string'),
				'paging'		=> array('name'	=> 'paging', 'type'	=> 'xsd:integer')
				// 'jahr' => array('name' => 'jahr', 'type' => 'xsd:integer'),
                //'interpret' => array('name' => 'interpret', 'type' => 'xsd:string'),
                //'titel' => array('name' => 'titel', 'type' => 'xsd:string')
            )
        );
		
		$this->nusoap_server->register(
            'getpelanggan',
            array('period_month' 	=> 'xsd:string',
				  'kd_area'			=> 'xsd:string',
				  'paging'			=> 'xsd:string'
			),  //parameters
            array('return' => 'tns:dt_getinfopel'),  
					'urn:emintegrasi', 
					'urn:emintegrasi#getpelanggan',
            'rpc',
            'encoded', // use
            'Penarikan data pelanggan' //description
        );
		
		$this->nusoap_server->register(
			'catatmeterindustrinormalmeter',
			array(
				'UniqueID'				=> 'xsd:string',
				'Periodecatat'			=> 'xsd:long',
				'Tanggalcatat'			=> 'xsd:long',
				'AsetAktif'				=> 'xsd:string',
				'IDPelanggan'			=> 'xsd:string',
				'Stream'				=> 'xsd:integer',
				'Kategori'				=> 'xsd:string',
				'SNmeter'				=> 'xsd:string',
				'Standawalmeter'		=> 'xsd:double',
				'Standakhirmeter'		=> 'xsd:double',
				'Selisihvolumemeter'	=> 'xsd:double',
				'PressureGauge'			=> 'xsd:double',
				'TemperatureGauge'		=> 'xsd:double',
				'FaktorKoreksi'			=> 'xsd:double',
				'VolumeCorrectedManual'	=> 'xsd:double',
				'KeteranganInfo'		=> 'xsd:string',
				'BA'					=> 'xsd:string',
				'Tanggalinput'			=> 'xsd:double',
				'Tanggalupdate'			=> 'xsd:double',
				'Sentdate'				=> 'xsd:double',
				'Sentoleh'				=> 'xsd:string',
				'DW1'					=> 'xsd:integer',
				'DW2'					=> 'xsd:integer',
				'DW3'					=> 'xsd:integer',
				'DW4'					=> 'xsd:integer',
				'DW5'					=> 'xsd:integer',
				'DW6'					=> 'xsd:integer',
				'DW7'					=> 'xsd:integer',
				'DW8'					=> 'xsd:integer',
				'DW9'					=> 'xsd:integer',
				'DB1'					=> 'xsd:integer',
				'DB2'					=> 'xsd:integer',
				'DB3'					=> 'xsd:integer',
				'DB4'					=> 'xsd:integer',
				'DB5'					=> 'xsd:integer',
				'FinalStatus'			=> 'xsd:integer'
			),
			array('return' => 'tns:dt_getinfopel'),  
			'urn:emintegrasi', 
			'urn:emintegrasi#catatmeterindustrinormal',
			'rpc',
            'encoded', // use
            'Catat  dengan aset meter' //description		
		);
		$this->nusoap_server->register(
			'catatmeterindustrinormaevc',
			array(
				"Periodecatat"	=>	"long",
				"Tanggalcatat"	=>	"long",
				"AsetAktif"	=>	"string",
				"IDPelanggan"	=>	"string",
				"Stream"	=>	"integer",
				"Jenistransaksi"	=>	"string",
				"SNmeter"	=>	"string",
				"SNEVC"	=>	"string",
				"Standawalmeter"	=>	"double",
				"Standakhirmeter"	=>	"double",
				"Selisihvolumemeter"	=>	"double",
				"Standawaluncorrectedmeter"	=>	"double",
				"Standakhiruncorrectedmeter"	=>	"double",
				"Selisihvolumeuncorrected"	=>	"double",
				"Standawalcorrectedmeter"	=>	"double",
				"Standakhircorrectedmeter"	=>	"double",
				"Selisihvolumecorrected"	=>	"double",
				"PressureGauge"	=>	"double",
				"TemperatureGauge"	=>	"double",
				"PressureEVC"	=>	"double",
				"TemperatureEVC"	=>	"double",
				"CO2"	=>	"double",
				"N2"	=>	"double",
				"SG"	=>	"double",
				"FaktorKoreksi"	=>	"double",
				"VolumeCorrectedManual"	=>	"double",
				"VolumeCorrected"	=>	"double",
				"Keterangan"	=>	"string",
				"BA"	=>	"string",
				"Tanggalinput"	=>	"long",
				"Tanggalupdate"	=>	"long",
				"Sentdate"	=>	"long",
				"Sentoleh"	=>	"string",
				"Warning1DW1"	=>	"integer",
				"Warning2DW2"	=>	"integer",
				"Warning3DW3"	=>	"integer",
				"Warning4DW4"	=>	"integer",
				"Warning5DW5"	=>	"integer",
				"Warning6DW6"	=>	"integer",
				"Warning7DW7"	=>	"integer",
				"Warning8DW5"	=>	"integer",
				"Warning9DW9"	=>	"integer",
				"Warning10DW10"	=>	"integer",
				"Warning11DW11"	=>	"integer",
				"Warning12DW12"	=>	"integer",
				"Bad1DB1"	=>	"integer",
				"Bad2DB2"	=>	"integer",
				"Bad3DB3"	=>	"integer",
				"Bad4DB4"	=>	"integer",
				"Bad5DB5"	=>	"integer",
				"FinalStatus"	=>	"integer",
			),
			array('return' => 'tns:dt_getinfopel'),  
			'urn:emintegrasi', 
			'urn:emintegrasi#catatmeterindustrinormaevc',
			'rpc',
            'encoded', // use
            'Catat  dengan aset EVC'
		);
		
		$this->nusoap_server->register(
			'catatmeterindustrinormaevcamr',
			array(
				"Periodecatat"	=>	"long",
				"Tanggalcatat"	=>	"long",
				"AsetAktif"	=>	"string",
				"IDPelanggan"	=>	"string",
				"Stream"	=>	"integer",
				"Jenistransaksi"	=>	"string",
				"SNmeter"	=>	"string",
				"SNEVC"	=>	"string",
				"SNAMR"	=> "string",
				"Standawalmeter"	=>	"double",
				"Standakhirmeter"	=>	"double",
				"Selisihvolumemeter"	=>	"double",
				"Standawaluncorrectedmeter"	=>	"double",
				"Standakhiruncorrectedmeter"	=>	"double",
				"Selisihvolumeuncorrected"	=>	"double",
				"Standawalcorrectedmeter"	=>	"double",
				"Standakhircorrectedmeter"	=>	"double",
				"Selisihvolumecorrected"	=>	"double",
				"PressureGauge"	=>	"double",
				"TemperatureGauge"	=>	"double",
				"PressureEVC"	=>	"double",
				"TemperatureEVC"	=>	"double",
				"CO2"	=>	"double",
				"N2"	=>	"double",
				"SG"	=>	"double",
				"FaktorKoreksi"	=>	"double",
				"VolumeCorrectedManual"	=>	"double",
				"VolumeCorrected"	=>	"double",
				"Keterangan"	=>	"string",
				"BA"	=>	"string",
				"Tanggalinput"	=>	"long",
				"Tanggalupdate"	=>	"long",
				"Sentdate"	=>	"long",
				"Sentoleh"	=>	"string",
				"Warning1DW1"	=>	"integer",
				"Warning2DW2"	=>	"integer",
				"Warning3DW3"	=>	"integer",
				"Warning4DW4"	=>	"integer",
				"Warning5DW5"	=>	"integer",
				"Warning6DW6"	=>	"integer",
				"Warning7DW7"	=>	"integer",
				"Warning8DW5"	=>	"integer",
				"Warning9DW9"	=>	"integer",
				"Warning10DW10"	=>	"integer",
				"Warning11DW11"	=>	"integer",
				"Warning12DW12"	=>	"integer",
				"Bad1DB1"	=>	"integer",
				"Bad2DB2"	=>	"integer",
				"Bad3DB3"	=>	"integer",
				"Bad4DB4"	=>	"integer",
				"Bad5DB5"	=>	"integer",
				"FinalStatus"	=>	"integer",
			),
			array('return' => 'tns:dt_getinfopel'),  
			'urn:emintegrasi', 
			'urn:emintegrasi#catatmeterindustrinormaevcamr',
			'rpc',
            'encoded', // use
            'Catat  dengan aset EVC'
		);
		//xsd:double
		function getpelanggan($period_month,$kd_area,$paging)
		{
			$ci =& get_instance();
			$ci->load->model('b_model');
			$filter[0]['field'] = "area";
			$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $kd_area);
								   
			$filter[1]['field'] = "paging";
			$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "list",
									   "value"		=> $paging);	

			$filter[2]['field'] = "period_month";
			$filter[2]['data'] = array("comparison"	=> "eq",
									   "type"		=> "date",
									   "value"		=> $period_month);						   
			
			$dataas = $ci->b_model->get_all_data('tbl_jsonpel',$filter , 'All', '0', '');
			return $dataas;
		}
		function catatmeterindustrinormalmeter($UniqueID,$Periodecatat,$Tanggalcatat,$AsetAktif,$IDPelanggan,$Stream,$Kategori,$SNmeter,$Standawalmeter,$Standakhirmeter,$Selisihvolumemeter,$PressureGauge,$TemperatureGauge,$FaktorKoreksi,$VolumeCorrectedManual,$KeteranganInfo,$BA,$Tanggalinput,$Tanggalupdate,$Sentdate,$Sentoleh,$DW1,$DW2,$DW3,$DW4,$DW5,$DW6,$DW7,$DW8,$DW9,$DB1,$DB2,$DB3,$DB4,$DB5,$FinalStatus)
		{
			$ci =& get_instance();
			$ci->load->model('b_model');
			
			$data_input = array(
								"periodecatat"	=> $Periodecatat,
								"tanggalcatat"	=> $Tanggalcatat,
								"assetactive"	=> $AsetAktif,
								"idrefpelanggan"	=> $IDPelanggan,
								"streamid"		=> $Stream,
								"snmeter"		=> $SNmeter,
								"std_lalu_meter"	=> $Standawalmeter,
								"std_kini_meter"	=> $Standakhirmeter,
								"mtr_volume"		=> $Selisihvolumemeter,
								"psig"				=> $PressureGauge,
								"tmpg"				=> $TemperatureGauge,
								"cf"				=> $FaktorKoreksi,
								"corrected_volume_mtr"	=>	$VolumeCorrectedManual,
								"dw1"				=> $DW1,
								"dw2"				=> $DW2,
								"dw3"				=> $DW3,
								"dw4"				=> $DW4,
								"dw5"				=> $DW5,
								"dw6"				=> $DW6,
								"dw7"				=> $DW7,
								"dw8"				=> $DW8,
								"dw9"				=> $DW9,
								"db1"				=> $DB1,
								"db2"				=> $DB2,
								"db3"				=> $DB3,
								"db4"				=> $DB4,
								"db5"				=> $DB5,
								"final_status"		=> $FinalStatus
				);
				
				$filter[0]['field'] = "periodecatat";
				$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> $Periodecatat);
				
				$filter[1]['field'] = "tanggalcatat";
				$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> $Tanggalcatat);	
									   
				$filter[2]['field'] = "idrefpelanggan";
				$filter[2]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $IDPelanggan);	

				$filter[3]['field'] = "streamid";
				$filter[3]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $Stream);

				$dataas = $ci->b_model->insert_update_data('valdy_avr',$data_input , 'All', '0', '');						
		}
		function catatmeterindustrinormaevc($Periodecatat,$Tanggalcatat,$AsetAktif,$IDPelanggan,$Stream,$Jenistransaksi,$SNmeter,$SNEVC,$Standawalmeter,$Standakhirmeter,$Selisihvolumemeter,$Standawaluncorrectedmeter,$Standakhiruncorrectedmeter,$Selisihvolumeuncorrected,$Standawalcorrectedmeter,$Standakhircorrectedmeter,$Selisihvolumecorrected,$PressureGauge,$TemperatureGauge,$PressureEVC,$TemperatureEVC,$CO2,$N2,$SG,$FaktorKoreksi,$VolumeCorrectedManual,$VolumeCorrected,$Keterangan,$BA,$Tanggalinput,$Tanggalupdate,$Sentdate,$Sentoleh,$Warning1DW1,$Warning2DW2,$Warning3DW3,$Warning4DW4,$Warning5DW5,$Warning6DW6,$Warning7DW7,$Warning8DW5,$Warning9DW9,$Warning10DW10,$Warning11DW11,$Warning12DW12,$Bad1DB1,$Bad2DB2,$Bad3DB3,$Bad4DB4,$Bad5DB5,$FinalStatus
		)
		{
			$ci =& get_instance();
			$ci->load->model('b_model');
			
			$data_input = array(
				"periodecatat"	=>	$Periodecatat,
				"tanggalcatat"	=>	$Tanggalcatat,
				"assetactive"	=>	$AsetAktif,
				"idrefpelanggan"	=>	$IDPelanggan,
				"streamid"	=>	$Stream,
				"typeoftrans"	=>	$Jenistransaksi,
				"snmeter"	=>	$SNmeter,
				"snevc"	=>	$SNEVC,
				"std_lalu_meter"	=>	$Standawalmeter,
				"std_kini_meter"	=>	$Standakhirmeter,
				"mtr_volume"	=>	$Selisihvolumemeter,
				"std_uncorrected_lalu"	=>	$Standawaluncorrectedmeter,
				"std_uncorrected_kini"	=>	$Standakhiruncorrectedmeter,
				"std_uncorrected_volume"	=>	$Selisihvolumeuncorrected,
				"std_corrected_lalu"	=>	$Standawalcorrectedmeter,
				"std_corrected_kini"	=>	$Standakhircorrectedmeter,
				"std_corrected_volume"	=>	$Selisihvolumecorrected,
				"psig"	=>	$PressureGauge,
				"tmpg"	=>	$TemperatureGauge,
				"psievc"	=>	$PressureEVC,
				"tmpevc"	=>	$TemperatureEVC,
				"co2"	=>	$CO2,
				"n2"	=>	$N2,
				"sg"	=>	$SG,
				"cf"	=>	$FaktorKoreksi,
				"corrected_volume_mtr"	=>	$VolumeCorrectedManual,
				"corrected_volume_evc"	=>	$VolumeCorrected,
				"keterangan"	=>	$Keterangan,
				"banumber"	=>	$BA,
				"inputdate"	=>	$Tanggalinput,
				"sentdate"	=>	$Sentdate,
				"sentby"	=>	$Sentoleh,
				"dw1"	=>	$Warning1DW1,
				"dw2"	=>	$Warning2DW2,
				"dw3"	=>	$Warning3DW3,
				"dw4"	=>	$Warning4DW4,
				"dw5"	=>	$Warning5DW5,
				"dw6"	=>	$Warning6DW6,
				"dw7"	=>	$Warning7DW7,
				"dw8"	=>	$Warning8DW5,
				"dw9"	=>	$Warning9DW9,
				"dw10"	=>	$Warning10DW10,
				"dw11"	=>	$Warning11DW11,
				"dw12"	=>	$Warning12DW12,
				"db1"	=>	$Bad1DB1,
				"db2"	=>	$Bad2DB2,
				"db3"	=>	$Bad3DB3,
				"db4"	=>	$Bad4DB4,
				"db5"	=>	$Bad5DB5,
				"final_status"	=>	$FinalStatus,
			);
			
			$filter[0]['field'] = "periodecatat";
			$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> $Periodecatat);
			
			$filter[1]['field'] = "tanggalcatat";
			$filter[1]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> $Tanggalcatat);	
								   
			$filter[2]['field'] = "idrefpelanggan";
			$filter[2]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $IDPelanggan);	

			$filter[3]['field'] = "streamid";
			$filter[3]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $Stream);

			$dataas = $ci->b_model->insert_update_data('valdy_avr',$data_input , 'All', '0', '');	
		}
		
		function catatmeterindustrinormaevcamr($Periodecatat,$Tanggalcatat,$AsetAktif,$IDPelanggan,$Stream,$Jenistransaksi,$SNmeter,$SNEVC,$SNAMR,$Standawalmeter,$Standakhirmeter,$Selisihvolumemeter,$Standawaluncorrectedmeter,$Standakhiruncorrectedmeter,$Selisihvolumeuncorrected,$Standawalcorrectedmeter,$Standakhircorrectedmeter,$Selisihvolumecorrected,$PressureGauge,$TemperatureGauge,$PressureEVC,$TemperatureEVC,$CO2,$N2,$SG,$FaktorKoreksi,$VolumeCorrectedManual,$VolumeCorrected,$Keterangan,$BA,$Tanggalinput,$Tanggalupdate,$Sentdate,$Sentoleh,$Warning1DW1,$Warning2DW2,$Warning3DW3,$Warning4DW4,$Warning5DW5,$Warning6DW6,$Warning7DW7,$Warning8DW5,$Warning9DW9,$Warning10DW10,$Warning11DW11,$Warning12DW12,$Bad1DB1,$Bad2DB2,$Bad3DB3,$Bad4DB4,$Bad5DB5,$FinalStatus)
		{
			$ci =& get_instance();
			$ci->load->model('b_model');
			
			$data_input = array(
				"periodecatat"	=>	$Periodecatat,
				"tanggalcatat"	=>	$Tanggalcatat,
				"assetactive"	=>	$AsetAktif,
				"idrefpelanggan"	=>	$IDPelanggan,
				"streamid"	=>	$Stream,
				"typeoftrans"	=>	$Jenistransaksi,
				"snmeter"	=>	$SNmeter,
				"snevc"	=>	$SNEVC,
				"snamr"	=> $SNAMR,
				"std_lalu_meter"	=>	$Standawalmeter,
				"std_kini_meter"	=>	$Standakhirmeter,
				"mtr_volume"	=>	$Selisihvolumemeter,
				"std_uncorrected_lalu"	=>	$Standawaluncorrectedmeter,
				"std_uncorrected_kini"	=>	$Standakhiruncorrectedmeter,
				"std_uncorrected_volume"	=>	$Selisihvolumeuncorrected,
				"std_corrected_lalu"	=>	$Standawalcorrectedmeter,
				"std_corrected_kini"	=>	$Standakhircorrectedmeter,
				"std_corrected_volume"	=>	$Selisihvolumecorrected,
				"psig"	=>	$PressureGauge,
				"tmpg"	=>	$TemperatureGauge,
				"psievc"	=>	$PressureEVC,
				"tmpevc"	=>	$TemperatureEVC,
				"co2"	=>	$CO2,
				"n2"	=>	$N2,
				"sg"	=>	$SG,
				"cf"	=>	$FaktorKoreksi,
				"corrected_volume_mtr"	=>	$VolumeCorrectedManual,
				"corrected_volume_evc"	=>	$VolumeCorrected,
				"keterangan"	=>	$Keterangan,
				"banumber"	=>	$BA,
				"inputdate"	=>	$Tanggalinput,
				"sentdate"	=>	$Sentdate,
				"sentby"	=>	$Sentoleh,
				"dw1"	=>	$Warning1DW1,
				"dw2"	=>	$Warning2DW2,
				"dw3"	=>	$Warning3DW3,
				"dw4"	=>	$Warning4DW4,
				"dw5"	=>	$Warning5DW5,
				"dw6"	=>	$Warning6DW6,
				"dw7"	=>	$Warning7DW7,
				"dw8"	=>	$Warning8DW5,
				"dw9"	=>	$Warning9DW9,
				"dw10"	=>	$Warning10DW10,
				"dw11"	=>	$Warning11DW11,
				"dw12"	=>	$Warning12DW12,
				"db1"	=>	$Bad1DB1,
				"db2"	=>	$Bad2DB2,
				"db3"	=>	$Bad3DB3,
				"db4"	=>	$Bad4DB4,
				"db5"	=>	$Bad5DB5,
				"final_status"	=>	$FinalStatus,
			);
			
			$filter[0]['field'] = "periodecatat";
			$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> $Periodecatat);
			
			$filter[1]['field'] = "tanggalcatat";
			$filter[1]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> $Tanggalcatat);	
								   
			$filter[2]['field'] = "idrefpelanggan";
			$filter[2]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $IDPelanggan);	

			$filter[3]['field'] = "streamid";
			$filter[3]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $Stream);

			$dataas = $ci->b_model->insert_update_data('valdy_avr',$data_input , 'All', '0', '');	
		}
		
		$this->nusoap_server->service(file_get_contents("php://input"));
 
	}
	public function areaclient()
	{
		$wsdl = base_url().'/index.php/integrasi?wsdl';
        $this->load->library("nusoap"); //load the library here
 
        $client = new nusoap_client($wsdl, 'wsdl');
		
		$params = array('period_month'	=> '2017-06-01',
						'kd_area'		=> '011',
						'paging'		=> '1,2');
		$res1 = $client->call('getpelanggan', $params);
		$err = $client->getError();
		
		echo "<pre>";
			var_dump($res1);
		echo "</pre>";
	}
	public function tet()
	{
		echo "ok";
	}
	
	
}
<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Main extends CI_Controller {
	function __construct()
       {
            parent::__construct();
			$this->output->set_header("HTTP/1.0 200 OK");
			$this->output->set_header("Access-Control-Allow-Origin: *");
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
		
		$id = $this->input->post('id');
		
		//$id = 53;
		
		$filter[0]['field'] = "idmenu";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> $id);
		
		$limit = 25;
		$offset = 0;
			
		$data = $this->b_model->get_all_data('menu', $filter , $limit, $offset, '');
		$js = $data[0]->path;
		
		
		if(empty($js) == false)
		{
			if(file_exists(FCPATH.$js) == true)
			{
				$result = file_get_contents(FCPATH.$js);
				echo stripslashes(trim($result)); 
			}
			
		}
	}
	public function save()
	{
		$data = json_decode($this->input->post('data'));
		
		$table = $this->input->post('tbl');
		
		$this->b_model->insert_data($table, (array) $data);
	}
	public function saveitemsreceipt()
	{
		$data = json_decode($this->input->post('data'));
		$table = $this->input->post('tbl');
		
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
	public function saveprogram()
	{
		$data = json_decode($this->input->post('data'));
		
		$data->satker	= json_encode($data->satker);
		
		$table = 'ms_program';
		$this->b_model->insert_data($table, (array) $data);
	}
	public function update()
	{
			$data = json_decode($this->input->post('data'));
			$table = $this->input->post('tbl');
			$filteras[0]['field'] = "rowid";
			$filteras[0]['data']  = array("comparison"		=> "eq",
									"type"					=> "string",
									"value"					=> $data->rowid);
			 
			$this->b_model->update_data($table, $filteras, (array) $data);
	}
	public function delete_data()
	{
		$data = json_decode($this->input->post('data'));
		$filteras[0]['field'] = "rowid";
		$filteras[0]['data']  = array("comparison"		=> "eq",
									"type"					=> "string",
									"value"					=> $data->rowid);
		$table = $this->input->post('tbl');						   
		$this->b_model->delete_data($table, $filteras);
	}
	
	public function savepencatatan()
	{	
		//$postdata = file_get_contents("php://input");
		//$request = json_decode($postdata);
		
		$data_forms = json_decode($this->input->post('data'));
		
		$filter[0]['field'] = "refffarms";
		$filter[0]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $data_forms->refffarms);
								   
		$filter[1]['field'] = "type_items";
		$filter[1]['data'] = array("comparison"	=> "eq",
								   "type"		=> "numeric",
								   "value"		=> 1);
								   
		$filter[2]['field'] = "reffkandang";
		$filter[2]['data'] = array("comparison"	=> "eq",
								   "type"		=> "string",
								   "value"		=> $data_forms->reffkandang);
								   
		$count = $this->b_model->count_all_data('trans_pengembangan', $filter);
		
		if($count == 0 and $data_forms->refffarms != '')
		{	
			
			$data->total_stock = $data->qty;
			$data = array("refffarms"	=> $data_forms->refffarms,
						  "reffkandang"	=> $data_forms->reffkandang,
						  "jumlah"		=> $data_forms->jumlah,
						  "sisa"		=> $data_forms->sisa,
						  "type_items"	=> 1);			  
			$this->b_model->insert_data('trans_pengembangan', $data);
			
			$dp  = $this->b_model->get_all_data('trans_pengembangan', $filter , 1, 0, '');	
			$total_stockold = 0 ;
			
			IF( $data_forms->status_transaksi  == 'MD33')
			{
				$total_stock = $total_stockold + $data_forms->jumlah;
				
			}
			if($data_forms->status_transaksi == 'MD34')
			{
				$total_stock = $total_stockold - $data_forms->jumlah;
			}
			
			$data_insert = array(
						 "refffarms"	=> $data_forms->refffarms,
						  "reffkandang"	=> $data_forms->reffkandang,
						  "jumlah"		=> $data_forms->jumlah,
						  "sisa"		=> $total_stock,
						  "type_items"	=> 2,
						  "status_transaksi"	=> $data_forms->status_transaksi,
						  "status_elemen"		=> $data_forms->status_elemen,
						  "reffpenjualan"		=> $data_forms->reffpenjualan,
						  "total_berat"		=> $data_forms->total_berat
						  );		
			$this->b_model->insert_data('trans_pengembangan', $data_insert);
			$data_update = array("sisa"	=> $total_stock,
								"update_date"	=> 'now()');
			$filter[0]['field'] = "refffarms";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=> $data_forms->refffarms);
									   
			$filter[1]['field'] = "type_items";
			$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> 1);					
			$this->b_model->update_data('trans_pengembangan', $filter ,$data_update);
			var_dump ($data_update);
		}else if($count > 0 and  $data_forms->refffarms != '')
		{
			
			$dp  = $this->b_model->get_all_data('trans_pengembangan', $filter , 1, 0, '');	
			$total_stockold = $dp[0]->sisa;
			
			if( $data_forms->status_transaksi == 'MD33')
			{
				$total_stock = $total_stockold + $data_forms->jumlah;
				
			}
			if($data_forms->status_transaksi == 'MD34')
			{
				$total_stock = $total_stockold - $data_forms->jumlah;
			}
			
			$data_insert = array("refffarms"	=> $data_forms->refffarms,
						  "reffkandang"	=> $data_forms->reffkandang,
						  "jumlah"		=> $data_forms->jumlah,
						  "sisa"		=> $total_stock,
						  "type_items"	=> 2,
						  "status_transaksi"	=> $data_forms->status_transaksi,
						  "status_elemen"		=>$data_forms->status_elemen,
						  "reffpenjualan"		=> $data_forms->reffpenjualan,
						  "total_berat"		=> $data_forms->total_berat
						  );		 
			
			$this->b_model->insert_data('trans_pengembangan', $data_insert);
			
			$data_update = array("sisa"	=> $total_stock,
								"update_date"	=> 'now()');
								
			$filter[0]['field'] = "refffarms";
			$filter[0]['data'] = array("comparison"	=> "eq",
									   "type"		=> "string",
									   "value"		=>$data_forms->refffarms);
									   
			$filter[1]['field'] = "type_items";
			$filter[1]['data'] = array("comparison"	=> "eq",
									   "type"		=> "numeric",
									   "value"		=> 1);					
			$this->b_model->update_data('trans_pengembangan', $filter ,$data_update);
			 echo "siisinix";
		}
	}
}
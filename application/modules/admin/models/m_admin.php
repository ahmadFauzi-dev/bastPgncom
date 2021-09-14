<?php
Class M_admin extends CI_Model
{
	function __construct()
	{
		$this->db	= $this->load->database('default',TRUE);
		parent::__construct();
	}
	
	//Base Action
	//-----------------------------------------------------------	public function checkpassword($user_id,$pass)	{				$array_where = array (						'user_id' => $user_id,						'password' => $pass		);				$this->db->where($array_where);		$hasil_query = $this->db->get('rev_user');				$hasil = $hasil_query->result();		if ($hasil[0]->user_id == null){			$value = false;		}		else{			$value = true;		}				$data	= array("user_id" => $hasil[0]->user_id);		return $data;	}	
	public function add_entry($data,$tb)
	{
		//add data
		$this->db->insert($tb,$data);
		$json   = array(
				'success'   => TRUE,
				'message'   => "Loaded data",
				'data'      => $data
				
		);
		//echo json_encode($json);
	}
	
	public function add_entry_nodin($data,$tb)
	{
		//add data
		$this->db->insert($tb,$data);
		$json   = array(
				'data'   => $data,
				'no_usulan' => $data['no_usulan']
		);
		echo json_encode($data);
	}
	
	public function update_entry($data,$id,$tb,$wr)
	{
		//update data
		$this->db->where($wr,$id);
		$this->db->update($tb,$data);
		/* $json   = array(
				'success'   => TRUE,
				'message'   => "Loaded data",
				'data'      => $data
		);
		echo json_encode($json); */
	}
	
	public function delete_entry($id,$tb,$wr)
	{
	    //delete data
		$this->db->where($wr,$id);
		$this->db->delete($tb); 
		$json   = array(
				'success'   => TRUE,
				'message'   => "Loaded data",
				'data'      => $data
		);
		//echo json_encode($json);
	}
	
	public function list_parent($id,$tb)
	{
		$this->db->where("id_parent", $id); 
		$hasil	= $this->db->count_all($tb);
		$data	= array("id_parent"	=> $hasil[0]->id_parent);
		return $data;
	}
	
	//menu
	//------------------------------------------------------------------------------
	
	public function showMenu($node,$username,$groupid)
	{
		
		//var_dump($node);
		$this->db->order_by('sort','asc');
		$this->db->where('parent',$node);
		$hasil_query = $this->db->get('menu');
		$n = 0;
		
		//$data = new stdClass();;
		foreach ($hasil_query->result() as $row) {
				$data[$n] = new stdClass();
				$data[$n]->id = $row->idmenu;
				$data[$n]->text	= $row->name;
				$data[$n]->act	= $row->act;
				$data[$n]->iconCls = $row->iconcls;
				$data[$n]->parent = $row->parent;
				
				if ($row->parent == 0)//root menu
				{
					
					switch($row->idmenu){
					default:
						$data[$n]->leaf = false;//default root menu
					break;
					
					case '5':
						$data[$n]->leaf = true;//logout
					break;
					
					
					}
					//$data[$n]->expanded = true;
					
				}else//parent menu
				{
					$data[$n]->leaf = true;
					//$data[$n]->expanded = false;
				}
			$n++;
		}
		$json   = array(
					'success'   => TRUE,
					'message'   => "Loaded data",
					'data'      => $data
		);
		echo json_encode($json);
	}
	public function showmenutree($node,$username,$idMenu)
	{
		$this->db->order_by('sort','asc');
		
		if($node == 0)
		{
			$this->db->where('parent',$idMenu);
		}else
		{
			$this->db->where('parent',$node);
		}
		$groupid = $this->session->userdata('id_group');
		$this->db->where('group_id',$groupid);
		
		
		$hasil_query = $this->db->get('v_menu');
		$n = 0;
		
		//$data = new stdClass();;
		foreach ($hasil_query->result() as $row) {
				$data[$n] = new stdClass();
				$data[$n]->id = $row->idmenu;
				$data[$n]->text	= $row->name;
				$data[$n]->act	= $row->act;
				$data[$n]->iconCls = $row->iconcls;
				$data[$n]->path = $row->path;
				$data[$n]->parent = $row->parent;
				
				$filteras[0]['field'] = "parent";
				$filteras[0]['data']  = array("comparison"		=> "eq",
										"type"				=> "numeric",
										"value"				=> intval($row->idmenu));
									 
				$count		 = $this->b_model->count_all_data('v_menu', $filteras);
				if($count > 0 )
				{
					
					$data[$n]->leaf = false;
					//$data[$n]->expanded = true;
					//$data[$n]->children = $this->getchild('v_sbuarea',$filteras);
				}else
				{
					$data[$n]->leaf = true;
					//$data[$n]->expanded = true;
				}
				
				
			$n++;
		}
		$json   = array(
					'success'   => TRUE,
					'message'   => "Loaded data",
					'data'      => $data
		);
		echo json_encode($json);
	}
	
	public function listGridDaily()
	{
		$query = "SELECT *,(tahun || '-' || bulan || '-' || tanggal) as tanggalPengukuran,mstation.stationname,error   
		from tbl_penyalurandaily 
		JOIN mstation on mstation.reffidstation = tbl_penyalurandaily.tbl_station_id
		WHERE tahun = 2015 and bulan = 12 
		ORDER BY (tbl_station_id || '' || tahun || '' || bulan || '' || tanggal) ASC";
		$hasil_query	= $this->db->query($query);
		$stat = "";
		$n = 0;
		foreach ($hasil_query->result() as $row) {
			$data[] = $row;
			
			$data[$n]->stat = alternator('success', 'warnig','error');
			$stat = unserialize($row->error);
			//$statfin = ($stat['115113'] + $stat['115112']) / 2;
			$statfin = ($stat['115113']);
			
			if($statfin < 1)
			{
				$error = 0;
			}else
			{
				$error	= 1;
			}
			$data[$n]->error = $error;
			$n++;
		}
		
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			'total'     => 10,
			'data'      => $data
		);
		echo json_encode($json);
	}
	public function listGridHourly()
	{
		$randomFloat = rand(100, 400) / 10;
		$query = "SELECT tbl_realisasipenyaluranstations.*,tbl_station.nama_station 
				from tbl_realisasipenyaluranstations
				join tbl_station ON tbl_realisasipenyaluranstations.tbl_station_id = tbl_station.id		
				WHERE tgl_pengukuran = '2015-12-11' and tbl_station_id = 24
				ORDER BY tgl_pengukuran DESC";
		$hasil_query	= $this->db->query($query);
		$stat = "";
		$n = 0;		
		foreach ($hasil_query->result() as $row) {
			$data[] = $row;
			$data[$n]->stat = alternator('error');
			$data[$n]->pcv = rand(100, 400) / 10;
			$data[$n]->parameter_periode = 'hourly';
			$n++;
		}
		
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			'total'     => 10,
			'data'      => $data
		);
		echo json_encode($json);
	}
	public function listGridHourlycek($sts,$tgl)
	{
		$randomFloat = rand(100, 400) / 10;
		$query = "SELECT * from v_penyaluranstationhourly 
				  WHERE tanggal_pengukuran BETWEEN '".$tgl." 00:00:00' and '".$tgl." 23:59:59' 
				  and stationid = ".$sts."";
				  
		/*
		$query = "SELECT tbl_realisasipenyaluranstations.*,tbl_station.nama_station 
				from tbl_realisasipenyaluranstations
				join tbl_station ON tbl_realisasipenyaluranstations.tbl_station_id = tbl_station.id		
				WHERE tgl_pengukuran = '2015-12-11' and tbl_station_id = 24
				ORDER BY tgl_pengukuran DESC";
		*/
		$hasil_query	= $this->db->query($query);
		$stat = "";
		$n = 0;		
		foreach ($hasil_query->result() as $row) {
			$data[] = $row;
			$data[$n]->stat = alternator('error');
			$data[$n]->pcv = rand(100, 400) / 10;
			$data[$n]->parameter_periode = 'hourly';
			$n++;
		}
		
		return $data;
		//echo json_encode($json);
	}
	public function listGridDailycek($station,$tgl)
	{
		//$tgl_before = intval($tgl) - 1;
		$tgl_before = date('Y-m-d',strtotime($tgl . "-1 days"));
		//echo $tgl_before;
		/*
		$query = "SELECT *,(tahun || '-' || bulan || '-' || tanggal) as tanggalPengukuran,mstation.stationname,error,warning   
		from tbl_penyalurandaily 
		JOIN mstation on mstation.reffidstation = tbl_penyalurandaily.tbl_station_id
		WHERE tahun = 2015 and bulan = 12 and tbl_station_id = ".$station." and tanggal between ".$tgl_before." and ".$tgl."  
		ORDER BY (tbl_station_id || '' || tahun || '' || bulan || '' || tanggal) ASC";
		*/
		//echo $query;
		
		$query = "SELECT * from v_cekpenyaluranstationdaily 
				  WHERE tanggal_pengukuran = '".$tgl."'
				  and stationid = ".$station." ORDER BY tanggal_pengukuran asc";
				  
		$hasil_query	= $this->db->query($query);
		$stat = "";
		$n = 0;
		foreach ($hasil_query->result() as $row) {
			$data[] = $row;
			$data[$n]->stat = alternator('success', 'warnig','error');
			$n++;
		}
		
		return $data;
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			'total'     => 10,
			'data'      => $data
		);
		//echo json_encode($json);
	}
	public function cekdup($sts,$tgl){
		$tgl_before = date('Y-m-d',strtotime($tgl . "-1 days"));
		
		$query = "SELECT * from v_penyaluranstationdaily 
				  WHERE tanggal_pengukuran = '".$tgl_before."'
				  and stationid = ".$sts." ORDER BY tanggal_pengukuran asc";
		
		$hasil_query	= $this->db->query($query);			
		foreach ($hasil_query->result() as $row) {
			$data[] = $row;
		}
		return $data;
	}
	public function cekduphourly($sts,$tgl)
	{
		$query = "SELECT * from v_penyaluranstationhourly 
				  WHERE tanggal_pengukuran = to_timestamp('".$tgl."','YYYY-MM-DD HH24:MI:SS') - INTERVAL '1 hour' 
				  and stationid = ".$sts." ORDER BY tanggal_pengukuran asc";
		
		$hasil_query	= $this->db->query($query);			
		foreach ($hasil_query->result() as $row) {
			$data[] = $row;
		}
		return $data;
	}
	public function ceksum($sts,$tgl)
	{
		$query = "SELECT stationid,
					sum(mmscfd) as mmscfd,SUM(totalizer_mmbtu) as totalizer_mmbtu
					,sum(totalizer_mscf) as totalizer_mscf
					,sum(totalizer_energy) as totalizer_energy
					,sum(totalizer_volume) as totalizer_volume
					,sum(pressureinlet) as pressureinlet
					,sum(pressureoutlet) as pressureoutlet,
					sum(prevdayghv) as prevdayghv
					from v_penyaluranstationhourly 
					WHERE stationid = ".$sts." and tanggal_pengukuran = '".$tgl."'
					GROUP BY stationid";
		$hasil_query	= $this->db->query($query);			
		foreach ($hasil_query->result() as $row) {
			$data[] = $row;
		}
		return $data;
	}
	function array2json($arr) {
		$parts = array();
		$is_list = false;
	
		$keys = array_keys($arr);
		$max_length = count($arr)-1;
		if(($keys[0] == 0) and ($keys[$max_length] == $max_length)) {
			$is_list = true;
			for($i=0; $i<count($keys); $i++) {
				if($i != $keys[$i]) {
					$is_list = false;
					break;
				}
			}
		}
	
		foreach($arr as $key=>$value) {
			if(is_array($value)) {
				if($is_list) $parts[] = $this->array2json($value);
				else $parts[] = '"' . $key . '":' . $this->array2json($value);
			} else {
				$str = '';
				if(!$is_list) $str = '"' . $key . '":';
				if(is_numeric($value)) $str .= $value;
				elseif($value === false) $str .= 'false';
				elseif($value === true) $str .= 'true';
				else $str .= '"' . addslashes($value) . '"';
				$parts[] = $str;
			}
		}
		$json = implode(',',$parts);
	
		if($is_list) return '[' . $json . ']';
		return '{' . $json . '}';
	}
	public function listChartDaily()
	{
		$query = "SELECT volume
				  ,energy
				  ,(tahun || '-' || bulan || '-' || tanggal) as tanggals
				  from tbl_penyalurandaily 
				  WHERE tbl_station_id = 24 and tahun = 2015 and bulan = 11 ORDER BY tanggal ASC";
		$hasil_query	= $this->db->query($query);
		$n = 0;
		$min = 5;
		$max = 15;
		foreach ($hasil_query->result() as $row) {
			$data[] = $row;
			$data[$n]->volume = floatval($row->volume);
			$data[$n]->energy = floatval($row->energy);
			$data[$n]->min = $min;
			$data[$n]->max = $max;
			$data[$n]->tanggal = $row->tanggal;
			$n++;
		}
		
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			'total'     => 10,
			'data'      => $data
		);
		echo json_encode($json);
	}
	public function insertEstimate($data)
	{
		$this->db->insert('estimatebulk',$data);
	}
	public function genGrid($querygrid)
	{
		
		$hasil_query	= $this->db->query($querygrid);
		foreach($hasil_query->list_fields() as $field)
		{
			$data[] = $field;
		}
		return $data;
		//echo json_encode($data);
	}
	public function listRows($query)
	{
		$hasil_query	= $this->db->query($query);
		foreach ($hasil_query->result() as $row) {
			$data[] = $row;
		}
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			'total'     => 10,
			'data'      => $data
		);
		echo json_encode($json);
	}
	public function storeestimasirend()
	{
		$query = "SELECT * 
					from tbl_parametervaluehist
					WHERE tgl_pengukuran = '2015-12-11'
					and tbl_station_id = 24 ORDER BY jam_pengukuran DESC";
		$hasil_query	= $this->db->query($query);
		foreach ($hasil_query->result() as $row) {
			$data[] = $row;
		}
		$json   = array(
			'success'   => TRUE,
			'message'   => "Loaded data",
			'total'     => 10,
			'data'      => $data
		);
		echo json_encode($json);
	}
	public function inserttb($tb,$data)
	{
		$this->db->insert($tb,$data);
	}
	public function listrolems()
	{
		$query = "SELECT * from ms_liberrorcode where typeofrole = 'station'";
		$hasil_query = $this->db->query($query); 
		return $hasil_query->result();
	}
	public function showdetailrole($id)
	{
		$query = "SELECT formula 
					from dt_msliberrcode WHERE id_ms_liberrorcode = '".$id."'";
		$hasil_query = $this->db->query($query); 
		return $hasil_query->result();
	}
	public function cekDataHourly()
	{
		$randomFloat = rand(100, 400) / 10;
		$query = "SELECT tbl_realisasipenyaluranstations.*,tbl_station.nama_station 
				from tbl_realisasipenyaluranstations
				join tbl_station ON tbl_realisasipenyaluranstations.tbl_station_id = tbl_station.id		
				WHERE tgl_pengukuran = '2015-12-11' and tbl_station_id = 24
				ORDER BY tgl_pengukuran DESC";
		$hasil_query	= $this->db->query($query);
		$stat = "";
		$n = 0;		
		foreach ($hasil_query->result() as $row) {
			$data[] = $row;
			$data[$n]->stat = alternator('error');
			$data[$n]->pcv = rand(100, 400) / 10;
			$data[$n]->parameter_periode = 'hourly';
			$n++;
		}
		
		return $data;
	}
	public function submitconfig($table,$data)
	{
		
	}
	public function updatemappcol()
	{
		
	}
	public function checkstation()
	{
		$query = "SELECT reffidstation 
				  from v_msattionbulk";
		$hasil_query	= $this->db->query($query);
		
		foreach ($hasil_query->result() as $row) {
			$data[] = $row;
		}
		
		return $data;
		
	}
}


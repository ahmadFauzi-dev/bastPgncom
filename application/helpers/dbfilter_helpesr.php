<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

	function whereTofilter ($field, $value, $type, $comparison){
		
		$filter = 
		array(
			'field' => $field,
			'data' => array (
				'value' => $value,
				'type' => $type,
				'comparison' => $comparison
			)
		);   
		return $filter ;
		
	}

    function dateTonum($date){
		//$contoh = "2016/01/01 00:11:22";
        $tahun = substr($date, 0, 4);
        $bulan = substr($date, 5, 2);
        $tgl   = substr($date, 8, 2);
        $jam   = substr($date, 11, 2);
        $menit = substr($date, 14, 2);
        $detik = substr($date, 17, 2);   
        $result = $tahun . $bulan . $tgl . $jam . $menit . $detik;      
        //return $result;
        return !empty($result) ? $result : '';
    }

    function numTodate($num)
    {
        $tahun = substr($num, 0, 4);
        $bulan = substr($num, 4, 2);
        $tgl   = substr($num, 6, 2);
        $jam   = substr($num, 8, 2);
        $menit = substr($num, 10, 2);
        $detik = substr($num, 12, 2);
        $dass = date("Y/m/d H:i:s", mktime($jam, $menit, $detik, $bulan, $tgl, $tahun));
        // v::dump(date("Y/m/d H:i:s", $dass));
        // $dass = date( "Y/m/d H:i:s", $num );
        return $dass;
    }   

	function generate_filter($filter = array()) {
		$clause = array();
		foreach($filter as $where) {
			//if(is_null($where['field']) == false and ()is_null($where['data']['value']) == false ) {				
			//if(is_null($where['field']) == false and (!empty($where['data']['value']) == TRUE OR $where['data']['value'] == 0) ) {				
			
			if( !empty($where['field']) and $where['data']['value'] != '' ) {				
				//IF( $where['data']['value'] == 0)
				
				
				if($where['data']['type'] == 'string') {
					switch ($where['data']['comparison'])
					{
						case 'eq' : $clause[] = $where['field'] . " = " . "'" . $where['data']['value'] . "'"; Break;
						default :
						$clause[] = $where['field'] . " LIKE " . "'%" . $where['data']['value'] . "%'" ;
					}
					
				}
				
				if($where['data']['type'] == 'numeric') {
					switch ($where['data']['comparison']) {
					case 'eq' : $clause[] = $where['field'] . " = " . "'" . $where['data']['value'] . "'"; Break;
					case 'noteq' : $clause[] = $where['field'] . " <> " . "'" . $where['data']['value'] . "'"; Break;
<<<<<<< .mine
					case 'lt' : $clause[] = $where['field'] . " <= " . "'" . intval($where['data']['value']) . "'"; Break;
				    case 'gt' : $clause[] = $where['field'] . " >= " . "'" . intval($where['data']['value']) . "'"; Break;
||||||| .r94
					case 'lt' : $clause[] = $where['field'] . " < " . "'" . intval($where['data']['value']) . "'"; Break;
				    case 'gt' : $clause[] = $where['field'] . " > " . "'" . intval($where['data']['value']) . "'"; Break;
=======
					case 'lt' : $clause[] = $where['field'] . " < " . "'" . intval($where['data']['value']) . "'"; Break;
				    case 'gt' : $clause[] = $where['field'] . " >= " . "'" . $where['data']['value'] . "'"; Break;
>>>>>>> .r97
				}                
				}				
				if($where['data']['type'] == 'list') {
					if (strstr($where['data']['value'],',')){
						$fi = explode(',',$where['data']['value']);
						for ($q=0;$q<count($fi);$q++){
							$fi[$q] = "'".$fi[$q]."'";
						}
						$where['data']['value'] = implode(',',$fi);
						$clause[] = $where['field']." IN (".$where['data']['value'].")"; 
					}else{
						$clause[] = $where['field']." LIKE '".$where['data']['value']."%'"; 
					}
				}				
				if($where['data']['type'] == 'date') {
					switch ($where['data']['comparison']) {
						case 'eq' : $clause[] = $where['field'] . " = " . "'" . date('Y-m-d',strtotime($where['data']['value'])) . "'"; Break;
						case 'lt' : $clause[] = $where['field'] . " <= " . "'" . date('Y-m-d',strtotime($where['data']['value'])) . "'"; Break;
						case 'gt' : $clause[] = $where['field'] . " >= " . "'" . date('Y-m-d',strtotime($where['data']['value'])) . "'"; Break;
					}                
				}
				if($where['data']['type'] == 'boolean') {
					switch ($where['data']['value']) {
						case 'null' : 
						case 'NULL' : 
							$clause[] = $where['field'] . " IS NULL";
						break;
						case 'not null' : 
						case 'NOT NULL' : 
						$clause[] = $where['field'] . " IS NOT NULL";
						break;
						default :
						$clause[] = $where['field'] . " = " . "'" . $where['data']['value'] . "'";
					}					
				}
			}
		}
		$CI =& get_instance();
		//$po = implode(" AND ", $clause);
		//echo $po;
		return !empty($clause) ? $CI->db->where(implode(" AND ", $clause)) : ''
		//var_dump($clause);
		/* $CI->db->where($filter) */;
		// return !empty($clause) ? implode(" AND ", $clause) : '';
	}
	
	/* function generate_filteralex($filter = array()) {
		$clause = array();
		$n=0;
		//$as[];
		
		foreach($filter as $where) {
			
			
			if($where['field'] > '' && $where['data']['value'] > '') {
				if($where['data']['type'] == 'boolean') {
					$clause[$n] = array("field"	=> $where['field']." = ",
										"value"	=> $where['data']['value']);
				}
				if($where['data']['type'] == 'string') {
					$clause[$n] = array("field"	=> $where['field']." LIKE ",
										"value"	=> $where['data']['value']); 
				}				
				if($where['data']['type'] == 'numeric') {
					switch ($where['data']['comparison']) {
						case 'eq' : $clause[$n] = array("field"	=> $where['field']." = ",
														"value"	=> $where['data']['value']); 
						Break;
						case 'lt' :
							$clause[$n] = array("field"	=> $where['field']." < ",
											   "value"	=> $where['data']['value']); 
						break;
						case "gt" :
							$clause[$n] = array("field"	=> $where['field']." > ",
											   "value"	=> $where['data']['value']);
						break;
					}	
				}				
				if($where['data']['type'] == 'list') {
					if (strstr($where['data']['value'],',')){
						$fi = explode(',',$where['data']['value']);
						for ($q=0;$q<count($fi);$q++){
							$fi[$q] = "'".$fi[$q]."'";
						}
						$where['data']['value'] = implode(',',$fi);
						$clause[] = $where['field']." IN (".$where['data']['value'].")"; 
					}else{
						$clause[] = $where['field']." LIKE '".$where['data']['value']."%'"; 
					}
				}
				if($where['data']['type'] == 'date') {
					switch ($where['data']['comparison']) {
						case 'eq' : $clause[$n] = array("field" => $where['field']."",
													   "value"	=> $where['data']['value']); 
						Break;
						case 'lt' : $clause[$n] = array("field" => $where['field']." < ",
													   "value"	=> $where['data']['value']); 
						Break;
						case 'gt' : $clause[$n] = array("field" => $where['field']." > ",
													   "value"	=> $where['data']['value']); 
						Break;
					}                
				}				
				
			}
			//$where[$n] = $where;
			
			
			//$as[$n] = $where;
			$n++;
		}
		
		return $clause;
		
	} */
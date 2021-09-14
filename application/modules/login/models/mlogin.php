<?php 
Class Mlogin extends CI_Model
{
	function __construct()
	{
		$this->db	= $this->load->database('default',TRUE);
		parent::__construct();
	}
	public function ceklogin($username,$pass)	{
		$query1 = "select * from v_checklogin WHERE							LOWER(username) = '".$username."'						AND PASSWORD = '".$pass."'						AND active = 'Y'"; 		$query2 = "select * from v_checklogin WHERE							LOWER(username) = '".$username."'						AND active = 'Y'";								
		$hasil_query	= $this->db->query($query1);
		$hasil = $hasil_query->result();
		$data	= array(
					"user_id"	 	 => $hasil[0]->user_id,
					"username"		 => $hasil[0]->username,
					"nama" 		 	 => $hasil[0]->nama,
					"group_id"		 => $hasil[0]->group_id,
					"user_email"	 => $hasil[0]->email,					"reffjabatan"	 => $hasil[0]->reffjabatan,					"namajabatan"	 => $hasil[0]->namajabatan,					"divisi_id"	 => $hasil[0]->divisi_id,					"nama_divisi"	 => $hasil[0]->nama_divisi,					"id_perusahaan"	 => $hasil[0]->id_perusahaan,					"nama_perusahaan"	 => $hasil[0]->nama_perusahaan
		);
		return $data;		
	}
	
	public function ceklogin_ldap($username,$pass)
	{
		$domain = 'corp\\';
		$usr = $username;
		$pwd = $pass;
		//echo substr($usr,0,5);
		if (substr($usr,0,5) == $domain ){
			$usr = strtolower($usr);    
		}else{  
			$usr = strtolower($domain.$usr);
		}    
		if (!function_exists("ldap_connect")) // cek apakah function ldap_connect terdeteksi dari web server
			die("LDAP belum terinstal atau diaktifkan."); // jika tidak, tampilkan pesan dan langsung exit

		$ldapconn = ldap_connect("corp.pgn.co.id", 389) or die("Tidak terhubung ke server LDAP."); // jangan lupa untuk menyesuaikan nama host dan port server LDAP-nya

		if ($ldapconn && ldap_bind($ldapconn, $usr, $pwd)) { // jika koneksi ke LDAP valid  
			//$this->setCurrentUserName($usr); // set nama pengguna dari parameter username
			
			//return TRUE; // pastikan TRUE supaya validasi standar tidak dilakukan lagi
		 
			$query = "SELECT * FROM rev_user
						JOIN group_permission on group_permission.group_id = rev_user.groupid	
							WHERE
								lower ( rev_user.usernameldap ) = '".strtolower($username)."' 
							AND active = 'Y'";
							// AND rev_user. PASSWORD = '".$pass."'";
			
			$hasil_query	= $this->db->query($query);
			$hasil = $hasil_query->result();
			
				$data	= array(
					"user_id"	 	 => $hasil[0]->user_id,
					"username"		 => $hasil[0]->username,
					"nama" 		 	 => $hasil[0]->nama,
					"rd"			 => $hasil[0]->canrd,
					"area"			 => $hasil[0]->canarea,
					"groupid"		 => $hasil[0]->group_id,
					"user_email"	 => $hasil[0]->email,
					"group_email"	 => $hasil[0]->koordinatoruser
					
				);		
		} else {
			$query = "SELECT * FROM rev_user
				JOIN group_permission on group_permission.group_id = rev_user.groupid	
					WHERE
				lower ( rev_user.username ) = '".strtolower($username)."'
				AND rev_user.PASSWORD = '".$pass."'
				AND active = 'Y'";
			
			$hasil_query	= $this->db->query($query);
			$hasil = $hasil_query->result();			
				$data	= array(
					"user_id"	 	 => $hasil[0]->user_id,
					"username"		 => $hasil[0]->username,
					"nama" 		 	 => $hasil[0]->nama,
					"rd"			 => $hasil[0]->canrd,
					"area"			 => $hasil[0]->canarea,
					"groupid"		 => $hasil[0]->group_id,
					"user_email"	 => $hasil[0]->email,
					"group_email"	 => $hasil[0]->koordinatoruser
					
				);	
		}
		return $data;
	}
}
?>
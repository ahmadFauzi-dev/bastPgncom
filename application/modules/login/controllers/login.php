<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Login extends CI_Controller {

	public function index()
	{
		//echo "OKOK";
		$this->load->view('login');	
	}
	public function ass()
	{
	    echo "OJOJOJOJ";
	}
	public function lupa_pass()
	{
		$this->load->view('lupa_pass');	
	}
	public function change_pass()
	{
		$this->load->view('change_pass');
	}
	public function ceklogin()
	{
		
		$username = strtolower($this->input->post('username')); //$_POST['username'];
		$pass	  = sha1(sha1(md5($this->input->post('pass'))));		//$_POST['pass'];
		
		$this->load->model('mlogin');
		$cekdata = $this->mlogin->ceklogin($username, $pass);
		//$cekdata = $this->mlogin->ceklogin_ldap($username, $pass);
		
		if($cekdata['username'] == "" or $cekdata['username'] == null)
		{
			echo "fail";
		} else
		{						
			$data = array(
				'user_id'				=> $cekdata['user_id'],
				'username'			=> $cekdata['username'],
				'nama'					=> $cekdata['nama'],
				"id_group"			=> $cekdata['group_id'],
				'access' 				=> true,
				"expire"				=> time()+(7200),
				"user_email"	 	=> $cekdata['user_email'],
				"reffjabatan"	 	=> $cekdata['reffjabatan'],
				"namajabatan"	=> $cekdata['namajabatan'],
				"divisi_id"	 			=> $cekdata['divisi_id'],
				"nama_divisi"	 	=> $cekdata['nama_divisi'],
				"id_perusahaan"	=> $cekdata['id_perusahaan'],
				"nama_perusahaan"	 => $cekdata['nama_perusahaan']
			);
			
			$cookie = array(
				'name' => 'SIMPEL_access',
				'value' => json_encode($data),				
				'expire' => time()+7200
			);			
			
			// set_cookie($cookie);
			$this->session->sess_expiration = 7200;
			// $this->session->set_userdata(array('access' => true));			
			$this->session->set_userdata($data);			
		}		
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */
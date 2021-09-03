<?php if( ! defined('BASEPATH')) exit('No direct script access allowed');

class MY_Controller extends CI_Controller{

	public function __construct(){
		parent::__construct();
				
		try{
			$user_check = $this->session->userdata('access');
			if($user_check){
					$this->session->set_userdata(array("access" => true));
			} else {
				$this->_denyUser();
			}
			
		} catch(Exception $e){
			$data['success'] = false;
			$data['code'] = $e->getCode();
			$data['message'] = $e->getMessage();
			extjs_output($data);
		}
		
	}
	
	private function _denyUser()
	{
		if(isset($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest'){
			throw new Exception('Session expired, you will be redirected.', 401);
		} else{
			redirect('login', 'refresh');
		}
	}
	
	public function send_email($to, $subject, $template, $file)
	{
		// $this->load->library('PHPMailerAutoload');
        $mail = new PHPMailer();		
		$mail->isSMTP();
		$mail->SMTPDebug  = 2;
		$mail->Headers = 'Content-type: text/html; charset=iso-8859-1';
		$mail->Host = 'mail.pgn.co.id';
        $mail->Port = '25'; 
        $mail->Port = 25;
		//$mail->SMTPAuth = false;
		$mail->SMTPSecure = false;
		
		$mail->SMTPAuth = true;
	    $mail->Username = 'corp\mng1';
        $mail->Password = 'corp.PGN';
        
		$mail->From = 'mng1@pgn.co.id';
		$mail->FromName = 'SPG-EM';
		$mail->SMTPSecure = "tls";
		$mail->WordWrap = 50; 
       
		//$mail->AddAddress('person1@domain.com', 'Person One');
		//$mail->AddAddress('person2@domain.com', 'Person Two');
		
		$mail->addAddress($to);
		$mail->Subject = $subject;
		$mail->Body 	= $template;
		$mail->IsHTML(true);		
		$mail->AddAttachment($file);
        $mail->send();
	}
	public function send_emailmultiaddress($to,$subject, $template, $file)
	{
		$mail = new PHPMailer();		
		$mail->isSMTP();
		$mail->SMTPDebug  = 2;
		$mail->Headers = 'Content-type: text/html; charset=iso-8859-1';
		$mail->Host = 'mail.pgn.co.id';
        $mail->Port = '25'; 
        $mail->Port = 25;
		//$mail->SMTPAuth = false;
		$mail->SMTPAuth = true;
		$mail->SMTPSecure = false;
		
		$mail->SMTPAuth = true;
	    $mail->Username = 'corp\mng1';
        $mail->Password = 'corp.PGN';
        
		$mail->From = 'mng1@pgn.co.id';
		$mail->FromName = 'SPG-EM';
		$mail->SMTPSecure = "tls";
		$mail->WordWrap = 50; 
       
		//$mail->AddAddress('person1@domain.com', 'Person One');
		//$mail->AddAddress('person2@domain.com', 'Person Two');
		
		foreach($to as $r)
		{
			
			if(!empty($r))
			{
				$mail->addAddress($r);
			}
			//$mail->addAddress($r);
		}
		$mail->Subject = $subject;
		$mail->Body 	= $template;
		$mail->IsHTML(true);		
		$mail->AddAttachment($file);
        $mail->send();
	}	
	
}
<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Example extends CI_Controller {

	public function index()
    {
    
	    //Load the library
		$this->load->library('html2pdf');
	    
	    //Set folder to save PDF to
	    $this->html2pdf->folder('./asset/pdfs/');
	    
	    //Set the filename to save/download as
		$filename = date('YmdHisu').'_'.'okke.pdf';
	    $this->html2pdf->filename($filename);
	    
	    //Set the paper defaults
	    $this->html2pdf->paper('a4', 'portrait');
		//$image = str_replace('<img src="','<img src="'.base_url().'/document',$img);
		$data = array(
	    	'title' => 'PDF Created',
	    	'message' => 'Hello World!',
			'image' => $img
	    );
		//$this->load->view('pdf', $data);
	    //Load html view
	   $this->html2pdf->html($this->load->view('pdf', $data, true));
	    
	    if($this->html2pdf->create('save')) {
	    	//PDF was successfully saved or downloaded
	    	echo 'PDF saved';
		}	
	    
		
    } 
    
	public function mail_pdf()
    {
		//Load the library
	    $this->load->library('html2pdf');
	    
	    $this->html2pdf->folder('./assets/pdfs/');
	    $this->html2pdf->filename('email_test.pdf');
	    $this->html2pdf->paper('a4', 'portrait');
	    
	    $data = array(
	    	'title' => 'PDF Created',
	    	'message' => 'Hello World!'
	    );
	    //Load html view
	    $this->html2pdf->html($this->load->view('simpel/pdf', $data, true));
	    
	    //Check that the PDF was created before we send it
	    if($path = $this->html2pdf->create('save')) {
	    	
			$this->load->library('email');

			$this->email->from('your@example.com', 'Your Name');
			$this->email->to('someone@example.com'); 
			
			$this->email->subject('Email PDF Test');
			$this->email->message('Testing the email a freshly created PDF');	

			$this->email->attach($path);

			$this->email->send();
			
			echo $this->email->print_debugger();
						
	    }
	    
    } 
}

/* End of file example.php */
/* Location: ./application/controllers/example.php */
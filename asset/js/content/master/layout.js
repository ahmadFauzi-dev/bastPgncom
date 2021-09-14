function apps(name, iconCls){
	var valuesimpan;
	Ext.define('Init', {
			valuesimpan
	});
	//var iconCls = 
	
	var msclass 			= Ext.create('master.global.geteventmenu'); 
	
	var v_table 						= "v_rekanan"; 
	var pgrid 							= msclass.getgrid(v_table,'idgrid_mstrekanan',[]);
	var pform 							= msclass.getformcreate(v_table,'idform_mstrekanan','',[]);
	var pformupdate				= msclass.getformupdate(v_table,'idform_mstrekanan','',[]);
	var get_toolbar 				= msclass.gettoolbar(pform,pformupdate,'idgrid_mstrekanan',v_table);
	var get_toolbar_search	= msclass.gettoolbarsearch(pform,pformupdate,v_table);
	var layout 							= msclass.getlayout(pgrid,get_toolbar_search,get_toolbar,iconCls,name);
}
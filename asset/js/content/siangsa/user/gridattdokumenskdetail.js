Ext.define('siangsa.user.gridattdokumenskdetail' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
	var dataselect;
	var msclass = Ext.create('master.global.geteventmenu'); 
	var pageId = Init.idmenu;
	var model = msclass.getmodel('tbl_attdokumen');
	var columns = msclass.getcolumn('tbl_attdokumen');
	//var winss;
	var filter = [];
	var store =  msclass.getstore(model,'tbl_attdokumen',filter);
	
	var storeact = Ext.create('Ext.data.Store', {
				fields: ['id', 'name'],
				data : [
					{"id":"Y", "name":"Y"},
					{"id":"N", "name":"N"}
				]
			});
			
	var coldisplay = columns;
				//columns[0].hidden = true;//row_id
				coldisplay[1].hidden = true;//row_id
				coldisplay[2] = {
						text : 'Nama File',
						width : 250,
						align : 'center',
						dataIndex	: coldisplay[2].dataIndex,				
						renderer: 
						function(val, meta, record, rowIndex){	
							var name = record.get('name') ;
							var url_dokumen = record.get('url_document') ;
							return '<a href="'+base_url+'document/upload/'+url_dokumen+'" target="_blank"><img src="'+base_url+'asset/ico/66.ico"  height="10" width="10"/>&nbsp;'+name+'</a>&nbsp;';
						}
				}
				//columns[3].text = 'Nama Pemohon';//nama_pemohon
				coldisplay[3].hidden = true;
				coldisplay[4].hidden = true;
				//columns[5].hidden = true;
				coldisplay[5].hidden = true;
				coldisplay[6].hidden = true;
				coldisplay[7].hidden = true;
				coldisplay[8].hidden = true;
				coldisplay[9].hidden = true;
				coldisplay[10].hidden = true;
				coldisplay[11].hidden = true;
				
				
			var editing = Ext.create('Ext.grid.plugin.RowEditing', {
			  clicksToEdit: 2,
			  listeners :
				{					
					'edit' : function (editor,e) {
						 // console.log("asd");
						/* var grid = e.grid;
						var record = e.record;					 
						var recordData = record.data;
						recordData.id = 'gridworkflow'+pageId; */
						//msclass.savedata(recordData , base_url+'hrd/update_jabatan');
						//console.log(Ext.getCmp('id_identitas'+pageId+'add'));
					}
				}
			});	
			
	Ext.apply(this, {
			//title	: 'Email Template',
			store		: store,
			plugins		: editing,	
			multiSelect	: true,
			//selType		: 'checkboxmodel',
			fit		: true,
			layout : 'fit',
			height : 200,
			id			: 'gridattdokumenskdetail'+pageId,
			columns		: columns
		});
		this.callParent(arguments);
	}
});
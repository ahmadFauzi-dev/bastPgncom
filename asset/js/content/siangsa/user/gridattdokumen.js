Ext.define('siangsa.user.gridattdokumen' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
	var dataselect;
	var msclass = Ext.create('master.global.geteventmenu'); 
	var pageId = Init.idmenu;
	var model = msclass.getmodel('v_attdokumen');
	var columns = msclass.getcolumn('v_attdokumen');
	//var winss;
	var filter = [];
	var store =  msclass.getstore(model,'v_attdokumen',filter);
	
			
	var coldisplay = columns;
				//columns[0].hidden = true;//row_id
				coldisplay[1].hidden = true;//row_id
				coldisplay[2] = {
						text : 'Nama File',
						flex: 2,
						sortable:false,
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
				coldisplay[12] = {
						text : 'Nomor',
						flex: 2,
						sortable:false,
						align : 'center',
						dataIndex	: coldisplay[12].dataIndex
				};
				coldisplay[13] = {
						text : 'Tanggal',
						flex: 1,
						sortable:false,
						align : 'center',
						dataIndex	: coldisplay[13].dataIndex
				};
				coldisplay[14] = {
						text : 'Jenis Dokumen',
						flex: 1,
						sortable:false,
						align : 'center',
						dataIndex	: coldisplay[14].dataIndex
				};
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
			id			: 'gridAttdokumen'+pageId,
			dockedItems	: [
				{
					xtype: 'toolbar',
					items	: [
					{
						text	: 'Add',
						iconCls	: 'add',
						//id : 'addattdokumen',
						xtype	: 'button',
						handler	: function()
						{
								
								if(!Init.winss_formupload)
								{
									var formattdokumen = Ext.create('siangsa.user.formdupload');
									Init.winss_formupload = Ext.widget('window', {
										title		: "Form Upload",
										closeAction	: 'hide',
										width: 500,
										height	: 300,
										//id			: ''+Init.idmenu+'winmapppelsource',
										resizable	: true,
										modal		: true,
										closable :true,
										bodyPadding	: 5,
										layout		: 'fit',
										items		: formattdokumen
									});
								}
								Ext.getCmp('formdupload'+pageId).getForm().reset();
								Init.winss_formupload.show();		
						}
					},
					{
							text	: 'Delete',
							iconCls	: 'bin',
							id : 'deleteattdokumen',
							xtype	: 'button',
							handler: function () {
								var grid = this.up('grid');
								if (grid) {
									var sm = grid.getSelectionModel();
									var rs = sm.getSelection();
									if (!rs.length) {
										Ext.Msg.alert('Info', 'No Records Selected');
										return;
									}
									grid.store.remove(rs[0]);
									
								}
							}
					}]
				}
			],
			columns		: columns
		});
		this.callParent(arguments);
	}
});
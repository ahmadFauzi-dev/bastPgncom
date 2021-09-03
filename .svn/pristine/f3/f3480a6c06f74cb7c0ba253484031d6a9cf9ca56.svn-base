Ext.define('siangsa.user.formduploadedit' ,{	
	extend: 'Ext.form.Panel',
	initComponent: function() {	
			var pageId = Init.idmenu;
			//console.log(pageId);
			//store_rekanan_m
			var msclass = Ext.create('master.global.geteventmenu'); 
			var filter = [];
			
			var mstore_jenis = msclass.getmodel("fn_getdatamastertype('TOD49')");
			var store_jenis =  msclass.getstore(mstore_jenis,"fn_getdatamastertype('TOD49')",filter);
			store_jenis.getProxy().extraParams = {
							view :"fn_getdatamastertype('TOD49')",
							limit : "All"
						};
			store_jenis.load();
			
												
		Ext.apply(this, {
				xtype : 'form',
				header:false,
				frame : true,
				id:'formduploadedit'+pageId,
    			fileUpload : true,
				defaultType : 'textfield',
				url			: base_url+'siangsa/form_dupload',
				method		: 'POST',
				bodyPadding: '5 5 0',
				fieldDefaults: {
					labelAlign: 'left',
				},
				items		: [
					{
						fieldLabel	: 'rowid',
						//id		: 'rowid_uploadt'+pageId,
						name		: 'rowid',
						//value		:  no_usulan,
						hidden	: true
					},
					{
						xtype: 'filefield',
						//id: 'url_documentt'+pageId,
						disabled:false,
						afterLabelTextTpl: required,
						width: 460,
						fieldLabel: 'Dokumen',
						name: 'url_document',
						buttonText: 'Unggah'
					},
					{
						xtype: 'combobox',
						fieldLabel: 'Jenis Dokumen',
						//id: 'activet'+pageId,
						name: 'jenis_dokumen',
						//width: 150,
						store: store_jenis,
						valueField: 'id',
						displayField: 'nama',
						queryMode: 'local',
							listeners: {
							change: function(combo, record, index) {								
								if (record){
									var nama = combo.displayTplData[0].nama;
									Ext.getCmp("nama_jenisedit"+pageId).setValue(nama);
								}
							}
						}
					},
					{
						fieldLabel: "nama_jenis",
						id: "nama_jenisedit"+pageId,
						name: "nama_jenis",
						hidden:true
					},
					{
						fieldLabel: "Nomor",
						//id: "descriptiont"+pageId,
						name: "nomor"
					},													{
						xtype: 'datefield',
						fieldLabel: 'Tanggal',
						allowBlank:false,
						maxValue: new Date(),
						//maxValue: '2018-11-30',
						name: 'tanggal',
						format: 'Y-m-d',
					}],
					buttons		: [
								{
									text: 'Upload',
									//id: 'BtnUpload'+pageId,
									disabled:false,
									iconCls:'folder_go',
									//hidden:!ROLE.DRAFT_DATA,
									handler: function(){
										if(this.up('form').getForm().isValid()){
											this.up('form').getForm().submit({
												waitTitle	 	: 'Harap Tunggu',
												waitMsg 	: 'Upload data',
												success	:function(response,opt)
												{
													var ar = Ext.JSON.decode(opt.response.responseText);
													var store = Ext.getCmp('gridattdokumenedit').getStore();
													var r = {
																	rowid : '',
																	nomor : ar.data.nomor,
																	tanggal : ar.data.tanggal,
																	jenis_dokumen : ar.data.jenis_dokumen,
																	url_document : ar.data.url_document,
																	name : ar.data.name,
																	nama_jenis : ar.data.nama_jenis,
													}
													store.insert(0, r);
													Ext.Msg.alert('Sukses','Upload Sukses');
													Init.winss_formuploadedit.close();
												},
												failure:function(response,opt)
												{
													//console.log(action);
													Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + opt.response.responseText + "");
												}
											});
									
										}
									}

								} 
						]
		});

		this.callParent(arguments);

		
	}
});
Ext.define('siangsa.validator.formbastcreator' ,{
		extend: 'Ext.form.Panel',
		initComponent: function() {
			var pageId = Init.idmenu;
			var filter = [];
			var msclass = Ext.create('master.global.geteventmenu');
			var dmodel = msclass.getmodel('v_karyawanjabatan');
			var storeph1 =  msclass.getstore(dmodel,'v_karyawanjabatan',filter);
			storeph1.load();
		
	
		Ext.apply(this, {
				xtype		: 'form',
				frame		: false,
				collapsed :false,
				url			: base_url+'siangsa/add_bast',
				border		: false,
				//title		: "Form Revise",
				autoScroll	:true,
				fileUpload	: true,
				frame  		: false,
				method		: 'POST',
				//bodyPadding: '5 5 0',
				fieldDefaults: {
					labelAlign: 'left',
					anchor: '60%'
				},
				id					: 'formbastcreator',
				flex 				: 1,
				defaultType	: 'textfield',
				items		: [
				{		
						xtype		: 'fieldset',
						defaultType	: 'textfield',
						//id			: 'fieldsetformNewRelocation',
						border		: false,
						layout		: 'anchor',
						defaults: {
							anchor: '100%'
						},
						items		: [
								{
									fieldLabel: "rowid",
									id: "rowidcb"+pageId,
									name: "rowid",
									hidden : true
								},
								{
									xtype: 'datefield',
									fieldLabel: 'Tanggal Surat',
									//id:'tanggal_suratedit'+pageId,
									allowBlank:false,
									//maxValue: new Date(),
									name: 'tanggal_surat',
									format: 'Y-m-d',
								},
								{
									fieldLabel: "No Surat",
									//id: "no_suratedit"+pageId,
									name: "no_surat",
									hidden : false
								},
								{
									xtype: 'combobox',
									fieldLabel: 'Jabatan Pejabat',
									name: 'reffph1',
									store: storeph1,
									triggerAction: 'all',
									valueField: 'id',
									displayField: 'name',
									queryMode: 'local',
									allowBlank:false,
									typeAhead: true,
									grow:true,
									listeners: {
										select: function(cmb, record, index){
												//console.log(record[0].data.name_organization);
												var name = record[0].data.name;
												var namakaryawan = record[0].data.namakaryawan;
												var user_id = record[0].data.user_id;
												Ext.getCmp("nama_pejabat"+pageId).setValue(namakaryawan);			
												Ext.getCmp("nama_jabatan"+pageId).setValue(name);			
										}
									}
								},
								{
									fieldLabel: "Nama Pejabat",
									id: "nama_pejabat"+pageId,
									name: "nama_pejabat"
								},
								{
									fieldLabel: "Nama Jabatan",
									id: "nama_jabatan"+pageId,
									name: "nama_jabatan"
								}
						]
				}],
				buttons			: [
				{
							text: 'Kirim',
				            //id: 'Btntaskskdetail'+pageId,
				            disabled:false,
							border : true,
				            iconCls:'disk',
				            //hidden:!ROLE.DRAFT_DATA,
				            handler: function(){
								if(this.up('form').getForm().isValid()){
				            		this.up('form').getForm().submit({
										waitTitle	: 'Harap Tunggu',
										waitMsg		: 'Insert data', 
										params:{ 
											table : 'tb_bast'
										},
										success	:function(form, action)
										{
											//myMask.hide();
											Ext.Msg.alert('Sukses','BAST telah dibuat');
											var tabPanel = Ext.getCmp('contentcenter');
											Init.winss_formcreatebast.destroy();
											Init.winss_formcreatebast.close();
											tabPanel.items.each(function(c){
												if (c.id == 'editdraft') {
													tabPanel.remove(c);
												}
											});
											Ext.getCmp('idgrid_permohonanbastcreator').getStore().load();
											Ext.getCmp('formbastcreator').getForm().destroy();
										},
										failure:function(form, action)
										{
											Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
										}
									});
				            
								}
							}
				}]
		});
												
		this.callParent(arguments);
	}
});
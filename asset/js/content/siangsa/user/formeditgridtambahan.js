Ext.define('siangsa.user.formeditgridtambahan' ,{	
	extend: 'Ext.form.Panel',
	initComponent: function() {	
			var pageId = Init.idmenu;
			//console.log(pageId);
			//store_rekanan_m
			var msclass = Ext.create('master.global.geteventmenu'); 
			var filter = [];
			
			var mstore_jenis = msclass.getmodel("v_jbiayatambahan");
			var store_jenis =  msclass.getstore(mstore_jenis,"v_jbiayatambahan",filter);
			store_jenis.getProxy().extraParams = {
							view :"v_jbiayatambahan",
							limit : "All"
						};
			store_jenis.load();
			
												
		Ext.apply(this, {
				xtype : 'form',
				header:false,
				frame : true,
				id:'formeditgridtambahan'+pageId,
    			fileUpload : true,
				defaultType : 'textfield',
				url			: base_url+'siangsa/formgridtambahan',
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
						xtype: 'combobox',
						fieldLabel: 'Jenis Biaya',
						//id: 'activet'+pageId,
						name: 'jenis_biaya',
						//width: 150,
						store: store_jenis,
						valueField: 'rowid',
						displayField: 'name',
						queryMode: 'local',
						listeners: {
							change: function(combo, record, index) {								
									if (record){
										var name = combo.displayTplData[0].name;
										var mvalue = combo.displayTplData[0].description;
										Ext.getCmp("nama_jenisedit"+pageId).setValue(name);
										Ext.getCmp("mvalueedit"+pageId).setValue(mvalue);
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
						fieldLabel: "mvalue",
						id: "mvalueedit"+pageId,
						name: "mvalue",
						hidden:true
					},
					{
						xtype: 'numberfield',
						fieldLabel: 'Nominal',
						name : 'nominal',
						hideTrigger: true,
						minValue: 0
					},
					{
						xtype: 'textareafield',
						fieldLabel: 'Keterangan',
						name: 'keterangan',
						anchor    : '100%',
						height    : 150,
						grow : true
					}],
					buttons		: [
					{
							text: 'Add',
							//id: 'BtnUpload'+pageId,
							disabled:false,
							iconCls:'folder_go',
							//hidden:!ROLE.DRAFT_DATA,
							handler: function(){
											var findform = this.up('form').getForm();
											var oksparams = findform.getValues();
											var store = Ext.getCmp('grideditbiayatambahan'+'add').getStore();
											var r = {
														rowid : '',
														reffjenis : oksparams.jenis_biaya,
														nama_jenis : oksparams.nama_jenis,
														keterangan : oksparams.keterangan,
														nominal : oksparams.nominal,
														mvalue : oksparams.mvalue
											}
											store.insert(0, r);
											Ext.Msg.alert('Sukses','Insert Sukses');
											Init.winss_formeditgridtambahan.close();
										
							}
					}]
		});

		this.callParent(arguments);

		
	}
});
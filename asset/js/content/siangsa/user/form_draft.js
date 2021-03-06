Ext.define('siangsa.user.form_draft' ,{
		extend: 'Ext.form.Panel',
		initComponent: function() {
			//tbl_rekanan	
	
			var pageId = Init.idmenu;
			var msclass = Ext.create('master.global.geteventmenu'); 
			var filter = [];
			
			//var gridtembusan = Ext.create('siangsa.user.gridtembusan');
			var gridattdokumen = Ext.create('siangsa.user.gridattdokumen');
			var gridworkflow = Ext.create('siangsa.user.gridworkflow');
			var gridbiayatambahan = Ext.create('siangsa.user.gridbiayatambahan');
			
			var mrefftujuansurat = msclass.getmodel("fn_getdatamastertype('TOD39')");
			var store_refftujuansurat =  msclass.getstore(mrefftujuansurat,"fn_getdatamastertype('TOD39')",filter);
			store_refftujuansurat.getProxy().extraParams = {
							view :"fn_getdatamastertype('TOD39')",
							limit : "All"
						};
			store_refftujuansurat.load();
			
			var msatuankerja = msclass.getmodel("mst_divisi");
			var store_satuankerja =  msclass.getstore(msatuankerja,"mst_divisi",filter);
			store_satuankerja.getProxy().extraParams = {
							view :"mst_divisi",
							limit : "All"
						};
			store_satuankerja.load();
			
			var mreffjenissurat = msclass.getmodel("v_jenissurat");
			var store_reffjenissurat =  msclass.getstore(mreffjenissurat,"v_jenissurat",filter);
			store_reffjenissurat.getProxy().extraParams = {
							view :"v_jenissurat",
							limit : "All"
						};
			store_reffjenissurat.load();
			
			var mvendor_nama = msclass.getmodel("tb_vendor");
			var svendor_nama =  msclass.getstore(mvendor_nama,"tb_vendor",filter);
			svendor_nama.getProxy().extraParams = {
							view :"tb_vendor",
							limit : "All"
						};
			svendor_nama.load();
			
			var mtb_vendordir = msclass.getmodel("tb_vendordir");
			var stb_vendordir =  msclass.getstore(mtb_vendordir,"tb_vendordir",filter);			
			
			var mrefftujuansurat = msclass.getmodel("fn_getdatamastertype('TOD39')");
			var store_refftujuansurat =  msclass.getstore(mrefftujuansurat,"fn_getdatamastertype('TOD39')",filter);
			store_refftujuansurat.getProxy().extraParams = {
							view :"fn_getdatamastertype('TOD39')",
							limit : "All"
						};
			store_refftujuansurat.load();
			
			var mrefflokasi = msclass.getmodel("fn_getdatamastertype('TOD40')");
			var store_refflokasi =  msclass.getstore(mrefflokasi,"fn_getdatamastertype('TOD40')",filter);
			store_refflokasi.getProxy().extraParams = {
							view :"fn_getdatamastertype('TOD40')",
							limit : "All"
						};
			store_refflokasi.load();
			
			Ext.apply(this, {
				xtype		: 'form',
				frame		: false,
				collapsed 	:false,
				autoScroll: true,
				border		: false,
				url			: base_url+'siangsa/add_draft',
				margins: '10,10,10,10',
				fileUpload	: true,
				frame  		: false,
				method		: 'POST',
				width   		: '60%',
				//bodyPadding: '5 5 0',
				fieldDefaults: {
					labelAlign: 'left',
					anchor: '100%',
					labelWidth: 150
				},
				id			: 'form_draft'+pageId,
				//flex : 1,
				defaultType	: 'textfield',
				layout: {
					//type: 'hbox',
					//align: 'stretch'
				},
				items		: [
					{
							xtype		: 'fieldset',
							defaultType	: 'textfield',
							//id			: 'fieldsetformNewRelocation',
							fileUpload	: false,
							width : 20,
							collapsed :false,
							border		: false,
					},
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
								xtype		: 'fieldset',
								defaultType	: 'textfield',
								//id			: 'fieldsetformNewRelocation',
								fileUpload	: false,
								collapsed :false,
								border		: false,
								flex 			: 1,
								layout		: 'anchor',
								defaults: {
									anchor: '100%'
								},
								items		: [
								{
									fieldLabel: "rowid",
									id: "rowid"+pageId,
									name: "rowid",
									value : '0',
									hidden : true
								},
								{
									fieldLabel: "Satuan Kerja",
									id: "str_satuankerja"+pageId,
									name: "str_satuankerja",
									hidden : true
								},
								{
									xtype: 'combobox',
									fieldLabel: 'Jenis Surat *',
									allowBlank:false,
									id: 'reffjenissurat'+pageId,
									name: 'reffjenissurat',
									store: store_reffjenissurat,
									triggerAction: 'all',
									flex : 1,
									valueField: 'id',
									displayField: 'desk',
									queryMode: 'local',
									//allowBlank:false,
									typeAhead: true,
									grow:true,
									listeners: {
										change: function(combo, record, index) {
												var desk = combo.displayTplData[0].desk;
												Ext.getCmp("str_jenissurat"+pageId).setValue(desk);
										}
									}
								},
								{
									fieldLabel: "Jenis Surat",
									id: "str_jenissurat"+pageId,
									name: "str_jenissurat",
									hidden : true
								},
								{
									xtype: 'textareafield',
									fieldLabel: "Nama Kegiatan *",
									id: "judul_bast"+pageId,
									name: "judul_bast",
									allowBlank:false,
									grow: true,
									width: 700,
									height: 50
								},
								/* {
									xtype: 'textareafield',
									fieldLabel: "Kerja Tambah",
									name: "kerja_tambah",
									allowBlank:false,
									grow: true,
									width: 700,
									height: 50
								}, */
								{
									xtype: 'fieldcontainer',
									fieldLabel: 'Pembayaran *',
									layout: 'hbox',
									//anchor: '50%',
									name: 'pembayaran',
									items : [
										{
											xtype: 'numberfield',
											//allowBlank:false,
											width : 30,
											emptyText: '%',
											name : 'persen_pembayaran',
											hideTrigger: true,
											maxValue: 100,
											minValue: 0
										},
										{
											xtype: 'label',
											labelClsExtra:'text-align-center',  
											width: 10,
										},
										{
											xtype: 'numberfield',
											fieldLabel: 'Nominal Project',
											labelWidth: 100,
											hideTrigger: true,
											emptyText: 'Rp.',
											//allowBlank:false,
											name : 'nominal_projek'
										},
										{
											xtype: 'label',
											labelClsExtra:'text-align-center',  
											width: 10,
										},
										{
											xtype: 'numberfield',
											anchor : '100%',
											width : 100,
											fieldLabel: 'Termin',
											labelWidth: 50,
											name : 'termin',
											hideTrigger: true,
											maxValue: 100,
											minValue: 0
										}
									]
								},
								{
									xtype: 'fieldcontainer',
									fieldLabel: 'Tambahan',
									id: "tambahan"+pageId,
									items: gridbiayatambahan
								},
								{
									xtype: 'fieldcontainer',
									fieldLabel: 'Tujuan Surat *',
									id: "tujuan_surat"+pageId,
									items: gridworkflow
								},
								{
									xtype: 'fieldcontainer',
									fieldLabel: 'Lampiran *',
									//layout: 'hbox',
									items: gridattdokumen
								},
								{
									xtype: 'combobox',
									fieldLabel: 'Lokasi *',
									id: 'refflokasi'+pageId,
									name: 'lokasi',
									store: store_refflokasi,
									triggerAction: 'all',
									flex : 1,
									valueField: 'id',
									displayField: 'nama',
									queryMode: 'local',
									allowBlank:false,
									typeAhead: true,
									grow:true,
									listeners: {
										change: function(combo, record, index) {
											//console.log(combo.displayTplData[0]);
											var nama = combo.displayTplData[0].nama;
											Ext.getCmp("str_lokasi"+pageId).setValue(nama);
										}
									}
								},
								{
									xtype: 'combobox',
									fieldLabel: 'Perusahaan *',
									id: 'reffph2'+pageId,
									name: 'reffph2',
									store: svendor_nama,
									triggerAction: 'all',
									valueField: 'rowid',
									displayField: 'nama_vendor',
									queryMode: 'local',
									allowBlank:false,
									listeners: {
										select: function(combo, record, index) {											
												//console.log(record[0].get('rowid'));
												var id = record[0].get('rowid');
												var store_nm = Ext.getCmp('reffapprovalph2'+pageId).getStore();
												store_nm.getProxy().extraParams = {
																view :'tb_vendordir',
																limit : 'All',
																"filter[0][field]" : "reffvendor", 
																"filter[0][data][type]" : "string",
																"filter[0][data][comparison]" : "eq",
																"filter[0][data][value]" : id
												};		
												store_nm.load(); 
											}
										}
								},
								{
									xtype: 'combobox',
									fieldLabel: 'PIC *',
									id: 'reffapprovalph2'+pageId,
									name: 'reffapprovalph2',
									store: stb_vendordir,
									triggerAction: 'all',
									valueField: 'rowid',
									displayField: 'nama',
									queryMode: 'local',
									allowBlank:false,
									typeAhead: true,
									grow:true
								},
								{
									fieldLabel: "str_lokasi",
									id: "str_lokasi"+pageId,
									name: "str_lokasi",
									allowBlank : false,
									hidden : true
								}]
							}]
					}],
				buttons			: [
				{
							text: 'Kirim',
				            //id: 'Btn'+pageId+'add',
				            disabled:false,
							border : true,
				            iconCls:'email_go',
				            //hidden:!ROLE.DRAFT_DATA,
				            handler: function(){
								
								var sworkflow = gridworkflow.getStore();
								var arrworkflow = [];
								sworkflow.each(function(record){
										arrworkflow.push(record.data);
								});
								var vworkflow;
								vworkflow = Ext.encode(arrworkflow);
								
								var sattdokumen = gridattdokumen.getStore();
								var arrattdokumen = [];
								sattdokumen.each(function(record){
										arrattdokumen.push(record.data);
								});
								var vattdokumen;
								vattdokumen = Ext.encode(arrattdokumen);
								
								
								var sbiayatambah = gridbiayatambahan.getStore();
								var arrbiayatambah = [];
								sbiayatambah.each(function(record){
										arrbiayatambah.push(record.data);
								});
								var vbiayatambah;
								vbiayatambah = Ext.encode(arrbiayatambah);
								
								
								if(this.up('form').getForm().isValid()){
				            		this.up('form').getForm().submit({
										waitTitle	: 'Harap Tunggu',
										waitMsg		: 'Insert data',
										//scope:this,
				                        params:{ 
											dataAttdokumen : vattdokumen, 
											dataWorkflow : vworkflow,
											dataBiayatambah : vbiayatambah
										},
										success	:function(form, action)
										{
											//myMask.hide();
											Ext.Msg.alert('Sukses','Draft sudah tersimpan');
											var tabPanel = Ext.getCmp('contentcenter');
											tabPanel.items.each(function(c){
												if (c.id == 'fdraft') {
													tabPanel.remove(c);
												}
											});
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
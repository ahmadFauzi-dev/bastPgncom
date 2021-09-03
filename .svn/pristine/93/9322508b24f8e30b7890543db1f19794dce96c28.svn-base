Ext.define('siangsa.validator.formdetailcreator' ,{
	
		extend: 'Ext.form.Panel',
		initComponent: function() {
			var pageId = Init.idmenu;
			//console.log(pageId);
			//store_rekanan_m
			var msclass = Ext.create('master.global.geteventmenu'); 
			var filter = [];
			var gridattdokumen = Ext.create('siangsa.validator.gridattdokumenbastdetailcreator');

		Ext.apply(this, {
				xtype		: 'form',
				frame		: false,
				collapsed :false,
				border		: false,
				title		: "Bapp Detail",
				autoScroll	:true,
				fileUpload	: true,
				frame  		: false,
				method		: 'POST',
				//bodyPadding: '5 5 0',
				fieldDefaults: {
					labelWidth: 200,
					labelAlign: 'left',
					anchor: '100%'
				},
				id			: 'formdetailcreator'+pageId,
				flex : 1,
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
								xtype: 'displayfield',
								fieldLabel: "Konseptor",
								name: "nama_creator",
								fieldStyle: 'background:none'								
							},
							{
								xtype: 'displayfield',
								fieldLabel: "Satuan Kerja",
								name: "nama_divisi"
							},
							{
								xtype: 'displayfield',
								fieldLabel: "Jenis Surat",
								name: "jenis_surat"
							},
							{
								xtype: 'displayfield',
								fieldLabel: "Nama Kegiatan",
								name: "judul_bast",
								grow: true
							},
							{
								xtype: 'displayfield',
								fieldLabel: "Nama Persahanaan Pihak Ke 2",
								name: "perusahaan_ph2",
								grow: true
							},
							{
								xtype: 'displayfield',
								fieldLabel: "Nama Pihak Ke 2",
								name: "nama_ph2",
								grow: true
							},
							{
								xtype: 'displayfield',
								fieldLabel: "Jabatan Pihak Ke 2",
								name: "jabatan_ph2",
								grow: true
							},
							{
								xtype: 'displayfield',
								fieldLabel: "Alamat Pihak Ke 2",
								name: "alamat_ph2",
								grow: true
							},
							{
								xtype: 'displayfield',
								fieldLabel: "Persen Pembayaran",
								name: "persen_pembayaran",
								grow: true
							},
							{
								xtype: 'displayfield',
								fieldLabel: "Nominal Projek",
								name: "nominal_projek",
								grow: true
							},
							{
								xtype: 'displayfield',
								fieldLabel: "Nominal Pembayaran",
								name: "nominal_pembayaran",
								grow: true
							},
							,{
								xtype: 'displayfield',
								fieldLabel: "Termin",
								name: "termin",
								grow: true
							},
							{
								xtype: 'fieldcontainer',
								fieldLabel: 'Lampiran',
								//layout: 'hbox',
								items: gridattdokumen
							}]
				}]				
		});
												
		this.callParent(arguments);
	}
});
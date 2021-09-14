Ext.define('mapping.model.mpelangganindustri', {
		extend: 'Ext.data.Model',
		idProperty: 'idpel',
		fields: [	
			{ name: 'accid'},		
			{ name: 'idpel'},
			{ name: 'noreff'},
			{ name: 'pelname'},
			{ name: 'jenispel'},	
			{ name: 'kode_area'},			
			{ name: 'namearea'},
			{ name: 'sbu'},
			{ name: 'ismultisource'},			
			{ name: 'stationname'},
			{ name: 'selectopts'}	
		]
	});
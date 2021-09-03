Ext.define('EM.tools.view.gridhourly' ,{
	extend: 'Ext.grid.Panel',
    //alias : 'widget.formco',
	initComponent	: function()
	{
		Ext.define('modelHourly',{
			extend	: 'Ext.data.Model',
			fields	: ['mmscfd','totalizer_mmbtu','totalizer_mscf','totalizer_energy','parameter_periode','totalizer_volume','tekanan_in_psig','tekanan_out_psig','temp_f','ghv','idx_jampengukuran_id','pcv','stat','tgl_pengukuran','tbl_station_id','nama_station']
		});
	
		Ext.define('modeestimasi',{
			extend	: 'Ext.data.Model',
			fields	: ['tbl_parameter','tgl_pengukuran','jam_pengukuran','parameter_periode','tbl_parametervalue','tbl_station_id']
		});
	
		var storeGridHourly = Ext.create('Ext.data.JsonStore',{
			model 	: 'modelHourly',
			proxy: {
				type: 'pgascomProxy',
				//extraParams:{'id':row_id},
				url: base_url+'admin/listGridHourly',
				reader: {
					type: 'json',
					//pageSize	: 10,
					root: 'data'
				}
				//simpleSortMode: true
			}
		});
		
		var storeestimasirend = Ext.create('Ext.data.JsonStore',{
			model 	: 'modeestimasi',
			proxy: {
				type: 'pgascomProxy',
				//extraParams : {'tgl_pengukuran'	:'2015-12-11','parameter_periode' : 'hourly','tbl_station_id' : '24'},
				url: base_url+'admin/srenderestimasi',
				reader: {
					type: 'json',
					//pageSize	: 10,
					root: 'data'
				}
				//simpleSortMode: true
			}
		});
		storeestimasirend.load();
		
		function getColorEstimasi(tgl_pengukuran,jam_pengukuran,tbl_station_id,tbl_parameter,parameter_periode)
		{
			
			//console.log(tbl_parameter);
			var test = storeestimasirend.findBy(
				function(rec, id) {
					if(rec.data.tbl_station_id == tbl_station_id && rec.data.tgl_pengukuran == tgl_pengukuran && rec.data.jam_pengukuran == jam_pengukuran  && rec.data.tbl_parameter == tbl_parameter && rec.data.parameter_periode == parameter_periode)
					{
						
						return 1;
					}else 
					{
						return 0;
					}
					//console.log(rec.data.jam_pengukuran == jam_pengukuran);
					//var cekdata = rec.data.tbl_station_id == tbl_station_id && rec.data.tgl_pengukuran == tgl_pengukuran && rec.data.jam_pengukuran == jam_pengukuran  && rec.data.tbl_parameter == tbl_parameter && rec.data.parameter_periode == parameter_periode;
					//console.log(rec.data.tbl_station_id+"_"+tbl_station_id+"_"+rec.data.tgl_pengukuran+"_"+tgl_pengukuran+"_"+rec.data.jam_pengukuran+"_"+jam_pengukuran+"_"+rec.data.tbl_parameter+"_"+tbl_parameter+"_"+rec.data.parameter_periode+"_"+parameter_periode);
					//if (cekdata == false) 
					//{
						//test = 0;
					//}else
					//{
						//test = 1;
					//}
				}
			);
			console.log(test);
			return test;
			
		}
		storeGridHourly.load();
		Ext.apply(this,{
			store		: storeGridHourly,
			//stateful	: true,
			//margins		: '10',
			id			: 'gridHourly',
			selType		: 'checkboxmodel',
			columns		: [
			{
				dataIndex	: 'stat',
				flex		: 5,
				renderer : function(value, metaData, record, rowIdx, colIdx, store, view){
					
					//metaData.tdAttr= 'data-qtip="'+message+'"';
					var color = '';
					if(record.get('stat') == "success")
					{
						 color = base_url+'asset/ico/green_indicator.ico';
					}else if(record.get('stat') == "warnig")
					{
						 color = base_url+'asset/ico/yellow_indicator.ico';
					}else
					{
						color = base_url+'asset/ico/red_indicator.ico';
					}
					return '<div><img src='+color+' width="20px" height="20px"></div>';
					
				}
			},
			{
				text	: 'station',
				align	: 'center',
				dataIndex	: 'nama_station'
			},
			{
				text	: 'Tanggal',
				align	: 'center',
				dataIndex	: 'tgl_pengukuran'
			},
			{
				text	: 'Jam',
				dataIndex	: 'idx_jampengukuran_id'
			},
			{
				text	: 'Volume',
				align	: 'center',
				dataIndex	: 'mmscfd',
				renderer	: function(value, metaData, record, rowIdx, colIdx, store, view)
				{
					var tgl_pengukuran = record.get('tgl_pengukuran');
					var jam_pengukuran = record.get('idx_jampengukuran_id');
					var tbl_station_id = record.get('tbl_station_id');
					var tbl_parameter  = 'mmscfd';
					var parameter_periode	 = record.get('parameter_periode');
					var message = getColorEstimasi(tgl_pengukuran,jam_pengukuran,tbl_station_id,tbl_parameter,parameter_periode);
					if (parseFloat(message) > 0) 
					{
						return '<div style="color:#9900ff">'+value+'</div>';
					}else
					{
						return value;
					}
				}
			},
			{
				text	: 'Energy <br /> BBTUD',
				align	: 'center',
				dataIndex	: 'totalizer_mmbtu',
				renderer	: function(value, metaData, record, rowIdx, colIdx, store, view)
				{
					var tgl_pengukuran = record.get('tgl_pengukuran');
					var jam_pengukuran = record.get('idx_jampengukuran_id');
					var tbl_station_id = record.get('tbl_station_id');
					var tbl_parameter  = 'totalizer_mmbtu';
					var parameter_periode	 = record.get('parameter_periode');
					var message = getColorEstimasi(tgl_pengukuran,jam_pengukuran,tbl_station_id,tbl_parameter,parameter_periode);
					if (parseFloat(message) > 0) 
					{
						return '<div style="color:#9900ff">'+value+'</div>';
					}else
					{
						return value;
					}
				}
			},
			{
				text	: 'Counter Volume <br /> (MMSCF)',
				align	: 'center',
				dataIndex	: 'totalizer_volume',
				renderer	: function(value, metaData, record, rowIdx, colIdx, store, view)
				{
					var tgl_pengukuran = record.get('tgl_pengukuran');
					var jam_pengukuran = record.get('idx_jampengukuran_id');
					var tbl_station_id = record.get('tbl_station_id');
					var tbl_parameter  = 'totalizer_volume';
					var parameter_periode	 = record.get('parameter_periode');
					var message = getColorEstimasi(tgl_pengukuran,jam_pengukuran,tbl_station_id,tbl_parameter,parameter_periode);
					if (parseFloat(message) > 0) 
					{
						return '<div style="color:#9900ff">'+value+'</div>';
					}else
					{
						return value;
					}
				}
				
			},
			{
				text	: 'Counter Energy <br /> (BBTU)',
				align	: 'center',
				dataIndex	: 'totalizer_energy',
				renderer	: function(value, metaData, record, rowIdx, colIdx, store, view)
				{
					var tgl_pengukuran = record.get('tgl_pengukuran');
					var jam_pengukuran = record.get('idx_jampengukuran_id');
					var tbl_station_id = record.get('tbl_station_id');
					var tbl_parameter  = 'totalizer_energy';
					var parameter_periode	 = record.get('parameter_periode');
					var message = getColorEstimasi(tgl_pengukuran,jam_pengukuran,tbl_station_id,tbl_parameter,parameter_periode);
					if (parseFloat(message) > 0) 
					{
						return '<div style="color:#9900ff">'+value+'</div>';
					}else
					{
						return value;
					}
				}
			},
			{
				text	: 'GHV <br /> (BTU/SCF)',
				align	: 'center',
				dataIndex	: 'ghv',
				renderer	: function(value, metaData, record, rowIdx, colIdx, store, view)
				{
					var tgl_pengukuran = record.get('tgl_pengukuran');
					var jam_pengukuran = record.get('idx_jampengukuran_id');
					var tbl_station_id = record.get('tbl_station_id');
					var tbl_parameter  = 'ghv';
					var parameter_periode	 = record.get('parameter_periode');
					var message = getColorEstimasi(tgl_pengukuran,jam_pengukuran,tbl_station_id,tbl_parameter,parameter_periode);
					if (parseFloat(message) > 0) 
					{
						return '<div style="color:#9900ff">'+value+'</div>';
					}else
					{
						return value;
					}
				}
			},
			{
				text	: 'Tekanan IN <br /> (PSIG)',
				align	: 'center',
				dataIndex	: 'tekanan_in_psig',
				renderer	: function(value, metaData, record, rowIdx, colIdx, store, view)
				{
					var tgl_pengukuran = record.get('tgl_pengukuran');
					var jam_pengukuran = record.get('idx_jampengukuran_id');
					var tbl_station_id = record.get('tbl_station_id');
					var tbl_parameter  = 'tekanan_in_psig';
					var parameter_periode	 = record.get('parameter_periode');
					var message = getColorEstimasi(tgl_pengukuran,jam_pengukuran,tbl_station_id,tbl_parameter,parameter_periode);
					if (parseFloat(message) > 0) 
					{
						return '<div style="color:#9900ff">'+value+'</div>';
					}else
					{
						return value;
					}
				}
			},
			{
				text	: 'Tekanan OUT <br /> (PSIG)',
				align	: 'center',
				dataIndex	: 'tekanan_out_psig',
				renderer	: function(value, metaData, record, rowIdx, colIdx, store, view)
				{
					var tgl_pengukuran = record.get('tgl_pengukuran');
					var jam_pengukuran = record.get('idx_jampengukuran_id');
					var tbl_station_id = record.get('tbl_station_id');
					var tbl_parameter  = 'tekanan_out_psig';
					var parameter_periode	 = record.get('parameter_periode');
					var message = getColorEstimasi(tgl_pengukuran,jam_pengukuran,tbl_station_id,tbl_parameter,parameter_periode);
					if (parseFloat(message) > 0) 
					{
						return '<div style="color:#9900ff">'+value+'</div>';
					}else
					{
						return value;
					}
				}
			},
			{
				text		: 'Temperature',
				align		: 'center',
				dataIndex	: 'temp_f',
				renderer : function(value, metaData, record, rowIdx, colIdx, store, view)
				{
					var tgl_pengukuran = record.get('tgl_pengukuran');
					var jam_pengukuran = record.get('idx_jampengukuran_id');
					var tbl_station_id = record.get('tbl_station_id');
					var tbl_parameter  = 'temp_f';
					var parameter_periode	 = record.get('parameter_periode');
					var message = getColorEstimasi(tgl_pengukuran,jam_pengukuran,tbl_station_id,tbl_parameter,parameter_periode);
					//console.log(tgl_pengukuran+" "+jam_pengukuran+" "+tbl_station_id+" "+tbl_parameter+" "+parameter_periode);
					if (parseFloat(message) > 0) 
					{
						return '<div style="color:#9900ff">'+value+'</div>';
					}else
					{
						return value;
					}
				}
			},
			{
				text		: 'PCV',
				align		: 'center',
				dataIndex	: 'pcv',
				renderer	: function(value, metaData, record, rowIdx, colIdx, store, view)
				{
					var tgl_pengukuran = record.get('tgl_pengukuran');
					var jam_pengukuran = record.get('idx_jampengukuran_id');
					var tbl_station_id = record.get('tbl_station_id');
					var tbl_parameter  = 'pcv';
					var parameter_periode	 = record.get('parameter_periode');
					var message = getColorEstimasi(tgl_pengukuran,jam_pengukuran,tbl_station_id,tbl_parameter,parameter_periode);
					if (parseFloat(message) > 0) 
					{
						return '<div style="color:#9900ff">'+value+'</div>';
					}else
					{
						return value;
					}
				}
			},
			{
				text	: 'Keterangan'
			}],
			listeners	: 
			{
				beforeitemcontextmenu: function(view, record, item, index, e)
				{
					e.stopEvent();
					gridMenu.showAt(e.getXY());
				},
				itemclick	: function(view, record, item, index, e, eOpts)
				{
					console.log(record.data);
				}
			}
		});
		this.callParent(arguments);
	}
})
Ext.require(['Ext.data.*']);

Ext.onReady(function() {

    window.generateDatacl = function(n, floor){
        var data = [],
            p = (Math.random() *  11) + 1,
            i;
		var	name_arr = ["Normal","CNG","Diesel"];
        floor = (!floor && floor !== 0)? 20 : floor;
        
        for (i = 0; i < 3; i++) {
            data.push({
                name :name_arr[i] ,
                data1: Math.floor(Math.max((Math.random() * 100), floor)),
                data2: Math.floor(Math.max((Math.random() * 100), floor))
            });
        }
        return data;
    };
    
    window.store1 = Ext.create('Ext.data.JsonStore', {
        fields: ['name', 'data1', 'data2'],
        data: generateData()
    });
       
    
    window.loadTask = new Ext.util.DelayedTask();
});

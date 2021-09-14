Ext.define('master.global.geteventmenu', {
    name: 'geteventmenu',
    constructor: function(name) {
        if (name) {
            this.name = name;
        }
    },

    getevent: function(idmenu) {
        //alert(this.name + " is eating: " + foodType);
		console.log(idmenu);
    }
});

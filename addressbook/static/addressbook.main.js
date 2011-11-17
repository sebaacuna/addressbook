define(['cs!addressbook'], function(addressbook) { 

    var app = new addressbook.App();
    app.run();
    
    return { app: app };
});
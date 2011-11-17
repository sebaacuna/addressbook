define ["jquery","cs!descanso"], ($, descanso) ->
    class App extends descanso.App
        
        constructor: ->
            super    
            @api_url = "/api"
            @name = "addressbook"

        run: ->
            @loadResources =>
                
                # Declare views
                
                personlistview = new descanso.ResourceListView @resources.person
                personlistview.setTemplate {view: "tmpl-table", items: "tmpl-table-row"}
                
                personview = new descanso.ResourcePaneView @resources.person
                personview.setTemplate "tmpl-person"
                
                entrylistview = new descanso.ResourceListView @resources.entry
                entrylistview.setTemplate {view: "tmpl-table", items: "tmpl-table-row"}
                
                entryview = new descanso.ResourcePaneView @resources.entry
                entryview.setTemplate "tmpl-entry"
                
                labellistview = new descanso.ResourceListView @resources.entrylabel
                labellistview.setTemplate {view: "tmpl-table", items: "tmpl-table-row"}

                labelview = new descanso.ResourcePaneView @resources.entrylabel
                labelview.setTemplate "tmpl-label"
                
                
                # Declare event bindings
                                
                personlistview.bindEvent "add", (args)=>
                    console.log "Adding person"
                    personview.bind personview.resource.empty()
                    @renderView "#person", personview
                    
                personlistview.bindEvent "select", (args)=>
                    person = args.view.obj
                    console.log "Selected person"
                    personview.bind person
                    @renderView "#person", personview
                    @resources.entry.list {"person": person }, (obj_list)=>
                        console.log "Got entries"
                        entrylistview.bind obj_list
                        newentry = @resources.entry.empty()
                        newentry.person = person
                        entryview.bind newentry
                        @renderView "#entrylist", entrylistview
                        @renderView "#new_entry", entryview
                        
                        
                entrylistview.bindEvent "add", (args)=>
                    console.log "Adding entry"
                    
                entryview.bindEvent "chooseLabel", (args)=>
                    args.domEvent.stopPropagation()
                    console.log "Choosing label"
                    $("#labels").removeClass "invisible"
                    pos = $(args.domEvent.srcElement).offset()
                    $("#labels").css( { left: pos.left + "px", top: pos.top + "px" } )
                    
                    
                labellistview.bindEvent "select", (args)=>
                    console.log "Label chosen"
                    $("#labels").elem.addClass "invisible"
                        
                # Initial data load
                
                @resources.entrylabel.list (obj_list) =>
                    labellistview.bind obj_list
                    labelview.bind @resources.entrylabel.empty()
                    
                    console.log "Entry labels"
                    @renderView "#labellist", labellistview
                    @renderView "#new_label", labelview

                    @resources.person.list (obj_list) =>
                        personlistview.bind obj_list
                        @renderView "#personlist", personlistview
                        
                    $("body").bind "click", (event)->
                        console.log "Leaving label dropdown"
                        $("#labels").addClass "invisible"
                
    return { "App": App }
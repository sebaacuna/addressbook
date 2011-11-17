define ["jquery","cs!descanso"], ($, descanso) ->
    class App extends descanso.App
        
        constructor: ->
            super    
            @api_url = "/api"
            @name = "addressbook"

        labelDropdownEnable: (anchorElement)->
            $("#labels").bind "click", (event)->
                event.stopPropagation()
            $("#labels").removeClass "invisible"
            pos = $(anchorElement).offset()
            $("#labels").css( { left: pos.left + "px", top: pos.top + "px" } )

        labelDropdownDisable: ()->
            $("#labels").addClass "invisible"
            $("#labels").bind "click", ()->  # CLEAR
            
            
        run: ->
            @loadResources =>
                
                # Declare views
                
                personlistview = new descanso.ResourceListView @resources.person
                personlistview.setTemplate {view: "tmpl-table", items: "tmpl-table-row"}
                
                personview = new descanso.ResourceView @resources.person
                personview.setTemplate "tmpl-person"
                
                entrylistview = new descanso.ResourceListView @resources.entry
                entrylistview.setTemplate {view: "tmpl-container", items: "tmpl-entry"}
                
                entryview = new descanso.ResourceView @resources.entry
                entryview.setTemplate "tmpl-entry"
                
                labellistview = new descanso.ResourceListView @resources.entrylabel
                labellistview.setTemplate {view: "tmpl-table", items: "tmpl-table-row"}

                labelview = new descanso.ResourceView @resources.entrylabel
                labelview.setTemplate "tmpl-label"
                
                
                # Declare event bindings
                
                refreshEntries = ()=>
                    @resources.entry.list {"person": personview.obj.id }, (obj_list)=>
                        console.log "Got entries"
                        entrylistview.bind obj_list
                        @renderView "#entrylist", entrylistview
                        
                        newentry = @resources.entry.empty()
                        newentry.person = personview.obj
                        entryview.bind newentry
                        @renderView "#new_entry", entryview
                        
                
                showPerson = (person)=>
                    personview.bind person
                    @renderView "#person", personview
                    refreshEntries()
                    
                    if person.portrait.file
                        $(".portrait").css({ 'background-image': "url('http://s3.amazonaws.com/unholster-promo/" + person.portrait.file+"')" })

                        
                personlistview.bindEvent "select", (args)=>
                    console.log "Selected person"
                    showPerson args.view.obj
                    
                personlistview.bindEvent "add", (args)->
                    console.log "Adding person"
                    showPerson args.view.resource.empty()

                personview.bindEvent "formChanged", (args)=>
                    personview.submit()
                    
                personview.bindEvent "attach", (args)=>
                    console.log "Attaching file"
                    onupload = (res)=>
                        #$(".portrait input[name=id]").attr "value", res.id
                        personview.obj.portrait = { id: res.id }
                        personview.submit()
                    args.view.elem.upload args.extra.url, onupload, "json"
                    
                personview.bindEvent "submitted", (args)=>
                    console.log "Submitted"
                    #showPerson args.view.obj
                    @resources.person.list (obj_list) =>
                        console.log "Refreshing personlist"
                        personlistview.bind obj_list
                        @renderView "#personlist", personlistview
                        
                entryview.bindEvent "chooseLabel", (args)=>
                    console.log "Choosing label on new entry"
                    args.domEvent.stopPropagation()
                    @labelDropdownEnable args.domEvent.srcElement 
                    labellistview.target = entryview
                    
                entrylistview.bindEvent "chooseLabel", (args)=>
                    console.log "Choosing label on entrylist"
                    args.domEvent.stopPropagation()
                    @labelDropdownEnable args.domEvent.srcElement 
                    labellistview.target = args.view
                    
                entrylistview.bindEvent "submitted", (args)=>
                    refreshEntries()

                entryview.bindEvent "changed", (args)->
                    entryview.submit()
                    refreshEntries()
                    
                entryview.bindEvent "submitted", (args)=>
                    refreshEntries()
                        
                entrylistview.bindEvent "changed", (args)->
                    console.log "Entrylist: object changed"
                    args.view.submit()
                    refreshEntries()
                    

                
                labellistview.bindEvent "select", (args)=>
                    console.log "Label chosen"
                    labellistview.target.obj.label = args.view.obj
                    labellistview.target.submit()
                    @labelDropdownDisable()
                    
                labelview.bindEvent "changed", (args)=>
                    console.log "Label form changed"
                    labelview.submit()
                
                
                
                refreshLabels= ()=>
                    @resources.entrylabel.list (obj_list) =>
                        labellistview.bind obj_list
                        labelview.bind @resources.entrylabel.empty()

                        console.log "Entry labels"
                        @renderView "#labellist", labellistview
                        @renderView "#new_label", labelview

                        @resources.person.list (obj_list) =>
                            personlistview.bind obj_list
                            @renderView "#personlist", personlistview

                        $("body").bind "click", (event)=>
                            @labelDropdownDisable()
                            
                refreshLabels()

                
    return { "App": App }
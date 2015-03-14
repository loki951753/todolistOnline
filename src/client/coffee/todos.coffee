###
 重写Backbone.sync
###
window.onload = ->
	Backbone.sync = (method, model, options) ->
		options ?= {}
		switch method
			when 'create'
				window.sgxw.ajax 
					url:model.urlRoot
					type:'POST'
					data:model.attributes
					success:options.success
			when 'update'
				window.sgxw.ajax
					url:model.urlRoot + '/' + model.id
					type:"PUT"
					data:model.attributes
					success:options.success					
			when 'delete'
				window.sgxw.ajax
					url:model.urlRoot + '/' + model.attributes.order
					type:"DELETE"
					success:options.success					
			when 'read'
				window.sgxw.ajax
					url:model.url
					type:"GET"
					success:options.success
		return						
		
	Todo = Backbone.Model.extend
		urlRoot: '/todo'
		# Default attributes for the todo item
		defaults: -> 
			title:'empty todo...'
			order:Todos.nextOrder()
			done:false

		#Toggle the `done` state of this todo item
		toggle: ->
			this.save {done:!this.get 'done'}
			return

	###
	 Todo Collection
	 The collection of todos is backed by *localStorage* instead of a remote
	 server.
	###
	TodoList = Backbone.Collection.extend 
		url: '/todos/'

		# Reference to this collection's model.
		model: Todo

		# Filter down the list of all todo items that are finished.
		done: -> this.where done:true

		# Filter down the list to only todo items that are still not finished.
		remaining: -> this.where done:false

		nextOrder: ->
			return 1 if !this.length
			return this.last().get('order') + 1

		# Todos are sorted by their original insertion order.
		comparator: 'order'
	

	# Create our global collection of **Todos**.
	Todos = new TodoList;

	# Todo Item View
	# --------------

	# The DOM element for a todo item...
	TodoView = Backbone.View.extend
		# ... is a list tag
		tagName: 'li'

		# Cache the template function for a single item.
		template: _.template($('#item-template').html())

		# The DOM events specific to an item.
		events: 
	    	"click .toggle"   : "toggleDone"
	    	"dblclick .view"  : "edit"
	    	"click a.destroy" : "clear"
	    	"keypress .edit"  : "updateOnEnter"
	    	"blur .edit"      : "close"

	    initialize: ->
	    	@.listenTo(@.model, 'change', @.render)
	    	@.listenTo(@.model, 'destroy', @.remove)
	    	return

		# Re-render the titles of the todo item.
    	render: ->
    		@.$el.html(@.template(@.model.toJSON()))
    		@.$el.toggleClass('done', @.model.get('done'))
    		@.input = @.$ '.edit'
    		this

		# Toggle the `"done"` state of the model.
		toggleDone: ->
			@.model.toggle()
			return

		# Switch this view into `"editing"` mode, displaying the input field.
		edit: ->
			@.$el.addClass 'editing'
			@.input.focus()
			return

		# Close the `"editing"` mode, saving changes to the todo.
		close: ->
			value = this.input.val()
			if !value 
				@.clear()
			else
				@.model.save title:value
				@.$el.removeClass 'editing'
			return

		# If you hit `enter`, we're through editing the item.
		updateOnEnter: (e) ->
			@.close() if e.keyCode is 13
			return

		# Remove the item, destroy the model.
		clear: ->
			@.model.destroy()
			return

	# The Application
	# ---------------
	# Our overall **AppView** is the top-level piece of UI.
	AppView = Backbone.View.extend
		el: $('#todoapp')
		
		statsTemplate: _.template($('#stats-template').html())

		events:
	      "keypress #new-todo":  "createOnEnter",
	      "click #clear-completed": "clearCompleted",
	      "click #toggle-all": "toggleAllComplete"

	    initialize: ->
	    	@.input = @.$ "#new-todo"
	    	@.allCheckbox = @.$('#toggle-all')[0] 

	    	@.listenTo Todos, 'add', @.addOne
	    	@.listenTo Todos, 'reset', @.addAll
	    	@.listenTo Todos, 'all', @.render

	    	@.footer = @.$ 'footer'
	    	@.main = $ '#main'

	    	Todos.fetch()
	    	return

	    render: ->
	    	done = Todos.done().length
	    	remaining = Todos.remaining().length

	    	if Todos.length
	    		@.main.show()
	    		@.footer.show()
	    		@.footer.html @.statsTemplate({done: done, remaining: remaining})
	    	else
	    		@.main.hide()
	    		@.footer.hide()

	    	@.allCheckbox.checked = !remaining
	    	return

	    addOne:(todo) ->
	    	view = new TodoView model:todo
	    	@.$("#todo-list").append(view.render().el)
	    	return

	    addAll:->
	    	Todos.each(@.addOne, @)
	    	return

	    createOnEnter:(e)->
	    	return null if e.keyCode isnt 13
	    	return null if !@.input.val()

	    	Todos.create title:@.input.val()
	    	@.input.val ''
	    	return

	    clearCompleted:->
	    	_.invoke Todos.done(), 'destroy'
	    	false

	    toggleAllComplete:->
	    	done = @.allCheckbox.checked
	    	Todos.each (todo)->
	    		todo.save 'done':done
	    		return
	    	return

	# Finally, we kick things off by creating the **App**.
	App = new AppView

	return
express = require 'express'
bodyParser = require 'body-parser'
app = express()
app.use express.static(__dirname + '/public')

app.set 'public', __dirname+'/public'
app.engine 'html', require('ejs').renderFile
app.set 'view engine', 'ejs'

app.use bodyParser.json()
app.use bodyParser.urlencoded extended:false

todoFSApi = require './lib/todoFSApi'
util = require './lib/util'

app.get '/', (req, res)->
	res.render 'index.html'
	return

app.get '/todos/', (req, res)->
	res.send todoFSApi.get()
	return

app.post '/todo', (req, res)->
	res.send todoFSApi.post req.body if !util.isEmptyObject req.body
	return

app.put '/todo/:order', (req, res)->
	res.send todoFSApi.put req.body if !util.isEmptyObject req.body
	return

app.delete '/todo/:orderId', (req, res)->
	res.send todoFSApi.delete req.params.orderId
	return

server = app.listen 80, ->
	return
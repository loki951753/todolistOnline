fs = require 'fs'
dataPath = './data/data.json'

exports.get = ->
	fs.readFileSync dataPath, 'utf8'

exports.post = (item) ->
	fileContent = fs.readFileSync dataPath, 'utf8'
	todoArray = JSON.parse fileContent

	return null for oldItem in todoArray when oldItem.order is item.order

	#用文件操作无法像数据库那样生成唯一id
	#这里用客户端传来的order
	item.id = item.order
	todoArray.push item

	fileContent = JSON.stringify todoArray
	fs.writeFile dataPath, fileContent, (err)->
		throw err if err
		console.log "Item's saved!"
		return

	return null

exports.put = (item) ->
	fileContent = fs.readFileSync(dataPath,'utf8');
	todoArray = JSON.parse(fileContent);

	for i in [0..todoArray.length-1] by 1
		if todoArray[i].order is item.order
			todoArray[i] = item
			
			fileContent = JSON.stringify todoArray
			fs.writeFile dataPath, fileContent, (err)->
				throw err if err
				console.log "Item's updated!"
				return
	return null

exports.delete = (id) ->
	fileContent = fs.readFileSync(dataPath,'utf8');
	todoArray = JSON.parse(fileContent);

	for i in [0..todoArray.length-1] by 1
		if todoArray[i].order is parseInt id
			todoArray.splice i, 1
			
			fileContent = JSON.stringify todoArray
			fs.writeFile dataPath, fileContent, (err)->
				throw err if err
				console.log "Item's delete!"
			break
	return null
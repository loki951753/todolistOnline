###
  一个粗陋的小插件, 利用闭包实现一个单例，全部都是静态函数，本身不维护任何信息
  sgxw ： shi guang xiao wu
  1.完成部分功能函数
  2.完成ajax操作
  3.暴露给window，用IIFE包裹整个插件
###
(( window ) -> 
  createAjax = ->
    try xhr = new XMLHttpRequest()
    catch e
    	console.log '浏览器不支持ajax'
    	return

  sgxw = ( ->
  	{
	  ajax : (options) ->
	          options ?= {}
	          options.type ?= "GET"
	          options.dataType ?= "json"
	          options.contentType ?= "application/json"
	          options.data ?= null
	          return null if !options.url?
	          xhr = createAjax()
	          #暂不考虑同步
	          xhr.open(options.type, options.url, true)

	          switch options.type
	            when "GET", "DELETE"
	              xhr.send()
	            when "POST", "PUT"
	              xhr.setRequestHeader("Content-Type", options.contentType)
	              xhr.send JSON.stringify(options.data)

	          xhr.onreadystatechange = ->
	            if xhr.readyState is 4 and xhr.status is 200
	              if xhr.responseText and xhr.responseText.toUpperCase() isnt'NONE'
	                response = JSON.parse xhr.responseText
	                options.success && options.success response
	              else
	                options.fail && options.fail response
	            
	            return

	          return
	}
  )()

  window.sgxw = sgxw

  return
)( @ )
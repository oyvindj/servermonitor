restify = require("restify")
db_helper = require("./db-helper.js")
fs = require('fs')
index = fs.readFileSync('index.html')

server = restify.createServer()
server.use restify.bodyParser()
			
getIndex = (req, res, next) ->
  console.log 'getting index.html...'
  res.writeHead(200, {'Content-Type': 'text/html'})
  res.end(index)

foos = [{name: 'Aaaa'},{name: 'Bbb'}]
getFoos = (req, res, next) ->
  res.send foos

createHTML = (foos) ->
  html = '<html><body><table border="1">'
  html = html + '<tr><td>Found' + foos.length + ' items</td></tr>'
  for item in foos
    html = html + '<tr>'
    html = html + '<td>' + item.name + '</td>'
    html = html + '</tr>'
  html = html + '</table></body></html>'
  return html

getBars = (req, res, next) ->
  db_helper.get_employees((result) ->
    console.log 'got mysql result'
    console.log result
    html = createHTML(result)
    res.writeHead(200, {
      'Content-Length': Buffer.byteLength(html),
      'Content-Type': 'text/html'
    })
    res.write(html)
    res.end()
  )

postFoo = (req, res, next) ->
  console.log 'postFoo: ' + req
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Access-Control-Allow-Headers", "X-Requested-With")
  params = req.params
  db_helper.add_employee(params, (lastId) ->
    console.log 'added employee with id: ' + lastId
    res.send(200, 'Added ' + params.name + ' with id ' + lastId)
    res.end()
    return next()
  )

server.get "/foos", getFoos
server.post "/foo", postFoo
server.get "/bars", getBars
server.get "/", getIndex

server.listen 8087, ->
  console.log "%s listening at %s", server.name, server.url


mysql = require('mysql')
MYSQL_USERNAME = 'demo'
MYSQL_PASSWORD = 'demo'
 
client = mysql.createConnection({
  host: 'localhost'
  user: MYSQL_USERNAME
  password: MYSQL_PASSWORD
})

client.query('USE servermonitor')
      
exports.add_employee = (data, callback) ->
  cols = []
  cols.push 'name'
  cols.push 'salary'
  insert(data, 'employees', cols, callback)
                 
exports.get_employees = (callback) ->
   select('employees', callback)

select = (table, callback) ->
   client.query("select * from " + table, (err, results, fields) ->
      callback(results)
   )

insert = (data, table, cols, callback) ->
  q = 'insert into ' + table + '('
  i = 0
  for col in cols
    if(i++ < (cols.length - 1))
      q = q + col + ','
    else
      q = q + col
  q = q + ') values ('
  i = 0
  for col in cols
    if(i++ < (cols.length - 1))
      q = q + '?,'
    else
      q = q + '?'
  q = q + ')'
  values = []
  i = 0
  for col in cols
    values[i++] = data[col]

  client.query(q, values, (err, info) ->
    callback(info.insertId)
  )

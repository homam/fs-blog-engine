var fs = require('fs'); 
var readme = fs.readFileSync('./README.md', 'utf8'); 
var now = new Date().valueOf();
fs.writeFileSync('./store.json', 
	JSON.stringify([{_id: now, _dateCreated: now, _dateLastUpdated: now, title: 'Welcome!', header: '', body: readme}], null, 4), 'utf8')
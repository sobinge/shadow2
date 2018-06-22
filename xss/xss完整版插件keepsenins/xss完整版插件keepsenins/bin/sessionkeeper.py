#!/usr/bin/python
#filename:sessionkeeper.py
#Author:error
import sys, os, MySQLdb, httplib, threading, re, time, string
webroot = os.path.abspath('..')
print webroot
configfile = webroot + '/config.php'
cachedir = webroot + '/cache/'
if not os.path.exists(configfile):
	print configfile,'Not Found.'
	sys.exit()
if not os.path.exists(cachedir):
	os.makedirs(cachedir)
	if os.path.exists(cachedir):
		print cachedir, 'created.'
	else:
		print cachedir,'Not Found.'
		sys.exit()
config = open(configfile).read()
m = re.findall("(db[a-z]+)\s*=\s*'([^']*)'", config)
dbhost = m[0][1]
dbuser = m[1][1]
dbpass = m[2][1]
dbname = m[3][1]
print dbhost, dbuser, dbpass, dbname
conn = MySQLdb.connect(dbhost, dbuser, dbpass)
conn.select_db(dbname)
cursor = conn.cursor(MySQLdb.cursors.DictCursor)

class sessionkeeper(threading.Thread):
	def __init__(self,xssinfo):
		threading.Thread.__init__(self)
		self.info = xssinfo
	def sk(self):
		url_list = self.info['location'].replace('http://','').replace('https://','').split('/')
		host = url_list[0]
		path = ('/'+string.join(url_list[1:],'/')).replace('//','/')
		#print host, path
		try:
			h = httplib.HTTPConnection(host)
			header = {'Content-Type':'application/x-www-form-urlencoded', 'x-forwarded-for':'%s'%self.info['ip'], 'User-Agent':'%s'%self.info['agent'], 'Cookie':'%s'%self.info['cookie'], 'Referer':'%s'%self.info['referer']}
			h.request('GET',path,'',header)
			httpres1 = h.getresponse()
			resp = httpres1.read()
		except BaseException:
			resp = 'Null'
		filename = cachedir + '%s.txt'%self.info['iid']
		file_object = open(filename, 'w')
		headers = httpres1.getheaders()
		for header in headers:
			print '%s %s'%(header)
			file_object.write('%s: %s\n'%(header))
		file_object.write('\n\n')
		file_object.write(resp)
		file_object.close()
		print '%s'%httpres1.status
		sql = "UPDATE `xg_info` SET sk_status='%s' WHERE iid=%d"%(httpres1.status, self.info['iid'])
		cursor.execute(sql)
		h.close()
		httpres1.close()
	def run(self):
		self.sk()

while True:
	count = cursor.execute("SELECT * FROM `xg_info` d JOIN `xg_browser` n JOIN `xg_project` m ON d.bid=n.bid where m.sessionkeeper=1 and m.pid=n.pid")
	if count > 0:
		threads = []
		rows = cursor.fetchall()
		for row in rows:
			print row
			threads.append(sessionkeeper(row))
		for thread in threads:
			thread.start()
	time.sleep(60)

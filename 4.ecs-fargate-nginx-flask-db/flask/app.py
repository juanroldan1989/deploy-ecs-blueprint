from flask import Flask
import mysql.connector as mariadb

class DBManager:
  def __init__(self, database="example", host="db", user="root", password_file=None):
    pf = open(password_file, 'r')
    self.connection = mariadb.connect(
      user=user,
      password=pf.read(),
      host=host, # name of the mysql service as set in the docker compose file
      database=database,
      auth_plugin='mysql_native_password'
    )
    pf.close()
    self.cursor = self.connection.cursor()

  def populate_db(self):
    self.cursor.execute('DROP TABLE IF EXISTS blog')
    self.cursor.execute('CREATE TABLE blog (id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(255))')
    self.cursor.executemany('INSERT INTO blog (id, title) VALUES (%s, %s);', [(i, 'Blog post #%d'% i) for i in range (1,5)])
    self.connection.commit()

  def query_titles(self):
    self.cursor.execute('SELECT title FROM blog')
    titles = []
    for c in self.cursor:
      titles.append(c[0])
    return titles

  def get_title(self, id):
    self.cursor.execute(f"SELECT title FROM blog WHERE id = {id}")
    titles = []
    for c in self.cursor:
      titles.append(c[0])
    return titles[0]

app = Flask(__name__)
conn = None

def get_db():
  global conn
  if not conn:
    conn = DBManager(password_file='/run/secrets/db-password')
    conn.populate_db()

  return conn

@app.route('/', methods=['GET'])
def list_titles():
  conn = get_db()
  titles = conn.query_titles()
  response = ''
  for title in titles:
    response = response  + '<h2>   Article  ' + title + '</h2>'
  return response

@app.route('/<int:title_id>', methods=['GET'])
def get_title(title_id):
  conn = get_db()
  title = conn.get_title(id=title_id)
  response = f"<h1> Article - {title} </h1>"
  return response

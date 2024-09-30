import os
from flask import Flask
import mysql.connector as mariadb

class DBManager:
  def __init__(self, host="db", database="example", user="root", password_file=None):
    try:
      with open(password_file, 'r') as pf:
        password = pf.read().strip()
    except FileNotFoundError:
      # TODO: implement KMS to provision DB password - "${aws::resource::kms}"
      password = 'db-78n9n'

    self.connection = mariadb.connect(
      host=os.getenv('DB_HOST', host),  # database service/container
      database=os.getenv('DB_NAME', database),
      user=os.getenv('DB_USER', user),
      password=password,
      auth_plugin='mysql_native_password'
    )
    pf.close()
    self.cursor = self.connection.cursor()

  def populate_db(self):
    self.cursor.execute('DROP TABLE IF EXISTS articles')
    self.cursor.execute('CREATE TABLE articles (id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(255))')
    self.cursor.executemany('INSERT INTO articles (id, title) VALUES (%s, %s);', [(i, 'Article post #%d'% i) for i in range (1,5)])
    self.connection.commit()

  def get_articles(self):
    self.cursor.execute('SELECT title FROM articles')
    titles = []
    for c in self.cursor:
      titles.append(c[0])
    return titles

  def get_article(self, id):
    self.cursor.execute(f"SELECT title FROM articles WHERE id = {id}")
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
def home():
  conn = get_db()
  titles = conn.get_articles()
  response = ''
  for title in titles:
    response = response  + '<h2>   Article  ' + title + '</h2>'
  return response

@app.route('/<int:title_id>', methods=['GET'])
def get_article(title_id):
  conn = get_db()
  title = conn.get_article(id=title_id)
  response = f"<h1> Article - {title} </h1>"
  return response

@app.route('/flask-health-check')
def flask_health_check():
	return "success"

from itemadapter import ItemAdapter
import mysql.connector


class BookvoedPipeline:
    def __init__(self):
        self.conn = mysql.connector.connect(
            host='${mysql_host}',
            user='crawler',
            password='123456pass',
            database='bookspider'
        )

        self.cur = self.conn.cursor()
        self.cur.execute('''
            create table if not exists books (
                id int not null auto_increment,
                name varchar(255) not null,
                price varchar(255) null,
                author varchar(255) null,
                PRIMARY KEY (id)
            )
        ''')


    def process_item(self, item, spider):
        spider.logger.warn('HEREHEREHERHERHE')
        # adapter = ItemAdapter(item)

        # # Extract data from item
        # name = adapter.get('name')
        # price = adapter.get('price')
        # author = adapter.get('author')

        # # Check if all required fields are present
        # if not name or not price or not author:
        #     raise ValueError("Missing required fields in item.")

        # Prepare SQL query to insert data
        sql_query = '''
            INSERT INTO books (name, price, author)
            VALUES (%s, %s, %s)
        '''
        
        # Insert item into the books table
        self.cur.execute(sql_query, (item['name'], item['price'], item['author']))
        
        # Commit the transaction
        self.conn.commit()

        # Optionally return the item to continue processing in the pipeline
        return item

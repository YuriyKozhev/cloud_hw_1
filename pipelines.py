from itemadapter import ItemAdapter
import mysql.connector


class BookvoedPipeline:
    def __init__(self):
        self.conn = mysql.connector.connect(
            host='${mysql_host}',
            user='${db_user_name}',
            password='${db_user_pass}',
            database='${db_name}'
        )
        self.cur = self.conn.cursor()

        self.cur.execute('''
            create table if not exists ${db_table_name} (
                id int not null auto_increment,
                name varchar(255) not null,
                price varchar(255) null,
                author varchar(255) null,
                primary key (id)
            )
        ''')

        self.insert_query = '''
            insert into ${db_table_name} (name, price, author)
            values (%s, %s, %s)
        '''


    def process_item(self, item, spider):
        spider.logger.warn('Inserting item in DB')

        self.cur.execute(self.insert_query, (item['name'], item['price'], item['author']))
        self.conn.commit()

        return item

    def close_spider(self, spider):

        ## Close cursor & connection to database 
        self.cur.close()
        self.conn.close()

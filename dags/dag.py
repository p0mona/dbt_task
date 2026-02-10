from airflow import DAG
from airflow.operators.dummy import DummyOperator
from airflow.operators.bash import BashOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.mysql.hooks.mysql import MySqlHook
from airflow.operators.python_operator import BranchPythonOperator
from settings import DEFAULT_ARGS
from dotenv import load_dotenv
from datetime import datetime
import os

load_dotenv()

def check_db(hook: object, db: str, sql: str) -> bool:
    result = hook.get_first(sql, parameters=(db, ) )
    return True if result else False
    
def check_and_decide() -> str:
    pagila = check_db(
        PostgresHook(postgres_conn_id='postgres_default', schema='postgres'),
        os.getenv('PGDB'),
        '''
            SELECT 1
            FROM pg_database
            WHERE datname LIKE %s;
        '''
    )

    sakila = check_db(
        MySqlHook(mysql_conn_id='mysql_default', schema='information_schema'),
        os.getenv('MYSQLDB'),
        '''
            SHOW DATABASES LIKE %s;
        '''
    )
    return 'create_dbs' if not pagila or not sakila else 'exist'

with DAG(
    dag_id="dbt_task",
    schedule=None,
    default_args=DEFAULT_ARGS,
    start_date=datetime(2026, 2, 5)
) as dag:
    check_task = BranchPythonOperator(
        task_id='branch_task',
        python_callable=check_and_decide
    )

    create_dbs = BashOperator(
        task_id='create_dbs',
        bash_command='''
            export PGPASSWORD=$PGPASS
            psql -h pagila -U $PGUSER -d postgres -c "CREATE DATABASE $PGDB;"
            psql -h pagila -U $PGUSER -d $PGDB -f /opt/airflow/pagila/pagila-schema.sql
            psql -h pagila -U $PGUSER -d $PGDB -f /opt/airflow/pagila/pagila-data.sql

            mysql -h sakila -u $MYSQLUSER -p$MYSQLPASS -e "CREATE DATABASE IF NOT EXISTS $MYSQLDB;"
            mysql -h sakila -u $MYSQLUSER -p$MYSQLPASS $MYSQLDB < /opt/airflow/sakila/sakila-schema.sql
            mysql -h sakila -u $MYSQLUSER -p$MYSQLPASS $MYSQLDB < /opt/airflow/sakila/sakila-data.sql
        '''
    )

    exist = DummyOperator(task_id="exist")

    check_task >> [exist, create_dbs]
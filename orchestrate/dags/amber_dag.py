import datetime

from airflow.decorators import dag
from operators.datacoves.dbt import DatacovesDbtOperator


@dag(
    default_args={
        "start_date": datetime.datetime(2023, 1, 1, 0, 0),
        "owner": "Amber Chiles",
        "email": "amber.chiles@doublegood.com",
        "email_on_failure": True,
        "retires": 3,
    },
    description="Daily dbt run",
    schedule="0 12 * * *",
    tags=["ac_transform"],
    catchup=False,
)
def amber_dag():
    run_dbt = DatacovesDbtOperator(task_id="run_dbt", bash_command="dbt run")


dag = amber_dag()

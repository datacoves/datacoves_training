import datetime

from airflow.decorators import dag, task


@dag(
    default_args={
        "start_date": datetime.datetime(2023, 1, 1, 0, 0),
        "owner": "Mayra Pena",
        "email": "mayra@example.com",
        "email_on_failure": True,
        "retries": 3,

    },
    description="Daily dbt run",
    schedule="0 12 * * *",
    tags=["version_1"],
    catchup=False,

)
def sample_dag():

    @task.datacoves_dbt(
        connection_id="main"
    )
    def run_dbt():
        return "dbt run -s my_model"

    run_dbt()

sample_dag()

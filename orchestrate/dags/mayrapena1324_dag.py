from airflow.decorators import dag
from operators.datacoves.dbt import DatacovesDbtOperator
from pendulum import datetime

@dag(
    default_args={
        "start_date": datetime(2023, 10, 10),
        "owner": "airflow",
        "email": "mayrapena1324@example.com",
        "email_on_failure": True,
    },

    catchup=False,
    tags = ["version_1"],
    description = "My first Airflow DAG",

    # This is a regular CRON schedule. Helpful resources
    # https://cron-ai.vercel.app/
    # https://crontab.guru/
    schedule_interval = "0 0 1 */12 *"
)
def mayrapena1324_sample_dag():

    # Calling dbt commands
    dbt_debug = DatacovesDbtOperator(
        task_id = "dbt_debug_task",
        bash_command = "dbt debug",
    )

    dbt_run = DatacovesDbtOperator(
        task_id = "dbt_run_task",
        bash_command = "dbt run --select +mayrapena1324_avg_by_grade",
    )

    # tells Airflow what order to run tasks in
    dbt_debug >> dbt_run


# Invoke Dag
dag = mayrapena1324_sample_dag()

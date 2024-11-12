import datetime
from airflow.decorators import dag, task
from operators.datacoves.dbt import DatacovesDbtOperator

@dag(
    default_args={
        "start_date": datetime.datetime(2023, 1, 1, 0, 0),
        "owner": "Noel Gomez",
        "email": "gomezn@example.com",
        "email_on_failure": True,
    },
    description="Sample DAG for dbt build",
    schedule_interval="0 0 1 */12 *",
    tags=["version_2"],
    catchup=False,
)
def sample_dag():

    @task
    def get_variable():
        from airflow.models import Variable
        # Fetch the variable from Airflow's Variables
        my_var = Variable.get("datacoves_mayras_secret")
        return my_var  # Return the value for downstream tasks

    fetched_variable = get_variable()

    # Task to run dbt using the DatacovesDbtOperator and pass the fetched variable
    @task
    def run_dbt_task(fetched_variable: str):
        # Use the fetched variable in the dbt command
        DatacovesDbtOperator(
            task_id="run_dbt",
            bash_command=f"dbt run -s personal_loans --vars '{{my_var: \"{fetched_variable}\"}}'"
        )

    run_dbt_task(fetched_variable)

dag = sample_dag()

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
def aws_dag():

    @task
    def get_aws_variable():
        from airflow.models import Variable
        # Fetches the variable, potentially making an AWS Secrets Manager API call
        aws_var = Variable.get("aws_mayras_secret")
        return aws_var

    @task
    def get_datacoves_variable():
        from airflow.models import Variable
        # Fetches the variable without an AWS Secrets Manager API call
        datacoves_var = Variable.get("datacoves_mayras_secret")
        return local_var

    aws_variable = get_aws_variable()
    my_variable = get_local_variable()

    # Task to run dbt using the DatacovesDbtOperator and pass the variables
    @task
    def run_dbt_task(aws_variable: str, my_variable: str):
        # Use the fetched variables in the dbt command
        DatacovesDbtOperator(
            task_id="run_dbt",
            bash_command=f"dbt run -s personal_loans --vars '{{my_aws_variable: \"{aws_variable}\", my_variable: \"{my_variable}\"}}'"
        )


dag = aws_dag()

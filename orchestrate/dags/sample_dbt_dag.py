"""
## dbt DAG Example
This DAG illustrates how to run dbt in Airflow
"""

from airflow.decorators import dag, task
from orchestrate.utils import datacoves_utils

@dag(
    doc_md = __doc__,
    catchup = False,

    default_args = datacoves_utils.set_default_args(
        owner = "Noel Gomez",
        owner_email = "noel@example.com"
    ),

    description="Airflow Variables Sample DAG",
    schedule = datacoves_utils.set_schedule("0 0 1 */12 *"),
    tags=["transformation"],
)
def sample_dbt_dag():

    @task.datacoves_dbt(
        connection_id="main"
    )
    def run_dbt():
        return "dbt debug"

    run_dbt()

sample_dbt_dag()

from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.decorators import dag
import datetime
from operators.datacoves.dbt import DatacovesDbtOperator
from airflow.decorators import task_group
@dag(
  default_args={'start_date': '2023-01'},
  description="Personal Loan Average",
  schedule_interval="0 0 1 */12 *",
  tags=['version_1'],
  catchup=False
)
def yml_dag():
    @task_group(group_id='extract_and_load_airbyte', tooltip='Airbyte Extract and Load')
    def extract_and_load_airbyte():
    tg_extract_and_load_airbyte = extract_and_load_airbyte()
    transform = DatacovesDbtOperator(
    task_id='transform',
      bash_command="dbt build -s 'tag:daily_run_airbyte+ -t prd'"
    )
    transform.set_upstream([tg_extract_and_load_airbyte])
dag = yml_dag()

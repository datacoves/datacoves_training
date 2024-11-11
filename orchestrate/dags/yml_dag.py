import datetime

from airflow.decorators import dag, task_group
from airflow.providers.airbyte.operators.airbyte import \
    AirbyteTriggerSyncOperator
from operators.datacoves.dbt import DatacovesDbtOperator


@dag(
    default_args={"start_date": "2023-01"},
    description="Personal Loan Average",
    schedule_interval="0 0 1 */12 *",
    tags=["version_1"],
    catchup=False,
)
def yml_dag():
    @task_group(group_id="extract_and_load_airbyte", tooltip="Airbyte Extract and Load")
    def extract_and_load_airbyte():
        country_populations_datacoves_train = AirbyteTriggerSyncOperator(
            task_id="country_populations_datacoves_train",
            connection_id="676575f7-22d7-41f4-ab78-52099d8cbccb",
            airbyte_conn_id="airbyte_connection",
        )
        personal_loans_datacoves_train = AirbyteTriggerSyncOperator(
            task_id="personal_loans_datacoves_train",
            connection_id="04b4fc09-bc22-4d19-b457-2d1fe84fbd40",
            airbyte_conn_id="airbyte_connection",
        )

    tg_extract_and_load_airbyte = extract_and_load_airbyte()
    transform = DatacovesDbtOperator(
        task_id="transform", bash_command="dbt build -s 'tag:daily_run_airbyte+ -t prd'"
    )
    transform.set_upstream([tg_extract_and_load_airbyte])


dag = yml_dag()

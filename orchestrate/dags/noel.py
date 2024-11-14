import datetime

from airflow.decorators import dag, task_group
from airflow.providers.airbyte.operators.airbyte import \
    AirbyteTriggerSyncOperator
from operators.datacoves.dbt import DatacovesDbtOperator


@dag(
    default_args={
        "start_date": datetime.datetime(2023, 1, 1, 0, 0),
        "owner": "Noel Gomez",
        "email": "noel@example.com",
        "email_on_failure": True,
    },
    description="Personal Loan Average",
    schedule_interval="0 0 1 */12 *",
    tags=["version_1"],
    catchup=False,
)
def noel():
    @task_group(group_id="extract_and_load_airbyte", tooltip="Airbyte Extract and Load")
    def extract_and_load_airbyte():
        country_populations_datacoves_train = AirbyteTriggerSyncOperator(
            task_id="country_populations_datacoves_train",
            connection_id="676575f7-22d7-41f4-ab78-52099d8cbccb",
            airbyte_conn_id="airbyte_connection",
        )
        noel_source_datacoves_train = AirbyteTriggerSyncOperator(
            task_id="noel_source_datacoves_train",
            connection_id="c94c67bd-63dd-47d5-a117-e7544eee50f5",
            airbyte_conn_id="airbyte_connection",
        )

    tg_extract_and_load_airbyte = extract_and_load_airbyte()
    transform = DatacovesDbtOperator(
        task_id="transform", bash_command="dbt build -s 'tag:daily_run_airbyte+ -t prd'"
    )
    transform.set_upstream([tg_extract_and_load_airbyte])


dag = noel()

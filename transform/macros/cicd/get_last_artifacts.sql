{# Macro for returning dbt manifest from a snowflake stage. #}
{#
    dbt run-operation get_last_artifacts
    #}
{# Once this is completed, deferral and state modifiers are available using --state logs #}

{% macro get_last_artifacts() %}
    {# Fallback variable used to run/debug macro in vscode #}
    {% set stage_name = 'RAW.DBT_ARTIFACTS.ARTIFACTS' %}

    {# We will put the manifest.json in the log directory and use it with the --state param in dbt #}
    {% set logs_dir = env_var('DATACOVES__DBT_HOME') ~ "/logs/" %}

    {# List only the .json files in the root folder (excludes archive dir) #}
    {% set list_stage_query %}
        LIST @{{ stage_name }} PATTERN = '^((?!(archive/)).)*.json$';
    {% endset %}

    {{ print("\nCurrent items in stage " ~ stage_name) }}
    {% set results = run_query(list_stage_query) %}
    {{ results.exclude('md5').print_table(max_column_width=40) }}
    {{ print("\n" ~ "="*85) }}

    {% if results and results.rows %}

        {% set artifacts_destination =  "file://" + logs_dir %}

        {# Download and print manifest.json #}
        {% set get_manifest_query %}
            get @{{ stage_name }}/manifest.json {{ artifacts_destination }};
        {% endset %}
        {% set download_manifest_results = run_query(get_manifest_query) %}x
        {{ print("Manifest Downloaded") }}
        {{ download_manifest_results.print_table(max_column_width=40) }}

        {# Download and print catalog.json #}
        {% set get_catalog_query %}
            get @{{ stage_name }}/catalog.json {{ artifacts_destination }};
        {% endset %}
        {% set download_catalog_results = run_query(get_catalog_query) %}
        {{ print("Catalog Downloaded") }}
        {{ download_catalog_results.print_table(max_column_width=40) }}

    {% else %}
        {{ print("No artifacts found in stage " ~ stage_name ~ ". Skipping file download.") }}
    {% endif %}

{% endmacro %}

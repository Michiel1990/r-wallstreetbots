{{ config(
    indexes=[
      {'columns': ['date_day'], 'unique': True}
    ]
) }}
{{ dbt_date.get_date_dimension("1999-11-01", "2030-12-31") }}
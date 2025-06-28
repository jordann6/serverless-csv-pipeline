from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

sc = SparkContext()
glueContext = GlueContext(sc)
job = Job(glueContext)
job.init("csv-etl-job", {})

datasource = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    format="csv",
    connection_options={"paths": ["s3://csv-processed-data-proj/"]},
    format_options={"withHeader": True}
)

glueContext.write_dynamic_frame.from_options(
    frame=datasource,
    connection_type="s3",
    format="parquet",
    connection_options={"path": "s3://csv-final-data-proj/"}
)

job.commit()

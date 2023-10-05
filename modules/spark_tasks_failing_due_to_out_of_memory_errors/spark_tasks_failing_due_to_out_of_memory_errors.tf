resource "shoreline_notebook" "spark_tasks_failing_due_to_out_of_memory_errors" {
  name       = "spark_tasks_failing_due_to_out_of_memory_errors"
  data       = file("${path.module}/data/spark_tasks_failing_due_to_out_of_memory_errors.json")
  depends_on = [shoreline_action.invoke_spark_configuration_check,shoreline_action.invoke_spark_memory_update]
}

resource "shoreline_file" "spark_configuration_check" {
  name             = "spark_configuration_check"
  input_file       = "${path.module}/data/spark_configuration_check.sh"
  md5              = filemd5("${path.module}/data/spark_configuration_check.sh")
  description      = "Insufficient memory allocation for Spark tasks."
  destination_path = "/agent/scripts/spark_configuration_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "spark_memory_update" {
  name             = "spark_memory_update"
  input_file       = "${path.module}/data/spark_memory_update.sh"
  md5              = filemd5("${path.module}/data/spark_memory_update.sh")
  description      = "Increase the memory allocation for the Spark executor. This can be done by adjusting the "
  destination_path = "/agent/scripts/spark_memory_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_spark_configuration_check" {
  name        = "invoke_spark_configuration_check"
  description = "Insufficient memory allocation for Spark tasks."
  command     = "`chmod +x /agent/scripts/spark_configuration_check.sh && /agent/scripts/spark_configuration_check.sh`"
  params      = ["MEMORY_SIZE_FOR_EACH_SPARK_EXECUTOR","URL_OF_SPARK_MASTER","MEMORY_SIZE_FOR_THE_SPARK_DRIVER","SPARK_HOME"]
  file_deps   = ["spark_configuration_check"]
  enabled     = true
  depends_on  = [shoreline_file.spark_configuration_check]
}

resource "shoreline_action" "invoke_spark_memory_update" {
  name        = "invoke_spark_memory_update"
  description = "Increase the memory allocation for the Spark executor. This can be done by adjusting the "
  command     = "`chmod +x /agent/scripts/spark_memory_update.sh && /agent/scripts/spark_memory_update.sh`"
  params      = ["NEW_MEMORY_ALLOCATION","PATH_TO_SPARK_CONFIGURATION_FILE"]
  file_deps   = ["spark_memory_update"]
  enabled     = true
  depends_on  = [shoreline_file.spark_memory_update]
}


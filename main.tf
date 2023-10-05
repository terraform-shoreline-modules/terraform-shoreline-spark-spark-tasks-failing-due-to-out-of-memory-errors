terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "spark_tasks_failing_due_to_out_of_memory_errors" {
  source    = "./modules/spark_tasks_failing_due_to_out_of_memory_errors"

  providers = {
    shoreline = shoreline
  }
}
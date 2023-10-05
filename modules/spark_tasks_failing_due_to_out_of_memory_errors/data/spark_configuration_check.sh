

#!/bin/bash



# Define variables

SPARK_HOME=${SPARK_HOME}

SPARK_MASTER_URL=${URL_OF_SPARK_MASTER}

SPARK_EXECUTOR_MEMORY=${MEMORY_SIZE_FOR_EACH_SPARK_EXECUTOR}

SPARK_DRIVER_MEMORY=${MEMORY_SIZE_FOR_THE_SPARK_DRIVER}



# Check memory allocation configuration

echo "Checking memory allocation configuration..."

if grep -q "spark.executor.memory" $SPARK_HOME/conf/spark-defaults.conf && grep -q "spark.driver.memory" $SPARK_HOME/conf/spark-defaults.conf; then

  echo "Memory allocation configuration is already set."

else

  echo "Memory allocation configuration is not set. Setting configuration..."

  echo "spark.executor.memory $SPARK_EXECUTOR_MEMORY" >> $SPARK_HOME/conf/spark-defaults.conf

  echo "spark.driver.memory $SPARK_DRIVER_MEMORY" >> $SPARK_HOME/conf/spark-defaults.conf

fi



# Check Spark cluster status

echo "Checking Spark cluster status..."

if $SPARK_HOME/bin/spark-submit --master $SPARK_MASTER_URL --class org.apache.spark.examples.SparkPi $SPARK_HOME/examples/jars/spark-examples_2.11-2.4.0.jar 10; then

  echo "Spark cluster is running."

else

  echo "Spark cluster is not running. Please check the Spark cluster status."

fi



# Check Spark task status

echo "Checking Spark task status..."

if $SPARK_HOME/bin/spark-submit --master $SPARK_MASTER_URL --class org.apache.spark.examples.SparkPi --num-executors 1 --executor-memory $SPARK_EXECUTOR_MEMORY --driver-memory $SPARK_DRIVER_MEMORY $SPARK_HOME/examples/jars/spark-examples_2.11-2.4.0.jar 10; then

  echo "Spark task is running with the allocated memory."

else

  echo "Spark task is failing due to insufficient memory allocation. Please increase memory allocation for Spark tasks."

fi
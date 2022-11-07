/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

variable "kinesis_stream_name" {
  type = string
  default = "s3-camel-test-123"
}


data "aws_caller_identity" "current" {}

# Create a new Kinesis Stream
resource "aws_kinesis_stream" "MyKinesisStream" {
  name = var.kinesis_stream_name
  shard_count = 1
  
  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}

output "Kinesis-stream" {
  value       = aws_kinesis_stream.MyKinesisStream.id
  description = "The Kinesis Stream"
}
	

#!/bin/bash -
echo terraform fmt -recursive
terraform fmt -recursive
echo error-level:$?
echo 
echo terraform fmt -recursive -check
terraform fmt -recursive -check
echo error-level:$?
echo 
echo terraform validate
terraform validate
echo error-level:$?
echo 
echo tflint
tflint
echo error-level:$?
echo 

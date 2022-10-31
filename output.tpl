Follow the steps on your terminal to start testing:

1. export BOUNDARY_ADDR=${b_addr}
2. boundary authenticate password -auth-method-id ${b_auth_id} -login-name ${b_auth_user} 
2. boundary connect ssh -target-id ${b_target_id}
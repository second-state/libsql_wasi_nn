#!/bin/sh

cargo wasi build --release

wasmedgec target/wasm32-wasi/release/wasi_nn_udf.wasm wasi_nn_udf.aot.wasm

FUNC_NAME='classify'
echo "DROP FUNCTION IF EXISTS ${FUNC_NAME};" > create_${FUNC_NAME}_udf.sql
echo -n "CREATE FUNCTION ${FUNC_NAME} LANGUAGE wasm AS X'" >> create_${FUNC_NAME}_udf.sql
xxd -p wasi_nn_udf.aot.wasm | tr -d "\n" >> create_${FUNC_NAME}_udf.sql 
echo "';" >> create_${FUNC_NAME}_udf.sql
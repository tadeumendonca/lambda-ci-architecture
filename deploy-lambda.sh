#!/bin/bash

if [[ "$CODEBUILD_SRC_DIR" ==  "" ]] ; then
    echo "Ocorreu um erro ao obter o valor da variavel CODEBUILD_SRC_DIR. Verifique se esta executando na instancia do code build."
    exit 1
fi

WORK_DIR=$CODEBUILD_SRC_DIR
echo "WORKDIR = ${WORK_DIR}"

# Navegando p/ diretório com codigo das funções.
cd ${WORK_DIR}/src
if [[ $? -ne 0 ]] ; then
    echo "Ocorreu um erro ao navegar para o diretório raiz do codigo."
    exit 1
fi

for FUNC in $(ls) 
do
    function_name="lambda-arch-${FUNC}"
    function_pkg_path="${WORK_DIR}/deploy/${FUNC}.zip"
    function_pkg_file="${FUNC}.zip"
    function_dir="${WORK_DIR}/src/${FUNC}"

    echo "/****************  INICIO ${function_name} ****************/"
    echo "FUNCTION_NAME     = ${function_name}"
    echo "FUNCTION_DIR      = ${function_dir}"
    echo "FUNCTION_PKG_PATH = ${function_pkg_path}"
    echo "FUNCTION_PKG_FILE = ${function_pkg_file}"

    # Navegando p/ diretório da funcao
    cd "${function_dir}"
    if [[ $? -ne 0 ]] ; then
        echo "Ocorreu um erro ao navegar para o diretório raiz da funcao."
        exit 1
    fi

    # Instalando dependencias
    npm install
    if [[ $? -ne 0 ]] ; then
        echo "Ocorreu um erro ao instalar dependencias no diretório raiz da funcao."
        exit 1
    fi

    # Empacotando código das funções para deploy.
    zip -r "${function_pkg_path}" *
    if [[ $? -ne 0 ]] ; then
        echo "Ocorreu um erro ao compactar o diretório raiz da funcao."
        exit 1
    fi

    # Atualizando lambda.
    aws lambda update-function-code --function-name "${function_name}" --zip-file "fileb://${function_pkg_path}"
    if [[ $? -ne 0 ]] ; then
        echo "Ocorreu um erro ao realizar atualizacao de codigo da funcao."
        exit 1
    fi

    # Atualizando artefato.
    aws s3 cp ${WORK_DIR}/deploy/${function_pkg_file} s3://$LAMBDA_DEPLOY_BUCKET/${function_pkg_file}
    if [[ $? -ne 0 ]] ; then
        echo "Ocorreu um erro ao realizar upload do artefato de codigo da funcao."
        exit 1
    fi
    echo "/****************  FIM ${function_name} ****************/"
done

exit 0
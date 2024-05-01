#!/bin/bash

SECRET_CONFIG=postgresql-secret.yaml
CONFIG_MAP_CONFIG=app-config-map.yaml
POSTGRES_VOLUME=postgres-deploy-pv.yaml
POSTGRES_VOLUME_CLAIM=postgres-deploy-pvc.yaml
POSTGRES_MANIFEST_SCRIPT=postgresql-deploy.yaml
POSTGRES_SERVICE_CONFIG=postgresql-service.yaml
JAVA_APP_MANIFEST_SCRIPT=java-app-deploy.yaml
JAVA_APP_SERVICE_CONFIG=java-app-service.yaml
JAVA_APP_INGRESS_SERVICE_CONFIG=java-app-ingress-route.yaml

declare -a arr=($SECRET_CONFIG
                $CONFIG_MAP_CONFIG
                $POSTGRES_VOLUME
                $POSTGRES_VOLUME_CLAIM
                $POSTGRES_MANIFEST_SCRIPT
                $POSTGRES_SERVICE_CONFIG
                $JAVA_APP_MANIFEST_SCRIPT
                $JAVA_APP_SERVICE_CONFIG
                $JAVA_APP_INGRESS_SERVICE_CONFIG)

check_file_exists() {
    if [ ! -f $1 ]; then
        printf "File not found: %s", $1
        exit 1
    fi   
}

apply_services() {
    for i in "${arr[@]}"
    do 
        check_file_exists $i
        kubectl apply -f $i
    done
}

delete_services() {
    for i in "${arr[@]}"
    do 
        check_file_exists $i
        kubectl delete -f $i 
    done
}

parse_arguments() {
    case "$1" in
        -r | --run )
            apply_services
            ;;
        -d | --delete )
            delete_services
            ;;
    esac
    shift
}

parse_arguments "$@"

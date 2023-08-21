#!/bin/sh
#
# Entrypoint script for Django application in a Docker container
#
# Variables:
#  - SKIP_DJANGO_COLLECT_STATIC
#  - SKIP_DJANGO_MIGRATE
#

echo "Starting application..."

if [ -z "${EXPOSE_PORT}" ]; then
    EXPOSE_PORT="8091"
fi

if [ -f ".version" ]; then
    APP_VERSION=$( cat ".version" )
else
    APP_VERSION="0.0.0"
fi

export APP_VERSION

echo "Variables:"
echo "APP_VERSION='${APP_VERSION}'"
echo "SKIP_DJANGO_COLLECT_STATIC='${SKIP_DJANGO_COLLECT_STATIC}'"
echo "SKIP_DJANGO_MIGRATE='${SKIP_DJANGO_MIGRATE}'"

[ "${SKIP_DJANGO_COLLECT_STATIC}" -eq "1" ] || python manage.py collectstatic --no-input
[ "${SKIP_DJANGO_MIGRATE}" -eq "1" ] || python manage.py migrate

python -m gunicorn milter_framework_admin.wsgi:application

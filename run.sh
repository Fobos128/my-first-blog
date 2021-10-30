#!/bin/sh
APP="$0"
COMMAND=$1
if [ $COMMAND ]; then
	shift
fi
ARGS=$@

COMPOSE="docker-compose"

DJANGO="$COMPOSE exec django"
CALCULATOR="$COMPOSE exec calculator"

MANAGE="$DJANGO python3 manage.py"
CELERY="$DJANGO celery"
FLOWER="$DJANGO flower"

if [ "$COMMAND" = "ps" ]; then
    $COMPOSE ps $ARGS
elif [ "$COMMAND" = "exec" ]; then
    $COMPOSE exec $ARGS
elif [ "$COMMAND" = "build" ]; then
    $COMPOSE build $ARGS
elif [ "$COMMAND" = "start" ]; then
    $COMPOSE up -d $ARGS
elif [ "$COMMAND" = "logs" ]; then
    $COMPOSE logs $ARGS
elif [ "$COMMAND" = "stop" ]; then
    $COMPOSE stop $ARGS
elif [ "$COMMAND" = "dbshell" ]; then
    $COMPOSE exec postgres psql -U postgres
elif [ "$COMMAND" = "req" ]; then
    $COMPOSE exec django pip install -r requirements.txt
elif [ "$COMMAND" = "bash" ]; then
    $DJANGO bash $ARGS
elif [ "$COMMAND" = "celery" ]; then
    $CELERY -A basis worker -l INFO
elif [ "$COMMAND" = "purge" ]; then
    $CELERY -A food_report purge
elif [ "$COMMAND" = "beat" ]; then
    $CELERY -A food_report beat -l info
elif [ "$COMMAND" = "flower" ]; then
    $FLOWER -A food_report --port=5555
elif [ "$COMMAND" = "shell" ]; then
    $MANAGE shell
elif [ "$COMMAND" = "runserver" ]; then
    $MANAGE runserver 0.0.0.0:8000
elif [ "$COMMAND" = "translate" ]; then
    $MANAGE compilemessages 
elif [ "$COMMAND" = "makemessages" ]; then
    $MANAGE makemessages -l en -i venv

# Команды для запуска фронта
elif [ "$COMMAND" = "calcrun" ]; then
    $CALCULATOR npm run dev
elif [ "$COMMAND" = "calcbuild" ]; then
    $CALCULATOR npm run build

else
    $MANAGE $COMMAND $ARGS
fi

exit

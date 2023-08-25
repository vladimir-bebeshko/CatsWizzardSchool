#!/bin/sh
ENVFILE=.env

if [ -f $ENVFILE ]
then
  source $ENVFILE
fi

awk '
BEGIN { 
  map["{{ argument.cats_host }}"] = "'$CATS_RAPIDAPI_HOST'"
  map["{{ argument.cats_endpoint }}"] = "'$CATS_ENDPOINT'"
  map["{{ argument.cats_key }}"] = "'$CATS_RAPIDAPI_KEY'"
  map["{{ argument.validate_email_host }}"] = "'$VALIDATE_EMAIL_HOST'"
  map["{{ argument.validate_email_endpoint }}"] = "'$VALIDATE_EMAIL_ENDPOINT'"
  map["{{ argument.validate_email_key }}"] = "'$VALIDATE_EMAIL_KEY'"
}
{ 
  str=$0
  for (key in map) {
    if (match(str, key)) {
      before = substr(str,1,RSTART-1);
      after = substr(str,RSTART+RLENGTH);
      str=before map[key] after
    }
  }
  print str
}
'

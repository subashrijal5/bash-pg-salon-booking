#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only  -c"

DISPLAY_SERVICES(){
  if [[ $1  ]]
  then
    echo -e "\n$1"
  fi
  echo "Available Services"
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM SERVICES")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
   echo "$SERVICE_ID) $SERVICE_NAME"
  done 
  echo "Select a Service"
  read SERVICE_ID_SELECTED
  SERVICE_NAME_TO_BOOK=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME_TO_BOOK ]]
  then
   DISPLAY_SERVICES "Select service is not available. Please try again."
  else
   echo "Enter your phone number"
   read CUSTOMER_PHONE
    
   CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
   if [[ -z $CUSTOMER_ID ]]
   then 
    echo "Enter your name"
    read CUSTOMER_NAME
    CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
   fi
  echo "Enter the time of the service"
  read SERVICE_TIME

  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')")
  BOOKED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo "I have put you down for a $BOOKED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}
DISPLAY_SERVICES

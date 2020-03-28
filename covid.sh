#!/bin/bash

# Use your particular state number in alphabetical order
# This example uses Alabama (1)
# You can specify an output file as first argument

STATE_NUMBER=1

if [[ -z $1 ]]; then
  OUTPUT_FILE=/dev/null
else
  OUTPUT_FILE="$1"
fi

get_data() {
  echo "$1" | jq -r "$2"
}

print_state() {
  echo "STATE: $state"
  echo "POSITIVE: $state_positive"
  echo "DEATHS: $state_deaths"
}

print_us() {
  echo "COUNTRY: US"
  echo "POSITIVE: $us_positive"
  echo "HOSPITALIZED: $us_hospitalized"
  echo "DEATHS: $us_deaths"
}

print_data() {
  echo
  print_state | column -t
  echo "$state_timestamp"
  echo
  print_us | column -t
  echo "$us_timestamp"
  echo
}

while :; do
  state_data="$(curl -skL 'https://covidtracking.com/api/states')"
  state_data="$(echo "$state_data" | jq ".[$STATE_NUMBER]")"
  state="$(get_data "$state_data" .state)"
  state_positive="$(get_data  "$state_data"  .positive)"
  state_deaths="$(get_data "$state_data" .death)"
  state_timestamp="$(date -d "$(get_data "$state_data" .dateModified)")"

  us_data="$(curl -skL 'https://covidtracking.com/api/us' | jq '.[0]')"
  us_positive="$(get_data "$us_data" .positive)"
  us_deaths="$(get_data "$us_data" .death)"
  us_hospitalized="$(get_data "$us_data" .hospitalized)"
  us_timestamp="$(date -d "$(get_data "$us_data" .lastModified)")"

  clear
  echo -e '<!DOCTYPE html>\n<html>\n<head>\n<meta http-equiv="refresh" content="300" />\n</head>\n<body>\n<pre>' > "$OUTPUT_FILE"
  print_data | tee -a "$OUTPUT_FILE"
  echo -e '</pre>\n</body>\n</html>' >> "$OUTPUT_FILE"
  read -t 3600 -n 3600 && break
done

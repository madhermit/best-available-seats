# Best Available Seats project

## Summary
This script will return the best possible seat in a theatre. The current assumption is the best seat is the middle most, closes to the screen and filling up the first row before moving to the second.

## Testing
Run the test suite with:

    $ ruby test_bas.rb

## Run script
Run the script with:

    $ ./bas.rb -f theatre.json

## Generate a theatre json file
You can use this script to generate a json file of a sample theatre. Currently this option doesnt allow you to specify unavailable seats.

    $ ./bas.rb generate > theatre.json

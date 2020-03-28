# covid.sh

There are much more robust covid-19 trackers out there, but I whipped up this simple one for myself so that I could pull up-to-date stats from a known reliable resource,
[https://covidtracking.com/api/](https://covidtracking.com/api/).

I figured I would share in case anyone was interested for their own use, but I mainly just created this for me and my family.

## Usage

`./covid.sh [output file]`

You can change the state number in the script to reflect the number of your state from the [covidtracking.com API](https://covidtracking.com/api/).

The script runs in an infinite loop, pulling API data every hour.  It can be killed with Ctrl-C.

If you specify an output file, it will write the results to that file in HTML format.  I did this so I could host it at an Nginx document root on my local network.

There is a meta tag in the HTML that will refresh the page every 5 minutes.  You don't have to host the file -- you can just as easily open it in Chrome, and it will work the same way.

## Running in the background

If you only want to monitor the web page without having a terminal window dedicated to process itself, you can just run it in the background:

`(./covid.sh /path/to/file.html &) > /dev/null 2>&1`

And then just open `file.html` in your browser, and monitor from there.

If you run it in the background, you should probably be able to kill it with `pkill covid.sh`.

Otherwise, just use the ol' trusty one-liner:

`ps aux | grep [c]ovid.sh | awk '{print $2}' | xargs kill -9`
 

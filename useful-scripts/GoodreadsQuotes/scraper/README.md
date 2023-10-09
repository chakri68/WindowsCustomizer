# Goodreads Quotes Scraper

Uses beautiful soup to scrape quotes from goodreads and saves them to a json file.

## Pre-requisites

- Needs beautiful soup installed

## Usage

```bash
python main.py
```

You can schedule this script to run every few days using Task Scheduler.

## Using task scheduler to run the script every few days

- Open Task Scheduler
- Click on Create Task
- Give it a name
- Click on Triggers
- Click on New
- Select Daily
- Select the time you want the script to run
- Click on Actions
- Click on New
- Select Start a program
- In the Program/script field, enter the path to the python executable
- In the Add arguments field, enter the path to the main.py file
- Click on OK

You have now scheduled the script to run every day at the specified time!

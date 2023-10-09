import random
import json
from scrape import get_extreme_pages, fetch_quotes, CONFIG

PATH = "C:\\GlobalScripts\\quotes.json"

first_page, last_page = get_extreme_pages()

# Fetch a random page between the first and last page
random_page_quotes = fetch_quotes(
    f"{CONFIG['base_url']}/quotes?page={random.randint(first_page, last_page)}")


# encode unicode characters as ascii
for quote in random_page_quotes:
    quote["text"] = quote["text"].encode("ascii", "ignore").decode()
    quote["author"] = quote["author"].encode("ascii", "ignore").decode()

with open(PATH, "w") as f:
    json.dump(random_page_quotes, f)

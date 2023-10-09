from typing import List, TypedDict
from bs4 import BeautifulSoup, Tag
import requests
from utils import get_numbers

CONFIG = {
    "base_url": "https://www.goodreads.com",
}


class Quote(TypedDict):
    text: str
    author: str


def fetch_quotes(url: str):
    quotes_page_raw_html = requests.get(url)
    quotes_page = BeautifulSoup(quotes_page_raw_html.content, "html.parser")
    quotes: List[Tag] = quotes_page.find_all(class_="quote")

    quote_data: List[Quote] = []

    for quote in quotes:
        try:
            quote_text_element = quote.find(class_="quoteText")
            quote_author = quote.find(
                class_="authorOrTitle").get_text(strip=True)
            quote_text = quote_text_element.contents[0].get_text(strip=True)
            quote_data.append({"text": quote_text, "author": quote_author})
        except Exception as e:
            print(e)
            continue
    return quote_data


def get_extreme_pages():
    quotes_page_raw_html = requests.get(f"{CONFIG['base_url']}/quotes")
    quotes_page = BeautifulSoup(quotes_page_raw_html.content, "html.parser")
    pages_div = quotes_page.find(class_="previous_page").parent
    pages: List[Tag] = pages_div.find_all("a")
    first_page = get_numbers(pages[0].get_attribute_list("href")[
        0].replace("2", "1"))[0]
    last_page = get_numbers(pages[-2].get_attribute_list("href")[0])[0]
    return first_page, last_page

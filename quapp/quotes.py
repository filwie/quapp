#!/usr/bin/env python3
import re

import requests
from bs4 import BeautifulSoup

WIKIQUOTE_RANDOM_URL = 'https://en.wikiquote.org/wiki/Special:Random'
RE_SENTENCE = re.compile(r'(?:[A-Za-z]+[\ .\',\"!:]{0,3}){3,}.*')


def get_random_quote():
    def find_quote(quotes_soup):
        for q in quotes_soup.find_all('li'):
            if RE_SENTENCE.match(q.text) and 30 <= len(q.text) <= 300:
                return q.text.split('\n', 1)[0]
        return 'Changing was necessary. Change was right.' \
               'He was all in favour of change.' \
               'What he was dead against was things not staying the same.', 'Terry Pratchett'
    quotes_html = requests.get(WIKIQUOTE_RANDOM_URL).text
    quotes_soup = BeautifulSoup(quotes_html, 'html.parser')
    author = quotes_soup.title.string.replace(' - Wikiquote', '')
    return find_quote(quotes_soup), author


if __name__ == '__main__':
    print(get_random_quote())

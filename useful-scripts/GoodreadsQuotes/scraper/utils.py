from typing import List
import re


def get_numbers(string: str) -> List[int]:
    pattern = r'\d+\.\d+|\d+'
    numbers = re.findall(pattern, string)
    numbers = [float(number) if '.' in number else int(number)
               for number in numbers]
    return numbers

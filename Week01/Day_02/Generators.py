# Exercise: Build a generator that reads a large CSV/JSON file of scraped store records
# and yields one cleaned record at a time (strip whitespace, normalize phone format)
# instead of loading the whole file into a list.

import csv
import re

def normalize_phone(phone):
    return re.sub('[^0-9]','',phone)

def clean_record(record):
    return {
        "Store_Name":record.get("Store_Name").strip(),
        "Address":record.get("Address").strip(),
        "Phone":normalize_phone(record.get("Phone")),
    }

def read_csv(fname):
    with open(fname, "r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f)

        for record in reader:
            yield clean_record(record)

for store in read_csv(r"C:\Users\aditya.gautam\Downloads\Destini\Destini\Store_List.csv"):
    print(store)

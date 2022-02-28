
from scrapy import Selector
import pandas as pd
import re 
import requests
#response = requests.get("https://situsamc.avature.net/careers/SearchJobs/?jobOffset=1")
response = requests.get("https://cdr.ffiec.gov/public/PWS/DownloadBulkData.aspx")

selector = Selector(response)
# The result below extracts the location of the job posting:
ScrapedLocation = selector.xpath('//*[@id= "DatesDropDownList"]')

ScrapedLocation



ScrapedLocation = selector.xpath('//li[@class = "jobResultItem"]//div[@class = "bMar05"]/text()')
ScrapedTitle = selector.xpath('//li[@class = "jobResultItem"]//a[@class = "jobResultItemTitle"]/text()')
ScrapedDesc = selector.xpath('//li[@class = "jobResultItem"]//div[@class = "jobResultItemDescription"]/text()')
ScrapedLink = selector.xpath('//li[@class = "jobResultItem"]//a/@href')

def extr_list(list_from_selector):
    return([x.extract() for x in list_from_selector])
    
def text_clean_function(to_clean):
    cleaned_text = [re.sub(pattern = "\\n *",repl = "",string = x   ) for x in to_clean]
    return(cleaned_text)

# The purpose of this script is to do the following
# 1. Access the FFIEC bulk call report website.
# 2. Collect all of the dates in the reporting period selector.
# 3. For each date:
#    i). Download the bulk call report
#    ii). Move the call report
#    iii) Unziq the call report

import 

# Access the FFIEC call report website:

website_url = "https://cdr.ffiec.gov/public/PWS/DownloadBulkData.aspx"

# Get the total list of dates:
# The name is: ctl00$MainContentHolder$DatesDropDownList
# The id is: DatesDropDownList
# The class is: valuelabel
# We want to access all values:



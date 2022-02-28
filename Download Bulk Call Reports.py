# -*- coding: utf-8 -*-
"""
Created on Sun Oct 18 10:35:12 2020

@author: USER
"""

# Peter Caya
# Purpose: Download the bulk call reports for all dates available in the FFIEC database. These will be saved in the Download folder and then be transferred to a folder where they will be unzipped in a different script

# [1] Define the download function.
# [2] Collect set of dates, other settings to be used in the function.
# [3] Write log of results including dates, and any errors that were noticed.


# Preamble:
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from time import sleep
import re
# [1] 

def bulk_report_downoader(date,bulk_call_url = "https://cdr.ffiec.gov/public/PWS/DownloadBulkData.aspx",sleep_length = 30):
    try: 
        from selenium import webdriver
        from webdriver_manager.chrome import ChromeDriverManager    
        driver = webdriver.Chrome(ChromeDriverManager().install())
        driver.get("https://cdr.ffiec.gov/public/PWS/DownloadBulkData.aspx")
        
        report_type = driver.find_element_by_id("ListBox1")
        report_type.send_keys("Call Reports -- Single")
        
        date_type = driver.find_element_by_id("DatesDropDownList")
        date_type.send_keys( date )
        
        hold = driver.find_element_by_id("Download_0")
        hold = driver.find_element_by_id("Download_0")
        hold.click()
        sleep(sleep_length)
        driver.close() 
    except Exception:
    		pass
    
def prep_date():
    from selenium import webdriver
    from webdriver_manager.chrome import ChromeDriverManager 
    from selenium.webdriver.support.ui import Select

    driver = webdriver.Chrome(ChromeDriverManager().install())
    driver.get("https://cdr.ffiec.gov/public/PWS/DownloadBulkData.aspx")

    report_type = driver.find_element_by_id("ListBox1")
    report_type.send_keys("Call Reports -- Single")
       
    date_type = driver.find_element_by_id("DatesDropDownList")
    selector = Select(date_type)
    options = selector.options
    return_dates = [x.text for x in options]
    
    driver.close() 
    return(return_dates)
    
# Example test: Works.    
#bulk_report_downoader(date = "06/30/2016",sleep_length=15)
    
# [2] 
dates_to_use = prep_date()

# [3] 
[bulk_report_downoader( date = x, sleep_length =30) for x in dates_to_use]
    
# bulk_report_downoader( date = dates_to_use[1], sleep_length =15)   
 
 
 
  
 
 
 
 
 
 
 
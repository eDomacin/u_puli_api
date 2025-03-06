


3. scraper package 
- which would have data source to get scraped data 
- and datasource to databasedatasource 
- and domain with models and such 
- and repositories for both of those 
-- make just one repo for all events scrapers
- and use cases for each source 
- and have presentation 
-- i guess we will have a controller in there
--- it would have handle scrape data 
--- it would call all use cases for scraping 
--- it would then call use cases for saving data
-- it would need to accept database 
- and then we would have EventsScraper class 
- this class would initialize
-- env variables 
-- database	
-- repositories
-- use cases
-- data sources
- and it would then intiialize controller
- and call controllers handle scrape events method 
-- inside the class we would do all of this 
-- once the work is done, or error is thrown, dabase needs to be closed 
- its method will be called run
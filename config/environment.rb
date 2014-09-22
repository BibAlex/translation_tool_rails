# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
EolTranslationToolRails::Application.initialize!

DEFAULT_HIERARCHY_ID = 3
ITEMS_PER_PAGE = 1
VETTED_UNKNOWN = 1
VETTED_TRUSTED = 4
VETTED_UNTRUSTED =2 
EOL_SITE_URL = 'localhost'
VISIBILITY_INVISIBLE =  '0'
LANGUAGE_EN = '1'
DATA_TYPES_TEXT = '3'
TOC_INCLUDED_PARENT_IDS = '1, 3, 4, 5, 6, 8, 256, 303, 315, 326, 346'
DATA_TYPES_MEDIA = '2, 4, 7, 8'
MASTER = 'eol_data'
SLAVE = 'aeol'

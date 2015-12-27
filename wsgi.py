import sys
import logging

logging.basicConfig(stream=sys.stderr, level=logging.INFO)
sys.path.insert(0, '/opt/filexchange')

from fs import app as application

import json
import os

with open('/tmp/.env', 'w') as f:
    with os.popen('/opt/elasticbeanstalk/bin/get-config environment') as p:
        for line in p:
            d = json.loads(line)
            for k in d:
                f.write('%s=%s\n' % (k, d[k]))

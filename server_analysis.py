import json
from mrcc import CCJob
from urllib.parse import urlparse


class ServerAnalysis(CCJob):
    def parse_url(self, url):
        data = urlparse(url)
        return data.netloc

    def process_record(self, record):
        # We're only interested in the JSON responses
        if record['Content-Type'] != 'application/json':
            return

        payload = record.payload.read()
        data = json.loads(payload)

        try:
            metas = data['Envelope']['Payload-Metadata']['HTTP-Response-Metadata']['HTML-Metadata']['Head']['Metas']

            for meta in metas:
                if meta['name'] == 'METADATA-NAME':
                    yield self.parse_url(record.url), 1
                    self.increment_counter('commoncrawl', 'pages_found', 1)
        except KeyError:
            pass

        self.increment_counter('commoncrawl', 'processed_pages', 1)


if __name__ == '__main__':
    ServerAnalysis.run()

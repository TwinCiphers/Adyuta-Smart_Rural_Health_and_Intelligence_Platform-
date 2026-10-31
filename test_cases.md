Table 7.1:-Testcase1

| Test case          | Unit Testing                   |
|--------------------|--------------------------------|
| Name of the Test:  | Parse Real Answer Test         |
| Item being tested: | AdyutaClient outcome parser    |
| Sample input:      | Valid JSON answer with status  |
| Expected output:   | Parsed as Answered outcome     |
| Actual output:     | Parsed as Answered outcome     |
| Remarks:           | Pass                           |

Table 7.2:-Testcase2

| Test case          | Unit Testing                   |
|--------------------|--------------------------------|
| Name of the Test:  | Map Online Metadata            |
| Item being tested: | API JSON to MessageMeta        |
| Sample input:      | JSON with scores and sources   |
| Expected output:   | Metadata fields populated      |
| Actual output:     | Metadata fields populated      |
| Remarks:           | Pass                           |

Table 7.3:-Testcase3

| Test case          | Functionality Testing          |
|--------------------|--------------------------------|
| Name of the Test:  | Render Placeholder Notice      |
| Item being tested: | MessageBubble Widget           |
| Sample input:      | ChatMessage with placeholder   |
| Expected output:   | Render no model connected      |
| Actual output:     | Renders no model connected     |
| Remarks:           | Pass                           |

Table 7.4:-Testcase4

| Test case          | Functionality Testing          |
|--------------------|--------------------------------|
| Name of the Test:  | OpenAQ API Auth Handling       |
| Item being tested: | scratch_test.py fetch()        |
| Sample input:      | fetch('api.openaq.org/...')    |
| Expected output:   | Returns HTTP 401 Unauthorized  |
| Actual output:     | Returns HTTP 401 Unauthorized  |
| Remarks:           | Pass                           |

Table 7.5:-Testcase5

| Test case          | Integration Testing            |
|--------------------|--------------------------------|
| Name of the Test:  | USGS Earthquake API Fetch      |
| Item being tested: | scratch_test.py data pipeline  |
| Sample input:      | GET usgs.gov/earthquakes feed  |
| Expected output:   | Retrieves 36 features in JSON  |
| Actual output:     | Retrieves 36 features in JSON  |
| Remarks:           | Pass                           |

Table 7.6:-Testcase6

| Test case          | Integration Testing            |
|--------------------|--------------------------------|
| Name of the Test:  | Gov Data API Fetch             |
| Item being tested: | scratch_test.py data pipeline  |
| Sample input:      | GET api.data.gov.in resource   |
| Expected output:   | Error WinError 10061 Refused   |
| Actual output:     | Error WinError 10061 Refused   |
| Remarks:           | Pass                           |

Table 7.7:-Testcase7

| Test case          | Usability Testing              |
|--------------------|--------------------------------|
| Name of the Test:  | Prevent Thin Grounding Repeat  |
| Item being tested: | MessageBubble Widget           |
| Sample input:      | Answer with note already in it |
| Expected output:   | Note is not printed twice      |
| Actual output:     | Note is not printed twice      |
| Remarks:           | Pass                           |

Table 7.8:-Testcase8

| Test case          | Usability Testing              |
|--------------------|--------------------------------|
| Name of the Test:  | Flag Foreign Advisory          |
| Item being tested: | MessageBubble Widget           |
| Sample input:      | Advisory in en, asked in ta    |
| Expected output:   | Advisory language is flagged   |
| Actual output:     | Advisory language is flagged   |
| Remarks:           | Pass                           |

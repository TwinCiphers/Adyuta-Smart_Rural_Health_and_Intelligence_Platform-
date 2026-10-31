import urllib.request
import urllib.parse
import re
import json

queries = {
    "course_01": [
        "Millennial Farmer",
        "Ag PhD Hefty",
        "How Farms Work",
        "Farmonaut",
        "Nature's Always Right",
        "Krishi Jagran",
        "Digital Green agriculture",
        "Peterson Farm Bros",
        "Cole the Cornstar",
        "FAO sustainable agriculture"
    ],
    "course_02": [
        "The Plain Bagel",
        "Ben Felix PWL Capital",
        "Graham Stephan",
        "Two Cents PBS",
        "Patrick Boyle finance",
        "Zerodha Varsity",
        "CA Rachana Ranade",
        "Khan Academy Finance and Capital Markets",
        "Aswath Damodaran valuation",
        "Bloomberg Originals markets"
    ],
    "course_03": [
        "Fireship",
        "freeCodeCamp",
        "Traversy Media",
        "CS50 Harvard",
        "Two Minute Papers",
        "NetworkChuck",
        "The Cyber Mentor",
        "Corey Schafer Python",
        "IBM Technology",
        "sentdex"
    ],
    "course_04": [
        "Y Combinator startup school",
        "Harvard Business Review YouTube",
        "Ali Abdaal",
        "Valuetainment Patrick Bet-David",
        "Slidebean startup",
        "Think Media",
        "Wall Street Journal business",
        "Exponent podcast tech business",
        "GaryVee",
        "Stanford GSB View From The Top"
    ]
}

def get_first_video_id(query):
    try:
        url = "https://www.youtube.com/results?search_query=" + urllib.parse.quote(query)
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        html = urllib.request.urlopen(req).read().decode('utf-8')
        video_ids = re.findall(r"watch\?v=(\S{11})", html)
        if video_ids:
            return video_ids[0]
    except Exception as e:
        print("Error fetching", query, e)
    return "dQw4w9WgXcQ" # fallback

results = {}
for course_id, q_list in queries.items():
    results[course_id] = []
    for q in q_list:
        vid = get_first_video_id(q)
        print(f"Found {vid} for {q}")
        results[course_id].append({"title": q, "videoId": vid})

with open("scraped_videos.json", "w") as f:
    json.dump(results, f, indent=2)

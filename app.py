import os
import json
from flask import Flask, request, jsonify
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app)

DATA_FILE = 'days_data.json'
WEATHER_API_KEY = '你的和风天气API Key'  # 请替换为你自己的API Key
WEATHER_API_URL = 'https://devapi.qweather.com/v7/weather/now'

# 读取本地数据
def load_data():
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r', encoding='utf-8') as f:
            return json.load(f)
    return {}

# 保存数据到本地
def save_data(data):
    with open(DATA_FILE, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

days_data = load_data()

@app.route('/days', methods=['GET'])
def get_all_days():
    return jsonify(list(days_data.values()))

@app.route('/days/<date>', methods=['GET'])
def get_day(date):
    return jsonify(days_data.get(date, {}))

@app.route('/days', methods=['POST'])
def add_or_update_day():
    data = request.json
    date = data.get('date')
    if not date:
        return jsonify({"error": "date is required"}), 400

    # 自动获取天气（如果前端没传weather字段）
    if not data.get('weather') and data.get('location'):
        weather = fetch_weather(data['location'])
        if weather:
            data['weather'] = weather

    days_data[date] = data
    save_data(days_data)
    return jsonify(data), 201

@app.route('/days/<date>', methods=['DELETE'])
def delete_day(date):
    if date in days_data:
        del days_data[date]
        save_data(days_data)
        return '', 204
    return jsonify({"error": "not found"}), 404

# 天气API集成（以和风天气为例，需注册获取API Key）
def fetch_weather(location):
    # 这里location建议传城市名或经纬度，具体看API文档
    params = {
        'location': location,
        'key': WEATHER_API_KEY
    }
    try:
        resp = requests.get(WEATHER_API_URL, params=params, timeout=5)
        if resp.status_code == 200:
            data = resp.json()
            if 'now' in data:
                now = data['now']
                return f"{now['text']} {now['temp']}°C"
    except Exception as e:
        print("天气API请求失败：", e)
    return None

if __name__ == '__main__':
    app.run(debug=True) 
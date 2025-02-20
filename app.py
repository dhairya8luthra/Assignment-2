from flask import Flask, request, jsonify, send_from_directory
import pandas as pd
import numpy as np
import os

app = Flask(__name__, static_folder='static')

def moving_average_forecast(df, window=3):
    df["Moving Average"] = df["Original MADT"].rolling(window=window).mean()
    forecast = df["Moving Average"].iloc[-1] if not df["Moving Average"].isna().all() else None
    return forecast

def exponential_smoothing_forecast(df, alpha=0.2):
    df["Exponential Smoothing"] = df["Original MADT"].ewm(alpha=alpha, adjust=False).mean()
    forecast = df["Exponential Smoothing"].iloc[-1]
    return forecast

@app.route('/')
def index():
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/forecast', methods=['POST'])
def forecast():
    try:
        json_data = request.get_json()
        custom_data = json_data.get("data", [])
        window = int(json_data.get("window", 3))
        alpha = float(json_data.get("alpha", 0.2))
        
        df_custom = pd.DataFrame(custom_data)
        moving_avg_forecast = moving_average_forecast(df_custom, window)
        exp_smooth_forecast = exponential_smoothing_forecast(df_custom, alpha)
        
        return jsonify({
            "moving_avg_forecast": float(moving_avg_forecast) if moving_avg_forecast is not None else None,
            "exp_smooth_forecast": float(exp_smooth_forecast) if exp_smooth_forecast is not None else None
        })
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == '__main__':
    app.run(debug=True)
# Load necessary libraries
library(forecast)
library(ggplot2)

# Define the dataset
years <- c(1999:2010)
vehicle_data <- data.frame(
  Year = years,
  `2W` = c(506164, 540583, 579505, 620070, 669676, 723250, 766645, 816477, 865466, 921409, 967479, 1018399),
  `4W` = c(321825, 340626, 360819, 386132, 411445, 443551, 487438, 535824, 578141, 557070, 598710, 642138),
  `Tempo_LCV` = c(11541, 12368, 13137, 13935, 14685, 15600, 17046, 18553, 19790, 34790, 36015, 37933),
  `Bus_Truck` = c(20604, 21616, 22619, 23602, 24772, 26160, 28365, 30898, 32495, 56385, 57741, 60929),
  `Autos` = c(56664, 61197, 66705, 72041, 78885, 86379, 94153, 101693, 108812, 104712, 107853, 115351)
)

# Function to train ARIMA and forecast
forecast_vehicle <- function(data, col_name) {
  ts_data <- ts(data[[col_name]], start = 1999, frequency = 1)  # Time series object
  
  # Fit ARIMA(1,1,1) model
  model <- tryCatch({
    auto.arima(ts_data, order = c(1,1,1))  # ARIMA(1,1,1) Model
  }, error = function(e) {
    print(paste("Error in ARIMA model for", col_name, ":", e$message))
    return(NULL)
  })
  
  # Ensure model was created successfully
  if (!is.null(model)) {
    forecasted_values <- forecast(model, h = 5)  # Forecast for 5 years
    
    # Plot forecast
    plot(forecasted_values, main = paste("Forecast for", col_name), ylab = "Number of Vehicles", xlab = "Year")
    
    # Print forecasted values
    print(forecasted_values)
    
    return(forecasted_values)
  } else {
    return(NULL)
  }
}

# Forecast for each category
forecast_2W <- forecast_vehicle(vehicle_data, "2W")
forecast_4W <- forecast_vehicle(vehicle_data, "4W")
forecast_Tempo_LCV <- forecast_vehicle(vehicle_data, "Tempo_LCV")
forecast_Bus_Truck <- forecast_vehicle(vehicle_data, "Bus_Truck")
forecast_Autos <- forecast_vehicle(vehicle_data, "Autos")


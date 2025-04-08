import pandas as pd
import numpy as np
from sklearn.preprocessing import MinMaxScaler

# Load raw dataset
df = pd.read_csv("Project1.csv")

# === Data Cleaning === #

# Frequency Mapping
freqMap = {
    "Weekly": 52,
    "Fortnightly": 26,
    "Monthly": 13,
    "Annually": 1,
    "Yearly": 1,
    " ": 0
}
df['Frequency of Purchases'] = df['Frequency of Purchases'].map(freqMap).fillna(0).astype(int)

# Handle missing values
df['Review Rating'] = df['Review Rating'].fillna(df['Review Rating'].mode()[0])
df['Previous Purchases'] = df['Previous Purchases'].fillna(0)
df['Purchase Amount (USD)'] = df['Purchase Amount (USD)'].fillna(
    df.groupby('Item Purchased')['Purchase Amount (USD)'].transform('mean')
)
df['Purchase Amount (USD)'] = df['Purchase Amount (USD)'].astype(int)

# Drop unneeded columns (like 'Customer ID')
df.drop('Customer ID', axis=1, inplace=True)

# === Feature Engineering: Spender Score === #

def CalculateSpendingScore(df):
    SpendingScoredf = df.copy()
    scaler = MinMaxScaler()

    # Normalize Purchase Amount
    SpendingScoredf['Normalized_Purchase_Amount'] = scaler.fit_transform(SpendingScoredf[['Purchase Amount (USD)']]) 
    
    # Assign weights for Spender Score
    w1, w2, w3, w5 = 40, 25, 15, 30
    
    # Convert Subscription Status to numerical (1 = Subscribed, 0 = Not Subscribed)
    SpendingScoredf['Subscription_Status_Num'] = SpendingScoredf['Subscription Status'].apply(
        lambda x: 1 if str(x).lower() == 'subscribed' else 0
    )
    
    # Normalize Frequency of Purchases
    SpendingScoredf['Normalized_Frequency'] = scaler.fit_transform(SpendingScoredf[['Frequency of Purchases']])
    
    # Normalize Previous Purchases
    SpendingScoredf['Normalized_Previous_Purchases'] = scaler.fit_transform(SpendingScoredf[['Previous Purchases']])
    
    # Calculate Spending Score as a weighted sum
    SpendingScoredf['Spending_Score'] = (
        w1 * SpendingScoredf['Normalized_Purchase_Amount'] +
        w2 * SpendingScoredf['Normalized_Frequency'] +
        w3 * SpendingScoredf['Subscription_Status_Num'] +
        w5 * SpendingScoredf['Normalized_Previous_Purchases']
    )
    
    # Normalize Spending Score to 0-100
    SpendingScoredf['Spending_Score'] = scaler.fit_transform(SpendingScoredf[['Spending_Score']]) * 100
    
    return SpendingScoredf['Spending_Score']

# Create Spender Score column
df['SpenderScore'] = CalculateSpendingScore(df)





# OPTIONAL: Save cleaned file
df.to_csv('cleaned_data.csv', index=False)

print("Data cleaning and feature engineering are complete. Cleaned data saved as 'cleaned_data.csv'.")
